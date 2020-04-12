//
//  TopHeaderCollectionReusableView.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class TopHeaderCollectionReusableView: UICollectionReusableView {
    private var dt: OnecallWeather?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.name.center = CGPoint(x: -100, y: 0)
//
//        }, completion: nil)
    }
    
    func config(OnecallWeather d: OnecallWeather?){
        guard let d = d else { return }
        dt = d
        name.text = d.title
        guard let cur = d.current else { return }
        desc.text = cur.weather?.first?.weatherDescription
        let temp = isCelsius ? String(format: "%.0f", floor(cur.temp!)) : cur.temp?.toFahrenheit()
        temperature.text = "\(temp!)°"
    }
}
