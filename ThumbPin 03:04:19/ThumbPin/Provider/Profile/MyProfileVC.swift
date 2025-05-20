//
//  MyProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 03/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

protocol ContainerViewHeight {
    func setContainerViewHeight(heigth:CGFloat)
}
var arrPortFolio = [UserProfile.ProfileData.PortFolio]()

import UIKit
import GoogleMobileAds

class MyProfileVC: BaseViewController {
    
 
    @IBOutlet weak var lblMessagesHead: UILabel!
    @IBOutlet weak var lblMessages: UILabel!
    @IBOutlet weak var imgVerfied: UIImageView!
    @IBOutlet weak var btnFlagUser: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var btnPortFolio: UIButton!
    @IBOutlet weak var btnBusinessProfile: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCompletedQuotesValue: UILabel!
    @IBOutlet weak var labelCompletedQuotes: UILabel!
    @IBOutlet weak var labelTotalQuotes: UILabel!
    @IBOutlet weak var labelTotalQuotesValue: UILabel!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var labelLanguages: UILabel!
    @IBOutlet weak var labelPhoneno: UILabel!
    @IBOutlet weak var stackViewContact: UIStackView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelLocaton: UILabel!
    @IBOutlet weak var lavelReview: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewLineBottom: UIView!
    @IBOutlet weak var conContainerViewHeight: NSLayoutConstraint!
    
    static var storyboardInstance:MyProfileVC? {
        return StoryBoard.profileProvider.instantiateViewController(withIdentifier: MyProfileVC.identifier) as? MyProfileVC
    }
    var userProfile = UserProfile()
    var userProfileOff = UserProfileOffline()
    var selectedMenu = 0
    var userIdFromCustomer = ""
    var userType = ""
    var flagStatus = FlagStatus()
    var Profile_id:String = ""
    
    @objc func menuChange(notification: Notification) {
        let data = notification.object as! [String: Any]
        guard let index = data["Pagevc_index"] as? Int else { return }
        
        print("Raised notification")
        
        switch index {
        case 0:
            btnBusinessProfileAction(btnBusinessProfile)
        case 1:
            btnPortFolioAction(btnPortFolio)
        case 2:
            btnReviewsAction(btnReviews)
        default:
            break
        }
    }
    @objc func setContainerHeight(notification: Notification) {
        let data = notification.object as! [String: Any]
        guard let height = data["containerHeight"] as? CGFloat else { return }
        conContainerViewHeight.constant = height
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDisplayUI()
        NotificationCenter.default.addObserver(self, selector: #selector(setContainerHeight(notification:)), name: .setContainerHeight, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(menuChange(notification:)), name: .profileMenuChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if userIdFromCustomer.isEmpty {
            userIdFromCustomer = UserData.shared.getUser()!.user_id
            userType = UserData.shared.getUser()!.user_type
           // userIdCustomerBusiness = userIdFromCustomer
            btnFlagUser.isHidden = true
            btnEditProfile.isHidden = false
        }else {
            userIdCustomerBusiness = userIdFromCustomer
            btnFlagUser.isHidden = false
            btnEditProfile.isHidden = true
            userType = "2"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(true)
        if isFromProvider{
            stackViewEmail.isHidden = true
            stackViewContact.isHidden = true
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            print("Yes! internet is available.")
            if appDelegate?.isCallGetProfileApi == "0" {
                callApiGetProfile()
                if UserData.shared.getUser()!.user_type == "1" {
                    callApiGetFlagStatus(userIdFromCustomer)
                }
            }else {
                appDelegate?.isCallGetProfileApi = "0"
            }
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            self.userProfileOff = UserProfileOffline(dic: dict["user_data"] as? [String : Any] ?? [String : Any]())
            self.showDataProfileOffline()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // NotificationCenter.default.removeObserver(self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Remove observer")
    }
    func callApiGetProfile() {
        let dictParam = [
            "action": Action.getProfile,
            "lId": UserData.shared.getLanguage,
            "user_type": userType,
            "user_id": userIdFromCustomer,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.userProfile = UserProfile(dic: dict)
            self.showDataProfile()
            arrPortFolio = self.userProfile.profileData.arrPortFolio
        }
    }
    func callApiFlagService(_ flagId: String) {
        let dictParam = [
            "action": Action.setStatus,
            "lId": UserData.shared.getLanguage,
            "flag_type": "user",
            "user_id": UserData.shared.getUser()!.user_id,
            "flag_id": flagId,
            ] as [String : Any]
        ApiCaller.shared.setFlagStatus(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            let isFlag = dict["isFlag"] as? String
            if isFlag == "y" {
                self.btnFlagUser.setImage(#imageLiteral(resourceName: "Orange_Flag"), for: .normal)
            }else {
                self.btnFlagUser.setImage(#imageLiteral(resourceName: "remove_flag"), for: .normal)
            }
        }
    }
    func callApiGetFlagStatus(_ flagId: String) {
        let dictParam = [
            "action": Action.getStatus,
            "lId": UserData.shared.getLanguage,
            "flag_type": "user",
            "user_id": UserData.shared.getUser()!.user_id,
            "flag_id": flagId,
            ] as [String : Any]
        ApiCaller.shared.setFlagStatus(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.flagStatus = FlagStatus(dic: dict)
            if self.flagStatus.flagStatus == "y" {
                self.btnFlagUser.setImage(#imageLiteral(resourceName: "Orange_Flag"), for: .normal)
            }else {
                self.btnFlagUser.setImage(#imageLiteral(resourceName: "remove_flag"), for: .normal)
            }
        }
    }
    func showDataProfile() {
        
        labelName.text = userProfile.profileData.user_name
        labelStar.text = userProfile.profileData.user_rating
        lavelReview.text = userProfile.profileData.uesr_no_review
        labelLocaton.text = userProfile.profileData.user_location
        labelEmail.text = userProfile.profileData.user_email
        labelPhoneno.text = userProfile.profileData.user_contact
        labelLanguages.text = userProfile.profileData.languages
        
        if let strUrl = userProfile.profileData.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
        }
        if userProfile.profileData.receive_msg == "y"{
            lblMessagesHead.text = localizedString(key: "Messages") + ": " + localizedString(key: "Yes")
        }else{
            lblMessagesHead.text = localizedString(key: "Messages") + ": " + localizedString(key: "No")
        }
        labelTotalQuotesValue.text = userProfile.profileData.user_total_quote
        labelCompletedQuotesValue.text = userProfile.profileData.user_total_quote_completed
        labelDescription.text = userProfile.profileData.user_desc
        setUpLang()
        if userProfile.abn_num_verified == "y"{
           // self.imgVerified.isHidden = false
        }
    }
    func showDataProfileOffline() {
        labelName.text = userProfileOff.user_name
        labelStar.text = userProfileOff.user_rating
        lavelReview.text = userProfileOff.uesr_no_review
        labelLocaton.text = userProfileOff.user_location
        labelEmail.text = userProfileOff.user_email
        labelPhoneno.text = userProfileOff.user_contact
        labelLanguages.text = userProfileOff.languages
        if let strUrl = userProfileOff.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
        }
        labelTotalQuotesValue.text = userProfileOff.user_total_quote
        labelCompletedQuotesValue.text = userProfileOff.user_total_quote_completed
        labelDescription.text = userProfileOff.user_desc
        setUpLang()
        if userProfile.abn_num_verified == "y"{
            self.imgVerfied.isHidden = false
        }
    }
    func setUpDisplayUI() {
        labelName.font = MuliFont.bold(with: FontSize.title.rawValue)
        labelName.textColor = Color.Custom.whiteColor
        labelStar.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelStar.textColor = Color.Custom.whiteColor
        lavelReview.font = MuliFont.regular(with: FontSize.small.rawValue)
        lavelReview.textColor = Color.Custom.whiteColor
        labelLocaton.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelLocaton.textColor = Color.Custom.whiteColor
        labelEmail.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelEmail.textColor = Color.Custom.whiteColor
        labelPhoneno.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelPhoneno.textColor = Color.Custom.whiteColor
        labelLocaton.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelLocaton.textColor = Color.Custom.whiteColor
        labelTotalQuotesValue.font = MuliFont.bold(with: FontSize.medium.rawValue)
        labelTotalQuotesValue.textColor = Color.Custom.blackColor
        labelCompletedQuotesValue.font = MuliFont.bold(with: FontSize.medium.rawValue)
        labelCompletedQuotesValue.textColor = Color.Custom.blackColor
        labelTotalQuotes.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelTotalQuotes.textColor = Color.Custom.darkGrayColor
        labelCompletedQuotes.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelCompletedQuotes.textColor = Color.Custom.darkGrayColor
        labelDescription.font = MuliFont.regular(with: FontSize.small.rawValue)
        labelDescription.textColor = Color.Custom.blackColor
    }
    func setUpLang() {
        labelTotalQuotes.text = localizedString(key: "Total Quotes")
        labelCompletedQuotes.text = localizedString(key: "Completed Quotes")
        labelTitleNav.text = localizedString(key: "My Profile")
        btnBusinessProfile.setTitle(localizedString(key: "Business profile"), for: .normal)
        btnPortFolio.setTitle(localizedString(key: "Portfolio"), for: .normal)
        btnReviews.setTitle(localizedString(key: "Reviews"), for: .normal)
     
    }
    
    func callAnimatioView(sender: UIButton) {
        if self.viewLineBottom.center.x == sender.center.x {
            return
        }
        // btnService.setImage(#imageLiteral(resourceName: "icon1_Green"), for: UIControlState())
        
        animationOnView(center: sender.center)
        selectedMenu = sender.tag
        NotificationCenter.default.post(name: .profileMenuChange, object: ["selectedMenu":selectedMenu] as [String:Any])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBusinessProfileAction(_ sender: UIButton) {
       // conContainerViewHeight.constant = 100
        sender.tag = 0
        callAnimatioView(sender: sender)
//        animationOnView(center: sender.center)
//        selectedMenu = 0
//        NotificationCenter.default.post(name: .profileMenuChange, object: ["selectedMenu":selectedMenu] as [String:Any])

        
    }
    @IBAction func btnPortFolioAction(_ sender: UIButton) {
        //conContainerViewHeight.constant = 200
        sender.tag = 1
        callAnimatioView(sender: sender)
//        animationOnView(center: sender.center)
//        selectedMenu = 1
//        NotificationCenter.default.post(name: .profileMenuChange, object: ["selectedMenu":selectedMenu] as [String:Any])

    }
    @IBAction func btnReviewsAction(_ sender: UIButton) {
      //  conContainerViewHeight.constant = 300
        sender.tag = 2
        callAnimatioView(sender: sender)
//        animationOnView(center: sender.center)
//        selectedMenu = 2
//        NotificationCenter.default.post(name: .profileMenuChange, object: ["selectedMenu":selectedMenu] as [String:Any])

    }
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(EditProviderProfileVC.storyboardInstance!, animated: true)
    }
    @IBAction func btnFlagUserAction(_ sender: UIButton) {
        callApiFlagService(userIdFromCustomer)
    }
    
    
    
}
extension MyProfileVC {
    func animationOnView(center point:CGPoint,vcWithIdentifier id:String = "") {
        
        /*  switch selectedMenu {
         case 0:
         btnService.setImage(#imageLiteral(resourceName: "icon1_Grey"), for: UIControlState())
         case 1:
         btnUser.setImage(#imageLiteral(resourceName: "icon2_Grey"), for: UIControlState())
         case 2:
         btnStar.setImage(#imageLiteral(resourceName: "icon3_Grey"), for: UIControlState())
         case 3:
         btnGallery.setImage(#imageLiteral(resourceName: "icon4_Grey"), for: UIControlState())
         default:
         break
         }  */
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.viewLineBottom.center.x = point.x
        }, completion: nil)
        
    }
}
extension MyProfileVC: ContainerViewHeight {
    
    func setContainerViewHeight(heigth:CGFloat) {
        conContainerViewHeight.constant = heigth
    }
    
    
}
extension MyProfileVC:GADBannerViewDelegate{
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
}
