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
    
    lazy var headerView: ITMainTableViewHeaderInfoView = {
        let view = ITMainTableViewHeaderInfoView() 
        view.didSelectedDateBlock = { [weak self] (date) in
            self?.currentSelectedDate = date.date
            self?.reloadEventsInfo(date.date)
            self?.updateTodayWindow(date.date)
        }
        view.showSeasonViewBlock = { [weak self] in
            self?.showSeasonView(nil)
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
    
    lazy var todayWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = .alert
        window.backgroundColor = UIColor.greenColor
        window.isHidden = true
        let rootVC = UIViewController()
        rootVC.view.addSubview(self.todayLabel)
        window.rootViewController = rootVC;
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didClickedTodayWidowAction))
        window.addGestureRecognizer(tap)
        return window
    }()
    
    lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: TimeNumberFontName, size: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    let calendarDataManager: ITCalendarDataManager = ITCalendarDataManager()
    
    private var animationFinished = true
    private var granted: Bool = false
    private var currentSelectedDate: Date = Date()
    private var events: [EKEvent]?
    private var isLoading: Bool = false
    private var categoryViewModels: [CategorySeasonsViewModel] = [CategorySeasonsViewModel]()
    private var categorys: [CategoryModel] = [CategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        view.backgroundColor = UIColor.tintColor
        
        view.addSubview(tableView)
        
        loadCategoryViewModels()
        rigesterNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategoryViewModels()
        updateTodayWindow(self.currentSelectedDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCalendarAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTodayWindow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect.init(x: 0.0, y: IT_StatusHeight, width: self.view.frame.width, height: self.view.frame.size.height)
    }
    
    // MARK: - Private Methods
    
    func checkCalendarAuthorization() {
        calendarDataManager.checkCalendarAuthorization { [weak self] (granted) in
            DispatchQueue.main.async {
                self?.granted = granted
                self?.reloadEventsInfo(self?.currentSelectedDate)
            }
        }
    }
    
    func updateTodayWindow(_ date: Date?) {
        if let date = date, !(date as NSDate).isToday() {
            showTodayWindow()
        } else {
            hideTodayWindow()
        }
    }
    
    func hideTodayWindow() {
        guard !todayWindow.isHidden else {
            return
        }
        todayWindow.alpha = 1.0
        UIView.animate(withDuration: 0.1, animations: {
            self.todayWindow.alpha = 0.0
        }) { (_) in
            self.todayWindow.isHidden = true
        }
    }
     
    func showTodayWindow() {
        guard todayWindow.isHidden else {
            return
        }
        let WH: CGFloat = 40.0
        let bottom: CGFloat = IT_IPHONE_X ? 50.0 : 30.0;
        todayWindow.frame = CGRect.init(x: 20.0, y: UIScreen.main.bounds.size.height - bottom - WH, width: WH, height: WH)
        todayWindow.layer.cornerRadius = WH  * 0.5
        todayWindow.layer.borderColor = UIColor.heightLightGrayColor.cgColor
        todayWindow.layer.borderWidth = 2.0
        todayWindow.layer.masksToBounds = true
        
        self.todayLabel.frame = self.todayWindow.bounds
        self.todayLabel.text = "\((NSDate()).day)"
          
        self.todayWindow.isHidden = false
        todayWindow.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.todayWindow.alpha = 1.0
        })
    }
    
    @objc func didClickedTodayWidowAction() {
        headerView.calendarView.calendarView.toggleCurrentDayView()
    }
    
    private func reloadEventsInfo(_ date: Date?) {
        guard granted, let date = date else { return }
        
        let startDate = (date as NSDate).atStartOfDay() ?? date
        let endDate = (date as NSDate).atEndOfDay() ?? date
        events = calendarDataManager.loadEventFromCalendWithStartDate(date: startDate, endDate: endDate)
        
        tableView.reloadData()
    }
    
    func loadCategoryViewModels() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        categoryViewModels.removeAll()
        HomeSeasonViewModel.loadLocalCategorys { [weak self] (models) in
            self?.categorys = models
            for category in models {
                if category.isDefault {
                    continue
                }
                let viewModel: CategorySeasonsViewModel = CategorySeasonsViewModel()
                viewModel.category = category
                self?.loadSeasons(viewModel)
                self?.categoryViewModels.append(viewModel)
            }
            self?.tableView.reloadData()
            self?.isLoading = false
        }
    }
    
    func loadSeasons(_ viewModel: CategorySeasonsViewModel) {
        guard viewModel.category.id.count > 0 else {
            return
        }
        HomeSeasonViewModel.loadLocalSeasons(categoryId: viewModel.category.id) { (seasons) in
            viewModel.seasons = seasons
        }
    }
    
//    func loadSeasons() {
//        if let categoryId = UserDefaults.standard.string(forKey: CurrentSelectedCategoryIDKey) {
//            HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryId) { [weak self] (seasons) in
//                 self?.seasons = seasons
//                 self?.tableView.reloadData()
//            }
//        } else {
//            HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
//                self?.seasons = seasons
//                self?.tableView.reloadData()
//            }
//        }
//    }
     
    private func rigesterNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] (_) in
            self?.checkCalendarAuthorization()
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
     
    private func showSeasonView(_ viewModel: CategorySeasonsViewModel?) {
        saveCurrentCategory(viewModel)
        
        let seasonVC = HomeViewController()
        navigationController?.pushViewController(seasonVC, animated: true)
    }
    
    private func showAddNewSeasonView(_ viewModel: CategorySeasonsViewModel?) {
        saveCurrentCategory(viewModel)
        
        let addNewSeasonVC = AddNewSeasonViewController()
        navigationController?.pushViewController(addNewSeasonVC, animated: true)
    }
    
    private func saveCurrentCategory(_ viewModel: CategorySeasonsViewModel?) {
        if let model = viewModel, model.category.id.count > 0, categorys.count > 0 {
            for index in 0..<categorys.count {
                var category = categorys[index]
                category.isSelected = category.id == model.category.id
                categorys[index] = category
            }
            HomeSeasonViewModel.saveAllCategorys(categorys)
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
        var height = ITMainContainterTableViewCell.heightForCell(events: events, categoryViewModels: categoryViewModels)
        height = height > minHeight ? height : minHeight
        height += footerMargin
        height += 50.0
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITMainContainterTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainContainterTableViewCell.self), for: indexPath) as! ITMainContainterTableViewCell
        cell.updateContetnView(events: events, categoryViewModels: categoryViewModels, currentSelectedDate: currentSelectedDate)
        cell.showSystemCalendarAPPBlock = { [weak self ] in
            self?.showSystemCalendarAPP()
        }
        cell.showSeasonViewBlock = { [weak self] (cellModel) in
            self?.showSeasonView(cellModel)
        }
        cell.showAddNewSeasonViewBlock = { [weak self] (cellModel) in
            self?.showAddNewSeasonView(cellModel)
        }
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

