//
//  ViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addVC(name: "ListViewController")
        
    }

    func addVC(name: String){
        if let vc = storyboard?.instantiateViewController(withIdentifier: name){
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.view.pinEdgesToSuperView()
        }
    }
    
    

}

