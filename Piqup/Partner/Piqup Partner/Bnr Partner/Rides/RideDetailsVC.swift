//
//  RideDetailsVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Alamofire
import AlamofireImage
import GoogleMaps

class RideDetailsVC: BaseVC {
    
    
   
    @IBOutlet weak var viewDimesion: UIView!{
        didSet{
            viewDimesion.layer.borderColor = UIColor.lightGray.cgColor
            viewDimesion.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewWeight: UIView!{
        didSet{
            viewWeight.layer.borderColor = UIColor.lightGray.cgColor
            viewWeight.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewLogCat: UIView!{
        didSet{
            viewLogCat.layer.borderColor = UIColor.lightGray.cgColor
            viewLogCat.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewPerson: UIView!{
        didSet{
            viewPerson.layer.borderColor = UIColor.lightGray.cgColor
            viewPerson.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var lblNumberPerson: UILabel!
    @IBOutlet weak var lblDimension: UILabel!
    @IBOutlet weak var lblLogWeight: UILabel!
    @IBOutlet weak var lblLogCategory: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
   
    @IBOutlet weak var lblDriverMobileNo: UILabel!
   
    
    @IBOutlet weak var lblTripTime: UILabel!
    @IBOutlet weak var lblTripDate: UILabel!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblCarBrandName: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
    
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
   
    @IBOutlet weak var lblTotal: UILabel!
   
    
    @IBOutlet weak var userRatingView: HCSStarRatingView!
//    @IBOutlet weak var userImgView: UIImageView!
//    @IBOutlet weak var lblReview: UILabel!
    
    
   
    @IBOutlet weak var lblRideStatus: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var navView: UIView!
    
  
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var lblDroupOffConst:UILabel!
//    @IBOutlet weak var lblPickeUpConts:UILabel!
//    @IBOutlet weak var lblViewLocationOnMap:UILabel!
  
    
    @IBOutlet weak var lblExtraPerson:UILabel!
    
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
    @IBOutlet weak var lblByWallet: UILabel!
    @IBOutlet weak var lblRecContact: UILabel!
    @IBOutlet weak var lblRecEmail: UILabel!
    @IBOutlet weak var lblRecName: UILabel!
    @IBOutlet weak var lblSenderContact: UILabel!
    @IBOutlet weak var lblSenderEmail: UILabel!
    @IBOutlet weak var lblSenderName: UILabel!
   // @IBOutlet weak var lblReqContact: UILabel!
    //@IBOutlet weak var lblReqEmail: UILabel!
    //@IBOutlet weak var lblReqName: UILabel!
    @IBOutlet weak var rideMapView: GMSMapView!
    
    
//    @IBOutlet weak var viewReqName: UIView!{
//        didSet{
//            viewReqName.layer.borderColor = UIColor.lightGray.cgColor
//            viewReqName.layer.borderWidth = 1.0
//        }
//    }
//    @IBOutlet weak var viewreqContact: UIView!{
//        didSet{
//            viewreqContact.layer.borderColor = UIColor.lightGray.cgColor
//            viewreqContact.layer.borderWidth = 1.0
//        }
//    }
//    @IBOutlet weak var viewReqEmail: UIView!{
//        didSet{
//            viewReqEmail.layer.borderColor = UIColor.lightGray.cgColor
//            viewReqEmail.layer.borderWidth = 1.0
//        }
//    }
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
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblTimeTaken: UILabel!
    @IBOutlet weak var viewSenderEmail: UIView!{
        didSet{
            viewSenderEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderEmail.layer.borderWidth = 1.0
        }
    }
   // @IBOutlet weak var lblrate: UILabel!
    
    @IBOutlet weak var viewFareSummary: UIView!{
        didSet{
            viewFareSummary.layer.borderWidth = 1.0
            viewFareSummary.layer.borderColor  = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var viewTripTime: UIView!{
        didSet{
            viewTripTime.addDashedBorder()
        }
    }
    @IBOutlet weak var viewTripDate: UIView!{
        didSet{
            viewTripDate.addDashedBorder()
        }
    }
    var selecteRide = Rides()
    var rideDetail = RideTripDetails()
    
    
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
        
        getRideDetails()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        lblPickeUpConts.text = appConts.const.pICK_UP
//        lblDroupOffConst.text = appConts.const.dROP_OFF
//        lblViewLocationOnMap.text = appConts.const.lBL_VIEW_LOCATIONO
//        lblBaseFareConst.text = appConts.const.lBL_BASE_FARE
//        lblextraKMConst.text = appConts.const.lBL_EXTRA_KM
//        lblTimeTakenConts.text = appConts.const.lBL_TIME_TAKEN
//        lblTotalConst.text = appConts.const.lBL_TOTAL
//
//        lblNavTitleConst.text = appConts.const.tITLE_RIDES
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    func getRideDetails(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "driverId":sharedAppDelegate().currentUser!.uId,
                "tripId":selecteRide.rideId,
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
                    
                    self.rideDetail = RideTripDetails.initWithResponse(dictionary: dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        self.displayTripDetails(rideTripDetail:self.rideDetail)
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
    
    func displayTripDetails(rideTripDetail:RideTripDetails){
        
        let array:NSArray = selecteRide.createdDateTimeFormatted.components(separatedBy: ",") as NSArray
        self.lblTripDate.text = array[0] as? String
        self.lblTripTime.text = array[1] as? String
        
        //if rideTripDetail.status == "c" && rideTripDetail.feedback == "N/A" {
            
          //  self.userRatingView.value = 0
        //}
        //else{
           
            if rideTripDetail.rating != "" {
                let n = NumberFormatter().number(from: rideTripDetail.rating)
                let f = CGFloat(truncating: n!)
                self.userRatingView.value = f
            }else{
                self.userRatingView.value = 0
       }
        self.userRatingView.isUserInteractionEnabled = false
        
         self.lblReview.text = rideTripDetail.feedback
        if self.lblReview.text ==  "" {
            self.lblReview.text = "N/A"
        }
        
        switch rideTripDetail.status {
        case "a":
            lblRideStatus.text = " Active  "
        case "e":
            lblRideStatus.text = " \(appConts.const.eXPIRED)  "
        case "r":
            lblRideStatus.text = " \(appConts.const.rEJECTED)  "
        case "c":
            lblRideStatus.text = " \(appConts.const.cOMPLETED)  "
        default:
            lblRideStatus.text = ""
        }
        
          self.lblUserName.text = String(format:"%@ %@",rideTripDetail.userFirstName,rideTripDetail.userlastName)
//        if self.rideDetail.driverReported == "y" {
//
//        }
//        else{
//
//
//        }
        self.view.layoutIfNeeded()
        // Status comparision
//        switch rideTripDetail.status {
//        case "a":
//            lblRideStatus.text = " \(appConts.const.LB_ACTIVE)  "
//        case "e":
//            lblRideStatus.text = " \(appConts.const.eXPIRED)  "
//        case "r":
//            lblRideStatus.text = " \(appConts.const.rEJECTED)  "
//        case "c":
//            lblRideStatus.text = " \(appConts.const.cOMPLETED)  "
//        default:
//            lblRideStatus.text = ""
//        }
        
        let pickUpMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(rideTripDetail.pickUpLat)!, Double(rideTripDetail.pickUpLong)!))
        
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.map = rideMapView
        
        let dropMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(rideTripDetail.dropOffLat)!, Double(rideTripDetail.dropOffLong)!))
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.map = rideMapView
        
        let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate: dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 20, left: 40, bottom: 20, right: 40))
        self.rideMapView.animate(with: cameraPosition)
        // download driver image with loader
        //        let driverImageUrl:String = URLConstants.Domains.profileUrl+rideTripDetail.driverProfileImage
        // download car image with loader
        let carImageUrl:String = URLConstants.Domains.CarUrl+rideTripDetail.typeImage
        self.carImgView.af_setImage(withURL: URL(string: carImageUrl)!)
        
        //self.lblReqName.text = rideTripDetail.driverFirstName + rideTripDetail.driverLastName
        // self.lblDriverEmail.text = rideTripDetail.
        //self.lblDriverMobileNo.text = rideTripDetail
        if rideTripDetail.senderName == "" {
            self.lblSenderName.text = "N/A"
        }else{
            self.lblSenderName.text = rideTripDetail.senderName
        }
        
        if rideTripDetail.senderEmail == "" {
            self.lblSenderEmail.text = "N/A"
        }else{
            self.lblSenderEmail.text = rideTripDetail.senderEmail
        }
        
        if rideTripDetail.senderPhone == "" {
            self.lblSenderContact.text = "N/A"
        }else{
            self.lblSenderContact.text = rideTripDetail.senderPhone
        }
        
        if rideTripDetail.recipientName == "" {
            self.lblRecName.text = "N/A"
        }else{
            self.lblRecName.text = rideTripDetail.recipientName
        }
        
        if rideTripDetail.recipientEmail == "" {
            self.lblRecEmail.text = "N/A"
        }else{
            self.lblRecEmail.text = rideTripDetail.recipientEmail
        }
        
        if rideTripDetail.recipientPhone == "" {
            self.lblRecContact.text = "N/A"
        }else{
            self.lblRecContact.text = rideTripDetail.recipientPhone
        }
        
       
        // Pickup Dropoff
        lblPickUp.text = rideTripDetail.pickUpLocation
        lblDropOff.text = rideTripDetail.dropOffLocation
        if rideTripDetail.number_of_extra_person_required == ""{
            lblExtraPerson.text = "N/A"
        }else{
          lblExtraPerson.text = rideTripDetail.number_of_extra_person_required
        }
        
        self.lblLogCategory.text = rideTripDetail.logistic_category_name
        self.lblNumberPerson.text = rideTripDetail.number_of_extra_person_required
        self.lblLogWeight.text = rideTripDetail.weight
        self.lblDimension.text = rideTripDetail.width + "in x " + rideTripDetail.height + "in x " + rideTripDetail.breadth + "in"
      //  self.lblrate.text = rideTripDetail.rating
       
        lblCarBrandName.text = String(format: "%@ %@",rideTripDetail.brandName,rideTripDetail.carName)
        lblCarType.text = rideTripDetail.typeName
        let baseFareFormattedString = NSMutableAttributedString()
        baseFareFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.fareDistanceCharges)")
            .bold(" (\(rideTripDetail.fareDistance) Km)")
        
        lblBaseFare.attributedText = baseFareFormattedString
        
        
        let extraKmFormattedString = NSMutableAttributedString()
        extraKmFormattedString
            .bold("\(rideTripDetail.extraDistance)")
            .bold(" (\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.fareAdditionalChargesPerKm) \(appConts.const.pER_KM)")
        
        lblExtraKm.attributedText = extraKmFormattedString
        
      
        let timeTakenFormattedString = NSMutableAttributedString()
        timeTakenFormattedString
            .bold("\(rideTripDetail.totalTime) Min")
            .bold(" (\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.perMinCharges) \(appConts.const.pER_MIN))")
        
        
        lblTimeTaken.attributedText = timeTakenFormattedString
        
        let totalFormattedString = NSMutableAttributedString()
        totalFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.totalCharges)")
            .bold(" (\(rideTripDetail.totalDistance))")
        
        lblTotal.attributedText =  totalFormattedString
        
        if rideDetail.payByCash == "" || rideTripDetail.payByCash == "0" || rideTripDetail.payByCash == "0.0" || Int(rideTripDetail.payByCash) == 0 {
            lblByWallet.text = "\(ParamConstants.Currency.currentValue+rideTripDetail.payByWallet)" + " " + appConts.const.lBL_WALLET
            
        }
        else{
            lblByWallet.text = "\(ParamConstants.Currency.currentValue+rideTripDetail.payByCash)" + " " + appConts.const.lBL_CASH
        }
    }
    @IBAction func onClickReportIssue(_ sender: UIButton) {
        let codeController = ReportDriverVC(nibName: "ReportDriverVC", bundle: nil)
        codeController.delegate = self
        codeController.driverId = self.rideDetail.custId
        self.addChildViewController(codeController)
        view.addSubview(codeController.view)
        
        codeController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        let bottomConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        self.view.layoutIfNeeded()
        
        codeController.didMove(toParentViewController: self)
        
    }
    
    @IBAction func btnGoBackClicked(_ sender: Any) {
        //goBack()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewLocationOnMapClicked(_ sender: Any) {
        
        let tripMapVC = RideTripMapVC(nibName: "RideTripMapVC", bundle: nil)
        
        let pickUpLocation = AddressLocation()
        pickUpLocation.location = self.rideDetail.pickUpLocation
        pickUpLocation.latitude = self.rideDetail.pickUpLat
        pickUpLocation.longitude = self.rideDetail.pickUpLong
        
        let dropOffLocation = AddressLocation()
        dropOffLocation.location = self.rideDetail.dropOffLocation
        dropOffLocation.latitude = self.rideDetail.dropOffLat
        dropOffLocation.longitude = self.rideDetail.dropOffLong
        
        tripMapVC.pickUpLocation = pickUpLocation
        tripMapVC.dropOffLocation = dropOffLocation
        
        self.navigationController?.pushViewController(tripMapVC, animated: true)
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

extension RideDetailsVC:ReportDriverDelegate{
    
    func dimissReportDriverClicked() {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? RideDetailsVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        getRideDetails()
        
    }
    
    
}
