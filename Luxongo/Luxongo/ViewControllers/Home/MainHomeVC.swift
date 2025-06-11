//
//  MainHomeVC.swift
//  Luxongo
//
//  Created by admin on 7/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MainHomeVC: UIViewController {

    //MARK: Variables
    var currentEventTypeVC:UIViewController?
    var selectedMenu = 1
    
    //MARK: Properties
    static var storyboardInstance:MainHomeVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: MainHomeVC.identifier) as! MainHomeVC
    }
    
    @IBOutlet weak var btnHome: UIButton!{
        didSet{
            self.btnHome.tag = 1
            self.btnHome.setImage(#imageLiteral(resourceName: "BMhome"), for: .selected)
        }
    }
    @IBOutlet weak var btnMyEvent: UIButton!{
        didSet{
            self.btnMyEvent.tag = 2
            self.btnMyEvent.setImage(#imageLiteral(resourceName: "BMcalendar"), for: .selected)
        }
    }
    @IBOutlet weak var btnProfile: UIButton!{
        didSet{
            self.btnProfile.tag = 3
            self.btnProfile.setImage(#imageLiteral(resourceName: "BMprofile"), for: .selected)
        }
    }
    @IBOutlet weak var btnMore: UIButton!{
        didSet{
            self.btnMore.tag = 4
            self.btnMore.setImage(#imageLiteral(resourceName: "BMmenu"), for: .selected)
        }
    }
    @IBOutlet weak var rootContainerView: UIView!
    @IBOutlet weak var viewBottom: UIView!{
        didSet{
            self.viewBottom.shadow(Offset:  CGSize(width: 0, height: -5), redius: 5, opacity: 0.1, color: UIColor.gray)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMenu(num: 1)
    }
    
    
    @IBAction func onClickBottomBtn(_ sender: UIButton) {
        isFromMenu = false
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    func selectionMenu(num: Int) {
        btnHome.isSelected = false
        btnMyEvent.isSelected = false
        btnProfile.isSelected = false
        btnMore.isSelected = false
        selectedMenu = num
        switch num {
        case 1:
            print("Home")
            btnHome.isSelected = true
            loadView(vc: HomeVC.storyboardInstance)
        case 2:
            print("MyEvent")
            btnMyEvent.isSelected = true
            loadView(vc: MyEventsVC.storyboardInstance)
        case 3:
            print("Profile")
            btnProfile.isSelected = true
            loadView(vc: ProfileVC.storyboardInstance)
        case 4:
            print("More")
            btnMore.isSelected = true
            loadView(vc: DashBoardVC.storyboardInstance)
        default:
            print("No menu selection");break
        }
    }

}

//MARK: Custom function
extension MainHomeVC{
    
    func loadView(vc: UIViewController, isRightToLeft:Bool = true) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                //self.rootContainerView.swipeAnimation(direction: ( isRightToLeft ? .rightToLeft : .leftToRight ))
        }
    }
    
}
