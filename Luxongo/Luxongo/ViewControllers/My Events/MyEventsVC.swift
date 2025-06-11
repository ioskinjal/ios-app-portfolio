//
//  MyEventsVC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var isFromMenu = false

class MyEventsVC: BaseViewController {
    
    //MARK: Variables
    var currentEventTypeVC:UIViewController?
    var selectedMenu = 1
    private let upperBound = 2 // Maximum tabbed page number
    
    //MARK: Properties
    static var storyboardInstance:MyEventsVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: MyEventsVC.identifier) as! MyEventsVC
    }
    
    //@IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnBack: UIButton!
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
    @IBOutlet weak var lblTittle: LabelBold!{
        didSet{
            if isFromMenu{
                lblTittle.text = "Saved Flyers"
            }else{
                btnBack.isHidden = true
                lblTittle.text = "My Flyers"
            }
        }
    }
    @IBOutlet weak var btnPast: BlackTabButton!{
        didSet{
            self.btnPast.tag = 1
        }
    }
    @IBOutlet weak var btnUpComing: BlackTabButton!{
        didSet{
            self.btnUpComing.tag = 2
        }
    }
    @IBOutlet weak var btnBootomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMenu(num: 1)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onClickPast(_ sender: UIButton) {
        if !sender.isSelected{
            
            selectionMenu(num: sender.tag)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickUpcoming(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
//    @IBAction func onClickAdd(_ sender: Any) {
//        pushViewController(CreateEventsVC.storyboardInstance, animated: true)
//    }
    
}

//MARK: Custom function
extension MyEventsVC{
    
    private func loadView(center point:CGPoint, vc: UIViewController) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                self.rootContainerView.swipeAnimation(direction: (self.btnBootomView.center.x < point.x ? .rightToLeft : .leftToRight), duration: 0.3)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.btnBootomView.center.x = point.x
                }, completion: nil)
        }
    }
    
    func selectionMenu(num: Int) {
        btnPast.isSelected = false
        btnUpComing.isSelected = false
        selectedMenu = num
        switch num {
        case 1:
            print("Past")
            btnPast.isSelected = true
            let vc = MyEventsListVC.storyboardInstance
             vc.selectedTab = .past
            loadView(center: btnPast.center, vc:vc)
        case 2:
            print("Upcoming")
            let vc = MyEventsListVC.storyboardInstance
            vc.selectedTab = .upComing
            loadView(center: btnUpComing.center, vc:vc)
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
//        switch selectedMenu {
//        case 1:
//            print("From Past")
//            selectedMenu = 2
//            selectionMenu(num: selectedMenu)
//        case 2:
//            print("From Upcoming")
//            selectedMenu = 1
//            selectionMenu(num: selectedMenu)
//        default:
//            break
//        }
    }
    
}

