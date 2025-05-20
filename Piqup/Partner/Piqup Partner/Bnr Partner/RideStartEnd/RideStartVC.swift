//
//  RideStartedVC.swift
//  BooknRide
//
//  Created by KASP on 29/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import Messages
import MessageUI
import AlamofireImage

class RideStartVC: BaseVC,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var tripMapView: GMSMapView!
    @IBOutlet weak var imgVehicle: UIImageView!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblRideTime: UILabel!
    
    //@IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var lbluserName: UILabel!
  
    @IBOutlet weak var lblUserNo: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStart:UIButton!
   // @IBOutlet weak var btnCancelRide:UIButton!
    //@IBOutlet weak var lblCall:UILabel!
   // @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var lblNavConst: UILabel!
    
    @IBOutlet weak var lblRecContact: UILabel!
    @IBOutlet weak var lblRecEmail: UILabel!
    @IBOutlet weak var lblRecName: UILabel!
    @IBOutlet weak var lblSenderContact: UILabel!
    @IBOutlet weak var lblSenderEmail: UILabel!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var lblReqContact: UILabel!
    @IBOutlet weak var lblReqEmail: UILabel!
    @IBOutlet weak var lblReqName: UILabel!
    @IBOutlet weak var viewReqName: UIView!{
        didSet{
            viewReqName.layer.borderColor = UIColor.lightGray.cgColor
            viewReqName.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewreqContact: UIView!{
        didSet{
            viewreqContact.layer.borderColor = UIColor.lightGray.cgColor
            viewreqContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewReqEmail: UIView!{
        didSet{
            viewReqEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewReqEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewSenderName: UIView!{
        didSet{
            viewSenderName.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderName.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewsenderContact: UIView!{
        didSet{
            viewsenderContact.layer.borderColor = UIColor.lightGray.cgColor
            viewsenderContact.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var viewtimer: UIView!{
        didSet{
            viewtimer.layer.borderColor = UIColor.lightGray.cgColor
            viewtimer.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewrecContact: UIView!{
        didSet{
            viewrecContact.layer.borderColor = UIColor.lightGray.cgColor
            viewrecContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewRecEmail: UIView!{
        didSet{
            viewRecEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewRecEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewrecName: UIView!{
        didSet{
            viewrecName.layer.borderColor = UIColor.lightGray.cgColor
            viewrecName.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewSenderEmail: UIView!{
        didSet{
            viewSenderEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderEmail.layer.borderWidth = 1.0
        }
    }
    var selecteRide:Rides?
    var rideTripDetail = RideTripDetails()
    var startRideTimeStamp = ""
    var dataAns = NSMutableDictionary()
    var rideStartTimer:Timer?
    
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
         getRideTimeStamp()
        getUserRideInfo()
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func getRideTimeStamp(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "rideId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.getStartRideTimestamp, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    self.dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print("Items \(self.dataAns)")
                    
                    let now = Date()
                    
                    let formatter = DateFormatter()
                    
                  //  formatter.timeZone = TimeZone.current
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:m:ss"
                    
                    self.startRideTimeStamp = self.dataAns.object(forKey: "startRideTimeStamp") as! String
                    if self.startRideTimeStamp == "" {
                        self.startRideTimeStamp = formatter.string(from: now)
                    }
                    self.lblPickupLocation.text = self.dataAns.object(forKey: "pickUpLocation")as? String
                    
                    self.lblRecName.text = self.dataAns.object(forKey: "recipientName") as? String
                    if self.lblRecName.text == "" {
                        self.lblRecName.text = "N/A"
                    }
                    self.lblRecEmail.text = self.dataAns.object(forKey: "recipientEmail") as? String
                    if self.lblRecEmail.text == "" {
                        self.lblRecEmail.text = "N/A"
                    }
                    
                    self.lblRecContact.text = self.dataAns.object(forKey: "recipientPhone") as? String
                    if self.lblRecContact.text == "" {
                        self.lblRecContact.text = "N/A"
                    }
                    
                    self.lblSenderName.text = self.dataAns.object(forKey: "senderName") as? String
                    if self.lblSenderName.text == "" {
                        self.lblSenderName.text = "N/A"
                    }
                    
                    self.lblSenderEmail.text = self.dataAns.object(forKey: "senderEmail") as? String
                    if self.lblSenderEmail.text == "" {
                        self.lblSenderEmail.text = "N/A"
                    }
                    
                    self.lblSenderContact.text = self.dataAns.object(forKey: "senderPhone") as? String
                    if self.lblSenderContact.text == "" {
                        self.lblSenderContact.text = "N/A"
                    }
                    
                    
                 //   self.lblRideName.text = self.dataAns.object(forKey: "carName")as? String
                    
                   // self.lblSubType.text = self.dataAns.object(forKey: "brandName")as? String
                    
                    let subTypeImg:String = (self.self.dataAns.object(forKey: "subTypeImage")as? String)!
                    
                    if subTypeImg == "" {
                        
                        let cache = UIImageView.af_sharedImageDownloader.imageCache;
                        let url = NSURL(string: URLConstants.Domains.SubCarUrl+subTypeImg)!
                        
                        // Retrieve image from memory or disk.
                        let req = URLRequest(url: url as URL)
                        if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
                            // Image is set the second time imageForRequest is called.
                            
                            self.imgVehicle.image = cacheImage
                            
                            // print("image in cache!");
                        } else {
                            
                            self.imgVehicle.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                                if response.data != nil {
                                    let downloadedImage = UIImage.init(data: response.data!)
                                    
                                    if downloadedImage != nil{
                                        self.imgVehicle.image = downloadedImage
                                    }
                                    else{
                                        self.imgVehicle.image = #imageLiteral(resourceName: "Vehicle1")
                                        
                                    }
                                    
                                    
                                    self.imgVehicle.contentMode = .scaleAspectFit
                                    //  cell?.clipsToBounds = true
                                    
                                    
                                }
                                else{
                                    // Default image if no data found
                                    self.imgVehicle.image = #imageLiteral(resourceName: "Vehicle1")
                                    
                                }
                            })
                            // Image is always nil the first time imageForRequest is called per app launch.
                            // (even if the image has been cached to disk from a previous launch).
                            // print("image somehow not in cache?");
                        }
                    }
                    else{
                        self.imgVehicle.image = #imageLiteral(resourceName: "Vehicle1")
                    }
                    
                    
                    self.startRideTimer()
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
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
    
    
    
    func startRideTimer(){
        
        if ((rideStartTimer) != nil){
            rideStartTimer?.invalidate()
            rideStartTimer = nil
        }
        rideStartTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRideTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(rideStartTimer!, forMode: RunLoopMode.commonModes)
        
    }
    
    @objc func updateRideTimer(){
        
        //        let startDateString = RideUtilities.UTCToLocal(date: self.startRideTimeStamp, fromFormat: "yyyy-MM-dd HH:m:ss", toFormat: "yyyy-MM-dd HH:m:ss")
        let startDate  = RideUtilities.getDateFromString(format: "yyyy-MM-dd HH:m:ss", date: self.startRideTimeStamp)
        
        let enddateString = RideUtilities.getStringFromDate(format: "yyyy-MM-dd HH:m:ss", date: Date())
        //let endUTC = RideUtilities.UTCToLocal(date: enddateString, fromFormat: "yyyy-MM-dd h:m:ss a", toFormat: "yyyy-MM-dd h:m:ss a")
        
        let enddate  = RideUtilities.getDateFromString(format: "yyyy-MM-dd HH:m:ss", date: enddateString)
        
        
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
        
        let string = formatter.string(from: startDate, to: enddate)
        
        
        let interval:TimeInterval = enddate.timeIntervalSince(startDate)
        let display = stringFromTimeInterval(interval: interval)
        
        DispatchQueue.main.async {
            self.lblRideTime.text = display as String
            
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        var minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        minutes = minutes + (hours*60)
        
        return NSString(format: "%0.2d:%0.2d",minutes,seconds)
    }
    func getUserRideInfo(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "driverId":sharedAppDelegate().currentUser!.uId,
                "tripId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Trip.getUserTripDetails, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print("Items \(dataAns)")
                    
                    self.rideTripDetail = RideTripDetails.initWithResponse(dictionary: dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        
                        self.display(tripdetails: self.rideTripDetail)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                    
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
    
    func display(tripdetails:RideTripDetails){
        
        lblPickupLocation.text = tripdetails.pickUpLocation
        lblDropOffLocation.text = tripdetails.dropOffLocation
        
        // Mapping markers
        let pickUpMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(tripdetails.pickUpLat)!, Double(tripdetails.pickUpLong)!))
        pickUpMarker.title = tripdetails.pickUpLocation
        pickUpMarker.icon =  #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.map = tripMapView
        
        let dropMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(tripdetails.dropOffLat)!, Double(tripdetails.dropOffLong)!))
        dropMarker.title = tripdetails.dropOffLocation
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.map = tripMapView
        
        let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate: dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 20, left: 40, bottom: 20, right: 40))
        self.tripMapView.animate(with: cameraPosition)
        
        lblRideTime.text = String(format: "Ride Time %@",tripdetails.rideDateTime)
        
          // Driver Information
        lbluserName.text = "\(tripdetails.userFirstName) \(tripdetails.userlastName)"
        lblUserNo.text = tripdetails.userMobileNo
    
        
        if tripdetails.userProfileImage.isEmpty{
           // self.userProfileImgView.image = #imageLiteral(resourceName: "profile_placeholder")
        }
        else{
            let userProfileImage:String = URLConstants.Domains.profileUrl+tripdetails.driverProfileImage
            //self.userProfileImgView.af_setImage(withURL: URL(string: userProfileImage)!)

        }
        
//        self.userProfileImgView.applyCorner(radius: (self.userProfileImgView.frame.size.width)/2)
//        self.userProfileImgView.clipsToBounds = true
        
        // Assigned new pickup and dropoff location in case of Push Notification.
        self.selecteRide?.pickUpLat = tripdetails.pickUpLat
        self.selecteRide?.pickUpLong = tripdetails.pickUpLong
        self.selecteRide?.pickUpLocation = tripdetails.pickUpLocation
        
        self.selecteRide?.dropOffLat = tripdetails.dropOffLat
        self.selecteRide?.dropOffLong = tripdetails.dropOffLong
        self.selecteRide?.dropOffLocation = tripdetails.dropOffLocation
        
    }
    
    
    func startRide(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "startRideTimeStamp":RideUtilities.getStringFromDate(format: "yyyy-MM-dd H:m:s", date: Date.init()),
                "rideId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.startRide, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        // Go To Map RideEndVC
                        UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isRideAccepted)
                        UserDefaults.standard.synchronize()
                        let rideVC = RideEndVC(nibName: "RideEndVC", bundle: nil)
                        rideVC.selecteRide = self.selecteRide
                        self.navigationController?.pushViewController(rideVC, animated: true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
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
    
    func cancelRide(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser?.uId ?? "",
                "userType":"d",
                "rideId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.cancelRide, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        // Go To Map RideEndVC
                        UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isRideAccepted)
                        UserDefaults.standard.synchronize()
                        self.navigationController?.popToRootViewController(animated: true)
                        
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnCallClicked(_ sender: Any) {
    
        //   RideUtilities.makeCall(number: self.rideTripDetail.userMobileNo)
       
            let url = NSURL(string: "tel://\(self.rideTripDetail.userMobileNo)")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url! as URL)
            } else {
                UIApplication.shared.openURL(url! as URL)
            }
    
        
    }
    @IBAction func btnMessageClicked(_ sender: Any) {
        
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = [self.rideTripDetail.userMobileNo]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = ""
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
            let alert = Alert()
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_NOT_AVAILABLE, buttonTitleStr: appConts.const.bTN_OK)
        }
        
    }
    
    @IBAction func btnDirectionClicked(_ sender: Any) {
        // For Google map app
//        let directionString = String(format: "comgooglemaps://?saddr=%@,%@&daddr=%@,%@&directionsmode=driving",rideTripDetail.pickUpLat,rideTripDetail.pickUpLong,rideTripDetail.dropOffLat,rideTripDetail.dropOffLong)
        
        // For Google directions via safari
        let directionString = String(format: "https://maps.google.com/maps?saddr=%@,%@&daddr=%@,%@&mode=transit",rideTripDetail.pickUpLat,rideTripDetail.pickUpLong,rideTripDetail.dropOffLat,rideTripDetail.dropOffLong)

        
        let url:URL = URL(string: directionString)!
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    @IBAction func btnStartRideClicked(_ sender: Any) {
//        let rideVC = RideEndVC(nibName: "RideEndVC", bundle: nil)
//        self.navigationController?.pushViewController(rideVC, animated: true)
        startRide()
    }
    
    @IBAction func btnCancelRideClicked(_ sender: Any) {
        
        let alert = Alert()
        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: appConts.const.mSG_RIDE_DENY, leftButtonTitle: appConts.const.bTN_YES, rightButtonTitle: appConts.const.bTN_NO, leftCompletionBlock: {
            self.cancelRide()
        }, rightCompletionBlock: {
            
        })
    }
}
