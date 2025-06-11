//
//  EmailPreferenceVC.swift
//  Luxongo
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EmailPreferenceVC: BaseViewController {
    
    //MARK: Variables
    //   let menuNameList = ["Change password","Change email preference","Delete account",]
    
    //MARK: Properties
    static var storyboardInstance:EmailPreferenceVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: EmailPreferenceVC.identifier) as! EmailPreferenceVC)
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(EmailPrefTC.nib, forCellReuseIdentifier: EmailPrefTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var settingsList = [NotificationSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmailSettings()
    }
    
    
    func getEmailSettings(){
        
        let param = ["userid":UserData.shared.getUser()!.userid]
        
        API.shared.call(with: .getNotificationSettings, viewController: self, param: param) { (response) in
            self.settingsList = Response.fatchDataAsArray(res: response, valueOf: .data).map({NotificationSettings(dictionary: $0 as! [String:Any])})
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
}

extension EmailPreferenceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmailPrefTC.identifier) as? EmailPrefTC else {
            fatalError("Cell can't be dequeue")
        }
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        cell.lblTittle.text = settingsList[indexPath.row].noti_label
        if settingsList[indexPath.row].noti_flag == "n"
        {
            cell.btnSwitch.setOn(false, animated: false)
        }else{
            cell.btnSwitch.setOn(true, animated: false)
        }
        cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.addTarget(self, action: #selector(onClickSwitch), for: .valueChanged)
        return cell
    }
    
    @objc func onClickSwitch(_ sender:UISwitch){
        var param:[String:Any] = ["userid":UserData.shared.getUser()!.userid]
        
        if sender.isOn{
            param["ticket_sold"] = "y"
        }else{
            param["ticket_sold"] = "n"
        }
        
        
        API.shared.call(with: .changeNotificationSettings, viewController: self, param: param) { (response) in
            self.getEmailSettings()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
