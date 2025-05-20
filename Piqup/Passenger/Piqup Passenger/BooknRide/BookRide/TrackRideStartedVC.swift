//
//  TrackRideStartedVC.swift
//  BooknRide
//
//  Created by KASP on 29/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire

class TrackRideStartedVC: BaseVC {
    
    @IBOutlet weak var tripMapView: GMSMapView!
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
    var pickUpMarker = GMSMarker()
    var dropOffMarker = GMSMarker()
    var carMarker = GMSMarker()
    
    var locationManager:CLLocationManager?
    
    var currentRideInfo:RideInfo?
    var rideId:String?
    
    var isFirstTime = true
    var animationFinished = true
    
    var locationArray = NSMutableArray()
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
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
        
        findMyLocation()
        getPathStringForTrip()
        lblNavTitleConst.text = appConts.const.tRACK_TRIP
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Home setup methods
    func findMyLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        
        // Here we start locating
        self.locationManager?.startUpdatingLocation()
    }
    
    
    
    func drawPath(pathData:NSDictionary){
        
        do {
            
            let pickupLatitude = String(format:"%@",pathData.object(forKey: "pickUpLat") as! CVarArg)
            let pickupLongitude = String(format:"%@",pathData.object(forKey: "pickUpLong") as! CVarArg)
            
            pickUpMarker.position = CLLocationCoordinate2DMake(Double(pickupLatitude)!, Double(pickupLongitude)!)
            pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
            pickUpMarker.map = self.tripMapView
            
            let dropOffLatitude = String(format:"%@",pathData.object(forKey: "dropOffLat") as! CVarArg)
            let dropOffLongitude = String(format:"%@",pathData.object(forKey: "dropOffLong") as! CVarArg)
            
            dropOffMarker.position = CLLocationCoordinate2DMake(Double(dropOffLatitude)!, Double(dropOffLongitude)!)
            dropOffMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
            dropOffMarker.map = self.tripMapView
            
            
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
            polyLine.map = self.tripMapView
        }
        catch{
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
    }
    
    
    func getPathStringForTrip(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":rideId!,
            "lId":Language.getLanguage().id
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
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
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
    func getInterPolatePoints(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D) -> [CLLocationCoordinate2D]{
        
        var points = [CLLocationCoordinate2D]()
        var k = 0.0
        
        for j in 0...9 {
            
            let coordinate = GMSGeometryInterpolate(from, to, k)
            points.append(coordinate)
            k += 0.1
        }
        return points
    }
    
    func animation(newPoint:CLLocationCoordinate2D){
        
        let oldLocation = CLLocation.init(latitude: self.carMarker.position.latitude, longitude: self.carMarker.position.longitude)
        let newLocation = CLLocation.init(latitude: newPoint.latitude, longitude:  newPoint.longitude)
        
        let bearing = GMSGeometryHeading(oldLocation.coordinate, newLocation.coordinate)
        
        self.snap(toMarkerIfItIsOutsideViewport: self.carMarker)
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        CATransaction.setAnimationDuration(0.4)
        if bearing != 0.0 {
            self.carMarker.rotation = bearing
        }
        CATransaction.setCompletionBlock {
            
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            CATransaction.setAnimationDuration(0.4)
            self.carMarker.position = newLocation.coordinate
            
            CATransaction.setCompletionBlock {
                
                if self.locationArray.count > 0 {
                    self.animationFinished = false
                    print("car bearing  \(bearing)")
                    self.animation(newPoint: self.locationArray.firstObject as! CLLocationCoordinate2D)
                    self.locationArray.removeObject(at: 0)
                    
                }
                else{
                    self.animationFinished = true
                }
            }
            CATransaction.commit()
            
        }
        
        
        
    }
    
    func snap(toMarkerIfItIsOutsideViewport m: GMSMarker) {
        let region: GMSVisibleRegion = self.tripMapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region:region)
        if !bounds.contains(m.position) {
            let camera = GMSCameraPosition.camera(withLatitude: m.position.latitude, longitude: m.position.longitude, zoom: self.tripMapView.camera.zoom)
            self.tripMapView?.animate(to: camera)
        }
    }
    
    
}


extension TrackRideStartedVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        if  locations.count > 0{
            
            
            if isFirstTime{
                isFirstTime = false
                carMarker.icon = #imageLiteral(resourceName: "map_car")
                carMarker.isFlat = true
                carMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                carMarker.appearAnimation = .pop
                carMarker.position = locations[0].coordinate
                carMarker.map = self.tripMapView
                
                let cameraPosition = GMSCameraUpdate.setTarget(locations[0].coordinate, zoom: 19.0)
                self.tripMapView.animate(with: cameraPosition)
            }
            else{
                
                
                let allCoordinatePoints:[CLLocationCoordinate2D] =  self.getInterPolatePoints(from: carMarker.position, to: locations[0].coordinate)
                self.locationArray.addObjects(from: allCoordinatePoints)
                
                if self.animationFinished {
                    self.animation(newPoint: self.locationArray.firstObject as! CLLocationCoordinate2D)
                }
            }
            
        }
    }
    
    
    
}
