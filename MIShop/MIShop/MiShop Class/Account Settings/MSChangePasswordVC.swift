//
//  MSChangePasswordVC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSChangePasswordVC: BaseViewController
{
    @IBOutlet var txtOldPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Change Password", action: #selector(btnSideMenuOpen))
       
    }
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSavePasswordClick(_ sender: Any) {
        callForgotPwdAPI()
    }
    func callForgotPwdAPI() {
        let param = [
            "user_id":UserData.shared.getUser()!.uId,
            "confirm_password":txtNewPassword.text!,
            "new_password":txtConfirmPassword.text!,
            "old_password":txtOldPassword.text!
        ]
        ModelClass.shared.changePassword(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                //self.navigationController?.popViewController(animated: true)
            })
        }
    }
    override func viewDidLayoutSubviews()
    {
        txtOldPassword.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtNewPassword.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtConfirmPassword.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtOldPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter old password"
        }
        else if (txtNewPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter new password"
        }
        else if (txtConfirmPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter confirm password"
        }
        else if txtConfirmPassword.text! != txtNewPassword.text! {
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

}
extension MSChangePasswordVC: UITextFieldDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            textField.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
}
