//
//  SeasonDetailCollectionViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/14.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SeasonDetailCollectionViewCell: UICollectionViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 44.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.adjustsFontSizeToFitWidth = true
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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    
    var season: SeasonModel? {
        didSet {
            reloadContent()
            
            if let textColor = season?.textColorModel.color, !textColor.isEmpty {
                let color = UIColor.color(hex: textColor)
                nameLabel.textColor      = color
                countDownLabel.textColor = color
                dateLabel.textColor      = color.withAlphaComponent(0.7)
                infoLabel.textColor      = color
            } else {
                nameLabel.textColor      = UIColor.white
                countDownLabel.textColor = UIColor.white
                dateLabel.textColor      = UIColor.white.withAlphaComponent(0.7)
                infoLabel.textColor      = UIColor.white
            }
        }
    }
    
    func reloadContent() {
        nameLabel.text = season?.title
        
        if let dateStr = season?.startDate.gregoriandDataString, let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
            infoLabel.text = (date as NSDate).isLaterThanDate(Date()) ? "距离" : "已过"
            
            let typeValue = season?.unitModel.info ?? DateUnitType.dayTime.rawValue
            let type: DateUnitType = DateUnitType(rawValue: typeValue) ?? DateUnitType.dayTime
            var timeString = (date as Date).convertToTimeString(type: type)
            countDownLabel.text = timeString
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
                    countDownLabel.attributedText = attributedText
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
        dateLabel.text = "\(dateStr) \(season?.startDate.weakDay ?? "")"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(countDownLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        
        let margin: CGFloat = 20.0
        let space: CGFloat  = 30.0
        let countDownHeight: CGFloat = 50.0
        countDownLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(countDownHeight)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            var bottomMargin = space + countDownHeight * 0.5
            bottomMargin += (IT_IPHONE_X || IT_IPHONE_6P) ? countDownHeight * 0.5 : 0.0
            make.bottom.equalTo(countDownLabel.snp.top).offset(-bottomMargin)
            make.height.greaterThanOrEqualTo(20.0)
            make.height.lessThanOrEqualTo(100.0)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(space)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel.snp.right)
            make.height.greaterThanOrEqualTo(25.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(space)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel.snp.right)
            make.height.greaterThanOrEqualTo(16.0)
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
