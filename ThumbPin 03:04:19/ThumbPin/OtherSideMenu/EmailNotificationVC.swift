//
//  EmailNotificationVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

struct EmailNotiDisp {
    var name = ""
    var value = ""
    var columnName = ""
}

import UIKit

class EmailNotificationVC: BaseViewController {

    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var tblvwEmailNotifications: UITableView!{
        didSet{
            tblvwEmailNotifications.delegate = self
            tblvwEmailNotifications.dataSource = self
            tblvwEmailNotifications.register(EmailNotificationCell.nib, forCellReuseIdentifier: EmailNotificationCell.identifier)
            tblvwEmailNotifications.rowHeight  = UITableViewAutomaticDimension
            tblvwEmailNotifications.estimatedRowHeight = 44
            tblvwEmailNotifications.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:EmailNotificationVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: EmailNotificationVC.identifier) as? EmailNotificationVC
    }
    var emailNotification = EmailNotification()
    var arrNotifi = [EmailNotiDisp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        callApiEmailNotification()
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Email Notifications")
    }
    func callApiEmailNotification() {
        let dictParam = [
            "action": Action.getEmailNotification,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.emailNotification(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.emailNotification = EmailNotification(dic: dict["data"] as? [String : Any] ?? [String : Any]())
            if UserData.shared.getUser()!.user_type == "1" {
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "New quote added"), value: self.emailNotification.NewQuoteAdded,columnName: "NewQuoteAdded"))
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Service request expired"), value: self.emailNotification.ServiceReqExpire,columnName: "ServiceReqExpire"))
            }else {
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "When Service Request is Posted"), value: self.emailNotification.NewServiceRequest,columnName: "NewServiceRequest"))
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Quote viewed"), value: self.emailNotification.QuoteViewed,columnName: "QuoteViewed"))
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Review and rating received"), value: self.emailNotification.ReviewAndRatingReceived,columnName: "ReviewAndRatingReceived"))
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Service request expired"), value: self.emailNotification.ServiceRequestExpired,columnName: "ServiceRequestExpired"))
                self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Hired for a service"), value: self.emailNotification.HiredForService,columnName: "HiredForService"))
              //  self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Receive builder message"), value: self.emailNotification.HiredForService,columnName: "HiredForService"))
                 self.arrNotifi.append(EmailNotiDisp(name: localizedString(key: "Pay Quote Ammount"), value: self.emailNotification.HiredForService,columnName: "HiredForService"))//remaining to add constants in email notification class
            }
            self.tblvwEmailNotifications.reloadData()
        }
    }
    func callApiSetEmailNotification(columnName: String,columnValue: String) {
        let dictParam = [
            "action": Action.setEmailNotification,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "column_name": columnName,
            "column_value": columnValue
        ] as [String : Any]
        ApiCaller.shared.emailNotification(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.tblvwEmailNotifications.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func pressButtonOnOFF(_ sender: UIButton) {
        if arrNotifi[sender.tag].value == "y" {
            arrNotifi[sender.tag].value = "n"
        }else {
            arrNotifi[sender.tag].value = "y"
        }
        callApiSetEmailNotification(columnName: arrNotifi[sender.tag].columnName, columnValue: arrNotifi[sender.tag].value)
        tblvwEmailNotifications.reloadData()
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EmailNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmailNotificationCell.identifier) as? EmailNotificationCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelNotificationName.text = arrNotifi[indexPath.row].name
        cell.btnSwitch.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
        if arrNotifi[indexPath.row].value == "y" {
            cell.btnSwitch.setImage(#imageLiteral(resourceName: "On"), for: .normal)
        }
        cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.addTarget(self, action: #selector(self.pressButtonOnOFF(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifi.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
