//
//  UIView+Extension.swift
//  checkinnow
//
//  Created by N17430 on 2018. 7. 31..
//  Copyright © 2018년 Interpark INT. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    /// 부모뷰 프레임에 맞추기. 동적 Autolayout
    func pinEdgesToSuperView(activeBottomAnchor: Bool = true) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        if activeBottomAnchor{bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true}        
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
}
