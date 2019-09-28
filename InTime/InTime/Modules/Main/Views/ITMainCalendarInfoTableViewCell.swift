//
//  ITMainCalendarInfoTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/9/28.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ITMainCalendarInfoTableViewCell: UITableViewCell {
     
    lazy var contentInfoView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.garyColor.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0.0, height: 5.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5.0
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage.init(named: "calender")
        return icon
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.garyColor
        label.text = "暂无时节，立即添加"
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(contentInfoView)
        contentInfoView.addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
 
        let width = self.frame.size.width - Margin * 2.0
        contentInfoView.frame = CGRect.init(x: Margin, y: 0.0, width: width, height: self.frame.size.height) 
        iconView.frame = CGRect.init(x: Margin, y: 10.0, width: IconWH, height: IconWH)
        infoLabel.frame = contentInfoView.bounds;
    }
    
    class func heightForCell(_ events: [EKEvent]?) -> CGFloat {
        var count = CGFloat(events?.count ?? 0)
        count = count > 0 ? count : 1
        return Margin * 2.0 + count * ItemHeight 
    }
    
    func updateContent(_ events: [EKEvent]?) {
        contentInfoView.removeAllSubviews()
        contentInfoView.addSubview(iconView)
        contentInfoView.addSubview(infoLabel)
        infoLabel.isHidden = (events?.count ?? 0) > 0
        guard let events = events else {
            return
        }
        
        var index: CGFloat = 0.0
        for event: EKEvent in events {
            let startDateStr = (event.startDate as NSDate).string(withFormat: "hh:mm") ?? ""
            let timeText = (event.startDate as NSDate).isMorning() ? "上午" : "下午"
            let dateString = startDateStr + timeText + "  "
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .left 
            label.textColor = UIColor.tintColor
            
            let title = dateString + event.title
            let attr = NSMutableAttributedString(string: title)
            attr.addAttributes([NSAttributedString.Key.font: label.font,
                                NSAttributedString.Key.foregroundColor: UIColor.greenColor],
                               range: NSRange(location: 0, length: dateString.count))
            label.attributedText = attr
             
            contentInfoView.addSubview(label)
            
            let x = Margin + IconWH + 10.0
            let y = Margin + index * ItemHeight
            let width = contentInfoView.frame.size.width - x - 10.0
            label.frame = CGRect.init(x: x, y: y, width: width, height: ItemHeight)
            index += 1.0
        }
        
        self.setNeedsLayout()
    }
}
