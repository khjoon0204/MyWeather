//
//  HorizontalPresentAnimationController.swift
//  checkinnow
//
//  Created by N17430 on 2019. 1. 15..
//  Copyright © 2019년 Interpark INT. All rights reserved.
//

import Foundation
import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from), // 이전 VC
            let toVC = transitionContext.viewController(forKey: .to), // 다음 VC
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) // 다음 VC SnapShot
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = originFrame
        
        // 다음 올 view 를 add 후, 그 위에 snapshot을 add 한다
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        print("Anim_Present snapshotFrame=[\(snapshot.frame) finalFrame=[\(finalFrame)] ]")

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            snapshot.frame = finalFrame
        }) { (complete) in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    
}
