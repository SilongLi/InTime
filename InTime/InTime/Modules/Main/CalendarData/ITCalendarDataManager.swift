//
//  ITCalendarDataManager.swift
//  InTime
//
//  Created by lisilong on 2019/9/8.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ITCalendarDataManager: NSObject {

    let store: EKEventStore = EKEventStore()
    
    let calendarName = "InTime"
    
    override init() {
        super.init()
    }
    
    
    public func checkCalendarAuthorization(completion: @escaping (_ success: Bool) -> ()) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .notDetermined, .denied:
            store.requestAccess(to: EKEntityType.event) { (granted, error) in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                    print(error.debugDescription)
                }
            }
            break
        case .restricted:
            completion(false)
            break
        case .authorized:
            completion(true)
            break
        }
    }
    
    public func loadEventFromCalendWithStartDate(date: Date, endDate: Date) -> [EKEvent] {
        let calendarArray = self.store.calendars(for: EKEntityType.event)
        var calendars: Array = Array<EKCalendar>()
        for calendar in calendarArray {
            if calendar.type == .local || calendar.type == .calDAV {
                calendars.append(calendar)
            }
        }
        let predicate = self.store.predicateForEvents(withStart: date, end: endDate, calendars: calendars)
        let requests: NSArray = self.store.events(matching: predicate) as NSArray
        var events: [EKEvent] = [EKEvent]()
        for request in requests {
            if request is EKEvent {
                events.append(request as! EKEvent)
            }
        }
        return events
    }
    
    public func addEventInfoCalender(title: String, startDate: Date, endDate: Date) {
        let event = EKEvent.init(eventStore: self.store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = false;
        
        event.calendar = self.findCalender(calendarName)
        if event.calendar == nil {
            event.calendar = self.createCalender(calendarName)
        }
        
        do {
            try self.store.save(event, span: EKSpan.thisEvent, commit: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func findCalender(_ name: String) -> EKCalendar? {
        let calendarArray = self.store.calendars(for: EKEntityType.event)
        for calendar in calendarArray {
            if calendar.title == name {
                return calendar
            }
        }
        return nil
    }
    
    func createCalender(_ name: String) -> EKCalendar {
        var calendar: EKCalendar? = self.findCalender(name)
        if calendar == nil {
            calendar = EKCalendar.init(for: EKEntityType.event, eventStore: self.store)
            calendar?.title = name
            calendar?.source = self.findCalendarSource(self.store)
            try? self.store.saveCalendar(calendar!, commit: true)
        }
        return calendar!
    }
    
    func findCalendarSource(_ eventStore: EKEventStore) -> EKSource? {
        for source in eventStore.sources {
            if source.sourceType == EKSourceType.calDAV, source.title == "iCloud" {
                return source
            }
        }
        for source in eventStore.sources {
            if source.sourceType == EKSourceType.local {
                return source
            }
        }
        return nil;
    }
}

