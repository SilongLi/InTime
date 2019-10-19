//
//  ITMainHeaderInfoView.swift
//  InTime
//
//  Created by lisilong on 2019/10/19.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITMainHeaderInfoView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.heightLightGrayColor
        return label
    }()

    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(didAddButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "add")
        return view
    }()
    
    var didAddSeasonButtonBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(addButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.frame.size.height
        
        let margin: CGFloat = 15.0
        titleLabel.frame = CGRect.init(x: margin, y: 0.0, width: 200.0, height: height)
        
        let imageViewWH: CGFloat = 15.0;
        imageView.frame = CGRect.init(x: self.frame.size.width - imageViewWH - margin, y: (height - imageViewWH) * 0.5, width: imageViewWH, height: imageViewWH)
        
        let addButtonWidth: CGFloat = 50.0
        addButton.frame = CGRect.init(x: self.frame.size.width - addButtonWidth - margin, y: 0.0, width: addButtonWidth, height: height)
    }
    
    // MARK: - Actions
    
    @objc func didAddButtonAction() {
        if let block = didAddSeasonButtonBlock {
            block()
        }
    }
}
