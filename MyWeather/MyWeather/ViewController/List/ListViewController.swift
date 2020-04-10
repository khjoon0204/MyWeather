//
//  ListViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/06.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let CELL_HEIGHT: CGFloat = 100
    let PINCH_SCALE_ADD_DETAIL: CGFloat = 2
    let PINCH_SCALE_REMOVE_DETAIL: CGFloat = 1
    let PINCH_SCALE_TRANS_DETAIL: CGFloat = 2.5
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewC: ViewController{
        return parent as! ViewController
    }
    
    var touchTableIdx: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeathers()
        setup()
    }
    
    private func getWeathers(){
        WeatherDataManager.shared.loadWeatherArray { (success) in
            self.tableView.reloadData()
        }
        
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
    func showDetailAnim(orgFrame: CGRect, dest: UIView, animCompletion: @escaping () -> Void){
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
    
    var isTransDetail = false
}

extension ListViewController: UITableViewDragDelegate, UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
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
        if indexPath == touchTableIdx{
            //            print("changeHeight index=\(indexPath)")
            cell.constraintHeight.constant = CELL_HEIGHT * viewC.pinchGestureRecognizer.scale
        }
        else{ cell.constraintHeight.constant = CELL_HEIGHT }
    }
    
    func addDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchTableIdx,
            cell.constraintHeight.constant > CELL_HEIGHT,
            viewC.pinchGestureRecognizer.scale > PINCH_SCALE_ADD_DETAIL,
            viewC.pinchGestureRecognizer.scale < PINCH_SCALE_TRANS_DETAIL,
            cell.detailV.subviews.count <= 0
        {
            print("addDetailView indexPath=\(indexPath)")
            addDetailSnapshot(cell: cell)
        }
        else if indexPath != touchTableIdx{
//            print("removeDetailView indexPath=\(indexPath)")
            cell.detailV.subviews.map{$0.removeFromSuperview()}
        }
    }
    
    func addDetailSnapshot(cell: DetailHeaderTableViewCell){
        guard cell.detailV.subviews.count <= 0 else{return}
        if let snap = viewC.detailC.view.snapshotView(afterScreenUpdates: true){
            snap.contentMode = .top
            cell.detailV.addSubview(snap)
            snap.pinEdgesToSuperView()
        }
    }
    
    func transDetailView(indexPath: IndexPath, cell: DetailHeaderTableViewCell){
        if indexPath == touchTableIdx,
            viewC.pinchGestureRecognizer.state.rawValue >= 2,
            viewC.pinchGestureRecognizer.scale > PINCH_SCALE_TRANS_DETAIL,
            !isTransDetail,
            cell.detailV.subviews.count > 0
        {
            isTransDetail = true
            print(#function)
//            viewC.resetPinchGesture()
            
            DispatchQueue.main.async {
                self.tableView(self.tableView, didSelectRowAt: indexPath)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DetailHeaderTableViewCell{
            print("\(#function) indexPath=\(indexPath)")
            let idxPath = touchTableIdx ?? indexPath
            addDetailSnapshot(cell: cell)
            
            CAAnimation(duration: 1, animation: {
                cell.constraintHeight.constant = UIScreen.main.bounds.height
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }) { (complete) in
                    print("animation done!")
                }
                tableView.scrollToRow(at: idxPath, at: .top, animated: true)
            }) {
                print("CAAnimation complete!")
                self.viewC.translateToDetail(indexPath.row)
                self.isTransDetail = false
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

