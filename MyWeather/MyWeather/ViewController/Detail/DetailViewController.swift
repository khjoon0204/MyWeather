//
//  DetailViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    final let TOP_HEADER_HEIGHT: CGFloat = 380
    final let HOURLY_HEADER_HEIGHT: CGFloat = 116
    final let WEEKLY_HEIGHT: CGFloat = 610
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var parentVC: DetailPageViewController{
        return self.parent as! DetailPageViewController
    }
    
    private var dt: OnecallWeather?
    
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
        print("DetailViewController viewDidLoad! name:\(dt?.title)")
        registerNib()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(#function) name:\(dt?.title)")
    }
    
    func registerNib(){
        collectionView.register(UINib(nibName: "TopHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TopHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "HourlyHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HourlyHeaderCollectionReusableView")
    }
    
    func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = WeatherCollectionViewFlowLayout()
    }
    
    //MARK: - public
    func config(w: OnecallWeather){
        dt = w
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HeaderType.count.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == HeaderType.topHeader.rawValue{return 0}
        else{return CellType.count.rawValue}
//        return section == 0 ? 0 : 1
        
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
//            print(#function)
            cell.config(OnecallWeather: self.dt)

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
                    v.config(OnecallWeather: dt)
                  return v
                }
            case .hourlyHeader:
                if let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HourlyHeaderCollectionReusableView", for: indexPath) as? HourlyHeaderCollectionReusableView {
                    v.config(OnecallWeather: dt)
                  return v
                }
            default: break
            }
            
        default: break
        }
        return UICollectionReusableView()
    }

}

