//
//  SlideUpVC.swift
//  Luxongo
//
//  Created by admin on 8/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SlideUpVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:SlideUpVC {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: SlideUpVC.identifier) as! SlideUpVC
    }
    var eventData:EventList?
    
    var currentEventTypeVC:UIViewController?
    var selectedMenu = 1
    private let upperBound = 4 //Maximum page number
    
    @IBOutlet weak var viewBuyNow: UIView!
    @IBOutlet weak var rootContainerView: UIView!{
        didSet{
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipped(gesture:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            rootContainerView.addGestureRecognizer(swipeLeft)
            
            let swipeLeft1 = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipped(gesture:)))
            swipeLeft1.direction = UISwipeGestureRecognizer.Direction.right
            rootContainerView.addGestureRecognizer(swipeLeft1)
        }
    }
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnDetails: UIButton!{
        didSet{
            btnDetails.tag = 1
        }
    }
    @IBOutlet weak var btnMap: UIButton!{
        didSet{
            btnMap.tag = 2
        }
    }
    @IBOutlet weak var btnOrganizer: UIButton!{
        didSet{
            btnOrganizer.tag = 3
        }
    }
    @IBOutlet weak var btnSimilar: UIButton!{
        didSet{
            btnSimilar.tag = 4
        }
    }
    @IBOutlet weak var btnBuyNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMenu(num: selectedMenu)
//        if eventData?.userid ?? "" == UserData.shared.getUser()?.userid ?? ""{
//            viewBuyNow.isHidden = true
//        }
        
        if let eventData = self.eventData{
            btnBuyNow.isHidden = eventData.is_past == "y" ? true : false
        }
        
    }
    
    @IBAction func onClickUp(_ sender: Any) {
        
    }
    
    @IBAction func onClickBuyNow(_ sender: Any) {
        //pushViewController(BuyNowVC.storyboardInstance, animated: true)
        dismiss(animated: true) {
            //parent.present(BuyNowVC.storyboardInstance, animated: true, completion: nil)
            outerloop: for vc in self.sharedAppdelegate.rootNavigation?.viewControllers ?? []{
                if vc is EventPreview{
                    let nextVC = BuyNowVC.storyboardInstance
                    nextVC.eventData = (vc as! EventPreview).eventData
                    vc.present(asPopUpView: nextVC)
                    break
                }
            }
        }
    }
    
    @IBAction func onClickTabbed(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
}


//MARK: Custom function
extension SlideUpVC{
    
    private func loadView(center point:CGPoint, vc: UIViewController) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                self.rootContainerView.swipeAnimation(direction: (self.bottomView.center.x < point.x ? .rightToLeft : .leftToRight), duration: 0.3)
                print((self.bottomView.center.x < point.x ? "RtL" : "LtR"))
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomView.center.x = point.x
                }, completion: nil)
        }
    }
    
    func selectionMenu(num: Int) {
        btnDetails.isSelected = false
        btnMap.isSelected = false
        btnOrganizer.isSelected = false
        btnSimilar.isSelected = false
        
        selectedMenu = num
        switch num {
        case 1:
            print("btnDetails")
            btnDetails.isSelected = true
            let nextVC = EventDetailVC.storyboardInstance
            loadView(center: btnDetails.center, vc: nextVC)
        case 2:
            print("btnMap")
            btnMap.isSelected = true
            let nextVC = EventMapVC.storyboardInstance
            loadView(center: btnMap.center, vc: nextVC)
        case 3:
            print("Draft")
            btnOrganizer.isSelected = true
            let nextVC = EventOrganizerVC.storyboardInstance
            loadView(center: btnOrganizer.center, vc: nextVC)
        case 4:
            print("Draft")
            btnSimilar.isSelected = true
            let nextVC = EventSimilarVC.storyboardInstance
            loadView(center: btnSimilar.center, vc: nextVC)
        default:
            print("No menu selection");break
        }
    }
    
    @objc func viewSwipped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                let pageLimit = UserData.shared.isRTL ? upperBound : 1
                if selectedMenu == pageLimit { return }
                changeMenu(isSwipeLeft: UserData.shared.isRTL)
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                let pageLimit = UserData.shared.isRTL ? 1 : upperBound
                if selectedMenu == pageLimit { return }
                changeMenu(isSwipeLeft: !UserData.shared.isRTL)
            default:
                break
            }
        }
    }
    
    func changeMenu(isSwipeLeft:Bool = true) {
        if isSwipeLeft{
            self.selectedMenu = min(upperBound, (self.selectedMenu + 1))
        }else{
            self.selectedMenu = max(1, (self.selectedMenu - 1))
        }
        selectionMenu(num: selectedMenu)
        
    }
    
}



