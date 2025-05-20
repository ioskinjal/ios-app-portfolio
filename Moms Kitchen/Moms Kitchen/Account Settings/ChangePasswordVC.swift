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
    
    @IBOutlet weak var txtReEnterPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCancel.layer.borderColor = UIColor.init(hexString: "F20F30").cgColor
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Change Password", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
       
        
    }

    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    @IBAction func onClickSave(_ sender: UIButton) {
        if isValidated(){
            callChangePassword()
        }
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
