//
//  OnBoardingVC.swift
//  Luxongo
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OnBoardingVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:OnBoardingVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: OnBoardingVC.identifier) as! OnBoardingVC
    }
    
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.transform = CGAffineTransform(scaleX:1.5, y: 1.5) //set value here
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSkip: BlackButton!
    
    
    var onBoardingPageViewController: OnBoardingPageVC? {
        didSet {
            onBoardingPageViewController?.onBoardingDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let overlayController = DTOverlayController(viewController: HomeVC.storyboardInstance)
//
//            // View controller is automatically dismissed when you release your finger
//            overlayController.dismissableProgress = 0.6
//
//            // Enable/disable pan gesture
//            //overlayController.isPanGestureEnabled = false
//
//            // Update top-left and top-right corner radius
//            //overlayController.overlayViewCornerRadius = 10
//
//            // Control the height of the view controller
//            overlayController.overlayHeight = .dynamic(0.8) // 80% height of parent controller
//            //overlayController.overlayHeight = .static(300) // fixed 300-point height
//            //overlayController.overlayHeight = .inset(50) // fixed 50-point inset from top
//
//            self.present(overlayController, animated: true, completion: nil)
//
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingPageViewController = segue.destination as? OnBoardingPageVC {
            self.onBoardingPageViewController = onBoardingPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        onBoardingPageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @objc func didChangePageControlValue() {
        onBoardingPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
        //if let btn = sender as? UIButton, btn.title(for: .normal) == "CONTINUE"{
        UserData.shared.setAppLaunch(isLaunch: true)
        popToRootViewController(animated: true)
        /*
        if UserData.shared.languageID.isEmpty{
            pushViewController(LanguageVC.storyboardInstance, animated: true)
        }else{
            popToRootViewController(animated: true)
        }*/
    }
    
}

extension OnBoardingVC: OnBoardingPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: OnBoardingPageVC,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: OnBoardingPageVC,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        if pageControl.currentPage == 2{
            UIView.transition(with: btnSkip, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.btnSkip.setTitleColor(Color.Purpel.textColor, for: .normal)
                self.btnSkip.setTitle("CONTINUE", for: .normal)
            }, completion: nil)
        }else{
            UIView.transition(with: btnSkip, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.btnSkip.setTitleColor(Color.Black.textColor, for: .normal)
                self.btnSkip.setTitle("SKIP", for: .normal)
            }, completion: nil)
        }
    }
    
}
