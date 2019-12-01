//
//  CategoryTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 16.0)
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "selected"))
        view.isHidden = true
        return view
    }()
    
    lazy var spaceLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.spaceLineColor.withAlphaComponent(0.2)
        return view
    }()
    
    var nameNormalColor: UIColor = UIColor.white
     
    var isNeedSelectedStatus: Bool = true
    
    var model: SelectedViewModelProtocol? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.title
            if model.isSelected && isNeedSelectedStatus {
                iconView.isHidden = false
                nameLabel.textColor = UIColor.greenColor
            } else {
                iconView.isHidden = true
                nameLabel.textColor = nameNormalColor
            }
        }
    }
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(spaceLineView)
        
        let margin: CGFloat = 20.0
        nameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(margin)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(IT_SCREEN_WIDTH * 0.6)
        }
        iconView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-margin)
            make.size.equalTo(CGSize.init(width: 20.0, height: 20.0))
        }
        spaceLineView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.cellHighlightedColor.withAlphaComponent(0.1)
        self.selectedBackgroundView = selectedView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        guard editing else { return }
    
        let classString = "UITableViewCellReorderControl"
        guard let target = NSClassFromString(classString) else { return }
        for view in self.subviews {
            if type(of: view) == target {
                for view in view.subviews {
                    if type(of: view) == NSClassFromString("UIImageView") {
                        (view as! UIImageView).image = UIImage.init(named: "sortIcon")
                        break
                    }
                }
                break
            }
        }
    }
}
