//
//  LandingPageVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit


class LandingPageVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    //MARK:- UIButton Click Events
    
    @IBAction func onClickExploreApp(_ sender: Any) {
        Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
        Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
        self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
    }
    @IBAction func onClickFood(_ sender: UIButton) {
        
        if sender.tag == 0 {
            toptitle = "Breakfast List"
        }else if sender.tag == 1{
            toptitle = "Lunch List"
        }
        else{
                toptitle = "Dinner List"
            }
        let nextVC = MenuListVC.storyboardInstance!
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
        let nextVC = LoginVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let nextVC = SignUpVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
