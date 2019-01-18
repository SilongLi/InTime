//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import Foundation
import UIKit

open class CKActionSheetAnimation: CKAlertBaseAnimation {

    override func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)) as? CKAlertViewController
        alertViewController?.CK_backgroundView.alpha = 0.0
        var y: CGFloat = 0
        if alertViewController?.CK_ContainerView != nil {
            y = (alertViewController?.CK_ContainerView.frame.size.height)!
        }
        alertViewController?.CK_ContainerView.transform = CGAffineTransform(translationX: 0, y: y)
        let containerView = transitionContext.containerView
        containerView.addSubview((alertViewController?.view)!)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        alertViewController?.CK_backgroundView.alpha = 1.0
                        alertViewController?.CK_ContainerView.transform = CGAffineTransform(translationX: 0, y: 0) },
                       completion: { (_) in
                        UIView.animate(withDuration: 0.5, animations: {
                            alertViewController?.CK_ContainerView.transform = CGAffineTransform.identity
                        }, completion: { (_) in
                            transitionContext.completeTransition(true)
                        }) })
    }

    override func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)) as? CKAlertViewController
        var y: CGFloat = 0
        if alertViewController?.CK_ContainerView != nil {
            y = (alertViewController?.CK_ContainerView.frame.size.height)!
        }
        UIView.animate(withDuration: 0.25,
                       animations: {
                        alertViewController?.CK_backgroundView.alpha = 0.0
                        alertViewController?.CK_ContainerView.transform =  CGAffineTransform(translationX: 0, y: y) },
                       completion: { (_) in transitionContext.completeTransition(true) })
    }

}
