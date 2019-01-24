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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
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
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    
    var season: SeasonModel?{
        didSet {
            titleLabel.text = season?.title
            
            if let dateStr = season?.startDate.gregoriandDataString, let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
                infoLabel.text = (date as NSDate).isLaterThanDate(Date()) ? "距离" : "已过"
                
                let typeValue = season?.unitModel.info ?? DateUnitType.dayTime.rawValue
                let type: DateUnitType = DateUnitType(rawValue: typeValue) ?? DateUnitType.dayTime
                var timeString = (date as Date).convertToTimeString(type: type)
                dateLabel.text = timeString
                switch type {
                case .second, .minute, .hour, .day:
                    if type == .second {
                        timeString.append("秒")
                    } else if type == .minute {
                        timeString.append("分")
                    } else if type == .hour {
                        timeString.append("时")
                    } else if type == .day {
                        timeString.append("天")
                    }
                    if timeString.count > 1 {
                        let attributedText = NSMutableAttributedString(string: timeString)
                        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                                                      NSAttributedString.Key.foregroundColor: UIColor.white],
                                                     range: NSRange(location: timeString.count - 1, length: 1))
                        dateLabel.attributedText = attributedText
                    }
                default:
                    break
                }
            }
            
            var dateStr = ""
            if season?.startDate.isGregorian ?? true {
                dateStr = season?.startDate.gregoriandDataString ?? ""
            } else {
                dateStr = season?.startDate.lunarDataString ?? ""
            }
            dateInfoLabel.text = "\(dateStr) \(season?.startDate.weakDay ?? "")"
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
        addSubview(dateLabel)
        addSubview(dateInfoLabel)
        addSubview(infoLabel)
        
        let margin: CGFloat = 20.0
        let space: CGFloat  = 30.0
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-space)
            make.height.equalTo(20)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateInfoLabel.snp.top).offset(-margin)
            make.left.equalTo(dateInfoLabel.snp.left)
            make.right.equalTo(dateInfoLabel.snp.right)
            make.height.equalTo(25.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoLabel.snp.top).offset(-margin)
            make.left.equalTo(dateInfoLabel.snp.left)
            make.right.equalTo(dateInfoLabel.snp.right)
            make.height.equalTo(34.0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(space)
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalTo(dateLabel.snp.right)
            make.bottom.greaterThanOrEqualTo(dateLabel.snp.top).offset(-space)
            make.height.lessThanOrEqualTo(80.0)
        }
        
        refreshTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        refreshTimer?.schedule(deadline: .now(), repeating: 1.0)
        refreshTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.reloadContent()
            }
        })
        refreshTimer?.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
