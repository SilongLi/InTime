//
//  CloudKeeper
//
//  Created by lisilong on 2018/8/15.
//  Copyright © 2018 lisilong. All rights reserved.
//

import Foundation
import UIKit

open class CKAlertNoAnimation: CKAlertBaseAnimation {

    override func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)) as? CKAlertViewController
        alertViewController?.CK_backgroundView.alpha = 1.0
        alertViewController?.CK_ContainerView.transform = CGAffineTransform.identity
        let containerView = transitionContext.containerView
        containerView.addSubview((alertViewController?.view)!)
        transitionContext.completeTransition(true)
    }

    override func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)) as? CKAlertViewController
        alertViewController?.CK_backgroundView.alpha = 0.0
        var y: CGFloat = 0
        if alertViewController?.CK_ContainerView != nil {
             y = (alertViewController?.CK_ContainerView.frame.size.height)!
        }
        alertViewController?.CK_ContainerView.transform = CGAffineTransform().translatedBy(x: 0, y: y)
        transitionContext.completeTransition(true)
    }

}
