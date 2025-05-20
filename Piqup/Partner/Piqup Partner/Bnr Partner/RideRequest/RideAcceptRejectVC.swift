//
//  RideAcceptRejectVC.swift
//  BnR Partner
//
//  Created by KASP on 10/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import LinearProgressView

class RideAcceptRejectVC: BaseVC {
    @IBOutlet weak var imgvehicle: UIImageView!
    
    @IBOutlet weak var viewPerson: UIView!
    {
        didSet{
            viewPerson.applyBorder(color: UIColor.lightGray, width: 1.0)
        }
    }
    @IBOutlet weak var viewDimension: UIView!{
        didSet{
            viewDimension.applyBorder(color: UIColor.lightGray, width: 1.0)
        }
    }
    @IBOutlet weak var viewWeight: UIView!{
        didSet{
            viewWeight.applyBorder(color: UIColor.lightGray, width: 1.0)
        }
    }
    @IBOutlet weak var viewCategory: UIView!{
        didSet{
            viewCategory.applyBorder(color: UIColor.lightGray, width: 1.0)
        }
    }
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var viewTimer: UIView!{
        didSet{
            viewTimer.applyBorder(color: UIColor.lightGray, width: 1.0)
        }
    }
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var linearProgressView: LinearProgressView!
    
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblTotalPerson: UILabel!
    @IBOutlet weak var lblDimension: UILabel!
    @IBOutlet weak var lblweight: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var rideMapView: GMSMapView!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblRideName: UILabel!
    
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var btnAccepted:UIButton!
    @IBOutlet weak var denyRequest:UIButton!
    var carId = ""
    var rideId = ""
    
    var isUrgent = ""
    var customerId = ""
    var pickUpLocation = ""
    var pickUpLat = ""
    var pickUpLong = ""
    var dropOffLocation = ""
    var dropOffLat = ""
    var dropOffLong = ""
    var timerLimit = ""
    var tripDateTime = ""
    
    var rideAcceptRejectTimer:Timer?
 
     public var notificationInfo: NotificationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProgressBar()
        startRideTimer()
        displayTripInfo()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.disableRideTimer()
        
       
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
//        btnAccepted.setTitle(appConts.const.bTN_ACCEPT_REQ, for: .normal)
//        denyRequest.setTitle(appConts.const.bTN_DENY_REQ, for: .normal)
//        navTitle.text = appConts.const.TITLE_RIDE_REQUEST
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func displayTripInfo(){
        
        
        
        self.lblPickUpLocation.text = self.pickUpLocation
        self.lblDropOffLocation.text = self.dropOffLocation
        
        let pickUpMarker = GMSMarker()
        
        let pickupCoordinate = CLLocationCoordinate2D(latitude:Double(self.pickUpLat)!, longitude: Double(self.pickUpLong)!)
        pickUpMarker.position = pickupCoordinate
        pickUpMarker.appearAnimation = .pop
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.title = self.pickUpLocation
        pickUpMarker.map = rideMapView
        
        let dropMarker = GMSMarker()

        let dropCoordinate = CLLocationCoordinate2D(latitude:Double(self.dropOffLat)!, longitude: Double(self.dropOffLong)!)
        dropMarker.position = dropCoordinate
        dropMarker.appearAnimation = .pop
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.title = self.dropOffLocation
        dropMarker.map = rideMapView
        
        
        let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate: dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 150, left: 40, bottom: 150, right: 40))
        self.rideMapView.animate(with: cameraPosition)
        
        self.lblCarName.text = notificationInfo?.subTypeName
        self.lblRideName.text = notificationInfo?.typeName
        self.lblCategory.text = notificationInfo?.logisticCategoryName
        self.lblweight.text = notificationInfo?.weight
        
        self.lblDimension.text = "\(String(describing: notificationInfo?.width ?? "")) in x \(notificationInfo?.height ?? "") in x \(notificationInfo?.breadth ?? "") in"
        
        self.lblTotalPerson.text = notificationInfo?.number_of_extra_person_required
        
    }
    
    
    func setProgressBar(){

        linearProgressView.isCornersRounded = false
        linearProgressView.minimumValue = 0
        linearProgressView.maximumValue = Float(timerLimit)!
        linearProgressView.setProgress(0, animated: false)
//        linearProgressView.animationDuration = 10

    }
    
    func startRideTimer(){
        
        self.disableRideTimer()
        rideAcceptRejectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRideTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(rideAcceptRejectTimer!, forMode: RunLoopMode.commonModes)
        
    }
    
    @objc func updateRideTimer(){
        
        var prog:Float = Float(self.linearProgressView.progress)
        prog += 1
        self.linearProgressView.setProgress(prog, animated: false)
        
        let displayTimer = linearProgressView.maximumValue - prog
        
        if displayTimer > 9 {
            self.lblTime.text = "00:\(Int(displayTimer))"

        }
        else{
            self.lblTime.text = "00:0\(Int(displayTimer))"

        }
        
        if prog == Float(timerLimit)!{
            self.disableRideTimer()
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func acceptRideRequest(){
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let savedCarId = UserDefaults.standard.object(forKey: ParamConstants.Defaults.carId)

            let parameters: Parameters = [
                "driverId":sharedAppDelegate().currentUser!.uId,
                "rideId":self.rideId,
                "carId":savedCarId ?? "0",
                "driverLat":String(format:"%@",(describe(sharedAppDelegate().currentLocaton?.latitude))),
                "driverLong":String(format:"%@",(describe(sharedAppDelegate().currentLocaton?.longitude))),
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.partnerAcceptRide, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{

                    //UserDefaults.standard.set("", forKey: ParamConstants.Defaults.rideId)
                    UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isRideAccepted)
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        
                        self.disableRideTimer()
                        let startVC = RideStartVC(nibName: "RideStartVC", bundle: nil)
                        let newRide = Rides()
                        newRide.rideId = self.rideId
                        startVC.selecteRide = newRide
                        self.navigationController?.pushViewController(startVC, animated: true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        
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
    
    func disableRideTimer(){
        
        if ((rideAcceptRejectTimer) != nil){
            rideAcceptRejectTimer?.invalidate()
            rideAcceptRejectTimer = nil
        }
    }
    
    @IBAction func btnAcceptRequestClicked(_ sender: Any) {
        
        acceptRideRequest()
    }
    
    @IBAction func btnRejectRequestClicked(_ sender: Any) {
        goBack()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
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
