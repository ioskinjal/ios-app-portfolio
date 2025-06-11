//
//  AccountSettingVC.swift
//  Luxongo
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AccountSettingVC: BaseViewController {

    //MARK: Variables
    //"Change Language"
    let menuNameList = ["Change password","Change email preference","Delete account",]
    
    //MARK: Properties
    static var storyboardInstance:AccountSettingVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: AccountSettingVC.identifier) as! AccountSettingVC)
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(AccountSettingTC.nib, forCellReuseIdentifier: AccountSettingTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
}

extension AccountSettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingTC.identifier) as? AccountSettingTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblTittle.text = menuNameList[indexPath.row].localized
        cell.btnArrow.isHidden = (menuNameList.count - 1) == indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let nextVC = redirectToVC(index: indexPath){
            pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

}

//MARK: custom function
extension AccountSettingVC{
    
    func displayDeleteAlert() {
        UIApplication.alert(title: "Delete", message: "Are you sure you want to Delete the account?", actions: ["Cancel","Ok"], style: [.cancel,.destructive]) { (flag) in
            if flag == 1{ //Ok
                self.callDeleteAcc()
            }
        }
    }
    
}

//MARK:Custom fuction
extension AccountSettingVC{
    func redirectToVC(index: IndexPath) -> UIViewController? {
        switch index.row {
        case 0:
            return ChangePasswordVC.storyboardInstance
        case 1:
            return EmailPreferenceVC.storyboardInstance
        case 3:// Delete Account
            displayDeleteAlert()
            return nil
        default:
            return nil
        }
    }

    func callDeleteAcc() {
        let param:dictionary = ["userid": UserData.shared.getUser()!.userid,]
        API.shared.call(with: .deleteUserFromSite, viewController: self, param: param) { (response) in
            UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                UserData.shared.logoutUser()
                self.popToRootViewController(animated: true)
            })
        }
    }
    
}
