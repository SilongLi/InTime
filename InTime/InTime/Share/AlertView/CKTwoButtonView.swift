//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import UIKit

/// 弹窗需要两个按钮时，请add这个View
/// 需要圆角需设置clipsToBounds和cornerRadius
open class CKTwoButtonView: UIView {

    public var leftButtonBlock: (() -> Void)?
    public var rightButtonBlock: (() -> Void)?

    lazy var horizontalLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        return view
    }()

    lazy var verticalLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        return view
    }()

    lazy var leftButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(leftButtonTouchAction), for: UIControl.Event.touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.setTitleColor(UIColor(red: 178/255.0, green: 149/255.0, blue: 89/255.0, alpha: 1.0), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(rightButtonTouchAction), for: UIControl.Event.touchUpInside)
        return button
    }()

    public init(leftTitle: String, rightTitle: String, lefeBlock: (() -> Void)?, rightBlock: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        self.addSubview(horizontalLine)
        self.addSubview(verticalLine)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.leftButtonBlock = lefeBlock
        self.rightButtonBlock = rightBlock
        self.leftButton.setTitle(leftTitle, for: UIControl.State.normal)
        self.rightButton.setTitle(rightTitle, for: UIControl.State.normal)
        horizontalLine.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        verticalLine.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.width.equalTo(0.5)
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
        }

        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(verticalLine.snp.left)
            make.height.equalTo(44)
            make.bottom.equalTo(self)
        }

        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.left.equalTo(verticalLine.snp.right)
            make.right.equalTo(self)
            make.height.equalTo(leftButton)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func leftButtonTouchAction() {
        guard leftButtonBlock != nil else {
            return
        }
        self.leftButtonBlock!()
    }

    @objc func rightButtonTouchAction() {
        guard rightButtonBlock != nil else {
            return
        }
        self.rightButtonBlock!()

    }

}
