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
    @IBOutlet weak var navTitle:UILabel!
    public let cellIdentifier  = "rideCell"
    public let listCellIdentifier  = "listTypeCell"
    
    
    var rideList:NSMutableArray = []
    var rideType:NSMutableArray = [appConts.const.aLL,
                                   appConts.const.cOMPLETED,
                                   appConts.const.pENDING,
                                   appConts.const.wAITING,
                                   appConts.const.sTATED,
                                   appConts.const.rEJECTED,
                                   appConts.const.LBL_ACCEPTED]
    
    
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
            let nib = UINib(nibName: "RideCell", bundle: nil)
            ridesTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
            
           // ridesTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            ridesTableView.rowHeight  = UITableViewAutomaticDimension
            ridesTableView.estimatedRowHeight = 300
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
        navTitle.text = appConts.const.rIDE_INFO
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
        else if rideStatus == appConts.const.rEJECTED {
            getRidesList(rideType: "r", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.eXPIRED {
            getRidesList(rideType: "e", title: rideStatus!,lastCount: 0)
        }
        else if rideStatus == appConts.const.LBL_ACCEPTED {
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
                "driverId":sharedAppDelegate().currentUser!.uId,
                "tripstatus":rideType,
                "lastCount":lastCount,
                "totalRecords":20,
                "lId":Language.getLanguage().id
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
                            alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        }
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
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
            
            
            let rideInfoController = RideStartVC(nibName: "RideStartVC", bundle: nil)
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
            
        }
        else if selectedRide.status == "s"{
            
            // Go To Tracking Page
            let rideInfoController = RideEndVC(nibName: "RideEndVC", bundle: nil)
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
            let rideInfoController = RideStartVC(nibName: "RideStartVC", bundle: nil)
            rideInfoController.selecteRide = selectedRide
            self.navigationController?.pushViewController(rideInfoController, animated: true)
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
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RideCell
            
            if cell == nil {
                cell = RideCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            }
            
            let currentRide:Rides = self.rideList.object(at: indexPath.row) as! Rides
            
            // Partener
            cell?.lblParenterName.text = String(format: "%@ %@",currentRide.userFirstName,currentRide.userLastName)
            cell?.lblDate.text = currentRide.createdDateTime
            
            cell?.lblPickup.text = currentRide.pickUpLocation
            cell?.lblDropOff.text = currentRide.dropOffLocation
            
            // Format 27 Oct , 2017 10:15
            
            cell?.lblDate.text = RideUtilities.getDateStringFromString(date: currentRide.createdDateTime)
            cell?.lblCarName.text = "\(currentRide.brandName) \(currentRide.carName)"
            
            cell?.lblCarType.text = currentRide.typeName

            if currentRide.status == "c"{
                
                cell?.lblRideStatus.text = "\(appConts.const.cOMPLETED)  "
                cell?.rideDetailView.isHidden = false
                cell?.viewDetailsBtn.tag = indexPath.row
                cell?.viewDetailsBtn.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
            }
                
            else if currentRide.status == "p"{
                
                if currentRide.rejectedBy == "a"{
                    cell?.lblRideStatus.text = "\(appConts.const.eXPIRED)  "
                    cell?.rideDetailView.isHidden = true
                }
                else{
                    cell?.lblRideStatus.text = "\(appConts.const.pENDING)  "
                    cell?.rideDetailView.isHidden = false
                    cell?.viewDetailsBtn.tag = indexPath.row
                    cell?.viewDetailsBtn.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
                }
            }
            else if currentRide.status == "w"{
                
                cell?.lblRideStatus.text = "\(appConts.const.wAITING)  "
                cell?.rideDetailView.isHidden = false
                cell?.viewDetailsBtn.tag = indexPath.row
                cell?.viewDetailsBtn.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
            }
            else if currentRide.status == "s"{
                cell?.lblRideStatus.text = "\(appConts.const.sTATED)  "
                cell?.rideDetailView.isHidden = false
                cell?.viewDetailsBtn.tag = indexPath.row
                cell?.viewDetailsBtn.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
                
            }
            else if currentRide.status == "r"{
                if currentRide.rejectedBy == "a"{
                    cell?.lblRideStatus.text = "\(appConts.const.eXPIRED)  "
                    cell?.rideDetailView.isHidden = true
                }
                else{
                    cell?.lblRideStatus.text = "\(appConts.const.rEJECTED)  "
                    cell?.rideDetailView.isHidden = false
                    cell?.viewDetailsBtn.tag = indexPath.row
                    cell?.viewDetailsBtn.addTarget(self, action: #selector(btnViewTripDetailsClicked(_sender:)), for: UIControlEvents.touchUpInside)
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
                cell?.lblRideStatus.text = "\(appConts.const.eXPIRED)  "
                cell?.rideDetailView.isHidden = true
                
            }
            else if currentRide.status == "a"{
                cell?.lblRideStatus.text = "\(appConts.const.LBL_ACCEPTED)  "
                cell?.rideDetailView.isHidden = false
                
            }else{
                cell?.lblRideStatus.text = ""
                cell?.rideDetailView.isHidden = true
            }
            cell?.driveImgView.applyCorner(radius: (cell?.driveImgView.frame.size.width)!/2)
            cell?.driveImgView.clipsToBounds = true
            
            let profileImage = String(format:"%@%@",URLConstants.Domains.profileUrl,currentRide.driverProfileImage)

            
            // Driver Profile Image Download
            if !currentRide.driverProfileImage.isEmpty {
                // Download image or fetch from cache.
                let cache = UIImageView.af_sharedImageDownloader.imageCache;
                let url = NSURL(string: profileImage)!
                
                // Retrieve image from memory or disk.
                let req = URLRequest(url: url as URL)
                if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
                    // Image is set the second time imageForRequest is called.
                    
                    cell?.driveImgView.image = cacheImage
                    cell?.driverIndicator.stopAnimating()
                    //print("image in cache!");
                } else {
                    cell?.driverIndicator.startAnimating()
                    cell?.driveImgView.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                        if response.data != nil {
                            let downloadedImage = UIImage.init(data: response.data!)
                            
                            if downloadedImage != nil{
                                cell?.driveImgView.image = downloadedImage
                            }
                            else{
                                cell?.driveImgView.image = #imageLiteral(resourceName: "profile_placeholder")
                            }
                           
                            cell?.driverIndicator.stopAnimating()
                           
                        }
                        else{
                            // Default image if no data found
                            
                        }
                    })
                    // Image is always nil the first time imageForRequest is called per app launch.
                    // (even if the image has been cached to disk from a previous launch).
                    //print("image somehow not in cache?");
                }
            }
            else{
                cell?.driveImgView.image = #imageLiteral(resourceName: "profile_placeholder")
                cell?.driverIndicator.stopAnimating()
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
                    
                    cell?.carImgView.image = cacheImage
                    
                    // print("image in cache!");
                } else {
                    
                    cell?.carImgView.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                        if response.data != nil {
                            let downloadedImage = UIImage.init(data: response.data!)
                            
                            if downloadedImage != nil{
                                cell?.carImgView.image = downloadedImage
                            }
                            else{
                                cell?.carImgView.image = #imageLiteral(resourceName: "rides_icon")
                                
                            }
                            
                            
                            cell?.carImgView.contentMode = .scaleAspectFit
                            cell?.clipsToBounds = true
                            
                            
                        }
                        else{
                            // Default image if no data found
                            cell?.carImgView.image = nil
                            
                        }
                    })
                    // Image is always nil the first time imageForRequest is called per app launch.
                    // (even if the image has been cached to disk from a previous launch).
                    // print("image somehow not in cache?");
                }
            }
            else{
                cell?.carImgView.image = nil
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
            else if rideStatus == appConts.const.sTATED {
                getRidesList(rideType: "s", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.rEJECTED {
                getRidesList(rideType: "r", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.eXPIRED{
                getRidesList(rideType: "e", title: rideStatus,lastCount: 0)
            }
            else if rideStatus == appConts.const.LBL_ACCEPTED{
                getRidesList(rideType: "a", title: rideStatus,lastCount: 0)
            }
            
            listView.isHidden = true
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.rideList.count - 1){
            
            let rideStatus = lblTripType.text

            if rideStatus == appConts.const.aLL{
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
            else if rideStatus == appConts.const.sTATED {
                getRidesList(rideType: "s", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.rEJECTED {
                getRidesList(rideType: "r", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.eXPIRED{
                getRidesList(rideType: "e", title: rideStatus!,lastCount: self.rideList.count)
            }
            else if rideStatus == appConts.const.LBL_ACCEPTED{
                getRidesList(rideType: "a", title: rideStatus!,lastCount: self.rideList.count)
            }
        }
    }
    
}

