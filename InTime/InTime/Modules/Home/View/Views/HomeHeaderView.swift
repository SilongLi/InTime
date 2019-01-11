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
        label.font = UIFont.boldSystemFont(ofSize: 34.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center
        return label
    }()
    
    var season: SeasonModel?{
        didSet {
            titleLabel.text = season?.title
            dateLabel.text = "1天12小时20分40秒"
            dateInfoLabel.text = "2019.01.12 08:31 星期六"
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(dateInfoLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        dateInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.bottom.equalTo(-30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
