//
//  ProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 20/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var btnFlagUser: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhoneNo: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    
    static var storyboardInstance:ProfileVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: ProfileVC.identifier) as? ProfileVC
    }
    var userProfile = UserProfile()
    var userProfileOff = UserProfile.ProfileData()
    var flagStatus = FlagStatus()
    var userIdFromProvider = ""
    var userType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userIdFromProvider.isEmpty {
            userIdFromProvider = UserData.shared.getUser()!.user_id
            userType = UserData.shared.getUser()!.user_type
            btnFlagUser.isHidden = true
            btnEdit.isHidden = false
        }else {
           // userIdFromProvider = userIdFromCustomer
            userType = "1"
            btnFlagUser.isHidden = false
            btnEdit.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            callApiGetProfile()
            if UserData.shared.getUser()!.user_type == "2" {
                callApiGetFlagStatus(userIdFromProvider)
            }
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            self.userProfileOff = UserProfile.ProfileData(dic: dict["user_data"] as? [String : Any] ?? [String : Any]())
            self.showDataProfileOffline()
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetProfile() {
        let dictParam = [
            "action": Action.getProfile,
            "lId": UserData.shared.getLanguage,
            "user_type": userType,
            "user_id": userIdFromProvider,
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
        labelLocation.text = userProfile.profileData.user_location
        labelEmail.text = userProfile.profileData.user_email
        labelPhoneNo.text = userProfile.profileData.user_contact
        labelLanguage.text = userProfile.profileData.languages
        if let strUrl = userProfile.profileData.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
            UserData.shared.setProfileImage(imageUrl: userProfile.profileData.user_image )
        }
        if userProfile.profileData.abn_num_verified == "y"{
            self.imgVerified.isHidden = false
        }
        
    }
    func showDataProfileOffline() {
        print(userProfileOff.user_name)
        labelName.text = userProfileOff.user_name
        labelLocation.text = userProfileOff.user_location
        labelEmail.text = userProfileOff.user_email
        labelPhoneNo.text = userProfileOff.user_contact
        labelLanguage.text = userProfileOff.languages
        if let strUrl = userProfileOff.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
            UserData.shared.setProfileImage(imageUrl: userProfile.profileData.user_image )
        }
        if userProfile.profileData.abn_num_verified == "y"{
            self.imgVerified.isHidden = false
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "My Profile")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(EditProfileVC.storyboardInstance!, animated: true)
    }
    @IBAction func btnFlagUserAction(_ sender: UIButton) {
        callApiFlagService(userIdFromProvider)
    }
}
