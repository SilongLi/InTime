//
//  ITMainContainterTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/10/4.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ITMainContainterTableViewCell: UITableViewCell {
    
    lazy var infoView: ITMainListInfoView = {
        let view = ITMainListInfoView()
        view.showSystemCalendarAPPBlock = { [weak self ] in
            if let block = self?.showSystemCalendarAPPBlock {
                block()
            }
        }
        view.showSeasonViewBlock = { [weak self] (cellModel) in
            if let block = self?.showSeasonViewBlock {
                block(cellModel)
            }
        }
        view.showAddNewSeasonViewBlock = { [weak self] (cellModel) in
            if let block = self?.showAddNewSeasonViewBlock {
                block(cellModel)
            }
        }
        return view
    }()
    
    private var currentSelectedDate: Date = Date()
    private var events: [EKEvent]?
    private var categoryViewModels: [CategorySeasonsViewModel] = [CategorySeasonsViewModel]()
     
    var showSystemCalendarAPPBlock: (() -> ())?
    var showSeasonViewBlock: ((_ viewModel: CategorySeasonsViewModel) -> ())?
    var showAddNewSeasonViewBlock: ((_ viewModel: CategorySeasonsViewModel) -> ())?
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tintColor
        addSubview(infoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = self.bounds
    }

    // MARK: Public Methods
     
    static func heightForCell(events: [EKEvent]?, categoryViewModels: [CategorySeasonsViewModel]) -> CGFloat {
        return ITMainListInfoView.heightForView(events: events, categoryViewModels: categoryViewModels)
    }
    
    func updateContetnView(events eventArray: [EKEvent]?, categoryViewModels viewModels: [CategorySeasonsViewModel], currentSelectedDate date: Date = Date()) {
        events = eventArray
        categoryViewModels = viewModels
        currentSelectedDate = date
        
        infoView.updateContetnView(events: events, categoryViewModels: viewModels, currentSelectedDate: date)
    }
}
