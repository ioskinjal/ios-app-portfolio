//
//  LoginVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import FacebookCore
import FacebookLogin
import GoogleSignIn


var appConts = AppConst.shared

class LoginVC: BaseVC, ForgotPasswordDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    
//    @IBOutlet weak var facebookBtn: UIButton!
//
//    @IBOutlet weak var googleBtn: GIDSignInButton!
//    @IBOutlet weak var btnLogin:UIButton!
//    @IBOutlet weak var btnForgotPassword:UIButton!
//    @IBOutlet weak var btnSignUp:UIButton!
//
    var isSocialLogin = false
    
    //    @IBOutlet weak var googleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //googleSetup()
        configureGoogle()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        txtEmail.placeholder = appConts.const.lBL_EMAIL
//        txtPassword.placeholder = appConts.const.lBL_PASSWORD
//        btnLogin.setTitle(appConts.const.bTN_LOGIN, for: .normal)
//        btnForgotPassword.setTitle(appConts.const.lBL_FORGOT_PASSWORD, for: .normal)
//        btnSignUp.setTitle(appConts.const.tITLE_SIGNUP, for: .normal)
    }
    
    func googleSetup(){
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
//        googleBtn.colorScheme = .light
//        googleBtn.style = .iconOnly
        
        GIDSignIn.sharedInstance().signOut()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - ForgotPassword Delegate method
    func dimissForgotPasswordClicked(isSuccess: Bool) {
        
        if let nav = self.navigationController, let loginVC = nav.topViewController as? LoginVC {
            
            if loginVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  loginVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        if isSuccess {
            let alert = Alert()
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.nEW_PWD_SENT, buttonTitleStr: appConts.const.bTN_OK)
        }
    }
    
    // MARK:- Social/Login api methods
    func loginToFacebook(){
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self) { (loginResult) in
            //self.facebookBtn.isUserInteractionEnabled = true
            switch loginResult{
            case .failed(let error):
                print(error)
            case .success(let grantedPermissions, let declinedPermissions, let token):
                print("Logged in!")
                
                let accessToken = token.authenticationToken    // User logged in , use 'accessToken' here.
                let granted = grantedPermissions.description
                let declined = declinedPermissions.description
                print("\(granted)")
                print("\(declined)")
                
                AccessToken.refreshCurrentToken({ (token, error) in
                    self.getUserProfile(token: accessToken)
                })
            case .cancelled:
                print("User cancelled login.")
                
            }
            
        }
    }
    
    func getUserProfile(token:String){
        
        let graphPath = "/me"
        let params: [String : Any]? = ["fields": "id,email,first_name,last_name"]
        let accessToken = AccessToken.current
        let httpMethod: GraphRequestHTTPMethod = .GET
        let apiVersion: GraphAPIVersion = .defaultVersion
        
        let graphRequest = GraphRequest(graphPath: graphPath, parameters: params!, accessToken: accessToken, httpMethod: httpMethod, apiVersion: apiVersion)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    if (responseDictionary["email"] != nil) {
                        let first_name = responseDictionary["first_name"] as! String
                        let last_name =  responseDictionary["last_name"] as! String
                        let email = responseDictionary["email"] as! String
                        self.isSocialLogin = true
                        self.socialLogin(first_name: first_name, last_name: last_name, email: email)
                    }
                    else{
                        let alert = Alert()
                        alert.showAlert(titleStr: "", messageStr: appConts.const.REQ_SOCIAL_EMAIL , buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }
        }
    
    }
    
    func socialLogin(first_name:String,last_name:String,email:String){
        
        let params: Parameters = [
            "email": email,
            "firstName": first_name,
            "lastName": last_name,
            "userType": "u",
            
        ]
        
        loginWith(api: URLConstants.Domains.ServiceUrl+URLConstants.Social.login, parameters: params )
        
    }
    
    func loginWith(api:String,parameters:Parameters){
        
        startIndicator(title: "")
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: api, parameters: parameters, successBlock: { (json, urlResponse) in
            
            // self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print("Items \(dataAns)")
                
                let person = User.initWithResponse(dictionary: userDict as? [String : Any])
                self.sharedAppDelegate().currentUser = person
                DispatchQueue.main.async {
                    
                    self.stopIndicator()
                    
                    
                    //if person is register
                    if person.register == "y"{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
                        editProfileController.isFromRegister = true
                        editProfileController.social = self.isSocialLogin
                        self.navigationController?.pushViewController(editProfileController, animated: true)
                    }
                    else{
                            // Mobile No not available
                        if person.mobileNo.isEmpty {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
                            editProfileController.isFromRegister = true
                            editProfileController.social = self.isSocialLogin
                            self.navigationController?.pushViewController(editProfileController, animated: true)
                        }
                        else if person.isActive.lowercased() == "y"{
                            // Go to Home - User Logged in
                            User.saveUser(loggedUser: person)
                            User.setUserLoginStatus(isLogin: true)
                            self.registerDeviceToken()
                            self.sharedAppDelegate().rootToHome()
                        }
                        else{
                            // Show Error Alert
                            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.aCCOUNT_NOT_ACTIVE, buttonTitleStr: appConts.const.bTN_OK)
                            
                        }
                        
                    }
                    
                }
                
            }
            else{
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
            
            
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                self.navigationController?.present(oopsVC, animated: true, completion: nil)
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
        
        
    }
    
    func registerDeviceToken(){
        
        let params: Parameters = [
            "deviceId": CustomerDefaults.getDeviceToken() ,
            "userId": sharedAppDelegate().currentUser?.uId ?? "",
            "userType": "u",
            "deviceType":"i",
            "lId":Language.getLanguage().id
        ]
        
        //        showLoader(title: "")
        
        //        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Device.registerDevice, parameters: params, successBlock: { (json, urlResponse) in
            
            // self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                //                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                //                print("Items \(dataAns)")
                
                
            }
            else{
                DispatchQueue.main.async {
                    
                    // alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                }
            }
            
            
        }) { (error) in
            DispatchQueue.main.async {
                
                // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                //self.window?.rootViewController?.navigationController?.present(oopsVC, animated: true, completion: nil)
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
    }
    
    // MARK:- Button action events
    
    @IBAction func onClickGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let signUpController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        let validate = Validator()
        let alert = Alert()
        
        if (txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if (txtPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_PASSWORD, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else{
            self.view.endEditing(true)
            
            let params: Parameters = [
                "email": String(format:"%@",txtEmail.text!),
                "password": String(format:"%@",txtPassword.text!),
            ]
            self.isSocialLogin = false
            loginWith(api: URLConstants.Domains.ServiceUrl+URLConstants.User.login, parameters: params)
            
        }
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let forgotController = storyBoard.instantiateViewController(withIdentifier: "forgotPasswordVC") as! ForgotPasswordVC
        forgotController.delegate = self
        self.addChildViewController(forgotController)
        view.addSubview(forgotController.view)
        forgotController.didMove(toParentViewController: self)
    }
    
    @IBAction func btnFacebokClicked(_ sender: Any) {
        
        //facebookBtn.isUserInteractionEnabled = false
        loginToFacebook()
    }
    
    @IBAction func btnGoogleClicked(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

//MARK:- GoogleSignIn
extension LoginVC: GIDSignInDelegate {
    
    func configureGoogle() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signOut()
            //GIDSignIn.sharedInstance().disconnect()
        }
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    //MARK: Google Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            // let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            // let fullName = String(format:"%@",user.profile.name)
            let givenName = String(format:"%@",user.profile.givenName)
            let familyName = String(format:"%@",user.profile.familyName)
            let email = String(format:"%@",user.profile.email)
            self.isSocialLogin = true
            self.socialLogin(first_name: givenName, last_name: familyName, email: email)
            
        } else {
            print("\(error.localizedDescription)")
            
            //let alert = Alert()
            //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    // [END disconnect_handler]
    
}
