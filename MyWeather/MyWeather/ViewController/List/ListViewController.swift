//
//  ListViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    let CELL_HEIGHT: CGFloat = 100
    
    //    var weathers: [OneWeather] = []
    
    var pageC: DetailPageController{
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as! DetailPageController
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self
        return vc
    }
    
    var pinchIdx: IndexPath?{
        didSet{
            if oldValue == nil{
                let rect = tableView.rectForRow(at: pinchIdx!)
                destFrame = CGRect(origin: rect.origin, size: UIScreen.main.bounds.size )
                print("destFrame=\(destFrame)")
            }
        }
    }
    
    var orgFrame = CGRect.zero
    var destFrame = CGRect.zero
    var fromDismiss = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(pageC)
        setup()

    }
    
    private func setup(){
        
        tableView.delegate = self
        tableView.dataSource = self
                
    }
    
//    private func addViewController(){
//        self.addChild(pageC)
//        self.contentView.addSubview(pageVC.view)
//        pageVC.view.pinEdgesToSuperView()
//    }

    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        let touch = sender.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touch) {
//            print("indexPath=\(indexPath) scale=\(sender.scale) state=\(sender.state.rawValue)")
            pinchIdx = indexPath
            tableView.reloadData()
            
        }
        
    }
    
}


// MARK: TableView Delegate and DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell", for: indexPath) as? DetailHeaderTableViewCell{
            transitionDetailView(indexPath: indexPath, cell: cell)
            addDetailView(indexPath: indexPath, cell: cell)
//            print("\(#function) gesture_state=\(pinchGestureRecognizer.state.rawValue)")
            return cell
        }
        return UITableViewCell()
    }
    
    func addDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if let idx = pinchIdx, indexPath == idx, cell.contentView.subviews.count == 0, pinchGestureRecognizer.scale > 2.0{
            cell.contentView.addSubview(pageC.view)
        }
    }
    
    func transitionDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if let idx = pinchIdx, indexPath == idx,
            cell.contentView.subviews.count > 0,
            pinchGestureRecognizer.state.rawValue >= 2,
        pinchGestureRecognizer.scale > 3{
            let rect = tableView.rectForRow(at: indexPath)
            orgFrame = CGRect(origin: rect.origin, size: UIScreen.main.bounds.size )
            present(pageC, animated: true, completion: nil)
//            pinchIdx = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DetailHeaderTableViewCell{
            print(#function)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("\(#function) gesture_state=\(pinchGestureRecognizer.state.rawValue)")
        if fromDismiss{
            fromDismiss = false
            return UIScreen.main.bounds.height
        }
        if let idx = pinchIdx, indexPath == idx{
            return CELL_HEIGHT * pinchGestureRecognizer.scale
        }
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView.loadFromNibNamed(nibNamed: "ListFooterView") as! ListFooterView
        footerV.dele = self
        return footerV
    }
    
}

extension ListViewController: ListFooterViewDelegate{
    func pressWeb(_ sender: UIButton) {
        print(#function)
    }
    
    func selectSegment(_ sender: UISegmentedControl) {
        print(#function)
    }
    
    func pressSearch(_ sender: UIButton) {
        print(#function)
    }
    
    
    
}

extension ListViewController: UIViewControllerTransitioningDelegate{
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimationController(originFrame: orgFrame)
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("pinchIdx=\(pinchIdx)")
//        fromDismiss = true
//        pinchGestureRecognizer.state = .changed
//        pinchGestureRecognizer.scale = 5
//        tableView.reloadData()
        return DismissAnimationController(destinationFrame: destFrame)
        
    }
    
}
