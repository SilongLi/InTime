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
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
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
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
    
    var season: SeasonModel?{
        didSet {
            titleLabel.text = season?.title
            
            if let dateStr = season?.startDate.gregoriandDataString, let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
                let typeValue = season?.unitModel.info ?? DateUnitType.dayTime.rawValue
                let type: DateUnitType = DateUnitType(rawValue: typeValue) ?? DateUnitType.dayTime
                dateLabel.text = (date as Date).convertToTimeString(type: type)
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
        
        let margin: CGFloat = 15.0
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(44)
        }
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-margin)
            make.height.equalTo(20)
            make.bottom.equalTo(-30)
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
