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
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    let pageVC = DetailPageViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPageViewController()
                
    }
    
    func addPageViewController(){
        self.addChild(pageVC)
        self.contentView.addSubview(pageVC.view)
        pageVC.view.pinEdgesToSuperView()
    }
    
    func selectPage(page: Int){
        pageControl.currentPage = page
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        transitionListView()
    }
    
    func transitionListView(){
        if pinchGestureRecognizer.state.rawValue >= 1{
            dismiss(animated: true, completion: nil)
        }
    }
    
}

class DetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate{
    
    var vcs: [DetailViewController] = []
    
    var parentVC: DetailPageController{
        return self.parent as! DetailPageController
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        dataSource = self
        delegate = self
                
        /// Mock Data
        let detail1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let detail2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vcs = [detail1, detail2]
        
        parentVC.pageControl.numberOfPages = vcs.count
        
        self.setViewControllers([vcs.first!], direction: .forward, animated: false, completion: nil)
        
    }
    
    
    
    /// 페이지 이동
    /// - Parameters:
    ///   - pageViewController: <#pageViewController description#>
    ///   - viewController: <#viewController description#>
    /// - Returns: <#description#>
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("page viewControllerBefore")
        let index = vcs.firstIndex(of: viewController as! DetailViewController)
        guard index != NSNotFound && index != 0 else { return nil }
        let prevIndex = index! - 1
        let lastIndex = vcs.count - 1
        guard prevIndex >= 0 else { return vcs[lastIndex] }
        guard lastIndex + 1 > prevIndex else { return nil }
        return vcs[prevIndex]
    }
    
    /// 페이지 이동
    /// - Parameters:
    ///   - pageViewController: <#pageViewController description#>
    ///   - viewController: <#viewController description#>
    /// - Returns: <#description#>
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("page viewControllerAfter")
        let index = vcs.firstIndex(of: viewController as! DetailViewController)
        guard index != NSNotFound else { return nil }
        let nextIndex = index! + 1
        let count = vcs.count
        guard count > nextIndex else {return nil}
        return vcs[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("page didFinishAnimating finished=\(finished) transitionCompleted completed=\(completed) previousViewControllers=\(previousViewControllers)")
        // 이전페이지와 같은 페이지
        guard previousViewControllers.first != pageViewController.viewControllers?.first else {return}
        
        guard completed else {return}
        
        parentVC.pageControl.currentPage = 1 - vcs.firstIndex(of: previousViewControllers.first as! DetailViewController)!
    }
}
