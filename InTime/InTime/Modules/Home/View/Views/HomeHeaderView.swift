//
//  HomeHeaderView.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 44.0)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: ITCountdownLabel = {
        let label = ITCountdownLabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 23.0)
        label.text = "距离"
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var ringInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 8.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.pinkColor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        return label
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    
    var season: SeasonModel?{
        didSet {
            guard let model = season else {
                return
            }
            titleLabel.text = model.title
            ringInfoLabel.text = model.repeatRemindType.converToString()
            
            let (_, info, date, dateInfo, isLater) = SeasonTextManager.handleSeasonInfo(model)
            
            infoLabel.text = info
            infoLabel.textColor = isLater ? UIColor.white : UIColor.red
            
            let type: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
            countDownLabel.isRound = isLater
            countDownLabel.setCountDownDate(targetDate: date as NSDate)
            countDownLabel.timeFormat = SeasonTextManager.handleDateFormat(type: type)
            countDownLabel.animationType = .Fall
            countDownLabel.start()
            
            dateInfoLabel.text = dateInfo
        }
    }
    
    func reloadContent() {
        guard let model = season else {
            return
        }
        self.season = model
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        addSubview(countDownLabel)
        addSubview(dateInfoLabel)
        addSubview(infoLabel)
        addSubview(ringInfoLabel)
        
        let margin: CGFloat = 20.0
        let space: CGFloat  = 30.0
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(ringInfoLabel.snp.left).offset(-10)
            make.height.equalTo(20)
            make.bottom.equalTo(-(space + 10))
        }
        ringInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateInfoLabel.snp.right).offset(10)
            make.width.greaterThanOrEqualTo(20.0)
            make.centerY.equalTo(dateInfoLabel.snp.centerY).offset(4)
            make.height.equalTo(12.0)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateInfoLabel.snp.top).offset(-margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(25.0)
        }
        countDownLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoLabel.snp.top).offset(-margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(34.0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(space)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.greaterThanOrEqualTo(countDownLabel.snp.top).offset(-space)
            make.height.lessThanOrEqualTo(80.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
