//
//  DetailViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let TOP_HEADER_HEIGHT: CGFloat = 200
    let HOURLY_HEADER_HEIGHT: CGFloat = 75
    let WEEKLY_HEIGHT: CGFloat = 800
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parentVC: DetailPageViewController{
        return self.parent as! DetailPageViewController
    }
    
    lazy var curPage: Int = {
        return self.parentVC.vcs.firstIndex(of: self)!
    }()
    
    enum CellType: Int {
        case weekly = 0
        case count
    }
    
    enum HeaderType: Int {
        case topHeader = 0
        case hourlyHeader
        case count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("DetailView curPage=\(curPage)")
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
        return HeaderType.count.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CellType.count.rawValue
    }
    
    /// Cell Size
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: WEEKLY_HEIGHT)
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
            return CGSize(width: self.view.bounds.width, height: TOP_HEADER_HEIGHT)
        case .hourlyHeader:
            return CGSize(width: self.view.bounds.width, height: HOURLY_HEADER_HEIGHT)
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

