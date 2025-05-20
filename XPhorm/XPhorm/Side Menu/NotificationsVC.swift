//
//  NotificationsVC.swift
//  XPhorm
//
//  Created by admin on 6/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NotificationsVC: BaseViewController {

    static var storyboardInstance:NotificationsVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: NotificationsVC.identifier) as? NotificationsVC
    }
     
    
    @IBOutlet weak var tblNotificationHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblNotification: UITableView!{
        didSet{
            tblNotification.register(NotificationSetingCell.nib, forCellReuseIdentifier: NotificationSetingCell.identifier)
            tblNotification.dataSource = self
            tblNotification.delegate = self
            tblNotification.separatorStyle = .none
            
        }
    }
    
    var notificationList = [NotificationCls.NotificationList]()
    var notificationObj: NotificationCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationBar.lblTitle.text = "Notifications".localized
        
        getNotifications()
        
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
    
    
    func getNotifications(){
        let nextPage = (notificationObj?.pagination?.page ?? 0 ) + 1
        
        let param = ["action":"getNotifications",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getNotifications(vc: self, param: param) { (dic) in
            self.notificationObj = NotificationCls(dictionary: dic)
            if self.notificationList.count > 0{
                self.notificationList += self.notificationObj!.notificationList
            }
            else{
                self.notificationList = self.notificationObj!.notificationList
            }
            self.tblNotification.reloadData()
        }
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSetingCell.identifier) as? NotificationSetingCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblDate.text = notificationList[indexPath.row].time_ago
        cell.lblText.text = notificationList[indexPath.row].notification
        cell.lblDate.isHidden = false
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if notificationList.count - 1 == indexPath.row &&
            (Int(notificationObj!.pagination!.page) < notificationObj!.pagination!.numPages) {
            self.getNotifications()
        }
    }
    
    
}
