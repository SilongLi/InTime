//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import UIKit

open class CKAlertCommonView: UIView {

    public var backgroundAction: (() -> Void)?
    public var animationStyle: CKAlertAnimationStyle
    public var alertStyle: CKAlertStyle
    public weak var alertViewController: CKAlertViewController?
    public var showTime = 0.25
    /// 弹窗高度
    public var contentViewHeight: CGFloat = 0.0
    /// y值偏移量
    public var contentViewY: CGFloat = 0.0

    public init(animationStyle: CKAlertAnimationStyle, alertStyle: CKAlertStyle) {
        self.animationStyle = animationStyle
        self.alertStyle = alertStyle
        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func showAlertView(inViewController: UIViewController, leftOrRightMargin: CGFloat, height: CGFloat = 0.0, _ centerY_Margin: CGFloat = 0.0) {
        let alertViewController = CKAlertViewController(animationStyle: self.animationStyle, alertStyle: self.alertStyle, containerView: self, height: height, margin: leftOrRightMargin)
        alertViewController.CK_Magin_CenterY = centerY_Margin + contentViewY
        alertViewController.CK_showTime = showTime
        alertViewController.CK_ContentView_Height = contentViewHeight
        self.alertViewController = alertViewController
        weak var weakSelf = self
        self.alertViewController?.clickBackgroundAction = {
            if weakSelf?.backgroundAction != nil {
                weakSelf?.backgroundAction!()
            }
        }
        self.alertViewController?.showAlertViewController(inViewController: inViewController, complete: nil)
    }

    open func hiddenAlertView() {
        self.alertViewController?.hiddenAlertViewController(hiddenComplete: nil)
    }

    open func hiddenAlertView(complete: @escaping () -> Void) {
        self.alertViewController?.hiddenAlertViewController(hiddenComplete: complete)
    }
}
