//
//  PageControllerReviews.swift
//  BistroStays
//
//  Created by NCT109 on 19/09/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let profileMenuChange = Notification.Name("reviewMenuChange")
    static let profileMenuChange1 = Notification.Name("reviewMenuChange1")
    static let setContainerHeight = Notification.Name("setContainerHeight")
}

class PageControllerProfile: UIPageViewController {
    
    var currentPage = 0
    
    @objc func menuChange(notification: Notification) {
        let data = notification.object as! [String: Any]
        guard let index = data["selectedMenu"] as? Int else { return }
        print("index : \(index)")
        turnToPage(index: index)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(menuChange(notification:)), name: .profileMenuChange, object: nil)
        setScrollDelegate()
        
        dataSource = self
        delegate = self
        self.turnToPage(index: 0)
    
        
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getViewController(withIdentifier: "BusinessProfileVC"),//"CustmrSideServcHistory"),
            self.getViewController(withIdentifier: "PortfolioVC"),
            self.getViewController(withIdentifier: "ReviewsVC"),
        ]
    }()
    
    private func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "ProfileProvider", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}
extension PageControllerProfile{
    
        func setScrollDelegate(){
            for subview in self.view.subviews {
                if let scrollView = subview as? UIScrollView {
                    scrollView.delegate = self
                    break;
                }
            }
        }
    
    func turnToPage(index: Int)
    {
        print(index)
        let controller = orderedViewControllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = orderedViewControllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
            print("current : \(currentIndex) : index : \(index)")
        }
        
        //self.configureDisplaying(viewController: controller)
        //currentPage = index
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension PageControllerProfile : UIPageViewControllerDataSource
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
extension PageControllerProfile : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        
        for (index,vc) in  orderedViewControllers.enumerated(){
            if pendingViewControllers.first == orderedViewControllers[index] {
                print("index: \(index), vc: \(vc)")
                NotificationCenter.default.post(name: .profileMenuChange, object: ["Pagevc_index":index] as [String:Any])
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
                    NotificationCenter.default.post(name: .profileMenuChange, object: ["Pagevc_index":index] as [String:Any])
                    break
                }
            }
        }
    }
}
extension PageControllerProfile:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
