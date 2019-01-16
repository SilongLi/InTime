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
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
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
    
    var dataSource: [BaseSectionModel] = [BaseSectionModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupContentView()
    }
    
    // MARK: - setup
    func setupSubviews() {
        navigationItem.title = "新建"
        view.backgroundColor = UIColor.tintColor
        fd_interactivePopDisabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "save"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveSeasonAction))
        
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
