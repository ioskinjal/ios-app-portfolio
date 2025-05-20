//
//  NotificationVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class NotificationVC: BaseVC {
    
    @IBOutlet weak var notificationTableview: UITableView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNavTitle:UILabel!
    let notificationCellIdentifier  = "notificationCell"
    
    var notifications:NSMutableArray = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((notificationTableview) != nil) {
            let nib = UINib(nibName: "NotificationCell", bundle: nil)
            notificationTableview.register(nib, forCellReuseIdentifier: notificationCellIdentifier)
            
            notificationTableview.separatorStyle = UITableViewCellSeparatorStyle.none
            notificationTableview.rowHeight  = UITableViewAutomaticDimension
            notificationTableview.estimatedRowHeight = 120
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotifications(lastCount: 0)
        lblNavTitle.text = appConts.const.nOTIFICATION
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNotifications(lastCount:Int){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "lastCount":lastCount,
                 "totalRecords":20,
                 "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Notification.getNotification, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print("Items \(dataAns)")
                    
                    let newNotifications = Notifications.initWithResponse(array: (dataAns as! [Any]))
                    
                    if lastCount>0{
                        self.notifications.addObjects(from: newNotifications)
                    }
                    else{
                        self.notifications = (newNotifications as NSArray).mutableCopy() as! NSMutableArray
                    }
                    
                    DispatchQueue.main.async {
                        self.notificationTableview.reloadData()
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        if lastCount == 0 {
                            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        }
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    @IBAction func btnNotificationMenuClicked(_ sender: Any) {
        openMenu()
    }
    
    /*
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - Tableview DataSource

extension NotificationVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: notificationCellIdentifier, for: indexPath) as? NotificationCell
        
        if cell == nil {
            cell = NotificationCell(style: UITableViewCellStyle.default, reuseIdentifier: notificationCellIdentifier)
        }
        
        let notifiation = self.notifications[indexPath.row] as! Notifications
        cell?.displayData(notification: notifiation)
        
        return cell!
        
    }

}
// MARK: - Tableview Delegate

extension NotificationVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.notifications.count - 1){
            
            self.getNotifications(lastCount: self.notifications.count)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNotification = self.notifications.object(at: indexPath.row) as! Notifications
        
        let selectedRide = Rides()
        selectedRide.rideId = selectedNotification.rideId
        selectedRide.status = selectedNotification.status
        
        
        
        if selectedNotification.status.lowercased() == "w" {
            
            // Go To Ride Information Controller with Ride Id
            let rideInfoController = RideStartVC(nibName: "RideStartVC", bundle: nil)
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
            
        }
        else if selectedNotification.status.lowercased() == "s" {
            
//             Go To Ride Started Controller with Ride Id
            let rideInfoController = RideEndVC(nibName: "RideEndVC", bundle: nil)
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
            
        }
        else if selectedNotification.status.lowercased() == "c" {
            
            // Go To Ride Details(Completed) Controller with Ride Id
            let tripDetailsController = RideDetailsVC(nibName: "RideDetailsVC", bundle: nil)
            tripDetailsController.selecteRide = selectedRide
            self.navigationController?.pushViewController(tripDetailsController, animated: true)
            
        }
        else if selectedNotification.status.lowercased() == "r" {
            
            // Go To Ride Details(Rejected) Controller with Ride Id
            let tripDetailsController = RideDetailsVC(nibName: "RideDetailsVC", bundle: nil)
            tripDetailsController.selecteRide = selectedRide
            self.navigationController?.pushViewController(tripDetailsController, animated: true)
        }
        
    }
}


