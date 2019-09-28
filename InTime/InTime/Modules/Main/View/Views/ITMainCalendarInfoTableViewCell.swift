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

    static let ItemHeight: CGFloat = 25.0
     
    lazy var contentInfoView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.lightGrayColor.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0.0, height: 5.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3.0
        view.layer.cornerRadius = 5.0
        view.backgroundColor = UIColor.darkGaryColor
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
        label.textColor = UIColor.heightLightGrayNoPressColor
        label.text = "暂无日程"
        label.isHidden = true
        return label
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.pinkColor
        return line
    }()
    
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
    
    class func heightForCell(_ events: [EKEvent]?) -> CGFloat {
        let count = CGFloat(events?.count ?? 0)
        if count > 0 {
            return Margin * 2.0 + count * ItemHeight
        } else {
            return Margin * 2.0 + IconWH
        }
    }
    
    func updateContent(_ events: [EKEvent]?) {
        contentInfoView.removeAllSubviews()
        contentInfoView.addSubview(lineView)
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
            label.textColor = UIColor.heightLightGrayColor
            
            let title = dateString + event.title
            let attr = NSMutableAttributedString(string: title)
            attr.addAttributes([NSAttributedString.Key.font: label.font,
                                NSAttributedString.Key.foregroundColor: UIColor.greenColor],
                               range: NSRange(location: 0, length: dateString.count))
            label.attributedText = attr
             
            contentInfoView.addSubview(label)
            
            let x = Margin + IconWH + 10.0
            let y = Margin + index * ITMainCalendarInfoTableViewCell.ItemHeight
            let width = contentInfoView.frame.size.width - x - 10.0
            label.frame = CGRect.init(x: x, y: y, width: width, height: ITMainCalendarInfoTableViewCell.ItemHeight)
            index += 1.0
        }
        
        self.setNeedsLayout()
    }
}
