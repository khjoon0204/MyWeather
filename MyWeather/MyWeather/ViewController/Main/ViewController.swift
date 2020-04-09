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
    var detailC: DetailPageController!

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
        detailC = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as? DetailPageController
        _ = detailC.viewIfLoaded
    }
    
    private func addV(vc: UIViewController){
        vc.removeFromParent()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.pinEdgesToSuperView()
    }
    
    // MARK: - Transition
    func translateToDetail(){
        resetGesture()
        
        self.detailC.view.removeFromSuperview()
        addV(vc: self.detailC)
        
        curPage = .detail
    }
    
    func translateToList(){

        addV(vc: listVC)
        self.detailC.removeFromParent()
        
        curPage = .list
    }
    
    private func resetGesture(){
        pinchGestureRecognizer.isEnabled = false
        pinchGestureRecognizer.isEnabled = true
    }
    
    // MARK: - Function
    private func showDetailAnim(orgFrame: CGRect, dest: UIView, animCompletion: @escaping () -> Void){
        guard let snapshot = dest.snapshotView(afterScreenUpdates: true) else { return }
        snapshot.contentMode = .top
        snapshot.frame = orgFrame
        view.addSubview(snapshot)
//        snapshot.transform = CGAffineTransform.init(translationX: 0, y: 300)
        print("Anim_Present snapshotFrame=[\(snapshot.frame)]")
        UIView.animate(withDuration: 3, animations: {
            
            snapshot.frame = UIScreen.main.bounds
            
        }) { (complete) in
            snapshot.removeFromSuperview()
            animCompletion()
        }
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        print("\(#function) currentPage=\(currentPage) scale=\(pinchGestureRecognizer.scale) gesture_state=\(pinchGestureRecognizer.state.rawValue)")
        if currentPage == .list{
            let touch = sender.location(in: listVC.tableView)
            if let indexPath = listVC.tableView.indexPathForRow(at: touch) {
                //            print("indexPath=\(indexPath) scale=\(sender.scale) state=\(sender.state.rawValue)")
                listVC.pinchIdx = indexPath
                listVC.tableView.reloadData()
            }
        }
        else if currentPage == .detail{
            pinchGestureRecognizer.scale = 3
            translateToList()
        }
        
    }
    
    
}

