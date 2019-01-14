//
//  SeasonDetailCollectionViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/14.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SeasonDetailCollectionViewCell: UICollectionViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    var season: SeasonModel? {
        didSet {
            nameLabel.text = season?.title
            countDownLabel.text = "112天22时30分28秒"
            dateLabel.text = "2019.01.11 11:20 星期五"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(countDownLabel)
        addSubview(dateLabel)
        
        let margin: CGFloat = 15.0
        countDownLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-30.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(50.0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(countDownLabel.snp.top).offset(-20.0)
            make.height.greaterThanOrEqualTo(20.0)
            make.height.lessThanOrEqualTo(100.0)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countDownLabel.snp.bottom).offset(30.0)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel.snp.right)
            make.height.greaterThanOrEqualTo(16.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
