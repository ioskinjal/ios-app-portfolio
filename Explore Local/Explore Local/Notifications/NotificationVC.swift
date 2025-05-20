//
//  NotificationVC.swift
//  Explore Local
//
//  Created by NCrypted on 15/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    static var storyboardInstance:NotificationVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: NotificationVC.identifier) as? NotificationVC
    }
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblNotification: UITableView!{
        didSet{
            tblNotification.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.identifier)
            tblNotification.dataSource = self
            tblNotification.delegate = self
            tblNotification.tableFooterView = UIView()
            tblNotification.separatorStyle = .singleLine
            tblNotification.border(side: .all, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    
    var notificationList = [NotificationCls.NotificationList]()
    var notificationObj: NotificationCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Notifications", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        notificationList = [NotificationCls.NotificationList]()
        notificationObj = nil
        callNotificationAPI()
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callNotificationAPI(){
        let nextPage = (notificationObj?.pagination?.current_page ?? 0 ) + 1
        print("nextPage: \(nextPage)")//UserData.shared.getUser()!.user_id
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "page": nextPage,
                     "action":"notifications"] as [String : Any]
        
        Modal.shared.getNotifications(vc: self, param: param) { (dic) in
            self.notificationObj = NotificationCls(dictionary: dic)
            if self.notificationList.count > 0{
                self.notificationList += self.notificationObj!.notificationList
            }
            else{
                self.notificationList = self.notificationObj!.notificationList
            }
            if self.notificationList.count != 0 {
            self.tblNotification.reloadData()
            }else{
                self.lblNoData.isHidden = false
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier) as? NotificationCell else {
            fatalError("Cell can't be dequeue")
        }
       cell.cellData = notificationList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return paymentHistoryList.count
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if notificationList.count - 1 == indexPath.row &&
            (notificationObj!.pagination!.current_page > notificationObj!.pagination!.total_pages) {
            self.callNotificationAPI()
        }
    }
    
    
}
