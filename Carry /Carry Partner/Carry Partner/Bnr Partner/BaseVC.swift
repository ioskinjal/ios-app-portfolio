//
//  BaseVC.swift
//  BooknRide
//
//  Created by NCrypted on 02/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit


class BaseVC: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return textField.resignFirstResponder()
//    }
    
    func openMenu(){
        if self.slideMenuController() != nil {
            self.slideMenuController()?.openLeft()
        }
    }
    
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func sharedAppDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func presentLocationAlert(){
        
        let throwAlert = Alert()
    
        throwAlert.showAlertWithLeftAndRightCompletionHandler(titleStr: appConts.const.LBL_LOCATION, messageStr: appConts.const.LBL_LOCATION_SERVICE_DISABLED, leftButtonTitle: appConts.const.sETTING, rightButtonTitle: appConts.const.bTN_OK, leftCompletionBlock: {
            
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                        // Checking for setting is opened or not
                        print("Setting is opened: \(success)")
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl!)
                }
            }
            
        }, rightCompletionBlock: {
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    func displayNetworkAlert(){
        
        stopIndicator()
        let alert = Alert()
        
        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: appConts.const.MSG_NETWORK, messageStr: appConts.const.MSG_NO_INTERNET, leftButtonTitle: appConts.const.bTN_OK, rightButtonTitle: appConts.const.sETTING, leftCompletionBlock: {
            
        }) {
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)

        }
    }
    
    
    func startIndicator(title:String){
        
        
        sharedAppDelegate().showLoader(title: title)
        
    }
    
    func stopIndicator(){
        
        sharedAppDelegate().hideLoader()
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

extension UIViewController {
    //MARK:- UIAlertController
    func alert(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            print("Youve pressed OK Button")
            completion()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func alert(title: String, message : String, actions:[String], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            
            let act = UIAlertAction(title: actions[i], style: .default, handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[String],style:[UIAlertActionStyle], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            
            let act = UIAlertAction(title: actions[i], style: style[i], handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
        
        //For iPad display actionsheet
        //alertController.popoverPresentationController?.sourceRect = button!.frame
        //alertController.popoverPresentationController?.sourceView = self.view
        
        //        self.present(alertController, animated: true, completion: nil)
    }
}
