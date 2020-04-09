//
//  SearchTableViewCell.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/09.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    var searchData: MKLocalSearchCompletion? {
        didSet {
            guard let city = searchData else {return}
            title.attributedText = highlightedText(
                city.title,
                inRanges: city.titleHighlightRanges,
                size: 17.0
            )
        }
    }
    
    private func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString? {
        let attributeText = NSMutableAttributedString(string: text)
        let boldFont = UIFont.systemFont(ofSize: size, weight: .bold)
        for value in ranges {
            attributeText.addAttribute(
                NSAttributedString.Key.font,
                value: boldFont,
                range: value.rangeValue
            )
        }
        return attributeText
    }
    
    func config(data: MKLocalSearchCompletion) {
        searchData = data
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
