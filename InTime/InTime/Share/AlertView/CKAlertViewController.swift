//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import UIKit
import SnapKit

public enum CKAlertStyle: Int {

    /// 底部弹出
    case CKAlertStyleActionSheet = 0

    /// 中心点对齐
    case CKAlertStyleAlert       = 1
}

public enum CKAlertAnimationStyle: Int {

    /// 渐现+弹出
    case CKAlertFadePop = 0

    /// 系统action view动画效果
    case CKActionSheetPop = 1

    /// 没有动画
    case CKAlertNoAnimationPop = 2
}

open class CKAlertViewController: UIViewController {

    var CK_ContainerView: UIView
    var CK_ViewStyle: CKAlertStyle
    var CK_AnimationStyle: CKAlertAnimationStyle
    var CK_Magin: CGFloat
    var CK_Magin_CenterY: CGFloat = 0.0
    var CK_ContentView_Height: CGFloat = 0.0
    var CK_showTime: TimeInterval = 0.0
    var CK_dismissTime: TimeInterval = 0
    var isCusAnimationTime: Bool = false
    
    public var clickBackgroundAction: (() -> Void)?

    ///可以实现以下blcok,对自己的视图，进行更精细的封装
    public var viewWillApper: (() -> Void)?
    public var viewDidApper: (() -> Void)?
    public var viewWillDisApper: (() -> Void)?
    public var viewDidDisApper: (() -> Void)?

    lazy var CK_backgroundView: UIControl = {
        var control = UIControl()
        control.isUserInteractionEnabled = true
        control.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        control.addTarget(self, action: #selector(backgroundViewAction), for: UIControl.Event.touchUpInside)
        return control
    }()

    public init(animationStyle: CKAlertAnimationStyle, alertStyle: CKAlertStyle, containerView: UIView, height: CGFloat = 0.0, margin: CGFloat) {
        self.CK_ViewStyle = alertStyle
        self.CK_AnimationStyle = animationStyle
        self.CK_ContainerView = containerView
        self.CK_Magin = margin
        self.CK_ContentView_Height = height
        super.init(nibName: nil, bundle: nil)
        self.providesPresentationContextTransitionStyle = false
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(CK_backgroundView)
        self.view.addSubview(CK_ContainerView)

        CK_backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        CK_ContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(CK_Magin)
            make.right.equalTo(self.view).offset(-CK_Magin)
        }
        if CK_ContentView_Height > 0.0 {
            CK_ContainerView.snp.makeConstraints { (make) in
                make.height.equalTo(CK_ContentView_Height)
            }
        }
        if self.CK_ViewStyle == .CKAlertStyleActionSheet {
            CK_ContainerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.view)
            }
        } else {
            CK_ContainerView.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.view).offset(CK_Magin_CenterY)
            }
        }
        self.view.layoutIfNeeded()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.viewWillApper != nil {
            self.viewWillApper!()
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewDidApper != nil {
            self.viewDidApper!()
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.viewWillDisApper != nil {
            self.viewWillDisApper!()
        }
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.viewDidDisApper != nil {
            self.viewDidDisApper!()
        }
    }

    func setAlertAnimation(showTime: TimeInterval, dismisssTime: TimeInterval) {
        self.CK_showTime = showTime
        self.CK_dismissTime = dismisssTime
        self.isCusAnimationTime = true
    }

    @objc func backgroundViewAction() {
        if clickBackgroundAction != nil {
            clickBackgroundAction!()
        }
    }

    open func showAlertViewController(inViewController: UIViewController?, complete: (() -> Void)?) {
        if inViewController != nil {
            if (inViewController?.presentedViewController) != nil {
                inViewController?.presentedViewController?.present(self, animated: true, completion: complete)
            } else {
                inViewController?.present(self, animated: true, completion: complete)
            }
        } else {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            rootViewController?.present(self, animated: true, completion: complete)
        }
    }

    open func hiddenAlertViewController(hiddenComplete: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.CK_backgroundView.alpha = 0
            self.CK_ContainerView.alpha = 0
            self.view.alpha = 0
        }) { (_) in
            self.dismiss(animated: true, completion: hiddenComplete)
        }
    }
}

extension CKAlertViewController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.CK_AnimationStyle {
        case .CKAlertFadePop:
            return CKAlertFadePopAnimation(isPresenting: true)
        case .CKActionSheetPop:
            return CKActionSheetAnimation(isPresenting: true)
        case .CKAlertNoAnimationPop:
            return CKAlertNoAnimation(isPresenting: true)
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.CK_AnimationStyle {
        case .CKAlertFadePop:
            if self.isCusAnimationTime {
              return CKAlertFadePopAnimation(isPresenting: false, showAnimationTime: CK_showTime, dismissAnimationTime: CK_dismissTime)
            }
            return CKAlertFadePopAnimation(isPresenting: false)
        case .CKActionSheetPop:
            if self.isCusAnimationTime {
                return CKActionSheetAnimation(isPresenting: false, showAnimationTime: CK_showTime, dismissAnimationTime: CK_dismissTime)
            }
            return CKActionSheetAnimation(isPresenting: false)
        case .CKAlertNoAnimationPop:
            if self.isCusAnimationTime {
                return CKAlertNoAnimation(isPresenting: false, showAnimationTime: CK_showTime, dismissAnimationTime: CK_dismissTime)
            }
            return CKAlertNoAnimation(isPresenting: false)
        }
    }

}
