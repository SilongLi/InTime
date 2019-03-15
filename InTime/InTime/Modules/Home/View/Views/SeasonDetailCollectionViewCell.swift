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
        label.font = UIFont.init(name: FontName, size: 18.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: ITCountdownLabel = {
        let label = ITCountdownLabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 40.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: FontName, size: 18.0)
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.init(name: FontName, size: 18.0)
        label.textAlignment = .left
        return label
    }()
    
    lazy var ringInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = UIFont.init(name: FontName, size: 8.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.pinkColor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        return label
    }()
    let margin: CGFloat = 20.0
    
    var season: SeasonModel? {
        didSet {
            guard let model = season else {
                return
            }
            let unitType: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
            let textColor = UIColor.color(hex: model.textColorModel.color)
            let nameFont = UIFont(name: FontName, size: 30.0) ?? .boldSystemFont(ofSize: 30.0)
            let (timeIntervalStr, date, dateInfo, _) = SeasonTextManager.handleSeasonInfo(model)
            
            dateLabel.textColor = textColor.withAlphaComponent(0.8)
            dateLabel.text = dateInfo
            
            
            ringInfoLabel.text = model.repeatRemindType.converToString()
            
            
            let (font, estimateWidth) = SeasonTextManager.calculateFontSizeAndWidth(timeIntervalStr, margin: margin)
            if unitType == .second || unitType == .minute || unitType == .hour || unitType == .day {
                unitLabel.isHidden = false
                unitLabel.text = unitType.rawValue
                
                unitLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(margin + estimateWidth + 10.0)
                    make.centerY.equalTo(countDownLabel.snp.centerY).offset(-15)
                    make.size.equalTo(CGSize(width: 30.0, height: 30.0))
                }
            } else {
                unitLabel.isHidden = true
            }
            
            
            countDownLabel.font = font
            countDownLabel.textColor = textColor
            countDownLabel.disposeTimer()
            countDownLabel.setupContent(date: date, unitType: unitType, animationType: model.animationType) { [weak self] (isLater) in
                self?.nameLabel.textColor = isLater ? UIColor.greenColor : UIColor.white
                let title = model.title + ((isLater || model.repeatRemindType != .no) ? " 还有" : " 已经")
                let attr = NSMutableAttributedString(string: title)
                attr.addAttributes([NSAttributedString.Key.font: nameFont,
                                    NSAttributedString.Key.foregroundColor: textColor],
                                   range: NSRange(location: 0, length: title.count - 2))
                self?.nameLabel.attributedText = attr
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(unitLabel)
        addSubview(dateLabel)
        addSubview(ringInfoLabel)
        addSubview(countDownLabel)
        
        countDownLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(200.0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(countDownLabel.snp.top)
            make.height.lessThanOrEqualTo(100.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(-10)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(ringInfoLabel.snp.left).offset(-10)
            make.height.greaterThanOrEqualTo(20.0)
        }
        ringInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right)
            make.width.greaterThanOrEqualTo(20.0)
            make.centerY.equalTo(dateLabel.snp.centerY).offset(2)
            make.height.equalTo(12.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
