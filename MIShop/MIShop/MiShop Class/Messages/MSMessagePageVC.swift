

import UIKit
protocol MSMessagePageVCDelegate: class
{
    func setupPageController(numberOfPages: CGFloat)
    func turnPageController(to index: Int)
}
class MSMessagePageVC: UIPageViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        self.turnToPage(index: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification), name: Notification.Name("JobspageIndexChange"), object: nil)
        // Do any additional setup after loading the view.
    }
    weak var pageViewControllerDelegate: MSMessagePageVCDelegate?
    
    
    
    var arrViewController:[UIViewController] = [MSInboxVC.instantiate(appStorybord: .Message),MSSentVC.instantiate(appStorybord: .Message),MSDeletedVC.instantiate(appStorybord: .Message)]
    
    
    lazy var controllers: [UIViewController] = {
        return arrViewController.enumerated().map({ (index,view) -> UIViewController? in
            return arrViewController[index] === view ? view : nil
        }) as! [UIViewController]
        self.pageViewControllerDelegate?.setupPageController(numberOfPages: CGFloat(arrViewController.count))
    }()
    
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        if let info = notification.userInfo!["index"] as? Int
        {
            turnToPage(index: info)
        }
    }
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first
        {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > index
            {
                direction = .reverse
            }
        }
        
        self.configureDisplaying(viewController: controller)
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated()
        {
            if let myjobs =  vc as? MSInboxVC , viewController == myjobs
            {
                self.pageViewControllerDelegate?.turnPageController(to: index)
            }
            else if let appliedJobs =  vc as? MSSentVC , viewController == appliedJobs
            {
                self.pageViewControllerDelegate?.turnPageController(to: index)
            }
            else if let appliedJobs =  vc as? MSDeletedVC , viewController == appliedJobs
            {
                self.pageViewControllerDelegate?.turnPageController(to: index)
            }
        }
    }
}


// MARK: - UIPageViewControllerDataSource

extension MSMessagePageVC : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController)
        {
            if index > 0
            {
                return controllers[index - 1]
            }
        }
        
        return nil//controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController)
        {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        
        return nil //controllers.first
    }
}

extension MSMessagePageVC : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        
        for (index,vc) in arrViewController.enumerated()
        {
            if pendingViewControllers.first == arrViewController[index]{
                print(vc as UIViewController)
                self.pageViewControllerDelegate?.turnPageController(to: index)
                break
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !completed {
            
            for (index,vc) in arrViewController.enumerated()
            {
                if previousViewControllers.first == arrViewController[index]
                {
                    print(vc as UIViewController)
                    self.pageViewControllerDelegate?.turnPageController(to: index)
                    break
                }
            }
        }
    }
}

