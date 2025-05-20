//
//  NotificationSettingVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class NotificationSettingVC: BaseViewController {

    static var storyboardInstance:NotificationSettingVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: NotificationSettingVC.identifier) as? NotificationSettingVC
    }
    
    @IBOutlet weak var btnCancelled: UIButton!
    @IBOutlet weak var btnInvoice: UIButton!
    @IBOutlet weak var btnDispatched: UIButton!
    @IBOutlet weak var btnPacked: UIButton!
    @IBOutlet weak var btnPlaced: UIButton!
    @IBOutlet weak var viewPlaced: UIView!
    @IBOutlet weak var viewPacked: UIView!
    @IBOutlet weak var viewDispatched: UIView!
    @IBOutlet weak var viewInvoice: UIView!
    
    @IBOutlet weak var viewCancelled: UIView!
    @IBOutlet weak var txtReEnterPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    var data:NotificationSetting?
    var orderPlaced : String = ""
    var orderPacked :  String = ""
    var orderDispatched :  String = ""
    var orderDelivered :  String = ""
    var orderCancelled :  String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Account Settings", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
         btnCancel.layer.borderColor = UIColor.init(hexString: "F20F30").cgColor
        
        callgetNotificationSettings()
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func callgetNotificationSettings() {
        let param  = ["uid":UserData.shared.getUser()!.user_id]
        Modal.shared.getNotificationSettings(vc: self, param: param) { (dic) in
            print(dic)
        self.data = NotificationSetting(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            
            if self.data?.orderPlaced == true {
                self.orderPlaced = "y"
                self.btnPlaced.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.orderPlaced = "y"
                
            }else{
                self.orderPlaced = "n"
                self.btnPlaced.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.orderPlaced = "n"
            }
            if self.data?.orderPacked == true {
                self.orderPacked = "y"
                 self.btnPacked.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }else{
                self.orderPacked = "n"
                self.btnPacked.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
            if self.data?.orderDispatched == true {
                self.orderDispatched = "y"
                 self.btnDispatched.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }else{
                self.orderDispatched = "n"
                self.btnDispatched.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
            if self.data?.orderDelivered == true {
                 self.btnInvoice.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.orderDelivered = "y"
            }else{
                self.orderDelivered = "n"
                self.btnInvoice.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
            if self.data?.orderCancelled == true {
                self.orderCancelled = "y"
                 self.btnCancelled.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }else{
                self.orderCancelled = "n"
                self.btnCancelled.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
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
    
    @IBAction func onClickSave(_ sender: UIButton) {
        if isValidated(){
            callChangePassword()
        }
    }
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            "email":UserData.shared.getUser()!.email_id,
            "old_password":txtOldPassword.text!,
            "new_password":txtNewPassword.text!,
            ]
        Modal.shared.changePassword(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    @IBAction func onClickSettings(_ sender: UIButton) {
        let button = sender
        if button.tag == 0{
            if orderPlaced == "n"{
                button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                orderPlaced = "y"
                }else{
                button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                orderPlaced = "n"
            }
        }else if button.tag == 1{
            if orderPacked == "n" {
                button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                orderPacked = "y"
            }else{
                orderPacked = "n"
                button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
            
        }else if button.tag == 2{
            if orderDispatched == "n" {
                button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                orderDispatched = "y"
            }else{
                orderDispatched = "n"
                button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
            
        }else if button.tag == 3{
            if orderDelivered == "n" {
                button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                orderDelivered = "y"
            }else{
                button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                orderDelivered = "n"
            }
            
        }else{
            if orderCancelled == "n" {
                orderCancelled = "y"
                button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }else{
                orderCancelled = "n"
                button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            }
        }
        callEditNotificationSettings()
    }
    
    func callEditNotificationSettings() {
        let param = ["uid":UserData.shared.getUser()!.user_id,
                     "orderPlaced":orderPlaced,
                     "orderPacked":orderPacked,
                     "orderDispatched":orderDispatched,
                     "orderDelivered":orderDelivered,
                     "orderCancelled":orderCancelled]
        Modal.shared.editNotificationSetting(vc: self, param: param) { (dic) in
            self.callgetNotificationSettings()
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
