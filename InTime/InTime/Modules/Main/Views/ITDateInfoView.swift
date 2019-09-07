//
//  ITDateInfoView.swift
//  InTime
//
//  Created by lisilong on 2019/9/6.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITDateInfoView: UIView {

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.darkGaryColor
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect.init(x: 0.0, y: 0.0, width: 200, height: self.frame.height)
    }
    
    public func updateContent(_ date: CVDate) {
        dateLabel.text = "\(date.year)/\(date.month)/\(date.day)"
    }
}
