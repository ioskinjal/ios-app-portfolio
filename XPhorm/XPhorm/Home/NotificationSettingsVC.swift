//
//  NotificationSettingsVC.swift
//  XPhorm
//
//  Created by admin on 6/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NotificationSettingsVC: BaseViewController {

    static var storyboardInstance:NotificationSettingsVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: NotificationSettingsVC.identifier) as? NotificationSettingsVC
    }
    
   
    @IBOutlet weak var tblTrainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblCustomerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnNotificationTrainer: UIButton!
    @IBOutlet weak var btnNotificationCustomer: UIButton!
    @IBOutlet weak var tblNotificationtrainer: UITableView!{
        didSet{
            
            tblNotificationtrainer.register(NotificationSetingCell.nib, forCellReuseIdentifier: NotificationSetingCell.identifier)
            tblNotificationtrainer.dataSource = self
            tblNotificationtrainer.delegate = self
            tblNotificationtrainer.tableFooterView = UIView()
            tblNotificationtrainer.setRadius(10.0)
            tblNotificationtrainer.separatorStyle = .none
            
        }
    }
    @IBOutlet weak var tblNotificationCustomer: UITableView!{
        didSet{
            
            tblNotificationCustomer.register(NotificationSetingCell.nib, forCellReuseIdentifier: NotificationSetingCell.identifier)
            tblNotificationCustomer.dataSource = self
            tblNotificationCustomer.delegate = self
            tblNotificationCustomer.tableFooterView = UIView()
            tblNotificationCustomer.setRadius(10.0)
            tblNotificationCustomer.separatorStyle = .none
            
        }
    }
    
    var typeList = [NotificationTypeList]()
    var trainerList = [NotificationTypeList]()
    var customerList = [NotificationTypeList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Notifications Settings".localized, action: #selector(onClickBack(_:)))
        getNotificationType()
        onClickCustomer(btnNotificationCustomer)
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNotificationType(){
        let param = ["action":"getNotificationTypes",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.notificationType(vc: self, param: param) { (dic) in
            self.typeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({NotificationTypeList(dic: $0 as! [String:Any])})
            self.tblNotificationtrainer.reloadData()
            self.trainerList = [NotificationTypeList]()
            self.customerList = [NotificationTypeList]()
            for i in self.typeList{
                if i.userType == "u"{
                    self.customerList.append(i)
                }else{
                    self.trainerList.append(i)
                }
            }
            
            self.tblNotificationtrainer.reloadData()
            self.tblNotificationCustomer.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblTrainerHeightConst.constant = self.tblNotificationtrainer.contentSize.height
            self.tblCustomerHeightConst.constant = self.tblNotificationCustomer.contentSize.height
            }
            
        }
    }
    
    @IBAction func onClickTrainer(_ sender: UIButton) {
        if tblNotificationtrainer.isHidden{
            tblNotificationtrainer.isHidden = false
        }else{
            tblNotificationtrainer.isHidden = true
        }
    }
    @IBAction func onClickCustomer(_ sender: UIButton) {
        if tblNotificationCustomer.isHidden{
            tblNotificationCustomer.isHidden = false
        }else{
            tblNotificationCustomer.isHidden = true
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

extension NotificationSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblNotificationCustomer{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSetingCell.identifier) as? NotificationSetingCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblText.text = customerList[indexPath.row].notiTitle
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
        if customerList[indexPath.row].isEnabled == "true"{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "checkedCon"), for: .normal)
        }else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "radioButton"), for: .normal)
        }
            cell.selectionStyle = .none
            cell.lblDate.isHidden = true
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSetingCell.identifier) as? NotificationSetingCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.lblText.text = trainerList[indexPath.row].notiTitle
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(onClickCheck1(_:)), for: .touchUpInside)
            if trainerList[indexPath.row].isEnabled == "true"{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "checkedCon"), for: .normal)
            }else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "radioButton"), for: .normal)
            }
            
            cell.selectionStyle = .none
            cell.lblDate.isHidden = true
            return cell
        }
        
    }
    
    @objc func onClickCheck(_ sender:UIButton){
        let param = ["action":"submitNotificationSettings",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "notiId":customerList[sender.tag].id]
        
        Modal.shared.notificationType(vc: self, param: param) { (dic) in
            self.getNotificationType()
        }
    }
    
    @objc func onClickCheck1(_ sender:UIButton){
        let param = ["action":"submitNotificationSettings",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "notiId":trainerList[sender.tag].id]
        
        Modal.shared.notificationType(vc: self, param: param) { (dic) in
            self.getNotificationType()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblNotificationCustomer{
         return customerList.count
        }else{
        return trainerList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblTrainerHeightConst.constant = self.tblNotificationtrainer.contentSize.height
            self.tblCustomerHeightConst.constant = self.tblNotificationCustomer.contentSize.height
        }
    }
    
}
