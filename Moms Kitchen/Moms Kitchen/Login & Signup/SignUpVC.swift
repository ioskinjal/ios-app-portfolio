//
//  SignUpVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit


class SignUpVC: BaseViewController {

    @IBOutlet weak var txtContactNo: UITextField!{
        didSet{
            txtContactNo.keyboardType = .numberPad
            txtContactNo.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtLastName: UITextField!{
        didSet{
            txtLastName.keyboardType = .alphabet
        }
    }
    @IBOutlet weak var txtFirstName: UITextField!{
        didSet{
            txtFirstName.keyboardType = .alphabet
        }
    }
    static var storyboardInstance:SignUpVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC
    }
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sign Up", action: #selector(onClickMenu(_:)))
        navigationBar.viewCart.isHidden = true
        navigationBar.btnCart.isHidden = true
    }
    
    func isValidInput(Input:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        print("\(isValid)")
        
        return isValid
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func callSignUpAPI() {
        if isValidated(){
            let param : [String:String]

             param = [
                "email":txtEmail.text!,
                "password":txtPassword.text!,
                "mobile_no":txtContactNo.text!,
                "fname":txtFirstName.text!,
                "lname":txtLastName.text!
            ]
            Modal.shared.signUp(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                     self.navigationController?.popViewController(animated: true)
                })
               
            }
        }
    }
   

    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter a first name"
        }else if !(isValidInput(Input: txtFirstName.text!)) {
            ErrorMsg = "firstname only accepts characters"
        }
        else  if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter a last name"
        }else if !(isValidInput(Input: txtLastName.text!)) {
            ErrorMsg = "lastname only accepts characters"
        }else  if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email address"
        } else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Please enter a valid email id"
        } else  if (txtPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter password"
        }else if (txtPassword.text?.length)! < 6 {
            ErrorMsg = "Password must be atleast 6 characters"
        }
        else  if (txtContactNo.text?.isEmpty)! {
            ErrorMsg = "Please enter contact number"
        }else  if ((txtContactNo.text?.length)! != 10) {
            ErrorMsg = "Please enter valid contact number"
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
    //MARK:- UIButton Click Events
    @IBAction func onClickShowPassword(_ sender: UIButton) {
        let button:UIButton = sender
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            button.setImage(#imageLiteral(resourceName: "eye-ico"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "visibility-off-512"), for: .normal)
            txtPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        if isValidated(){
            callSignUpAPI()
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
extension SignUpVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtContactNo == textField{
            //if (textField.text?.length)! >= 10{
               // textField.deleteBackward()
          //  }
          
        }
        return true
    }
    
}
