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
    
    let CELL_HEIGHT: CGFloat = 100
    
    var viewC: ViewController{
        return parent as! ViewController
    }
    
    var pinchIdx = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    private func setup(){
        tableView.delegate = self
        tableView.dataSource = self
                
    }
}


// MARK: TableView Delegate and DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell", for: indexPath) as? DetailHeaderTableViewCell{
            
            removeDetailView(indexPath: indexPath, cell: cell)
            addDetailView(indexPath: indexPath, cell: cell)
            changeHeight(indexPath: indexPath, cell: cell)
            transitionDetailView(indexPath: indexPath, cell: cell)
            
//            print("\(#function) gesture_state=\(pinchGestureRecognizer.state.rawValue)")
            return cell
        }
        return UITableViewCell()
    }
    
    func changeHeight(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx{
//            print(#function)
            cell.constraintHeight.constant = CELL_HEIGHT * viewC.pinchGestureRecognizer.scale
        }
    }
    
    func addDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx,
            cell.backV.subviews.count == 0,
        viewC.pinchGestureRecognizer.scale > 2{
            cell.backV.addSubview(viewC.detailC.view)
            viewC.detailC.view.pinEdgesToSuperView()
//            print(viewController.detailC.view.frame)
        }
    }
    
    func removeDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx,
            cell.backV.subviews.count > 0,
            viewC.pinchGestureRecognizer.scale <= 1{
            viewC.detailC.view.removeFromSuperview()
        }
    }
    
    func transitionDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx,
            cell.backV.subviews.count > 0,
            viewC.pinchGestureRecognizer.state.rawValue >= 2,
        viewC.pinchGestureRecognizer.scale > 3{
            self.viewC.translateToDetail()
             
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DetailHeaderTableViewCell{
            self.viewC.translateToDetail()
        }
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
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        present(searchVC, animated: true) {
            
        }
    }
    
    
    
}
