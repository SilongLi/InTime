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
 
    static let footHeight: CGFloat = 20.0
    
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
    
    var events: [EKEvent]?
    var seasons: [SeasonModel]?
    var currentSelectedDate: Date = Date()
    
    var isSelected: Bool = false
    
    
    var showSystemCalendarAPPBlock: (() -> ())?
    var showSeasonViewBlock: (() -> ())?
    var showAddNewSeasonViewBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func heightForView(events: [EKEvent]?, seasons: [SeasonModel]?) -> CGFloat {
        var height = ITMainCalendarInfoTableViewCell.heightForCell(events) + footHeight * 2.0
        height += ITMainSeasonTableViewCell.heightForCell(seasons)
        return height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = self.bounds
    }
    
    func updateContetnView(events eventArray: [EKEvent]?, seasons seasonArray: [SeasonModel]?, currentSelectedDate date: Date = Date()) {
        events = eventArray
        seasons = seasonArray
        currentSelectedDate = date
        
        tableView.reloadData()
    }
}

extension ITMainListInfoView: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.001
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
            cell.updateContent(seasons, date: currentSelectedDate)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
                return ITMainCalendarInfoTableViewCell.heightForCell(events)
            }
            return ITMainSeasonTableViewCell.heightForCell(seasons)
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0:
                if let block = showSystemCalendarAPPBlock {
                    block()
                }
                break
            case 1:
                if let seasons = seasons, seasons.count > 0, let block = showSeasonViewBlock {
                    block()
                } else {
                    if let block = showAddNewSeasonViewBlock {
                        block()
                    }
                }
                break
            default:
                break
            }
        }
}

