//
//  DetailPageViewController.swift
//  MyWeather
//
//  Created by N17430 on 2020/04/07.
//  Copyright © 2020 hjoon. All rights reserved.
//

import UIKit

class DetailPageController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let pageVC = DetailPageViewController()
    
    fileprivate var viewC: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        addPageViewController()
        print(#function)
    }
    
    func addPageViewController(){
        self.addChild(pageVC)
        self.contentView.addSubview(pageVC.view)
        pageVC.view.pinEdgesToSuperView()
        
    }
    
    @IBAction func pressWeb(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func pressList(_ sender: Any) {
        viewC?.translateToList()
    }
    
    // MARK:- public
    func setupPageViewController(_ initPageIndex: Int = 0){
        pageVC.setup(initPageIndex)
    }
    
    func getPageIndex() -> Int{
        return pageControl.currentPage
    }
    
    
}

class DetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate{
    
    lazy var vcs = parentVC.viewC?.detailViewControllers ?? []
    
    var parentVC: DetailPageController{
        return self.parent as! DetailPageController
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup(_ initPageIndex: Int = 0){
        dataSource = self
        delegate = self
        
        parentVC.pageControl.numberOfPages = vcs.count
        parentVC.pageControl.currentPage = initPageIndex
        if vcs.count > 0{self.setViewControllers([vcs[initPageIndex]], direction: .forward, animated: false, completion: nil)} 
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = vcs.firstIndex(of: firstViewController as! DetailViewController) else{
            return
        }
        parentVC.pageControl.currentPage = firstViewControllerIndex
        print("currentpage \(parentVC.pageControl.currentPage)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcs.firstIndex(of: viewController as! DetailViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else{
            return vcs.last
        }
        guard vcs.count > previousIndex else{
            return nil
        }
        return vcs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcs.firstIndex(of: viewController as! DetailViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < vcs.count else{
            return vcs.first
        }
        guard vcs.count > nextIndex else{
            return nil
        }
        return vcs[nextIndex]
    }

    
}
