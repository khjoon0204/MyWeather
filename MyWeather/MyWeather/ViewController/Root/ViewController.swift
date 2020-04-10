//
//  ViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    var listVC: ListViewController!
    var detailC: DetailBackController!

    enum CurrentPage {
        case list
        case detail
    }
    
    /// 현재 화면 상태값.
    private var curPage: CurrentPage = .list
    var currentPage: CurrentPage{
        get{return curPage}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVCs()
        translateToList()
    }

    private func setupVCs(){
        listVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        _ = listVC.viewIfLoaded
        detailC = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as? DetailBackController
        _ = detailC.viewIfLoaded
    }
    
    private func addV(vc: UIViewController){
        vc.removeFromParent()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.pinEdgesToSuperView()
    }
    
    // MARK: - Transition
    func translateToDetail(_ initPageIndex: Int = 0){
        resetPinchGesture()
        self.detailC.view.removeFromSuperview()
        addV(vc: self.detailC)
        self.detailC.setupPageViewController(initPageIndex)
        curPage = .detail
    }
    
    func translateToList(){
        addV(vc: listVC)
        self.detailC.removeFromParent()
        curPage = .list
    }
    
    func resetPinchGesture(){
        pinchGestureRecognizer.isEnabled = false
        pinchGestureRecognizer.isEnabled = true
    }
    
    // MARK: - Function
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        tmpPinchScale = sender.scale
//        print("\(#function) page=\(currentPage) scale=\(pinchGestureRecognizer.scale.rounded()) state=\(pinchGestureRecognizer.state.rawValue)")
        if currentPage == .list{
            guard !listVC.isTranslating else{return}
            let touch = sender.location(in: listVC.tableView)
            if let indexPath = listVC.tableView.indexPathForRow(at: touch) {
                if listVC.touchIndex == nil{listVC.touchIndex = indexPath}
                listVC.tableView.reloadData()
                if pinchGestureRecognizer.state.rawValue >= 3
                {
                    listVC.touchIndex = nil
                    print("pinchIdx 초기화!")
                }
            }
        }
        else if currentPage == .detail{
            translateToList()
            listVC.listFromDetail(index: detailC.getPageIndex())
        }
    }
    
    private var tmpPinchScale: CGFloat = 1.0{
        didSet{
            isPinchZoomIn = (oldValue < tmpPinchScale)
        }
    }
    var isPinchZoomIn: Bool = false
    
}

