//
//  HomeTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    lazy var spaceLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.spaceLineColor
        return view
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
            
            unitLabel.text = season?.unitModel.info
        }
    }
    
    func reloadContent() {
        guard let model = season else {
            return
        }
        self.season = model
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.cellHighlightedColor
        selectedBackgroundView = selectedView
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(countDownLabel)
        addSubview(dateLabel)
        addSubview(unitLabel)
        addSubview(spaceLineView)
        
        let margin: CGFloat = 15.0
        let width: CGFloat = IT_SCREEN_WIDTH * 0.5 - margin - 10.0
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.equalTo(margin)
            make.height.greaterThanOrEqualTo(20.0)
            make.height.greaterThanOrEqualTo(40.0)
            make.width.greaterThanOrEqualTo(80.0)
            make.width.lessThanOrEqualTo(width)
        }
        countDownLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-margin)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(20.0)
            make.width.greaterThanOrEqualTo(80.0)
            make.width.lessThanOrEqualTo(width)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(10.0)
            make.right.equalTo(countDownLabel.snp.right)
            make.height.equalTo(16.0)
            make.width.lessThanOrEqualTo(100.0)
            make.width.greaterThanOrEqualTo(60.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(unitLabel.snp.centerY)
            make.height.equalTo(unitLabel.snp.height)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(unitLabel.snp.left).offset(10)
        }
        spaceLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
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
