//
//  AccountSettingsVC.swift
//  Happenings
//
//  Created by admin on 2/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class AccountSettingsVC: BaseViewController {
    
    static var storyboardInstance:AccountSettingsVC? {
        return StoryBoard.accountsettings.instantiateViewController(withIdentifier: AccountSettingsVC.identifier) as? AccountSettingsVC
    }
    @IBOutlet weak var headerCollectionView: UICollectionView!{
        didSet{
            headerCollectionView.delegate = self
            headerCollectionView.dataSource = self
            headerCollectionView.register(HeaderCell.nib, forCellWithReuseIdentifier: HeaderCell.identifier)
        }
    }
    
    @IBOutlet weak var viewConfirmPassword: UIView!{
        didSet{
            viewConfirmPassword.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewNewPassword: UIView!
        {
        didSet{
            viewNewPassword.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewOldPassword: UIView!{
        didSet{
            viewOldPassword.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewEmailNotification: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewChangeEmail: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    
    @IBOutlet weak var viewPushNotification: UIView!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtOldPAssword: UITextField!
    @IBOutlet weak var tblSettings: UITableView!{
        didSet{
            tblSettings.register(NotificationSettingCell.nib, forCellReuseIdentifier: NotificationSettingCell.identifier)
            tblSettings.dataSource = self
            tblSettings.delegate = self
            tblSettings.tableFooterView = UIView()
            tblSettings.separatorStyle = .none
        }
    }
    @IBOutlet weak var tblPushHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblPushSettings: UITableView!{
        didSet{
            tblPushSettings.register(NotificationSettingCell.nib, forCellReuseIdentifier: NotificationSettingCell.identifier)
            tblPushSettings.dataSource = self
            tblPushSettings.delegate = self
            tblPushSettings.tableFooterView = UIView()
            tblPushSettings.separatorStyle = .none
        }
    }
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    //
    //    var unselectedTextAttributes: [NSAttributedString.Key: Any] = [
    //        .font : TitilliumWebFont.regular(with: 17.0),
    //        .foregroundColor : UIColor.black
    //    ]
    //    var selectedTextAttributes: [NSAttributedString.Key: Any] = [
    //        .font : TitilliumWebFont.regular(with: 17.0),
    //        .foregroundColor : UIColor.black
    //
    //    ]
    
    var headerList = ["Change Password","Change Email","Push Notification","Email Setings"]
    var selectedIndex:Int = 0
    var strDealPost:String = ""
    var strDealPostCat:String = ""
    var strDealbuy:String = ""
    var strDealCart:String = ""
    var notification = [NotificationList]()
    var notificationPush = [NotificationList]()
    var paramNotification = [String:Any]()
    var arrayPref : NSMutableArray = []
     var dictPref = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "ACCOUNT SETTINGS", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        viewChangePassword.isHidden = false
        viewChangeEmail.isHidden = true
        viewEmailNotification.isHidden = true
        headerCollectionView.reloadData()
        // didValueChanged(viewSegment)
        callGetSettingsAPI()
        
    }
    
    func callGetSettingsAPI(){
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getNotificationSettings(vc: self, param:param) { (dic) in
            var list:NotificationSettings
            
            list = NotificationSettings(dictionary: dic)
            
                for i in 0..<list.notificationList.count {
                    if list.notificationList[i].push_or_mail == "p"{
                        self.notificationPush.append(list.notificationList[i])
                    }else{
                         self.notification.append(list.notificationList[i])
                    }
                }
                if self.notificationPush.count != 0 {
                    self.tblPushSettings.reloadData()
                    self.setAutoHeighttbl()
                    
                }
                if self.notification.count != 0 {
                    self.tblSettings.reloadData()
                    self.setAutoHeighttbl()
                    
            }
            
        }
    }

    func setAutoHeighttbl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.tblHeightConst.constant = self.tblSettings.contentSize.height
            self.tblSettings.layoutIfNeeded()
            self.tblPushHeightConst.constant = self.tblPushSettings.contentSize.height
            self.tblPushSettings.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickUpdatePush(_ sender: Any) {
        arrayPref.add(dictPref)
        let jsonStringPretty = JSONStringify(value: dictPref as AnyObject, prettyPrinted: true)
        print(jsonStringPretty)
        var strParam:NSString = jsonStringPretty as NSString
        
        strParam = strParam.replacingOccurrences(of: "\\", with: "") as NSString
        paramNotification["preferences"] = strParam
        Modal.shared.updateNotificationCustomer(vc: self, param: paramNotification) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.notification = [NotificationList]()
                self.notificationPush = [NotificationList]()
                self.callGetSettingsAPI()
            })
        }
    }
    
    
    @IBAction func onClickUpdateEmailNotification(_ sender: Any) {
        arrayPref  = []
        arrayPref.add(dictPref)
        let jsonStringPretty = JSONStringify(value: dictPref as AnyObject, prettyPrinted: true)
        print(jsonStringPretty)
        var strParam:NSString = jsonStringPretty as NSString
        
        strParam = strParam.replacingOccurrences(of: "\\", with: "") as NSString
        paramNotification["preferences"] = strParam
        Modal.shared.updateNotificationCustomer(vc: self, param: paramNotification) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.notification = [NotificationList]()
                self.notificationPush = [NotificationList]()
                self.callGetSettingsAPI()
            })
        }
        
    }
    
    @IBAction func onClickUpdateEmail(_ sender: UIButton) {
        if txtEmail.text == "" {
            self.alert(title: "", message: "please enter email")
            
        }else if !((txtEmail.text?.isValidEmailId)!) {
            self.alert(title: "", message: "please enter valid email")
        }
        else{
            let param = ["action":"change-email",
                         "email_address":txtEmail.text!,
                         "user_id":UserData.shared.getUser()!.user_id]
            
            Modal.shared.changeEmail(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        txtOldPAssword.text = ""
        txtNew.text = ""
        txtConfirm.text = ""
    }
    //    @IBAction func didValueChanged(_ sender: PuiSegmentedControl) {
    //        if sender.selectedIndex == 0 {
    //            viewChangePassword.isHidden = false
    //            viewChangeEmail.isHidden = true
    //            viewEmailNotification.isHidden = true
    //
    //        }else if sender.selectedIndex == 1 {
    //            viewChangePassword.isHidden = true
    //            viewChangeEmail.isHidden = false
    //            viewEmailNotification.isHidden = true
    //
    //        }else{
    //           viewChangePassword.isHidden = true
    //            viewChangeEmail.isHidden = true
    //            viewEmailNotification.isHidden = false
    //        }
    //
    //    }
    
    
    @IBAction func onClickNotificationSetings(_ sender: UIButton) {
        if sender.tag == 0 {
            if sender.currentImage == UIImage(named: ""){
                strDealbuy = "n"
            }else{
                strDealbuy = "y"
            }
        }else if sender.tag == 1 {
            if sender.currentImage == UIImage(named: ""){
                strDealPost = "n"
            }else{
                strDealPost = "y"
            }
        }else if sender.tag == 2 {
            if sender.currentImage == UIImage(named: ""){
                strDealPostCat = "n"
            }else{
                strDealPostCat = "y"
            }
        }else if sender.tag == 3{
            if sender.currentImage == UIImage(named: ""){
                strDealCart = "n"
            }else{
                strDealCart = "y"
            }
        }else{
            
        }
    }
    @IBAction func onClickUpdateNotification(_ sender: UIButton) {
        let param = ["action":"update-customer-notification",
                     "updatefor":"push",
                     "deal_post":strDealPost,
                     "deal_category_post":strDealPostCat,
                     "deal_buy":strDealbuy,
                     "deal_in_cart":strDealCart,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.updateNotification(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    @IBAction func onClickCancelNotification(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCickSubmit(_ sender: UIButton) {
        if isValidated(){
            callChangePassword()
        }
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtOldPAssword.text?.isEmpty)! {
            ErrorMsg = "Please enter current password"
        }
        else if (txtNew.text?.isEmpty)! {
            ErrorMsg = "Please enter new password"
        }
        else if (txtConfirm.text?.isEmpty)! {
            ErrorMsg = "Please enter confirm password"
        }
        else if txtNew.text! != txtConfirm.text! {
            ErrorMsg = "new password and confirm new password not match!"
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
    
    func callChangePassword() {
        let param = [
            "action":"change_password",
            "user_id":UserData.shared.getUser()!.user_id,
            "old_pwd":txtOldPAssword.text!,
            "new_pwd":txtNew.text!,
            "confirm_pwd":txtConfirm.text!
        ]
        Modal.shared.changePassword(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
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
extension AccountSettingsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblName.text = headerList[indexPath.row]
        if selectedIndex == indexPath.row{
            cell.viewPoint.isHidden = false
            
        }else{
            cell.viewPoint.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        paramNotification = [String:Any]()
        dictPref = [String:String]()
        if indexPath.row == 0{
            viewChangePassword.isHidden = false
            viewChangeEmail.isHidden = true
            viewEmailNotification.isHidden = true
            viewPushNotification.isHidden = true
        }else if indexPath.row == 1{
            viewChangePassword.isHidden = true
            viewChangeEmail.isHidden = false
            viewEmailNotification.isHidden = true
            viewPushNotification.isHidden = true
        }else if indexPath.row == 2{
            viewChangePassword.isHidden = true
            viewChangeEmail.isHidden = true
            viewEmailNotification.isHidden = true
            viewPushNotification.isHidden = false
//            notification = [NotificationList]()
//            callGetSettingsAPI()
        }else{
           viewChangePassword.isHidden = true
            viewChangeEmail.isHidden = true
            viewEmailNotification.isHidden = false
            viewPushNotification.isHidden = true
//            notification = [NotificationList]()
//            callGetSettingsAPI()
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str:String = headerList[indexPath.row]
        let width = str.width(withConstrainedHeight: 50, font: HeaderCell.locationNameFont);
        
        return CGSize(width: width + 40, height: 50);
        
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    //        return imageSize
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //    }
    
    //    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
    //        reloadMoreData(indexPath: indexPath)
    //
    //    }
    
    
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if businessListRelated.count - 1 == indexPath.row &&
    //            (relatedObj!.pagination!.current_page > relatedObj!.pagination!.total_pages) {
    //            self.callRelatedBusiness()
    //        }
    //    }
}
extension String
{
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width;
    }
}
extension AccountSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblPushSettings{
            dictPref[notificationPush[indexPath.row].id] = notificationPush[indexPath.row].preference_value
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingCell.identifier) as? NotificationSettingCell else {
                fatalError("Cell can't be dequeue")
            }
            if notificationPush[indexPath.row].preference_value ==  "y"{
                cell.btnSwitch.setImage(UIImage(named: "red-radio"), for: .normal)
                
            }else{
                cell.btnSwitch.setImage(UIImage(named: "gray-radio"), for: .normal)
            }
            cell.lblTitle.text = notificationPush[indexPath.row].notification_type
            cell.btnSwitch.tag = indexPath.row
            cell.btnSwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .touchUpInside)
            return cell
        }else{
            dictPref[notification[indexPath.row].id] = notification[indexPath.row].preference_value
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingCell.identifier) as? NotificationSettingCell else {
            fatalError("Cell can't be dequeue")
        }
            if notification[indexPath.row].preference_value ==  "y"{
                cell.btnSwitch.setImage(UIImage(named: "red-radio"), for: .normal)
            }else{
                cell.btnSwitch.setImage(UIImage(named: "gray-radio"), for: .normal)
            }
        cell.lblTitle.text = notification[indexPath.row].notification_type
            cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.addTarget(self, action: #selector(onClickSwitch1(_:)), for: .touchUpInside)
        return cell
        }
    }
    
    @objc func onClickSwitch(_ sender:UIButton){
       
       
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        if sender.currentImage == UIImage(named: "red-radio"){
            sender.setImage(UIImage(named: "gray-radio"), for: .normal)
           
           dictPref[notificationPush[sender.tag].id] = "n"
            
        }else{
            sender.setImage(UIImage(named: "red-radio"), for: .normal)
            dictPref[notificationPush[sender.tag].id] = "y"
        }
        
       
        paramNotification = param
        
        
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ?
            JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        //    JSONSerialization.WritingOptionsJSONSerialization.WritingOptions.PrettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    @objc func onClickSwitch1(_ sender:UIButton){
        
        
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        if sender.currentImage == UIImage(named: "red-radio"){
            sender.setImage(UIImage(named: "gray-radio"), for: .normal)
            
            dictPref[notification[sender.tag].id] = "n"
            
        }else{
            sender.setImage(UIImage(named: "red-radio"), for: .normal)
            dictPref[notification[sender.tag].id] = "y"
        }
        
        
        paramNotification = param
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPushSettings{
        return notificationPush.count
        }else{
            return notification.count
        }
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if tableView == tblPushSettings{
            self.tblPushHeightConst.constant = self.tblPushSettings.contentSize.height
            self.tblPushSettings.layoutIfNeeded()
            self.view.layoutIfNeeded()
            }else{
                self.tblHeightConst.constant = self.tblSettings.contentSize.height
                self.tblSettings.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
    
    
        }
    //
    //
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if paymentHistoryList.count - 1 == indexPath.row &&
    //            (favouriteObj!.currentPage > favouriteObj!.TotalPages) {
    //            self.paymentHistoryAPI()
    //        }
    //    }
}
