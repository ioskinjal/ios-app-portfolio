//
//  ChnagePasswordVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    static var storyboardInstance:ChangePasswordVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as? ChangePasswordVC
    }
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewEmailSettings: UIView!
    @IBOutlet weak var viewMembership: UIView!
    @IBOutlet weak var viewReviewReply: UIView!
    @IBOutlet weak var viewBusinessAdded: UIView!
    
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var btnMembershipPlan: UIButton!
    @IBOutlet weak var btnReplyOnReview: UIButton!
    @IBOutlet weak var btnnewBusiness: UIButton!
    @IBOutlet weak var viewNotificationSettings: UIView!
    @IBOutlet weak var txtReEnterPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnEmailSettings: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblBusinessAdded: UILabel!
 
    var strNewBus:String = "y"
    var strReplyReview:String = "y"
    var strRenewMembership:String = "y"
    var strNewbusiness:String?
    var strNewReview:String?
    var strNewMembership:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCancel.layer.borderColor = UIColor.init(hexString: "575EFA").cgColor
        //setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Change Password", action: #selector(onClickMenu(_:)), isRightBtn: false)
        onClickChangePassword(btnChangePassword)
        self.navigationBar.isHidden = true
        let user = UserData.shared.getUser()
        if user?.user_type == "2"{
            viewEmail.isHidden = true
//            viewReviewReply.isHidden = true
//            viewMembership.isHidden = true
//            lblBusinessAdded.text = "When new review is posted for the businesses owned by merchant"
        }else{
            callgetSettingsAPI()
        }
        
        
        
            if UserDefaults.standard.value(forKey: "new_business") != nil{
            if UserDefaults.standard.value(forKey: "new_business")as! String == "y"{
                btnnewBusiness.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                strNewBus = "y"
            }else{
                btnnewBusiness.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                strNewBus = "n"
            }
            
            if UserDefaults.standard.value(forKey: "reply_review")as! String == "y"{
                btnReplyOnReview.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                strReplyReview = "y"
            }else{
                btnReplyOnReview.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                strReplyReview = "n"
            }
            
            if UserDefaults.standard.value(forKey: "renew_membership")as! String == "y"{
                btnMembershipPlan.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                strRenewMembership = "y"
            }else{
                btnMembershipPlan.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                strRenewMembership = "n"
            }
            
        }
       
    }

    func callgetSettingsAPI(){
        let param = ["action":"saved_email_settings",
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            let dict:NSDictionary = dic["settings"] as! NSDictionary
            if dict.value(forKey: "new_business")as! String == "y"{
                self.btnnewBusiness.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                self.strNewBus = "y"
            }else{
                self.btnnewBusiness.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                self.strNewBus = "n"
            }
            
            if dict.value(forKey: "reply_review")as! String == "y"{
                self.btnReplyOnReview.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                self.strReplyReview = "y"
            }else{
                self.btnReplyOnReview.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                self.strReplyReview = "n"
            }
            
            if dict.value(forKey: "renew_membership")as! String == "y"{
                self.btnMembershipPlan.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                self.strNewMembership = "y"
            }else{
                self.btnMembershipPlan.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                self.strNewMembership = "n"
            }
            
            
        }
    }
    
    
  
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    @IBAction func onClickChangePassword(_ sender: UIButton) {
        self.viewNotificationSettings.isHidden = true
        self.viewChangePassword.isHidden = false
        self.viewEmailSettings.isHidden = true
    }
    @IBAction func onClickEmailSettings(_ sender: UIButton) {
        self.viewNotificationSettings.isHidden = false
        self.viewChangePassword.isHidden = true
        self.viewEmailSettings.isHidden = false
    }
    @IBAction func onClickMemberShipPlan(_ sender: UIButton) {
        if self.btnMembershipPlan.currentImage == #imageLiteral(resourceName: "On") {
            self.btnMembershipPlan.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
            strRenewMembership = "n"
        }else{
            strRenewMembership = "y"
            self.btnMembershipPlan.setImage(#imageLiteral(resourceName: "On"), for: .normal)
        }
    }
    @IBAction func onClickReplyOnReciew(_ sender: UIButton) {
        if self.btnReplyOnReview.currentImage == #imageLiteral(resourceName: "On") {
            self.btnReplyOnReview.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
            strReplyReview = "n"
        }else{
            strReplyReview = "y"
            self.btnReplyOnReview.setImage(#imageLiteral(resourceName: "On"), for: .normal)
        }
    }
    @IBAction func onClickNewBuisness(_ sender: UIButton) {
        if self.btnnewBusiness.currentImage == #imageLiteral(resourceName: "On") {
            self.btnnewBusiness.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
            strNewBus = "n"
        }else{
            self.btnnewBusiness.setImage(#imageLiteral(resourceName: "On"), for: .normal)
            strNewBus = "y"
        }
    }
    @IBAction func onClickSaveSettings(_ sender: UIButton) {
        let param = ["action":"notification_settings",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "new_business":strNewBus,
                     "reply_review":strReplyReview,
                     "renew_membership":strRenewMembership]
        
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
                UserDefaults.standard.set(self.strNewBus, forKey:"new_business")
                UserDefaults.standard.set(self.strReplyReview, forKey:"reply_review")
                UserDefaults.standard.set(self.strRenewMembership, forKey:"renew_membership")
                UserDefaults.standard.synchronize()
            })
        }
    }
    @IBAction func onClickSave(_ sender: UIButton) {
        if isValidated(){
            callChangePassword()
        }
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
    }
    
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtOldPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter current password"
        }
        else if (txtNewPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter new password"
        }
        else if (txtReEnterPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter confirm password"
        }
        else if txtNewPassword.text! != txtReEnterPassword.text! {
            ErrorMsg = "new password and confirm new password not match!"
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    func callChangePassword() {
        let param = [
            "action":"change_password",
            "user_id":UserData.shared.getUser()!.user_id,
            "old_password":txtOldPassword.text!,
            "new_password":txtNewPassword.text!,
            "confirm_password":txtReEnterPassword.text!
            ]
        Modal.shared.home(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
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
