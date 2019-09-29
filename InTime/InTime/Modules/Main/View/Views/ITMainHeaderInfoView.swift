//
//  ITMainHeaderInfoView.swift
//  InTime
//
//  Created by lisilong on 2019/9/28.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITMainHeaderInfoView: UIView {
    
    let margin: CGFloat = 15.0
    let infoHeight: CGFloat = 80.0
    let btnHeight: CGFloat = 30.0
    
    lazy var calendarView: ITMainCalendarView = {
        let calendarView = ITMainCalendarView.init({ [weak self] (dateInfo) in
            self?.dateInfoView.updateContent(dateInfo)
            if let block = self?.didSelectedDateBlock {
                block(dateInfo)
            }
        })
        return calendarView
    }()
    
    lazy var dateInfoView: ITMainDateInfoView = {
        let view = ITMainDateInfoView()
        return view
    }()
    
    lazy var showDetailButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "line"), for: .normal)
        btn.addTarget(self, action: #selector(showDetailButtonAction), for: UIControl.Event.touchUpInside)
        btn.alpha = 0.5
        return btn
    }()
    
    lazy var showSeasonButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "seasonView"), for: .normal)
        btn.addTarget(self, action: #selector(showSeasonViewButtonAction), for: UIControl.Event.touchUpInside)
        btn.alpha = 0.8
        return btn
    }()
    
    var didSelectedDateBlock: ((_ date: CVDate) -> ())?
    var showDetailCalendarViewBlock: (() -> ())?
    var showSeasonViewBlock: (() -> ())?
     
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        addSubview(dateInfoView)
        addSubview(showSeasonButton)
        addSubview(calendarView)
        addSubview(showDetailButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        let width: CGFloat = size.width - margin * 2.0
         
        dateInfoView.frame = CGRect.init(x: margin, y: 0.0, width: width, height: infoHeight)
        calendarView.frame = CGRect.init(x: 0.0, y: dateInfoView.frame.maxY + 10.0, width: size.width, height: calendarView.heightForView())
        showDetailButton.frame = CGRect.init(x: 0.0, y: calendarView.frame.maxY, width: size.width, height: btnHeight)
        
        let showSeasonButtonWH: CGFloat = 30.0
        let y: CGFloat = 30
        showSeasonButton.frame = CGRect.init(x: size.width - showSeasonButtonWH - margin, y: y, width: showSeasonButtonWH, height: showSeasonButtonWH)
        showSeasonButton.center.y = dateInfoView.center.y
    }
    
    // MARK: - Public Methods
    
    func heightForView() -> CGFloat {
        return margin + infoHeight + calendarView.heightForView() + btnHeight
    }
    
    // MARK: - Actions
    @objc private func showDetailButtonAction() {
        let isWeek = calendarView.calendarMode == .weekView
        calendarView.calendarMode = isWeek ? .monthView : .weekView
         
        if let block = showDetailCalendarViewBlock {
            block()
        }
    }
    
    @objc private func showSeasonViewButtonAction() {
        if let block = showSeasonViewBlock {
            block()
        }
    }

}
