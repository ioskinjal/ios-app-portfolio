//
//  NotificationVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var tblvwNotification: UITableView!{
        didSet{
            tblvwNotification.delegate = self
            tblvwNotification.dataSource = self
            tblvwNotification.register(NotificationListCell.nib, forCellReuseIdentifier: NotificationListCell.identifier)
            tblvwNotification.rowHeight  = UITableViewAutomaticDimension
            tblvwNotification.estimatedRowHeight = 70
            tblvwNotification.separatorStyle = .none
        }
    }
    
    static var storyboardInstance:NotificationVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: NotificationVC.identifier) as? NotificationVC
    }
    var pageNo = 1
    var notificationList = NotificationList()
    var arrNotifications = [NotificationList.NotificationList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        notificationList = NotificationList()
        arrNotifications = [NotificationList.NotificationList]()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        pageNo = 1
        if isConnectedToInternet {
            pageNo = 1
            callApiNotification()
        }else {
            print("No! internet is available.")
            pageNo = 1
            let dict = retrieveFromJsonFile()
            self.arrNotifications = ResponseKey.fatchData(res: dict, valueOf: .site_notification).ary.map({NotificationList.NotificationList(dic: $0 as! [String:Any])})
            self.tblvwNotification.reloadData()
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func callApiNotification() {
        let dictParam = [
            "action": Action.getNotificationList,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
            "keyword": ""
            ] as [String : Any]
        ApiCaller.shared.notificationList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.notificationList = NotificationList(dic: dict)
            print(self.notificationList.arrNotificationList)
            if self.pageNo > 1 {
                self.arrNotifications.append(contentsOf: self.notificationList.arrNotificationList)
            }else {
                self.arrNotifications.removeAll()
                self.arrNotifications = self.notificationList.arrNotificationList
            }
            if self.arrNotifications.count == 0{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.tblvwNotification.backgroundView = bgImage
            }
            self.tblvwNotification.reloadData()
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Notifications")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(EmailNotificationVC.storyboardInstance!, animated: true)
    }
}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListCell.identifier) as? NotificationListCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelNotification.text = arrNotifications[indexPath.row].notification
        cell.labelDate.text = arrNotifications[indexPath.row].createdDate
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifications.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrNotifications[indexPath.row].type == "m" {
            isFromMessages = true
            let nextVC = ChatVC.storyboardInstance!
            nextVC.provider_id = arrNotifications[indexPath.row].providerId
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else if arrNotifications[indexPath.row].type == "s" {
            let vc = RequestDetailVC.storyboardInstance!
            vc.serviceId = arrNotifications[indexPath.row].serviceId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if arrNotifications[indexPath.row].type == "r" {
            isFromMessages = false
            let nextVC = ChatVC.storyboardInstance!
            nextVC.provider_id = arrNotifications[indexPath.row].providerId
            nextVC.customerId = arrNotifications[indexPath.row].customerId
            nextVC.serviceID = Int(arrNotifications[indexPath.row].serviceId) ?? 0
            nextVC.quotesId = arrNotifications[indexPath.row].quoteId
            //nextVC.quotesId = arrNotifications[indexPath.row].quoteId
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if arrNotifications[indexPath.row].type == "pm" {
            isFromMessages = true
            let nextVC = ChatVC.storyboardInstance!
            nextVC.provider_id = arrNotifications[indexPath.row].senderId
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrNotifications.count - 1
        let page = notificationList.pagination.current_page
        let numPages = notificationList.pagination.total_pages
        let totalRecords = notificationList.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiNotification()
        }
    }
}
