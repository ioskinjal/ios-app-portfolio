//
//  changePasswordVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
class changePasswordVC: UIViewController{
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var btnBackground: UIView!
    
    @IBOutlet weak var tblchangePassword: UITableView!
    @IBOutlet weak var lblEnterpassword: UILabel!{
        didSet{
            lblEnterpassword.text = "enter_lbl".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEnterpassword.font = UIFont(name: "Cairo-SemiBold", size: lblEnterpassword.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblPassDesc: UILabel!{
        didSet{
            lblPassDesc.text = "newpass_lbl".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblPassDesc.font = UIFont(name: "Cairo-Light", size: lblPassDesc.font.pointSize)
            }
        }
    }

    
    var isPasswordCheck = true
    var userCurrentPassword = ""
    var userNewPassword = ""
    var userConfirmPassword = ""
    var isCoverActive = false
    @IBOutlet weak var btnChangePassword: UIButton!{
        didSet{
            btnChangePassword.setTitle("pass_change".localized, for: .normal)
            btnChangePassword.addTextSpacingButton(spacing: 1.5)
            btnChangePassword.isEnabled = false
            btnChangePassword.alpha = 0.5
            btnBackground.alpha = 0.5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderAction()
        tblchangePassword.register(UINib(nibName: "passwordCell", bundle: nil), forCellReuseIdentifier: "passwordCell")

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillDisappear() {
        
        if isPasswordCheck {
            let index = IndexPath(row: 0, section: 0)
            let cell: passwordCell = tblchangePassword.cellForRow(at: index) as! passwordCell
            
            if cell.tfPassword.text!.isEmpty {
                //cell.lblErrorMsg.text = "Enter Current Password"
                //cell.lblErrorMsg.isHidden = false
                
            }
            else{
                let currentPassword = cell.tfPassword.text
                let userUserName = UserDefaults.standard.value(forKey: "userEmail")
                userLoginApi(pass: currentPassword ?? "", email: userUserName as! String)
            }
            
            print("HIde key bord do action ")
        }

    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        
        header.headerTitle.text = "pass_change".localized
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    func showAlertMessage(messageValue:String) {
        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:messageValue, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func showPasswordUpdatedMessage(messageValue:String) {
        let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message:messageValue , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { action in
           self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)

        MBProgressHUD.hide(for: self.view, animated: true)
    }
    @IBAction func changePasswordSelector(_ sender: Any) {
        print("Hit change password api")
        let index0 = IndexPath(row: 0, section: 0)
        let cell0: passwordCell = tblchangePassword.cellForRow(at: index0) as! passwordCell
        let currentPassword = cell0.tfPassword.text ?? ""
        
        if currentPassword.length > 0 {
            let index = IndexPath(row: 1, section: 0)
            let cell: passwordCell = tblchangePassword.cellForRow(at: index) as! passwordCell
            userNewPassword = cell.tfPassword.text ?? ""
            
            let index1 = IndexPath(row: 2, section: 0)
            let cell1: passwordCell = tblchangePassword.cellForRow(at: index1) as! passwordCell
            userConfirmPassword = cell1.tfPassword.text ?? ""
            if userNewPassword.length > 0 && userConfirmPassword.length > 0 {
                if userNewPassword == userConfirmPassword {
                    
                    let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.updatePassword
                    //let url = "https://mobileapp-levelshoes-m2.vaimo.net/index.php/rest/V1/customers/me/password"
                     MBProgressHUD.showAdded(to: view, animated: true)
                    let params = [
                        "currentPassword" : userCurrentPassword,
                        "newPassword" : userNewPassword
                        ] as [String : Any]
                    
                    print("UPdate Password \(params) \n \(url)")
                    ApiManager.apiPut(url: url, params: params) { (myJson, myError) in
                        if let error = myError{
                            print(error)
                            self.sharedAppdelegate.stoapLoader()
                            return
                        }
                        if myJson != nil{
                            
                            // print("Print respon \(myJson)")
                            let messageStr = myJson?["message"].string ?? ""
                            if messageStr.length > 0 {
                                self.showAlertMessage(messageValue: messageStr)
                            }
                            else{
                                self.showPasswordUpdatedMessage(messageValue: "Password updated!")
                            }
                        }else{
                            self.showAlertMessage(messageValue: "Something went wrong")
                        }
                    }
                }
                else{
                    self.showAlertMessage(messageValue: "New and confirm password should be same.")
                }
            }
            else{
                self.showAlertMessage(messageValue: "Please enter new and confirm password")
            }
        }
        else{
            self.showAlertMessage(messageValue: "Please enter current password")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func userLoginApi (pass : String , email : String)
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let params = [
            "username" : email,
            "password" : pass
            ] as [String : Any] as [String : Any]
        print("Paramas \(params)")
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.kUserLogin
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
            if let error = error{
                print(error)
                self.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil{
                if statusCode == 200  {
                    self.isPasswordCheck = false
                    self.userCurrentPassword = pass
                    self.isCoverActive = true
                    self.btnChangePassword.isEnabled = true
                    self.btnChangePassword.alpha = 1.0
                    self.btnBackground.alpha = 1.0
                    self.tblchangePassword.reloadData()
//                    let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message:"Password updated!" , preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                       self.navigationController?.popViewController(animated: true)
//                    }))
//                    self.present(alert, animated: true)

                }
                if statusCode == 401  {
                    //let errorMessage = response?.dictionaryValue["message"]?.stringValue
                    let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:"incorrect_pass".localized, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }else{
                print("something went wrong")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
    }
    
    
//    func ischeckPassword ()
//    {
//        let u_email = ValidationClass.verifyPassword(text: registerData.password)
//        errorIndex = 999
//        errorMessage = ""
//
//        if !u_email.1 {
//            if registerData.password.count == 0 {
//                passwordError?.isHidden = true
//                passwordOuterView?.backgroundColor = UIColor.white
//                passwordImageView?.isHidden = true
//                self.passwordCount?.isHidden = true
//            }else{
//                errorIndex = 2
//                errorMessage = u_email.0
//                passwordError?.text = errorMessage
//                passwordError?.isHidden = false
//                passwordImageView?.isHidden = false
//                passwordErrorLine?.backgroundColor = UIColor.red
//                passwordImageView?.image = UIImage(named: "icn_error@2x.png")
//                passwordTF.floatPlaceholderActiveColor = UIColor.red
//                self.passwordCount?.isHidden = false
//            }
//        }else{
//            passwordError?.frame.size.height = 22
//            passwordImageView?.image = UIImage(named: "Successnew")
//            passwordError?.isHidden = true
//            passwordErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
//            passwordTF.floatPlaceholderActiveColor =  colorNames.placeHolderColor
//            passwordTF?.floatPlaceholderColor = colorNames.placeHolderColor
//            self.passwordCount?.isHidden = false
//        }
//    }
//
//    func ischeckConfirmPassword ()
//    {
//        let u_email = ValidationClass.verifyPasswordAndConfirmPassword(password:registerData.password, confirmPassword: registerData.confirmPAssword)
//        errorIndex = 999
//        errorMessage = ""
//
//        if !u_email.1 {
//            if registerData.confirmPAssword.count == 0 {
//                confirmPassError?.isHidden = true
//                confirmPassOuterView?.backgroundColor = UIColor.white
//                confirmPassImageView?.isHidden = true
//                self.confirmPassCount?.isHidden = true
//            }else{
//                errorIndex = 2
//                errorMessage = u_email.0
//                confirmPassError?.text = errorMessage
//                confirmPassError?.isHidden = false
//                confirmPassImageView?.isHidden = false
//                confirmPassErrorLine?.backgroundColor = UIColor.red
//                confirmPassImageView?.image = UIImage(named: "icn_error@2x.png")
//                confirmPassTF.floatPlaceholderActiveColor = UIColor.red
//                self.confirmPassCount?.isHidden = false
//            }
//        }else{
//            confirmPassImageView?.image = UIImage(named: "Successnew")
//            confirmPassError?.isHidden = true
//            confirmPassErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
//            confirmPassTF.floatPlaceholderActiveColor = colorNames.placeHolderColor
//            confirmPassTF?.floatPlaceholderColor = colorNames.placeHolderColor
//            self.confirmPassCount?.isHidden = false
//        }
//    }

}
extension changePasswordVC: UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! passwordCell
        if indexPath.row == 0 {
             cell.tfPassword.placeHolder(text: "Current Password*".localized, textfieldname: cell.tfPassword)
            cell.viewCover.isHidden = true
        }
        else if indexPath.row == 1 {
            cell.tfPassword.placeHolder(text: "New Password*".localized, textfieldname: cell.tfPassword)
            cell.viewCover.isHidden = isCoverActive
        }
        else{
            cell.tfPassword.placeHolder(text: "Confirm Password*".localized, textfieldname: cell.tfPassword)
            cell.viewCover.isHidden = isCoverActive
        }
       
        return cell
        
    }

}
extension changePasswordVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField, withCell: passwordCell) {
        print("Hit api Begin editing")
    }

    func textFieldDidChangeSelection(_ textField: UITextField, withCell: passwordCell) {
         
    }

//    func textFieldDidEndEditing(_ textField: UITextField, withCell: passwordCell) {
//            print("Hit api end editing")
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, withCell: passwordCell) -> Bool {
        return  true
    }

    func textFieldShouldReturn(_ textField: UITextField, withCell: passwordCell) -> Bool {
        print("Hit api")
        return true
    }
}

