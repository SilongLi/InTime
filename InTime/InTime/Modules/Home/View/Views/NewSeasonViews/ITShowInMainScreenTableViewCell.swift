//
//  ITShowInMainScreenTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/11/24.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITShowInMainScreenTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 16)
        label.textColor = UIColor.white
        label.text = "主屏幕显示"
        return label
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor.greenColor
        view.addTarget(self, action: #selector(switchAction), for: UIControl.Event.valueChanged)
        return view
    }()
    
    weak var delegate: ShowInMainScreenSwitchDelegate?
    var secreenModel: ShowInMainScreenModel?

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
            make.right.equalTo(-NewSeasonMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? ShowInMainScreenSwitchDelegate
        guard model is ShowInMainScreenModel else {
            return
        }
        let model = model as! ShowInMainScreenModel
        nameLabel.text = model.name
        switchView.isOn = model.isShow
    }
    
    // MARK: - actions
    @objc func switchAction() {
        self.delegate?.didClickedShowInMainScreenSwitchAction(isShow: switchView.isOn)
    }
}
