//
//  BottomPageViewController.swift
//  Dating Platform
//
//  Created by NCrypted Technologies on 15/09/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
protocol BottomPageViewControllerDelegate: class
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}
class BottomPageViewController: UIPageViewController {
    weak var pageViewControllerDelegate: BottomPageViewControllerDelegate?
    var VC = ["Account","Send","More","Request","Reports"]
    
    lazy var controllers: [UIViewController] = {
        
        let storyboard = StoryBoard.main
        var controllers = [UIViewController]()
        
        
        for (index,vc) in VC.enumerated() {
            if index == 0{
                    let accountVC = AccountVC.storyboardInstance
                    controllers.append(accountVC!)
            }else if index == 1{
//                let FavoriteVc = FavoriteVC.storyboardInstance
//                controllers.append(FavoriteVc!)
            }else if index == 2{
//                let LikeVc = ProfileVC.storyboardInstance
//                controllers.append(LikeVc!)
            }else if index == 3{
//                let MessageVc = MessageListVC.storyboardInstance
//                controllers.append(MessageVc!)
            }else if index == 4{
//                let SearchVc = ProfileVC.storyboardInstance
//                controllers.append(SearchVc!)
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
            if UserDefaults.standard.object(forKey: "IsInstall") as? Bool ?? false{
//            if let homevc =  vc as? HomeVC , viewController == homevc{
//                    self.pageViewControllerDelegate?.turnPageController(to: index)
//                    print("profileVc")
//                }
//            }else if let profileVc =  vc as? ProfileVC , viewController == profileVc{
//                    self.pageViewControllerDelegate?.turnPageController(to: index)
//                    print("profileVc")
//            }else if let favoritedMe =  vc as? FavoritedMeVC , viewController == favoritedMe{
//                self.pageViewControllerDelegate?.turnPageController(to: index)
//                print("favoritedMe")
//            }else if let likeVc =  vc as? ProfileVC , viewController == likeVc{
//                self.pageViewControllerDelegate?.turnPageController(to: index)
//                print("GallaryVC")
//            }else if let messageVC =  vc as? MessageListVC , viewController == messageVC{
//                self.pageViewControllerDelegate?.turnPageController(to: index)
//                print("messageVC")
//            }else if let searchVC =  vc as? ProfileVC , viewController == searchVC{
//                self.pageViewControllerDelegate?.turnPageController(to: index)
//                print("searchVC")
           }
        }
    }
}
extension BottomPageViewController : UIPageViewControllerDataSource
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

extension BottomPageViewController : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
//        if UserDefaults.standard.object(forKey: "IsInstall") as? Bool ?? false{
//            if let homevc = pendingViewControllers.first as? HomeVC{
//                self.configureDisplaying(viewController: homevc)
//            }
//        }else if let profileVc =  pendingViewControllers.first as? ProfileVC{
//            self.configureDisplaying(viewController: profileVc)
//        }else if let FavoritedMeVC =  pendingViewControllers.first as? FavoritedMeVC{
//            self.configureDisplaying(viewController: FavoritedMeVC)
//        }else if let likeVc =  pendingViewControllers.first as? ProfileVC{
//            self.configureDisplaying(viewController: likeVc)
//        }else if let messageVc =  pendingViewControllers.first as? MessageListVC{
//            self.configureDisplaying(viewController: messageVc)
//        }else if let searchVc =  pendingViewControllers.first as? ProfileVC{
//            self.configureDisplaying(viewController: searchVc)
//        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
//        if !completed {
//            if UserDefaults.standard.object(forKey: "IsInstall") as? Bool ?? false{
//                if let homevc = previousViewControllers.first as? HomeVC{
//                    self.configureDisplaying(viewController: homevc)
//                }
//            }else if let profileVc =  previousViewControllers.first as? ProfileVC{
//                self.configureDisplaying(viewController: profileVc)
//            }else if let FavoritedMeVC =  previousViewControllers.first as? FavoritedMeVC{
//                self.configureDisplaying(viewController: FavoritedMeVC)
//            }else if let likeVc =  previousViewControllers.first as? ProfileVC{
//                self.configureDisplaying(viewController: likeVc)
//            }else if let messageVc =  previousViewControllers.first as? MessageListVC{
//                self.configureDisplaying(viewController: messageVc)
//            }else if let searchVc =  previousViewControllers.first as? ProfileVC{
//                self.configureDisplaying(viewController: searchVc)
//            }
//        }
    }
}
