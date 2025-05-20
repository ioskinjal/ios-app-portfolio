//
//  ViewController.swift
//  ThumbPin
//
//  Created by NCT109 on 17/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import HSCycleGalleryView
import FacebookCore
import FacebookLogin
import GoogleSignIn
import LinkedinSwift

var isSocialLogin:Bool?
class ViewController: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var imgvwGuide: UIImageView!
    @IBOutlet weak var viewGuide: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnDontHaveAnAccount: UIButton!
    @IBOutlet weak var labelOrSignInWithStatic: LabelMuliRegular13!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var labelLine: UILabel!{
        didSet {
            labelLine.createCorenerRadius()
        }
    }
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var labelSignInStatic: UILabel!
    @IBOutlet weak var labelThumbPin: UILabel!
    @IBOutlet weak var txtPassword: LineCustomTextField!
    @IBOutlet weak var txtEmail: LineCustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
   // @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewForgotPass: UIView!
    @IBOutlet weak var txtEmailForgot: LineCustomTextField!
    @IBOutlet weak var labelTitleForgotPass: UILabel!
    @IBOutlet weak var labelResendEmail: LabelMuliRegular13!
    var pager = HSCycleGalleryView()
    
    
    var isForgotPass = ""
    var arrGuide = ["Post your request","Get quotes","Hire Professionals","Post review"]
    var arrPic = ["pic_1","pic_2","pic_3","pic_4"]
    var currentGuideIndex = 1
    
    let linkedinHelper = LinkedinSwiftHelper(configuration:
        LinkedinSwiftConfiguration(clientId: "81tzlaeu6z3c4b", clientSecret: "gT5h3GuH6tbBsYsu", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "http://justinthumbpin.ncryptedprojects.com/auth/linkedin/callback")
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSetUpStatusBar = false
//        if (UserData.shared.getUser()?.user_id) != nil {
//            self.navigationController?.pushViewController(HomeCustomerVC.storyboardInstance!, animated: false)
//        }
        if UserData.shared.getGuideValue.isEmpty {
            viewContainer.isHidden = false
            UserData.shared.setGuideValue(language: "1")
        }else {
            viewContainer.isHidden = true
        }
        resendEmail()
        setUpDisplayUI()
        
        configureFacebook()
        configureGoogle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        showCarouselView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isSetUpStatusBar = false
    }
    func showCarouselView() {
        viewGuide.updateConstraints()
        viewGuide.layoutIfNeeded()
        view.layoutIfNeeded()
        pager = HSCycleGalleryView(frame: CGRect(x: 0, y: 0, width: viewGuide.frame.width, height: viewGuide.frame.height))
        pager.register(nib: UserGuideCell.nib, forCellReuseIdentifier: UserGuideCell.identifier)
        pager.delegate = self
        self.viewGuide.addSubview(pager)
        self.pager.reloadData()
        //pager.scrollToSpecificIndex(1)
    }
    func setUpDisplayUI() {
        labelSignInStatic.font = MuliFont.regular(with: FontSize.large.rawValue)
        labelSignInStatic.textColor = Color.Custom.blackColor
        txtEmail.font = MuliFont.regular(with: FontSize.medium.rawValue)
        txtEmail.textColor = Color.Custom.blackColor
        txtPassword.font = MuliFont.regular(with: FontSize.medium.rawValue)
        txtPassword.textColor = Color.Custom.blackColor
        btnLogin.titleLabel?.font = MuliFont.bold(with: FontSize.medium.rawValue)
        btnLogin.titleLabel?.textColor = Color.Custom.blackColor
        labelResendEmail.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelResendEmail.textColor = Color.Custom.blackColor
        labelOrSignInWithStatic.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelOrSignInWithStatic.textColor = Color.Custom.darkGrayColor
        btnForgotPassword.titleLabel?.font = MuliFont.regular(with: FontSize.small.rawValue)
        btnForgotPassword.titleLabel?.textColor = Color.Custom.blackColor
        btnDontHaveAnAccount.titleLabel?.font = MuliFont.regular(with: FontSize.small.rawValue)
        btnDontHaveAnAccount.titleLabel?.textColor = Color.Custom.blackColor
        labelLine.backgroundColor = Color.Custom.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callApiLogin() {
        let dictParam = [
            "action": Action.login,
            "email": txtEmail.text!,
            "password": txtPassword.text!,
            "device_id": UserData.shared.deviceToken,
            "device_type": "ios",
            "lId": UserData.shared.getLanguage
        ] as [String : Any]
        ApiCaller.shared.login(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            let data = ResponseKey.fatchData(res: dict, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let user = UserData.shared.getUser()!
            print(user.user_email)
            if user.user_type == "1" {
                appDelegate?.sideMenuController.rootViewController = HomeCustomerVC.storyboardInstance!
                appDelegate?.sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
                
            }else {
                appDelegate?.sideMenuController.rootViewController = HomeProfileVC.storyboardInstance!
                appDelegate?.sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
            }
            appDelegate?.getOfflineData()
            self.navigationController?.pushViewController(appDelegate!.sideMenuController, animated: true)
        }
    }
    func callApiForgotPass() {
        let dictParam = [
            "action": Action.forgotpassword,
            "email": txtEmailForgot.text!,
            "lId": UserData.shared.getLanguage
            ] as [String : Any]
        ApiCaller.shared.login(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.viewBackGround.isHidden = true
            self.viewForgotPass.isHidden = true
        }
    }
    func callApiResendActicvationEmail() {
        let dictParam = [
            "action": Action.sendReactivateEmail,
            "email": txtEmailForgot.text!,
            "lId": UserData.shared.getLanguage
            ] as [String : Any]
        ApiCaller.shared.resendActivationMail(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.viewBackGround.isHidden = true
            self.viewForgotPass.isHidden = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == viewBackGround {
            viewBackGround.isHidden = true
            viewForgotPass.isHidden = true
        }
    }
    func setUpLang() {
        labelSignInStatic.text = localizedString(key: "Sign In")
        txtEmail.placeholder = localizedString(key: "Email*")
        txtPassword.placeholder = localizedString(key: "Password*")
        btnLogin.setTitle(localizedString(key: "Login"), for: .normal)
        labelOrSignInWithStatic.text = localizedString(key: "or sign in with")
        btnDontHaveAnAccount.setTitle(localizedString(key: "Don't have an account?"), for: .normal)
        btnForgotPassword.setTitle(localizedString(key: "Forgot password"), for: .normal)
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtEmail.text?.isEmpty)! {
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
        return true
    }
    func resendEmail() {
        labelResendEmail.text = localizedString(key: "Haven't received activation email yet? Click Here to receive again.")
        let text = (labelResendEmail.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Click Here")
        underlineAttriString.addAttribute(NSAttributedStringKey.link, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
        // underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range1)
        //let range2 = (text as NSString).rangeOfString("Privacy Policy")
       // underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range1)
       // underlineAttriString.addAttribute(NSAttributedStringKey.underlineColor, value: Color.Custom.mainColor, range: range1)
        labelResendEmail.attributedText = underlineAttriString
        labelResendEmail.isUserInteractionEnabled = true
        labelResendEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = labelResendEmail.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: NSLocalizedString("Click Here", comment: "Click Here")),recognizer.didTapAttributedTextInLabel(label: labelResendEmail, inRange: NSRange(range, in: text)) {
            viewForgotPass.isHidden = false
            viewBackGround.isHidden = false
            labelTitleForgotPass.text = "Resend activation email"
            isForgotPass = "0"
        }
        //        else if let range = text.range(of: NSLocalizedString("_onboarding_privacy", comment: "privacy")),
        //            recognizer.didTapAttributedTextInLabel(label: lblAgreeToTerms, inRange: NSRange(range, in: text)) {
        //            goToPrivacyPolicy()
        //        }
    }
    
    // MARK: - Button Action
    
    @IBAction func onClickLinkdin(_ sender: Any) {
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
    
    @IBAction func onClickGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if checkValidation() {
            callApiLogin()
        }
    }
    @IBAction func btnForgottPasswordAction(_ sender: UIButton) {
        viewForgotPass.isHidden = false
        viewBackGround.isHidden = false
        labelTitleForgotPass.text = "Forgot password"
        isForgotPass = "1"
    }
    @IBAction func btnDontHaveAccountAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ChooseSignUpTypeVC.storyboardInstance!, animated: true)
    }
    @IBAction func btnSubmitForgotPassAction(_ sender: UIButton) {
        if (txtEmailForgot.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return
        }
        if isForgotPass == "1" {
            callApiForgotPass()
        }else {
            callApiResendActicvationEmail()
        }
        
    }
    @IBAction func btnNextAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "NEXT" {
            currentGuideIndex = currentGuideIndex + 1
            pager.scrollToSpecificIndex(currentGuideIndex)
        }else {
            viewContainer.isHidden = true
        }
    }
    @IBAction func btnSkipAction(_ sender: UIButton) {
        viewContainer.isHidden = true
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
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension ViewController: HSCycleGalleryViewDelegate {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        return arrGuide.count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "UserGuideCell", for: IndexPath(item: index, section: 0)) as! UserGuideCell
        cell.labelName.text = arrGuide[index]
        cell.imgvwGuide.image = UIImage(named: arrPic[index])
        return cell
    }
    func cycleGalleryViewscrollViewDidEndDecelerating(_ index: Int) {
        self.pageControl?.currentPage = index
        currentGuideIndex = index
        print(index)
        if index == 3 {
            btnNext.setTitle("GOT IT", for: .normal)
            btnSkip.isHidden = true
        }else {
            btnNext.setTitle("NEXT", for: .normal)
            btnSkip.isHidden = false
        }
    }
    
    func cycleGalleryViewscrollViewDidEndScrollingAnimation(_ index: Int) {
        self.pageControl?.currentPage = index
        currentGuideIndex = index
    }
    func cycleGalleryViewscrollViewDidScroll(_ index: Int) {
        self.pageControl?.currentPage = index
        currentGuideIndex = index
        if index == 3 {
            btnNext.setTitle("GOT IT", for: .normal)
            btnSkip.isHidden = true
        }else {
            btnNext.setTitle("NEXT", for: .normal)
            btnSkip.isHidden = false
        }
    }
    
}
//MARK:- FB login methods
extension ViewController {
    
    
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
extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
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
extension ViewController {
    
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
