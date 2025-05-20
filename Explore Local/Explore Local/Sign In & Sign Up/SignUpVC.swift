//
//  SignUpVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import LinkedinSwift



class SignUpVC: BaseViewController {

    @IBOutlet weak var viewConfirmPWD: UIView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtLastname: UITextField!
    
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "863cr4lylhmt2j", clientSecret: "umhXje6TXbxz08jN", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "https://explorelocalmerchants.com")
    )
    
    var strProfileImage:String?
    var data:NSDictionary?
    var strId:String?
    var strType:String?
    var userType = [[
        "tbl_user_type_id": "1",
        "name": "User"       ],[
            "tbl_user_type_id": "2",
            "name":"Merchant"      ]]
    var selectedUserType:[String:String] = [:]
    
    @IBOutlet weak var txtUserType: UITextField!{
        didSet {
        let userTypePickerView = UIPickerView()
        userTypePickerView.delegate = self
         txtUserType.delegate = self
        txtUserType.inputView = userTypePickerView
        txtUserType.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
        }
    }
    @IBOutlet weak var txtFirstName: UITextField!
    static var storyboardInstance:SignUpVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC
    }
    
    override func viewDidLoad() {
        if isSocialLogin == true {
            let array:NSArray = UserData.shared.getUser()?.name.components(separatedBy: " ") as NSArray? ?? []
            self.txtFirstName.text = array[0] as? String
                self.txtLastname.text = array[1] as? String
            self.txtEmail.text = UserData.shared.getUser()?.email
            self.viewPassword.isHidden = true
            self.viewConfirmPWD.isHidden = true
        }
        super.viewDidLoad()
      //  setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sign Up", action: #selector(onClickMenu(_:)))
        self.navigationBar.isHidden = true
        configureFacebook()
        configureGoogle()
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func callSignUpAPI() {
        if isValidated(){
            let param : [String:String]
          //  let userType = selectedUserType["tbl_user_type_id"]
             param = [
                "action":"signup",
                "email":txtEmail.text!,
                "password":txtPassword.text!,
                "first_name":txtFirstName.text!,
                "last_name":txtLastname.text!,
                "tbl_user_type_id":"1"
            ]
            Modal.shared.signUp(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    if isFromPlan{
                        self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
                    }else{
                     self.navigationController?.popViewController(animated: true)
                    }
                })
               
            }
        }
    }

    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter a first name"
        }else  if (txtLastname.text?.isEmpty)! {
            ErrorMsg = "Please enter a last name"
        }else  if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email address"
        } else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Please enter a valid email id"
        }
//        else if (txtUserType.text?.isEmpty)! {
//            ErrorMsg = "Please select user type"
//        }
        
        if viewPassword.isHidden == false {
           if (txtPassword.text?.isEmpty)! {
                ErrorMsg = "Please enter password"
            }
            else  if (txtConfirmPassword.text?.isEmpty)! {
                ErrorMsg = "Please enter confirm password"
            }else  if txtPassword.text != txtConfirmPassword.text {
                ErrorMsg = "confirm password doesn't match with password"
            }
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
    //MARK:- UIButton Click Events
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
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
    
    @IBAction func onClickShowPassword(_ sender: UIButton) {
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        if isValidated(){
            if isSocialLogin == true{
                socilaLogin(fNm: txtFirstName.text!, lNm: txtLastname.text!, loginType: strType!, socialId: strId!, email: txtEmail.text!, profile_pic: strProfileImage!)
            }else{
            callSignUpAPI()
            }
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
      
        Modal.shared.login(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .user).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                //   Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
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
                    if isFromPlan{
                    self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.pushViewController(HomeVC.storyboardInstance!, animated: true)
                    }
                }
                // }
            })
        }
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
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  userType.count
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        let dic = countryList[row] as! NSDictionary
    //        let name = dic.object(forKey: "country_name") as! String
    //        let code = dic.object(forKey: "phone_code")as! String
    //        let str = name + " (\(code))"
    //        return str
    //    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUserType = userType[row]
        
        let dic = userType[row]
        let name = dic["name"] ?? ""
        //let code = dic["phone_code"] ?? ""
        let str = name
        txtUserType.text = str
       
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.font = RobotoFont.regular(with: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
            let dic = userType[row]
            let name = dic["name"] ?? ""
            let str = name
            label.text = str
        
        
        return label
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUserType {
            return false
        }
        else {
            return true
        }
    }
    
}
//MARK:- FB login methods
extension SignUpVC {
    
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
        btnFacebook.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
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
extension SignUpVC: GIDSignInDelegate, GIDSignInUIDelegate {
    
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
extension SignUpVC {
    
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
    
    
    func loginWithLinkedInSwift() {
        
        self.requestProfile()
       
    }
}
