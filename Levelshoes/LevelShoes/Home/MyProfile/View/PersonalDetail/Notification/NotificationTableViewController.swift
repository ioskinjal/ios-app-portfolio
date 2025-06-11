//
//  NotificationTableViewController.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MarketingCloudSDK
import SafariServices

class NotificationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 //   var notifications: [NotificationData] = []
    

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    @IBOutlet weak var btnEdit: UIButton!{
        didSet{
            btnEdit.setTitle("Edit".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var lblHeader: UILabel!{
        didSet {
            lblHeader.text = "accountNotifiation".localized.uppercased()
        }
    }
    
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = false
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var usesTallCells = false
    
    var inboxRefreshObserver: NSObjectProtocol?
    var newMessageObserver: NSObjectProtocol?
     var dataSourceArray = [[String:Any]]()
    
    @IBOutlet weak var noResultPlaceholder: UIView!
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView : UITableView!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
     tableView.allowsSelection = true
    tableView.allowsMultipleSelectionDuringEditing = true
        
        // tableView.rowHeight = UITableView.UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        view.layoutMargins.left = 32
        
        //   resetData()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
//        if newMessageObserver == nil {
//            newMessageObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.SFMCInboxMessagesNewInboxMessages, object: nil, queue: OperationQueue.main) {(_ note: Notification) -> Void in
//                self.refreshControl.endRefreshing()
//                self.reloadData()
//            }
//        }
        
        img.image = img.image?.withRenderingMode(.alwaysTemplate)
               img.tintColor = UIColor.black
        
    }
    
    @objc func update(_ sender: Any) {
        if MarketingCloudSDK.sharedInstance().sfmc_refreshMessages() == false {
            self.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(inboxRefreshObserver as Any)
        inboxRefreshObserver = nil
        
        NotificationCenter.default.removeObserver(newMessageObserver as Any)
        newMessageObserver = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        if inboxRefreshObserver == nil {
            inboxRefreshObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.SFMCInboxMessagesRefreshComplete, object: nil, queue: OperationQueue.main) {(_ note: Notification) -> Void in
                self.refreshControl.endRefreshing()
                self.reloadData()
            }
        }

        reloadData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        if MarketingCloudSDK.sharedInstance().sfmc_refreshMessages() == false {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh(_ sender: Any) {
           if MarketingCloudSDK.sharedInstance().sfmc_refreshMessages() == false {
               self.refreshControl.endRefreshing()
           }
       }
 
       func reloadData() {
           if let inboxArray = MarketingCloudSDK.sharedInstance().sfmc_getAllMessages() as? [[String : Any]] {
               dataSourceArray = inboxArray.sorted {
               
                   if $0["sendDateUtc"] == nil {
                       return true
                   }
                   if $1["sendDateUtc"] == nil {
                       return true
                   }

                   let s1 = $0["sendDateUtc"] as! Date
                   let s2 = $1["sendDateUtc"] as! Date
                   
                   return s1 < s2
               }
               tableView.reloadData()
            if MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount() != nil{
                let unreadCount = MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount()
                if unreadCount > 0 {
                    lblHeader.text = "accountNotifiation".localized.uppercased() + " (" + String(unreadCount) +  ")"
                }
                else{
                    lblHeader.text = "accountNotifiation".localized.uppercased() + ""
                }
                
                UserDefaults.standard.set(unreadCount, forKey: string.notificationItemCount)
                NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
            }

           
            
            if inboxArray.count == 0{
                          noResultPlaceholder.isHidden = false
                          tableView.isHidden = true
                      }
                      else{
                          noResultPlaceholder.isHidden = true
                          tableView.isHidden = false
                      }
           }
       }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return dataSourceArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailCell") as! NotificationCell
        cell.delegate = self
        
         let inboxMessage = dataSourceArray[indexPath.row]
        if (inboxMessage["subject"] != nil) {
            let subject = inboxMessage["subject"] as! String
            cell.bodyLabel.text = subject
            
            let arr = subject.components(separatedBy: " ")
            
            if arr.count >= 2{
                cell.fromLabel.text = arr[0] + " " + arr[1]
            }
            else{
                cell.fromLabel.text = arr[0]
            }
            
            
        }
        if (inboxMessage["sendDateUtc"] != nil) {
            let sendDateUtc = inboxMessage["sendDateUtc"] as! Date
            
            let formatter4 = DateFormatter()
            //formatter4.dateStyle = .short
            formatter4.dateFormat = "dd-MM-yyyy HH:mm"
            cell.dateLabel.text = formatter4.string(from: sendDateUtc)
        }
        
        if (inboxMessage["read"] as! Bool == true) {
            cell.backgroundColor = .white
            cell.unread = true
        }
        else {
            cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            cell.unread = false
        }
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let inboxMessage = dataSourceArray[indexPath.row]
        
    
        MarketingCloudSDK.sharedInstance().sfmc_trackMessageOpened(inboxMessage)
      
        let urlString = inboxMessage["url"] as! String
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            present(vc, animated: true)
        }
    }

    
    
    
    func visibleRect(for tableView: UITableView) -> CGRect? {
        if usesTallCells == false { return nil }
        
        if #available(iOS 11.0, *) {
            return tableView.safeAreaLayoutGuide.layoutFrame
        } else {
            let topInset = navigationController?.navigationBar.frame.height ?? 0
            let bottomInset = navigationController?.toolbar?.frame.height ?? 0
            let bounds = tableView.bounds
            
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + topInset, width: bounds.width, height: bounds.height - bottomInset)
        }
    }
    
    // MARK: - Actions
    @IBAction func backTapped(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
}
    
extension NotificationTableViewController: SwipeTableViewCellDelegate {
  
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
         let inboxMessage = self.dataSourceArray[indexPath.row]
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            MarketingCloudSDK.sharedInstance().sfmc_markMessageDeleted(inboxMessage)
            self.reloadData()
        }
        
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = UIColor.black
        deleteAction.font = BrandenFont.thin(with: 14.0)
        
        let readAction = SwipeAction(style: .default, title: "Mark as read") { action, indexPath in
            MarketingCloudSDK.sharedInstance().sfmc_markMessageRead(inboxMessage)
            self.reloadData()
        }
        
        readAction.image = UIImage(named: "read")
        readAction.backgroundColor = UIColor.white
        readAction.font = BrandenFont.thin(with: 14.0)
        readAction.textColor = UIColor.black
        
        if inboxMessage["read"] as! Bool == false{
             return [deleteAction,readAction]
        }
        else{
             return [deleteAction]
        }
    }
}

class NotificationCell: SwipeTableViewCell {
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                dateLabel.textAlignment = .right

            }
            else{
                dateLabel.textAlignment = .left
            }
        }
    }
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    

   var unread = false
}
