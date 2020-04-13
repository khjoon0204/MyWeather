//
//  WeatherCollectionViewFlowLayout.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class WeatherCollectionViewFlowLayout: UICollectionViewFlowLayout {
    final let TOP_HEADER_MINIMUM_HEIGHT: CGFloat = 120
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        attributes = []
        guard let collectionView = collectionView else { return }
        
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let headerIndexPath = IndexPath(item: 0, section: section)
            if let headerAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath)?.copy() {
                attributes.append(headerAttribute as! UICollectionViewLayoutAttributes)
            }
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                if let attribute = layoutAttributesForItem(at: indexPath)?.copy() {
                    attributes.append(attribute as! UICollectionViewLayoutAttributes)
                }
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let offset = collectionView?.contentOffset ?? CGPoint.zero
        let headers = attributes.filter { attribute -> Bool in
            return attribute.representedElementKind == UICollectionView.elementKindSectionHeader
        }
        guard let topHeader = headers.first, let secondHeader = headers.last else { return nil }
        let topHeaderDefaultSize = topHeader.frame.size
        topHeader.frame.size.height = max(TOP_HEADER_MINIMUM_HEIGHT, topHeaderDefaultSize.height - offset.y)
        topHeader.frame.origin.y = offset.y
        secondHeader.frame.origin.y = topHeader.frame.origin.y + topHeader.frame.size.height
        
        return attributes
    }
}
