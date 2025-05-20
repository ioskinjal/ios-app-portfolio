//
//  SignUpVC.swift
//  XPhorm
//
//  Created by admin on 5/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
//import GoogleSignIn
//import LinkedinSwift

class SignUpVC: UIViewController {
    
    @IBOutlet weak var lblTrainer: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: SignInButton!
    @IBOutlet weak var txtConfirmPassword: Textfield!
    @IBOutlet weak var txtPassword: Textfield!
    @IBOutlet weak var txtEmail: Textfield!
    @IBOutlet weak var txtLastName: Textfield!
    @IBOutlet weak var txtFirstName: Textfield!
    
    @IBOutlet weak var btnCheck: UIButton!
    
//    let linkedinHelper = LinkedinSwiftHelper(configuration:
//        LinkedinSwiftConfiguration(clientId: "81lm3etdbnq6sw", clientSecret: "1n2KMHTsDvYCgIU7", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "https://xphorm.ncryptedprojects.com/auth/linkedin/callback")
//    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebook()
//        configureGoogle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage()
    {
        btnSignIn.setTitle("Already have an account? Sign In".localized, for: .normal)
        lblTrainer.text = "Sign Up".localized
        txtFirstName.placeholder = "First name".localized
        txtLastName.placeholder = "Last name".localized
        txtEmail.placeholder = "Email".localized
        txtPassword.placeholder = "Password".localized
        txtConfirmPassword.placeholder = "Confirm Password".localized
        btnSignUp.setTitle("Sign Up".localized, for: .normal)
    }
    
//    @IBAction func onClickLinkdin(_ sender: UIButton) {
//        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
//        if let cookies = cookieStorage.cookies {
//            for cookie in cookies {
//                cookieStorage.deleteCookie(cookie)
//            }
//        }
//        loginWithLinkedInSwift()
//    }
    
//    @IBAction func onClickGoogle(_ sender: UIButton) {
//        GIDSignIn.sharedInstance().signIn()
//    }
    
    @IBAction func onClickCheck(_ sender: Any) {
        if btnCheck.currentImage == #imageLiteral(resourceName: "checkedIcon"){
            btnCheck.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
        }else{
            btnCheck.setImage(#imageLiteral(resourceName: "checkedIcon"), for: .normal)
        }
    }
    @IBAction func onClickForgotPwd(_ sender: UIButton) {
        self.navigationController?.pushViewController(ForgotPasswordVC.storyboardInstance!, animated: true)
    }
    
    @IBAction func onClickPrivacy(_ sender: Any) {
        let nextVC = TermsVC.storyboardInstance!
        nextVC.navTitle = "Privacy Policy"
        nextVC.strUrl = "https://xphorm.ncryptedprojects.com/content/7"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickTerms(_ sender: Any) {
        let nextVC = TermsVC.storyboardInstance!
        nextVC.navTitle = "Terms & Conditions"
        nextVC.strUrl = "https://xphorm.ncryptedprojects.com/content/6"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickSignIn(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func onClickSignUp(_ sender: SignInButton) {
        if isValidated(){
            let param : [String:String]
            //  let userType = selectedUserType["tbl_user_type_id"]
            param = [
                "action":"signup",
                "email":txtEmail.text!,
                "psw":txtPassword.text!,
                "firstname":txtFirstName.text!,
                "lastname":txtLastName.text!,
                "lId":UserData.shared.getLanguage
            ]
            Modal.shared.signUp(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.txtFirstName.text = ""
                    self.txtLastName.text = ""
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""
                    self.txtConfirmPassword.text = ""
                    self.tabBarController?.selectedIndex = 0
                    
                })
                
            }
        }
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        if sender.tag == 0{
            self.tabBarController?.selectedIndex = 0
        }else{
            self.tabBarController?.selectedIndex = 1
        }
    }
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter a first name".localized
        }else  if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter a last name".localized
        }else  if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email address".localized
        } else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Please enter a valid email id".localized
        }else if (txtPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter password".localized
        }
        else  if (txtConfirmPassword.text?.isEmpty)! {
            ErrorMsg = "Please enter confirm password".localized
        }else  if txtPassword.text != txtConfirmPassword.text {
            ErrorMsg = "confirm password doesn't match with password".localized
        }else if btnCheck.currentImage != #imageLiteral(resourceName: "checkedIcon"){
            ErrorMsg = "please accept terms & conditions"
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
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
//MARK:- FB login methods
extension SignUpVC {
    
    
    func configureFacebook(){
        
        btnFB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        LoginManager().logOut()
        
    }
    @IBAction func onClickInsta(_ sender: UIButton) {
        let nextVC = InstaViewController.storyboardInstance!
        nextVC.isFromLogin = true
        self.navigationController?.pushViewController(nextVC, animated: true)
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
                    
                    self.getFBUserData()
                    
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
                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "facebook", socialId: fbId, email: email, profile_pic: facebookProfileUrl!)
                    }
                }
            }
        }
    }
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["first_name":fNm,
                        "last_name": lNm,
                        "provider": loginType,
                        "email": email,
                        "thumbnail":profile_pic,
                        "deviceId":UserData.shared.deviceToken,//UserData.shared.deviceToken,
            "action":"submitSocial",
            "deviceType":"i",
            "lId":UserData.shared.getLanguage,
            "id":socialId
        ]
        
        Modal.shared.signUp(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            
            let userData = [
                "email": self.txtEmail.text!,
                "password": self.txtPassword.text!,
            ]
            _ = UserData.shared.setUserLoginData(dic: userData)
            
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = viewController;
            })
        }
    }
}

//MARK:- GoogleSignIn
//extension SignUpVC: GIDSignInDelegate, GIDSignInUIDelegate {
//
//    func configureGoogle() {
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
//            GIDSignIn.sharedInstance().signOut()
//
//        }
//
//    }
//
//    //MARK: Google Delegate
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//    }
//
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let firstName = user.profile.givenName
//            let lastName = user.profile.familyName
//            let email = user.profile.email
//            let profile_url:String?
//            profile_url  = "\(String(describing: user.profile.imageURL(withDimension: 100)))"
//            // ...
//
//            self.socilaLogin(fNm: firstName!, lNm: lastName!, loginType: "google", socialId: idToken!, email: email!,profile_pic:profile_url!)
//            GIDSignIn.sharedInstance().signOut()
//        } else {
//            print("\(error)")
//        }
//    }
//

//    // [START disconnect_handler]
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//
//    }
//    // [END disconnect_handler]
//
//    func fatchGenderFromGoolgeAPI(token:String, callback:@escaping (_ gender:String) -> Void ) {
//        //https://stackoverflow.com/questions/35809947/how-to-retrieve-age-and-gender-from-google-sign-in
//        let gplusapi = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(token)"
//        let url = URL(string: gplusapi)!
//
//        var request = URLRequest(url: url as URL)
//        request.httpMethod = "GET"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//        let session = URLSession.shared
//
//        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
//            DispatchQueue.main.async {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            }
//            do {
//                let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:Any]
//
//                callback(userData!["gender"] as? String ?? "" )
//            } catch {
//                print("Account Information could not be loaded")
//            }
//
//        }).resume()
//    }
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}
//extension SignUpVC {
//
//    func fatcheEmail(email: @escaping (String) -> Void) {
//        self.linkedinHelper.requestURL("https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
//
//            print(response)
//
//            if response.statusCode == 200{
//                guard let obj = response.jsonObject else {return}
//                print(obj)
//
//                if let element = obj["elements"] as? [[String:Any]]{
//                    print(element)
//                    if let obj1 = element.first{
//                        if let handle = (obj1["handle~"] as? [String:Any]), let emailId = handle["emailAddress"] as? String{
//                            email(emailId)
//                        }
//                    }
//                }
//
//
//            }
//        })
//    }
//
//    func requestProfile() {
//
//        linkedinHelper.authorizeSuccess({ (token) in
//
//            print(token)
//            self.linkedinHelper.requestURL("https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
//
//                print(response)
//
//                if response.statusCode == 200{
//                    guard let obj = response.jsonObject else {return}
//
//                    let fNm = obj["localizedFirstName"] as? String ?? ""
//                    let lNm = obj["localizedLastName"] as? String ?? ""
//
//                    let id = obj["id"] as? String ?? ""
//
//                    let linkdinProfileUrl = "http://api.linkedin.com/v2/me?/\(id)/picture-url"
//                    print(linkdinProfileUrl)
//
//                    self.fatcheEmail(email: { (email) in
//                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "linkdin", socialId: id, email: email,profile_pic: linkdinProfileUrl)
//
//                        self.linkedinHelper.logout()
//                    })
//
//                }
//            }) {(error) -> Void in
//
//                print(error.localizedDescription)
//                //handle the error
//            }
//
//        }, error: { (error) in
//
//            print(error.localizedDescription)
//            //show respective error
//        }) {
//            //show sign in cancelled event
//        }
//    }
//
//    fileprivate func writeConsoleLine(_ log: String, funcName: String = #function) {
//
//        DispatchQueue.main.async { () -> Void in
//
//        }
//    }
//
//    func loginWithLinkedInSwift() {
//
//        self.requestProfile()
//
//    }
//}
