//
//  NotificationVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 13/09/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    static var storyboardInstance:NotificationVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: NotificationVC.identifier) as? NotificationVC
    }
    
    @IBOutlet weak var tblNotification: UITableView!{
        didSet{
            tblNotification.register(NotificationListCell.nib, forCellReuseIdentifier: NotificationListCell.identifier)
            tblNotification.dataSource = self
            tblNotification.delegate = self
            tblNotification.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    var notificationList = [NotificationCls.NotificationList]()
    var notificationObj: NotificationCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Notifications", action: #selector(onClickMenu(_:)))
        navigationBar.viewCart.isHidden = true
        // Do any additional setup after loading the view.
        callNotificationAPI()
    }

    @objc func onclickSettings(_ sender:UIButton){
        let nextVC = NotificationSettingVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func callNotificationAPI(){
        let nextPage = (notificationObj?.pagination?.current_page ?? 0 ) + 1
        print("nextPage: \(nextPage)")//UserData.shared.getUser()!.user_id
        let param = ["uid":UserData.shared.getUser()!.user_id,
                     "page": nextPage] as [String : Any]
        Modal.shared.getNotification(vc: self, param: param) { (dic) in
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListCell.identifier) as? NotificationListCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

