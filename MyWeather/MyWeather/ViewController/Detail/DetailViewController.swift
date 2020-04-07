//
//  DetailViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum CellType: Int {
        case weekly = 0
    }
    
    enum HeaderType: Int {
        case topHeader = 0
        case hourlyHeader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setup()
        
    }
    
    private func registerNib(){
        collectionView.register(UINib(nibName: "TopHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TopHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "HourlyHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HourlyHeaderCollectionReusableView")
        
    }
    
    private func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = WeatherCollectionViewFlowLayout()
          
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Cell Size
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 800)
    }
    
    /// Header Size
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerType = HeaderType(rawValue: section)
        switch headerType {
        case .topHeader:
            return CGSize(width: self.view.bounds.width, height: 200)
        case .hourlyHeader:
            return CGSize(width: self.view.bounds.width, height: 75)
        default: break
        }
        return .zero
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = CellType(rawValue: indexPath.row)
        switch cellType {
        case.weekly:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionViewCell", for: indexPath) as? WeeklyCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default: break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerType = HeaderType(rawValue: indexPath.section)
            switch headerType {
            case .topHeader:
                if let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopHeaderCollectionReusableView", for: indexPath) as? TopHeaderCollectionReusableView {
                  return v
                }
            case .hourlyHeader:
                if let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HourlyHeaderCollectionReusableView", for: indexPath) as? HourlyHeaderCollectionReusableView {
                  return v
                }
            default: break
            }
            
        default: break
        }
        return UICollectionReusableView()
    }
    
}

