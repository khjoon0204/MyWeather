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
    final let PINCH_SCALE_TRANSLATE: CGFloat = 3.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewtop: NSLayoutConstraint!
    
    private var viewC: ViewController{
        return parent as! ViewController
    }
//    private var vcs: [DetailViewController]{
//        return viewC.detailViewControllers
//    }
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
    var pages: [DetailPageViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDetailVCObject()
        
//        getWeathers()
        setup()
    }
    
    private func createDetailVCObject(){
        pages.removeAll()
        for i in 0..<WeatherDataManager.shared.weathers.count {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let vc = DetailPageViewController()
//            vc.config(w: i)
            vc.setup(i)
            pages.append(vc)
        }
    }
    
//    private func getWeathers(){
//        WeatherDataManager.shared.loadWeatherArray { (success) in
//            self.tableView.reloadData()
//        }
//        // 임시: - 하루API 조회 제한
////        WeatherDataManager.shared.updateWeatherArray { (success) in
////            DispatchQueue.main.async {
////                WeatherDataManager.shared.sortBySeq()
////                self.tableView.reloadData()
////            }
////        }
//    }
    
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
//        guard vcs.count ?? 0 > 0 else {return}
//        if let v = vcs[indexPath.row].view{
////            print("addDetailView indexPath=\(indexPath)")
//            v.removeFromSuperview()
//            cell.detailV.addSubview(v)
//            v.pinEdgesToSuperView()
//        }
        
        
        let vc = pages[indexPath.row]
        if let v = vc.view{
                        print("addDetailView indexPath=\(indexPath)")
            v.removeFromSuperview()
            cell.detailV.addSubview(v)
            v.pinEdgesToSuperView()
        }
        
//        let vc0 = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
////        vc0.view.backgroundColor = UIColor.blue
////        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
////        lb.text = "Hi, World!"
////        vc0.view.addSubview(lb)
//
//        let vc1 = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
////        vc1.view.backgroundColor = UIColor.red
////        let lb1 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
////        lb1.text = "Hello, World!"
////        vc1.view.addSubview(lb1)
//
//        let vc = UIPageViewController()
//        vc.setViewControllers([indexPath.row % 2 == 0 ? vc0 : vc1], direction: .forward, animated: false, completion: nil)
//        if let v = vc.view{
//            v.backgroundColor = UIColor.brown
//            cell.detailV.addSubview(v)
//            v.pinEdgesToSuperView()
//        }
        
        
    }
      
    func transDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchIndex,
            viewC.isPinchZoomIn,
//            viewC.pinchGestureRecognizer.state.rawValue >= 2,
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
            
            touchCellRect = touchCellRect == .zero ? cell.frame : touchCellRect
//            print("touchCellRect=\(touchCellRect) cell.frame=\(cell.frame) self.tableViewtop.constant=\(self.tableViewtop.constant)")
            self.tableViewtop.constant = -self.touchCellRect.minY
            cell.constraintHeight.constant = UIScreen.main.bounds.height
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded() // update tableView
                self.tableView.beginUpdates() // should update cell in didSelectRowAt
                self.tableView.endUpdates()
            }) { (complete) in
                print("animation complete!")
//                self.viewC.translateToDetail(idxPath.row)
                self.isTranslating = false
                self.resetSelection()
//                tableView.reloadData()
                
                self.view.addSubview(cell.detailV)
                cell.detailV.pinEdgesToSuperView()
                self.view.bringSubviewToFront(cell.detailV)
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

