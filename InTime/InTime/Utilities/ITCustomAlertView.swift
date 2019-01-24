//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import UIKit
import SnapKit

let TopIconTopoffset: CGFloat = 30
let TitleLabelTopOffset: CGFloat = 30
let titleLabelLeftAndRightOffset: CGFloat = 40
let detailLabelLeftAndRightOffset: CGFloat = 30
let TitleLabelHeight: CGFloat = 18
let DetailLabelTopOffset: CGFloat = 10
let horizonalLineTopOffset: CGFloat = 30
let buttonHeight: CGFloat = 50.0
let ContentIconHeight: CGFloat = 80

class ITCustomAlertView: CKAlertCommonView {

    public var isTwoButton: Bool? = true
    public var cancelButtonBlock: (() -> Void)?
    public var doneButtonBlock: (() -> Void)?
    public var detailLabelTopConstraint: Constraint?
    public var titleLabelHeightConstraint: Constraint?
    public var contentIconTopConstraint: Constraint?
    public var contentIconHeightConstraint: Constraint?
    
    var iconObserver: NSKeyValueObservation?
    var contentIconObserver: NSKeyValueObservation?
    var titleTextObserver: NSKeyValueObservation?
    var titleAttributeTextObserver: NSKeyValueObservation?
    var detailTextObserver: NSKeyValueObservation?
    var detailAttributeTextObserver: NSKeyValueObservation?

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var contentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("取消", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
        return button
    }()

    public lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("确定", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(doneAction), for: UIControl.Event.touchUpInside)
        return button
    }()

    public lazy var topIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    init(title: String = "",
         detailTitle: String = "",
         topIcon: UIImage? = nil,
         contentIcon: UIImage? = nil,
         isTwoButton: Bool = true,
         cancelAction: (() -> Void)? = nil,
         doneAction: (() -> Void)? = nil) {
        super.init(animationStyle: .CKAlertFadePop, alertStyle: .CKAlertStyleAlert)
        self.isTwoButton = isTwoButton
        self.cancelButtonBlock = cancelAction
        self.doneButtonBlock = doneAction

        commonInit()
        observeToUpdateConstraint()
        self.topIcon.image = topIcon
        self.contentIcon.image = contentIcon
        self.titleLabel.text = title
        self.detailLabel.text = detailTitle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        CommonTools.printLog(message: "----\(self.classForCoder) is dealloc ----")
    }

    func commonInit() {
        self.backgroundColor = UIColor.tintColor
        self.layer.cornerRadius = 7
        self.addSubview(topIcon)
        self.addSubview(titleLabel)
        self.addSubview(contentIcon)
        self.addSubview(detailLabel)
        self.addSubview(horizonalLineView)
        self.addSubview(doneButton)
        topIcon.snp.makeConstraints { (make) in
            make.top.equalTo(TopIconTopoffset)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topIcon.snp.bottom).offset(self.topIcon.image == nil ? 0 : TitleLabelTopOffset)
            make.left.equalTo(self).offset(titleLabelLeftAndRightOffset)
            make.right.equalTo(self).offset(-titleLabelLeftAndRightOffset)
        }
        contentIcon.snp.makeConstraints { (make) in
            self.contentIconTopConstraint = make.top.equalTo(self.titleLabel.snp.bottom).offset(20).constraint
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            self.contentIconHeightConstraint = make.height.equalTo(ContentIconHeight).constraint
        }

        detailLabel.snp.makeConstraints { (make) in
            self.detailLabelTopConstraint = make.top.equalTo(contentIcon.snp.bottom).offset(DetailLabelTopOffset).constraint
            make.left.equalTo(self).offset(detailLabelLeftAndRightOffset)
            make.right.equalTo(self).offset(-detailLabelLeftAndRightOffset)
            make.bottom.equalTo(horizonalLineView).offset(-horizonalLineTopOffset)
        }

        horizonalLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalTo(doneButton.snp.top)
        }

        if isTwoButton == true {
            self.addSubview(verticalLineView)
            verticalLineView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 0.5, height: buttonHeight-1))
                make.top.equalTo(horizonalLineView.snp.bottom)
                make.centerX.equalToSuperview()
            }
            self.addSubview(cancelButton)
            cancelButton.snp.makeConstraints({ (make) in
                make.top.equalTo(horizonalLineView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalTo(verticalLineView.snp.left)
                make.height.equalTo(buttonHeight-1)
            })

            doneButton.snp.makeConstraints({ (make) in
                make.top.equalTo(horizonalLineView.snp.bottom)
                make.right.equalToSuperview()
                make.left.equalTo(verticalLineView.snp.right)
                make.height.equalTo(buttonHeight-1)
                make.bottom.equalToSuperview()
            })
        } else {
            doneButton.snp.makeConstraints({ (make) in
                make.top.equalTo(horizonalLineView.snp.bottom)
                make.right.left.equalToSuperview()
                make.height.equalTo(buttonHeight-1)
                make.bottom.equalToSuperview()
            })
        }
    }

    func observeToUpdateConstraint() {
        iconObserver = topIcon.observe(\UIImageView.image) {[weak self] (imageView, _) in
            self?.titleLabel.snp.updateConstraints({ (make) in
                make.top.equalTo((self?.topIcon.snp.bottom)!).offset(imageView.image == nil ? 0 : TitleLabelTopOffset)
            })
        }
        contentIconObserver = contentIcon.observe(\UIImageView.image) {[weak self] (imageView, _) in
            self?.contentIconHeightConstraint?.update(offset: imageView.image == nil ? 0 : ContentIconHeight)
            self?.detailLabel.snp.updateConstraints({ (make) in
                make.top.equalTo((self?.contentIcon.snp.bottom)!).offset(imageView.image == nil ? 0 : 20)
            })
        }
        titleTextObserver = titleLabel.observe(\UILabel.text) { [weak self] (label, _) in
            let text = label.text
            guard text != nil else { return }
            if text?.isEmpty != true {
                self?.contentIconTopConstraint?.update(offset: 20)
                self?.titleLabelHeightConstraint?.update(offset: TitleLabelHeight)
            } else {
                self?.contentIconTopConstraint?.update(offset: 0)
                self?.titleLabelHeightConstraint?.update(offset: 0)
            }
        }

        titleAttributeTextObserver = titleLabel.observe(\UILabel.attributedText) {[weak self] (label, _) in
            let text = label.text
            guard text != nil else { return }
            if text?.isEmpty != true {
                self?.contentIconTopConstraint?.update(offset: 20)
            } else {
                self?.contentIconTopConstraint?.update(offset: 0)
            }
        }

        detailTextObserver = detailLabel.observe(\UILabel.text) { [weak self] (label, _) in
            let text = label.text
            guard text != nil else { return }
            if text?.isEmpty == true {
                self?.detailLabelTopConstraint?.update(offset: 0)
            } else {
                guard self?.titleLabel.text != nil else {
                    self?.detailLabelTopConstraint?.update(offset: 0)
                    return
                }
                if (self?.titleLabel.text?.isEmpty) == true {
                    self?.detailLabelTopConstraint?.update(offset: 0)
                } else {
                    self?.detailLabelTopConstraint?.update(offset: DetailLabelTopOffset)
                }
            }
        }

        detailAttributeTextObserver = detailLabel.observe(\UILabel.attributedText) {[weak self] (label, _) in
            let text = label.text
            guard text != nil else { return }
            if text?.isEmpty == true {
                self?.detailLabelTopConstraint?.update(offset: 0)
            } else {
                guard self?.titleLabel.text != nil else {
                    self?.detailLabelTopConstraint?.update(offset: 0)
                    return
                }
                if (self?.titleLabel.text?.isEmpty) == true {
                    self?.detailLabelTopConstraint?.update(offset: 0)
                } else {
                    self?.detailLabelTopConstraint?.update(offset: DetailLabelTopOffset)
                }
            }
        }
    }
}

extension ITCustomAlertView {
    @objc func doneAction() {
        self.hiddenAlertView()
        if let action = self.doneButtonBlock {
            action()
        }
    }

    @objc func cancelAction() {
        self.hiddenAlertView()
        if let action = self.cancelButtonBlock {
            action()
        }
    }
}
