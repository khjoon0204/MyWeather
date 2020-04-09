//
//  DetailHeaderTableViewCell.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var nameV: UIView!
    @IBOutlet weak var detailV: UIView!
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(data w: OnecallWeather){
        cityName.text = w.title
    }
    
}
