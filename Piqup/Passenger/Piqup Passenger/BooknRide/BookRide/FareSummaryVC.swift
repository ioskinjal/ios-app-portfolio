//
//  FareSummaryVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import HCSStarRatingView
import GoogleMaps

class FareSummaryVC: BaseVC,UITextViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var carImgView: UIImageView!
    
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarModal: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
    @IBOutlet weak var lblExtraPerson: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var txtDescription: UITextView!{
        didSet{
            txtDescription.placeholder = "Enter Description*"
        }
    }
   
    @IBOutlet weak var userRatingView: HCSStarRatingView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
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
    
    
    var originalTimeStamp:String?
    var rideId:String?
    var carId:String?
    var driverId:String?
    var timeTaken:String?
    var perMinFareAmount:String?
    
    var fareSummary:FareSummary?
    
    
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
        
        getFareSummary()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //self.lblDescriptionToHide.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
//        if textView.text.isEmpty {
//            self.lblDescriptionToHide.isHidden = false
//        }
//        else{
//            self.lblDescriptionToHide.isHidden = true
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func getFareSummary(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "rideId":self.rideId ?? "",
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Fare.getFareSummary, parameters: parameters, successBlock: { (json, urlResponse) in
                
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
                    
                    self.fareSummary = FareSummary.initWithResponse(dictionary:  dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        
                        self.displayFareSummary(rideSummary: self.fareSummary!)
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
    
    
    func displayFareSummary(rideSummary:FareSummary){
        
        self.userRatingView.value = 0
        
        
        
        // download car image with loader
        let carImageUrl:String = URLConstants.Domains.CarUrl+rideSummary.carTypeImage
        self.carImgView.af_setImage(withURL: URL(string: carImageUrl)!)
        
        
        // Pickup Dropoff
        lblPickUpLocation.text = rideSummary.pickUpLocation
        lblDropLocation.text = rideSummary.dropOffLocation
        
        
        lblCarType.text = String(format: "%@ %@",rideSummary.carBrand,rideSummary.carName)
        lblCarModal.text = rideSummary.carTypeName
        
        
        let baseFareFormattedString = NSMutableAttributedString()
        baseFareFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideSummary.totalFareAmount)")
            .normal(" (\(rideSummary.perKmAmount) Km)")
        
        lblBaseFare.attributedText = baseFareFormattedString
        
        if (rideSummary.totalExtraKm.contains("-")) {
            lblExtraKm.text = "0"
        } else {
            
            let extraKmFormattedString = NSMutableAttributedString()
            extraKmFormattedString
                .bold("\(rideSummary.totalExtraKm)")
                .normal(" (\(ParamConstants.Currency.currentValue)")
                .normal("\(rideSummary.perKmPrice) Per Km)")
            
            lblExtraKm.attributedText = extraKmFormattedString
        }
        
        
        let timeTakenFormattedString = NSMutableAttributedString()
        timeTakenFormattedString
            .bold("\(rideSummary.totalTime) min")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal("\(rideSummary.perMinFareAmount) Per Min)")
        
        
     let totalFormattedString = NSMutableAttributedString()
        totalFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold("\(rideSummary.finalTotalRidePrice)")
            .normal(" (\(rideSummary.totalKm))")
        
        lblTotal.attributedText =  totalFormattedString
        
        lblExtraPerson.text = "\((rideSummary.extraPerson as NSString).integerValue )"
        if rideSummary.payByCash == "" || rideSummary.payByCash == "0" || rideSummary.payByCash == "0.0" || Int(rideSummary.payByCash) == 0 {
            
        }
        else{
        
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        
        var date = dateFormatter.date(from: rideSummary.rideDateTime)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        lblDate.text = dateFormatter.string(from: date ?? Date())
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        date = dateFormatter.date(from: rideSummary.rideDateTime)
        // dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        lblTime.text = dateFormatter.string(from: date ?? Date())
        
    }
    
    func submitFeedback(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":self.rideId!,
            "ratting":userRatingView.value,
            "comment":self.txtDescription.text,
            "lId":Language.getLanguage().id
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
                    self.navigateToRideDetailsVC()
                })
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    func navigateToRideDetailsVC(){
        
        // User Trip Details
        let tripDetailsController = RideDetailsVC(nibName: "RideDetailsVC", bundle: nil)
        let newRide = Rides()
        newRide.rideId = self.rideId!
        tripDetailsController.selecteRide = newRide
        tripDetailsController.isFromSummary = true
        self.navigationController?.pushViewController(tripDetailsController, animated: true)
    }
    
    @IBAction func btnDownloadPDFClicked(_ sender: Any) {
        
        let finalLink:String = URLConstants.Domains.pdfDownload + (self.fareSummary?.rideSummary)!
        uploadiCloud(pdfLink: finalLink)
        
    }
    
    
    func uploadiCloud(pdfLink:String){
        if let linkPDF =  pdfLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            if let url = URL(string: linkPDF){
                self.startIndicator(title: "")
                Downloader.loadFileAsync(url: url) { (str, err) in
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    if err == nil, str != nil{
                        print("Download: \(str!)")
                        
                        //https://medium.com/ios-os-x-development/icloud-drive-documents-1a46b5706fe1
                        //TODO: Save file into iCloude
                        CloudDataManager.sharedInstance.copyFileToCloud()
                        DispatchQueue.main.async {
                            self.stopIndicator()
                            let ac = UIAlertController(title: "Saved!", message: appConts.const.MSG_iCLOUD, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: appConts.const.bTN_OK, style: .default, handler: { (action) in
                                if let pdfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowPDFViewController") as? ShowPDFViewController{
                                    pdfVC.link = pdfLink
                                    
                                    self.navigationController?.pushViewController(pdfVC , animated: true)
                                }
                            }))
                            self.present(ac, animated: true, completion: nil)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.stopIndicator()
                            let ac = UIAlertController(title: appConts.const.MSG_SAVE_ERROR, message: err?.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: appConts.const.bTN_OK, style: .default, handler: nil))
                            
                            self.present(ac, animated: true, completion: nil)
                            print("Error in Save Attachment")
                            
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        let alert = Alert()
        
        if txtDescription.text.isEmpty{
            alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.MSG_ENTER_REVIEW, buttonTitleStr: appConts.const.bTN_OK)
        }else if userRatingView.value == 0.0{
            self.alert(title: "", message: "please select rating")
        }
        else{
            self.submitFeedback()
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
