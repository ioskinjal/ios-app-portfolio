//
//  HomeVC.swift
//  XPhorm
//
//  Created by admin on 5/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
//import GoogleSignIn
//import LinkedinSwift

var isfromProfile = false

class DashboardVC: BaseViewController {

    static var storyboardInstance:DashboardVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: DashboardVC.identifier) as? DashboardVC
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var constServiceCollectionView: NSLayoutConstraint!
    @IBOutlet weak var stackViewGivenReviews: UIStackView!
    @IBOutlet weak var stackViewMoreReceived: UIStackView!
    
    @IBOutlet weak var imgInstaVerify: UIImageView!
    @IBOutlet weak var lblContact: UILabel!
    
    @IBOutlet weak var viewImg: UIView!{
        didSet{
            viewImg.setRadius(31.0)
        }
    }
    @IBOutlet weak var lblResponseRate: UILabel!
    @IBOutlet weak var lblResponseTime: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblEmergency: UILabel!
    @IBOutlet weak var lblResponseRateHead: UILabel!
    @IBOutlet weak var lblResponsehead: UILabel!
    @IBOutlet weak var lblGenderHead: UILabel!
    @IBOutlet weak var lblEmrgencyHead: UILabel!
    @IBOutlet weak var lblContactHead: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblDobHead: UILabel!
    @IBOutlet weak var bntViewMoreGivenReviews: UIButton!
    @IBOutlet weak var lblTotalReqyestHead: UILabel!
    @IBOutlet weak var btnViewMoreReceivedReviews: UIButton!
    @IBOutlet weak var lblGivenReviewsHead: UILabel!
    
    @IBOutlet weak var givenReviewCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCertificatesHead: UILabel!
    
    @IBOutlet weak var lblReceivedReviewsHead: UILabel!
    
    
    @IBOutlet weak var lblTotalTimeHead: UILabel!
    @IBOutlet weak var ReviewXollectionHeight: NSLayoutConstraint!
  
    @IBOutlet weak var certificateCollectionView: UICollectionView!{
        didSet{
            certificateCollectionView.delegate = self
            certificateCollectionView.dataSource = self
            certificateCollectionView.register(SubCategoryCell.nib, forCellWithReuseIdentifier: SubCategoryCell.identifier)
        }
    }
    
    @IBOutlet weak var lblReqCount: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var viewTotalTime: UIView!{
        didSet{
            viewTotalTime.setGradientBackground(colorTop: UIColor.init(red: 220/255.0, green: 253/255.0, blue: 237/255.0, alpha: 1.0), colorBottom: UIColor.init(red: 149/255.0, green: 226/255.0, blue: 190/255.0, alpha: 1.0))
            viewTotalTime.setRadius(10.0)
        }
    }
    @IBOutlet weak var viewTotalReq: UIView!{
        didSet{
            viewTotalReq.setGradientBackground(colorTop: UIColor.init(red: 254/255.0, green: 212/255.0, blue: 198/255.0, alpha: 1.0), colorBottom: UIColor.init(red: 242/255.0, green: 175/255.0, blue: 192/255.0, alpha: 1.0))
            viewTotalReq.setRadius(10.0)
        }
    }
    @IBOutlet weak var stackviewServices: UIStackView!
    @IBOutlet weak var collectionViewServices: UICollectionView!{
        didSet{
            collectionViewServices.delegate = self
            collectionViewServices.dataSource = self
            collectionViewServices.register(MyServiceCC.nib, forCellWithReuseIdentifier: MyServiceCC.identifier)
        }
    }
    @IBOutlet weak var btnLinkdin: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var collectionViewGivenReviews: UICollectionView!{
        didSet{
            collectionViewGivenReviews.delegate = self
            collectionViewGivenReviews.dataSource = self
            collectionViewGivenReviews.register(BeforeHomeScreenCell.nib, forCellWithReuseIdentifier: BeforeHomeScreenCell.identifier)
        }
    }
    @IBOutlet weak var imgLinkdinVerify: UIImageView!
    
    @IBOutlet weak var imgGoogleVerfy: UIImageView!
    @IBOutlet weak var imgFbVerify: UIImageView!
    
    @IBOutlet weak var collectionViewCertiHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var stackViewAbout: UIStackView!
    
    
    @IBOutlet weak var stackViewCertificate: UIStackView!
    @IBOutlet weak var collectionViewRecivedReviews: UICollectionView!{
        didSet{
            collectionViewRecivedReviews.delegate = self
            collectionViewRecivedReviews.dataSource = self
            collectionViewRecivedReviews.register(BeforeHomeScreenCell.nib, forCellWithReuseIdentifier: BeforeHomeScreenCell.identifier)
        }
    }
    
    
//    let linkedinHelper = LinkedinSwiftHelper(configuration:
//        LinkedinSwiftConfiguration(clientId: "81lm3etdbnq6sw", clientSecret: "1n2KMHTsDvYCgIU7", state: "DLKDJF45DIWOERCM", permissions: ["r_emailaddress", "r_liteprofile"], redirectUrl: "https://xphorm.ncryptedprojects.com/auth/linkedin/callback")
//    )
    
    var serviceList = [MyServiceCls.ServiceList]()
    var serviceObj: MyServiceCls?
    var certficateList = [Profile.Certificates]()
    var givenReviews = [Profile.GivenReviews]()
    var receivedReviews = [Profile.ReceivedReviews]()
    var navTitle = ""
    var user_id = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: navTitle, action: #selector(onClickMenuMain(_:)))
     
        configureFacebook()
//        configureGoogle()
        
      // self.givenReviewCollectionHeight.constant = self.collectionViewGivenReviews.contentSize.height
        // self.ReviewXollectionHeight.constant = self.collectionViewRecivedReviews.contentSize.height
       
        if isfromProfile{
            btnEdit.isHidden = true
            stackViewAbout.isHidden = false
            stackViewCertificate.isHidden = true
            stackviewServices.isHidden = false
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         setLanguage()
        getPrfile()
    }
    
    
    func getMyService(){
        let nextPage = (serviceObj?.pagination?.page ?? 0 ) + 1
        
        var param = ["action":"getMyService",
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage,
                     "keyword":""] as [String : Any]
        if user_id != ""{
            param["userId"] = user_id
        }else{
            param["userId"] = UserData.shared.getUser()!.id
        }
        Modal.shared.getMyService(vc: nil, param: param) { (dic) in
            self.serviceObj = MyServiceCls(dictionary: dic)
            if self.serviceList.count > 0{
                self.serviceList += self.serviceObj!.serviceList
            }
            else{
                self.serviceList = self.serviceObj!.serviceList
            }
           
            if self.serviceList.count == 0{
                self.constServiceCollectionView.constant = 1
            }
            self.collectionViewServices.reloadData()
        }
        
    }
    
    
    func  setLanguage(){
        lblTotalReqyestHead.text = "Total Requests".localized
        lblTotalTimeHead.text = "Total Time".localized
        lblCertificatesHead.text = "Certificates".localized
        lblReceivedReviewsHead.text = "Received Reviews".localized
        btnViewMoreReceivedReviews.setTitle("VIEW MORE".localized, for: .normal)
        lblGivenReviewsHead.text = "Given Reviews".localized
        bntViewMoreGivenReviews.setTitle("VIEW MORE".localized, for: .normal)
        lblDobHead.text = "DATE OF BIRTH".localized
        lblContactHead.text = "CONTACT NO".localized
        lblEmrgencyHead.text = "EMREGENCY NO".localized
        lblGenderHead.text = "GENDER".localized
        lblResponsehead.text = "RESPONSE TIME".localized
        lblResponseRateHead.text = "RESPONSE RATE".localized
        
    }
    
    func getPrfile(){
        var param = ["action":"getProfileData",
                     "lId":UserData.shared.getLanguage]
        if user_id != ""{
            param["userId"] = user_id
        }else{
            param["userId"] = UserData.shared.getUser()!.id
        }
        Modal.shared.profile(vc: self, param: param) { (dic) in
            let data:Profile?
               data = Profile(dic: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.showProfileData(data: data!)
            let data1 = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            if self.user_id == ""{
            _ = UserData.shared.setUser(dic: data1)
            }
            self.getMyService()
        }
    }
    
    
    func showProfileData(data:Profile){
        
        imgProfile.downLoadImage(url: data.profileImg)
        
        lblUserName.text = data.firstName + " " +  data.lastName
        lblLocation.text = data.address
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let date = dateformat.date(from: data.birthDate)
        dateformat.dateFormat = "MM/dd/yyyy"
        lblDob.text = dateformat.string(from: date ?? Date())
        lblContact.text = data.contactNumber
        lblEmergency.text = data.emergencyContactNumber
        if data.gender == "m"{
             lblGender.text = "Male".localized
        }else if data.gender == "f"{
            lblGender.text = "Female".localized
        }
        lblResponseTime.text = String(data.responseTime) + " Hours".localized
        lblResponseRate.text = String(data.responseRate) + " %"
        certficateList = data.certificates
        certificateCollectionView.reloadData()
        if certficateList.count == 0{
            collectionViewCertiHeightConst.constant = 1
        }
        
        if data.facebook_verify == "y"{
            imgFbVerify.isHidden = false
        }
//        if data.google_verify == "y"{
//            imgGoogleVerfy.isHidden = false
//        }
//        if data.linkedin_verify == "y"{
//            imgLinkdinVerify.isHidden = false
//        }
        if data.insta_verify == "y"{
            imgInstaVerify.isHidden = false
        }
        
        givenReviews = data.givenReviews
        if givenReviews.count == 0{
            
        }
        if givenReviews.count != 0{
            stackViewGivenReviews.isHidden = false
        }else{
             stackViewGivenReviews.isHidden = true
            givenReviewCollectionHeight.constant = 0
        }
        collectionViewGivenReviews.reloadData()
        
        receivedReviews = data.receivedReviews
        if receivedReviews.count == 0{
        }
        if receivedReviews.count != 0{
            stackViewMoreReceived.isHidden = false
        }else{
            stackViewMoreReceived.isHidden = true
            ReviewXollectionHeight.constant = 0
            
        }
        collectionViewRecivedReviews.reloadData()
    lblAbout.text = data.desc
        
    }
    //MARK:- UIButton Action
    
    @objc func onClickMenuMain(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickInstagram(_ sender: UIButton) {
        self.navigationController?.pushViewController(InstaViewController.storyboardInstance!, animated: true)
    }
    @IBAction func onclickEdit(_ sender: UIButton) {
        self.navigationController?.pushViewController(EditProfileVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickViewMoreGivenReviews(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReviewsVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickViewMoreReceivedReviews(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReviewsVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickFB(_ sender: UIButton) {
    }
//    @IBAction func onClickGoogle(_ sender: UIButton) {
//        GIDSignIn.sharedInstance().signIn()
//    }
//    @IBAction func onClickLinkdin(_ sender: UIButton) {
//        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
//        if let cookies = cookieStorage.cookies {
//            for cookie in cookies {
//                cookieStorage.deleteCookie(cookie)
//            }
//        }
//        loginWithLinkedInSwift()
//    }
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["provider": loginType,
                        "email": email,
                        "action":"socialVerify",
                        "lId":UserData.shared.getLanguage,
                        "userId":UserData.shared.getUser()!.id
        ]
        
        Modal.shared.signUp(vc: self, param: dicParam) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.getPrfile()
            })
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

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewGivenReviews{
            return givenReviews.count
        }else if collectionView == collectionViewRecivedReviews{
        return receivedReviews.count
        }else if collectionView == certificateCollectionView{
            return certficateList.count
        }else{
            return serviceList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewGivenReviews{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeforeHomeScreenCell.identifier, for: indexPath) as? BeforeHomeScreenCell else {
            fatalError("Cell can't be dequeue")
            
        }
         cell.mainView.layer.borderColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0).cgColor
            let data:Profile.GivenReviews = givenReviews[indexPath.row]
            cell.imgProfile.downLoadImage(url: data.profileImg)
            cell.lbluserName.text = data.userName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data.createdDate)
            dateformat.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateformat.string(from: date ?? Date())
            cell.lblDesc.text = data.description
            cell.viewrate.rating = (data.ratting as NSString).doubleValue
        return cell
        }else if collectionView == collectionViewRecivedReviews{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeforeHomeScreenCell.identifier, for: indexPath) as? BeforeHomeScreenCell else {
                fatalError("Cell can't be dequeue")
            }
             cell.mainView.layer.borderColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0).cgColor
            let data:Profile.ReceivedReviews = receivedReviews[indexPath.row]
            cell.imgProfile.downLoadImage(url: data.profileImg)
            cell.lbluserName.text = data.userName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data.createdDate)
            dateformat.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateformat.string(from: date ?? Date())
            cell.lblDesc.text = data.description
            cell.viewrate.rating = (data.ratting as NSString).doubleValue
            return cell
        }else if collectionView == certificateCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as? SubCategoryCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.btnDelete.isHidden = true
            cell.imgView.downLoadImage(url: certficateList[indexPath.row].certificatePath)
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyServiceCC.identifier, for: indexPath) as? MyServiceCC else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewMain.layer.borderColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0).cgColor
            let data:MyServiceCls.ServiceList?
            data = serviceList[indexPath.row]
            cell.lblServiceType.text = data?.categoryName
            cell.lblTotalReviews.text = data?.totalReview
            cell.lblPrice.text = currency + data!.price
            cell.imgService.downLoadImage(url: data!.serviceImagePath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewServices{
            let nextVC = ServiceDetailVC.storyboardInstance!
            nextVC.service_id = serviceList[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
  /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if collectionView == collectionViewGivenReviews{
        return CGSize(width: collectionView.frame.size.width/2, height:140)
        }
//        else if collectionView == collectionViewRecivedReviews{
////            return CGSize(width: collectionView.frame.size.width/2, height:140)
//        }
        else if collectionView == certificateCollectionView{
           return CGSize(width: 120, height:120)
        }else if collectionView == collectionViewServices{
            return CGSize(width: collectionView.frame.size.width/2, height:186)
        }
        return CGSize()
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionViewGivenReviews{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        }else if collectionView == collectionViewRecivedReviews{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        }else{
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if collectionView == collectionViewServices{
          reloadMoreData(indexPath: indexPath)
        
        }
        
    }
    func reloadMoreData(indexPath: IndexPath) {
        if serviceList.count - 1 == indexPath.row &&
            (serviceObj!.pagination!.page < serviceObj!.pagination!.numPages) {
            self.getMyService()
        }
    }
}
//MARK:- FB login methods
extension DashboardVC {
    
    
    func configureFacebook(){
        
        btnFB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        LoginManager().logOut()
        
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
}

//MARK:- GoogleSignIn
//extension DashboardVC: GIDSignInDelegate, GIDSignInUIDelegate {
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
//extension DashboardVC {
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
