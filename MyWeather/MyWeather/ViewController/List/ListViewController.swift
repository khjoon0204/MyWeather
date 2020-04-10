//
//  ListViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    final let CELL_HEIGHT: CGFloat = 100
    final let PINCH_SCALE_ADD_DETAIL: CGFloat = 2
    final let PINCH_SCALE_REMOVE_DETAIL: CGFloat = 1
    final let PINCH_SCALE_TRANSLATE: CGFloat = 3
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewC: ViewController{
        return parent as! ViewController
    }
    
    var touchIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeathers()
        setup()
    }
    
    private func getWeathers(){
        WeatherDataManager.shared.loadWeatherArray { (success) in
            self.tableView.reloadData()
        }
        // 임시: - 하루API 조회 제한
//        WeatherDataManager.shared.updateWeatherArray { (success) in
//            DispatchQueue.main.async {
//                WeatherDataManager.shared.sortBySeq()
//                self.tableView.reloadData()
//            }
//        }
    }
    
    private func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    // MARK:- public
    var isTranslating = false
    
    func listFromDetail(index i: Int){
        let idxPath = IndexPath(row: i, section: 0)
        touchIndex = idxPath
        
        viewC.pinchGestureRecognizer.scale = UIScreen.main.bounds.height / CELL_HEIGHT
        tableView.reloadData()
        tableView.scrollToRow(at: idxPath, at: .middle, animated: false)
    }
   
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableView Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell", for: indexPath) as? DetailHeaderTableViewCell{
            cell.config(data: WeatherDataManager.shared.weathers[indexPath.row])
            transDetailView(indexPath: indexPath, cell: cell)
            addDetailView(indexPath: indexPath, cell: cell)
            changeHeight(indexPath: indexPath, cell: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func changeHeight(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchIndex{
//            print("changeHeight index=\(indexPath) scale=\(viewC.pinchGestureRecognizer.scale.rounded())")
            cell.constraintHeight.constant = CELL_HEIGHT * max(viewC.pinchGestureRecognizer.scale, 1.0)
        }
        else{ cell.constraintHeight.constant = CELL_HEIGHT }
    }
    
    func addDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchIndex,
            cell.constraintHeight.constant > CELL_HEIGHT,
            viewC.pinchGestureRecognizer.scale > PINCH_SCALE_ADD_DETAIL,
//            viewC.pinchGestureRecognizer.scale < PINCH_SCALE_TRANSLATE,
            cell.detailV.subviews.count <= 0
        {
            print("addDetailView indexPath=\(indexPath)")
            addDetailSnapshot(cell: cell)
        }
        else if indexPath != touchIndex{
//            print("removeDetailView indexPath=\(indexPath)")
            cell.detailV.subviews.map{$0.removeFromSuperview()}
        }
    }
    
    private func addDetailSnapshot(cell: DetailHeaderTableViewCell){
        guard cell.detailV.subviews.count <= 0 else{return}
        if let snap = viewC.detailC.view.snapshotView(afterScreenUpdates: true){
            snap.contentMode = .top
            cell.detailV.addSubview(snap)
            snap.pinEdgesToSuperView()
        }
    }
    
    func transDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchIndex,
            viewC.isPinchZoomIn,
            viewC.pinchGestureRecognizer.state.rawValue >= 2,
            viewC.pinchGestureRecognizer.scale > PINCH_SCALE_TRANSLATE,
            !isTranslating,
            cell.detailV.subviews.count > 0
        {
            isTranslating = true
            print(#function)
            DispatchQueue.main.async {
                self.tableView(self.tableView, didSelectRowAt: indexPath)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DetailHeaderTableViewCell {
            print("\(#function) indexPath=\(indexPath)")
            let idxPath = touchIndex ?? indexPath
            addDetailSnapshot(cell: cell)
            
            CAAnimation(duration: 1, animation: {
                cell.constraintHeight.constant = UIScreen.main.bounds.height
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }) { (complete) in
                    //                    print("animation done!")
                }
                tableView.scrollToRow(at: idxPath, at: .top, animated: true)
            }) {
                //                print("CAAnimation complete!")
                self.viewC.translateToDetail(idxPath.row)
                self.isTranslating = false
                self.tableView.reloadData()
            }
        }        
    }
    
    // MARK: - UITableView Editing
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView.loadFromNibNamed(nibNamed: "ListFooterView") as! ListFooterView
        footerV.dele = self
        return footerV
    }
    
}

extension ListViewController: UITableViewDragDelegate, UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
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

