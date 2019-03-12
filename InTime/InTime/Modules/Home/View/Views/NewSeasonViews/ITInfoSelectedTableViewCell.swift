//
//  ITInfoSelectedTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITInfoSelectedTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.init(name: FontName, size: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var infoBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(selectedInfoTypeAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    var delegate: InfoSelectedDelegate?
    var infoModel: InfoSelectedModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(infoBtn)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-NewSeasonMargin)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.height.equalTo(30.0)
        }
        infoBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-NewSeasonMargin)
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? InfoSelectedDelegate
        guard model is InfoSelectedModel else {
            return
        }
        let model = model as! InfoSelectedModel
        infoModel = model
        
        nameLabel.text = model.name
        
        let attr = NSMutableAttributedString(string: model.info)
        attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attr.length))
        attr.addAttribute(.foregroundColor, value: UIColor.greenColor, range: NSRange(location: 0, length: attr.length))
        infoLabel.attributedText = attr
    }
    
    // MARK: - actions
    @objc func selectedInfoTypeAction() {
        guard let model = infoModel else {
            return
        } 
        self.delegate?.didClickedInfoSelectedAction(model: model)
    }
}
