//
//  RideEndVC.swift
//  BnR Partner
//
//  Created by KASP on 15/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import AlamofireImage

class RideEndVC: BaseVC {
    
    @IBOutlet weak var lblSubType: UILabel!
    @IBOutlet weak var lblRideName: UILabel!
    @IBOutlet weak var imgVehicle: UIImageView!
    
    @IBOutlet weak var lblRecContact: UILabel!
    @IBOutlet weak var lblRecEmail: UILabel!
    @IBOutlet weak var lblRecName: UILabel!
    @IBOutlet weak var lblSenderContact: UILabel!
    @IBOutlet weak var lblSenderEmail: UILabel!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var rideMapView: GMSMapView!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblRideTimer: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var endRide:UIButton!
    
    var dataAns = NSMutableDictionary()
    @IBOutlet weak var lblPickupLocation: UILabel!
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
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    let dropOffMarker = GMSMarker()
    let pickUpMarker = GMSMarker()
    
    var selecteRide:Rides?
    var startRideTimeStamp = ""
    
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
        getPathStringForTrip()
        displayDropLocation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        if ((rideStartTimer) != nil){
        //            rideStartTimer?.invalidate()
        //            rideStartTimer = nil
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayDropLocation(){
        
        self.lblDropOffLocation.text = self.selecteRide?.dropOffLocation
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
                    
                    formatter.timeZone = TimeZone.current
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:m:ss"
                    
                    // self.startRideTimeStamp = self.dataAns.object(forKey: "startRideTimeStamp") as! String
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
                    
                    
                    self.lblRideName.text = self.dataAns.object(forKey: "typeName")as? String
                    
                    self.lblSubType.text = self.dataAns.object(forKey: "subTypeName")as? String
                    
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
    
    
    func getPathStringForTrip(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":selecteRide!.rideId,
            ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Trip.getPathString, parameters: parameters, successBlock: { (json, urlResponse) in
            
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
                
                
                
                DispatchQueue.main.async {
                    self.drawPath(pathData: dataAns)
                    
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
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
    }
    
    
    func drawPath(pathData:NSDictionary){
        
        do {
            
            let pickupLatitude = String(format:"%@",pathData.object(forKey: "pickUpLat") as! CVarArg)
            let pickupLongitude = String(format:"%@",pathData.object(forKey: "pickUpLong") as! CVarArg)
            
            
            pickUpMarker.position = CLLocationCoordinate2DMake(Double(pickupLatitude)!, Double(pickupLongitude)!)
            pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
            pickUpMarker.map = self.rideMapView
            
            let dropOffLatitude = String(format:"%@",pathData.object(forKey: "dropOffLat") as! CVarArg)
            let dropOffLongitude = String(format:"%@",pathData.object(forKey: "dropOffLong") as! CVarArg)
            
            
            dropOffMarker.position = CLLocationCoordinate2DMake(Double(dropOffLatitude)!, Double(dropOffLongitude)!)
            dropOffMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
            dropOffMarker.map = self.rideMapView
            
            
            let pathString = String(format:"%@",pathData.object(forKey: "ridePathString") as! CVarArg)
            
            let pathData = pathString.data(using: String.Encoding.utf8)
            let jsonPath = try JSONSerialization.jsonObject(with: pathData!, options: .mutableContainers) as? NSDictionary
            
            print("json \(String(describing: jsonPath))")
            
            guard (jsonPath?.object(forKey: "routes")) != nil else {
                return}
            
            let routes = jsonPath?.object(forKey: "routes") as! NSArray
            let routeDict = routes[0] as! NSDictionary
            let overview_polyline = routeDict.object(forKey: "overview_polyline") as! NSDictionary
            let points = overview_polyline.object(forKey: "points") as! String
            
            let path:GMSPath = GMSPath.init(fromEncodedPath: points)!
            
            let polyLine:GMSPolyline = GMSPolyline.init(path: path)
            polyLine.strokeWidth = 5.0
            polyLine.strokeColor = UIColor.darkGray
            polyLine.map = self.rideMapView
            
            let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate:dropOffMarker.position)
            let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 100, left: 40, bottom: 50, right: 40))
            self.rideMapView.animate(with: cameraPosition)
        }
        catch{
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
            self.lblRideTimer.text = display as String
            
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600) % 24
        
        return NSString(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    @IBAction func btnNavigateToDirectionClicked(_ sender: Any) {
        UIApplication.shared.openURL(URL(string:"http://maps.google.com/maps?f=d&saddr=\(String(format:"%@", (sharedAppDelegate().currentLocaton?.latitude.description)!)),\(String(format:"%@", (sharedAppDelegate().currentLocaton?.longitude.description)!))&daddr=\(dropOffMarker.position.latitude),\(dropOffMarker.position.longitude)&directionsmode=driving")!)
        
    }
    
    @IBAction func btnEndRideClicked(_ sender: Any) {
        
        if self.startRideTimeStamp.isEmpty {
            goBack()
            return
        }
        let startDate = RideUtilities.getDateFromString(format: "yyyy-MM-dd H:m:s", date: self.startRideTimeStamp)
        let enddate = Date()
        
        let interval:TimeInterval = enddate.timeIntervalSince(startDate)
        
        var minutes = (NSInteger(interval) / 60) % 60
        let hours = (NSInteger(interval) / 3600)
        minutes = minutes + (hours*60)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let endVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        endVC.originalTimeStamp = self.startRideTimeStamp
        endVC.selectedRide = self.selecteRide
        endVC.dataAns = self.dataAns
        endVC.timeInMinutes = String(minutes)
        self.navigationController?.pushViewController(endVC, animated: true)
    }
    
    
    
    
    @IBAction func btnBackToRootClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
  
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
