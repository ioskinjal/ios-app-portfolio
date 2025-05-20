//
//  ServiceNotificationsVC.swift
//  ThumbPin
//
//  Created by NCT109 on 10/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ServiceNotificationsVC: BaseViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tblvwServiceNotification: UITableView!{
        didSet{
            tblvwServiceNotification.delegate = self
            tblvwServiceNotification.dataSource = self
            tblvwServiceNotification.register(ServiceNotificationsCell.nib, forCellReuseIdentifier: ServiceNotificationsCell.identifier)
            tblvwServiceNotification.rowHeight  = UITableViewAutomaticDimension
            tblvwServiceNotification.estimatedRowHeight = 310
            tblvwServiceNotification.tableFooterView = UIView()
        }
    }
    static var storyboardInstance:ServiceNotificationsVC? {
        return StoryBoard.serviceNotifications.instantiateViewController(withIdentifier: ServiceNotificationsVC.identifier) as? ServiceNotificationsVC
    }
    var pageNo = 1
    var serviceNotifications = ServiceNotifications()
    var arrServiceNotifi = [ServiceNotifications.ServiceNotificationList]()
    var deleteNotificationID = Int()
    var serviceId = ""
    var isPush = "0"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if isPush == "1" {
            let vc = RequestDetailVC.storyboardInstance!
            vc.serviceId = "\(serviceId)"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            if isPush == "0" {
                isPush = "0"
                pageNo = 1
                callApiServiceNotifications()
            }
            isPush = "0"
        }else {
            print("No! internet is available.")
            pageNo = 1
            let dict = retrieveFromJsonFile()
            self.arrServiceNotifi = ResponseKey.fatchData(res: dict, valueOf: .service_notification).ary.map({ServiceNotifications.ServiceNotificationList(dic: $0 as! [String:Any])})
            self.tblvwServiceNotification.reloadData()
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiServiceNotifications() {
        let dictParam = [
            "action": Action.getNotification,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getServiceNotifications(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.serviceNotifications = ServiceNotifications(dic: dict)
            if self.pageNo > 1 {
                self.arrServiceNotifi.append(contentsOf: self.serviceNotifications.arrServiceNotification)
            }else {
                self.arrServiceNotifi.removeAll()
                self.arrServiceNotifi = self.serviceNotifications.arrServiceNotification
            }
            if self.arrServiceNotifi.count == 0{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.tblvwServiceNotification.backgroundView = bgImage
            }
            self.tblvwServiceNotification.reloadData()
        }
    }
    func callApiDeleteServiceNotifications(_ serviceId: String,_ notificationId: String) {
        let dictParam = [
            "action": Action.deleteNotification,
            "lId": UserData.shared.getLanguage,
            "service_id": serviceId,
            "notification_id": notificationId,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getServiceNotifications(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.arrServiceNotifi.remove(at: self.deleteNotificationID)
            self.tblvwServiceNotification.reloadData()
        }
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Service Notifications")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func pressButtonDeleteNotification(_ sender: UIButton) {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: localizedString(key: "Are you sure you want to delete service?"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localizedString(key: "NO"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "YES"), style: .default, handler: { _ in
            self.deleteNotificationID = sender.tag
            self.callApiDeleteServiceNotifications(self.arrServiceNotifi[sender.tag].service_id, self.arrServiceNotifi[sender.tag].notification_id)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func tapToShowProfile(sender:UITapGestureRecognizer) {
        let point = sender.view
        let mainCell = point?.superview
        let main = mainCell?.superview
        let stack = main?.superview
        let stack1 = stack?.superview
        let cell: ServiceNotificationsCell = stack1 as! ServiceNotificationsCell
        let indexPath = tblvwServiceNotification.indexPath(for: cell)
        let index = indexPath?.row ?? 0
        print(index)
        let vc = ProfileVC.storyboardInstance!
        vc.userIdFromProvider = arrServiceNotifi[index].customer_id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ServiceNotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceNotificationsCell.identifier) as? ServiceNotificationsCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelServiceName.text = arrServiceNotifi[indexPath.row].service_name
        cell.labelCategory.text = "\(arrServiceNotifi[indexPath.row].service_category) > \(arrServiceNotifi[indexPath.row].service_sub_category)"
        cell.labelPostedBy.text = arrServiceNotifi[indexPath.row].customer_name
        cell.labeLocation.text = arrServiceNotifi[indexPath.row].service_location
        cell.labelEstBudget.text = arrServiceNotifi[indexPath.row].service_budget
        cell.labelServiceStatus.text = arrServiceNotifi[indexPath.row].service_status
        cell.labelPosted.text = arrServiceNotifi[indexPath.row].service_posted_time
        cell.btnDelete.tag = indexPath.row
        for i in 0..<arrServiceNotifi[indexPath.row].material.count{
            if cell.lblMaterialName.text == ""{
                cell.lblMaterialName.text = arrServiceNotifi[indexPath.row].material[i].material_name
            }else{
                cell.lblMaterialName.text = cell.lblMaterialName.text ?? "" + "," + arrServiceNotifi[indexPath.row].material[i].material_name
            }
        }
        cell.btnPDF.tag = indexPath.row
        cell.btnPDF.addTarget(self, action: #selector(onClickDownload(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.pressButtonDeleteNotification(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnQuote.setTitle(arrServiceNotifi[indexPath.row].quote_status, for: .normal)
        if arrServiceNotifi[indexPath.row].service_status == "Expired" {
            cell.btnQuote.isHidden = true
        }else {
            cell.btnQuote.isHidden = false
        }
        if arrServiceNotifi[indexPath.row].quote_status == "Send Quote" {
            cell.btnQuote.backgroundColor = Color.Custom.mainColor
        }else {
            cell.btnQuote.backgroundColor = Color.Custom.darkGrayColor
        }
        cell.tap = UITapGestureRecognizer(target: self, action: #selector(ServiceNotificationsVC.tapToShowProfile))
        cell.labelPostedBy.isUserInteractionEnabled = true
        cell.labelPostedBy.addGestureRecognizer(cell.tap)
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc func onClickDownload(_ sender:UIButton){
        DispatchQueue.main.async {
            let url = URL.init(fileURLWithPath: self.arrServiceNotifi[sender.tag].pdf_file)
            let pdfData = try? Data.init(contentsOf: url)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "Thumbpin.pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                self.alert(title: "", message: "pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
                self.alert(title: "", message: "Pdf could not be saved")
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrServiceNotifi.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestDetailVC.storyboardInstance!
        vc.serviceId = arrServiceNotifi[indexPath.row].service_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrServiceNotifi.count - 1
        let page = serviceNotifications.pagination.current_page
        let numPages = serviceNotifications.pagination.total_pages
        let totalRecords = serviceNotifications.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiServiceNotifications()
        }
    }
}
