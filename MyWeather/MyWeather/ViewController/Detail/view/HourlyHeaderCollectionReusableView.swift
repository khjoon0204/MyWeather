//
//  HourlyHeaderCollectionReusableView.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class HourlyHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dt: OnecallWeather?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerNib()
    }
    
    func registerNib(){
        collectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
    }
    
    func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func config(OnecallWeather d: OnecallWeather?){        
        dt = d
        setup()
    }
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        print("SecondHeader zPos=\(self.layer.zPosition)")
//    }
}

extension HourlyHeaderCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dt?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
        //            print(#function)
        cell.config(Hourly: dt?.hourly?[indexPath.row])
        return cell
    }
    
    
}
