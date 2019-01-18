//
//  CategoryTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

protocol SelectedViewModelProtocol {
    var title: String { get }
    var isSelected: Bool { get }
}

class CategoryTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "selected"))
        view.isHidden = true
        return view
    }()
    
    lazy var spaceLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.spaceLineColor
        return view
    }()
    
    var nameNormalColor: UIColor = UIColor.white
    
    var model: SelectedViewModelProtocol? {
        didSet {
            nameLabel.text = model?.title
            iconView.isHidden = !(model?.isSelected ?? false)
            nameLabel.textColor = (model?.isSelected ?? false) ? UIColor.greenColor : nameNormalColor
            nameLabel.font = (model?.isSelected ?? false) ? UIFont.boldSystemFont(ofSize: 16.0) : UIFont.systemFont(ofSize: 16.0)
        }
    }
    
    var margin: CGFloat = 50.0 {
        didSet {
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
        }
    }
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(iconView)
        addSubview(spaceLineView)
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
        selectedView.backgroundColor = UIColor.cellHighlightedColor
        self.selectedBackgroundView = selectedView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
