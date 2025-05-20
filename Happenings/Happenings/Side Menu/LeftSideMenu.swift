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
        
        if UserData.shared.getUser() != nil{
            self.imgUser.downLoadImage(url: UserData.shared.getUser()!.userProfileImage)
            self.lblUserName.text = (UserData.shared.getUser()?.firstName)! + " " + (UserData.shared.getUser()?.lastName)!
            iconLocation.isHidden = false
            lblLocation.text = UserData.shared.getUser()?.address
        }else{
            iconLocation.isHidden = true
            self.lblUserName.text = "Guest User"
            self.imgUser.image = #imageLiteral(resourceName: "user")
        }
        
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
    
    @IBAction func onClickClose(_ sender: UIButton) {
        Modal.sharedAppdelegate.sideMenuController.hideLeftView(animated: true, completionHandler: nil)
    }
}

//MARK: Custom functions
extension LeftSideMenu{
    func setMenuBarElements() {
       // self.view.backgroundColor = Color.Black.theam
        let user = UserData.shared.getUser()
        if user?.user_type == "c" {
            print("Login as Customer")
            menuNames = ["Dashboard","My Profile","Favorite Deals","My Following Merchant","My Reviews","Refer a Friend","Purchased Deals","Recently Viewed Deals","Payment History","Notification","Account Setings","Shopping Cart","Contact Us","Info","Logout"]
            menuImages = [#imageLiteral(resourceName: "dashboard"),#imageLiteral(resourceName: "dashboard"), #imageLiteral(resourceName: "Favdeal"),#imageLiteral(resourceName: "merchant"), #imageLiteral(resourceName: "reviews"), #imageLiteral(resourceName: "referfriend"), #imageLiteral(resourceName: "deal"), #imageLiteral(resourceName: "vieweddeal"), #imageLiteral(resourceName: "paymenthistory"), #imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "Accountsetting"),#imageLiteral(resourceName: "Cart"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "info"),#imageLiteral(resourceName: "Logout")]
            
            vcArray = [HomeVC.storyboardInstance!,
                       ProfileUserVC.storyboardInstance!,
                       FavoriteDealsVC.storyboardInstance!,
                       MyFollowingMerchantVC.storyboardInstance!,
                       ReviewsVC.storyboardInstance!,
                       ReferFriendVC.storyboardInstance!,
                       PurchasedDealVC.storyboardInstance!,
                      RecentViewedVC.storyboardInstance!,
                       PaymentHistoryVC.storyboardInstance!,
                       NotificationVC.storyboardInstance!,
                       AccountSettingsVC.storyboardInstance!,
                       ShoppingCartVC.storyboardInstance!,
                       ContactUsVC.storyboardInstance!,
                       StaticPageVC.storyboardInstance!
                       
                       //Logout, 12
            ]
        }
        else if user?.user_type == "m"{
            print("Login as Provider")
             menuNames = ["My Followers","My Profile","My Reviews","My Deals","My Deal Orders","Notification","Account Settings","Contact Us","Info","Logout"]
            menuImages = [#imageLiteral(resourceName: "merchant"),#imageLiteral(resourceName: "merchant"),#imageLiteral(resourceName: "reviews"),#imageLiteral(resourceName: "deal"),#imageLiteral(resourceName: "Mydealorder"), #imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "Accountsetting"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "info"),#imageLiteral(resourceName: "Logout")]
            
            vcArray = [MyFolowersVC.storyboardInstance!,
                       ProfileMerchantVC.storyboardInstance!,
                       ReviewsVC.storyboardInstance!,
                       ManageDealsVC.storyboardInstance!,
                       ManageDealOrderVC.storyboardInstance!,
                       NotificationVC.storyboardInstance!,
                       AccountSettingsVC.storyboardInstance!,
                       ContactUsVC.storyboardInstance!,
                       StaticPageVC.storyboardInstance!
                       //Logout, 7
            ]
        }else{
             menuNames = ["Dashboard","Login","Sign up","Contact Us","Info"]
             menuImages = [#imageLiteral(resourceName: "dashboard"),#imageLiteral(resourceName: "Login"), #imageLiteral(resourceName: "Signup"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "info")]
            
            vcArray = [HomeVC.storyboardInstance!,
                        LoginVC.storyboardInstance!,
                       SignUpVC.storyboardInstance!,
                        ContactUsVC.storyboardInstance!,
                        StaticPageVC.storyboardInstance!]
        }
        self.tableView.reloadData()
        
        
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
            if (indexPath.row == 14 && user?.user_type == "c") || (indexPath.row == 9 && (user?.user_type == "m")){
                logout()
              
            }else{
                sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
               
        }
        }
    
    
    func logout() {
        self.alert(title: "", message: "Are you sure you want to logout from this application ?", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                print("Logout")
                
              //  let param = ["user_id":UserData.shared.getUser()!.user_id, "device_token": UserData.shared.deviceToken] //, "lId": ""
                let param = ["userId":UserData.shared.getUser()!.user_id, "deviceToken": "1212121212","deviceType":"iphone","action":"logout"] //, "lId": ""//UserData.shared.deviceToken
                Modal.shared.logOut(vc: self, param: param) { (dic) in
                    print(dic)
                    UserData.shared.logoutUser()
                    Modal.sharedAppdelegate.sideMenuController.hideLeftView()
                    Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                                    let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenu") as! LeftSideMenu
                                    Modal.sharedAppdelegate.sideMenuController.leftViewController = leftViewController
                }
                
            }
            else {
                //Do nothing
            }
        }
    }
    
    
    func getNextVC(index: Int) -> UIViewController? {
        let user = UserData.shared.getUser()
        if user?.user_type == "c" {
            switch index {
            case 0:
                return HomeVC.storyboardInstance!
            case 1:
                return ProfileUserVC.storyboardInstance!
            case 2:
                return FavoriteDealsVC.storyboardInstance!
            case 3:
                return MyFollowingMerchantVC.storyboardInstance!
            case 4:
                return ReviewsVC.storyboardInstance!
            case 5:
                return ReferFriendVC.storyboardInstance!
            case 6:
                return PurchasedDealVC.storyboardInstance!
            case 7:
                return RecentViewedVC.storyboardInstance!
            case 8:
                return PaymentHistoryVC.storyboardInstance!
            case 9:
                return NotificationVC.storyboardInstance!
            case 10:
                return AccountSettingsVC.storyboardInstance!
            case 11:
                return ShoppingCartVC.storyboardInstance!
            case 12:
                return ContactUsVC.storyboardInstance!
            case 13:
                return StaticPageVC.storyboardInstance!
            default:
                return nil
            }
        }else if user?.user_type == "m" {
            switch index {
            case 0:
                return MyFolowersVC.storyboardInstance!
            case 1:
                return ProfileMerchantVC.storyboardInstance!
            case 2:
                return ReviewsVC.storyboardInstance!
            case 3:
                return ManageDealsVC.storyboardInstance!
            case 4:
                return ManageDealOrderVC.storyboardInstance!
            case 5:
                return NotificationVC.storyboardInstance!
            case 6:
                return AccountSettingsVC.storyboardInstance!
            case 7:
                return ContactUsVC.storyboardInstance!
            case 8:
                return StaticPageVC.storyboardInstance!
            default:
            return nil
            }
        }
        else{
            switch index {
            case 0:
            return HomeVC.storyboardInstance!
            case 1:
            return LoginVC.storyboardInstance!
            case 2:
            return SignUpVC.storyboardInstance!
            case 3:
            return ContactUsVC.storyboardInstance!
            case 4:
                return StaticPageVC.storyboardInstance!
            default:
              return nil
            }
        }
    }

}

