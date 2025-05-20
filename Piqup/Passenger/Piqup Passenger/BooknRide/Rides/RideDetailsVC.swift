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

class RideDetailsVC: BaseVC,UITextViewDelegate {
    @IBOutlet weak var stackViewRecipient: UIStackView!
    @IBOutlet weak var descViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewRecContact: UIView!{
        didSet{
            viewRecContact.layer.borderColor = UIColor.lightGray.cgColor
            viewRecContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewRecEmail: UIView!{
        didSet{
            viewRecEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewRecEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewRecName: UIView!{
        didSet{
            viewRecName.layer.borderColor = UIColor.lightGray.cgColor
            viewRecName.layer.borderWidth = 1.0
        }
    }
   
    
    @IBOutlet weak var lblDescriptionToHide: UILabel!
    @IBOutlet weak var txtDescription: UITextView!{
        didSet{
            
           txtDescription.delegate = self
           // txtDescription.border(side: .bottom, color: UIColor.black, borderWidth: 1.0)
           //txtDescription.border(side: .bottom, color: UIColor.black, borderWidth: 1.0)
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var lblRecContact: UILabel!
    @IBOutlet weak var lblRecEmail: UILabel!
    @IBOutlet weak var lblRecName: UILabel!
    @IBOutlet weak var lblTripTime: UILabel!
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
    @IBOutlet weak var lblSenderContact: UILabel!
    @IBOutlet weak var lblTripDate: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblSenderEmail: UILabel!
    @IBOutlet weak var viewSenderEmail: UIView!{
        didSet{
            viewSenderEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var lblLogisticsName: UILabel!
    @IBOutlet weak var lblLogisticsContact: UILabel!
    
    @IBOutlet weak var viewLogisticsContact: UIView!{
        didSet{
            viewLogisticsContact.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var lblLogisticsEmail: UILabel!
    @IBOutlet weak var viewLogisticsEmail: UIView!
        {
        didSet{
            viewLogisticsEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewLogisticsName: UIView!
        {
        didSet{
            viewLogisticsName.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsName.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewSenderContact: UIView!{
        didSet{
            viewSenderContact.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewsendername: UIView!{
        didSet{
            viewsendername.layer.borderColor = UIColor.lightGray.cgColor
            viewsendername.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewDriverContact: UIView!{
        didSet{
            viewDriverContact.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var viewDriverEmail: UIView!{
        didSet{
            viewDriverEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var lblDrivername: UILabel!
    @IBOutlet weak var viewDriverName: UIView!{
        didSet{
            viewDriverName.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverName.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var lblPerson: UILabel!
    @IBOutlet weak var viewFareSummary: UIView!{
        didSet{
            viewFareSummary.layer.borderColor = UIColor.lightGray.cgColor
            viewFareSummary.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var lblRideStatus: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var lblExtraPerson: UILabel!
    
    @IBOutlet weak var lblDriverMobileNo: UILabel!
    
    @IBOutlet weak var lblByWallet: UILabel!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblCarBrandName: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
   
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var userRatingView: HCSStarRatingView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
    @IBOutlet weak var lblBaseFareConst: UILabel!
    @IBOutlet weak var lblExtraKmConst: UILabel!
   
    
    var isFromSummary:Bool = false
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
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getRideDetails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        // self.scrollView.setContentOffset(CGPoint(x: 0, y: self.userRatingView.frame.origin.y-45), animated: true)
        
        self.lblDescriptionToHide.isHidden = true
        // self.scrollView.isScrollEnabled = false
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       if rideDetail.feedback == "N/A"{
        return true
       }else{
        return false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            self.lblDescriptionToHide.isHidden = false
        }
        else{
            self.lblDescriptionToHide.isHidden = true
        }
//        self.txtDescription.sizeToFit()
//        self.descViewHeight.constant = txtDescription.frame.height
       // txtDescription.border(side: .bottom, color: UIColor.black, borderWidth: 1.0)
        // let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        // scrollView.setContentOffset(bottomOffset, animated: true)
        // self.scrollView.isScrollEnabled = true
        
    }

    func textView(_ textView: UITextView, c range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    
    func getRideDetails(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
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
                    self.rideDetail.driverReported = jsonDict!["driverReported"] as? String ?? "y"
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
        if selecteRide.createdDateTimeFormatted != ""{
        self.lblTripDate.text = array[0] as? String
        self.lblTripTime.text = array[1] as? String
        }

        if rideTripDetail.status == "c" && rideTripDetail.feedback == "N/A" {

            self.userRatingView.value = 0
        }
        else{

            self.submitBtn.isHidden = true
            self.lblDescriptionToHide.isHidden = true
            if rideTripDetail.feedback != "N/A"{
                self.txtDescription.text = rideTripDetail.feedback
               // self.txtDescription.sizeToFit()
                
                self.descViewHeight.constant = txtDescription.frame.height
               // txtDescription.border(side: .bottom, color: UIColor.black, borderWidth: 1.0)
            }else{
                self.descriptionView.isHidden = true
            }
            //self.txtDescription.isUserInteractionEnabled = false
            self.userRatingView.isUserInteractionEnabled = false

            if rideTripDetail.rating != "N/A" {
                let n = NumberFormatter().number(from: rideTripDetail.rating)
                let f = CGFloat(truncating: n!)
                self.userRatingView.value = f
            }
        }
        
        
//        if self.rideDetail.driverReported == "y" {
//            driverReportViewConstraint.constant = 0
//        }
//        else{
//            driverReportViewConstraint.constant = 50
//
//        }
        self.view.layoutIfNeeded()
        // Status comparision
        switch rideTripDetail.status {
        case "a":
            lblRideStatus.text = " \(appConts.const.LB_ACTIVE)  "
        case "e":
            lblRideStatus.text = " \(appConts.const.eXPIRED)  "
        case "r":
            lblRideStatus.text = " \(appConts.const.rEJECTED)  "
        case "c":
            lblRideStatus.text = " \(appConts.const.cOMPLETED)  "
        default:
            lblRideStatus.text = ""
        }
        
        let pickUpMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(rideTripDetail.pickUpLat)!, Double(rideTripDetail.pickUpLong)!))
        
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.map = mapView
        
        let dropMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(rideTripDetail.dropOffLat)!, Double(rideTripDetail.dropOffLong)!))
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.map = mapView
        
        let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate: dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 20, left: 40, bottom: 20, right: 40))
        self.mapView.animate(with: cameraPosition)
        // download driver image with loader
//        let driverImageUrl:String = URLConstants.Domains.profileUrl+rideTripDetail.driverProfileImage
        // download car image with loader
        let carImageUrl:String = URLConstants.Domains.CarUrl+rideTripDetail.typeImage
        self.carImgView.af_setImage(withURL: URL(string: carImageUrl)!)
        
        self.lblDrivername.text = rideTripDetail.driverFirstName + rideTripDetail.driverLastName
       // self.lblDriverEmail.text = rideTripDetail.
        //self.lblDriverMobileNo.text = rideTripDetail
        if rideTripDetail.recipientName == ""{
            stackViewRecipient.isHidden = true
        }
        self.lblRecName.text = rideTripDetail.recipientName
        self.lblRecEmail.text = rideTripDetail.recipientEmail
        self.lblRecContact.text = rideTripDetail.recipientPhone
        self.lblSenderName.text = rideTripDetail.senderName
        self.lblSenderEmail.text = rideTripDetail.senderEmail
        self.lblSenderContact.text = rideTripDetail.senderPhone
        self.lblLogisticsName.text = rideTripDetail.logistic_category_name
        self.lblPerson.text = rideTripDetail.number_of_extra_person_required
        self.lblLogisticsEmail.text = rideTripDetail.weight
        self.lblLogisticsContact.text = rideTripDetail.width + "in x " + rideTripDetail.height + "in x " + rideTripDetail.breadth + "in"
        // Pickup Dropoff
        lblPickUp.text = rideTripDetail.pickUpLocation
        lblDropOff.text = rideTripDetail.dropOffLocation
        lblExtraPerson.text = rideTripDetail.number_of_extra_person_required
        //self.lblRate.text = rideTripDetail.rating
        lblDriverMobileNo.text = rideTripDetail.mobileNo
        lblCarBrandName.text = String(format: "%@ %@",rideTripDetail.brandName,rideTripDetail.carName)
        lblCarType.text = rideTripDetail.typeName
        let baseFareFormattedString = NSMutableAttributedString()
        baseFareFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideTripDetail.fareDistanceCharges)")
            .normal(" (\(rideTripDetail.fareDistance) Km)")
        
        lblBaseFare.attributedText = baseFareFormattedString
        
        
        let extraKmFormattedString = NSMutableAttributedString()
        extraKmFormattedString
            .bold("\(rideTripDetail.extraDistance)")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal("\(rideTripDetail.fareAdditionalChargesPerKm) \(appConts.const.pER_KM)")
        
        lblExtraKm.attributedText = extraKmFormattedString
        
        let timeTakenFormattedString = NSMutableAttributedString()
        timeTakenFormattedString
            .bold("\(rideTripDetail.totalTime) min")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal("\(rideTripDetail.perMinCharges) \(appConts.const.pER_MIN)")
        
        
//        let totalFormattedString = NSMutableAttributedString()
//        totalFormattedString
//            .bold("\(ParamConstants.Currency.currentValue)")
//            .bold("\(rideTripDetail.totalCharges)")
//            .normal(" (\(rideTripDetail.totalDistance) Km)")
        
        lblTotal.text =  ParamConstants.Currency.currentValue + rideTripDetail.totalCharges
        
        
        //if rideDetail.payByCash == "" || rideTripDetail.payByCash == "0" || rideTripDetail.payByCash == "0.0" || Int(rideTripDetail.payByCash) == 0 {
           // lblByWallet.text = "\(ParamConstants.Currency.currentValue+rideTripDetail.payByWallet) \(appConts.const.LBL_WALLET)"
            
     //   }
       // else{
        
            
     //   }
        
        // userRatingView.value = rideTripDetail.
        
        
        //userRatingView: HCSStarRatingView!
        //lblDescriptionToHide: UILabel!
        // txtDescription: UITextView!
        
        
    }
    
    
    func submitFeedback(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":selecteRide.rideId,
            "ratting":userRatingView.value,
            "comment":txtDescription.text
            
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Trip.addUserFeedback, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            _ = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            DispatchQueue.main.async {
                alert.showAlertWithCompletionHandler(titleStr: appConts.const.lBL_MESSAGE, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                    self.userRatingView.value = 0.0
                    self.txtDescription.text = ""
                   // self.txtDescription.sizeToFit()
                   // self.txtDescription.border(side: .bottom, color: UIColor.black, borderWidth: 1.0)
                    self.getRideDetails()
                })
                
                
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    @IBAction func btnGoBackClicked(_ sender: Any) {
        
        if self.isFromSummary == false {
        goBack()
        }
        else{
            self.navigationController?.popToRootViewController(animated: true)

        }
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
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        let alert = Alert()
        if userRatingView.value == 0.0{
            self.alert(title: "", message: "please select rating")
        }else if txtDescription.text == ""{
            self.alert(title: "", message: "please enter description")
        }else{
            self.submitFeedback()
        }
    }
    
    @IBAction func onclickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReportDriverClicked(_ sender: Any) {
        
        let codeController = ReportDriverVC(nibName: "ReportDriverVC", bundle: nil)
        codeController.delegate = self
        codeController.driverId = self.rideDetail.driverId
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
extension UIView {
    func addDashedBorder() {
        let color = UIColor(red: 209, green: 47, blue: 54).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
