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
        label.font = UIFont.init(name: FontName, size: 13.0)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: ITCountdownLabel = {
        let label = ITCountdownLabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: FontName, size: 40.0)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.init(name: FontName, size: 17.0)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var ringInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.init(name: FontName, size: 8.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.pinkColor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        return label
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    let margin: CGFloat = 15.0
    
    var season: SeasonModel?{
        didSet {
            guard let model = season else {
                return
            }
            let unitType: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
            let font = UIFont(name: FontName, size: 30.0) ?? .boldSystemFont(ofSize: 30.0)
            let (timeIntervalStr, date, dateInfo, _) = SeasonTextManager.handleSeasonInfo(model)
            
            dateInfoLabel.text = dateInfo
            ringInfoLabel.text = model.repeatRemindType.converToString()
            
            countDownLabel.font = SeasonTextManager.calculateFontSize(timeIntervalStr, margin: margin)
            countDownLabel.disposeTimer()
            countDownLabel.setupContent(date: date, unitType: unitType, animationType: model.animationType) { [weak self] (isLater) in
                self?.titleLabel.textColor = isLater ? UIColor.greenColor : UIColor.white
                let title = model.title + ((isLater || model.repeatRemindType != .no) ? " 还有" : " 已经")
                let attr = NSMutableAttributedString(string: title)
                attr.addAttributes([NSAttributedString.Key.font: font,
                                    NSAttributedString.Key.foregroundColor: UIColor.white],
                                   range: NSRange(location: 0, length: title.count - 2))
                self?.titleLabel.attributedText = attr
            }
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        addSubview(countDownLabel)
        addSubview(dateInfoLabel)
        addSubview(ringInfoLabel)
        
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(ringInfoLabel.snp.left).offset(-10.0)
            make.height.equalTo(20.0)
            make.bottom.equalTo(-40.0)
        }
        ringInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateInfoLabel.snp.right).offset(10.0)
            make.width.greaterThanOrEqualTo(20.0)
            make.centerY.equalTo(dateInfoLabel.snp.centerY).offset(2.0)
            make.height.equalTo(11.0)
        }
        countDownLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateInfoLabel.snp.top)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(140.0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(countDownLabel.snp.top).offset(10)
            make.height.greaterThanOrEqualTo(60.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
