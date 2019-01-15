//
//  ITSelectedTimeTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITSelectedTimeTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.text = "时节时间"
        return label
    }()
    
    lazy var noteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" 提示", for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "question"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(showNoteViewAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var timeBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(showCalendarViewAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(switchAction), for: UIControl.Event.valueChanged)
       return view
    }()
    
    var delegate: SelectedTimeDelegate?
    var timeModel: TimeModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
        addSubview(noteBtn)
        addSubview(timeBtn)
        addSubview(switchView)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10.0)
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
        noteBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.greaterThanOrEqualTo(50.0)
            make.height.equalTo(20.0)
        }
        timeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(100.0)
            make.height.equalTo(16.0)
            make.bottom.equalTo(-15)
        }
        switchView.snp.makeConstraints { (make) in
            make.right.equalTo(-NewSeasonMargin - 10)
            make.bottom.equalTo(timeBtn.snp.bottom)
            make.size.equalTo(CGSize(width: 40.0, height: 30.0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? SelectedTimeDelegate
        guard model is TimeModel else {
            return
        }
        let model = model as! TimeModel
        timeModel = model
        
        nameLabel.text = model.noteName
        noteBtn.setTitle(model.note, for: UIControl.State.normal)
        noteBtn.setImage(UIImage(named: model.noteIcon), for: UIControl.State.normal)
        timeBtn.setTitle(model.dataString, for: UIControl.State.normal)
        switchView.isOn = model.isGregorian
    }
    
    // MARK: - actions
    @objc func showNoteViewAction() {
        self.delegate?.didClickedNoteInfoAction()
    }
    
    @objc func showCalendarViewAction() {
        guard let model = timeModel else {
            return
        }
        self.delegate?.didClickedShowCalendarViewAction(model: model)
    }
    
    @objc func switchAction() {
        self.delegate?.didClickedOpenGregorianSwitchAction(isGregorian: switchView.isOn)
    }
}
