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

//    lazy var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isPagingEnabled = true
//        view.backgroundColor = UIColor.tintColor
//        view.showsVerticalScrollIndicator = false
//        view.showsHorizontalScrollIndicator = false
//        view.delegate = self
//        return view
//    }()
//
//    var containters: [ITMainListInfoView] = [ITMainListInfoView]()
    
    lazy var infoView: ITMainListInfoView = {
        let view = ITMainListInfoView()
        view.showSystemCalendarAPPBlock = { [weak self ] in
            if let block = self?.showSystemCalendarAPPBlock {
                block()
            }
        }
        view.showSeasonViewBlock = { [weak self] in 
            if let block = self?.showSeasonViewBlock {
                block()
            }
        }
        view.showAddNewSeasonViewBlock = { [weak self] in
            if let block = self?.showAddNewSeasonViewBlock {
                block()
            }
        }
        return view
    }()
    
    var events: [EKEvent]?
    var seasons: [SeasonModel]?
    private var currentSelectedDate: Date = Date()
     
    var showSystemCalendarAPPBlock: (() -> ())?
    var showSeasonViewBlock: (() -> ())?
    var showAddNewSeasonViewBlock: (() -> ())?
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tintColor
        
        addSubview(infoView)
        
//        addSubview(scrollView)
//        setupContetnView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = self.bounds
        
//        scrollView.frame = self.bounds
//
//        scrollView.contentSize = CGSize.init(width: scrollView.bounds.width * CGFloat(containters.count), height: scrollView.bounds.height)
//
//        var index: CGFloat = 0.0
//        for view in containters {
//            view.frame = CGRect.init(x: index * scrollView.bounds.width, y: 0.0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//            index += 1.0
//        }
    }
    
    // Mark: setup
    
//    func setupContetnView() {
//        scrollView.removeAllSubviews()
//        containters.removeAll()
//
//        var index = 0
//        while index < 10 {
//            let view = ITMainListInfoView()
//            scrollView.addSubview(view)
//            containters.append(view)
//            index += 1
//        }
//    }

    // MARK: Public Methods
     
    static func heightForCell(events: [EKEvent]?, seasons: [SeasonModel]?) -> CGFloat {
        return ITMainListInfoView.heightForView(events: events, seasons: seasons)
    }
    
    func updateContetnView(events eventArray: [EKEvent]?, seasons seasonArray: [SeasonModel]?, currentSelectedDate date: Date = Date()) {
        events = eventArray
        seasons = seasonArray
        currentSelectedDate = date
        
        infoView.updateContetnView(events: events, seasons: seasons, currentSelectedDate: date)
        
//        var index = 0
//        for view: ITMainListInfoView in containters {
//            let currentDate = (date as NSDate).addingDays(index)
//            view.updateContetnView(events: events, seasons: seasons, currentSelectedDate: currentDate ?? date)
//            index += 1
//        }
    }
}

//extension ITMainContainterTableViewCell: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetX = scrollView.contentOffset.x
//        let index = offsetX / self.bounds.width
//
////        for view: ITMainListInfoView in containters {
////            view.events = events
////            view.seasons = seasons
////            view.currentSelectedDate = currentSelectedDate
////        }
//    }
//}
