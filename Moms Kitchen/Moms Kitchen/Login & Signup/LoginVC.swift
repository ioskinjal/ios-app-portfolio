//
//  LoginVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
//import TwitterKit
import LinkedinSwift
var isFromSideMenu:Bool = false

var isFromMenu:Bool = false
class LoginVC: BaseViewController {
    
    var iconClick = true
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    static var storyboardInstance:LoginVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC
    }
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btntwitter: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sign In", action: #selector(onClickMenu(_:)))
        navigationBar.viewCart.isHidden = true
        navigationBar.btnCart.isHidden = true
        configureFacebook()
        configureGoogle()
        
    }
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "81ft1pua4vux9f", clientSecret: "Kpn3EulhgZDpP1aw", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://192.168.100.72/login/callback")
    )
    
    //  private let tweetImageInfo:TWTRUser? = nil
    
    
    @objc func onClickMenu(_ sender: UIButton){
        if isFromMenu{
            self.dismiss(animated: true, completion: nil)
            isFromMenu = false
        }else{
        self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickResendLink(_ sender: UIButton) {
        resendLink()
    }
    @IBAction func onClickSignUp(_ sender: UIButton) {
        let nextVC = SignUpVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func onClickGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func onClickFB(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickTwitter(_ sender: UIButton) {
        loginWithLinkedInSwift()
        //signInWithTwitter()
    }
    @IBAction func onClickForgotPassword(_ sender: UIButton) {
        forgotPwd()
    }
    
    func forgotPwd() {
        displayAlret { (email) in
            Modal.shared.getForgotPassword(vc: self, param: ["email":email]) { (dic) in
                print(dic)
                let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                self.alert(title: "", message: data)
            }
        }
    }
    
    func resendLink() {
        displayAlret1 { (email) in
            Modal.shared.resendLink(vc: self, param: ["email":email]) { (dic) in
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
    
    
    func displayAlret1(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Resend Link", message: "Enter email id for resend activation link", preferredStyle: .alert)
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
    @IBAction func onClickSignIn(_ sender: UIButton) {
        if isValidated(){
            callLoginAPI()
        }
    }
    
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
        Modal.shared.login(vc: self, param: ["email": txtEmail.text!, "password": txtPassword.text!,"token_id":UserData.shared.deviceToken]) { (dic) in
            
            //Set data for auto login
            let userData = [
                "email": self.txtEmail.text!,
                "password": self.txtPassword.text!,
                ]
            UserDefaults.standard.set(false, forKey: "isSocial")
           UserDefaults.standard.synchronize()
            _ = UserData.shared.setUserLoginData(dic: userData)
            
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
//                if isFromMenu == true {
//                    self.dismiss(animated: true, completion: nil)
//                }else {
                if !isFromSideMenu  {
            
                Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
                let strPhone:String = data["contact_no"] as! String
                if strPhone == "" {
                    let nextVC = EditProfileVC.storyboardInstance!
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }else{
                self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
                }
                }else{
                    self.navigationController?.popViewController(animated: true)
                    isFromSideMenu = false
                }
               // }
            })
        }
    }
   
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["fname":fNm,
                        "lname": lNm,
                        "type": loginType,
                        "email": email,
                        "imageURL":profile_pic,
                        "token_id":UserData.shared.deviceToken,
                        "mobile_no":"",
                        "action":"social"
        ]
        switch loginType {
        case "g":
            UserDefaults.standard.set("g", forKey: "type")
            UserDefaults.standard.synchronize()
        case "f":
           
            UserDefaults.standard.set("f", forKey: "type")
            UserDefaults.standard.synchronize()
        case "l":
            UserDefaults.standard.set("l", forKey: "type")
            UserDefaults.standard.synchronize()
        default:
            break
        }
        Modal.shared.signUp(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            UserDefaults.standard.set(true, forKey: "isSocial")
            UserDefaults.standard.synchronize()
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                //                if isFromMenu == true {
                //                    self.dismiss(animated: true, completion: nil)
                //                }else {
                if !isFromSideMenu {
                Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
                    isFromLogin = true
                let strPhone:String = data["contact_no"] as! String
                if strPhone == "" {
                    
                    let nextVC = EditProfileVC.storyboardInstance!
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }else{
                    self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
                }
                }else{
                    self.navigationController?.popViewController(animated: true)
                    isFromSideMenu = false
                }
                // }
            })
        }
    }
    
    //    func signInWithTwitter() {
    //        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
    //            if (session != nil) {
    //                print("signed in as \(String(describing: session?.userName))");
    //
    //            } else {
    //                print("error: \(String(describing: error?.localizedDescription))");
    //            }
    //        })
    //
    //      //  Twitter.sharedInstance().logInWithMethods(TWTRLoginMethod.WebBased, completion: {(session, error) -> Void in
    //
    //    }
    
    
    
//    @objc var imageIdentifier: String? {
//        return self.tweetImageInfo?.profileImageLargeURL
//    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK:- FB login methods
extension LoginVC {
    
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
        btnFb.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
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
                        
                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "f", socialId: fbId, email: email, profile_pic: facebookProfileUrl!)
                    }
                }
            }
        }
    }
}

//MARK:- GoogleSignIn
extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate {
    
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
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email
            let profile_url:String?
            profile_url  = "\(user.profile.imageURL(withDimension: 100))"
            // ...
            print(userId!, idToken!, fullName!, firstName!, lastName!, email!)
            print("==========================")
            print("userId: \(userId!)")
            print("==========================")
            print("idToken: \(idToken!)")
            print("==========================")
            print("fullName: \(fullName!)")
            print("==========================")
            print("givenName: \(firstName!)")
            print("==========================")
            print("familyName: \(lastName!)")
            print("==========================")
            print("email:\(email!)")
            print("==========================")
            
             self.socilaLogin(fNm: firstName!, lNm: lastName!, loginType: "g", socialId: idToken!, email: email!,profile_pic:profile_url!)
            GIDSignIn.sharedInstance().signOut()
        } else {
            print("\(error)")
        }
    }
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
    // [END disconnect_handler]
    
    func fatchGenderFromGoolgeAPI(token:String, callback:@escaping (_ gender:String) -> Void ) {
        //https://stackoverflow.com/questions/35809947/how-to-retrieve-age-and-gender-from-google-sign-in
        let gplusapi = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(token)"
        let url = URL(string: gplusapi)!
        
        var request = URLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            do {
                let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:Any]
                //let picture = userData!["picture"] as! String
                //let gender = userData!["gender"] as! String
                //let locale = userData!["locale"] as! String
                callback(userData!["gender"] as? String ?? "" )
            } catch {
                print("Account Information could not be loaded")
            }
            
        }).resume()
    }
    
}
//MARK:- Login with LinkedIn
extension LoginVC {
    
    func requestProfile() {
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            print("Request success with response: \(response)")
            self.writeConsoleLine("Request success with response: \(response)")
            if response.statusCode == 200{
                guard let obj = response.jsonObject else {return}
                
                let fNm = obj["firstName"] as? String ?? ""
                let lNm = obj["lastName"] as? String ?? ""
                let email = obj["emailAddress"] as? String ?? ""
                let id = obj["id"] as? String ?? ""
                let linkdinProfileUrl:String?
                 linkdinProfileUrl = "http://api.linkedin.com/v1/people/\(id)/picture-url"
                self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "l", socialId: id, email: email,profile_pic: linkdinProfileUrl!)
                
                //                emailAddress = "ryangosling0983@gmail.com";
                //                firstName = "Ry'n";
                //                id = fDhWdOnDth;
                //                lastName = gosling;
                //                pictureUrl = "https://media.licdn.com/dms/image/C4E03AQGFP3uda49gSA/profile-displayphoto-shrink_100_100/0?e=1533772800&v=beta&t=OmqqccuHzneDx4OfLbL0MhkrkoGaQxUTaQxQdCc8b_g";
                //                pictureUrls =     {
                //                    "_total" = 1;
                //                    values =         (
                //                        "https://media.licdn.com/dms/image/C4E00AQHuV79iTxaCew/profile-originalphoto-shrink_450_600/0?e=1528286400&v=beta&t=8WeSbDE_1Q2H_yS55JX1gAy7ui2Nhx4JRnbwZkIIuaY"
                //                    );
                //                };
            }
            
            //TODO: Clear data of linkedIn
            //linkedinHelper.lsAccessToken = nil
            
        }) { [unowned self] (error) -> Void in
            print(error.localizedDescription)
            self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func writeConsoleLine(_ log: String, funcName: String = #function) {
        
        DispatchQueue.main.async { () -> Void in
            //            self.consoleTextView.insertText("\n")
            //            self.consoleTextView.insertText("-----------\(funcName) start:-------------")
            //            self.consoleTextView.insertText("\n")
            //            self.consoleTextView.insertText(log)
            //            self.consoleTextView.insertText("\n")
            //            self.consoleTextView.insertText("-----------\(funcName) end.----------------")
            //            self.consoleTextView.insertText("\n")
            //
            //            let rect = CGRect(x: self.consoleTextView.contentOffset.x, y: self.consoleTextView.contentOffset.y, width: self.consoleTextView.contentSize.width, height: self.consoleTextView.contentSize.height)
            //
            //            self.consoleTextView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    func loginWithLinkedInSwift() {
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            
            self.requestProfile()
            print("Login success lsToken: \(lsToken)")
            
            self.writeConsoleLine("Login success lsToken: \(lsToken)")
            }, error: { [unowned self] (error) -> Void in
                
                self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
            }, cancel: { [unowned self] () -> Void in
                
                self.writeConsoleLine("User Cancelled!")
        })
    }
}
