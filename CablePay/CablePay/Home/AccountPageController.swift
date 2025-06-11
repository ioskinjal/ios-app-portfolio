//
//  VisitorPageViewController.swift
//  Dating Platform
//
//  Created by NCrypted Technologies on 24/09/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
protocol AccountPageControllerDelegate: class
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
    func accountPageController(visitorPageViewController: AccountPageController,
                                   didUpdatePageCount count: Int)
    func accountPageController(visitorPageViewController: AccountPageController,
                                   didUpdatePageIndex index: Int)
}
class AccountPageController: UIPageViewController {
    weak var pageViewControllerDelegate: AccountPageControllerDelegate?
    var VC = ["AccountVC","AccountVC","AccountVC"]
    
    lazy var controllers: [UIViewController] = {
        
        let storyboard = StoryBoard.main
        var controllers = [UIViewController]()
        
        for (index,vc) in VC.enumerated() {
            if index == 0{
                let accountVC = AccountVC.storyboardInstance
                controllers.append(accountVC!)
            }else if index == 1{
                let accountVC = AccountVC.storyboardInstance
                controllers.append(accountVC!)
            }else{
                let accountVC = AccountVC.storyboardInstance
                controllers.append(accountVC!)
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
            if let accountVC =  vc as? AccountVC , viewController == accountVC{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("ProfileDetaile")
            }else if let accountVC =  vc as? AccountVC , viewController == accountVC{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("GallaryVC")
            }else if let accountVC =  vc as? AccountVC , viewController == accountVC{
                self.pageViewControllerDelegate?.turnPageController(to: index)
                print("GallaryVC")
            }
        }
    }
}


// MARK: - UIPageViewControllerDataSource

extension AccountPageController : UIPageViewControllerDataSource
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

extension AccountPageController : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        if let accountVC =  pendingViewControllers.first as? AccountVC{
            self.configureDisplaying(viewController: accountVC)
        }else if let accountVC =  pendingViewControllers.first as? AccountVC{
            self.configureDisplaying(viewController: accountVC)
        }else if let accountVC =  pendingViewControllers.first as? AccountVC{
            self.configureDisplaying(viewController: accountVC)
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
        {
            if !completed {
                if let accountVC =  pendingViewControllers.first as? AccountVC{
                    self.configureDisplaying(viewController: accountVC)
                    
                }else if let accountVC =  pendingViewControllers.first as? AccountVC{
                    self.configureDisplaying(viewController: accountVC)
                    
                }else if let accountVC =  pendingViewControllers.first as? AccountVC{
                    self.configureDisplaying(viewController: accountVC)
                    
                }
            }
        }
    }
}

