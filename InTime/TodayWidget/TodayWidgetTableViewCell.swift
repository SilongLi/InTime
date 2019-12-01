//
//  TodayWidgetTableViewCell.swift
//  TodayWidget
//
//  Created by lisilong on 2019/11/24.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class TodayWidgetTableViewCell: UITableViewCell {
      
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        let isShowBgImage = HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
        label.textColor = isShowBgImage ? UIColor.white : UIColor.black
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 10)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        let isShowBgImage = HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
        label.textColor = isShowBgImage ? UIColor.white : UIColor.black
        label.textAlignment = .right
        label.font = UIFont.init(name: FontName, size: 17.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        let isShowBgImage = HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
        label.textColor = isShowBgImage ? UIColor.white.withAlphaComponent(0.85) : UIColor.darkGray.withAlphaComponent(0.85)
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 10)
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
        let isShowBgImage = HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
        view.backgroundColor = isShowBgImage ? UIColor.white.withAlphaComponent(0.2) : UIColor.darkGray.withAlphaComponent(0.2)
        return view
    }()
    
    /// 定时刷新界面
    private var refreshTimer: DispatchSourceTimer?
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
        
        let isShowBgImage = HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
         
        let unitType: DateUnitType = DateUnitType(rawValue: model.unitModel.info) ?? DateUnitType.dayTime
        let (timeIntervalStr, _, dateInfo, isLater) = SeasonTextManager.handleSeasonInfo(model)
        let isEffective = isLater || model.repeatRemindType != .no
        let unEffectiveColor = isShowBgImage ? UIColor.white.withAlphaComponent(0.5) : UIColor.darkGray.withAlphaComponent(0.5)
        let attrColor = isShowBgImage ? UIColor.white : UIColor.black 
        let textColor = isShowBgImage ? UIColor.white : UIColor.darkGray
        
        nameLabel.textColor = isEffective ? textColor : unEffectiveColor
        let font  = UIFont(name: FontName, size: 14) ?? .boldSystemFont(ofSize: 134)
        let title = model.title + (isLater || (model.repeatRemindType != .no && model.repeatRemindType != .commemorationDay) ? " 还有" : " 已经")
        let attr  = NSMutableAttributedString(string: title)
        attr.addAttributes([NSAttributedString.Key.font: font,
                            NSAttributedString.Key.foregroundColor: isEffective ? attrColor : unEffectiveColor],
                           range: NSRange(location: 0, length: title.count - 2))
        nameLabel.attributedText = attr
        nameLabel.sizeToFit()
        
        if timeIntervalStr == "0" {
            countDownLabel.text  = "今天"
        } else {
            if unitType == .second || unitType == .minute || unitType == .hour || unitType == .day {
                countDownLabel.text  = timeIntervalStr + unitType.rawValue
            } else {
                countDownLabel.text  = timeIntervalStr
            }
        }
        countDownLabel.textColor = isEffective ? attrColor : unEffectiveColor
        countDownLabel.sizeToFit()
         
        dateLabel.textColor = isEffective ? textColor : unEffectiveColor
        dateLabel.text      = dateInfo
        dateLabel.sizeToFit()
        
        ringInfoLabel.text = model.repeatRemindType.converToString()
        ringInfoLabel.backgroundColor = isEffective ? UIColor.pinkColor : UIColor.pinkColor.withAlphaComponent(0.5)
        ringInfoLabel.sizeToFit()
        
        self.setNeedsLayout()
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
        
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
        let width = self.bounds.size.width
        let margin: CGFloat = 10.0
        let top: CGFloat = 8.0
        
        let cdMaxWidth: CGFloat = width * 0.3
        let countDownLabelWidth = countDownLabel.frame.size.width > cdMaxWidth ? cdMaxWidth : countDownLabel.frame.size.width
        let countDownLabelX = width - countDownLabelWidth - margin
        countDownLabel.frame = CGRect.init(x: countDownLabelX, y: top, width: countDownLabelWidth, height: 16.0)
        
        let nameLabelWidth = width - margin * 2.0 - countDownLabelWidth - 8.0
        nameLabel.frame = CGRect.init(x: margin, y: top, width: nameLabelWidth, height: 16.0)
         
        let dateLabelHeight: CGFloat = 16.0;
        let dateLabelY = self.bounds.size.height - dateLabelHeight - margin
        dateLabel.frame = CGRect.init(x: margin, y: dateLabelY, width: dateLabel.frame.size.width, height: dateLabelHeight)
 
        let ringInfoLabelX =  margin + dateLabel.frame.size.width + 5.0
        ringInfoLabel.frame = CGRect.init(x: ringInfoLabelX, y: dateLabelY, width: ringInfoLabel.frame.size.width, height: 10.0)
        ringInfoLabel.center.y = dateLabel.center.y
        
        let spaceLineViewWidth: CGFloat = width - margin * 2.0
        spaceLineView.frame = CGRect.init(x: margin, y: self.bounds.size.height - 0.5, width:  spaceLineViewWidth, height: 0.5)
    }
      
}
