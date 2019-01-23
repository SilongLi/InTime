//
//  AddNewSeasonViewController.swift
//  InTime
//
//  Created by lisilong on 2019/1/14.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

let NewSeasonMargin: CGFloat = IT_IPHONE_X || IT_IPHONE_6P ? 20.0 : 15.0

class AddNewSeasonViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(ITInputTextTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.input.rawValue)
        tableView.register(ITSelectedTimeTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.timeSelected.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.unit.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.category.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.animation.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.ring.rawValue)
        tableView.register(ITReminderTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.reminder.rawValue)
        tableView.register(ITRepeatReminderTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.repeatReminder.rawValue)
        tableView.register(ITSelectedBackgroundImageTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.background.rawValue)
        tableView.register(ITSelectedTextColorTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.textColor.rawValue)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tintColor
        return tableView
    }()
    
    // 点击空白区域的时候，退出编辑状态
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endTextFieldEditing))
        return tap
    }()
    
    var dataSource: [BaseSectionModel] = [BaseSectionModel]()
    var newSeason: SeasonModel = SeasonModel()
    var unitAlertModel: AlertCollectionModel = AlertCollectionModel()
    var categoryAlertModel: AlertCollectionModel = AlertCollectionModel()
    var reminderAlertModel: AlertCollectionModel = AlertCollectionModel()
    var isModifySeason: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        loadDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navbarBackgroundImage: UIImage = UIImage.creatImage(color: UIColor.tintColor)
        navigationController?.navigationBar.setBackgroundImage(navbarBackgroundImage, for: .default)
    } 
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) 
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    // MARK: - setup
    func setupSubviews() {
        fd_interactivePopDisabled = true
        
        view.backgroundColor = UIColor.tintColor
        navigationItem.title = "新建"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "save"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveSeasonAction))
        
        /// 当键盘升起的时候，添加点击手势
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (_) in
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
        /// 当键盘收起的时候，移除点击手势
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (_) in
            self.view.removeGestureRecognizer(self.tapGestureRecognizer)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSeasion() {
        guard newSeason.title.isEmpty, newSeason.categoryId.isEmpty else {
            isModifySeason = true
            return
        }
        for section in dataSource {
            switch section.cellIdentifier {
            case NewSeasonCellIdType.timeSelected.rawValue: /// 开始时间
                if let startTime: TimeModel = section.items.first as? TimeModel {
                    newSeason.startDate = startTime
                }
            case NewSeasonCellIdType.unit.rawValue:  /// 显示单位
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.unitModel = selectedModel
                }
            case NewSeasonCellIdType.category.rawValue:  /// 分类管理
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.categoryId = selectedModel.id
                }
            case NewSeasonCellIdType.ring.rawValue:  /// 提醒铃声
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.ringType = RemindVoiceType(rawValue: selectedModel.info) ?? RemindVoiceType.defaultType
                }
            case NewSeasonCellIdType.reminder.rawValue: /// 是否开启提醒
                if let model: OpenReminderModel = section.items.first as? OpenReminderModel {
                    newSeason.isOpenRemind = model.isOpen
                }
            case NewSeasonCellIdType.repeatReminder.rawValue:   /// 重复提醒
                if let models: RepeatReminderModel = section.items.first as? RepeatReminderModel {
                    for model in models.types {
                        if model.isSelected {
                            newSeason.repeatRemindType = model.type
                        }
                    }
                }
            case NewSeasonCellIdType.background.rawValue:   /// 自定义背景
                if let models: BackgroundModel = section.items.first as? BackgroundModel {
                    for model in models.images {
                        if model.isSelected {
                            newSeason.backgroundModel = model
                        }
                    }
                }
            case NewSeasonCellIdType.textColor.rawValue:    /// 字体颜色
                if let models: TextColorModel = section.items.first as? TextColorModel {
                    for model in models.colors {
                        if model.isSelected {
                            newSeason.textColorModel = model
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - load dataSource
    func loadDataSource() {
        AddNewSeasonViewModel.loadListSections(originSeason: newSeason) { [weak self] (sections) in
            self?.dataSource = sections
            self?.tableView.reloadData()
            self?.setupSeasion()
        }
        
        AddNewSeasonViewModel.loadUnitsModel(originSeason: newSeason) { [weak self] (model) in
            self?.unitAlertModel = model
        }
        AddNewSeasonViewModel.loadClassifyModel(originSeason: newSeason) { [weak self] (model) in
            self?.categoryAlertModel = model
        }
        AddNewSeasonViewModel.loadRemindVoicesModel(originSeason: newSeason) { [weak self] (model) in
            self?.reminderAlertModel = model
        }
    }
    
    // MARK: - actions
    @objc func saveSeasonAction() {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.addNewSeason()
        }
    }
    
    func addNewSeason() {
        guard !newSeason.title.isEmpty else {
            view.showText("请输入标题!")
            return
        }
        guard !newSeason.categoryId.isEmpty else {
            view.showText("请选择分类!")
            return
        }
        
        var success = false
        if isModifySeason {
            success = AddNewSeasonViewModel.saveSeason(season: newSeason)
        } else {
            newSeason.id = NSDate().string(withFormat: DatestringWithFormat)
            success = AddNewSeasonViewModel.addNewSeason(season: newSeason)
        }
        if success {
            NotificationCenter.default.post(name: NotificationAddNewSeason, object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            view.showText("保存失败!")
        }
    }
    
    @objc func endTextFieldEditing() {
        view.endEditing(true)
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension AddNewSeasonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].showCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as! BaseTableViewCell
        cell.setupContent(model: section.items.first)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 输入框
extension AddNewSeasonViewController: InputTextFieldDelegate {
    func didClickedEndEditing(model: InputModel) {
        if !model.text.isEmpty {
            newSeason.title = model.text
        }
    }
}

// MARK: - 时间选择
extension AddNewSeasonViewController: SelectedTimeDelegate {
    /// 提示
    func didClickedNoteInfoAction() {
        view.endEditing(true)
        CommonTools.printLog(message: "选择时间提示")
    }
    
    func didClickedShowCalendarViewAction(model: TimeModel) {
        view.endEditing(true)
        
        var selectedDate = Date()
        if isModifySeason {
            let dateStr = newSeason.startDate.gregoriandDataString
            if let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
                selectedDate = date as Date
            }
        }
        let datePicker = WSDatePickerView(dateStyle: DateStyleShowYearMonthDayHourMinute, scrollTo: selectedDate, complete: { [weak self] (date) in
            guard let strongSelf = self else { return }
            guard let currentDate = date else { return }
            model.lunarDataString = currentDate.solarToLunar()
            model.weakDay = currentDate.weekDay()
            model.gregoriandDataString = (currentDate as NSDate).string(withFormat: StartSeasonDateFormat)
            for index in 0..<strongSelf.dataSource.count {
                var section = strongSelf.dataSource[index]
                if section.cellIdentifier == NewSeasonCellIdType.timeSelected.rawValue {
                    section.items = [model]
                    strongSelf.dataSource[index] = section
                    break
                }
            }
            strongSelf.newSeason.startDate = model
            strongSelf.tableView.reloadData()
        })
        datePicker?.dateLabelColor  = UIColor.tintColor
        datePicker?.datePickerColor = UIColor.tintColor
        datePicker?.doneButtonColor = UIColor.greenColor
        datePicker?.show()
    }
    
    /// 切换农历和公历
    func didClickedOpenGregorianSwitchAction(isGregorian: Bool) {
        view.endEditing(true)
        
        for index in 0..<dataSource.count {
            var section = dataSource[index]
            if section.cellIdentifier == NewSeasonCellIdType.timeSelected.rawValue {
                if let model: TimeModel = section.items.first as? TimeModel {
                    model.isGregorian = isGregorian
                    section.items = [model]
                    dataSource[index] = section
                    newSeason.startDate = model
                    break
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: - 信息选择
extension AddNewSeasonViewController: InfoSelectedDelegate {
    func didClickedInfoSelectedAction(model: InfoSelectedModel) {
        view.endEditing(true)
        
        let margin: CGFloat = IT_IPHONE_4 || IT_IPHONE_5 ? 20.0 : 40.0
        switch model.type {
        /// 显示单位
        case .unit:
            let alert = CommonAlertTableView(model: unitAlertModel, selectedAction: { [weak self] (alertModel, textModel) in
                guard let strongSelf = self else { return }
                let unitModel = model
                unitModel.info = textModel.text
                strongSelf.newSeason.unitModel = unitModel
                strongSelf.unitAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.unit.rawValue:
                            section.items = [unitModel]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
            
            
        /// 分类管理
        case .classification:
            let alert = CommonAlertTableView(model: categoryAlertModel, selectedAction: { [weak self](alertModel, textModel) in
                guard let strongSelf = self else { return }
                strongSelf.newSeason.categoryId = textModel.type
                strongSelf.categoryAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.category.rawValue:
                            let catgory = model
                            catgory.id = textModel.type
                            catgory.info = textModel.text
                            section.items = [catgory]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
        /// 动画效果
        case .animation:
            break
        /// 提醒铃声
        case .ring:
            let alert = CommonAlertTableView(model: reminderAlertModel, selectedAction: { [weak self] (alertModel, textModel) in
                guard let strongSelf = self else { return }
                strongSelf.newSeason.ringType = RemindVoiceType(rawValue: textModel.type) ?? RemindVoiceType.defaultType
                strongSelf.reminderAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.ring.rawValue:
                            let ring = model
                            ring.info = textModel.text
                            section.items = [ring]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
        }
    }
}

// MARK: - 是否开启时节提醒
extension AddNewSeasonViewController: NoteSwitchDelegate {
    func didClickedReminderSwitchAction(isOpen: Bool) {
        view.endEditing(true)
        newSeason.isOpenRemind = isOpen
    }
}

// MARK: - 重复提醒
extension AddNewSeasonViewController: RepeatRemindersDelegate {
    func didSelectedRepeatRemindersAction(model: RepeatReminderTypeModel) {
        view.endEditing(true)
        newSeason.repeatRemindType = model.type
    }
}

// MARK: - 自定义背景
extension AddNewSeasonViewController: BackgroundImageDelegate {
    func didSelectedBackgroundImageAction(model: BackgroundImageModel) {
        view.endEditing(true)
        newSeason.backgroundModel = model
    }
}

// MARK: - 字体颜色
extension AddNewSeasonViewController: TextColorDelegate {
    func didSelectedTextColorAction(model: ColorModel) {
        view.endEditing(true)
        newSeason.textColorModel = model
    }
}
