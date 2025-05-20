//
//  SignUpVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import PuiSegmentedControl
import FacebookCore
import FacebookLogin

class SignUpVC: BaseViewController {

    var unselectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : TitilliumWebFont.regular(with: 17.0),
        .foregroundColor : UIColor.black
    ]
    var selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : TitilliumWebFont.regular(with: 17.0),
        .foregroundColor : UIColor.black
    ]
    
    @IBOutlet weak var segmentControl: PuiSegmentedControl!
    @IBOutlet weak var viewContact: UIView!{
        didSet{
            viewContact.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewLastName: UIView!{
        didSet{
            viewLastName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewFirstName: UIView!{
        didSet{
            viewFirstName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
   
    @IBOutlet weak var txtStoreName: UITextField!
    @IBOutlet weak var viewStore: UIView!{
        didSet{
            viewStore.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewConfirmPWD: UIView!{
        didSet{
            viewConfirmPWD.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewPassword: UIView!{
        didSet{
            viewPassword.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!{
        didSet{
            txtContactNumber.keyboardType = .numberPad
        }
    }
    var userType:String = ""
    var strProfileImage:String?
    var data:NSDictionary?
    var strId:String?
    var strType:String?
    var categoryList = [CategoryList]()
    var selectedCategoryList = [CategoryList]()
   
    @IBOutlet weak var txtFirstName: UITextField!
    static var storyboardInstance:SignUpVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC
    }
    
    override func viewDidLoad() {
        if isSocialLogin == true {
            let array:NSArray = UserData.shared.getUser()!.username.components(separatedBy: " ") as NSArray
            self.txtFirstName.text = array[0] as? String
                self.txtLastname.text = array[1] as? String
            self.txtEmail.text = UserData.shared.getUser()?.email_address
            self.viewPassword.isHidden = true
            self.viewConfirmPWD.isHidden = true
        }
        super.viewDidLoad()
       
        self.navigationBar.isHidden = true
        
        segmentControl.isSelectViewAllCornerRadius = true
        segmentControl.isAnimatedTabTransation = true
        segmentControl.items = ["Customer", "Merchant"]
        segmentControl.backgroundCornerRadius = segmentControl.frame.height / 2
        segmentControl.borderCornerRadius = segmentControl.frame.height / 2
        selectedTextAttributes[.foregroundColor] = UIColor.white
        unselectedTextAttributes[.foregroundColor] = UIColor.black
        segmentControl.selectedTextAttributes = selectedTextAttributes
        segmentControl.unselectedTextAttributes = unselectedTextAttributes
        segmentControl.selectedViewBackgroundColor = UIColor.init(hexString: "E0171E")
        segmentControl.selectedIndex = 0
        didValueChanged(segmentControl)
        
        configureFacebook()
    }
    
    @IBAction func onClickFB(_ sender: UIButton) {
        
        
    }
    //    func callCategory(){
//        let param = ["action":"categorylist"]
//
//        Modal.shared.getCategory(vc: self, param: param) { (dic) in
//            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .date).map({CategoryList(dic: $0 as! [String:Any])})
//            if self.categoryList.count != 0{
//                self.categoryPickerView.reloadAllComponents()
//            }
//        }
//    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func callSignUpAPI() {
        if isValidated(){
            var param = [String:String]()
          
             param = [
                "signup_email_address":txtEmail.text!,
                "signup_password":txtPassword.text!,
                "confirm_password":txtConfirmPassword.text!,
                "first_name":txtFirstName.text!,
                "last_name":txtLastname.text!,
                "contact_no":txtContactNumber.text!,
            ]
            
            if userType == "Merchant"{
                param["action"] = "merchant-signup"
                param["store_name"] = txtStoreName.text!
            }else{
                param["action"] = "customer-signup"
            }
            
            if userType == "Merchant"{
            Modal.shared.merchantSignUp(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                     self.navigationController?.popViewController(animated: true)
                })
               
            }
            }else{
                Modal.shared.signUp(vc: self, param: param) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }
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
        }else if (txtContactNumber.text?.isEmpty)! {
            ErrorMsg = "Please enter contact number"
        }else if txtContactNumber.text?.length != 10 {
            ErrorMsg = "Please enter valid contact number"
        }
       
       if viewStore.isHidden == false{
        if (txtStoreName.text?.isEmpty)! {
            ErrorMsg = "Please enter store name"
        }
        }
        
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
  
    @IBAction func onClickBlack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didValueChanged(_ sender: PuiSegmentedControl) {
        if sender.selectedIndex == 0 {
            userType = "Customer"
            viewStore.isHidden = true
        }else{
            userType = "Merchant"
            viewStore.isHidden = false
        }
        
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignUpVC.storyboardInstance!, animated: true)
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
        
        var dicParam = ["first_name":fNm,
                        "last_name": lNm,
                        "deviceToken": UserData.shared.deviceToken,
                        "signup_email_address": email,
                        "deviceType":"iphone",
                        "app_token":socialId,
                        "action":"social-signup"
            ] as [String : Any]
       
        if userType == "Customer"{
            dicParam["user_type"] = "c"
        }else{
           dicParam["user_type"] = "m"
        }
        if email == ""{
            let nextVC = UpdateEmailVC.storyboardInstance!
            nextVC.dictParam = dicParam
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
        Modal.shared.socialSignUp(vc: self, param: dicParam) { (dic) in
            print("Social Login respoence: \(dic)")
            isSocialLogin = true
            self.txtEmail.text = nil
            self.txtPassword.text = nil
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
//                Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
//                let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MSSideNavigationVC") as! MSSideNavigationVC
//                Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
//                let strPhone:String = data["usertype"] as! String
//                if strPhone == "" {
//                    let nextVC = SignUpVC.storyboardInstance!
//                    nextVC.strProfileImage = profile_pic
//                    nextVC.strId = socialId
//                    self.navigationController?.pushViewController(nextVC, animated: true)
               // }else{
//                    self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
               // }
                // }
            })
        }
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

extension SignUpVC {
    
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
        btnFB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        LoginManager().logOut()
        //let loginManager = LoginManager().
        //loginManager.logOut()
    }
    
    @objc func loginButtonClicked() {
        var message:String = ""
        if userType == "Customer"{
            message = "Are you sure you want to sign up as customer ?"
        }else{
            message = "Are you sure you want to sign up as merchant ?"
        }
        let refreshAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
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
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
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


