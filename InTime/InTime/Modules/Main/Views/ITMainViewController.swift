//
//  ITMainViewController.swift
//  InTime
//
//  Created by lisilong on 2019/7/16.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ITMainViewController: BaseViewController {
    
    let store: EKEventStore = EKEventStore()
    
    let calendarName = "InTime"
    
    lazy var calendarView: ITCalendarView = {
        let calendarView = ITCalendarView.init({ [weak self] (date) in
            self?.dateInfoView.updateContent(date)
        })
        return calendarView
    }()
    
    lazy var dateInfoView: ITDateInfoView = {
        let infoView = ITDateInfoView()
        return infoView
    }()
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var animationFinished = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(dateInfoView)
        self.view.addSubview(calendarView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let margin: CGFloat = 15.0
        let width: CGFloat = self.view.frame.width - margin * 2.0
        let infoHeight: CGFloat = 80.0
        dateInfoView.frame = CGRect.init(x: margin, y: IT_StatusHeight, width: width, height: infoHeight)
        
        calendarView.frame = CGRect.init(x: 0.0, y: dateInfoView.frame.maxY, width: self.view.frame.width, height: calendarView.heightForView())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        calendarView.calendarMode = calendarView.calendarMode == .weekView ? .monthView : .weekView
        view.setNeedsLayout()
        
//        checkCalendarAuthorization { [weak self] (granted) in
//            DispatchQueue.main.async {
//                if (granted) {
//                    let startDate = Date.init(timeIntervalSinceNow: 0)
//                    let endDate = Date.init(timeIntervalSinceNow: 110000)
//
//                    self?.loadEventFromCalendWithStartDate(date: startDate, endDate: endDate)
//
//                    self?.addEventInfoCalender()
//
//                    self?.loadEventFromCalendWithStartDate(date: startDate, endDate: endDate)
//                }
//            }
//        }
    }
    
    func checkCalendarAuthorization(completion: @escaping (_ success: Bool) -> ()) {
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
    
    func loadEventFromCalendWithStartDate(date: Date, endDate: Date) {
        let calendarArray = self.store.calendars(for: EKEntityType.event)
        var calendars: Array = Array<EKCalendar>()
        for calendar in calendarArray {
            if calendar.type == .local || calendar.type == .calDAV {
                calendars.append(calendar)
            }
        }
        let predicate = self.store.predicateForEvents(withStart: date, end: endDate, calendars: calendars)
        let requests: NSArray = self.store.events(matching: predicate) as NSArray
        for request in requests {
            if request is EKEvent {
                let event: EKEvent = (request as! EKEvent)
                print(event.title ?? "", event.startDate ?? Date(), event.endDate ?? Date())
            }
        }
    }
    
    func addEventInfoCalender() {
        let event = EKEvent.init(eventStore: self.store)
        event.title = "起床吃早餐了"
        event.startDate = Date.init(timeIntervalSinceNow: 10000)
        event.endDate = Date.init(timeIntervalSinceNow: 11000)
        event.isAllDay = false;
        
        event.calendar = self.findCalender(calendarName)
        if event.calendar == nil {
          event.calendar = self.createCalender(calendarName)
        }
        
        try? self.store.save(event, span: EKSpan.thisEvent, commit: true)
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
    
    /*
    //新增日历事件
    - (void)addCalendarStartDate:(NSString *)startDate addEndDate:(NSString *)endDate alarms:(NSArray *)alarmArray title:(NSString *)title
    {
    EKEvent *event = [EKEvent eventWithEventStore:[self sharedEKEventStore]];
    event.title = title;
    event.startDate = [NSDate dateWithString:startDate formatString:@"YYYY-MM-dd HH:mm:ss"];
    event.endDate = [NSDate dateWithString:endDate formatString:@"YYYY-MM-dd HH:mm:ss"];
    // 是否设置全天
    event.allDay = NO;
    //添加提醒
    if (alarmArray && alarmArray.count > 0){
    for (NSNumber *timeValue in alarmArray) {
    //如果需要设置提前提醒，需要设置一个负数时间值，单位秒s,根据实际需求转换单位
    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-1*[timeValue integerValue]*60]];
    }
    }
    //获取日历类型
    EKCalendar *calendar = [self findEKCalendar:@"根据实际需求新建一个名称即可" eventStore:[self sharedEKEventStore]];
    [event setCalendar:calendar];
    
    // 保存日历
    NSError *errSave;
    //EKSpanThisEvent 表示单次日历事件 如果需要保存重复事件需要使用EKSpanFutureEvents
    //commit 表示当前修改是否要立即提交，因为频繁操作数据库，建议先保存需要添加的事件，最后一把全部提交
    [[self sharedEKEventStore] saveEvent:event span:EKSpanThisEvent commit:NO error:&errSave];
    if (errSave) {
    DLog(@"保存失败，%@",errSave);
    }else{
    DLog(@"保存成功");
    }
    }
 
 */
}


