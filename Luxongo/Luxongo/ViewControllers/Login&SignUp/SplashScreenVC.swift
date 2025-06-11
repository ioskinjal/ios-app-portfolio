//
//  SplashScreenVC.swift
//  Luxongo
//
//  Created by admin on 7/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SplashScreenVC: BaseViewController {
    //MARK: Properties
    static var storyboardInstance:SplashScreenVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: SplashScreenVC.identifier) as! SplashScreenVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectionFlow()
    }
    

}

extension SplashScreenVC{
    
    private func redirectionFlow(){
        //FIXME: Logout forcefully
//        UserData.shared.logoutUser()
        
        //If Appislaunch first time
        if !UserData.shared.isAppLaunchFirstTime{
            pushViewController(OnBoardingVC.storyboardInstance, animated: true)
        }
        //if language is not select by the user
//        else if UserData.shared.languageID.isEmpty{
//            pushViewController(LanguageVC.storyboardInstance, animated: true)
//        }
        //If user is alreay login
        else if let _ = UserData.shared.getUser(){
            pushViewController(MainHomeVC.storyboardInstance, animated: true)
        }
        else{
            popViewController(animated: true)
        }
        
        //pushViewController(SelectOrganizerVC.storyboardInstance, animated: true)
        
        /*
        if !UserData.shared.isAppLaunchFirstTime{
            pushViewController(OnBoardingVC.storyboardInstance, animated: false)
        }else{
            //TODO: Language screen redirection or manage autologin with home screen rdirection
            pushViewController(LanguageVC.storyboardInstance, animated: false)
        }
        */
        
        /*
        if UserData.shared.languageID.isEmpty{
            self.navigationController?.pushViewController(LanguageVC.storyboardInstance, animated: false)
        }else{
            callAutoLogin(failer: {
                print("========AutoLogin fail")
            }) {
                // Verify User already login or not.
                if let user = UserData.shared.getUser() {
                    print(user.convertToDictionary!)
                    /*
                    if user!.isNoVerify.lowercased() == "y"{
                        print("========AutoLogin Done")
                        if user?.user_type == "c" {
                            print("Login=>Customer")
                            Modal.sharedAppdelegate.isCustomerLogin = true
                            Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                            Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
                        }
                        else{
                            print("Login=>Provider")
                            Modal.sharedAppdelegate.isCustomerLogin = false
                            Modal.sharedAppdelegate.sideMenuController.rootViewController = ProviderProfileVC.storyboardInstance!
                            Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
                        }
                        self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController!, animated: false)
                    }else{
                        let nextVC = LoginVC.storyboardInstance!
                        self.navigationController?.pushViewController(nextVC, animated: false)
                    }*/
                }else{
                    let nextVC = LoginVC.storyboardInstance!
                    self.navigationController?.pushViewController(nextVC, animated: false)
                }
            }
        }
        */
    }
    
}

/*

//MARK: API functions
extension SplashScreenVC{
    func callAutoLogin(failer:@escaping() -> () , success:@escaping() -> ()) {
        if let userData = UserData.shared.getAutoLoginData(), let _ = UserData.shared.getUser()?.userid{
            if userData.password.isBlank{ //Socila login
                /*
                Modal.shared.autoLoginAfterSocial(email: userData.email, failer: { (err) in
                    //"Response status code was unacceptable: 404."
                    print("Erro:\(err)")
                    if err != "The Internet connection appears to be offline." || err != "Could not connect to the server."{
                        if let user = UserData.shared.getUser(){
                            Modal.sharedAppdelegate.isCustomerLogin = (user.user_type == "c" ? true : false)
                        }
                        UserData.shared.logoutUser()
                        //let nextVC = LoginVC.storyboardInstance!
                        //self.navigationController?.pushViewController(nextVC, animated: false)
                        self.navigationController?.popToRootViewController(animated: false)
                        failer()
                    }
                }) { (dic) in
                    print(dic)
                    let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
                    _ = UserData.shared.setUser(dic: data)
                    success()
                }*/
            }else{ //Normal login
                /*
                Modal.shared.autoLogin(param: ["email": userData.email, "password": userData.password], failer: { (err) in
                    if err != "The Internet connection appears to be offline." || err != "Could not connect to the server."{
                        if let user = UserData.shared.getUser(){
                            Modal.sharedAppdelegate.isCustomerLogin = (user.user_type == "c" ? true : false)
                        }
                        UserData.shared.logoutUser()
                        //let nextVC = LoginVC.storyboardInstance!
                        //self.navigationController?.pushViewController(nextVC, animated: false)
                        self.navigationController?.popToRootViewController(animated: false)
                        failer()
                    }
                }) { (dic) in
                    print(dic)
                    let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
                    _ = UserData.shared.setUser(dic: data)
                    success()
                }*/
            }
        }
        else {
            let nextVC = LoginVC.storyboardInstance
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
}

*/
