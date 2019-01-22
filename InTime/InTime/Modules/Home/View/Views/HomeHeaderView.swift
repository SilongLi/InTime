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
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 34.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center
        return label
    }()
    
    var season: SeasonModel?{
        didSet {
            titleLabel.text = season?.title
            if let dateStr = season?.startDate.gregoriandDataString, let data = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
                var intervals = Int(data.timeIntervalSinceNow)
                let currentData = NSDate()
                // 标准时间和北京时间差8个小时
                intervals = intervals - 8 * 60 * 60
                let years = data.year - currentData.year
                let days = intervals / 60 / 60 / 24
                let hours = intervals / 60 / 60 - (days * 24)
                let minutes = intervals / 60 - (days * 24 * 60 + hours * 60)
                let seconds = intervals - (days * 24 * 60 * 60 + hours * 60 * 60 + minutes * 60)
                var dataText = ""
                if years != 0 {
                    dataText += "\(years)年"
                }
                if days != 0 {
                    dataText += "\(days)天"
                }
                if hours != 0 {
                    dataText += "\(hours)时"
                }
                if minutes != 0 {
                    dataText += "\(minutes)分"
                }
                if seconds != 0 {
                    dataText += "\(seconds)秒"
                }
                dateLabel.text = dataText
            }
            if season?.startDate.isGregorian ?? true {
                dateInfoLabel.text = season?.startDate.gregoriandDataString
            } else {
                dateInfoLabel.text = season?.startDate.lunarDataString
            }
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(dateInfoLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.bottom.equalTo(-30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
