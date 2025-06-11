//
//  ViewController.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.updateUI_WithDelay {
            //self.googleLogin()
            //self.facebookLogin()
            self.linkedInLogin()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func facebookLogin(){
        FacebookSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
            if let errStr = errStr{
                print(errStr)
            }else{
                print(userInfo.firstName)
            }
        }
    }
    
    fileprivate func googleLogin(){
        GoogleSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
            if let errStr = errStr{
                print(errStr)
            }else{
                print(userInfo.firstName)
            }
        }
    }
    
    fileprivate func linkedInLogin(){
        LinkedInManager.shared.loginWithLinked { (userInfo, errStr) in
            print(userInfo.firstName)
            print(userInfo.proFileURL)
        }
    }
}

