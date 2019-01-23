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
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 44.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    
    var season: SeasonModel? {
        didSet {
            nameLabel.text = season?.title
            
            if let dateStr = season?.startDate.gregoriandDataString, let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
                let typeValue = season?.unitModel.info ?? DateUnitType.dayTime.rawValue
                let type: DateUnitType = DateUnitType(rawValue: typeValue) ?? DateUnitType.dayTime
                countDownLabel.text = (date as Date).convertToTimeString(type: type)
            }
            
            var dateStr = ""
            if season?.startDate.isGregorian ?? true {
                dateStr = season?.startDate.gregoriandDataString ?? ""
            } else {
                dateStr = season?.startDate.lunarDataString ?? ""
            }
            dateLabel.text = "\(dateStr) \(season?.startDate.weakDay ?? "")"
            
            if let textColor = season?.textColorModel.color, !textColor.isEmpty {
                let color = UIColor.color(hex: textColor)
                nameLabel.textColor      = color
                countDownLabel.textColor = color
                dateLabel.textColor      = color.withAlphaComponent(0.7)
            } else {
                nameLabel.textColor      = UIColor.white
                countDownLabel.textColor = UIColor.white
                dateLabel.textColor      = UIColor.white.withAlphaComponent(0.7)
            }
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
        
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(countDownLabel)
        addSubview(dateLabel)
        
        let margin: CGFloat = 15.0
        countDownLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-30.0)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(50.0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(countDownLabel.snp.top).offset(-30.0)
            make.height.greaterThanOrEqualTo(20.0)
            make.height.lessThanOrEqualTo(100.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(40.0)
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
