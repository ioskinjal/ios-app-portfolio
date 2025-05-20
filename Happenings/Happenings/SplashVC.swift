//
//  SplashVC.swift
//  Happenings
//
//  Created by admin on 3/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    var isLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserData.shared.getUser()
        if user != nil{
            callCheckStatus()
        }else{
            Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
            let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenu") as! LeftSideMenu
            Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
            let navigation = Modal.sharedAppdelegate.window?.rootViewController as! UINavigationController
            navigation.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: false)
            Modal.sharedAppdelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    func callCheckStatus(){
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "action":"user-status"]
        
        Modal.shared.checkStatus(vc: self, param: param) { (dic) in
            print(dic)
            if dic["status"]as! Bool == true {
            self.redirectToVC()
            }else{
                UserData.shared.logoutUser()
                Modal.sharedAppdelegate.sideMenuController.hideLeftView()
                Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenu") as! LeftSideMenu
                Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
            }
        }
    }
    
    private func redirectToVC(){
        let user = UserData.shared.getUser()
        if (user != nil) {
            self.isLogin = true
        }
        Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
        let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenu") as! LeftSideMenu
        Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
        let navigation = Modal.sharedAppdelegate.window?.rootViewController as! UINavigationController
        navigation.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: false)
        Modal.sharedAppdelegate.window?.makeKeyAndVisible()
        //        }else{
        //            self.window?.rootViewController = StoryBoard.main.instantiateInitialViewController()
        //            self.window?.makeKeyAndVisible()
        //        }
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
