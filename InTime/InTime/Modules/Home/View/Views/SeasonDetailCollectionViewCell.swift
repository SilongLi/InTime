//
//  SeasonDetailCollectionViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/14.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SeasonDetailCollectionViewCell: UICollectionViewCell {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 17.0)
        label.text = "距离"
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left 
        label.font = UIFont.init(name: FontName, size: 15.0)
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
    
    var season: SeasonModel? {
        didSet {
            guard let model = season else {
                return
            }
            let textColor = UIColor.color(hex: model.textColorModel.color)
            countDownLabel.textColor = textColor
            dateLabel.textColor      = textColor.withAlphaComponent(0.8)
            infoLabel.textColor      = textColor.withAlphaComponent(0.9)
            
            let (timeIntervalStr, _, date, dateInfo, _) = SeasonTextManager.handleSeasonInfo(model)
            
            if IT_IPHONE_4 || IT_IPHONE_5 {
                countDownLabel.font = UIFont(name: FontName, size: timeIntervalStr.count > 11 ? 30.0 : 40)
            } else {
                countDownLabel.font = UIFont(name: FontName, size: timeIntervalStr.count > 11 ? 38.0 : 44)
            }
            
            let font = UIFont(name: FontName, size: 28.0) ?? .boldSystemFont(ofSize: 28.0)
            let unitType: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
            countDownLabel.setupContent(date: date, unitType: unitType, animationType: model.animationType) { [weak self] (isLater) in
                self?.nameLabel.textColor = isLater ? UIColor.greenColor : UIColor.red
                let title = model.title + (isLater ? " 还有" : " 已过")
                let attr = NSMutableAttributedString(string: title)
                attr.addAttributes([NSAttributedString.Key.font: font,
                                    NSAttributedString.Key.foregroundColor: textColor],
                                   range: NSRange(location: 0, length: title.count - 2))
                self?.nameLabel.attributedText = attr
            }
            
            dateLabel.text = dateInfo
            ringInfoLabel.text = model.repeatRemindType.converToString()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(countDownLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        addSubview(ringInfoLabel)
        
        let margin: CGFloat = 20.0
        countDownLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20.0)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(120.0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(countDownLabel.snp.top)
            make.height.lessThanOrEqualTo(100.0)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.greaterThanOrEqualTo(25.0)
            make.bottom.equalTo(nameLabel.snp.top).offset(-margin)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(margin)
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
