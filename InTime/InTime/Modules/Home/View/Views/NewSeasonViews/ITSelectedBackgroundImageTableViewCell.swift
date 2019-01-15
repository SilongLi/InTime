//
//  ITSelectedBackgroundImageTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITSelectedBackgroundImageTableViewCell: BaseTableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var reminderView: UIView = {
        let view = UIView()
        return view
    }()
    
    var delegate: BackgroundImageDelegate?
    var bgModel: BackgroundModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
        addSubview(reminderView)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10.0)
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
        reminderView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10.0)
            make.left.equalTo(NewSeasonMargin)
            make.right.equalTo(-NewSeasonMargin)
            make.bottom.equalToSuperview().offset(-10.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? BackgroundImageDelegate
        guard model is BackgroundModel else {
            return
        }
        let model = model as! BackgroundModel
        bgModel = model
        nameLabel.text = model.name
    }
    
    // MARK: - actions

}
