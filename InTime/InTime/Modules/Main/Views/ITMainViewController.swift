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
    
    lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    lazy var showDetailButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "line"), for: .normal)
        btn.addTarget(self, action: #selector(showDetailButtonAction), for: UIControl.Event.touchUpInside)
        btn.alpha = 0.5
        return btn
    }()
    
    lazy var showSeasonButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "seasonView"), for: .normal)
        btn.addTarget(self, action: #selector(showSeasonViewButtonAction), for: UIControl.Event.touchUpInside)
        btn.alpha = 0.8
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ITMainCalendarInfoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITMainCalendarInfoTableViewCell.self))
        tableView.register(ITMainSeasonTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITMainSeasonTableViewCell.self))
        return tableView
    }()
    
    let calendarDataManager: ITCalendarDataManager = ITCalendarDataManager()
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var animationFinished = true
    private var granted: Bool = false
    private var currentSelectedDate: Date = Date()
    private var events: [EKEvent]?
    private var seasons: [SeasonModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        
        view.addSubview(tableView)
        headerView.addSubview(dateInfoView)
        headerView.addSubview(calendarView)
        headerView.addSubview(showDetailButton)
        headerView.addSubview(showSeasonButton)
        tableView.tableHeaderView = headerView
        
        loadSeasons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSeasons()
        
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
        let btnHeight: CGFloat = 20.0
        
        headerView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: infoHeight + calendarView.heightForView() + btnHeight)
        dateInfoView.frame = CGRect.init(x: margin, y: 0.0, width: width, height: infoHeight)
        calendarView.frame = CGRect.init(x: 0.0, y: dateInfoView.frame.maxY, width: self.view.frame.width, height: calendarView.heightForView())
        showDetailButton.frame = CGRect.init(x: 0.0, y: calendarView.frame.maxY, width: self.view.frame.width, height: btnHeight)
        
        let showSeasonButtonWH: CGFloat = 30.0
        let y: CGFloat = 30.0
        showSeasonButton.frame = CGRect.init(x: headerView.frame.size.width - showSeasonButtonWH - 10.0, y: y, width: showSeasonButtonWH, height: showSeasonButtonWH)
         
        tableView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.size.height)
    }
    
    // MARK: - Private Methods
    
    private func reloadEventsInfo(_ date: Date?) {
        guard granted, let date = date else { return }
        
        let startDate = (date as NSDate).atStartOfDay() ?? date
        let endDate = (date as NSDate).atEndOfDay() ?? date
        events = calendarDataManager.loadEventFromCalendWithStartDate(date: startDate, endDate: endDate)
        
        tableView.reloadData()
    }
    
    func loadSeasons() {
        HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
            self?.seasons = seasons
            self?.tableView.reloadData()
        }
    }
    
    @objc private func showDetailButtonAction() {
        let isWeek = calendarView.calendarMode == .weekView
        calendarView.calendarMode = isWeek ? .monthView : .weekView
        
        view.setNeedsLayout()
        tableView.reloadData()
    }
    
    private func showSystemCalendarAPP() {
        let timeSince = NSDate.timeIntervalSinceReferenceDate
        let todayToFutureDate = currentSelectedDate.timeIntervalSince(Date())
        let finalInterval = todayToFutureDate + timeSince
        if let url = URL.init(string: "calshow:\(finalInterval)") {
            UIApplication.shared.openURL(url)
        } else {
            print("无法打开系统日历！")
        }
    }
     
    @objc private func showSeasonViewButtonAction() {
        let seasonVC = HomeViewController()
        navigationController?.pushViewController(seasonVC, animated: true)
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


extension ITMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell: ITMainCalendarInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainCalendarInfoTableViewCell.self), for: indexPath) as! ITMainCalendarInfoTableViewCell
            cell.updateContent(events)
            return cell
        }
        
        let cell: ITMainSeasonTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainSeasonTableViewCell.self), for: indexPath) as! ITMainSeasonTableViewCell
        cell.updateContent(seasons)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ITMainCalendarInfoTableViewCell.heightForCell(events)
        }
        return ITMainSeasonTableViewCell.heightForCell(seasons)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10.0
        case 1:
            return 20.0
        default:
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showSystemCalendarAPP()
            break
        case 1:
            showSeasonViewButtonAction()
            break
        default:
            break
        }
    }
}

