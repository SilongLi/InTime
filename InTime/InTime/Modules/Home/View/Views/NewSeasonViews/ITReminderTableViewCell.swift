//
//  ITReminderTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITReminderTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.text = "时节时间"
        return label
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(switchAction), for: UIControl.Event.valueChanged)
        return view
    }()
    
    var delegate: NoteSwitchDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
        addSubview(switchView)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
        switchView.snp.makeConstraints { (make) in
            make.right.equalTo(-NewSeasonMargin - 10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40.0, height: 30.0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? NoteSwitchDelegate
        guard model is OpenReminderModel else {
            return
        }
        let model = model as! OpenReminderModel
        nameLabel.text = model.name
        switchView.isOn = model.isOpen
    }
    
    // MARK: - actions
    @objc func switchAction() {
        self.delegate?.didClickedReminderSwitchAction(isOpen: switchView.isOn)
    } 
}
