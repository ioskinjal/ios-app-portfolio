//
//  PageVC.swift
//  Explore Local
//
//  Created by NCrypted on 06/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let menuChange = Notification.Name("menuChange")
}


class PageVC: UIPageViewController {

    var currentPage = 0
    
    @objc func menuChange(notification: Notification) {
        let data = notification.object as! [String: Any]
        guard let index = data["selectedMenu"] as? Int else { return }
        turnToPage(index: index)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(menuChange(notification:)), name: .menuChange, object: nil)
        //setScrollDelegate()
        
        dataSource = self
        delegate = self
        
        self.turnToPage(index: 0)
        
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getViewController(withIdentifier: "SearchBusinessVC"),
                self.getViewController(withIdentifier: "PostedReviewsVC"),
                self.getViewController(withIdentifier: "FavouriteBusinessVC"),
                //self.getViewController(withIdentifier: "innerGalleryTabVC"),
                ]
    }()
    
    private func getViewController(withIdentifier identifier: String) -> UIViewController
    {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
       
    }
    
}

extension PageVC{
    
    func turnToPage(index: Int)
    {
        let controller = orderedViewControllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = orderedViewControllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        
        //self.configureDisplaying(viewController: controller)
        //currentPage = index
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension PageVC : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = orderedViewControllers.index(of: viewController) {
            if index > 0 {
                //currentPage = currentPage - 1
                return orderedViewControllers[index-1]
            }
        }
        return nil//controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = orderedViewControllers.index(of: viewController) {
            if index < orderedViewControllers.count - 1 {
                //currentPage = currentPage + 1
                return orderedViewControllers[index + 1]
            }
        }
        return nil //controllers.first
    }
}

extension PageVC : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        for (index,vc) in  orderedViewControllers.enumerated(){
            if pendingViewControllers.first == orderedViewControllers[index] {
                print("index: \(index), vc: \(vc)")
                NotificationCenter.default.post(name: .menuChange, object: ["Pagevc_index":index] as [String:Any])
                break
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !completed {
            for (index,vc) in  orderedViewControllers.enumerated(){
                if previousViewControllers.first == orderedViewControllers[index] {
                    print("index: \(index), vc: \(vc)")
                    NotificationCenter.default.post(name: .menuChange, object: ["Pagevc_index":index] as [String:Any])
                    break
                }
            }
        }
    }
}

