//
//  ITMainListInfoView.swift
//  InTime
//
//  Created by lisilong on 2019/10/4.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ITMainListInfoView: UIView {
 
    static let headerHeight: CGFloat = 44.0
    static let footHeight: CGFloat = 15.0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tintColor
        tableView.isScrollEnabled = false
        tableView.register(ITMainCalendarInfoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITMainCalendarInfoTableViewCell.self))
        tableView.register(ITMainSeasonTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITMainSeasonTableViewCell.self))
        return tableView
    }()
    
    private var currentSelectedDate: Date = Date()
    private var events: [EKEvent]?
    private var categoryViewModels: [CategorySeasonsViewModel] = [CategorySeasonsViewModel]()
    
    var isSelected: Bool = false
    
    
    var showSystemCalendarAPPBlock: (() -> ())?
    var showSeasonViewBlock: ((_ viewModel: CategorySeasonsViewModel) -> ())?
    var showAddNewSeasonViewBlock: ((_ viewModel: CategorySeasonsViewModel) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func heightForView(events: [EKEvent]?, categoryViewModels: [CategorySeasonsViewModel]) -> CGFloat {
        var height = ITMainCalendarInfoTableViewCell.heightForCell(events) + footHeight * 2.0
        for viewModel in categoryViewModels {
            height += ITMainSeasonTableViewCell.heightForCell(viewModel)
            height += headerHeight
        }
        return height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = self.bounds
    }
    
    func updateContetnView(events eventArray: [EKEvent]?, categoryViewModels viewModels: [CategorySeasonsViewModel], currentSelectedDate date: Date = Date()) {
        events = eventArray
        categoryViewModels = viewModels
        currentSelectedDate = date
        
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    func getSeasonsViewModel(_ indexPath: IndexPath) -> CategorySeasonsViewModel {
        guard indexPath.section - 1 < categoryViewModels.count else {
            return CategorySeasonsViewModel()
        }
        return categoryViewModels[indexPath.section - 1]
    }
}

extension ITMainListInfoView: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1 + (categoryViewModels.count > 0 ? categoryViewModels.count : 1)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return section == 0 ? 0.001 : ITMainListInfoView.headerHeight
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return ITMainListInfoView.footHeight
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (indexPath.section == 0) {
                let cell: ITMainCalendarInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainCalendarInfoTableViewCell.self), for: indexPath) as! ITMainCalendarInfoTableViewCell
                cell.updateContent(events)
                return cell
            }
            
            let cell: ITMainSeasonTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ITMainSeasonTableViewCell.self), for: indexPath) as! ITMainSeasonTableViewCell 
            cell.updateContent(getSeasonsViewModel(indexPath), date: currentSelectedDate)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
                return ITMainCalendarInfoTableViewCell.heightForCell(events)
            }
            return ITMainSeasonTableViewCell.heightForCell(getSeasonsViewModel(indexPath))
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = .clear
            if (section == 0) {
                return view
            }
             
            guard section - 1 < categoryViewModels.count else {
                return view
            }
            let headerInfoView = ITMainHeaderInfoView()
            headerInfoView.backgroundColor = UIColor.clear
            let model = categoryViewModels[section - 1]
            headerInfoView.titleLabel.text = model.category.title
            headerInfoView.didAddSeasonButtonBlock = { [weak self] in
                if let block = self?.showAddNewSeasonViewBlock {
                    block(model)
                }
            }
            return headerInfoView
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                if let block = showSystemCalendarAPPBlock {
                    block()
                }
            } else {
                let index = indexPath.section - 1
                if index < categoryViewModels.count {
                    let viewModel = categoryViewModels[index]
                    if viewModel.seasons.count > 0, let block = showSeasonViewBlock {
                        block(viewModel)
                    }else {
                        if let block = showAddNewSeasonViewBlock {
                            block(viewModel)
                        }
                    }
                } else {}
            }
        }
}

