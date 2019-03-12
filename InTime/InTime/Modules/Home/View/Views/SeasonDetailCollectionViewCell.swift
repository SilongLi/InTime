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
    
    lazy var countDownLabel: ITCountdownLabel = {
        let label = ITCountdownLabel()
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
    
    var season: SeasonModel? {
        didSet {
            let textColor = UIColor.color(hex: season?.textColorModel.color ?? "#FFFFFF")
            nameLabel.textColor      = textColor
            countDownLabel.textColor = textColor
            dateLabel.textColor      = textColor.withAlphaComponent(0.7)
            infoLabel.textColor      = textColor
            
            reloadContent()
        }
    }
    
    func reloadContent() {
        guard let model = season else {
            return
        } 
        nameLabel.text = model.title
        ringInfoLabel.text = model.repeatRemindType.converToString()
        
        let (timeIntervalStr, info, date, dateInfo, isLater) = SeasonTextManager.handleSeasonInfo(model)
        
        infoLabel.text = info
        infoLabel.textColor = isLater ? infoLabel.textColor : UIColor.red
        
        countDownLabel.text = timeIntervalStr
        let unitType: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
        countDownLabel.setupContent(date: date, unitType: unitType, animationType: model.animationType) { [weak self] (isLater) in
            self?.infoLabel.textColor = isLater ? UIColor.white : UIColor.red
        }
        
        let type: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
        switch type {
        case .second, .minute, .hour, .day:
            if timeIntervalStr.count > 1 {
                let attributedText = NSMutableAttributedString(string: timeIntervalStr)
                attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
                                             range: NSRange(location: timeIntervalStr.count - 1, length: 1))
                countDownLabel.attributedText = attributedText
            }
        default:
            break
        }
        
        dateLabel.text = dateInfo
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
            make.right.equalTo(ringInfoLabel.snp.left).offset(-10)
            make.height.greaterThanOrEqualTo(16.0)
        }
        ringInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(10)
            make.width.greaterThanOrEqualTo(20.0)
            make.centerY.equalTo(dateLabel.snp.centerY).offset(2)
            make.height.equalTo(12.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
