//
//  MSLoginVC.swift
//  MIShop
//
//  Created by nct48 on 02/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import TextFieldEffects
import FacebookCore
import FacebookLogin


class MSLoginVC: UIViewController
{
    @IBOutlet weak var viewForgotPassword: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet var txtUserName: UITextField!{didSet{
        }}
    @IBOutlet var txtPassword: UITextField!{didSet{
        }}
    
    @IBOutlet weak var btnFBLogin: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
         configureFacebook()
    }
    override func viewDidLayoutSubviews()
    {
        txtUserName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtPassword.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
    //MARK:- UIButton Click Events
    @IBAction func onClickSubmit(_ sender: Any) {
        callforgetPasswordAPI()
    }
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
        viewForgotPassword.isHidden = false
    }
    @IBAction func btnLoginClick(_ sender: Any) {
        callLoginAPI()
    }
    
    @IBAction func btnLoginWithFacebookClick(_ sender: Any) {
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func callLoginAPI() {
        if isValidated(){
            let param = [
                "email":txtUserName.text!,
                "password":txtPassword.text!,
                "username":txtUserName.text!,
            ]
            ModelClass.shared.login(vc: self, param: param) { (dic) in
                print(dic)
                let userData = [
                    "email": self.txtUserName.text!,
                    "password": self.txtPassword.text!,
                    ]
                _ = UserData.shared.setUserLoginData(dic: userData)
                
                self.txtUserName.text = nil
                self.txtPassword.text = nil
                let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
                _ = UserData.shared.setUser(dic: data)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                })
                self.viewForgotPassword.isHidden = true
            }
        }
    }
    
    func callforgetPasswordAPI() {
        if (txtEmail.text?.isEmpty)!{
            self.alert(title: "", message: "please enter email", completion: {
            })
        }else if (!(txtEmail.text?.isValidEmail)!)
        {
            self.alert(title: "", message: "please enter valid email", completion: {
            })
        }
        else{
            let param = [
                "email":txtEmail.text!
                ]
            ModelClass.shared.forgetPassword(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                })
            }
        }
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
         if (txtUserName.text?.isEmpty)! {
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

extension MSLoginVC: UITextFieldDelegate
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
extension MSLoginVC {
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
        btnFBLogin.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        //let loginManager = LoginManager().
        //loginManager.logOut()
        
    }
    
    @objc func loginButtonClicked() {
        LoginManager().logOut()
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
                        let gender = responseDictionary["gender"] as! String
                        let fbId = responseDictionary["id"] as! String
                        let facebookProfileUrl = "http://graph.facebook.com/\(fbId)/picture?type=large"
                        //  fbId = self.md5(fbId)
                        print("=======fbId===================")
                        print(fbId)
                        print("=============fNm=============")
                        print(fNm)
                        print("==========lNm================")
                        print(lNm)
                        print("===========email===============")
                        print(email)
                        print("===========gender===============")
                        print(gender)
                        print("===========================")
                        
//                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "f", socialId: fbId, email: email, profile_pic: facebookProfileUrl)
                    }
                }
            }
        }
    }
}
