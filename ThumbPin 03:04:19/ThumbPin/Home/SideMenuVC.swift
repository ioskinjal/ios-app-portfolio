//
//  SideMenuVC.swift
//  ThumbPin
//
//  Created by NCT109 on 19/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class SideMenuVC: BaseViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    @IBOutlet weak var tblvwMenu: UITableView!{
        didSet{
            tblvwMenu.delegate = self
            tblvwMenu.dataSource = self
            tblvwMenu.separatorStyle = .none
            tblvwMenu.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
            tblvwMenu.rowHeight  = UITableViewAutomaticDimension
            tblvwMenu.estimatedRowHeight = 44
        }
    }
    
    static var storyboardInstance:SideMenuVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SideMenuVC.identifier) as? SideMenuVC
    }
    var arrMenu = [localizedString(key: "Home"),localizedString(key: "My Profile"),localizedString(key: "Messages"),localizedString(key: "My Request"),localizedString(key: "Explore Category"),localizedString(key: "Notifications"),localizedString(key: "Account Setting"),localizedString(key: "Info"),localizedString(key: "Contact Us"),localizedString(key: "Logout")]
    var arrMenuProvider = [localizedString(key: "Home"),localizedString(key: "My Profile"),localizedString(key: "Messages"),localizedString(key: "Service Notifications"),localizedString(key: "Quotes Placed"),localizedString(key: "Membership Plan"),localizedString(key: "Notifications"),localizedString(key: "Account Setting"),localizedString(key: "Info"),localizedString(key: "Contact Us"),localizedString(key: "Logout")]
    var arrImageCust = ["Home","Profile","Contact","ic_my_request","ic_explore_categor","MobileNOtification","AccountSetting","Info","Contact","Logout"]
    var arrImageProvider = ["Home","Profile","Contact","Notification","Order","MembershipPlan","MobileNOtification","AccountSetting","Info","Contact","Logout"]
    
    
    var arrSet = [String]()
    var arrImages = [String]()
    var serviceNotifi = 0
    var quote = 0
    var dispText = ""
    var userProfile = UserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        labelName.text = UserData.shared.getUser()?.user_name
//        if let strUrl = UserData.shared.getUser()?.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
//            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
//            imgvwProfile.sd_setShowActivityIndicatorView(true)
//            imgvwProfile.sd_setIndicatorStyle(.gray)
//        }
       
        if UserData.shared.getUser()?.user_type == "1" {
            arrSet = arrMenu
            arrImages = arrImageCust
        }else {
            arrSet = arrMenuProvider
            arrImages = arrImageProvider
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangNotification(notification:)), name: .changeLangNotifi, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuBadgeNotification(notification:)), name: .sideMenuBadgegNotifi, object: nil)
       
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
            self.imgvwProfile.downLoadImage(url: self.userProfile.profileData.user_image)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        serviceNotifi = UserDefaults.standard.value(forKey: serviceNotificationsKey) as? Int ?? 0
       // serviceNotifi = Int(service) ?? 0
        quote = UserDefaults.standard.value(forKey: quotePlacedKey) as? Int ?? 0
        dispText = UserDefaults.standard.value(forKey: dispTextKey) as? String ?? ""
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.callApiGetProfile()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // NotificationCenter.default.removeObserver(self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func callApiLogOut() {
        let dictParam = [
            "action": Action.logout,
            "lId": UserData.shared.getLanguage,
            "device_id": UserData.shared.deviceToken,
            "user_id": UserData.shared.getUser()!.user_id
        ] as [String : Any]
        ApiCaller.shared.login(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            UserData.shared.logoutUser()
            isSocialLogin = false
            UserData.shared.setGuideValue(language: "1")
            self.sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func shoWMessage() {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: localizedString(key: "Are you sure you want to logout?"), preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: localizedString(key: "NO"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "YES"), style: .default, handler: { _ in
            self.callApiLogOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getNextVC(index: Int) -> UIViewController? {
        
        if UserData.shared.getUser()?.user_type == "1" {
            
            switch index {
            case 0:
                return HomeCustomerVC.storyboardInstance!
            case 1:
                return ProfileVC.storyboardInstance!
            case 2:
                return MessagesListVC.storyboardInstance!
            case 3:
                return MyRequestVC.storyboardInstance!
            case 4:
                return ExploreCategoryVC.storyboardInstance!
            case 5:
                return NotificationVC.storyboardInstance!
            case 6:
                return AccountSettingsVC.storyboardInstance!
            case 7:
                return InfoVC.storyboardInstance!
            case 8:
                return ContactUsVC.storyboardInstance!
            default:
                return nil
            }
            
        }
        else{
            switch index {
            case 0:
                return HomeProfileVC.storyboardInstance!
            case 1:
                isFromProvider = false
                return MyProfileVC.storyboardInstance!
            case 2:
                return MessagesListVC.storyboardInstance!
            case 3:
                return ServiceNotificationsVC.storyboardInstance!
            case 4:
                return QuotePlacedVC.storyboardInstance!
            case 5:
                return MembershipPlanInfoVC.storyboardInstance!
            case 6:
                return NotificationVC.storyboardInstance!
            case 7:
                return AccountSettingsVC.storyboardInstance!
            case 8:
                return InfoVC.storyboardInstance!
            case 9:
                return ContactUsVC.storyboardInstance!
            default:
                return nil
            }
        }
        
    }
    @objc func changeLangNotification(notification: Notification) {
        if UserData.shared.getUser()?.user_type == "1" {
            arrSet = [localizedString(key: "Home"),localizedString(key: "My Profile"),localizedString(key: "Messages"),localizedString(key: "My Request"),localizedString(key: "Explore Category"),localizedString(key: "Notifications"),localizedString(key: "Account Setting"),localizedString(key: "Info"),localizedString(key: "Contact Us"),localizedString(key: "Logout")]
            arrImages = ["Home","Profile","ic_my_request","ic_explore_categor","MobileNOtification","AccountSetting","Info","Contact","Logout"]
        }else {
            arrSet = [localizedString(key: "Home"),localizedString(key: "My Profile"),localizedString(key: "Messages"),localizedString(key: "Service Notifications"),localizedString(key: "Quotes Placed"),localizedString(key: "Membership Plan"),localizedString(key: "Notifications"),localizedString(key: "Account Setting"),localizedString(key: "Info"),localizedString(key: "Contact Us"),localizedString(key: "Logout")]
            arrImages = arrImageProvider
        }
        tblvwMenu.reloadData()
    }
    @objc func sideMenuBadgeNotification(notification: Notification) {
        serviceNotifi = UserDefaults.standard.value(forKey: serviceNotificationsKey) as? Int ?? 0
        //serviceNotifi = Int(service) ?? 0
        print(serviceNotifi)
        quote = UserDefaults.standard.value(forKey: quotePlacedKey) as? Int ?? 0
        dispText = UserDefaults.standard.value(forKey: dispTextKey) as? String ?? ""
        tblvwMenu.reloadData()
    }

    // MARK: - Button Action
    @IBAction func btnProfileAction(_ sender: UIButton) {
        sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
        self.navigationController?.pushViewController(ProfileVC.storyboardInstance!, animated: true)
    }
}
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier) as? SideMenuCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrSet[indexPath.row]
        cell.imgvwMenu.image = UIImage(named: arrImages[indexPath.row])
        if UserData.shared.getUser()?.user_type == "2" {
            if indexPath.row == 3 {
                if serviceNotifi > 0 {
                    let service = "(\(serviceNotifi))"
                    cell.labelName.text = "Service Notifications \(service)"
                    let text = (cell.labelName.text)!
                    let underlineAttriString = NSMutableAttributedString(string: text)
                    let range1 = (text as NSString).range(of: "\(service)")
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
                    // underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range1)
                    //let range2 = (text as NSString).rangeOfString("Privacy Policy")
                    //underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range1)
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: Color.Custom.mainColor, range: range1)
                    cell.labelName.attributedText = underlineAttriString
                }
            }
            else if indexPath.row == 4 {
                if quote > 0 {
                    cell.labelName.text = "Quotes Placed (\(quote))"
                    
                    let text = (cell.labelName.text)!
                    let underlineAttriString = NSMutableAttributedString(string: text)
                    let range1 = (text as NSString).range(of: "(\(quote))")
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
                    // underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range1)
                    //let range2 = (text as NSString).rangeOfString("Privacy Policy")
                    //underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range1)
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: Color.Custom.mainColor, range: range1)
                    cell.labelName.attributedText = underlineAttriString
                }
            }
        }
        else if UserData.shared.getUser()?.user_type == "1" {
            if indexPath.row == 2 {
                if !dispText.isEmpty {
                    cell.labelName.text = "My Request (\(dispText))"
                    
                    let text = (cell.labelName.text)!
                    let underlineAttriString = NSMutableAttributedString(string: text)
                    let range1 = (text as NSString).range(of: "(\(dispText))")
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
                    // underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range1)
                    //let range2 = (text as NSString).rangeOfString("Privacy Policy")
                    //underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range1)
                    underlineAttriString.addAttribute(NSAttributedStringKey.foregroundColor, value: Color.Custom.mainColor, range: range1)
                    cell.labelName.attributedText = underlineAttriString
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSet.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
        }else {
            if UserData.shared.getUser()?.user_type == "1" {
                if indexPath.row == 9 {
                    shoWMessage()
                }else {
                    sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                    self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
                }
            }else {
                if indexPath.row == 10 {
                    shoWMessage()
                }else {
                    sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                    self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
                }
            }
            
        }
        
    }
}
