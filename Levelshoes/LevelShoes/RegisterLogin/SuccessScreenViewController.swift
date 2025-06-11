//
//  SuccessScreenViewController.swift
//  LevelShoes
//
//  Created by apple on 4/28/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SuccessScreenViewController: UIViewController {
     var isCommingFromHomeScreen = false
    @IBOutlet weak var _lblDeatil: UILabel!{
        didSet{
            _lblDeatil.text = "resDesc".localized
            _lblDeatil.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var _lblTitle: UILabel!{
        didSet{
            _lblTitle.text = "registerSuccess".localized
        }
    }
    static var storyboardInstance:SuccessScreenViewController? {
              return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: SuccessScreenViewController.identifier) as? SuccessScreenViewController
              
          }
    @IBOutlet weak var createBtn: UIButton!
          {
              didSet{
                createBtn.setTitle("start_shopping".localized, for: .normal)
                createBtn.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
              }
          }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onClickShoppingBtn(_ sender: Any) {
        let viewController = LatestHomeViewController.storyboardInstance!
                                
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)

                              let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                              nextViewController.selectedIndex = 0
                              nextViewController.tabBar.isHidden = true

       
        if  self.isCommingFromHomeScreen {
              self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: Notification.Name(notificationName.LetGO_LOGIN_TO_HOME), object: nil)
     
        }else{
             self.navigationController?.popToRootViewController(animated: true)
        }

    }
    @IBAction func onClickClose(_ sender: Any) {
           self.dismiss(animated: true) {
             self.navigationController?.popToRootViewController(animated: true)
           // self.navigationController?.pushViewController(LatestHomeViewController.storyboardInstance!, animated: true)
               
           }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
