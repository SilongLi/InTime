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
    
    let footerMargin: CGFloat = 50.0
    
    lazy var headerView: ITMainHeaderInfoView = {
        let view = ITMainHeaderInfoView()
        view.didSelectedDateBlock = { [weak self] (date) in
            self?.currentSelectedDate = date.date
            self?.reloadEventsInfo(date.date)
        }
        view.showSeasonViewBlock = { [weak self] in
            self?.showSeasonView()
        }
        view.showDetailCalendarViewBlock = { [weak self] in
            self?.view.setNeedsLayout()
            self?.tableView.reloadData()
        }
        return view
    }()
     
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tintColor
        tableView.register(ITMainContainterTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITMainContainterTableViewCell.self))
        return tableView
    }()
    
    let calendarDataManager: ITCalendarDataManager = ITCalendarDataManager()
    
    private var animationFinished = true
    private var granted: Bool = false
    private var currentSelectedDate: Date = Date()
    private var events: [EKEvent]?
    private var seasons: [SeasonModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        view.backgroundColor = UIColor.tintColor
        
        view.addSubview(tableView)
        
        loadSeasons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSeasons()
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
        
        tableView.frame = CGRect.init(x: 0.0, y: IT_StatusHeight, width: self.view.frame.width, height: self.view.frame.size.height)
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
        if let categoryId = UserDefaults.standard.string(forKey: CurrentSelectedCategoryIDKey) {
            HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryId) { [weak self] (seasons) in
                 self?.seasons = seasons
                 self?.tableView.reloadData()
            }
        } else {
            HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
                self?.seasons = seasons
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
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
     
    private func showSeasonView() {
        let seasonVC = HomeViewController()
        navigationController?.pushViewController(seasonVC, animated: true)
    }
    
    private func showAddNewSeasonView() {
        let addNewSeasonVC = AddNewSeasonViewController()
        navigationController?.pushViewController(addNewSeasonVC, animated: true)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.heightForView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerMargin
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight = self.view.bounds.height - headerView.heightForView()
        var height = ITMainContainterTableViewCell.heightForCell(events: events, seasons: seasons)
        height = height > minHeight ? height : minHeight
        height += footerMargin
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITMainContainterTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainContainterTableViewCell.self), for: indexPath) as! ITMainContainterTableViewCell
        cell.updateContetnView(events: events, seasons: seasons)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

