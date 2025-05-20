//
//  LeftSideMenu.swift
//  Talabtech
//
//  Created by NCT 24 on 05/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class LeftSideMenu: UIViewController {
    
    //MARK: Properties
    
    static var storyboardInstance:LeftSideMenu? {
        return StoryBoard.main.instantiateViewController(withIdentifier: LeftSideMenu.identifier) as? LeftSideMenu
    }
    
   
    var menuNames = [String]()
    var menuImages = [UIImage]()
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    var vcArray = [UIViewController]()
    
    
    @IBOutlet weak var btnEdit: UIButton!{
        didSet{
            btnEdit.setTitle("Edit".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    fileprivate func loadFromIntialIndex() {
        selectedIndex = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            var cell:LeftMenuCell?
            cell = self.tableView.cellForRow(at: self.selectedIndex) as? LeftMenuCell
            guard let cellSelected = cell else { return }
            cellSelected.contentView.backgroundColor = Color.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
            self.imgUser.downLoadImage(url: UserData.shared.getUser()!.profileImg)
            self.lblUserName.text = (UserData.shared.getUser()?.firstName)! + " " + (UserData.shared.getUser()?.lastName)!
           
            lblLocation.text = UserData.shared.getUser()?.address
      
        loadFromIntialIndex()
        setMenuBarElements()
        
        
    }
    @IBOutlet weak var iconLocation: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.setRadius()
        }
    }
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(LeftMenuCell.nib, forCellReuseIdentifier: LeftMenuCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
    
    }
}

//MARK: Custom functions
extension LeftSideMenu{
    func setMenuBarElements() {
      
             menuNames = ["My Dashboard".localized,"My Profile".localized,"My Reviews".localized,"My Services".localized,"My Wallet".localized,"Sent Service Request".localized,"Received Service Request".localized,"Manage Favorite Service".localized,"Financial Information".localized,"Notification Settings".localized,"Account Settings".localized,"Contact Us".localized,"Information".localized,"LOGOUT".localized]
            menuImages = [#imageLiteral(resourceName: "dashboardIco"),#imageLiteral(resourceName: "proIco"),#imageLiteral(resourceName: "reviewIco"),#imageLiteral(resourceName: "servicesMyIco"),#imageLiteral(resourceName: "walletIco"), #imageLiteral(resourceName: "sendService"),#imageLiteral(resourceName: "recievedService"),#imageLiteral(resourceName: "manageFavIcon"),#imageLiteral(resourceName: "financeIcon"),#imageLiteral(resourceName: "notifyIco"),#imageLiteral(resourceName: "settingIco"),#imageLiteral(resourceName: "contactIco"),#imageLiteral(resourceName: "informIco"),#imageLiteral(resourceName: "logoutIco")]
            
//            vcArray = [MyFolowersVC.storyboardInstance!,
//                       ProfileMerchantVC.storyboardInstance!,
//                       ReviewsVC.storyboardInstance!,
//                       ManageDealsVC.storyboardInstance!,
//                       ManageDealOrderVC.storyboardInstance!,
//                       NotificationVC.storyboardInstance!,
//                       AccountSettingsVC.storyboardInstance!,
//                       ContactUsVC.storyboardInstance!,
//                       StaticPageVC.storyboardInstance!
//                       //Logout, 7
//            ]
//        }else{
//             menuNames = ["Dashboard","Login","Sign up","Contact Us","Info"]
//             menuImages = [#imageLiteral(resourceName: "dashboard"),#imageLiteral(resourceName: "Login"), #imageLiteral(resourceName: "Signup"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "info")]
//
//            vcArray = [HomeVC.storyboardInstance!,
//                        LoginVC.storyboardInstance!,
//                       SignUpVC.storyboardInstance!,
//                        ContactUsVC.storyboardInstance!,
//                        StaticPageVC.storyboardInstance!]
//        }
        self.tableView.reloadData()
        
        
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        isFromEdit = false
        if sender.tag == 2{
            if UserData.shared.getUser()?.isCertificate == 0 {
                self.alert(title: "", message: "please upload certificates in your profile to add service".localized)
            }else if UserData.shared.getUser()?.insta_verify == "n" {
                self.alert(title: "", message: "please verify your instagram account".localized)
            }
            else{
                self.tabBarController?.selectedIndex = sender.tag
            }
        }else{
            self.tabBarController?.selectedIndex = sender.tag
        }
    }
    
    
}

extension LeftSideMenu: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuCell.identifier) as? LeftMenuCell
            else {fatalError("cell can't be deque")}
        
        cell.imgIcon.image = menuImages[indexPath.row]
        cell.lblMenuName.text = menuNames[indexPath.row]
//        if UIDevice.isiPhone5() {
//            cell.widthConstrain.constant = 20
//        }else{
//            cell.widthConstrain.constant = 46
//        }
        
        if selectedIndex == indexPath {
//            cell.contentView.backgroundColor = Color.green.theam
        }
        else{
//            cell.contentView.backgroundColor = Color.Black.theam
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            selectedIndex = indexPath
            let user = UserData.shared.getUser()
            if (indexPath.row == 13){
                logout()
              
            }else{
               // sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
               
        }
        }
    
    
    func logout() {
        self.alert(title: "", message: "Are you sure you want to logout from this application ?".localized, actions: ["Ok".localized,"Cancel".localized]) { (btnNo) in
            if btnNo == 0 {
                print("Logout")
                
              //  let param = ["user_id":UserData.shared.getUser()!.user_id, "device_token": UserData.shared.deviceToken] //, "lId": ""
                let param = ["userId":UserData.shared.getUser()!.id, "deviceId": UserData.shared.deviceToken,"lId":UserData.shared.getLanguage,"action":"logout"] as [String : Any] //, "lId": ""//UserData.shared.deviceToken
                Modal.shared.login(vc: self, param: param) { (dic) in
                    print(dic)
                    UserData.shared.logoutUser()
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontrollerHome") as! UITabBarController
                    viewController.tabBar.isHidden = true
                    UIApplication.shared.keyWindow?.rootViewController = viewController;
                }
                
            }
            else {
                //Do nothing
            }
        }
    }
    
    
    func getNextVC(index: Int) -> UIViewController? {
       
            switch index {
            case 0:
                isfromProfile = false
                let vc = DashboardVC.storyboardInstance!
                vc.navTitle = "My Dashboard".localized
                return vc
            case 1:
                isfromProfile = true
                let vc = DashboardVC.storyboardInstance!
                vc.navTitle = "My Profile".localized
                return vc
            case 2:
                return ReviewsVC.storyboardInstance!
            case 3:
                return MyServiceVC.storyboardInstance!
            case 4:
                return MyWalletVC.storyboardInstance!
            case 5:
                return SentRequestVC.storyboardInstance!
            case 6:
                return ReceivedRequestVC.storyboardInstance!
            case 7:
                return ManageFavoriteServiceVC.storyboardInstance!
            case 8:
                return FinancialInformationVC.storyboardInstance!
            case 9:
                return NotificationSettingsVC.storyboardInstance!
            case 10:
                return AccountSettingsVC.storyboardInstance!
            case 11:
                return ContactUsVC.storyboardInstance
            case 12:
                return infoVC.storyboardInstance!
            case 13:
                return nil
            default:
                return nil
            }
}
//        }else if user?.user_type == "m" {
//            switch index {
//            case 0:
//                return MyFolowersVC.storyboardInstance!
//            case 1:
//                return ProfileMerchantVC.storyboardInstance!
//            case 2:
//                return ReviewsVC.storyboardInstance!
//            case 3:
//                return ManageDealsVC.storyboardInstance!
//            case 4:
//                return ManageDealOrderVC.storyboardInstance!
//            case 5:
//                return NotificationVC.storyboardInstance!
//            case 6:
//                return AccountSettingsVC.storyboardInstance!
//            case 7:
//                return ContactUsVC.storyboardInstance!
//            case 8:
//                return StaticPageVC.storyboardInstance!
//            default:
//            return nil
//            }
//        }
//        else{
//            switch index {
//            case 0:
//            return HomeVC.storyboardInstance!
//            case 1:
//            return LoginVC.storyboardInstance!
//            case 2:
//            return SignUpVC.storyboardInstance!
//            case 3:
//            return ContactUsVC.storyboardInstance!
//            case 4:
//                return StaticPageVC.storyboardInstance!
//            default:
//              return nil
//            }
//        }
//    }

}

