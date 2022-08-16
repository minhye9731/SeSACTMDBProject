//
//  WalkThroughViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

class WalkThroughViewController: UIPageViewController {
    
    var pageViewControllerList: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        createPageViewController()
        configurePageViewController()
        
    }
    
    func createPageViewController() {
        let sb = UIStoryboard(name: "WalkThrough", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: FirstViewController.reuseIdentifier) as! FirstViewController
        let vc2 = sb.instantiateViewController(withIdentifier: SecondViewController.reuseIdentifier) as! SecondViewController
        let vc3 = sb.instantiateViewController(withIdentifier: ThirdViewController.reuseIdentifier) as! ThirdViewController
        let vc4 = sb.instantiateViewController(withIdentifier: FourthViewController.reuseIdentifier) as! FourthViewController
        pageViewControllerList = [vc1, vc2, vc3, vc4]
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        guard let first = pageViewControllerList.first else { return }
        setViewControllers([first], direction: .forward, animated: true)
    }
}

// MARK: - pageviewcontroller 설정
extension WalkThroughViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    // after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    // count
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    // show current page
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        print("===", index)
        return index
    }
    
}

