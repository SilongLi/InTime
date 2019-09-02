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
    
    var menuView: CVCalendarMenuView = {
        let menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 40))
        return menuView
    }()
    
    var calendarView: CVCalendarView = {
        let calendarView = CVCalendarView(frame: CGRect(x: 0, y: 140, width: UIScreen.main.bounds.size.width, height: 300))
        return calendarView
    }()
    
    private var currentCalendar: Calendar = {
        let timeZoneBias = 480 // (UTC+08:00)
        var currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar.timeZone = timeZone
        }
        return currentCalendar
    }()
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var animationFinished = true
    private var selectedDay: DayView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.menuView)
        self.view.addSubview(self.calendarView)
        
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if calendarView.calendarMode == .weekView {
            calendarView.changeMode(.monthView)
            calendarView.frame = CGRect(x: 0, y: 140, width: UIScreen.main.bounds.size.width, height: 300)
        } else {
            calendarView.changeMode(.weekView)
            calendarView.frame = CGRect(x: 0, y: 140, width: UIScreen.main.bounds.size.width, height: 50)
        }
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

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension ITMainViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return UIColor.white
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    // Defaults to true
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
    }
    
    func shouldSelectRange() -> Bool {
        return false
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        print(date.year, date.month, date.week, date.day)
//        if monthLabel.text != date.globalDescription && self.animationFinished {
//            let updatedMonthLabel = UILabel()
//            updatedMonthLabel.textColor = monthLabel.textColor
//            updatedMonthLabel.font = monthLabel.font
//            updatedMonthLabel.textAlignment = .center
//            updatedMonthLabel.text = date.globalDescription
//            updatedMonthLabel.sizeToFit()
//            updatedMonthLabel.alpha = 0
//            updatedMonthLabel.center = self.monthLabel.center
//
//            let offset = CGFloat(48)
//            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
//            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
//
//            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
//                self.animationFinished = false
////                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
////                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
////                self.monthLabel.alpha = 0
//
//                updatedMonthLabel.alpha = 1
//                updatedMonthLabel.transform = CGAffineTransform.identity
//
//            }) { _ in
//
//                self.animationFinished = true
////                self.monthLabel.frame = updatedMonthLabel.frame
////                self.monthLabel.text = updatedMonthLabel.text
////                self.monthLabel.transform = CGAffineTransform.identity
////                self.monthLabel.alpha = 1
//                updatedMonthLabel.removeFromSuperview()
//            }
//
//            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
//        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = ColorsConfig.selectionBackground
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func dayOfWeekTextColor() -> UIColor { return .white }
    
    func dayOfWeekBackGroundColor() -> UIColor { return .orange }
    
    func disableScrollingBeforeDate() -> Date { return Date.init(timeIntervalSince1970: 0) }
    
    func maxSelectableRange() -> Int { return 1 }
    
    func earliestSelectableDate() -> Date { return Date.init(timeIntervalSince1970: 0) }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 36500
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        }
        return Date()
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension ITMainViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return .lightGray
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _):
            return ColorsConfig.selectedText
        case (.sunday, .in, _):
            return ColorsConfig.sundayText
        case (.sunday, _, _):
            return ColorsConfig.sundayTextDisabled
        case (_, .in, _):
            return ColorsConfig.text
        default:
            return ColorsConfig.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _):
            return ColorsConfig.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _):
            return ColorsConfig.selectionBackground
        default:
            return nil
        }
    }
    
    func topMarkerColor() -> UIColor {
        return UIColor.spaceLineColor
    }
}



// MARK: - Convenience API Demo

extension ITMainViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        var components = Manager.componentsForDate(Date(), calendar: currentCalendar) // from today
        
        components.month! += offset
        
        let resultDate = currentCalendar.date(from: components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    
    func didShowNextMonthView(_ date: Date) {
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
    
    func didShowPreviousMonthView(_ date: Date) {
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
}
