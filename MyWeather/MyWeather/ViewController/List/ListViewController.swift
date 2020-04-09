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
        getWeathers()
        setup()
    }
    
    func getWeathers(){
        WeatherDataManager.shared.loadWeatherArray { (success) in
            self.tableView.reloadData()
        }
        WeatherDataManager.shared.updateWeatherArray { (success) in
            DispatchQueue.main.async {
                WeatherDataManager.shared.sortBySeq()
                self.tableView.reloadData()
            }
        }
    }
    
    private func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
}

extension ListViewController: UITableViewDragDelegate, UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WeatherDataManager.shared.removeWeather(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            WeatherDataManager.shared.setWeathersSequence()
            WeatherDataManager.shared.saveWeatherArray()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = WeatherDataManager.shared.weathers[sourceIndexPath.row]
        WeatherDataManager.shared.removeWeather(at: sourceIndexPath.row)
        WeatherDataManager.shared.insertWeather(weather: movedObject, at: destinationIndexPath.row)
        WeatherDataManager.shared.setWeathersSequence()
        WeatherDataManager.shared.saveWeatherArray()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataManager.shared.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell", for: indexPath) as? DetailHeaderTableViewCell{
            
            cell.config(data: WeatherDataManager.shared.weathers[indexPath.row])
            
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
            cell.detailV.subviews.count == 0,
            viewC.pinchGestureRecognizer.scale > 2{
            cell.detailV.addSubview(viewC.detailC.view)
            viewC.detailC.view.pinEdgesToSuperView()
            //            print(viewController.detailC.view.frame)
        }
    }
    
    func removeDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx,
            cell.detailV.subviews.count > 0,
            viewC.pinchGestureRecognizer.scale <= 1{
            viewC.detailC.view.removeFromSuperview()
        }
    }
    
    func transitionDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == pinchIdx,
            cell.detailV.subviews.count > 0,
            viewC.pinchGestureRecognizer.state.rawValue >= 2,
        viewC.pinchGestureRecognizer.scale > 3{
            self.viewC.translateToDetail(indexPath.row)
             
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? DetailHeaderTableViewCell) != nil{
            self.viewC.translateToDetail(indexPath.row)
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
        searchVC.dele = self
        present(searchVC, animated: true) {}
    }
}

extension ListViewController: SearchViewControllerDelegate{
    func mksearchUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

