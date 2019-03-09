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
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var ringInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: 6.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.pinkColor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.85)
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
    weak var delegate: HomeTableViewCellDelegate?
    var indexPath: IndexPath?
 
    var season: SeasonModel? {
        didSet {
            guard let model = season else {
                return
            }
            nameLabel.text = model.title
            unitLabel.text = model.unitModel.info
            ringInfoLabel.text = model.repeatRemindType.converToString()
            
            let (timeIntervalStr, _, _, dateInfo, isLater) = SeasonTextManager.handleSeasonInfo(model)
            
            let laterColor = UIColor.white.withAlphaComponent(0.5)
            nameLabel.textColor      = isLater ? UIColor.white : laterColor
            countDownLabel.textColor = isLater ? UIColor.white : laterColor
            dateLabel.textColor      = isLater ? UIColor.white.withAlphaComponent(0.85) : laterColor
            unitLabel.textColor      = isLater ? UIColor.white.withAlphaComponent(0.85) : laterColor
            ringInfoLabel.backgroundColor = isLater ? UIColor.pinkColor : UIColor.pinkColor.withAlphaComponent(0.5)
            
            countDownLabel.text = timeIntervalStr
            let type: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
            switch type {
            case .second, .minute, .hour, .day:
                if timeIntervalStr.count > 1 {
                    let attributedText = NSMutableAttributedString(string: timeIntervalStr)
                    attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                                                  NSAttributedString.Key.foregroundColor: UIColor.white],
                                                 range: NSRange(location: timeIntervalStr.count - 1, length: 1))
                    countDownLabel.attributedText = attributedText
                }
            default:
                break
            }
            
            dateLabel.text = dateInfo
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
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(countDownLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(spaceLineView)
        addSubview(ringInfoLabel)
        
        let margin: CGFloat = 15.0
        let width: CGFloat = IT_SCREEN_WIDTH * 0.5 - margin - 10.0
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.equalTo(margin)
            make.height.greaterThanOrEqualTo(20.0)
            make.height.lessThanOrEqualTo(50.0)
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
            make.top.equalTo(countDownLabel.snp.bottom).offset(margin)
            make.right.equalTo(countDownLabel.snp.right)
            make.height.equalTo(16.0)
            make.width.lessThanOrEqualTo(100.0)
            make.width.greaterThanOrEqualTo(60.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(unitLabel.snp.centerY)
            make.height.equalTo(unitLabel.snp.height)
            make.left.equalTo(nameLabel.snp.left)
            make.right.lessThanOrEqualTo(unitLabel.snp.left).offset(-40)
        }
        ringInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(5)
            make.width.greaterThanOrEqualTo(20.0)
            make.centerY.equalTo(dateLabel.snp.centerY).offset(2)
            make.height.equalTo(10.0)
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
        
        let longP = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGestureRecognizer))
        self.addGestureRecognizer(longP)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func longPressGestureRecognizer() {
        if let indexP = indexPath {
            delegate?.didLongPressGestureRecognizer(indexPath: indexP)
        }
    }
}
