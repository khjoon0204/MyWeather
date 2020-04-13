//
//  ListFooterView.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit
protocol ListFooterViewDelegate {
    func selectSegment(_ sender: UISegmentedControl)
    func pressSearch(_ sender: UIButton)
    func pressWeb(_ sender: UIButton)
}
class ListFooterView: UIView {
    var dele: ListFooterViewDelegate?
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        dele?.selectSegment(sender)
    }
    @IBAction func pressSearch(_ sender: UIButton) {
        dele?.pressSearch(sender)
    }
    @IBAction func pressWeb(_ sender: UIButton) {
        dele?.pressWeb(sender)
    }

}
