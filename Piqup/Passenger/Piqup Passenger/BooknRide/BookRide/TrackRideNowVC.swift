//
//  TrackRideNowVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftWebSocket



class TrackRideNowVC: BaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var aMapView: GMSMapView!
    
    @IBOutlet weak var lblNavTitleConst: UILabel!
    
    
    // MARK: - Variables
    var currentRideInfo:RideInfo?
    var rideId:String?
    
    var carMarker = GMSMarker()
    var driverMarker = GMSMarker()
    var passengerMarker = GMSMarker()
    
    
    var Get_Partener_Location_Interval:TimeInterval = 20.0
    var triptimer = Timer()
    var webSocketClient = WebSocket()
    
    var responseArray = [NSDictionary]()
    var locationArray = [LocationModal]()
    var via = [Any]()
    
    var animationFinished = true
    var first_Time = true
    var isProcessing = false
    
    var animationCounter = 0
    var lastIndex = 0
    var totalPoints = 0
    var currentRotation = 0
    
    var totalDistance:CLLocationDistance?
    
    var strDriverLat = ""
    var strDriverLong = ""
    var strPassengerLat = ""
    var strPassengerLong = ""
    var strCarLat = ""
    var strCarLong = ""
    var pathString = ""
    var timeLapse = ""
    
    var lastSendId = ""
    
    
    var startTime = CACurrentMediaTime();
    
    var driverPoint = CLLocationCoordinate2D()
    var passengerPoint = CLLocationCoordinate2D()
    var lastCarPoint = CLLocationCoordinate2D()
    
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
        
        prepareMapView()
        connectHost()
        
        lblNavTitleConst.text = appConts.const.tRACK_DRIVER
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareMapView(){
        
        let driverLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(currentRideInfo!.driverLastLat)!, Double(currentRideInfo!.driverLastLong)!)
        
        let cameraPosition = GMSCameraUpdate.setTarget(driverLocation, zoom: 16.0)

                aMapView.delegate = self
                aMapView.animate(with: cameraPosition)
        //        pickupMarker.position = driverLocation!
        //        pickupMarker.appearAnimation = .pop
        //        pickupMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        //        pickupMarker.map = aMapView
        
    }
    
    // MARK: - Initiate Tracking
    
    func connectHost(){
        
        webSocketClient = WebSocket(URLConstants.Domains.trackingUrl)
        webSocketClient.event.open = {
            print("opened")
            self.onConnect()
        }
        webSocketClient.event.close = { code, reason, clean in
            print("closed, reason \(reason)")
        }
        webSocketClient.event.error = { error in
            print("error \(error)")
        }
        
        
    }
    
    func onConnect(){
        
        var messageString:String = ""
        let lastId:String = UserDefaults.standard.object(forKey: "lastSendId") as? String ?? ""
        if lastId.isEmpty{
            messageString = rideId! + "&&&" + "0"
        }
        else{
            messageString = rideId! + "&&&" + lastId
            UserDefaults.standard.set(messageString, forKey: "lastSendId")
            UserDefaults.standard.synchronize()
        }
        print(messageString)
        
        webSocketClient.send(messageString)
        webSocketClient.event.message = { message in
            if let text = message as? String {
                print(text)
                
                if let data = text.data(using: String.Encoding.utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        print(json ?? "")
                        
                        guard (json?.object(forKey: "status")) != nil else {
                            return
                            
                        }
                        
                        let status = (json?.object(forKey: "status") as? NSNumber)?.boolValue
                        
                        if status == true {
                            
                            let stop = (json?.object(forKey: "stop") as? NSNumber)?.boolValue
                            
                            if !stop! {
                                self.responseArray.append(json!)
                                
                                if self.animationFinished {
                                    
                                    if self.animationCounter <= self.responseArray.count - 1{
                                        //                                        self.decodeResult(json: self.responseArray[self.animationCounter] as NSDictionary)
                                        self.decodeResult(json: self.responseArray[self.animationCounter])
                                        
                                    }
                                    
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.webSocketClient.close()
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                
                            }
                        }
                        else{
                            
                        }
                    } catch {
                        print("Something went wrong ")
                    }
                }
                
            }
        }
    }
    
    // MARK: - Decode Data
    
    func decodeResult(json:NSDictionary){
        lastIndex = 0
        self.locationArray.removeAll()
        self.locationArray = [LocationModal]()
        
        let trackObj = TrackRide.initWithResponse(dictionary: (json as! [String : Any]))
        
        strDriverLat = trackObj.driverLat
        strDriverLong = trackObj.driverLong
        strPassengerLat = trackObj.passengerLat
        strPassengerLong = trackObj.passengerLong
        strCarLat = trackObj.carLat
        strCarLong = trackObj.carLong
        pathString = trackObj.pathString
        //Total time of via array
        timeLapse = trackObj.timeLapse
        lastSendId = trackObj.lastSendId
        
        // Save lastSendId for Continue animation
        UserDefaults.standard.set(trackObj.lastSendId, forKey: "lastSendId")
        UserDefaults.standard.synchronize()
        
        //self.via = trackObj.via
        //        self.via.removeAll()
        var viaArray = NSArray()
        if (json.object(forKey: "via") != nil) {
            
            viaArray = json.object(forKey: "via") as! NSArray
            
        }
        
        //        if viaArray.count == 1 {
        //
        //            let locDict:NSDictionary = viaArray[0] as! NSDictionary
        //
        //            let latitude:Double =  locDict.object(forKey: "lat") as! Double
        //            let longitude =  locDict.object(forKey: "long") as! String
        //            DispatchQueue.main.async {
        //
        //                self.carMarker.position = CLLocationCoordinate2DMake(latitude, Double(longitude)!)
        //                self.aMapView.animate(toLocation: CLLocationCoordinate2DMake(latitude, Double(longitude)!))
        //                self.animationFinished = true
        //
        //                CATransaction.begin()
        //                CATransaction.setAnimationDuration(1.0)
        //                let bearing = GMSGeometryHeading(self.carMarker.position, CLLocationCoordinate2DMake(latitude, Double(longitude)!))
        //                self.carMarker.rotation = bearing
        //                CATransaction.commit()
        //            }
        //        }
        //        else{
        
        // Calculate Distance from two location
        let tempLocations:NSMutableArray = NSMutableArray.init()
        
        for (index, element) in viaArray.enumerated() {
            // print("Item \(index): \(element)")
            
            
            let locDict:NSDictionary = element as! NSDictionary
            //print("Location NSDictionary \(locDict)")
            
            
            let latitude:Double =  locDict.object(forKey: "lat") as! Double
            let longitude =  locDict.object(forKey: "long") as! String
            
            if index == 0 {
                
                let oldLocation = CLLocation.init(latitude: self.carMarker.position.latitude, longitude: self.carMarker.position.longitude)
                let newLocation = CLLocation.init(latitude:latitude, longitude: Double(longitude)!)
                
                //                let allPoints = self.getCoordiateBetween(from: oldLocation.coordinate, to: newLocation.coordinate)
                let allPoints = self.getInterPolatePoints(from:  oldLocation.coordinate, to: newLocation.coordinate)
                
                tempLocations.addObjects(from: allPoints)
                //                tempLocations.add(newLocation.coordinate)
            }
            else{
                
                let lastDict = viaArray.object(at: index-1)
                let lastLatitude:Double =  (lastDict as AnyObject).object(forKey: "lat") as! Double
                let latLongitude =  (lastDict as AnyObject).object(forKey: "long") as! String
                
                let oldLocation = CLLocation.init(latitude: lastLatitude, longitude:Double(latLongitude)!)
                let newLocation = CLLocation.init(latitude:latitude, longitude: Double(longitude)!)
                //                let allPoints = self.getCoordiateBetween(from: oldLocation.coordinate, to: newLocation.coordinate)
                
                let allPoints = self.getInterPolatePoints(from:  oldLocation.coordinate, to: newLocation.coordinate)
                
                tempLocations.addObjects(from: allPoints)
                //                tempLocations.add(newLocation.coordinate)
                
            }
        
        }
        
        //print("temp new points \(tempLocations)")
        let path:GMSMutablePath = GMSMutablePath.init()
        for (_, element1) in tempLocations.enumerated() {
            
            let coodinate:CLLocationCoordinate2D = element1 as! CLLocationCoordinate2D
            
            let modal = LocationModal()
            
            
            modal.lat = "\(coodinate.latitude)"
            modal.long = "\(coodinate.longitude)"
            
            // let currentLoc = CLLocation.init(latitude: latitude, longitude:longitude)
            
            //let oldLocation = CLLocation.init(latitude: Double(self.locationArray[index-1].lat)!, longitude: Double(self.locationArray[index-1].long)!)
            
            //self.totalDistance = currentLoc.distance(from: oldLocation)
            
            modal.distance = "\(Int(3.0 / Double(tempLocations.count)))"
            
            self.locationArray.append(modal)
            path.add(coodinate)
            
            
        }
        totalPoints = self.locationArray.count
        if path.count() > 0 {
            // let polyLine:GMSPolyline = GMSPolyline.init(path: path)
            // polyLine.strokeWidth = 5.0
            //    polyLine.geodesic = true
            // polyLine.strokeColor = UIColor.blue
            // polyLine.map = self.aMapView
        }
        //Time lapse buffer 4 seconds
        let lapse = Int(timeLapse)! - 4000
        timeLapse = "\(lapse)"
        
        // print("Time Calculation, timelapse \(timeLapse)")
        
        if self.locationArray.count <= 2 {
            
            
            // let currentLoc = CLLocation.init(latitude: Double(self.locationArray[0].lat)!, longitude: Double(self.locationArray[0].long)!)
            //let oldLocation = CLLocation.init(latitude: Double(self.locationArray[1].lat)!, longitude: Double(self.locationArray[1].long)!)
            
            // self.totalDistance = currentLoc.distance(from: oldLocation)
        }
        
        //  let responseObj = TrackRide.initWithResponse(dictionary: self.responseArray[self.responseArray.count - 1] as! [String : Any])
        // let responseVia = responseObj.via
        
        
        
        if first_Time {
            self.drawInitialPath()
        }
        else{
            if viaArray.count == 0 {
                
                self.animationFinished = true
                self.animationCounter += 1
                return
            }
            else{
                self.animationFinished = false
                
            }
            if self.locationArray.count > 0{
                DispatchQueue.main.async {
                    
                    // 22-Dec Animate to map from Animate Function
                    // let currentLoc = CLLocation.init(latitude: Double(self.locationArray[0].lat)!, longitude: Double(self.locationArray[0].long)!)
                    // let carLoc = CLLocation.init(latitude: self.carMarker.position.latitude, longitude: self.carMarker.position.longitude)
                    
                    
                    //                    if currentLoc.distance(from: carLoc) >= 1000 {
                    //                        self.carMarker.rotation = GMSGeometryHeading(self.carMarker.position, currentLoc.coordinate)
                    //                        self.carMarker.position = currentLoc.coordinate
                    //
                    //                    }
                    
                    //                    self.aMapView.animate(toLocation: currentLoc.coordinate)
                    //self.animationFinished = false
                    self.animation(newPoint: self.locationArray.first!)
                    self.locationArray.removeFirst()
                    
                }
            }
            else{
                self.animationCounter += 1
            }
            
        }
        
        
        //}
        
    }
    
    func getInterPolatePoints(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D) -> [CLLocationCoordinate2D]{
        
        var points = [CLLocationCoordinate2D]()
        var k = 0.0
        
        for _ in 0...10 {
            
            let coordinate = GMSGeometryInterpolate(from, to, k)
            points.append(coordinate)
            k += 0.1
        }
        return points
    }
    
    func getCoordiateBetween(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D) -> [CLLocationCoordinate2D]{
        
        let startPoint = self.aMapView.projection.point(for: from)
        let endPoint = self.aMapView.projection.point(for: to)
        
        let allPoints = self.findAllPointsBetweenTwoPoints(startPoint: startPoint, endPoint: endPoint)
        
        return allPoints
        
    }
    
    func findAllPointsBetweenTwoPoints(startPoint : CGPoint, endPoint : CGPoint)  -> [CLLocationCoordinate2D]{
        
        var allPoints :[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        let deltaX = fabs(endPoint.x - startPoint.x)
        let deltaY = fabs(endPoint.y - startPoint.y)
        
        var x = startPoint.x
        var y = startPoint.y
        var err = deltaX-deltaY
        
        var sx = -0.5
        var sy = -0.5
        if(startPoint.x<endPoint.x){
            sx = 0.5
        }
        if(startPoint.y<endPoint.y){
            sy = 0.5;
        }
        
        repeat {
            let pointObj = CGPoint(x: x, y: y)
            
            let cooridnate = self.aMapView.projection.coordinate(for: pointObj)
            
            allPoints.append(cooridnate)
            
            let e = 2*err
            if(e > -deltaY)
            {
                err -= deltaY
                x += CGFloat(sx)
            }
            if(e < deltaX)
            {
                err += deltaX
                y += CGFloat(sy)
            }
        } while (round(x)  != round(endPoint.x) && round(y) != round(endPoint.y));
        
        
        return allPoints
        
    }
    
    
    func animation(newPoint:LocationModal){
        
        let oldLocation = CLLocation.init(latitude: self.carMarker.position.latitude, longitude: self.carMarker.position.longitude)
        let newLocation = CLLocation.init(latitude: Double(newPoint.lat)!, longitude:  Double(newPoint.long)!)
        
        //let bearing = self.getBearingBetweenTwoPoints1(point1: oldLocation, point2: newLocation)
        let bearing = GMSGeometryHeading(oldLocation.coordinate, newLocation.coordinate)
        //        self.aMapView.animate(toLocation: newLocation.coordinate)
        //        self.carMarker.rotation = CLLocationDegrees(bearing)
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
                    // print("bearingggggg \(bearing)")
                    self.animation(newPoint: self.locationArray.first!)
                    self.locationArray.removeFirst()
                    
                }
                else{
                    self.animationCounter += 1
                    if (self.animationCounter <= self.responseArray.count - 1){
                        self.decodeResult(json: self.responseArray[self.animationCounter])
                        
                    }
                    else{
                        self.animationFinished = true
                        
                    }
                }
            }
            CATransaction.commit()
            
        }
        
        
        
    }
    
    func snap(toMarkerIfItIsOutsideViewport m: GMSMarker) {
        let region: GMSVisibleRegion = self.aMapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region:region)
        if !bounds.contains(m.position) {
            let camera = GMSCameraPosition.camera(withLatitude: m.position.latitude, longitude: m.position.longitude, zoom: self.aMapView.camera.zoom)
            self.aMapView?.animate(to: camera)
        }
    }
    
    
    func degreesToRadians(x: Double) -> Double {
        return Double((.pi * x)  / 180.0)
    }
    func radiansToDegrees(x: Double) -> Double {
        return x * 180.0 / .pi
    }
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        let fLat: Float = Float(degreesToRadians(degrees: fromLoc.latitude))
        let fLng: Float = Float(degreesToRadians(degrees: fromLoc.longitude))
        let tLat: Float = Float(degreesToRadians(degrees: toLoc.latitude))
        let tLng: Float = Float(degreesToRadians(degrees: toLoc.longitude))
        let degree: Float = Float(radiansToDegrees(radians: Double(atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng)))))
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
    
    // MARK: - Animation & Roatation
    
    func initiateAnimation(){
        
        if (self.lastIndex < (self.locationArray.count - 1)){
            
            self.rotateMarker()
        }
        else{
            self.animationFinished = true
            self.animationCounter += 1
        }
        
    }
    
    func rotateMarker(){
        
        let position = CLLocation.init(latitude: Double(self.locationArray[self.lastIndex+1].lat)!, longitude: Double(self.locationArray[self.lastIndex+1].long)!)
        let oldPosition = CLLocation.init(latitude: Double(self.locationArray[self.lastIndex].lat)!, longitude: Double(self.locationArray[self.lastIndex].long)!)
        
        
        let bearing = self.getBearingBetweenTwoPoints1(point1: oldPosition, point2: position)
        
        if (bearing != 0) {
            
            self.currentRotation = Int(bearing)
            print("roateMarker Bearing:\(bearing)")
            self.rotateMarkerWith(carMarker: self.carMarker, bearing: bearing, oldCarMarkBearing: self.carMarker.rotation)
            
            // Update Bearing
            
            self.aMapView.animate(toBearing: bearing)
        }
        else{
            //
            
            let newPoint = CLLocation.init(latitude: Double(self.locationArray[self.lastIndex+1].lat)!, longitude: Double(self.locationArray[self.lastIndex+1].long)!)
            
            // Calculating time for animation between two points
            self.aMapView.animate(toBearing: bearing)
            
            if (self.totalDistance != 0){
                
                let unitTime =  Int(Double(self.timeLapse)! / self.totalDistance!)
                let animationTime = unitTime * Int(self.locationArray[self.lastIndex+1].distance)!
                self.animateMarker(toPostion: newPoint, hideMarker: false, animationTime: Float(animationTime))
            }
            else{
                carMarker.position = newPoint.coordinate
                self.lastIndex += 1
                if (self.lastIndex < (self.locationArray.count - 1)){
                    self.initiateAnimation()
                }
                else if (self.lastIndex == (self.locationArray.count - 1)){
                    self.animationCounter += 1
                    self.animationFinished = true
                    
                    if (self.animationCounter <= self.responseArray.count - 1){
                        self.decodeResult(json: self.responseArray[self.animationCounter])
                    }
                }
                
            }
        }
        
        
    }
    
    func animateMarker(toPostion:CLLocation,hideMarker:Bool,animationTime:Float){
        
        //CLLocation startPoint = self.aMapView.projection.
        
    }
    
    func rotateMarkerWith(carMarker:GMSMarker,bearing:Double,oldCarMarkBearing:Double){
        
        
    }
    
    func drawInitialPath(){
        
        DispatchQueue.main.async {
            
            do {
                let pathData = self.pathString.data(using: String.Encoding.utf8)
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
                polyLine.map = self.aMapView
                
                
                self.driverPoint = CLLocationCoordinate2DMake(Double(self.strDriverLat)!, Double(self.strDriverLong)!)
                self.passengerPoint = CLLocationCoordinate2DMake(Double(self.strPassengerLat)!, Double(self.strPassengerLong)!)
                self.first_Time = false
                
                
                self.driverMarker = GMSMarker.init(position: self.driverPoint)
                self.driverMarker.icon = #imageLiteral(resourceName: "pickup_marker")
                self.driverMarker.map = self.aMapView
                
                self.passengerMarker = GMSMarker.init(position: self.passengerPoint)
                self.passengerMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
                self.passengerMarker.map = self.aMapView
                
                self.carMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(self.strCarLat)!, Double(self.strCarLong)!))
                self.carMarker.icon = #imageLiteral(resourceName: "map_car")
                //self.carMarker.isFlat = true
                self.carMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.carMarker.map = self.aMapView
                
                var bounds = GMSCoordinateBounds.init()
                bounds = bounds.includingCoordinate(self.carMarker.position)
                
                let cameraPosition = GMSCameraUpdate.fit(bounds)
                
                self.aMapView.animate(with: cameraPosition)
                self.aMapView.animate(toZoom: 17)
                
                // To Calculate Bearing for Car marker
                let legs = routeDict.object(forKey: "legs") as! NSArray
                let tempLegs = legs.firstObject as! NSDictionary
                let steps = tempLegs.object(forKey: "steps") as! NSArray
                let polylineDict = steps.firstObject as! NSDictionary
                let polylineSubDict = polylineDict.object(forKey: "polyline") as! NSDictionary
                let polyPoints = polylineSubDict.object(forKey: "points") as! String
                
                let bearingPath = GMSPath.init(fromEncodedPath: polyPoints)
                let totalCoordinate = self.getCoordianteFromPath(path: bearingPath!) as NSArray
                
                // Bearing Calulation if enough coordinates are found in points
                if totalCoordinate.count > 2 {
                    
                    let currentPoint = totalCoordinate.object(at: 0) as! CLLocation
                    let nextPoint = totalCoordinate.object(at: 1) as! CLLocation
                    
                    let bearing = self.getBearingBetweenTwoPoints1(point1: currentPoint, point2: nextPoint)
                    
                    // self.aMapView.animate(toBearing: bearing)
                    // Temporary first time calculation removed
                    //self.carMarker.rotation = bearing
                    
                }
                
                
            }
            catch{
                
            }
        }
    }
    
    func getCoordianteFromPath(path:GMSPath) -> [CLLocation]{
        
        var cooridnates = [CLLocation]()
        
        for index in 0...path.count() {
            
            let coordinate = path.coordinate(at: index)
            let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
            cooridnates.append(location)
        }
        
        return cooridnates
    }
    
    
    // MARK: - Degree To Radian/Radian To Degrees
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
        
    }
    
    @objc func getDriverLocation(){
        
        
        let parameters: Parameters = [
            "userType":"u",
            "lId":Language.getLanguage().id
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Track.driverInBackground, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                //print("Items \(dataAns)")
                
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    //alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    // MARK: - UI Button Actions
    @IBAction func btnBackClicked(_ sender: Any) {
        webSocketClient.close()
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

extension TrackRideNowVC:GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {

        //self.carMarker.rotation = 180 - position.bearing
    }
    
    
}



