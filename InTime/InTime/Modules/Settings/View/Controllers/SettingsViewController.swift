//
//  SettingsViewController.swift
//  InTime
//
//  Created by lisilong on 2019/3/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    let margin: CGFloat = 35.0
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(ITShowInMainScreenTableViewCell.self, forCellReuseIdentifier: SettingCellIdType.showBgImageInWidget.rawValue)
        tableView.register(ITReminderTableViewCell.self, forCellReuseIdentifier: SettingCellIdType.feedback.rawValue)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tintColor
        return tableView
    }()
    
    var dataSource: [BaseSectionModel] = [BaseSectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupSubviews()
        loadDataSource() 
    }
      
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    // MARK: - setup
    func setupSubviews() {
        fd_interactivePopDisabled = true
        
        view.backgroundColor = UIColor.tintColor
        navigationItem.title = "设置中心"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - load dataSource
    func loadDataSource() {
        ITSettingsViewModel.loadListSections() { [weak self] (sections) in
            self?.dataSource = sections
            self?.tableView.reloadData()
        }
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
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

// MARK: - 重复提醒
extension SettingsViewController: RepeatRemindersDelegate {
    func didSelectedRepeatRemindersAction(model: RepeatReminderTypeModel) {
         
    }
}

// MARK: - 是否显示到主屏幕
extension SettingsViewController: ShowInMainScreenSwitchDelegate {
    func didClickedShowInMainScreenSwitchAction(isShow: Bool) {
         
    }
}
