//
//  SignUpVC.swift
//  Luxongo
//
//  Created by admin on 7/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SignUpVC: BaseViewController {

    //MARK: Preperties
    static var storyboardInstance:SignUpVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as! SignUpVC
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
          //  self.tfPassword.isPreventCaret = true
        }
    }
    @IBOutlet weak var btnRegister: BlackBgButton!
    @IBOutlet weak var lblCont: LabelSemiBold!
    @IBOutlet weak var lblDontAcc: LabelSemiBold!
    @IBOutlet weak var btnSkip: BlackButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    //MARK: LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //tfEmail.text = "ns@mailinator.com"
        //tfPassword.text = "123456"
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
    
    @IBAction func onClickLogin(_ sender: Any) {
        popViewController(animated: true)
    }
    @IBAction func onClickRegister(_ sender: Any) {
        redirectToProfile()
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
        pushViewController(DashBoardVC.storyboardInstance, animated: true)
    }
    
    //MARK: Custom functions
    
    func redirectToProfile() {
        if isValidated(){
            let nextVC = EditProfileVC.storyboardInstance
            nextVC.email = tfEmail.text
            nextVC.password = tfPassword.text
            pushViewController(nextVC, animated: true)
        }
    }
    
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
        else if tfPassword.text!.count < 6 {
            ErrorMsg = "Password at list 6 character long"
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
            firstTextField.keyboardType = .emailAddress
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
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: API Calling functions
extension SignUpVC{
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
                print(UserData.shared.getUser()!.email)
                
                let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                UIApplication.alert(title: "", message: message, completion: {
                    self.pushViewController(MainHomeVC.storyboardInstance, animated: true)
                })
            }
            
        })
    }
}
