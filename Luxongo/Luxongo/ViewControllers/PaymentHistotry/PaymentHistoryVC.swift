//
//  PaymentHistoryVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PaymentHistoryVC: BaseViewController {

    //MARK: Variables
    var currentEventTypeVC:UIViewController?
    var selectedMenu = 1
    private let upperBound = 2 //Maximum page number
    
    
    //MARK: Properties
    static var storyboardInstance:PaymentHistoryVC {
        return (StoryBoard.paymentHistory.instantiateViewController(withIdentifier: PaymentHistoryVC.identifier) as! PaymentHistoryVC)
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnPaid: BlackTabButton!{
        didSet{
            self.btnPaid.tag = 1
        }
    }
    @IBOutlet weak var btnReceived: BlackTabButton!{
        didSet{
            self.btnReceived.tag = 2
        }
    }
    @IBOutlet weak var btnBootomView: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMenu(num: selectedMenu)
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickPaid(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    @IBAction func onClickReceived(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    
}


//MARK: Custom function
extension PaymentHistoryVC{
    
    private func loadView(center point:CGPoint, vc: UIViewController) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                self.rootContainerView.swipeAnimation(direction: (self.btnBootomView.center.x < point.x ? .rightToLeft : .leftToRight), duration: 0.3)
                print((self.btnBootomView.center.x < point.x ? "RtL" : "LtR"))
                UIView.animate(withDuration: 0.3, animations: {
                    self.btnBootomView.center.x = point.x
                }, completion: nil)
        }
    }
    
    func selectionMenu(num: Int) {
        btnPaid.isSelected = false
        btnReceived.isSelected = false
        
        selectedMenu = num
        switch num {
        case 1:
            print("btnPaid")
            btnPaid.isSelected = true
            let nextVC = PaymentHistoryListVC.storyboardInstance
            nextVC.selectedTab = .paid
            loadView(center: btnPaid.center, vc: nextVC)
        case 2:
            print("btnReceived")
            btnReceived.isSelected = true
            let nextVC = PaymentHistoryListVC.storyboardInstance
            nextVC.selectedTab = .received
            loadView(center: btnReceived.center, vc: nextVC)
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

