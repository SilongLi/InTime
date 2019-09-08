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
    
    lazy var calendarView: ITCalendarView = {
        let calendarView = ITCalendarView.init({ [weak self] (date) in
            self?.currentSelectedDate = date.date
            self?.dateInfoView.updateContent(date)
            self?.reloadEventsInfo(date.date)
        })
        return calendarView
    }()
    
    lazy var dateInfoView: ITDateInfoView = {
        let infoView = ITDateInfoView()
        return infoView
    }()
    
    let calendarDataManager: ITCalendarDataManager = ITCalendarDataManager()
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var animationFinished = true
    private var granted: Bool = false
    private var currentSelectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(dateInfoView)
        self.view.addSubview(calendarView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarDataManager.checkCalendarAuthorization { [weak self] (granted) in
            DispatchQueue.main.async {
                self?.granted = granted
                self?.reloadEventsInfo(self?.currentSelectedDate)
            }
        }
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
        
        
    }
    
    // MARK: - Private Methods
    
    private func reloadEventsInfo(_ date: Date?) {
        guard granted, let date = date else { return }
        
        let startDate = (date as NSDate).atStartOfDay() ?? date
        let endDate = (date as NSDate).atEndOfDay() ?? date
        let events: [EKEvent] = calendarDataManager.loadEventFromCalendWithStartDate(date: startDate, endDate: endDate)
        for event: EKEvent in events {
            print(event.title ?? "", event.startDate ?? Date(), event.endDate ?? Date())
        }
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


