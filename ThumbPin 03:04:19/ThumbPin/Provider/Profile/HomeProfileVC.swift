//
//  HomeProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 03/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeProfileVC: BaseViewController {
    
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
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
    @IBOutlet weak var lblMessages: UILabel!
    @IBOutlet weak var lblMessagesHead: UILabel!
    @IBOutlet weak var labelLanguages: UILabel!
    @IBOutlet weak var labelPhoneno: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelLocaton: UILabel!
    @IBOutlet weak var lavelReview: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    static var storyboardInstance:HomeProfileVC? {
        return StoryBoard.profileProvider.instantiateViewController(withIdentifier: HomeProfileVC.identifier) as? HomeProfileVC
    }
    var userProfile = UserProfile()
    var userProfileOff = UserProfileOffline()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDisplayUI()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            print("Yes! internet is available.")
            callApiGetProfile()
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            self.userProfileOff = UserProfileOffline(dic: dict["user_data"] as? [String : Any] ?? [String : Any]())
            self.showDataProfileOffline()
        }
    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//        print("Remove observer")
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetProfile() {
        let dictParam = [
            "action": Action.getProfile,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.userProfile = UserProfile(dic: dict)
            self.showDataProfile()
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
        print(userProfile.notification_count)
        UserDefaults.standard.set(userProfile.notification_count, forKey: serviceNotificationsKey)
        UserDefaults.standard.set(userProfile.message_count, forKey: quotePlacedKey)
        NotificationCenter.default.post(name: .sideMenuBadgegNotifi, object: nil)
        setUpLang()
        if userProfile.abn_num_verified == "y"{
            imgVerified.isHidden = false
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
        UserDefaults.standard.set(userProfileOff.notification_count, forKey: serviceNotificationsKey)
        UserDefaults.standard.set(userProfileOff.message_count, forKey: quotePlacedKey)
        setUpLang()
        if userProfile.abn_num_verified == "y"{
            imgVerified.isHidden = false
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
        //lblMessagesHead.text = localizedString(key: "Messages")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnMenuAction(_ sender: UIButton) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
}
extension HomeProfileVC:GADBannerViewDelegate{
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
}

