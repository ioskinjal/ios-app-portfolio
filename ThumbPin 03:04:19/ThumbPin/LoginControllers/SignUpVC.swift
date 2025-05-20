//
//  SignUpVC.swift
//  ThumbPin
//
//  Created by NCT109 on 17/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import GooglePlaces
import FacebookCore
import FacebookLogin
import GoogleSignIn
import LinkedinSwift

class SignUpVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var labelOrSignInWith: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var labelSignUp: UILabel!
    @IBOutlet weak var labelLine: UILabel!{
        didSet {
            labelLine.createCorenerRadius()
        }
    }
    @IBOutlet weak var txtName: LineCustomTextField!
    @IBOutlet weak var txtEmail: LineCustomTextField!
    @IBOutlet weak var txtPassword: LineCustomTextField!
    @IBOutlet weak var txtConfirmPassword: LineCustomTextField!
    @IBOutlet weak var txtContactNo: LineCustomTextField!{
        didSet{
            txtContactNo.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtEnterLocation: LineCustomTextField!
    @IBOutlet weak var txtABNNumber: LineCustomTextField!
    
    
    static var storyboardInstance:SignUpVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC
    }
    var userType = ""
    var lattitude = ""
    var longitude = ""
    
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "81tzlaeu6z3c4b", clientSecret: "gT5h3GuH6tbBsYsu", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "http://justinthumbpin.ncryptedprojects.com/auth/linkedin/callback")
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEnterLocation.delegate = self
        isSetUpStatusBar = false
        configureFacebook()
        configureGoogle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
    }
    func setUpLang() {
        labelSignUp.text = localizedString(key: "Sign Up")
        txtName.placeholder = localizedString(key: "Name*")
        txtEmail.placeholder = localizedString(key: "Email*")
        txtPassword.placeholder = localizedString(key: "Password*")
        txtConfirmPassword.placeholder = localizedString(key: "Confirm password")
        txtContactNo.placeholder = localizedString(key: "Contact No*")
        txtEnterLocation.placeholder = localizedString(key: "Enter Location*")
    }
    func callApiSignup() {
        let dictParam = [
            "action": Action.signup,
            "user_type": userType,
            "email": txtEmail.text!,
            "password": txtPassword.text!,
            "contact": txtContactNo.text!,
            "location": txtEnterLocation.text!,
            "latitude": lattitude,
            "longitude": longitude,
            "device_id": "",
            "name": txtName.text!,
            "lId": UserData.shared.getLanguage,
            "abn_num":txtABNNumber.text!
        ] as [String : Any]
        ApiCaller.shared.signUp(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
//            let data = ResponseKey.fatchData(res: dict, valueOf: .data).dic
//            _ = UserData.shared.setUser(dic: data)
//            let user = UserData.shared.getUser()!
//            print(user.user_email)
//            self.navigationController?.pushViewController(HomeVC.storyboardInstance!, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEnterLocation {
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
        }
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtName.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.name)
            return false
        }
       else if (txtName.text?.count)! < 3 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.nameValid)
            return false
        }
        else if (txtEmail.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return false
        }
        else if AppHelper.isValidEmail(txtEmail.text!) == false {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.validEmail)
            return false
        }
        else if (txtPassword.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.password)
            return false
        }
        else if (txtPassword.text?.count)! < 6 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.miniPass)
            return false
        }
        else if (txtConfirmPassword.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.confirmpassword)
            return false
        }
        else if (txtConfirmPassword.text?.count)! < 6 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.miniPass)
            return false
        }
        else if txtConfirmPassword.text != txtPassword.text {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.matchPassword)
            return false
        }
        else if (txtContactNo.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.contactno)
            return false
        }
        else if (txtContactNo.text?.count)! < 10 || (txtContactNo.text?.count)! > 11{
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.miniPhone)
            return false
        }
        else if (txtEnterLocation.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.address)
            return false
        }
        if userType == localizedString(key:"provide"){
         if (txtABNNumber.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.ABNMumber)
            return false
        }
    }
        return true
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickGoogle(_ sender: Any) {
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
        self.requestProfile()
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        if checkValidation() {
            callApiSignup()
        }
    }
    
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["action":"social-signup",
                        "lId": UserData.shared.getLanguage,
                        "user_type":"",
                        "name":fNm,
                        "email": email,
                        "device_id":UserData.shared.deviceToken,//UserData.shared.deviceToken,
            "type":loginType
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
        ApiCaller.shared.signUp(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                let user = UserData.shared.getUser()!
                
                if user.user_type == "1" {
                    appDelegate?.sideMenuController.rootViewController = HomeCustomerVC.storyboardInstance!
                    appDelegate?.sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
                    
                }else if user.user_type == "2"{
                    appDelegate?.sideMenuController.rootViewController = HomeProfileVC.storyboardInstance!
                    appDelegate?.sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
                }
                if user.user_type == "" || user.user_type == "0"{
                    self.navigationController?.pushViewController(ChooseSignUpTypeVC.storyboardInstance!, animated: true)
                }else{
                    appDelegate?.getOfflineData()
                    self.navigationController?.pushViewController(appDelegate!.sideMenuController, animated: true)
                }
                // }
            })
        }
    }
    
    
}

extension SignUpVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place addressComponents: \(String(describing: place.addressComponents))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        let formatedAddre = place.formattedAddress
        //  textFieldLocation.text = formatedAddre
        //  cityName = ""
        //  stateName = ""
        //  countryame = ""
        txtEnterLocation.text = formatedAddre
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    print(field.name)
                //  street_number = field.name
                case kGMSPlaceTypeRoute:
                    print(field.name)
                //route = field.name
                case kGMSPlaceTypeNeighborhood:
                    print(field.name)
                //   neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    print(field.name)
                    //  txtCity.text = field.name
                //   cityName = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    print(field.name)
                    //  txtState.text = field.name
                //   stateName = field.name
                case kGMSPlaceTypeCountry:
                    print(field.name)
                    //  txtCountry.text = field.name
                //  countryame = field.name
                case kGMSPlaceTypePostalCode:
                    print(field.name)
                    //  txtZip.text = field.name
                // postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    print(field.name)
                    // postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        // filterCustom.latLong = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        //  fillAddress()
        lattitude = "\(place.coordinate.latitude)"
        longitude = "\(place.coordinate.longitude)"
        print(place.coordinate)
        dismiss(animated: true) {
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
//MARK:- FB login methods
extension SignUpVC {
    
    
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
