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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            self.imgProfile.setRadius()
            
        self.imgProfile.border(side: .all, color: UIColor.white, borderWidth: 2.0)
        }
    }
    var menuNames = [String]()
    var menuImages = [UIImage]()
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    var vcArray = [UIViewController]()
    
    override func viewDidLoad() {
        
        
       // setMenuBarElements()
    }
    
    
    fileprivate func loadFromIntialIndex() {
        selectedIndex = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            var cell:LeftMenuCell?
            cell = self.tableView.cellForRow(at: self.selectedIndex) as? LeftMenuCell
            guard let cellSelected = cell else { return }
            cellSelected.contentView.backgroundColor = Color.clear
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = UserData.shared.getUser()
        if user != nil {
            lblName.text = (UserData.shared.getUser()?.first_name)! + " " + (UserData.shared.getUser()?.last_name)!
            imgProfile.downLoadImage(url: (UserData.shared.getUser()?.user_image)!)
        }else{
            lblName.text = "Guest User"
        }
        super.viewWillAppear(animated)
        loadFromIntialIndex()
        setMenuBarElements()
    }
    
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
    
}

//MARK: Custom functions
extension LeftSideMenu{
    func setMenuBarElements() {
        let user = UserData.shared.getUser()
        if user != nil{
            menuNames = ["My Profile","Cuisine Type","My Orders","Address","Account Settings","Notifications","Information","Logout"]
            menuImages = [#imageLiteral(resourceName: "myprofile-ico"),#imageLiteral(resourceName: "cuisine-ico"),#imageLiteral(resourceName: "myorder-ico"),#imageLiteral(resourceName: "ic_home"),#imageLiteral(resourceName: "change-password-ico"),#imageLiteral(resourceName: "notification-ico"),#imageLiteral(resourceName: "info_white"),#imageLiteral(resourceName: "logout-ico")]
        }
    else{
            menuNames = ["Signin/ SignUp","Cuisine Type","Info"]
            menuImages = [#imageLiteral(resourceName: "myprofile-ico"),#imageLiteral(resourceName: "cuisine-ico"),#imageLiteral(resourceName: "info_white")]
    }
    tableView.reloadData()
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
            //cell.contentView.backgroundColor = Color.white
        }
        else{
           // cell.contentView.backgroundColor = Color.Black.theam
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        

            if indexPath.row == 7 {
                logout()
            }else{
                sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
                self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
            }
                //self.navigationController?.pushViewController(vcArray[indexPath.row], animated: true)
           // }
       
    }

    func logout() {
        
        self.alert(title: "Alert", message: "Are you sure you want to logout from this application ?", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                print("Logout")//UserData.shared.deviceToken
                let param = ["uid":UserData.shared.getUser()!.user_id, "token_id":UserData.shared.deviceToken]
                Modal.shared.logOut(vc: self, param: param) { (dic) in
                    print(dic)
                    UserData.shared.logoutUser()
                    UserDefaults.standard.set(nil, forKey: "isSocial")
                    UserDefaults.standard.synchronize()
                    Modal.sharedAppdelegate.sideMenuController.hideLeftView()
                    self.parent!.navigationController?.popToRootViewController(animated: true)
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
                if user != nil{
                return ProfileVC.storyboardInstance!
                }else{
                    isFromSideMenu = true
                    return LoginVC.storyboardInstance!
                }
            case 1:
                return MenuListVC.storyboardInstance!
            case 2:
                  if user != nil{
                return MyOrderVC.storyboardInstance!
                  }else{
                    return InfoVC.storyboardInstance!
                }
            case 3:
                return AddressListVC.storyboardInstance!
            case 4:
                return NotificationSettingVC.storyboardInstance!
            case 5:
                return NotificationVC.storyboardInstance!
            case 6:
                return InfoVC.storyboardInstance!
            default:
                return nil
            }
        
    }
}


