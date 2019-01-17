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
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.info.rawValue)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupContentView()
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
    
    func setupContentView() {
        AddNewSeasonViewModel.loadListSections { [weak self] (sections) in
            self?.dataSource = sections
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - actions
    @objc func endTextFieldEditing() {
        view.endEditing(true)
    }
    
    @objc func saveSeasonAction() {
        /// TODO: 保存“时节”
        navigationController?.popViewController(animated: true)
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
        CommonTools.printLog(message: "输入框")
    }
}

// MARK: - 时间选择
extension AddNewSeasonViewController: SelectedTimeDelegate {
    /// 选择时间提示
    func didClickedNoteInfoAction() {
        
        CommonTools.printLog(message: "选择时间提示")
    }
    
    func didClickedShowCalendarViewAction(model: TimeModel) {
        let datePicker = WSDatePickerView(dateStyle: DateStyleShowYearMonthDayHourMinute, scrollTo: Date(), complete: { [weak self] (date) in
            guard let strongSelf = self else { return }
            guard let currentDate = date else { return }
            
            if let lunar = currentDate.solarToLunar() {
                model.data = currentDate
                model.lunarDataString = lunar
                model.gregoriandDataString = (currentDate as NSDate).string(withFormat: "yyyy-MM-dd HH:mm")
                for index in 0..<strongSelf.dataSource.count {
                    var section = strongSelf.dataSource[index]
                    if section.cellIdentifier == NewSeasonCellIdType.timeSelected.rawValue {
                        section.items = [model]
                        strongSelf.dataSource[index] = section
                        break
                    }
                }
                strongSelf.tableView.reloadData()
            }
        })
        datePicker?.dateLabelColor  = UIColor.tintColor
        datePicker?.datePickerColor = UIColor.tintColor
        datePicker?.doneButtonColor = UIColor.greenColor
        datePicker?.show()
    }
    /// 切换农历和公历
    func didClickedOpenGregorianSwitchAction(isGregorian: Bool) {
        
        CommonTools.printLog(message: "切换农历和公历")
    }
}

// MARK: - 信息选择
extension AddNewSeasonViewController: InfoSelectedDelegate {
    func didClickedInfoSelectedAction(model: InfoSelectedModel) {
        
        CommonTools.printLog(message: "信息选择")
    }
}

// MARK: - 是否开启时节提醒
extension AddNewSeasonViewController: NoteSwitchDelegate {
    func didClickedReminderSwitchAction(isOpen: Bool) {
        
        CommonTools.printLog(message: "是否开启时节提醒")
    }
}

// MARK: - 重复提醒
extension AddNewSeasonViewController: RepeatRemindersDelegate {
    func didSelectedRepeatRemindersAction(model: RepeatReminderModel) {
        
        CommonTools.printLog(message: "重复提醒")
    }
}

// MARK: - 自定义背景
extension AddNewSeasonViewController: BackgroundImageDelegate {
    func didSelectedBackgroundImageAction(model: BackgroundModel) {
        
        CommonTools.printLog(message: "自定义背景")
    }
}

// MARK: - 字体颜色
extension AddNewSeasonViewController: TextColorDelegate {
    func didSelectedTextColorAction(model: TextColorModel) {
        
        CommonTools.printLog(message: "字体颜色")
    }
}
