//
//  FareSummaryVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class FareSummaryVC: BaseVC {
    
    @IBOutlet weak var carImgView: UIImageView!
    
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarModal: UILabel!
    
    
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
    @IBOutlet weak var lblTimeTaken: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalCash: UILabel!
    @IBOutlet weak var lblTotalWallet: UILabel!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblFareSummary:UILabel!
    @IBOutlet weak var lblPickUp:UILabel!
    @IBOutlet weak var lbldropOff:UILabel!
    @IBOutlet weak var lblBaseFareConst:UILabel!
    @IBOutlet weak var lblExtraKmConst:UILabel!
    @IBOutlet weak var lblTimeTakenConst:UILabel!
    @IBOutlet weak var lblTotalConst:UILabel!
    @IBOutlet weak var btnCompleteRide:UIButton!
    
    
    
    
    
    
    var originalTimeStamp:String?
    var selectedRide:Rides?
    var summary:FareSummary?
    var timeInMinutes:String?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblFareSummary.text = appConts.const.tITLE_FARE_SUMMERY
        lblPickUp.text = appConts.const.pICK_UP
        lbldropOff.text = appConts.const.dROP_OFF
        lblBaseFareConst.text = appConts.const.lBL_BASE_FARE
        lblExtraKmConst.text = appConts.const.lBL_EXTRA_KM
        lblTimeTakenConst.text = appConts.const.lBL_TIME_TAKEN
        lblTotalConst.text = appConts.const.lBL_TOTAL
    btnCompleteRide.setTitle(appConts.const.bTN_COMPLETE_RIDE.uppercased(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFareSummary()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFareSummary(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let endTimeStamp = RideUtilities.getStringFromDate(format: "yyyy-MM-dd H:m:s", date: Date())
            let carId = UserDefaults.standard.object(forKey: ParamConstants.Defaults.carId)
            
            let parameters: Parameters = [
                "rideId": String(describe(self.selectedRide!.rideId)),
                "driverId":String(describe(self.sharedAppDelegate().currentUser!.uId)),
                "carId":carId ?? "",
                "timeInMinutes":self.timeInMinutes!,
                "endRideTimeStamp":endTimeStamp,
                "dropLat":String(describe(self.selectedRide!.dropOffLat)),
                "dropLong":String(describe(self.selectedRide!.dropOffLong)),
                "dropLocation":String(describe(self.selectedRide!.dropOffLocation)),
                "isCompletedRide":"y",
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Fare.summary, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print("Fare Summary:----- \(dataAns)")
                    
                    self.summary = FareSummary.initWithResponse(dictionary: dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        self.displayFareData(fare:self.summary!)
                        
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
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        
    }
    
    func displayFareData(fare:FareSummary){
        
        self.lblPickUpLocation.text = fare.pickUpLocation
        self.lblDropLocation.text = fare.dropOffLocation
        
        self.lblCarType.text = String(format: "%@ %@",(fare.carBrand),(fare.carName))
        self.lblCarModal.text = fare.subCarTypeName
        
        //Base Fare
        let baseFareFormattedString = NSMutableAttributedString()
        baseFareFormattedString
            .bold("\(ParamConstants.Currency.currentValue)")
            .normal("\(fare.totalFareAmount)")
            .normal(" (\(fare.perKmAmount) Km)")
        
        self.lblBaseFare.attributedText  = baseFareFormattedString
        
        //Extra Fare
        let extraFormattedString = NSMutableAttributedString()
        extraFormattedString
            .bold("\(fare.totalExtraKm)")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal(" \(fare.perKmPrice) Per Km)")
        
        self.lblExtraKm.attributedText  = extraFormattedString
        
        //Time Taken
        let timeTakenString = NSMutableAttributedString()
        timeTakenString
            .bold("\(fare.totalTime)")
            .normal(" (\(ParamConstants.Currency.currentValue)")
            .normal(" \(fare.perKmPrice) Per min)")
        
        self.lblTimeTaken.attributedText  = timeTakenString
        
        
        //Total 1
        let totalString = NSMutableAttributedString()
        totalString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold(" \(fare.finalTotalRidePrice)")
            .normal(" (\(fare.totalKm) Per Km)")
        
        self.lblTotal.attributedText  = totalString
        
        
        self.lblTotalCash.text  = "\(ParamConstants.Currency.currentValue)\(fare.payByCash) by cash"
        
        self.lblTotalWallet.text  = "\(ParamConstants.Currency.currentValue)\(fare.payByWallet) by wallet"
        
        let url = URL(string: URLConstants.Domains.SubCarUrl+fare.subCarTypeImage)!

        self.carImgView.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
            if response.data != nil {
                let downloadedImage = UIImage.init(data: response.data!)
                
                if downloadedImage != nil{
                    self.carImgView.image = downloadedImage
                }
                else{
                    self.carImgView.image = #imageLiteral(resourceName: "hactaback_small_icon")
                    
                }
                
                
                self.carImgView.contentMode = .scaleAspectFit
                self.carImgView.clipsToBounds = true
                
                
            }
            else{
                // Default image if no data found
                self.carImgView.image = nil
                
            }
        })
            
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func btnCompleteRideClicked(_ sender: Any) {
        UserDefaults.standard.set("", forKey: ParamConstants.Defaults.rideId)
        UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isRideAccepted)
        UserDefaults.standard.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        UserDefaults.standard.set("", forKey: ParamConstants.Defaults.rideId)
        UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isRideAccepted)
        UserDefaults.standard.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
