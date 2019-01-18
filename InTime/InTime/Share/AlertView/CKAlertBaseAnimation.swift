//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import Foundation
import UIKit

/**
 1.该类动画默认是.2s，如果有需要，可以自己重写
 2.该类默认的是系统自带的效果，如果有需要，继承该类，重写具体动画实现
 */
open class CKAlertBaseAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = false
    var showTime: TimeInterval = 0
    var dismissTime: TimeInterval = 0
    var isCustomeAnimationTimeFlag: Bool = false

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        self.isCustomeAnimationTimeFlag = false
        super.init()
    }

    init(isPresenting: Bool, showAnimationTime: TimeInterval, dismissAnimationTime: TimeInterval) {
        self.isPresenting = isPresenting
        self.showTime = showAnimationTime
        self.dismissTime = dismissAnimationTime
        self.isCustomeAnimationTimeFlag = true
        super.init()
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if isPresenting {
            self.presentAnimateTransition(transitionContext: transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext: transitionContext)
        }
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.isCustomeAnimationTimeFlag {
            if self.isPresenting {
                return self.showTime
            } else {
                return self.dismissTime
            }

        }
        if self.isPresenting {
            return 0.1
        }
        return 0.25
    }

    /// 子类需要重写 present
    ///
    /// - Parameter transitionContext: 动画上下文
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {

    }

    /// 子类需要重写 dismiss
    ///
    /// - Parameter transitionContext: 动画上下文
    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {

    }

}
