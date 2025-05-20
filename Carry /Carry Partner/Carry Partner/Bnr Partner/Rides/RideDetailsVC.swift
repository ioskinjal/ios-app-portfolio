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

class RideDetailsVC: BaseVC {
    
    
    @IBOutlet weak var lblRideStatus: UILabel!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
    @IBOutlet weak var driverImgView: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverMobileNo: UILabel!
    @IBOutlet weak var lblDriverRatings: UILabel!
    @IBOutlet weak var lblDriverTotalRatings: UILabel!
    
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblCarBrandName: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
    @IBOutlet weak var lblTimeTaken: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalOther: UILabel!
    
    @IBOutlet weak var userRatingView: HCSStarRatingView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var lblReview: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var navView: UIView!
    
  
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblDroupOffConst:UILabel!
    @IBOutlet weak var lblPickeUpConts:UILabel!
    @IBOutlet weak var lblViewLocationOnMap:UILabel!
    @IBOutlet weak var lblBaseFareConst:UILabel!
    @IBOutlet weak var lblextraKMConst:UILabel!
    @IBOutlet weak var lblTimeTakenConts:UILabel!
    @IBOutlet weak var lblTotalConst:UILabel!
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
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
        lblPickeUpConts.text = appConts.const.pICK_UP
        lblDroupOffConst.text = appConts.const.dROP_OFF
        lblViewLocationOnMap.text = appConts.const.lBL_VIEW_LOCATIONO
        lblBaseFareConst.text = appConts.const.lBL_BASE_FARE
        lblextraKMConst.text = appConts.const.lBL_EXTRA_KM
        lblTimeTakenConts.text = appConts.const.lBL_TIME_TAKEN
        lblTotalConst.text = appConts.const.lBL_TOTAL
        
        lblNavTitleConst.text = appConts.const.tITLE_RIDES
        
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
        
            self.userRatingView.isUserInteractionEnabled = false
            
            if !rideTripDetail.rating.isEmpty {
            let n = NumberFormatter().number(from: rideTripDetail.rating)
            let f = CGFloat(truncating: n!)
            self.userRatingView.value = f
            }
            
        self.lblReview.text = rideTripDetail.feedback
        
        self.lblUserName.text = String(format:"%@ %@",rideTripDetail.userFirstName,rideTripDetail.userlastName)
        
        // Status comparision
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
        
        // download driver image with loader
        let driverImageUrl:String = URLConstants.Domains.profileUrl+rideTripDetail.driverProfileImage
        self.driverImgView.af_setImage(withURL: URL(string: driverImageUrl)!)
        self.driverImgView.applyCorner(radius: (self.driverImgView.frame.size.width)/2)
        self.driverImgView.clipsToBounds = true
        
        
        // download user image with loader
        let userImageUrl:String = URLConstants.Domains.profileUrl+rideTripDetail.userProfileImage
        self.userImgView.af_setImage(withURL: URL(string: userImageUrl)!)
        self.userImgView.applyCorner(radius: (self.userImgView.frame.size.width)/2)
        self.userImgView.clipsToBounds = true
        
        
        // download car image with loader
        let carImageUrl:String = URLConstants.Domains.CarUrl+rideTripDetail.typeImage
        self.carImgView.af_setImage(withURL: URL(string: carImageUrl)!)
        
        
        // Pickup Dropoff
        lblPickUp.text = rideTripDetail.pickUpLocation
        lblDropOff.text = rideTripDetail.dropOffLocation
        
        
        lblDriverName.text = String(format:"%@ %@",rideTripDetail.driverFirstName,rideTripDetail.driverLastName)
        lblDriverMobileNo.text = rideTripDetail.mobileNo
        lblDriverRatings.text = rideTripDetail.avgRatting
        lblDriverTotalRatings.text = "\(rideTripDetail.totalRating) \(appConts.const.rATTINGS)"
        lblCarBrandName.text = String(format: "%@ %@",rideTripDetail.brandName,rideTripDetail.carName)
        lblCarType.text = rideTripDetail.typeName
        lblCarNo.text = rideTripDetail.carNumber
        
        lblDate.text = rideTripDetail.rideDateTime
        
        let baseFareFormattedString = NSMutableAttributedString()
        baseFareFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.fareDistanceCharges)")
            .normal(" (\(rideTripDetail.fareDistance) \(appConts.const.pER_KM))")
        
        lblBaseFare.attributedText = baseFareFormattedString
        
        
        let extraKmFormattedString = NSMutableAttributedString()
        extraKmFormattedString
            .bold("\(rideTripDetail.extraDistance)")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal("\(rideTripDetail.fareAdditionalChargesPerKm) \(appConts.const.pER_KM_CHARGE)")
        
        lblExtraKm.attributedText = extraKmFormattedString
        
        let timeTakenFormattedString = NSMutableAttributedString()
        timeTakenFormattedString
            .bold("\(rideTripDetail.totalTime) \(appConts.const.tIME_CHARGE)")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal("\(rideTripDetail.perMinCharges) \(appConts.const.pER_MIN)")
        
        
        lblTimeTaken.attributedText = timeTakenFormattedString
        
        
        let totalFormattedString = NSMutableAttributedString()
        totalFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.totalCharges)")
            .normal(" (\(rideTripDetail.totalDistance))")
        
        lblTotal.attributedText =  totalFormattedString
        
        
        if rideDetail.payByCash == "" || rideTripDetail.payByCash == "0" || rideTripDetail.payByCash == "0.0" || Int(rideTripDetail.payByCash) == 0 {
            lblTotalOther.text = "\(ParamConstants.Currency.currentValue+rideTripDetail.payByWallet) \(appConts.const.lBL_WALLET)"
            
        }
        else{
            lblTotalOther.text = "\(ParamConstants.Currency.currentValue+rideTripDetail.payByCash)" + appConts.const.lBL_CASH
        }
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

