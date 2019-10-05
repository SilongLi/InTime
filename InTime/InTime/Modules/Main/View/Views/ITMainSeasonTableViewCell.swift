//
//  ITMainSeasonTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/9/28.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITMainSeasonTableViewCell: UITableViewCell {
    
    static let ItemHeight: CGFloat = 30.0
    
    lazy var contentInfoView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.lightGrayColor.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3.0
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.darkGaryColor
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage.init(named: "seasonIcon")
        return icon
    }()
    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.heightLightGrayNoPressColor
        label.text = "暂无时节，立即添加"
        label.isHidden = true
        return label
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.blueColor
        return line
    }()
     
    private var refreshTimer: DispatchSourceTimer?
    private var currentSelectedDate: Date = Date()
    private var seasons: [SeasonModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(contentInfoView)
        contentInfoView.addSubview(lineView)
        contentInfoView.addSubview(infoLabel)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.size.width - Margin * 2.0
        contentInfoView.frame = CGRect.init(x: Margin, y: 0.0, width: width, height: self.frame.size.height)
        lineView.frame = CGRect.init(x: 0.0, y: 2.0, width: 1.0, height: contentInfoView.frame.size.height - 4.0)
        iconView.frame = CGRect.init(x: Margin, y: Margin, width: IconWH, height: IconWH)
        infoLabel.frame = contentInfoView.bounds;
    }
          
    class func heightForCell(_ seasons: [SeasonModel]?) -> CGFloat {
        let count = CGFloat(seasons?.count ?? 0)
        if count > 0 {
            return Margin * 2.0 + count * ItemHeight
        } else {
            return Margin * 2.0 + IconWH
        }
   }
     
    func updateContent(_ seasons: [SeasonModel]?, date: Date = Date()) {
        infoLabel.isHidden = (seasons?.count ?? 0) > 0
        currentSelectedDate = date
        
        if refreshTimer == nil {
            refreshTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            refreshTimer?.schedule(deadline: .now(), repeating: 10.0)
            refreshTimer?.setEventHandler(handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.reloadContent()
                }
            })
            refreshTimer?.resume()
        }
        self.seasons = seasons
        reloadContent()
    }
    
    func reloadContent() {
        contentInfoView.removeAllSubviews()
        contentInfoView.addSubview(lineView)
        contentInfoView.addSubview(iconView)
        contentInfoView.addSubview(infoLabel)
        guard let seasons = seasons  else {
            return
        }
        
        var index: CGFloat = 0.0
        for season: SeasonModel in seasons {
            season.unitModel.info = DateUnitType.day.rawValue
            let (timeIntervalStr, _, _, isLater) = SeasonTextManager.handleSeasonInfo(season, isNeedWeekDayInfo: true, currentSelectedDate)
             
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .left
            label.textColor = isLater ? UIColor.heightLightGrayColor : UIColor.heightLightGrayNoPressColor
            label.text = season.title
            contentInfoView.addSubview(label)
            
            let timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            timeLabel.textAlignment = .left
            timeLabel.textColor = isLater ? UIColor.white : UIColor.heightLightGrayColor
            timeLabel.text = " " + timeIntervalStr + "天 "
            timeLabel.backgroundColor = isLater ? UIColor.greenColor : UIColor.pinkColor.withAlphaComponent(0.5)
            timeLabel.layer.cornerRadius = 3.0
            timeLabel.layer.masksToBounds = true
            timeLabel.sizeToFit()
            contentInfoView.addSubview(timeLabel)
            
            let size = contentInfoView.frame.size
            let y = Margin + index * ITMainSeasonTableViewCell.ItemHeight + (ITMainSeasonTableViewCell.ItemHeight - timeLabel.frame.size.height) * 0.5
            var timeWidth = timeLabel.frame.size.width
            timeWidth = timeWidth > size.width * 0.4 ? size.width * 0.4 : timeWidth
            let timeX = size.width - timeWidth - 10.0
            timeLabel.frame = CGRect.init(x: timeX, y: y, width: timeWidth, height: timeLabel.frame.size.height)
            
            let x = Margin + IconWH + 10.0
            let labelY = Margin + index * ITMainSeasonTableViewCell.ItemHeight
            let width = contentInfoView.frame.size.width - x - 15.0 - timeWidth
            label.frame = CGRect.init(x: x, y: labelY, width: width, height: ITMainSeasonTableViewCell.ItemHeight)
            
            index += 1.0
        }
        
        self.setNeedsLayout()
    }

}


