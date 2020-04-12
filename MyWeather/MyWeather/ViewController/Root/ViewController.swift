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
    
    enum CurrentScreen {
        case list
        case detail
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
        initVCs(vc: listVC)
    }
    
    private func createVCObject(){
        listVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        addChild(listVC)
    }
    
    private func initVCs(vc: UIViewController){
        vc.view.removeFromSuperview()
        view.addSubview(vc.view) // viewDidLoad call
        vc.view.pinEdgesToSuperView()
    }
    
    func resetPinchGesture(){
        pinchGestureRecognizer.isEnabled = false
        pinchGestureRecognizer.isEnabled = true
    }
    
    // MARK: - Function
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        tmpPinchScale = sender.scale
        print("\(#function) screen=\(curScreen) scale=\(pinchGestureRecognizer.scale.rounded()) state=\(pinchGestureRecognizer.state.rawValue) isTranslating=\(listVC.isTranslating)")
        if currentScreen == .list{
            guard !listVC.isTranslating else{return}
            let touch = sender.location(in: listVC.tableView)
            if let indexPath = listVC.tableView.indexPathForRow(at: touch) {
//                print("touchIndex=\(indexPath)")
                if listVC.touchIndex == nil{
                    listVC.touchIndex = indexPath
                    let rect = listVC.tableView.rectForRow(at: indexPath)
                    listVC.touchCellRect = view.convert(rect, from: listVC.tableView)
                }
                listVC.tableView.reloadData()
            }
            if pinchGestureRecognizer.state.rawValue >= 3
            {
                listVC.resetSelection()
                print("pinchIdx 초기화!")
            }
        }
        else if currentScreen == .detail{
            listVC.showList()
        }
    }
    
    private var tmpPinchScale: CGFloat = 1.0{
        didSet{
            isPinchZoomIn = (oldValue < tmpPinchScale)
        }
    }
    var isPinchZoomIn: Bool = false
    
    func changeScreen(currentScreen screen: CurrentScreen){
        curScreen = screen
    }
    
}

