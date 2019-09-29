//
//  ITMainDateInfoView.swift
//  InTime
//
//  Created by lisilong on 2019/9/6.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITMainDateInfoView: UIView {
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: TimeNumberFontName, size: 55)
        label.textColor = UIColor.heightLightGrayColor
        label.textAlignment = .center
        return label
    }()
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 60)
        label.textColor = UIColor.garyColor.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.text = "/"
        label.sizeToFit()
        return label
    }()
     
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: TimeNumberFontName, size: 26)
        label.textColor = UIColor.heightLightGrayNoPressColor
        label.textAlignment = .center
        return label
    }()
     
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = UIFont.init(name: TimeNumberFontName, size: 13)
        label.textColor = UIColor.heightLightGrayNoPressColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dayLabel)
        addSubview(unitLabel)
        addSubview(dateLabel)
        addSubview(dateInfoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = 8.0
        let y: CGFloat = (self.frame.height - dayLabel.frame.height) * 0.5 + 4.0
        dayLabel.frame = CGRect.init(x: x, y: y, width: dayLabel.frame.width, height: dayLabel.frame.height)
        
        let unitY: CGFloat = (self.frame.height - unitLabel.frame.height) * 0.5
        unitLabel.frame = CGRect.init(x: dayLabel.frame.maxX, y: unitY, width: unitLabel.frame.width, height: unitLabel.frame.height)
         
        dateLabel.frame = CGRect.init(x: unitLabel.frame.maxX + 5.0,
                                      y: self.frame.height * 0.5 - dateLabel.frame.height,
                                      width: dateLabel.frame.width,
                                      height: dateLabel.frame.height)
        
        dateInfoLabel.frame = CGRect.init(x: unitLabel.frame.maxX + 5.0,
                                          y: self.frame.height * 0.5 + 10.0,
                                          width: dateInfoLabel.frame.width,
                                          height: dateInfoLabel.frame.height)
    }
    
    public func updateContent(_ dateInfo: CVDate) {
        dayLabel.text = "\(dateInfo.day)"
        dayLabel.sizeToFit()
        
        dateLabel.text = "\(dateInfo.year)-\(dateInfo.month)"
        dateLabel.sizeToFit()
        
        let info = dateInfo.date.solarToLunarOnlyYMD()
        if (info as NSString).contains("年") {
            let index = (info as NSString).range(of: "年").location + 1
            dateInfoLabel.text = "\(dateInfo.date.weekDay())，" + (info as NSString).substring(from: index)
        } else {
            dateInfoLabel.text = "\(dateInfo.date.weekDay())，" + info
        }
        dateInfoLabel.sizeToFit()
        
        setNeedsLayout()
    }
}
