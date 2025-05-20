//
//  FareSummaryVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps

class FareSummaryVC: BaseVC {
    
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarModal: UILabel!
    
    
    @IBOutlet weak var lblTripTime: UILabel!
    @IBOutlet weak var lblTripDate: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblExtraKm: UILabel!
   // @IBOutlet weak var lblTimeTaken: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    //@IBOutlet weak var lblTotalCash: UILabel!
   // @IBOutlet weak var lblTotalWallet: UILabel!
    
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
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTripDate: UIView!{
        didSet{
            viewTripDate.addDashedBorder()
        }
    }
    
    @IBOutlet weak var lblFareSummary:UILabel!
  //  @IBOutlet weak var lblPickUp:UILabel!
    //@IBOutlet weak var lbldropOff:UILabel!
//    @IBOutlet weak var lblBaseFareConst:UILabel!
//    @IBOutlet weak var lblExtraKmConst:UILabel!
//    @IBOutlet weak var lblTimeTakenConst:UILabel!
//    @IBOutlet weak var lblTotalConst:UILabel!
    @IBOutlet weak var btnCompleteRide:UIButton!
    
    
    
    
    
    let dropOffMarker = GMSMarker()
    let pickUpMarker = GMSMarker()
    var originalTimeStamp:String?
    var selectedRide:Rides?
    var summary:FareSummary?
    var timeInMinutes:String?
    var signatureImg:UIImage?
    
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
   //btnCompleteRide.setTitle(appConts.const.bTN_COMPLETE_RIDE.uppercased(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFareSummary()
        getPathStringForTrip()
        
        // Do any additional setup after loading the view.
    }
    
    func drawPath(pathData:NSDictionary){
        
        do {
            
            let pickupLatitude = String(format:"%@",pathData.object(forKey: "pickUpLat") as! CVarArg)
            let pickupLongitude = String(format:"%@",pathData.object(forKey: "pickUpLong") as! CVarArg)
            
            
            pickUpMarker.position = CLLocationCoordinate2DMake(Double(pickupLatitude)!, Double(pickupLongitude)!)
            pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
            pickUpMarker.map = self.mapView
            
            let dropOffLatitude = String(format:"%@",pathData.object(forKey: "dropOffLat") as! CVarArg)
            let dropOffLongitude = String(format:"%@",pathData.object(forKey: "dropOffLong") as! CVarArg)
            
            
            dropOffMarker.position = CLLocationCoordinate2DMake(Double(dropOffLatitude)!, Double(dropOffLongitude)!)
            dropOffMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
            dropOffMarker.map = self.mapView
            
            
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
            polyLine.map = self.mapView
            
            let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate:dropOffMarker.position)
            let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 100, left: 40, bottom: 50, right: 40))
            self.mapView.animate(with: cameraPosition)
        }
        catch{
        }
    }
    
    
    func getPathStringForTrip(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":selectedRide!.rideId,
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
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFromMultiPartSignature(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Fare.summary, parameters: parameters, image: signatureImg!, successBlock: { (json, urlResponse) in
          
                
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
        self.lblCarModal.text = fare.carTypeName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        
        
        let strDate:Date = dateFormatter.date(from: fare.rideDateTime)!
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let strdate:String = dateFormatter.string(from: strDate)
        print(strDate)
        let array:NSArray = strdate.components(separatedBy: " ") as NSArray
        lblTripDate.text = array[0] as? String
        lblTripTime.text = String(format: "%@ %@", array[1] as? String ?? "",array[2] as? String ?? "")
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
        
      //  self.lblTimeTaken.attributedText  = timeTakenString
        
        
        //Total 1
        let totalString = NSMutableAttributedString()
        totalString
            .bold("\(ParamConstants.Currency.currentValue)")
            .bold(" \(fare.finalTotalRidePrice)")
            .normal(" (\(fare.totalKm) Per Km)")
        
        self.lblTotal.attributedText  = totalString
        
        
        //self.lblTotalCash.text  = "\(ParamConstants.Currency.currentValue)\(fare.payByCash) by cash"
        
       // self.lblTotalWallet.text  = "\(ParamConstants.Currency.currentValue)\(fare.payByWallet) by wallet"
        
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
