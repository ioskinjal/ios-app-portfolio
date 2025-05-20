//
//  LoginVC.swift
//  Explore Local
//
//  Created by NCrypted on 05/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import LinkedinSwift

var isSocialLogin:Bool?
class LoginVC: UIViewController {

    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    
    var iconClick = true
    
    static var storyboardInstance:LoginVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC
    }
    
//    let linkedinHelper = LinkedinSwiftHelper(configuration:
//        LinkedinSwiftConfiguration(clientId: "81ft1pua4vux9f", clientSecret: "Kpn3EulhgZDpP1aw", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://192.168.100.72/login/callback")
//    )
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "863cr4lylhmt2j", clientSecret: "umhXje6TXbxz08jN", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "https://explorelocalmerchants.com")
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sign In", action: #selector(onClickMenu(_:)))
        configureFacebook()
        configureGoogle()
    }

//    @objc func onClickMenu(_ sender: UIButton){
//        self.navigationController?.popViewController(animated: true)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickForgotPwd(_ sender: UIButton) {
        forgotPwd()
    }
    @IBAction func onClickSignIn(_ sender: UIButton) {
        if isValidated(){
            callLoginAPI()
        }
    }
    @IBAction func onClickResendLink(_ sender: Any) {
        resendLink()
    }
    
    @IBAction func onClickLinkdin(_ sender: UIButton) {
        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
//                if cookie.domain.contains("linkedin") {
                    cookieStorage.deleteCookie(cookie)
//                }
            }
        }
        loginWithLinkedInSwift()
    }
    @IBAction func onClickGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func onClickShowPWD(_ sender: UIButton) {
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
    
    func forgotPwd() {
        displayAlret { (email) in
            Modal.shared.login(vc: self, param: ["email":email,
                                                 "action":"forgot_password"]) { (dic) in
                print(dic)
                let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                self.alert(title: "", message: data)
            }
        }
    }
    
    func resendLink() {
        displayAlretResend { (email) in
            Modal.shared.login(vc: self, param: ["email":email,
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
            "email": txtEmail.text!,
            "password": txtPassword.text!,
            "action":"login",
            "device_id":UserData.shared.deviceToken,
            "device_type":"ios"]) { (dic) in

            //Set data for auto login
            let userData = [
                "email": self.txtEmail.text!,
                "password": self.txtPassword.text!
                ]
            _ = UserData.shared.setUserLoginData(dic: userData)

            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .user).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
//                                if isFromMenu == true {
//                                    self.dismiss(animated: true, completion: nil)
//                                }else {
//                Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
//                let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MSSideNavigationVC") as! MSSideNavigationVC
               //Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
//                let strPhone:String = data["contact_no"] as! String
//                if strPhone == "" {
//                    let nextVC = EditProfileVC.storyboardInstance!
//                    self.navigationController?.pushViewController(nextVC, animated: true)
//                }else{
                    //self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
                self.navigationController?.popViewController(animated: true)
                //}
                 //}
            })
        }
    }
    
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["first_name":fNm,
                        "last_name": lNm,
                        "provider_name": loginType,
                        "email": email,
                        "profile_image":profile_pic,
                        "device_id":UserData.shared.deviceToken,//UserData.shared.deviceToken,
                        "identifier":socialId,
                        "action":"social_login",
                        "device_type":"ios"
        ]
        //        switch loginType {
        //        case "g":
        //            dicParam["googleid"] = socialId
        //        case "f":
        //            dicParam["fbid"] = socialId
        //        case "l":
        //            dicParam["linkedinid"] = socialId
        //        default:
        //            break
        //        }
        Modal.shared.login(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .user).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
             
               Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
              //  let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MSSideNavigationVC") as! MSSideNavigationVC
              //  Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
                let strPhone:String?
                    strPhone = data["user_type"] as? String
                if strPhone == "3" {
                    let nextVC = SignUpVC.storyboardInstance!
                    nextVC.data = data as NSDictionary
                    nextVC.strProfileImage = profile_pic
                    nextVC.strId = socialId
                    nextVC.strType = loginType
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }else{
                    //self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
                    self.navigationController?.popViewController(animated: true)
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
            
            self.socilaLogin(fNm: firstName!, lNm: lastName!, loginType: "google", socialId: idToken!, email: email!,profile_pic:profile_url!)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LoginVC {
    
    func fatcheEmail(email: @escaping (String) -> Void) {
        self.linkedinHelper.requestURL("https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            print(response)
            //print(response.value(forKey: "pictureUrl") as! String)
            //parse this response which is in the JSON format
            if response.statusCode == 200{
                guard let obj = response.jsonObject else {return}
                print(obj)
                
                if let element = obj["elements"] as? [[String:Any]]{
                    print(element)
                    if let obj1 = element.first{
                        if let handle = (obj1["handle~"] as? [String:Any]), let emailId = handle["emailAddress"] as? String{
                            email(emailId)
                        }
                    }
                }
                
                
            }
        })
    }
    
    func requestProfile() {
        
        linkedinHelper.authorizeSuccess({ (token) in
            
            print(token)
            //This token is useful for fetching profile info from LinkedIn server
            
           
            //https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json
            self.linkedinHelper.requestURL("https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                print(response)
                //print(response.value(forKey: "pictureUrl") as! String)
                //parse this response which is in the JSON format
                if response.statusCode == 200{
                    guard let obj = response.jsonObject else {return}
                    
                    let fNm = obj["localizedFirstName"] as? String ?? ""
                    let lNm = obj["localizedLastName"] as? String ?? ""
                    //let email = obj["emailAddress"] as? String ?? ""
                    let id = obj["id"] as? String ?? ""
                    //let linkdinProfileUrl:String?
                    //let linkdinProfileUrl = "http://api.linkedin.com/v1/people/\(id)/picture-url"
                    let linkdinProfileUrl = "http://api.linkedin.com/v2/me?/\(id)/picture-url"
                    print(linkdinProfileUrl)
                    
                    self.fatcheEmail(email: { (email) in
                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "linkdin", socialId: id, email: email,profile_pic: linkdinProfileUrl)
                        
                        self.linkedinHelper.logout()
                    })
                    
                    
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
            }) {(error) -> Void in
                
                print(error.localizedDescription)
                //handle the error
            }
            
        }, error: { (error) in
            
            print(error.localizedDescription)
            //show respective error
        }) {
            //show sign in cancelled event
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
//        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
//        if let cookies = cookieStorage.cookies {
//            for cookie in cookies {
//                if cookie.domain.contains("linkedin") {
//                    cookieStorage.deleteCookie(cookie)
//                }
//            }
//        }
//
//        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
//
            self.requestProfile()
//            print("Login success lsToken: \(lsToken)")
//
//            self.writeConsoleLine("Login success lsToken: \(lsToken)")
//            }, error: { [unowned self] (error) -> Void in
//
//                self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
//            }, cancel: { [unowned self] () -> Void in
//
//                self.writeConsoleLine("User Cancelled!")
//        })
   }
}
