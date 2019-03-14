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
        label.font = UIFont.init(name: FontName, size: 10.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = UIFont.init(name: FontName, size: 18.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 15.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var ringInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.font = UIFont.init(name: FontName, size: 6.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.pinkColor
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
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
    private var season: SeasonModel?
    
    func setContent(_ model: SeasonModel) {
        if refreshTimer == nil {
            refreshTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            refreshTimer?.schedule(deadline: .now(), repeating: 1.0)
            refreshTimer?.setEventHandler(handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.reloadContent()
                }
            })
            refreshTimer?.resume()
        }
        self.season = model
        reloadContent()
    }
    
    func reloadContent() {
        guard let model = season else {
            return
        }
        let (timeIntervalStr, _, dateInfo, isLater) = SeasonTextManager.handleSeasonInfo(model)
        let isEffective = isLater || model.repeatRemindType != .no
        let unEffectiveColor = UIColor.white.withAlphaComponent(0.5)
        
        nameLabel.text = model.title
        ringInfoLabel.text = model.repeatRemindType.converToString()
        
        nameLabel.textColor = isEffective ? UIColor.greenColor : unEffectiveColor
        let font = UIFont(name: FontName, size: 18.0) ?? .boldSystemFont(ofSize: 18.0)
        let title = model.title + (isEffective ? " 还有" : " 已经")
        let attr = NSMutableAttributedString(string: title)
        attr.addAttributes([NSAttributedString.Key.font: font,
                            NSAttributedString.Key.foregroundColor: isEffective ? UIColor.white : unEffectiveColor],
                           range: NSRange(location: 0, length: title.count - 2))
        nameLabel.attributedText = attr
        
        countDownLabel.text      = timeIntervalStr
        dateLabel.text           = dateInfo
        
        countDownLabel.textColor = isEffective ? UIColor.white : unEffectiveColor
        dateLabel.textColor      = isEffective ? UIColor.white.withAlphaComponent(0.85) : unEffectiveColor
        ringInfoLabel.backgroundColor = isEffective ? UIColor.pinkColor : UIColor.pinkColor.withAlphaComponent(0.5)
    }
    
    func disableTimer() {
        refreshTimer?.cancel()
        refreshTimer = nil
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
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(margin)
            make.left.equalTo(margin)
            make.height.equalTo(16.0)
            make.width.greaterThanOrEqualTo(60.0)
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
