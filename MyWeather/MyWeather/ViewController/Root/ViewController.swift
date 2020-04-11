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
    
    private var listVC: ListViewController!
    var listViewController: ListViewController{
        get{return listVC}
    }
    private var detailPC: DetailPageController!
    var detailPageController: DetailPageController{
        get{return detailPC}
    }
    private var detailVCs: [DetailViewController] = []
    var detailViewControllers: [DetailViewController]{
        get{return detailVCs}
    }
    
    enum CurrentScreen {
        case list
        case detailpage
    }
    
    /// 현재 화면 상태값.
    private var curScreen: CurrentScreen = .list
    var currentScreen: CurrentScreen{
        get{return curScreen}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherDataManager.shared.loadWeatherArray()
        self.setupVCs()
        self.translateToList()
    }
    
    private func setupVCs(){
        
        for i in WeatherDataManager.shared.weathers {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//            _ = vc.view
            vc.config(w: i)
            detailVCs.append(vc)
        }
        listVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        _ = listViewController.view
        detailPC = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as? DetailPageController
//        _ = detailPageController.view
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
        self.detailPageController.view.removeFromSuperview()
        addV(vc: self.detailPageController)
        self.detailPageController.setupPageViewController(initPageIndex)
        curScreen = .detailpage
    }
    
    func translateToList(){
        addV(vc: listViewController)
        self.detailPageController.removeFromParent()
        curScreen = .list
    }
    
    func resetPinchGesture(){
        pinchGestureRecognizer.isEnabled = false
        pinchGestureRecognizer.isEnabled = true
    }
    
    // MARK: - Function
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        tmpPinchScale = sender.scale
//        print("\(#function) screen=\(curScreen) scale=\(pinchGestureRecognizer.scale.rounded()) state=\(pinchGestureRecognizer.state.rawValue) isTranslating=\(listViewController.isTranslating)")
        if currentScreen == .list{
            guard !listViewController.isTranslating else{return}
            let touch = sender.location(in: listViewController.tableView)
            if let indexPath = listViewController.tableView.indexPathForRow(at: touch) {
//                print("touchIndex=\(indexPath)")
                if listViewController.touchIndex == nil{
                    listViewController.touchIndex = indexPath
                    let rect = listViewController.tableView.rectForRow(at: indexPath)
                    listViewController.touchCellRect = view.convert(rect, from: listViewController.tableView)
                }
                listViewController.tableView.reloadData()
            }
            if pinchGestureRecognizer.state.rawValue >= 3
            {
                listViewController.touchIndex = nil
                listViewController.tableViewtop.constant = 0
                print("pinchIdx 초기화!")
            }
        }
        else if currentScreen == .detailpage{
            translateToList()
            listViewController.listFromDetail(index: detailPageController.getPageIndex())
        }
    }
    
    private var tmpPinchScale: CGFloat = 1.0{
        didSet{
            isPinchZoomIn = (oldValue < tmpPinchScale)
        }
    }
    var isPinchZoomIn: Bool = false
    
}

