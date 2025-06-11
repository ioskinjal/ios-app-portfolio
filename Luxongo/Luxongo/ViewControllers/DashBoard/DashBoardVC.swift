//
//  DashBoardVC.swift
//  Luxongo
//
//  Created by admin on 6/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DashBoardVC: BaseViewController {
    
    //MARK: Variables
    let menuNameList = ["Manage Contacts",
                        "Manage Flyers",
                        "Saved Flyers",
                        "Purchased Tickets",
                        "Sold Tickets",
                        "Payment History",
                        "Following",
                        "Followers",
                        "My Organizers",
                        "My Tickets",
                        "Account Settings",
                        "Contact Us",
                        "About Us",
                        "Subscribe",
                        "Logout"]
    let menuIconList:[UIImage] = [#imageLiteral(resourceName: "db_contact"), #imageLiteral(resourceName: "manageEvent"),#imageLiteral(resourceName: "db_Events"), #imageLiteral(resourceName: "db_tickets"),#imageLiteral(resourceName: "soldTicket"), #imageLiteral(resourceName: "db_paymentHistory"),#imageLiteral(resourceName: "follower"),#imageLiteral(resourceName: "following"),#imageLiteral(resourceName: "myOrganiser"),#imageLiteral(resourceName: "myTicketsCopy"),#imageLiteral(resourceName: "db_account"),#imageLiteral(resourceName: "prEmail"), #imageLiteral(resourceName: "aboutUs"), #imageLiteral(resourceName: "subscribe"),#imageLiteral(resourceName: "db_logout")]
    
    //MARK: Properties
    static var storyboardInstance:DashBoardVC {
        return (StoryBoard.home.instantiateViewController(withIdentifier: DashBoardVC.identifier) as! DashBoardVC)
    }
    
    @IBOutlet weak var lblDashBoard: LabelBold!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(DashboardTC.nib, forCellReuseIdentifier: DashboardTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

extension DashBoardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTC.identifier) as? DashboardTC else {
            fatalError("Cell can't be dequeue")
        }
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        cell.btnIcon.setImage(menuIconList[indexPath.row], for: .normal)
        cell.lblTittle.text = menuNameList[indexPath.row].localized
        cell.btnArrow.isHidden = ( (menuNameList.count - 1) == indexPath.row || (menuNameList.count - 2) == indexPath.row )
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuIconList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let nextVC = redirectToVC(index: indexPath){
            pushViewController(nextVC, animated: true)
        }else if indexPath.row == 8{//Subscriber
            
        }else if indexPath.row == 10{//Logout
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if notificationList.count - 1 == indexPath.row &&
    //            (notificationObj!.pagination!.currentPage < notificationObj!.pagination!.total_pages) {
    //            self.callNotificationAPI()
    //        }
    //    }
    
}

//MARK: API methods
extension DashBoardVC{
    func callSendScbscription() {
        displaySubscriptionAlret { (email) in
            print("firstTxtValues: \(email)")
        }
    }
    
    func callLogout() {
        let param:dictionary = ["userid": UserData.shared.getUser()!.userid,
                                "device_id": UserData.shared.deviceToken,
        ]
        API.shared.call(with: .logoutUserFromSite, viewController: self, param: param) { (response) in
            UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                UserData.shared.logoutUser()
                self.popToRootViewController(animated: true)
            })
        }
    }
}

//MARK: Custom functions
extension DashBoardVC{
    func redirectToVC(index: IndexPath) -> UIViewController? {
        switch index.row {
        case 0:
            return ManageContactsVC.storyboardInstance
        case 1:
            return ManageEventsVC.storyboardInstance
        case 2:
            isFromMenu = true
            return MyEventsVC.storyboardInstance
        case 3:
            return PurchaseTicketVC.storyboardInstance
        case 4:
            return SoldTicketVC.storyboardInstance
        case 5:
            return PaymentHistoryVC.storyboardInstance
        case 6:
            return FollowingVC.storyboardInstance
        case 7:
            return FollowersVC.storyboardInstance
        case 8:
            return MyOrgenizersVC.storyboardInstance
        case 9:
            return MyTicketsVC.storyboardInstance
        case 10:
            return AccountSettingVC.storyboardInstance
        case 11:
            return ContactUsVC.storyboardInstance
        case 12://About Us
            return AboutUsVC.storyboardInstance
        case 13://Subscribe
            callSendScbscription()
            return nil
        case 14://Logout
            displayLogoutAlert()
            return nil
        default:
            return ManageContactsVC.storyboardInstance
        }
    }
    
    func displaySubscriptionAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Subscribe to newsletter".localized, message: "Enter your email for scbscription".localized, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add email".localized, style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if !(firstTextField.text ?? "").isBlank || firstTextField.text!.isValidEmailId {
                callback(firstTextField.text!)
            }
            else {
                UIApplication.alert(title: "Error", message: "Please enter valid email id")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "example@domail.com".localized
            textField.keyboardType = .emailAddress
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func displayLogoutAlert() {
        UIApplication.alert(title: "Logout".localized, message: "Are you sure you want to logout?".localized, actions: ["Cancel","Ok"], style: [.cancel,.destructive]) { (flag) in
            if flag == 1{ //Ok
                self.callLogout()
            }
        }
    }
}
