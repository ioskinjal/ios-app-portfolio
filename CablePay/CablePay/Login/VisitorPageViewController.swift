//
//  VisitorPageViewController.swift
//  Dating Platform
//
//  Created by NCrypted Technologies on 24/09/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
protocol VisitoPageViewControllerDelegate: class
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
    func visitorPageViewController(visitorPageViewController: VisitorPageViewController,
                                    didUpdatePageCount count: Int)
    func visitorPageViewController(visitorPageViewController: VisitorPageViewController,
                                    didUpdatePageIndex index: Int)
}
class VisitorPageViewController: UIPageViewController {
    weak var pageViewControllerDelegate: VisitoPageViewControllerDelegate?
    var VC = ["Login2VC","Login3VC","login4VC"]
    
    lazy var controllers: [UIViewController] = {
        
        let storyboard = StoryBoard.main
        var controllers = [UIViewController]()
        
        for (index,vc) in VC.enumerated() {
            if index == 0{
                let login2VC = Login2VC.storyboardInstance
                controllers.append(login2VC!)
            }else if index == 1{
                let login3VC = Login3VC.storyboardInstance
                controllers.append(login3VC!)
            }else{
                let login4VC = Login4VC.storyboardInstance
                controllers.append(login4VC!)
            }
        }
        
        self.pageViewControllerDelegate?.setupPageController(numberOfPages: controllers.count)
        
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.turnToPage(index: 0)
        
        
    }
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewController.NavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        
        self.configureDisplaying(viewController: controller)
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated() {
            if let login2Vc =  vc as? Login2VC , viewController == login2Vc{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("ProfileDetaile")
            }else if let login3VC =  vc as? Login3VC , viewController == login3VC{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("GallaryVC")
            }else if let login4VC =  vc as? Login4VC , viewController == login4VC{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("GallaryVC")
            }
        }
    }
}


// MARK: - UIPageViewControllerDataSource

extension VisitorPageViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index-1]
            }
        }
        
        return nil//controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        
        return nil //controllers.first
    }
}

extension VisitorPageViewController : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        if let login2Vc =  pendingViewControllers.first as? Login2VC{
            self.configureDisplaying(viewController: login2Vc)
        }else if let login3VC =  pendingViewControllers.first as? Login3VC{
            self.configureDisplaying(viewController: login3VC)
        }else if let login4VC =  pendingViewControllers.first as? Login4VC{
            self.configureDisplaying(viewController: login4VC)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !completed {
            if let login2Vc =  pendingViewControllers.first as? Login2VC{
                self.configureDisplaying(viewController: login2Vc)
               
            }else if let login3VC =  pendingViewControllers.first as? Login3VC{
                self.configureDisplaying(viewController: login3VC)
               
            }else if let login4VC =  pendingViewControllers.first as? Login4VC{
                self.configureDisplaying(viewController: login4VC)
                
            }
        }
        }
    }
}

