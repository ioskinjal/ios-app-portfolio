//
//  LoginVC.swift
//  Reviews_And_Rattings
//
//  Created by NCrypted on 05/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


var isSocialLogin:Bool?
class LoginVC: UIViewController {

    @IBOutlet weak var viewPWD: UIView!{
        didSet{
            viewPWD.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var iconClick = true
    
    static var storyboardInstance:LoginVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFacebook()
    }

//    @objc func onClickMenu(_ sender: UIButton){
//        self.navigationController?.popViewController(animated: true)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickForgotPwd(_ sender: UIButton) {
        forgotPwd()
    }
    @IBAction func onClickSignIn(_ sender: UIButton) {
        
        if isValidated(){
            callLoginAPI()
        }
    }
   
    
    @IBAction func onClickCreateAc(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func forgotPwd() {
        displayAlret { (email) in
            Modal.shared.getForgotPassword(vc: self, param: ["email_address":email,
                                                 "action":"forgot-password"]) { (dic) in
                print(dic)
                let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                self.alert(title: "", message: data)
            }
        }
    }
    
    
    func resendLink() {
        displayAlretResend { (email) in
            Modal.shared.getForgotPassword(vc: self, param: ["email":email,
                                                 "action":"resend_link"]) { (dic) in
                                                    print(dic)
                                                    let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                                                    self.alert(title: "", message: data)
            }
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter email id for recover the password", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Recover Password", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.keyboardType = .emailAddress
            print("firstTxtValues: \(firstTextField.text!)")
            if !(firstTextField.text?.isEmpty)! || (firstTextField.text?.isValidEmailId)! {
                callback(firstTextField.text!)
            }
            else {
                self.alert(title: "Error", message: "Please enter valid email id")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email id"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func displayAlretResend(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Resend Link", message: "Enter email id to resend link", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Resend", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.keyboardType = .emailAddress
            print("firstTxtValues: \(firstTextField.text!)")
            if !(firstTextField.text?.isEmpty)! || (firstTextField.text?.isValidEmailId)! {
                callback(firstTextField.text!)
            }
            else {
                self.alert(title: "Error", message: "Please enter valid email id")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email id"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email"
        }
        else if (txtPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter a Password"
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
    
    func callLoginAPI() {
        Modal.shared.login(vc: self, param: [
            "email_address": txtEmail.text!,
            "password": txtPassword.text!,
            "action": "user-login"]) { (dic) in

            //Set data for auto login
            let userData = [
                "email_address": self.txtEmail.text!,
                "password": self.txtPassword.text!
                ]
            _ = UserData.shared.setUserLoginData(dic: userData)

            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {

              self.navigationController?.popViewController(animated: true)
                
            })
        }
    }
    
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["app_token":socialId,
                        "action":"social-login",
                        "deviceToken":UserData.shared.deviceToken,
                        "deviceType":"iphone"
        ]
    
        Modal.shared.socialLogin(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.navigationController?.popViewController(animated: true)
                
            })
        }
    }
    
}
//MARK:- FB login methods
extension LoginVC {
    
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
        btnFB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        LoginManager().logOut()
        //let loginManager = LoginManager().
        //loginManager.logOut()
    }
    
    @objc func loginButtonClicked() {
        let loginmanger = LoginManager()
        loginmanger.logOut()
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("accessToken:\(accessToken)")
            self.getFBUserData()
        }
        else{
            let loginManager = LoginManager()
            let readPermissions: [ReadPermission] = [.publicProfile, .email, /*.userBirthday*/]
            loginManager.logIn(readPermissions: readPermissions, viewController: self) { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("Users cancelled login.")
                case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
                    print("Logged in!")
                    print("grantedPermissions:\(grantedPermissions.description)")
                    print("declinedPermissions:\(declinedPermissions.description)")
                    print("accessToken:\(accessToken.authenticationToken)")
                    //if grantedPermissions.contains(Permission(name: "email")) == true { .. }
                    self.getFBUserData()
                    //                    AccessToken.refreshCurrentToken({ (accessToken, error) in
                    //                        self.getFBUserData()
                    //                    })
                }
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            let params = ["fields" : "id,email,first_name,last_name,gender"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            graphRequest.start {
                (urlResponse, requestResult) in
                switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        let fNm = responseDictionary["first_name"] as! String
                        let lNm = responseDictionary["last_name"] as! String
                        let email = responseDictionary["email"] as! String
                        //  let gender = responseDictionary["gender"] as! String
                        let fbId = responseDictionary["id"] as! String
                        let facebookProfileUrl:String?
                        facebookProfileUrl = "http://graph.facebook.com/\(fbId)/picture?type=large"
                        print("=======fbId===================")
                        print(fbId)
                        print("=============fNm=============")
                        print(fNm)
                        print("==========lNm================")
                        print(lNm)
                        print("===========email===============")
                        print(email)
                        print("===========gender===============")
                        //   print(gender)
                        print("===========================")
                        
                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "facebook", socialId: fbId, email: email, profile_pic: facebookProfileUrl!)
                    }
                }
            }
        }
    }
}

