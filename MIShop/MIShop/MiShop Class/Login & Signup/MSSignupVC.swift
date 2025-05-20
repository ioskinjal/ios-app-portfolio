//
//  MSSignupVC.swift
//  MIShop
//
//  Created by nct48 on 02/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSSignupVC: UIViewController
{
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
    }
    override func viewDidLayoutSubviews()
    {
        txtFirstName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtLastName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtEmail.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtPassword.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtUserName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
   
    @IBAction func btnSignUpClick(_ sender: Any) {
        callSignUpAPI()
    }
    @IBAction func btnSignupWithFacebookClick(_ sender: Any) {
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


func callSignUpAPI() {
    if isValidated(){
        let param = [
            "email":txtEmail.text!,
            "password":txtPassword.text!,
            "username":txtUserName.text!,
            "firstname":txtFirstName.text!,
            "lastname":txtLastName.text!
        ]
        ModelClass.shared.signUp(vc: self, param: param) { (dic) in
            print(dic)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
            })
        }
    }
}

func isValidated() -> Bool {
    var ErrorMsg = ""
    if (txtFirstName.text?.isEmpty)! {
        ErrorMsg = "Please enter a first name"
    }else  if (txtLastName.text?.isEmpty)! {
        ErrorMsg = "Please enter a last name"
    }else  if (txtEmail.text?.isEmpty)! {
        ErrorMsg = "Please enter email address"
    } else if !(txtEmail.text?.isValidEmail)! {
        ErrorMsg = "Please enter a valid email id"
    }else  if (txtUserName.text?.isEmpty)! {
        ErrorMsg = "Please enter username"
    }else  if (txtPassword.text?.isEmpty)! {
        ErrorMsg = "Please enter password"
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
extension MSSignupVC: UITextFieldDelegate
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




