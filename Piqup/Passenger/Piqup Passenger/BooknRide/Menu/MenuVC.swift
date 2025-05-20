//
//  MenuVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage

class MenuVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var tableMenu: UITableView!
    
    let cellIdentifier  = "menuCell"
    var selectedIdex:Int = -1
    
    var menuItems:NSMutableArray = NSMutableArray.init()
    var listItems = [
       "Home",
       "My Profile",
       "Wallet",
       "Rides",
       "Notifications",
       "Account Settings",
       "Help",
       "About",
       "Info",
       "Logout"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(chnageConts), name: NSNotification.Name("ConstChnage"), object: nil)
        menuSetup()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        displayUser()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menuSetup(){
        if ((tableMenu) != nil) {
            let nib = UINib(nibName: "MenuCell", bundle: nil)
            tableMenu.register(nib, forCellReuseIdentifier: cellIdentifier)
            
            tableMenu.separatorStyle = UITableViewCellSeparatorStyle.none
            tableMenu.rowHeight  = 50
            tableMenu.estimatedRowHeight = 50
        }
        
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Menu", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            // Use your dict here
            menuItems = (dict.object(forKey: "list")as! NSArray).mutableCopy() as! NSMutableArray
        }
        
    }
    
    func displayUser(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        lblUserName.text = String(format: "%@ %@", (appDelegate.currentUser?.firstName)!,(appDelegate.currentUser?.lastName)!)
        
        let profileImage = String(format:"%@/%@/%@",URLConstants.Domains.profileUrl,(appDelegate.currentUser?.uId)!,(appDelegate.currentUser?.profileImage)!)
        
        self.userImgView.af_setImage(withURL: URL(string: profileImage)!)
        self.userImgView.applyCorner(radius: self.userImgView.frame.size.width/2)
        self.userImgView.clipsToBounds = true
    }
    
    func logout(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser?.uId ?? "",
                "userType":"u",
                "deviceId":CustomerDefaults.getDeviceToken(),
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.logout, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                
                        UserDefaults.standard.setValue("", forKey: "lastSendId")
                        UserDefaults.standard.synchronize()
                        self.slideMenuController()?.closeLeft()
                        User.setUserLoginStatus(isLogin: false)
                        self.sharedAppDelegate().rootToLogin()
                       
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    @IBAction func onClickClose(_ sender: UIButton) {
       
       
        self.slideMenuController()?.closeLeft()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Tableview DataSource/Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MenuCell
        
        if cell == nil {
            cell = MenuCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        if selectedIdex == indexPath.row{
            cell?.lblTitle.textColor = UIColor(red: 209, green: 47, blue: 54)
            cell?.viewPointer.isHidden = false
        }else{
            cell?.lblTitle.textColor = UIColor.darkGray
            cell?.viewPointer.isHidden = true
        }
        cell?.lblTitle.text =  listItems[indexPath.row]
        
        return cell!
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let item = self.listItems[indexPath.row]
            let controllerName = (item)
            self.selectedIdex = indexPath.row
            switch controllerName{
            case "Home":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: HomeVC.self))!{
                    
                    let homeController = HomeVC(nibName: "HomeVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: homeController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "My Profile":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: ProfileVC.self))!{
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let profileController = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
                    let nvc: UINavigationController = UINavigationController(rootViewController: profileController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Wallet":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: WalletVC.self))!{
                    
                    let walletController = WalletVC(nibName: "WalletVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: walletController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Rides":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: RidesVC.self))!{
                    
                    let ridesController = RidesVC(nibName: "RidesVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: ridesController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Notifications":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: NotificationVC.self))!{
                    
                    let notificationController = NotificationVC(nibName: "NotificationVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: notificationController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Account Settings":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: AccountSettingsVC.self))!{
                    
                    let accountSettingsController = AccountSettingsVC(nibName: "AccountSettingsVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: accountSettingsController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Help":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: HelpVC.self))!{
                    
                    let helpController = HelpVC(nibName: "HelpVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: helpController)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "About":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: AboutVC.self))!{
                    
                    let aboutVC = AboutVC(nibName: "AboutVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: aboutVC)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Info":
                if !(self.slideMenuController()?.mainViewController?.childViewControllers.first?.isKind(of: InfoVC.self))!{
                    
                    let aboutVC = InfoVC(nibName: "InfoVC", bundle: nil)
                    let nvc: UINavigationController = UINavigationController(rootViewController: aboutVC)
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.setToolbarHidden(true, animated: false)
                    self.slideMenuController()?.changeMainViewController(nvc, close: true)
                }
                else{
                    self.slideMenuController()?.closeLeft()
                }
            case "Logout":
                do {
                    let alert = Alert()
                
                        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: appConts.const.mSG_LOGOUT, leftButtonTitle: appConts.const.bTN_YES, rightButtonTitle: appConts.const.bTN_NO, leftCompletionBlock: {
                            self.logout()
                        }, rightCompletionBlock: {
                            
                        })
                }
                
            default:
                print("Unidentified Menu case")
            }
        }
    }
    
    @objc func chnageConts(){
        listItems = [
            appConts.const.tITLE_HOME,
            appConts.const.pROFILE,
            appConts.const.tITLE_FINANCIAL_INFO,
            appConts.const.tITLE_RIDES,
            appConts.const.nOTIFICATION,
            appConts.const.tITLE_ACCOUNT_SETTINGS,
            appConts.const.hELP,
            appConts.const.aBOUT,
            appConts.const.tITLE_INFO,
            appConts.const.lOGOUT
        ]
        self.tableMenu.reloadData()
    }
}



