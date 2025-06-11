//
//  MyAccountViewController.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit
import MarketingCloudSDK

class MyAccountViewController: UIViewController, AccountTableViewCellDelegate,SignoutProtocol,GestUserTableCellProtocol,CollectionTableViewCellDelegate, mobilePopupVCDelegate {
    @IBOutlet weak var viewHeader: headerView!
    
    //let headerCell = "headerCell"
    let getstLoginCell = "getstLoginCell"
    let signoutCell = "SignoutCell"
    let mywishCell = "mywishCell"
    let myAccountCell = "AccountCell"
    let MyLocationCell = "MyLocationCell"
    let MyLanguageCell = "MyLanguageCell"
    let InfoHelpCell = "InfoHelpCell"
    let PushNotificationsCell = "PushNotificationsCell"
    let PreferredCatCell = "PreferredCatCell"
    let kcategorySelectionCell = "kcategorySelectionCell"
    
    var messagesCount = 0
    
    var myWishList = [WishlistModel]()
    
    var cellDic =  [String:String]()
    var cellArray = [String]()
    var userEmailID:String = ""
    var window: UIWindow?
    var userData: AddressInformation?
    let checkoutModel = CheckoutViewModel()
    var addressArray : [Addresses] = [Addresses]()
    var selectedCategory = UserDefaults.standard.value(forKey: "category") as? String ?? ""
    func didSelectedRowWith(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MyOrders", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
        let navcontroller = UINavigationController.init(rootViewController: viewC)
        //        navcontroller.navigationBar.isHidden = true
        self.window?.rootViewController = navcontroller
        self.window?.makeKeyAndVisible()
        //        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var isEnglish: Bool = false
    var isArbic: Bool = false
    //MARK:- Controller Instance
    static var myAccountStoryboardInstance:MyAccountViewController? {
        return StoryBoard.home.instantiateViewController(withIdentifier: MyAccountViewController.identifier) as? MyAccountViewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedOut), name: Notification.Name("UserLoggedOut"), object: nil)

        if UserDefaults.standard.string(forKey: string.language) == string.en {
            isArbic = false
            isEnglish = true
            switchViewControllers(isArabic: false)
        }
        else{
            isArbic = true
            isEnglish = false
            switchViewControllers(isArabic: true)
        }
        loadHeaderAction()
        tableView.separatorColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let cells =
            [TopViewTableCell.className,SignoutTableViewCell.className,CollectionTableViewCell.className,AccountTableViewCell.className, MyLocationTableCell.className, MyLanguageTableViewCell.className,InfoHelpTableViewCell.className,GestUserTableCell.className,PushNotificationsTableViewCell.className,PreferredCategoryCell.className,categorySelectionCell.className]
        tableView.register(cells)
        
    }
    private func loadHeaderAction(){
        //header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        viewHeader.backButton.isHidden = true
        viewHeader.headerTitle.text = "aacountAccount".localized.uppercased()
        viewHeader.buttonClose.addAction(for: .touchUpInside) { [unowned self] in
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 0)
            })
            
        }
        
        
    }
    @objc func userLoggedOut(){
        callUserLoggedOut()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        selectedCategory = UserDefaults.standard.value(forKey: "category") as? String ?? "women"
        if UserDefaults.standard.value(forKey: "userToken") != nil {
            //user Login
            getUserDetail()
            cellArray = [signoutCell,mywishCell,myAccountCell,MyLocationCell,MyLanguageCell,InfoHelpCell]
            getMyWishList()
        } else {
            
            cellArray = [getstLoginCell,kcategorySelectionCell,MyLocationCell,MyLanguageCell,PushNotificationsCell,InfoHelpCell]
        }
        fecthMessagesCount()
        
        self.tableView.reloadData()
        
         if isUserChangedPasswordInWebsite {
             callUserLoggedOut()
         }
    }
     func callUserLoggedOut() {
        DispatchQueue.main.async {
               isUserChangedPasswordInWebsite = false
               print("SIgn Out Pressed")
               UserDefaults.standard.set(nil , forKey: "userToken")
               UserDefaults.standard.set(nil, forKey:"customerId")
               UserDefaults.standard.set(nil, forKey:"storeId")
               UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
               UserDefaults.standard.set(nil,forKey: "quote_id_to_convert")
               UserDefaults.standard.set(nil, forKey: string.isFBuserLogin)
               
            
               removeAllWishListArray()
               //User is Not Loggedin case Handle
               M2_isUserLogin = false
               userLoginStatus(status: false)
               //getQuoteId()
              
               let fbLoginManager = LoginManager()
                  fbLoginManager.logOut()
                  let cookies = HTTPCookieStorage.shared
                  let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
                  for cookie in facebookCookies! {
                      cookies.deleteCookie(cookie )
                  }
            
               FacebookSignInManager.logoutFromFacebook()
               self.loadHomePage()
        }
    }
    func getUserDetail()  {
        checkoutModel.getAddrssInformation(success: { (response) in
            print(response)
            self.userData = response
            guard let items = self.userData?.addresses else {
                return
            }
            self.checkMobileNumber()
            self.addressArray = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) {
            
        }
        
    }
    
    func checkMobileNumber(){
        var mobileNo = ""
        let customAtr = self.userData?.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                mobileNo = customAtrbt.value ?? ""
            }
        }
        //        if mobileNo == "" {
        //           showMobilepopup()
        //        }
    }
    func showMobilepopup() {
        let storyboard = UIStoryboard(name: "mobilepopup", bundle: Bundle.main)
        let popupVC: mobilePopupVC! = storyboard.instantiateViewController(withIdentifier: "mobilePopupVC") as? mobilePopupVC
        popupVC.mobilePopupDelegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
    }
    func continuousBtnAction(mobilePopupVC :mobilePopupVC, mobile: String){
        //update mobile Number
        var dataDic = [String:String]()
        dataDic =  ["dob":"\(userData?.dob ?? "")","salutation":"\(userData?.prefix ?? "")","firstName":"\(userData?.firstname ?? "")","lastName":"\(userData?.lastname ?? "")","mobileNo":"","emailAddress":"\(userData?.email ?? "")","gender":"\(userData?.gender)"]
        let customAtr = self.userData?.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                dataDic["mobileNo"] = "\(mobile)"
            }
        }
        
        let dobstr = dataDic["dob"]?.replace(string: "/", replacement: "-")
        
        let paramdata =
            [
                
                "customer": [
                    "prefix": dataDic["salutation"] ,
                    "firstname": dataDic["firstName"],
                    "lastname": dataDic["lastName"] ,
                    "email":dataDic["emailAddress"] ,
                    "middlename": "",
                    "dob": dobstr,
                    "gender": dataDic["gender"],
                    "store_id": userData?.storeId ,
                    "website_id": userData?.websiteId ,
                    "custom_attributes": [
                        [
                            "attribute_code" : "telephone",
                            "value": dataDic["mobileNo"]
                        ]
                    ]
                    
                ]
                
                ] as [String : Any]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.saveChangePref(params: paramdata, success: {  (response, error)  in
            MBProgressHUD.hide(for: self.view, animated: true)
            mobilePopupVC.dismiss(animated: true, completion: nil)
            self.showThankyouPopup()
            
        }) {_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Error".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showThankyouPopup() {
        let storyboard = UIStoryboard(name: "thanksPopup", bundle: Bundle.main)
        let popupVC: ThanksPopupVC! = storyboard.instantiateViewController(withIdentifier: "ThanksPopupVC") as? ThanksPopupVC
        popupVC.popupHeader = "Thanks".localized
        // popupVC.popupDesc = "Pass your ANy Desc Here TO see DESC"
        
        popupVC.popupDescHidden = true
        self.present(popupVC, animated: true, completion: nil)
        
    }
    //-------------end----------------
    func getMyWishList()  {
        let param = [
            "customer_id": UserDefaults.standard.value(forKey: "customerId") ?? 0
            ] as [String : Any]
        
        ApiManager.getWishList(params: param, success: { (response ) in
            print(response)
            if response != nil{
                self.myWishList = []
                if let data = response  as? [AnyObject]{
                    for wislistitem in data{
                        var productModel = WishlistModel()
                        productModel = productModel.getWishlistModel(dict: wislistitem as! [String : AnyObject])
                        
                        self.myWishList.append(productModel)
                    }
                }
                self.myWishList =  getSortedWishList(wishList: self.myWishList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }) {
            
        }
        
    }
    
    func loadHomePage(){
        
        UserDefaults.standard.set(0, forKey: string.notificationItemCount)
        NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
        
        cellArray = []
        if UserDefaults.standard.value(forKey: string.userToken) != nil {
            //user Login
            cellArray = [signoutCell,mywishCell,myAccountCell,MyLocationCell,MyLanguageCell,InfoHelpCell]
        } else {
            cellArray = [getstLoginCell,kcategorySelectionCell,MyLocationCell,MyLanguageCell,PushNotificationsCell,InfoHelpCell]
        }
        self.tableView.reloadData()
        //self.navigationController?.popToRootViewController(animated: true)
        
    }
    func logoutView(){
        
    }
    func needHelp() {
        
    }
    func registerButtonTap(){
        let loginVC = RegistrationUserViewController.storyboardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(loginVC, animated: false)
    }
    func signButtonTap(){
        
        let loginVC = LoginViewController.storyboardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(loginVC, animated: false)
        
    }
    
    func loadPDPPageWithKvuId(kvu:String){
        self.klevuProductSearchApi(skutext: kvu)
    }
    func klevuProductSearchApi(skutext: String){
        let delimiter = ";"
        let tempSkuArray = skutext.components(separatedBy: delimiter)
        let skuId = tempSkuArray[0]
        var arrMust = [[String:Any]]()
        
        arrMust.append(["match": ["sku":skuId]])
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        
        var dictSort = [String:Any]()
        dictSort = ["updated_at":"desc"]
        let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id"],
                     "from":0,
                     "size": 5,
                     "sort" : dictSort,
                     "query": dictBool
            ] as [String : Any]
        
        let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                if error.localizedDescription.contains(s: "offline") {
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                }
                
                return
            }
            var data: NewInData?
            if response != nil{
                let dict = ["data": response?.dictionaryObject]
                data = NewInData(dictionary: ResponseKey.fatchData(res: dict as dictionary, valueOf: .data).dic)
                DispatchQueue.main.async(execute: {
                    
                    let nextVC = ProductDetailVC.storyboardInstance!
                    // nextVC.selectedProduct = ip.row
                    nextVC.isCommingFromWishList = true
                    nextVC.detailData = data
                    // applyTransitionAnimation(nextVC: nextVC)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                })
            }
            
        }
    }
    
    @objc func btnNextAction(sender: UIButton!) {
        print("Next button taped")
        let storyboard = UIStoryboard(name: "mywishlist", bundle: Bundle.main)
        let wishlishtVC: MyWishlistVC! = storyboard.instantiateViewController(withIdentifier: "MyWishlistVC") as? MyWishlistVC
        wishlishtVC.myWishList = self.myWishList
        self.navigationController?.pushViewController(wishlishtVC, animated: true)
    }
    func goToHomeScreen(){
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 0)
        })
    }
    func goWishListView(){
        let storyboard = UIStoryboard(name: "mywishlist", bundle: Bundle.main)
        let wishlishtVC: MyWishlistVC! = storyboard.instantiateViewController(withIdentifier: "MyWishlistVC") as? MyWishlistVC
        wishlishtVC.myWishList = self.myWishList
        self.navigationController?.pushViewController(wishlishtVC, animated: true)
        
    }
    
       func fecthMessagesCount() {
//         if let inboxArray = MarketingCloudSDK.sharedInstance().sfmc_getAllMessages() as? [[String : Any]] {
//             messagesCount = inboxArray.count
//             self.tableView.reloadData()
//         }
        if MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount() != nil{
            let unreadCount = MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount()
            messagesCount = Int(unreadCount)
            self.tableView.reloadData()
            UserDefaults.standard.set(unreadCount, forKey: string.notificationItemCount)
            NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
        }
     }
    
}

extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellString = cellArray[indexPath.row]
        if cellString == kcategorySelectionCell  {
            return  160
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = cellArray[indexPath.row]
        
        switch cellString
        {
            //        case headerCell:
            //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewTableCell", for: indexPath) as? TopViewTableCell else{return UITableViewCell()}
        //            return cell
        case getstLoginCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GestUserTableCell", for: indexPath) as? GestUserTableCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case signoutCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutTableViewCell", for: indexPath) as? SignoutTableViewCell else{return UITableViewCell()}
            cell._lblUserEmail.text = userData?.email
            cell._lblUserName.text = userData?.firstname
            cell.delegate = self
            return cell
        case mywishCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell else{return UITableViewCell()}
            cell.delegate = self
            cell.myWishList = self.myWishList
            cell.updateWishListView()
            if self.myWishList.count < 1{
                cell.btnNext.isHidden = true
            }else{
                cell.btnNext.isHidden = false
                cell.btnNext.addTarget(self, action: #selector(btnNextAction), for: .touchUpInside)
            }
            
            return cell
        case myAccountCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell else{return UITableViewCell()}
            cell.userData = self.userData
            cell.addressArray = self.addressArray
            cell.delegates = self
            cell.notificationsCount = messagesCount
            cell.accountTableView.reloadData()
            //cell._lblName.text! +=  " " +  "(" + "\(messagesCount)" +  ")"
            UserDefaults.standard.set(messagesCount, forKey: string.notificationItemCount)
            NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
            cell.parentController = self
            return cell
        case kcategorySelectionCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "categorySelectionCell", for: indexPath) as? categorySelectionCell else{return UITableViewCell()}
            selectedCategory = UserDefaults.standard.value(forKey: "category") as? String ?? "women"
            cell.selectedCategory(aCategory: selectedCategory)
            // cell.delegates = self
            // cell.parentController = self
            return cell
        //
        case MyLocationCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationTableCell", for: indexPath) as? MyLocationTableCell else{return UITableViewCell()}
            cell._imgCountryFlag.isHidden = false
            cell.updateLocatioCell()
            cell.parentVC = self
            return cell
        case InfoHelpCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoHelpTableViewCell", for: indexPath) as? InfoHelpTableViewCell else{return UITableViewCell()}
            cell.parentController = self
            return cell
            
        case PushNotificationsCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PushNotificationsTableViewCell", for: indexPath) as? PushNotificationsTableViewCell else{return UITableViewCell()}
            //cell.parentController = self
            return cell
            
        case PreferredCatCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreferredCategoryCell", for: indexPath) as? PreferredCategoryCell else{return UITableViewCell()}
            //cell.parentController = self
            return cell
        case MyLanguageCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyLanguageTableViewCell", for: indexPath) as? MyLanguageTableViewCell else{return UITableViewCell()}
            cell.delegate = self
            
            if isEnglish{
                cell._btnEnglish.drawCornerButton()
                cell._btnEnglish.setBackgroundColor(color: .black, forState: .normal)
                cell._btnEnglish.setTitleColor(UIColor.white, for: .normal)
                
                cell._btnArbic.drawCornerButton()
                cell._btnArbic.setBackgroundColor(color: .white, forState: .normal)
                cell._btnArbic.setTitleColor(UIColor.black, for: .normal)
                cell._btnArbic.border(side: .all, color: .black, borderWidth: 1.0)
                
            }else{
                cell._btnArbic.drawCornerButton()
                cell._btnArbic.setBackgroundColor(color: .black, forState: .normal)
                cell._btnArbic.setTitleColor(UIColor.white, for: .normal)
                
                cell._btnEnglish.drawCornerButton()
                cell._btnEnglish.setBackgroundColor(color: .white, forState: .normal)
                cell._btnEnglish.setTitleColor(UIColor.black, for: .normal)
                cell._btnEnglish.border(side: .all, color: .black, borderWidth: 1.0)
            }
            //            cell._btnEnglish.addTarget(self, action:  #selector(tapTOEnglishPress(_:)), for: .touchUpInside)
            //            cell._btnEnglish.addTarget(self, action:  #selector(tapTOEnglishPress(_:)), for: .touchUpInside)
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoHelpTableViewCell", for: indexPath) as? InfoHelpTableViewCell else{return UITableViewCell()}
            cell.parentController = self
            return cell
            
        }
    }
}

extension MyAccountViewController: MyLanguageTableViewCellDelegate{
    
    func selectArabic() {
        let refreshAlert = UIAlertController(title: "refresh".localized, message: "change_language".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.isArbic = true
            self.isEnglish = false
            isLanguageCodeChanged = true
            
            //Bundle.setLanguage("ar")
            UserDefaults.standard.setValue(string.Arabic, forKey: string.userLanguage)
            UserDefaults.standard.setValue(string.ar, forKey: string.language)
            if(isUserLoggedIn()){userLoginStatus(status: true)}
            else{userLoginStatus(status: false)}
            //        switchViewControllers(isArabic: true)
            self.tabBarController?.switchViewControllersTab(isArabic: true)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
            
            UIApplication.shared.keyWindow?.rootViewController = nextViewController
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func selectEnglish() {
        
        let refreshAlert = UIAlertController(title: "refresh".localized, message: "change_country".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.isArbic = false
            self.isEnglish = true
            isLanguageCodeChanged = true
            
            //        switchViewControllers(isArabic: false)
            self.tabBarController?.switchViewControllersTab(isArabic:false)
            //Bundle.setLanguage("en")
            UserDefaults.standard.setValue(string.English, forKey: string.userLanguage)
            UserDefaults.standard.setValue(string.en, forKey: string.language)
            if(isUserLoggedIn()){userLoginStatus(status: true)}
            else{userLoginStatus(status: false)}
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
            
            UIApplication.shared.keyWindow?.rootViewController = nextViewController
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
}
