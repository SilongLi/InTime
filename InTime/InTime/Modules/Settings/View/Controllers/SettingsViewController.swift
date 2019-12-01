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
        tableView.register(ITDetailArrowTableViewCell.self, forCellReuseIdentifier: SettingCellIdType.feedback.rawValue)
        tableView.register(ITDetailArrowTableViewCell.self, forCellReuseIdentifier: SettingCellIdType.categoryManager.rawValue)
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
    
    // MARK: - Actions
    /// 分类管理
    func gotoCategoryManagerView() {
        let categoryManagerVC = CategoryManagerViewController()
        categoryManagerVC.isPush = true
        categoryManagerVC.isNeedSelectedStatus = false
        navigationController?.pushViewController(categoryManagerVC, animated: true)
    }
    
    /// 跳转到AppStore评价
    func gotoAppStoreWriteReview() {
        var urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1470847029&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        
        if #available(iOS 11.0, *) {
            urlStr = "itms-apps://itunes.apple.com/cn/app/id1470847029?mt=8&action=write-review"
        }
        
        if let url = URL.init(string: urlStr) {
            UIApplication.shared.openURL(url)
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
        
        let section = dataSource[indexPath.section]
        switch section.cellIdentifier {
        case SettingCellIdType.categoryManager.rawValue:
            gotoCategoryManagerView()
        case SettingCellIdType.feedback.rawValue:
            gotoAppStoreWriteReview()
        default:
            break
        }
    }
}

// MARK: - 是否显示到主屏幕
extension SettingsViewController: ShowInMainScreenSwitchDelegate {
    func didClickedShowInMainScreenSwitchAction(isShow: Bool) {
         HandleAppGroupsDocumentMannager.saveShowBgImageInMainScreen(isShow)
    }
}
