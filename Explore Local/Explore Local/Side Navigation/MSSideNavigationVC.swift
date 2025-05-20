//
//  MSSideNavigationVC.swift
//  MIShop
//
//  Created by nct48 on 03/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

struct sideMenu
{
    var title : String
    
    static func setTableData() -> [sideMenu]{
        let user = UserData.shared.getUser()
        if user?.user_type == "1"{
        return [
            
            sideMenu(title: "Home"),
            sideMenu(title: "Membership Plan"),
            sideMenu(title: "Profile"),
           // sideMenu(title: "Posted Reviews"),
            sideMenu(title: "Favorite Business"),
            sideMenu(title: "Invite Friends"),
            sideMenu(title: "Payment History"),
            sideMenu(title: "Notifications"),
            //sideMenu(title: "Messages"),
            sideMenu(title: "Account Settings"),
            sideMenu(title: "Contact Us"),
            sideMenu(title: "Logout")
            
        ]
        }else if user?.user_type == "2"{
        return [
            sideMenu(title: "Home"),
            sideMenu(title: "Profile"),
            sideMenu(title: "Posted Business"),
            sideMenu(title: "Received Reviews"),
            sideMenu(title: "Posted Advertisement"),
            //sideMenu(title: "Messages"),
            sideMenu(title: "Account Settings"),
            sideMenu(title: "Contact Us"),
            sideMenu(title: "Logout")
        ]
        }else{
            return [
                sideMenu(title: "Home"),
                sideMenu(title: "Membership Plan"),
                sideMenu(title: "Profile"),
                // sideMenu(title: "Posted Reviews"),
                sideMenu(title: "Favorite Business"),
                sideMenu(title: "Invite Friends"),
                sideMenu(title: "Payment History"),
                sideMenu(title: "Notifications"),
                //sideMenu(title: "Messages"),
                sideMenu(title: "Account Settings"),
                sideMenu(title: "Contact Us"),
            ]
        }
    }
    
}

class MSSideNavigationVC: UIViewController
{
    @IBOutlet var tableViewSideNavBar: UITableView!{didSet{
        tableViewSideNavBar.tableFooterView = UIView()
        }}
    
    var arrSideMenu = sideMenu.setTableData()
   
    
    @IBOutlet var imgUserImage: UIImageView!{
        didSet{
            imgUserImage.setRadius()
        }
    }
    @IBOutlet var lblUserName: UILabel!
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    var selectedRowIndex : Int = -1
     var vcArray = [UIViewController]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        imgUserImage.image = #imageLiteral(resourceName: "myprofile-ico")
        lblUserName.text = "Guest"
        self.arrSideMenu = sideMenu.setTableData()
        self.tableViewSideNavBar.reloadData()
        selectedRowIndex = -1
        tableViewSideNavBar.reloadData()
        let user = UserData.shared.getUser()
            if user != nil{
        imgUserImage.downLoadImage(url: (UserData.shared.getUser()?.image)!)
        lblUserName.text = UserData.shared.getUser()?.name
        }else{
            imgUserImage.image = #imageLiteral(resourceName: "myprofile-ico")
            lblUserName.text = "Guest"
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
    fileprivate func loadFromIntialIndex() {
        selectedIndex = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            var cell:UITableViewCell?
            cell = self.tableViewSideNavBar.cellForRow(at: self.selectedIndex)
            guard let cellSelected = cell else { return }
            cellSelected.contentView.backgroundColor = Color.green.theam
        }
    }
    
}

extension MSSideNavigationVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if selectedIndex == indexPath
        {
//            let viewLine = UIView()
//            viewLine.frame = CGRect(x: 0, y: 0, width: 2, height: cell.frame.size.height)
//            viewLine.backgroundColor = UIColor.white
        
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17.0)
          
            //cell.addSubview(viewLine)
        }
        else
        {
            
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 17.0)
            cell.textLabel?.textColor = UIColor.init(hexString: "333333")
            
        }
        cell.textLabel?.text = arrSideMenu[indexPath.row].title
         cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = UIColor.clear
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
          if selectedIndex != indexPath {
        sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
       // self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
//        if indexPath.row == 2 {
//            let nextVC = ProductDetailVC.storyboardInstance!
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
        tableViewSideNavBar.reloadData()
        self.selectedRowIndex = indexPath.row
        let user = UserData.shared.getUser()
        if user?.user_type == "1" {
        if indexPath.row == 9 {
            logout()
        }else{
            sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
            self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
        }
        }else{
            if indexPath.row == 7 {
                logout()
            }else{
                sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
            }
    }
        }
        
    }
    
    func logout() {
        
        self.alert(title: "Alert", message: "Are you sure you want to logout from this application ?", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                print("Logout")//UserData.shared.deviceToken
                let param = ["user_id":UserData.shared.getUser()!.user_id, "device_id":UserData.shared.deviceToken]
                Modal.shared.logOut(vc: self, param: param) { (dic) in
                    print(dic)
                    UserData.shared.logoutUser()
                    Modal.sharedAppdelegate.sideMenuController.hideLeftView()
                    self.arrSideMenu = sideMenu.setTableData()
                    self.tableViewSideNavBar.reloadData()
                    //self.parent!.navigationController?.popToRootViewController(animated: false)
                    let user = UserData.shared.getUser()
                    if user != nil{
                        self.imgUserImage.downLoadImage(url: (UserData.shared.getUser()?.image)!)
                        self.lblUserName.text = UserData.shared.getUser()?.name
                    }else{
                        self.imgUserImage.image = #imageLiteral(resourceName: "myprofile-ico")
                        self.lblUserName.text = "Guest"
                    }
                }
                
            }
            else {
                //Do nothing
            }
        }
    }
    
    func getNextVC(index: Int) -> UIViewController? {
        let user = UserData.shared.getUser()
        switch index {
         
        case 0:
           return HomeVC.storyboardInstance!
        case 1:
           // if user?.user_type == "1"{
           return MembershipPlanListVC.storyboardInstance!
//            }else if user?.user_type == "2"{
//                return MerchantProfileVC.storyboardInstance!
//            }
        case 2:
             if user?.user_type == "1"{
            return ProfileVC.storyboardInstance!
             }else if user?.user_type == "2"{
                isFromSubCat = false
               return PostedBuisnessVC.storyboardInstance!
             }else{
              return LoginVC.storyboardInstance!
            }
        case 3:
            if user?.user_type == "1"{
                return FavouriteBusinessVC.storyboardInstance!
            }else if user?.user_type == "2"{
                return ReceivedReviewsListVC.storyboardInstance!
            }else{
                return LoginVC.storyboardInstance!
            }
            
        case 4:
            if user?.user_type == "1"{
            return InviteFriendVC.storyboardInstance!
            }else if user?.user_type
            == "2"{
                return PostedAdvertiseVC.storyboardInstance!
            }else{
                return LoginVC.storyboardInstance!
            }
//        case 5:
//            if user?.user_type == "1"{
//            return MembershipPlanListVC.storyboardInstance!
//            }else{
//                return MessagesVC.storyboardInstance!
//            }
        case 5:
            if user?.user_type == "1"{
            return PaymentHistoryVC.storyboardInstance!
            
            }else if user?.user_type == "2"{
                return ChangePasswordVC.storyboardInstance!
            }else{
                return LoginVC.storyboardInstance!
            }
        case 6:
             if user?.user_type == "1"{
           return NotificationVC.storyboardInstance!
            
             }else if user?.user_type == "2"{
                return ContactUsVC.storyboardInstance!
             }else{
                return LoginVC.storyboardInstance!
            }
        case 7:
            if user?.user_type == nil{
                
            Modal.sharedAppdelegate.sideMenuController.hideLeftView()
                   self.parent!.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
                return nil
            }else{
            return ChangePasswordVC.storyboardInstance!
            }
           
        case 8:
             return ContactUsVC.storyboardInstance!
//            case 9:
//            return ContactUsVC.storyboardInstance!
        default:
            return nil
        }
        
    }

}
extension MSSideNavigationVC {
    func setMenubarElemnts() {
        //vcArray = [st
                   //Logout, 12
        //]
    }
}
