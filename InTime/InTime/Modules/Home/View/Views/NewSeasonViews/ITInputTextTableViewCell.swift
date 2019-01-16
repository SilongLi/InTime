//
//  ITInputTextTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 标题输入框

import UIKit

class ITInputTextTableViewCell: BaseTableViewCell {
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "请输入标题",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.tintColor])
        field.backgroundColor = UIColor.gray
        field.delegate = self
        return field
    }()
    
    var delegate: InputTextFieldDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(NewSeasonMargin)
            make.right.equalTo(-NewSeasonMargin)
            make.bottom.equalTo(-10)
        }
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? InputTextFieldDelegate
        guard model is InputModel else {
            return
        }
        let model = model as! InputModel
        let attributes =  [NSAttributedString.Key.foregroundColor: UIColor.tintColor,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        textField.attributedPlaceholder = NSAttributedString(string: model.placeholder, attributes: attributes)
    }
}

extension ITInputTextTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "\n" else {
            textField.resignFirstResponder()
            return false
        }
         return true
    }
}
