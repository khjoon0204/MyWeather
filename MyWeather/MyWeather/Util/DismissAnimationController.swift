//
//  HorizontalDismissAnimationController.swift
//  checkinnow
//
//  Created by N17430 on 2019. 1. 15..
//  Copyright © 2019년 Interpark INT. All rights reserved.
//

import Foundation
import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let destinationFrame: CGRect
    
    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        snapshot.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true

        
        let duration = transitionDuration(using: transitionContext)
        print("Anim_Dismiss snapshot frame=[\(snapshot.frame) destinationFrame=[\(destinationFrame)] ]")
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//            snapshot.frame = self.destinationFrame
//        }) { (complete) in
//            toVC.view.isHidden = false
//            snapshot.removeFromSuperview()
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
        toVC.view.isHidden = false
        snapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    
}
