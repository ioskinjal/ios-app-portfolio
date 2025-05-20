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

class RideStartedVC: BaseVC {
    
    @IBOutlet weak var tripMapView: GMSMapView!
    
    
    @IBOutlet weak var panicView: UIView!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblRideTime: UILabel!
    
    @IBOutlet weak var driverProfileImgView: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverAvgRatings: UILabel!
    @IBOutlet weak var lblDriverToalRatings: UILabel!
    @IBOutlet weak var carImgView: UIImageView!
    
    @IBOutlet weak var lblCarType: UILabel!
    
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var lblCarNo: UILabel!
    
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var lblMinFareKm: UILabel!
    
    @IBOutlet weak var lblMinFare: UILabel!
    
    @IBOutlet weak var lblExtraFareKm: UILabel!
    
    @IBOutlet weak var lblTimeCharges: UILabel!
    
   
    
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    //Constants
    @IBOutlet weak var lblNavTitleConst: UILabel!
    @IBOutlet weak var lblCarNoConst: UILabel!
    @IBOutlet weak var lblContactNoConst: UILabel!
    @IBOutlet weak var lblTimeChargesPerMinConst: UILabel!
    
    @IBOutlet weak var trackTripBtn: UIButton!
    
    
    var selecteRide:Rides?
    var rideInfo = RideInfo()
    
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
        
        getUserRideInfo()
        panicView.applyCorner(radius: panicView.frame.size.width/2)
        setupLanguageUI()
        // Do any additional setup after loading the view.
    }
    
    func setupLanguageUI(){
        
        lblNavTitleConst.text = appConts.const.rIDE_INFO
        
        lblCarNoConst.text = appConts.const.lBL_CAR_NO
        lblContactNoConst.text = appConts.const.cONTACT
        lblTimeChargesPerMinConst.text = appConts.const.tIME_CHARGE
        
        trackTripBtn.setTitle(appConts.const.tRACK_TRIP, for: UIControlState.normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPanicRide(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "rideId":selecteRide!.rideId,
            "lId":Language.getLanguage().id
            ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Panic.setPaniceRide, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            //let jsonDict = json as NSDictionary?
            
            //let status = jsonDict?.object(forKey: "status") as! Bool
            //let message = jsonDict?.object(forKey: "message") as! String
            
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    func getPanicNumber(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":self.sharedAppDelegate().currentUser?.uId as Any,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Panic.getPanicNumber, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                _ = jsonDict?.object(forKey: "message") as! String
                
                if status == true {
                    DispatchQueue.main.async {
                        
                        let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                        let dataDict = dataAns[0] as! NSDictionary
                        let panicNo:String = String(format:"%@",dataDict.object(forKey: "userPanicNo") as! CVarArg)
                        
                        if panicNo.isEmpty{
                        alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.MSG_PANIC_UPDATE    , buttonTitleStr: appConts.const.bTN_OK)
                            return
                        }
                        
                        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: String(format:"\(appConts.const.lBL_CALL) %@",panicNo), leftButtonTitle: appConts.const.cANCEL, rightButtonTitle: appConts.const.lBL_CALL, leftCompletionBlock: {
                            
                        }, rightCompletionBlock: {
                            let url = NSURL(string: "tel://\(panicNo)")
                            UIApplication.shared.openURL(url! as URL)
                            self.setPanicRide()
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
    
    func getUserRideInfo(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "rideId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.getUserRideInfo, parameters: parameters, successBlock: { (json, urlResponse) in
                
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
                    
                    self.rideInfo = RideInfo.initWithResponse(dictionary: dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        
                        self.display(tripdetails: self.rideInfo)
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
    
    func display(tripdetails:RideInfo){
        
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
        
        lblRideTime.text = String(format: "\(appConts.const.LBL_RIDE_TIME) %@",tripdetails.rideDateTime)
        
          // Driver Information
        lblDriverName.text = tripdetails.driverName
        lblDriverAvgRatings.text = tripdetails.avgRatting
        lblDriverToalRatings.text = "\(tripdetails.totalRatting) \(appConts.const.rATTINGS)"
        
        // Car Information
        lblCarType.text = tripdetails.carName
        lblCarName.text = tripdetails.typeName
        
        
        lblCarNo.text = tripdetails.carNumber
        lblContactNo.text = tripdetails.driverContact
        lblMinFareKm.text = "\(appConts.const.mINFARE) (\(tripdetails.minFareKm) Km)"
        lblMinFare.text =  "$\(tripdetails.minFareKmRate)"
        lblExtraFareKm.text = "$\(tripdetails.extraFareKm)"
        lblTimeCharges.text = "$\(tripdetails.perMinRate)"
        
        if tripdetails.driverProfileImage.isEmpty{
            self.driverProfileImgView.image = #imageLiteral(resourceName: "profile_placeholder")
        }
        else{
            let driverImageUrl:String = URLConstants.Domains.profileUrl+tripdetails.driverProfileImage
            self.driverProfileImgView.af_setImage(withURL: URL(string: driverImageUrl)!)
            
        }
        
        self.driverProfileImgView.applyCorner(radius: (self.driverProfileImgView.frame.size.width)/2)
        self.driverProfileImgView.clipsToBounds = true
        
        if tripdetails.subTypeName.isEmpty{
            self.carImgView.image = #imageLiteral(resourceName: "hactaback_small_icon")
        }
        else{
            self.carImgView.af_setImage(withURL: URL(string: URLConstants.Domains.SubCarUrl+tripdetails.subTypeImage)!)
            
        }
        
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
    }
    
    @IBAction func btnPanicClicked(_ sender: Any) {
        
        getPanicNumber()
    }
    
    @IBAction func btnTrackTripClicked(_ sender: Any) {
        
        let trackVC =  TrackRideStartedVC(nibName: "TrackRideStartedVC", bundle: nil)
        trackVC.rideId = selecteRide?.rideId
        trackVC.currentRideInfo = rideInfo
        self.navigationController?.pushViewController(trackVC, animated: true)
    }
}
