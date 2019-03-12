//
//  ITSelectedTimeTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 时间选择

import UIKit

class ITSelectedTimeTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: FontName, size: 16)
        label.textColor = UIColor.white
        label.text = "时节时间"
        return label
    }()
    
    lazy var noteBtn: UIButton = {
        let btn = UIButton()
        let attr = NSMutableAttributedString(string: " 提示")
        attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attr.length))
        attr.addAttribute(.foregroundColor, value: UIColor.lightGrayColor, range: NSRange(location: 0, length: attr.length))
        btn.setAttributedTitle(attr, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.init(name: FontName, size: 16)
        btn.setImage(UIImage.init(named: "question"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(showNoteViewAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var timeBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .left
        btn.titleLabel?.font = UIFont.init(name: FontName, size: 16)
        btn.addTarget(self, action: #selector(showCalendarViewAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var switchView: LabelSwitch = {
        var ls = LabelSwitchConfig(text: "农历",
                                   textColor: .white,
                                   font: UIFont.init(name: FontName, size: 13) ?? .boldSystemFont(ofSize: 13),
                                   gradientColors: [UIColor.pinkColor.cgColor, UIColor.pinkColor.cgColor],
                                   startPoint: CGPoint(x: 0.0, y: 0.5),
                                   endPoint: CGPoint(x: 1, y: 0.5))
        var rs = LabelSwitchConfig(text: "公历",
                                   textColor: .white,
                                   font: UIFont.init(name: FontName, size: 13) ?? .boldSystemFont(ofSize: 13),
                                   gradientColors: [UIColor.greenColor.cgColor, UIColor.greenColor.cgColor],
                                   startPoint: CGPoint(x: 0.0, y: 0.5),
                                   endPoint: CGPoint(x: 1, y: 0.5))
        let labelSwitch = LabelSwitch(center: CGPoint.zero, leftConfig: ls, rightConfig: rs, circlePadding: 2.0, defaultState: .L)
        labelSwitch.circleShadow = true
        labelSwitch.circleColor = .white
        labelSwitch.fullSizeTapEnabled = true
        labelSwitch.delegate = self
        return labelSwitch
    }()
    
    weak var delegate: SelectedTimeDelegate?
    var timeModel: TimeModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
//        addSubview(noteBtn)
        addSubview(timeBtn)
        addSubview(switchView)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10.0)
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
//        noteBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(nameLabel.snp.right).offset(10)
//            make.centerY.equalTo(nameLabel.snp.centerY)
//            make.width.greaterThanOrEqualTo(50.0)
//            make.height.equalTo(20.0)
//        }
        timeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(100.0)
            make.height.equalTo(20.0)
            make.bottom.equalTo(-15)
        }
        switchView.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeBtn.snp.bottom)
            make.right.equalTo(-NewSeasonMargin)
            make.size.equalTo(CGSize(width: 67.0, height: 30.0))
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
//        noteBtn.setTitle(model.note, for: UIControl.State.normal)
//        noteBtn.setImage(UIImage(named: model.noteIcon), for: UIControl.State.normal)
        
        let timeStr = model.isGregorian ? model.gregoriandDataString : model.lunarDataString
        let attr = NSMutableAttributedString(string: timeStr)
        attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attr.length))
        attr.addAttribute(.foregroundColor, value: UIColor.greenColor, range: NSRange(location: 0, length: attr.length))
        timeBtn.setAttributedTitle(attr, for: UIControl.State.normal)
        
        switchView.curState = model.isGregorian ? .L : .R
    }
    
    // MARK: - actions
    @objc func showNoteViewAction() {
        self.delegate?.didClickedNoteInfoAction()
    }
    
    @objc func showCalendarViewAction() {
        guard let model = timeModel else { return }
        self.delegate?.didClickedShowCalendarViewAction(model: model)
    }
}

extension ITSelectedTimeTableViewCell: LabelSwitchDelegate {
    func switchChangToState(_ state: LabelSwitchState) {
        let isGregorian = state == .L ? true : false
        timeModel?.isGregorian = isGregorian
        setupContent(model: timeModel, indexPath: IndexPath())
        
        delegate?.didClickedOpenGregorianSwitchAction(isGregorian: isGregorian)
    }
}
