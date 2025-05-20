//
//  RidesVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RidesVC: BaseVC {
    
    @IBOutlet weak var ridesTableView: UITableView!
    @IBOutlet weak var lblTripType: UILabel!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var rideTypeTableView: UITableView!
    @IBOutlet weak var closeListBtn: UIButton!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var totalRecords: Int = 0
    public let cellIdentifier  = "MyTripCell"
    public let listCellIdentifier  = "listTypeCell"
    
    
    var rideList:NSMutableArray = []
    //FIXME:- acceptd conts change
    var rideType:NSMutableArray = [appConts.const.aLL,appConts.const.cOMPLETED,appConts.const.pENDING,appConts.const.wAITING,appConts.const.sTATED,appConts.const.rEJECTED,appConts.const.eXPIRED ,"Scheduled"]
    
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
        
        if ((ridesTableView) != nil) {
            let nib = UINib(nibName: "MyTripCell", bundle: nil)
            ridesTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
            
            ridesTableView.separatorStyle = UITableViewCellSeparatorStyle.none
           
           
            
        }
        
        if ((rideTypeTableView) != nil) {
            let nib = UINib(nibName: "ListCell", bundle: nil)
            rideTypeTableView.register(nib, forCellReuseIdentifier: listCellIdentifier)
            
            rideTypeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            rideTypeTableView.rowHeight  = 50
            rideTypeTableView.estimatedRowHeight = 50
            
        }
        
        closeListBtn.isExclusiveTouch = true
        
        lblTripType.text = appConts.const.aLL

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let rideStatus = lblTripType.text

        if rideStatus == appConts.const.aLL{
            getRidesList(rideType: "", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.cOMPLETED{
            getRidesList(rideType: "c", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.pENDING{
            getRidesList(rideType: "p", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.wAITING{
            getRidesList(rideType: "w", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.sTATED{
            getRidesList(rideType: "s", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.rEJECTED{
            getRidesList(rideType: "r", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.eXPIRED{
            getRidesList(rideType: "e", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.LBL_ACCEPTED{
            getRidesList(rideType: "a", title: rideStatus!,lastCount: 0)
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getRidesList(rideType:String,title:String,lastCount:Int){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "tripstatus":rideType,
                "lastCount":lastCount,
                "totalRecords":totalRecords,
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Trip.getTripList, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print("Items \(dataAns)")
                    
                    let rides = Rides.initWithResponse(array: (dataAns as! [Any]))
                    self.totalRecords = jsonDict?.value(forKey: "totalRecords") as! Int
                    if lastCount>0{
                        self.rideList.addObjects(from: rides)
                    }
                    else{
                        self.rideList = (rides as NSArray).mutableCopy() as! NSMutableArray
                    }
                    
                    DispatchQueue.main.async {
                        self.lblTripType.text = title
                        self.ridesTableView.reloadData()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        if lastCount == 0 {
                            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                            self.rideList = NSMutableArray()
                            self.ridesTableView.reloadData()
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
    
    
    @IBAction func btnRidesMenuClicked(_ sender: Any) {
        openMenu()
        
    }
    
    @IBAction func btnShowTripTypeClicked(_ sender: Any) {
        listView.isHidden = false
    }
    
    
    @IBAction func btnViewTripDetailsClicked(_sender: UIButton){
        
        
        let selectedRide:Rides = self.rideList.object(at: _sender.tag) as! Rides
        
        if selectedRide.status == "c"{
            
            // User Trip Details
            let tripDetailsController = RideDetailsVC(nibName: "RideDetailsVC", bundle: nil)
            tripDetailsController.selecteRide = selectedRide
            self.navigationController?.pushViewController(tripDetailsController, animated: true)
        }
        else if selectedRide.status == "w"{
            
            // User Ride Info
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let rideInfoController = storyBoard.instantiateViewController(withIdentifier: "RideInfoVC") as! RideInfoVC
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
            
            
        }
        else if selectedRide.status == "s"{
            
            // Go To Tracking Page
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let rideInfoController = storyBoard.instantiateViewController(withIdentifier: "RideInfoVC") as! RideInfoVC
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
            
        }
        else if selectedRide.status == "r"{
            
            // User Trip Details
            let tripDetailsController = RideDetailsVC(nibName: "RideDetailsVC", bundle: nil)
            tripDetailsController.selecteRide = selectedRide
            self.navigationController?.pushViewController(tripDetailsController, animated: true)
            
        }
        else if selectedRide .status == "a"{
            // User Ride Info
            
            
        }
    }
    @IBAction func btnClostListClicked(_ sender: Any) {
        
        listView.isHidden = true
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

extension RidesVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == ridesTableView {
            return rideList.count
        }
        else{
            return rideType.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == ridesTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyTripCell
            
            if cell == nil {
                cell = MyTripCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            }
            cell?.lblStatus.layer.cornerRadius = 20
            cell?.lblStatus.layer.masksToBounds = true
           
            let currentRide:Rides = self.rideList.object(at: indexPath.row) as! Rides
            var array:NSArray = currentRide.createdDateTimeFormatted.components(separatedBy: ",") as NSArray
            
            if currentRide.carName == ""{
                cell?.lblCarName.text = "N/A"
            }else{
            cell?.lblCarName.text = currentRide.carName
            }
            
            // Partener
            if currentRide.driverFirstName == "" &&  currentRide.driverLastName == "" {
                cell?.lblDriverName.text = "N/A"
            }else{
            cell?.lblDriverName.text = String(format: "%@ %@",currentRide.driverFirstName,currentRide.driverLastName)
            }
           // cell?.lblTripDate.text = currentRide.createdDateTime
            
            cell?.lblPickup.text = currentRide.pickUpLocation
            cell?.lblDrop.text = currentRide.dropOffLocation
            
            // Format 27 Oct , 2017 10:15
            
            cell?.lblTripDate.text = array[0] as? String
            cell?.lblTime.text = array[1] as? String
            if currentRide.typeName == "" {
                cell?.lblType.text = "N/A"
            }else{
            cell?.lblType.text = currentRide.typeName
            }
            
            
            if currentRide.status == "c"{
                
                cell?.lblStatus.text = "\(appConts.const.cOMPLETED)  "
                cell?.btnViewDetails.isHidden = false
                cell?.viewDetail.isHidden = false
                cell?.btnViewDetails.tag = indexPath.row
                cell?.btnViewDetails.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
                cell?.btnCancelRide.isHidden = true
            }
                
            else if currentRide.status == "p"{
                
                cell?.lblStatus.text = "\(appConts.const.pENDING)  "
                cell?.btnViewDetails.isHidden = true
                cell?.btnCancelRide.isHidden = true
                cell?.viewDetail.isHidden = true
            }
            else if currentRide.status == "w"{
                
                cell?.lblStatus.text = "\(appConts.const.wAITING)  "
                cell?.btnViewDetails.isHidden = false
                cell?.viewDetail.isHidden = false
                cell?.btnViewDetails.tag = indexPath.row
                cell?.btnViewDetails.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
                cell?.btnCancelRide.isHidden = true
            }
            else if currentRide.status == "s"{
                cell?.lblStatus.text = "\(appConts.const.sTATED)  "
                cell?.btnViewDetails.isHidden = false
                cell?.viewDetail.isHidden = false
                cell?.btnViewDetails.tag = indexPath.row
                cell?.btnViewDetails.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
                cell?.btnCancelRide.isHidden = true
                
            }
            else if currentRide.status == "r"{
                if currentRide.rejectedBy == "a"{
                    cell?.lblStatus.text = "\(appConts.const.eXPIRED)  "
                    cell?.btnViewDetails.isHidden = true
                    cell?.viewDetail.isHidden = true
                }
                else{
                    cell?.lblStatus.text = "\(appConts.const.rEJECTED)  "
                    cell?.btnViewDetails.isHidden = true
                    cell?.viewDetail.isHidden = true
                }
                
                //                if currentRide.rejectedBy == "a"{
                //                    cell?.lblRideStatus.text = "Rejected  "
                //                    cell?.rideDetailView.isHidden = false
                //                }
                //                else{
                //                    cell?.lblRideStatus.text = "Rejected  "
                //                    cell?.rideDetailView.isHidden = true
                //                }
                
                
            }
            else if currentRide.status == "e"{
                cell?.lblStatus.text = "\(appConts.const.eXPIRED)  "
                cell?.btnViewDetails.isHidden = true
                cell?.btnCancelRide.isHidden = true
                cell?.viewDetail.isHidden = true
                
            }
            else if currentRide.status == "a"{
                cell?.lblStatus.text = "\(appConts.const.LBL_ACCEPTED)  "
                cell?.btnViewDetails.isHidden = true
                cell?.btnCancelRide.isHidden = true
                cell?.viewDetail.isHidden = true
                
            }else if currentRide.status == "sc" {
                cell?.lblStatus.text = "Scheduled"
                cell?.btnViewDetails.isHidden = true
                cell?.viewDetail.isHidden = true
                if (currentRide.is_cancel_btn as NSString).boolValue == true{
                cell?.btnCancelRide.isHidden = true
                }else{
                  cell?.btnCancelRide.isHidden = false
                }
                
                cell?.btnCancelRide.tag = indexPath.row
                //array = currentRide.scheduledDatetime.components(separatedBy: ",") as NSArray
                
                cell?.btnCancelRide.addTarget(self, action: #selector(onClickCancelRide(_:)), for: .touchUpInside)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
               
                var date = dateFormatter.date(from: currentRide.scheduledDatetime)
                dateFormatter.dateFormat = "dd MMM, yyyy"
                cell?.lblTripDate.text = dateFormatter.string(from: date ?? Date())
                 dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
                date = dateFormatter.date(from: currentRide.scheduledDatetime)
               // dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "hh:mm a"
                cell?.lblTime.text = dateFormatter.string(from: date ?? Date())
               // cell?.lblTripDate.text = array[0] as? String
                //cell?.lblTime.text = array[1] as? String
            }else{
                cell?.lblStatus.text = ""
                cell?.btnViewDetails.isHidden = true
                cell?.btnCancelRide.isHidden = true
                cell?.btnCancelRide.isHidden = true
                cell?.viewDetail.isHidden = true
            }
            
            
            // -------------------------------------------------
            // Car SubType Image Download
            if !currentRide.subTypeImage.isEmpty {
                // Download image or fetch from cache.
                let cache = UIImageView.af_sharedImageDownloader.imageCache;
                let url = NSURL(string: URLConstants.Domains.SubCarUrl+currentRide.subTypeImage)!
                
                // Retrieve image from memory or disk.
                let req = URLRequest(url: url as URL)
                if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
                    // Image is set the second time imageForRequest is called.
                    
                    cell?.imgVehichle.image = cacheImage
                    
                    // print("image in cache!");
                } else {
                    
                    cell?.imgVehichle.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                        if response.data != nil {
                            let downloadedImage = UIImage.init(data: response.data!)
                            
                            if downloadedImage != nil{
                                cell?.imgVehichle.image = downloadedImage
                            }
                            else{
                                cell?.imgVehichle.image = #imageLiteral(resourceName: "Vehicle1")
                                
                            }
                            
                            
                            cell?.imgVehichle.contentMode = .scaleAspectFit
                          //  cell?.clipsToBounds = true
                            
                            
                        }
                        else{
                            // Default image if no data found
                            cell?.imgVehichle.image = #imageLiteral(resourceName: "Vehicle1")
                            
                        }
                    })
                    // Image is always nil the first time imageForRequest is called per app launch.
                    // (even if the image has been cached to disk from a previous launch).
                    // print("image somehow not in cache?");
                }
            }
            else{
                cell?.imgVehichle.image = #imageLiteral(resourceName: "Vehicle1")
            }
            
            return cell!
            
        }
        else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath) as? ListCell
            
            if cell == nil {
                cell = ListCell(style: UITableViewCellStyle.default, reuseIdentifier: listCellIdentifier)
            }
            
            let rideType:String = self.rideType.object(at: indexPath.row) as! String
            
            cell?.lblTitle.text = rideType
            
            
            let numberOfRows: Int = tableView.numberOfRows(inSection: 0)
            
            
            if indexPath.row == (numberOfRows-1) {
                cell?.layer.shadowOffset = CGSize(width: 1, height: 2)
                cell?.layer.shadowColor = UIColor.black.cgColor
                cell?.layer.shadowRadius = 3
                cell?.layer.shadowOpacity = 0.75
                let shadowFrame: CGRect = cell!.layer.bounds
                let shadowPath = (UIBezierPath(rect: shadowFrame).cgPath)
                cell?.layer.shadowPath = shadowPath
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == rideTypeTableView{
            
            let rideStatus:String = self.rideType.object(at: indexPath.row) as! String
            
            
            
            if rideStatus == appConts.const.aLL{
                getRidesList(rideType: "", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.cOMPLETED{
                getRidesList(rideType: "c", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.pENDING{
                getRidesList(rideType: "p", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.wAITING{
                getRidesList(rideType: "w", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.sTATED{
                getRidesList(rideType: "s", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.rEJECTED{
                getRidesList(rideType: "r", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.eXPIRED{
                getRidesList(rideType: "e", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.LBL_ACCEPTED{
                getRidesList(rideType: "a", title: rideStatus,lastCount: 0)
            }else if rideStatus == "Scheduled"{
                getRidesList(rideType: "sc", title: rideStatus,lastCount: 0)
            }
            
            listView.isHidden = true
            
        }
    }
    
    @objc func onClickCancelRide(_ sender:UIButton){
         let currentRide:Rides = self.rideList.object(at: sender.tag) as! Rides
        
        let param = ["userId":sharedAppDelegate().currentUser!.uId,
                     "tripId":currentRide.rideId]
        
        let alert = Alert()
        
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.cancelScheduledRide, parameters: param, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: "OK", completionBlock: {
                        
                        let rideStatus = self.lblTripType.text
                        
                        if rideStatus == appConts.const.aLL{
                            self.getRidesList(rideType: "", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.cOMPLETED{
                            self.getRidesList(rideType: "c", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.pENDING{
                            self.getRidesList(rideType: "p", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.wAITING{
                            self.getRidesList(rideType: "w", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.sTATED{
                            self.getRidesList(rideType: "s", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.rEJECTED{
                            self.self.getRidesList(rideType: "r", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.eXPIRED{
                            self.getRidesList(rideType: "e", title: rideStatus!,lastCount: 0)
                        }
                        else if rideStatus == appConts.const.LBL_ACCEPTED{
                            self.getRidesList(rideType: "a", title: rideStatus!,lastCount: 0)
                        }
                    })
                }
            }){ (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if tableView == rideTypeTableView{
        if indexPath.row == (self.rideList.count - 1){
            
            let rideStatus = lblTripType.text
            
            if rideStatus ==  appConts.const.aLL{
                getRidesList(rideType: "", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.cOMPLETED{
                getRidesList(rideType: "c", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.pENDING{
                getRidesList(rideType: "p", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.wAITING{
                getRidesList(rideType: "w", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.sTATED{
                getRidesList(rideType: "s", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.rEJECTED{
                getRidesList(rideType: "r", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.eXPIRED{
                getRidesList(rideType: "e", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.LBL_ACCEPTED{
                getRidesList(rideType: "a", title: rideStatus!,lastCount: self.rideList.count)
            }else if rideStatus == "Scheduled"{
                getRidesList(rideType: "sc", title: rideStatus!,lastCount: self.rideList.count)
            }
        }
        }
    }
    
}

