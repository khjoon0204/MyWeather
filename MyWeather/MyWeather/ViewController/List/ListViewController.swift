//
//  ListViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    final let CELL_HEIGHT: CGFloat = 100.0
    final let PINCH_SCALE_TRANSLATE: CGFloat = 3.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewtop: NSLayoutConstraint!
    
    private var viewC: ViewController{
        return parent as! ViewController
    }
    
    private var detailPCs: [DetailPageController] = []
    var detailPageControllers: [DetailPageController]{
        get{return detailPCs}
    }
    
    var touchIndex: IndexPath?
    var touchCellRect: CGRect = .zero
    
    
//    lazy var pages: [DetailViewController] = {
//        let arr = [DetailViewController](repeating: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController, count: WeatherDataManager.shared.weathers.count)
//        for i in 0..<arr.count {
////            addChild(arr[i])
////            arr[i].setup(i)
//        }
//        return arr
//    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createDetailVCObject()
        WeatherDataManager.shared.updateWeatherArray { (complete) in
            DispatchQueue.main.async {
//                WeatherDataManager.shared.sortBySeq()
                self.tableView.reloadData()
            }
        }
        setup()
    }
    
    private func createDetailVCObject(){
        detailPCs.removeAll()
        for i in 0..<WeatherDataManager.shared.weathers.count {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPageController") as! DetailPageController
            detailPCs.append(vc)
        }
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
    private var detailIndex: Int = -1
    
    // MARK: - 뷰전환
    func showList(){
        guard let v = self.view.subviews.last else{return}
        self.view.subviews.last?.removeFromSuperview()
        self.viewC.changeScreen(currentScreen: .list)
//        showListAnim(animateComplete: nil)
        
//        viewC.pinchGestureRecognizer.scale = UIScreen.main.bounds.height / CELL_HEIGHT
////
////        tableView.reloadData()
////        tableView.beginUpdates()
////        tableView.endUpdates()
//        tableView.reloadData()
//        showListAnim { (complete) in
//            self.view.subviews.last?.removeFromSuperview()
//            self.viewC.changeScreen(currentScreen: .list)
//        }

        detailIndex = -1
        tableView.reloadData()
    }
    
    func showDetail(detailView v: UIView){
        viewC.changeScreen(currentScreen: .detail)
        self.view.addSubview(v)
        v.pinEdgesToSuperView()
        self.view.bringSubviewToFront(v)
    }
    
    func resetSelection(){
        touchIndex = nil
        touchCellRect = .zero
        tableViewtop.constant = 0
    }
       
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableView Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell", for: indexPath) as? DetailHeaderTableViewCell else { return UITableViewCell() }
        cell.config(data: WeatherDataManager.shared.weathers[indexPath.row])
        changeHeight(indexPath: indexPath, cell: cell)
        transDetailView(indexPath: indexPath, cell: cell)
        addDetailView(indexPath: indexPath, cell: cell)
        return cell
    }
    
    func changeHeight(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
//        guard detailIndex == -1 else{return}
        if indexPath == touchIndex{
            let dist = touchCellRect.minY * ((viewC.pinchGestureRecognizer.scale - 1) / PINCH_SCALE_TRANSLATE)
            cell.constraintHeight.constant = CELL_HEIGHT * max(viewC.pinchGestureRecognizer.scale, 1.0) + dist
            tableViewtop.constant = -dist
//            print("changeHeight index=\(indexPath) scale=\(viewC.pinchGestureRecognizer.scale.rounded()) touchCellY=\(touchCellY.rounded()) tableViewtop.constant=\(tableViewtop.constant)")
        }
        else{
            cell.constraintHeight.constant = CELL_HEIGHT
        }
    }
    
    func addDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        guard viewC.pinchGestureRecognizer.state.rawValue < 1 else {return}
        guard detailPCs.count > 0 else {return}
        let vc = detailPCs[indexPath.row]
        if let v = vc.view{
            print("addDetailView indexPath=\(indexPath)")
            v.removeFromSuperview()
            vc.dele = self
            vc.setupPageViewController(initPageIndex: indexPath.row)            
            cell.detailV.addSubview(v)
            v.pinEdgesToSuperView()
        }
    }
      
    func transDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchIndex,
            viewC.currentScreen == .list,
            viewC.isPinchZoomIn,
            viewC.pinchGestureRecognizer.state.rawValue >= 2,
            viewC.pinchGestureRecognizer.scale > PINCH_SCALE_TRANSLATE,
            !isTranslating
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
            self.showDetailAnim(cell: cell, indexPath: idxPath)
        }        
    }
    
    func showDetailAnim(cell: DetailHeaderTableViewCell, indexPath: IndexPath){
        guard let v = cell.detailV.subviews.first else { return }
        touchCellRect = touchCellRect == .zero ? cell.frame : touchCellRect
        //            print("touchCellRect=\(touchCellRect) cell.frame=\(cell.frame) self.tableViewtop.constant=\(self.tableViewtop.constant)")
        self.tableViewtop.constant = -self.touchCellRect.minY
        cell.constraintHeight.constant = UIScreen.main.bounds.height
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }) { (complete) in
            print("animation complete!")
            //                self.viewC.translateToDetail(idxPath.row)
            self.showDetail(detailView: v)
            self.isTranslating = false
            self.detailIndex = indexPath.row
            self.resetSelection()
        }
    }
    
    func showListAnim(animateComplete animComplete:((Bool) -> Void)?){
        let idxPath = IndexPath(row: detailIndex, section: 0)
        guard let cell = tableView.cellForRow(at: idxPath) as? DetailHeaderTableViewCell else{return}
        
        touchCellRect = touchCellRect == .zero ? cell.frame : touchCellRect
        addDetailView(indexPath: idxPath, cell: cell)
//        self.tableViewtop.constant = -self.touchCellRect.minY
//        cell.constraintHeight.constant = UIScreen.main.bounds.height
//        UIView.animate(withDuration: 1, animations: {
//            self.view.layoutIfNeeded()
//            self.tableView.beginUpdates()
//            self.tableView.endUpdates()
//        }) { (complete) in
//            print("animation complete!")
//            animComplete?(complete)
//        }
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
        isCelsius = (sender.selectedSegmentIndex == 0)
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
            self.createDetailVCObject()
            self.tableView.reloadData()
        }
    }
}

extension ListViewController: DetailPageControllerDelegate{
    func pressList(_ sender: Any) {
        showList()
    }
    
}
