//
//  ResetPwdVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 27/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
//import DTTextField
import MBProgressHUD
import STPopup




class ResetPwdVC: UIViewController {
    
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    static var storyboardInstance:ResetPwdVC? {
        return StoryBoard.ForgotPW.instantiateViewController(withIdentifier: ResetPwdVC.identifier) as? ResetPwdVC
        
    }
    var fourUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 4 leading zeros with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
            // generate another random number if the set of characters count is less than four
        } while Set(result).count < 4
        return result    // ran 5 times
    }
    
    @IBOutlet weak var lblForgotPwd: UILabel!{
        didSet{
            lblForgotPwd.text = "Forgot your password?".localized
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" != "en"{
                lblForgotPwd.font = UIFont(name: "Cairo-SemiBold", size: lblForgotPwd.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblEnterEmail: UILabel!{
        didSet{
            lblEnterEmail.text = "Enter your email address below, and we'll send you instructions to reset your password.".localized
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" != "en"{
                lblEnterEmail.font = UIFont(name: "Cairo-Light", size: lblEnterEmail.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
           if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
            lblTitle.addTextSpacing(spacing: 1.5)
           }else{
            lblTitle.font = UIFont(name: "Cairo-SemiBold", size: 14)
            }
            lblTitle.text = "RESET PASSWORD".localized
        }
    }
    @IBOutlet weak var lblSignUp: UILabel!{
        didSet{
            let strDont:String = "donthaveaccount".localized
            
            lblSignUp.attributedText = underlinedString(string: strDont as NSString, term: "Sign up".localized as NSString)
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" != "en" {
                lblSignUp.font = UIFont(name: "Cairo-Regular", size: lblSignUp.font.pointSize)
            }
            
        }
    }
  
    @IBOutlet weak var btnResetPWD: UIButton!{
 
            didSet{
                //btnResetPWD.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
                //btnResetPWD.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
                btnResetPWD.setTitle("RESET PASSWORD".localized, for: .normal)
                if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
                btnResetPWD.addTextSpacing(spacing: 1.5, color: "ffffff")
                    btnResetPWD.setBackgroundColor(color: colorNames.c7C7, forState: .normal)
                    btnResetPWD.isUserInteractionEnabled = false
                    
                }else{
                    btnResetPWD.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
                }
            }
    }
   

    
     //*********** Email Name declartion *************//
    @IBOutlet weak var txtEmail: RMTextField!{
        didSet{
            txtEmail.placeHolder(text: "Email Address*".localized, textfieldname: txtEmail)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                txtEmail.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            }else{
                txtEmail.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
                txtEmail.font = UIFont(name: "Cairo-Regular", size: 15)
            }
            
            txtEmail.backgroundColor = .white
            txtEmail.borderColor = .clear
            txtEmail.dtLayer.isHidden = true
            txtEmail.delegate = self
            
        }
    }
    @IBOutlet weak var emailOuterView: UIView?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var emailError: UILabel?
    @IBOutlet weak var emailErrorLine: UIView?
    //************* End of email ****************//
    let registerData = RegisterDetail()
    var errorIndex = 999
    var errorMessage = ""
    var ErrorMsg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.addTarget(self, action: #selector(onClickText), for: .editingChanged)
    }
    
    @objc func onClickText(_ sender:RMTextField){
        txtEmail.dtLayer.backgroundColor = UIColor(hexString: "FAFAFA").cgColor
        self.ischeckemail()
    }
    
//   @objc func didEndText(_ sender:DTTextField){
//    txtEmail.dtLayer.backgroundColor = UIColor.white.cgColor
//    self.ischeckemail()
//    }
    
    func underlinedString(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: string as String)
        let underlineRange = string.range(of: term as String)
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)

        return output
    }
    
 
    func forgotPwd() {
           MBProgressHUD.showAdded(to: self.view, animated: true)
          let randonToken = fourUniqueDigits
          UserDefaults.standard.set(randonToken, forKey: "defaultToken")
         UserDefaults.standard.set(self.txtEmail.text!, forKey: "userEmail")
        print("Usr Pass -- \(randonToken)")
        let params = [
            "email" : self.txtEmail.text!,
            "mobiletoken" : randonToken,
            "websiteid": getWebsiteId()
            ] as [String : Any] as [String : Any]

        //let storeCode:String = UserDefaults.standard.value(forKey: "storecode") as! String

        let url = getWebsiteBaseUrl(with: "rest")  + getM2StoreCode() + "/" + CommonUsed.globalUsed.kResetPasword
         print("this is my : \(params) and url is  \n \(url)")
        ApiManager.apiPut(url: url, params: params) { (response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            //print("Print REAP - \(response?.description) or error \(error)")
            if let error = error{
                print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil{
                UserDefaults.standard.set(response?.description, forKey: "userTokenforchangePassword")
                let nextVC = CodeVCViewController.storyboardInstance!
                nextVC.strEmail = self.txtEmail.text!
                //print("Responese Code -- \(response?.dictionaryObject)")
                if response?.dictionaryObject?.count != 1  && response?.dictionaryObject?.count != nil{
                    self.alert(title:"Error".localized, message: "email does not exist".localized)

                }else{
                     self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
        
    func ischeckemail ()
    {
       
               if (txtEmail.text?.isEmpty)! {
                //txtEmail.showError(message:"Please enter email address".localized)
                   ErrorMsg = txtEmail.errorMessage
                 
                 emailImageView?.isHidden = false
                emailImageView?.image = UIImage(named: "icn_error@2x.png")
                btnResetPWD.setBackgroundColor(color: colorNames.c7C7, forState: .normal)
                btnResetPWD.isUserInteractionEnabled = false
                txtEmail.floatPlaceholderActiveColor = .red
                
               }
               else if !txtEmail.text!.isValidEmailId {
                //txtEmail.showError(message:"Please enter valid email address".localized)
                ErrorMsg = txtEmail.errorMessage
                emailError?.isHidden = false
                emailError?.text = "Please enter valid email address".localized
                emailImageView?.isHidden = false
                emailImageView?.image = UIImage(named: "icn_error@2x.png")
                btnResetPWD.setBackgroundColor(color: colorNames.c7C7, forState: .normal)
                btnResetPWD.isUserInteractionEnabled = false
                 txtEmail.floatPlaceholderActiveColor = .red
            }
               else {
                 
                emailImageView?.isHidden = false
                emailImageView?.image = UIImage(named: "Successnew")
                btnResetPWD.setBackgroundColor(color:.black, forState: .normal)
                btnResetPWD.isUserInteractionEnabled = true
                emailError?.isHidden = true
                emailErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                txtEmail.floatPlaceholderActiveColor =  colorNames.placeHolderColor
                txtEmail?.floatPlaceholderColor = colorNames.placeHolderColor
                
                //txtEmail.floatPlaceholderActiveColor = UIColor(hexString: "#474747")

               }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pnClickClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let loginVC = RegistrationUserViewController.storyboardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(loginVC, animated: false)
    }
    @IBAction func onClickResetPassword(_ sender: Any) {
        
        txtEmail.endEditing(true)
        if isValidated(){
            forgotPwd()
        }
    }
    
     func isValidated() -> Bool {
           
           var ErrorMsg = ""
           if (txtEmail.text?.isEmpty)! {
            //txtEmail.showError(message:"Please enter email address".localized)
            ErrorMsg = txtEmail.errorMessage
            emailError?.isHidden = false
            emailError?.text = "Please enter email address".localized
            
           }
           else if !txtEmail.text!.isValidEmailId {
            emailError?.isHidden = false
            emailError?.text = "Please enter email address".localized
            //txtEmail.showError(message:"Please enter valid email address".localized)
            ErrorMsg = txtEmail.errorMessage
        }
           if ErrorMsg != "" {
            txtEmail.placeholderColor = colorNames.placeHolderColor
               return false
           }
           else {
            txtEmail.placeholderColor = colorNames.placeHolderColor
            
               return true
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
    
}
extension ResetPwdVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       let characterCountLimit = 1000

        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length

        let newLength = startingLength + lengthToAdd - lengthToReplace
        //self.lblChar.text = "\(newLength)/1000"
        
        if !textField.text!.isValidEmailId || textField.text!.count < 1 {
           
            txtEmail.placeholderColor =  colorNames.placeHolderColor
            emailError?.isHidden = true
        }else if textField.text!.count == 1 {
            txtEmail.placeholderColor = colorNames.placeHolderColor
        }else{
            txtEmail.placeholderColor = colorNames.placeHolderColor
        }
        
        return newLength <= characterCountLimit
        
        
    
    }
    
    
    
}


extension ResetPwdVC:NoInternetDelgate{
    func didCancel() {
        self.forgotPwd()
    }
}
