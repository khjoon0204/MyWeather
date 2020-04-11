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
//    private var detailVCs: [DetailViewController] = []
//    var detailViewControllers: [DetailViewController]{
//        get{return detailVCs}
//    }
    
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
        self.createVCObject()
        
        self.translateToList()
        
    }
    
    private func createVCObject(){
//        createDetailVCObject()
        listVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        addChild(listVC)
        detailPC = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as? DetailPageController
        
    }
    
    
    // MARK: - Transition
    func translateToDetail(_ initPageIndex: Int = 0){
        resetPinchGesture()
        initVCs(vc: detailPC)
//        resetDetailVCs(toUIViewController: detailPC.pageVC)
//        createDetailVCObject()
        
//        detailPC.setupPageController(initPageIndex)
        view.sendSubviewToBack(listVC.view)
        curScreen = .detailpage
    }
    
    func translateToList(){
        initVCs(vc: listVC)
//        listVC.addChild(detailPC)
//        resetDetailVCs(toUIViewController: listVC)
//        createDetailVCObject()
        
//        listVC.tableView.reloadData()
        view.sendSubviewToBack(detailPC.view)
        curScreen = .list
    }
    
    private func initVCs(vc: UIViewController){
        vc.view.removeFromSuperview()
        view.addSubview(vc.view) // viewDidLoad call
        vc.view.pinEdgesToSuperView()
    }
    
//    private func resetDetailVCs(toUIViewController toVC: UIViewController){
//        for vc in detailVCs {
//            vc.view.removeFromSuperview() // viewDidLoad call
//            vc.removeFromParent()
//        }
//    }
    
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
                listViewController.resetSelection()
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

