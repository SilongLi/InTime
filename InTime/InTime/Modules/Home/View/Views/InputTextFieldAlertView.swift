//
//  InputTextFieldAlertView.swift
//  InTime
//
//  Created by lisilong on 2019/2/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class InputTextFieldAlertView: CKAlertCommonView {

    let HeaderHeight: CGFloat = 44.0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.init(name: FontName, size: 17.0)
        label.backgroundColor = UIColor.garyColor.withAlphaComponent(0.6)
        return label
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入数据"
        field.layer.borderColor   = UIColor.spaceLineColor.cgColor
        field.layer.borderWidth   = 0.5
        field.layer.cornerRadius  = 3.0
        field.layer.masksToBounds = true
        field.textColor = UIColor.white
        field.clearButtonMode = .whileEditing 
        field.delegate = self
        field.leftView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        field.leftViewMode = .always
        return field
    }()
    
    public lazy var horizonalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.spaceLineColor
        return view
    }()
    
    public lazy var verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.spaceLineColor
        return view
    }()
    
    public lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.init(name: FontName, size: 17.0)
        button.setTitle("取消", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    public lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.greenColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.init(name: FontName, size: 17.0)
        button.setTitle("确定", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(doneAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    public var cancelButtonBlock: (() -> Void)?
    public var doneButtonBlock: ((_ text: String?) -> Void)?
    
    init(title: String = "",
         textFieldText: String?,
         placeholder: String = "",
         cancelAction: (() -> Void)? = nil,
         doneAction: ((_ text: String?) -> Void)? = nil) {
        super.init(animationStyle: .CKAlertFadePop, alertStyle: .CKAlertStyleAlert)
        self.cancelButtonBlock = cancelAction
        self.doneButtonBlock = doneAction
        
        setupSubviews()
        titleLabel.text = title
        textField.text  = textFieldText
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.spaceLineColor])
        textField.becomeFirstResponder()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    func setupSubviews() {
        backgroundColor = UIColor.tintColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(horizonalLineView)
        addSubview(verticalLineView)
        addSubview(cancelButton)
        addSubview(doneButton)
        
        let margin: CGFloat = 20.0
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(HeaderHeight)
        }
        textField.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.left.equalToSuperview().offset(30.0)
            make.right.equalToSuperview().offset(-30.0)
            make.height.equalTo(40.0)
        }
        horizonalLineView.snp.updateConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(margin)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let btnHeight: CGFloat = 44.0
        verticalLineView.snp.updateConstraints { (make) in
            make.top.equalTo(horizonalLineView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(btnHeight)
        }
        cancelButton.snp.updateConstraints({ (make) in
            make.top.equalTo(horizonalLineView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(verticalLineView.snp.left)
            make.height.equalTo(verticalLineView.snp.height)
        })
        doneButton.snp.updateConstraints({ (make) in
            make.top.equalTo(horizonalLineView.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(verticalLineView.snp.right)
            make.height.equalTo(verticalLineView.snp.height)
        })
        
        contentViewHeight = 170.0
        contentViewY = -70.0
    }
    
    @objc func doneAction() {
        textField.resignFirstResponder()
        self.hiddenAlertView()
        if let block = self.doneButtonBlock {
            block(textField.text)
        }
    }
    
    @objc func cancelAction() {
        textField.resignFirstResponder()
        self.hiddenAlertView()
        if let block = self.cancelButtonBlock {
            block()
        }
    }
}

extension InputTextFieldAlertView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
