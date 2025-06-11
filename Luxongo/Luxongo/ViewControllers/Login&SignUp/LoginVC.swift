//
//  LoginVC.swift
//  Luxongo
//
//  Created by admin on 7/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    //MARK: Properties
    static var storyboardInstance:LoginVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as! LoginVC
    }
    

    
    //MARK: Outlets
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var lblWelcm: LabelBold!
    @IBOutlet weak var lblEmail: LabelSemiBold!
    @IBOutlet weak var tfEmail: TextField!{
        didSet{
            self.tfEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var lblPassword: LabelSemiBold!
    @IBOutlet weak var tfPassword: TextField!{
        didSet{
//            self.tfPassword.isPreventCaret = true
        }
    }
    @IBOutlet weak var btnForgotPw: GreyButton!
    @IBOutlet weak var btnLogin: BlackBgButton!
    @IBOutlet weak var lblCont: LabelSemiBold!
    @IBOutlet weak var lblDontAcc: LabelSemiBold!
    @IBOutlet weak var btnRegister: OrangeButton!
    @IBOutlet weak var btnSkip: BlackButton!
    
    
    //MARK: LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        tfEmail.text = "ns@mailinator.com"
//        tfPassword.text = "123456"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfEmail.text = "kuldip.bhatt@ncrypted.com"
        tfPassword.text = "123456"
    }
    
    //MARK: IBActions
    @IBAction func onClickShow(_ sender: UIButton) {
        if btnShow.currentTitle == "Show"{
            tfPassword.isSecureTextEntry = false
            btnShow.setTitle("Hide", for: .normal)
        }else{
            tfPassword.isSecureTextEntry = true
            btnShow.setTitle("Show", for: .normal)
        }
    }
    @IBAction func onClickForgotPw(_ sender: Any) {
        forgotPwd()
    }
    @IBAction func onClickLogin(_ sender: Any) {
        callLogin()
    }
    @IBAction func onClickRegister(_ sender: Any) {
        pushViewController(SignUpVC.storyboardInstance, animated: true)
    }
    @IBAction func onClickFB(_ sender: Any) {
        callFacebookLogin()
    }
    @IBAction func onClickGoogle(_ sender: Any) {
        callGoogleLogin()
    }
    @IBAction func onClickLinkedIn(_ sender: Any) {
        callLinkedInLogin()
    }
    @IBAction func onClickSkip(_ sender: Any) {
    }
    
    //MARK: Custom functions
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfEmail.text ?? "").isBlank {
            ErrorMsg = "Please enter an Email"
        }else if !tfEmail.text!.isValidEmailId {
            ErrorMsg = "Please enter valid Email"
        }
        else if (tfPassword.text ?? "").isBlank {
            ErrorMsg = "Please enter Password"
        }
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Forgot Password".localized, message: "Enter email id for recover the password".localized, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Recover Password".localized, style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstTxtValues: \(firstTextField.text!)")
            if !(firstTextField.text ?? "").isBlank || firstTextField.text!.isValidEmailId {
                callback(firstTextField.text!)
            }
            else {
                UIApplication.alert(title: "Error", message: "Please enter valid email id")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email id".localized
            textField.keyboardType = .emailAddress
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: API Calling functions
extension LoginVC{
    func callFacebookLogin() {
        FacebookSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
            if let errStr = errStr{
                print(errStr)
            }else{
                print(userInfo.email)
                self.callSocialSignUp(email: userInfo.email, name: "\(userInfo.firstName) \(userInfo.lastName)", profilePicture: userInfo.profileUrl, provider: .facebook, socialId: userInfo.socialId)
            }
        }
    }
    
    func callGoogleLogin() {
        GoogleSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
            if let errStr = errStr{
                print(errStr)
            }else{
                print(userInfo.email)
                self.callSocialSignUp(email: userInfo.email, name: "\(userInfo.firstName) \(userInfo.lastName)", profilePicture: userInfo.profileUrl, provider: .google, socialId: userInfo.socialId)
            }
        }
    }
    
    func callLinkedInLogin() {
        LinkedInManager.shared.loginWithLinked { (userInfo, errStr) in
            print(userInfo.email)
            self.callSocialSignUp(email: userInfo.email, name: "\(userInfo.firstName) \(userInfo.lastName)", profilePicture: userInfo.proFileURL, provider: .linkedin, socialId: userInfo.socialId)
        }
    }
    
    func callLogin() {
        if isValidated(){
            let param:dictionary = ["email": tfEmail.text!,
                                    "password": tfPassword.text!,
                                    "device_id": UserData.shared.deviceToken,
                                    "device_type":"ios",
            ]
            API.shared.call(with: .login, viewController: self, param: param) { (response) in
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                if let uData = User(dictionary: dic).convertToDictionary{
                    UserData.shared.setUser(dic: uData)
                    print(UserData.shared.getUser()!.email)
                    self.pushViewController(MainHomeVC.storyboardInstance, animated: true)
                }
            }
        }
    }
    
    func forgotPwd() {
        displayAlret { (email) in
            let param:dictionary = ["email": email]
            API.shared.call(with: .forgotPassword, viewController: self, param: param, success: { (response) in
                let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                UIApplication.alert(title: "", message: message)
            })
        }
    }
    
    func callSocialSignUp(email:String, name: String, profilePicture:String, provider: SocialType, socialId:String ) {
        let param:dictionary = ["email": email,
                                "name": name,
                                "profile_picture": profilePicture,
                                "provider": provider.rawValue,
                                "social_id": socialId,
                                "device_type": "ios",
        ]
        API.shared.call(with: .socialSignup, viewController: self, param: param, success: { (response) in
            let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
            if let uData = User(dictionary: dic).convertToDictionary{
                UserData.shared.setUser(dic: uData)
                print(UserData.shared.getUser()!.name)
            }
            
            let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
            UIApplication.alert(title: "", message: message, completion: {
                print("OK")
                self.pushViewController(MainHomeVC.storyboardInstance, animated: true)
            })
        })
    }
}

enum SocialType:String{
    case facebook = "facebook"
    case linkedin = "linkedin"
    case google = "google"
}
