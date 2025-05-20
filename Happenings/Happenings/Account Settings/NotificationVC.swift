//
//  NotificationVC.swift
//  Happenings
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    static var storyboardInstance:NotificationVC? {
        return StoryBoard.accountsettings.instantiateViewController(withIdentifier: NotificationVC.identifier) as? NotificationVC
    }
    
    @IBOutlet weak var tblNotification: UITableView!{
        didSet{
            tblNotification.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.identifier)
            tblNotification.dataSource = self
            tblNotification.delegate = self
            tblNotification.tableFooterView = UIView()
            tblNotification.separatorStyle = .none
        }
    }
    
    var notificationList = [NotificationCls.Notifications]()
    var notificationObj: NotificationCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        callNotificationAPI()
    }
    
    func callNotificationAPI(){
        let nextPage = (notificationObj?.currentPage ?? 0 ) + 1
        let param = ["user_id":"212",
                     "action":"notification-list",
                     "page_no":nextPage] as [String : Any]

        
        Modal.shared.notification(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.tblNotification.backgroundView = bgImage
        }) { (dic) in
            self.notificationObj = NotificationCls(dictionary: dic)
            if self.notificationList.count > 0{
                self.notificationList += self.notificationObj!.notificationList
            }
            else{
                self.notificationList = self.notificationObj!.notificationList
            }
            if self.notificationList.count != 0{
                self.tblNotification.reloadData()
            }
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
//MARK: Custom function
extension NotificationVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Notifications", action: #selector(onClickMenu(_:)))
        
        
    }
   
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier) as? NotificationCell else {
            fatalError("Cell can't be dequeue")
        }
       cell.lblText.text = notificationList[indexPath.row].notify_string
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
            (notificationObj!.currentPage > notificationObj!.TotalPages) {
            self.callNotificationAPI()
        }
    }
}
