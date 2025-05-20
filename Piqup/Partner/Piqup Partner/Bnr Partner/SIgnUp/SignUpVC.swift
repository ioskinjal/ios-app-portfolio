//
//  SignUpVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices.UTType
import FacebookCore
import FacebookLogin
import GoogleSignIn

class SignUpVC: BaseVC,CodeDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!{
        didSet{
            txtMobileNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    var isSocialLogin = false
    var selectedImage:UIImage?
    var selectedImageName:String?
    let imagePicker = UIImagePickerController()
    let selfieImagePickerView = UIImagePickerController()
    var selectedCode = CountryCode()
    var documentItems = [Document]()
    
    var countryCodes = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountryCodes()
        selectedCode.country_code = "+91"
        configureGoogle()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCountryCodes(){
        
        let params: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        startIndicator(title: "")
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.countryCode, parameters: params, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let codes = CountryCode.initWithResponse(array: (dataAns as! [Any]))
                self.countryCodes = codes as NSArray
                
                for code in self.countryCodes {
                    
                    let newCode = code as! CountryCode
                    
                    if newCode.country_code == "+91"
                    {
                        self.selectedCode = newCode
                        break
                    }
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Mobile Number textfield max length is fixed to 15
        if textField == self.txtMobileNumber {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered:String = compSepByCharInSet.joined(separator: "")
            let totalText:String = describe(self.txtMobileNumber.text)
            
            if (string == numberFiltered) && (totalText.count <= 14) {
                return true
            }
            else if string == "" {
                return true
            }
            else{
                return false
            }
            
        }
        
        return true
    }
    
    
    // MARK: - Register User
    func register(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let params: Parameters = [
                "firstName": String(describe(txtFirstName.text)),
                "lastName": String(describe(txtLastName.text)),
                "email": String(describe(txtEmail.text)),
                "mobileNo": String(describe(txtMobileNumber.text)),
                "password": String(describe(txtPassword.text)),
                "countryCode": selectedCode.typeId
            ]
            
            
            let alert = Alert()
            
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.register, parameters: params, successBlock: { (json, urlResponse) in
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        alert.showAlertWithCompletionHandler(titleStr: appConts.const.lBL_SUCCESS, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        //alert.showAlertAndPopVC(titleStr: "Success", messageStr: message, buttonTitleStr: "OK")
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        alert.showAlert(titleStr: appConts.const.bTN_OK, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                    // self.navigationController?.present(oopsVC, animated: true, completion: nil)
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }
        else{
            displayNetworkAlert()
        }
    }
    
    // MARK: - Code Delegate method
    func didSelectCode(code: CountryCode) {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? SignUpVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        selectedCode = code
        lblCountryCode.text = code.country_code
    }
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        
        
        //        if let fileName = (asset.value(forKey: "filename")) as? String {
        //            print("\(fileName)")
        //            return fileName
        //        }
        
        //
        //        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
        //            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
        //                print(imageURL)
        //            }
        //            self.selectedImage = pickedImage
        //            self.selectedImageName = picker.getPickedFileName(info: info)
        //            self.lblImgName.text = selectedImageName
        //              //  self.userProfileImageHeightConstraint.constant = 80
        //               // self.userProfileImage.image = pickedImage
        //              //  self.view.layoutIfNeeded()
        //               // self.isSelfie = true
        //        }
        
        //1
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        //2
        //        if let _ = selectedImage {
        //            self.selectedImageName = picker.getPickedFileName(info: info)
        //        }
        
        if let pickedURL = info[UIImagePickerControllerReferenceURL] as? URL {
            print(pickedURL.lastPathComponent)
            self.selectedImageName = pickedURL.lastPathComponent
        }
        
        self.selectedImage = selectedImage
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if self.countryCodes.count > 0 {
            let codeController = CountryCodeVC(nibName: "CountryCodeVC", bundle: nil)
            codeController.delegate = self
            codeController.codes = self.countryCodes
            self.addChildViewController(codeController)
            view.addSubview(codeController.view)
            
            codeController.view.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            let trailingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            let topConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
            self.view.layoutIfNeeded()
            
            codeController.didMove(toParentViewController: self)
        }
        else{
            let alert = Alert()
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_COUNTRY_SELECTION    , buttonTitleStr: appConts.const.bTN_OK)
        }
    }
    
    @IBAction func onClickTerms(_ sender: UIButton) {
        let termsVC = Terms_ConditionsVC.storyboardInstance!
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    @IBAction func onClickTermsCheck(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "checkbox_deselected"){
            sender.setImage(#imageLiteral(resourceName: "checkbox_selected"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "checkbox_deselected"), for: .normal)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onclickSignIn(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        let validate = Validator()
        let alert = Alert()
        
        if (txtFirstName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_FIRST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtLastName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_LAST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtMobileNumber.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.pLEASE_ENTER_MOBILE_NO, buttonTitleStr: appConts.const.bTN_OK)
        }else if txtMobileNumber.text?.count != 10{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: "please enter valid mobile number", buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_PASSWORD, buttonTitleStr: appConts.const.bTN_OK)
        }else{
            self.view.endEditing(true)
            register()
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
            "userType": "d",
            
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
            "userType": "d",
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
    @IBAction func onClickGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnFacebokClicked(_ sender: Any) {
        
        //facebookBtn.isUserInteractionEnabled = false
        loginToFacebook()
    }
    
}
//MARK:- GoogleSignIn
extension SignUpVC: GIDSignInDelegate {
    
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
