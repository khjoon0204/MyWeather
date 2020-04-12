//
//  TopHeaderCollectionReusableView.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class TopHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.name.center = CGPoint(x: -100, y: 0)
//
//        }, completion: nil)
    }
    
}
