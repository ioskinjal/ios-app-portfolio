 //
 //  BookRideNowVC.swift
 //  BooknRide
 //
 //  Created by NCrypted on 01/11/17.
 //  Copyright © 2017 NCrypted Technologies. All rights reserved.
 //
 
 import UIKit
 import GoogleMaps
 import GooglePlaces
 import Alamofire
 import Toast_Swift
 import LinearProgressBarMaterial
 
 class BookRideNowVC: BaseVC {
    
    let addressIdentifier = "addressCell"
    var locations = NSMutableArray.init()
    var strPickupLocation = String()
    
    let linearBar: LinearProgressBar = LinearProgressBar()
    
    var pickUpMarker = GMSMarker()
    var dropMarker = GMSMarker()
    
    var pickUpLocation = AddressLocation()
    var dropLocation = AddressLocation()
    
    var carType = Car()
    var subCartype = SubCar()
    
    var fareEstimate = FareEstimate()
    
    var isCash = Bool()
    
    var searchTimer:Timer?
    
    var defaultPaymentMethod = "c"
    
    @IBOutlet weak var viewPickUp: UIView!{
        didSet{
            viewPickUp.layer.borderColor = UIColor.lightGray.cgColor
            viewPickUp.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var viewDrop: UIView!{
        didSet{
            viewDrop.layer.borderColor = UIColor.lightGray.cgColor
            viewDrop.layer.borderWidth = 1.0
        }
    }
    
    
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var txtDropAddress: UITextField!
    
    @IBOutlet weak var aMapView: GMSMapView!
    
    @IBOutlet weak var addressTableView: UITableView!
    
    
    @IBOutlet weak var addressViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNavTitle: UILabel!
    
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
        
        mapSetup()
       // btnCashClicked((Any).self)
        tableSetup()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDefaultPaymentMethod()
    }
    
    func mapSetup(){
        
        let pickupCoordinate = CLLocationCoordinate2D(latitude:Double(pickUpLocation.latitude)!, longitude: Double(pickUpLocation.longitude)!)
        
        pickUpMarker.position = pickupCoordinate
        pickUpMarker.title = pickUpLocation.location
        pickUpMarker.appearAnimation = .pop
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.map = aMapView
        
        let cameraPosition = GMSCameraUpdate.setTarget(pickupCoordinate, zoom: 19.0)
        aMapView.delegate = self
        aMapView.animate(with: cameraPosition)
        
        lblPickupAddress.text = pickUpLocation.location
        
        
    }
    
    func tableSetup(){
        
        let nib = UINib(nibName: "AddressCell", bundle: nil)
        addressTableView.register(nib, forCellReuseIdentifier: addressIdentifier)
        
        txtDropAddress.addTarget(self, action: #selector(processAddress),
                                 for: UIControlEvents.editingChanged)
    }
    
    func getFareEstimate(isBooking:Bool){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "carTypeId":self.carType.typeId,
                "subCarTypeId":self.subCartype.typeId,
                "pickupLat":self.pickUpLocation.latitude,
                "pickupLong":self.pickUpLocation.longitude,
                "dropoffLat":self.dropLocation.latitude,
                "dropoffLong":self.dropLocation.longitude,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Fare.estimate, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let fareDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    print("Items \(fareDict)")
                    
                    // Removing lastSendId inorder to create new booking
                    UserDefaults.standard.removeObject(forKey:"lastSendId")
                    UserDefaults.standard.synchronize()
                    self.fareEstimate = FareEstimate.initWithResponse(dictionary: (fareDict as! [String : Any]))
                    self.fareEstimate.pickUpLocation = self.lblPickupAddress.text!
                    self.fareEstimate.dropOffLocation = self.txtDropAddress.text!
                    if isBooking{
                        self.bookRide()
                    }
                    else{
                        // remove the loader for fare estiamte event
                        self.displayFareEstimate(fare: self.fareEstimate)
                    }
                    DispatchQueue.main.async {
                        
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.fareEstimate = FareEstimate()
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr:appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func bookRide(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: appConts.const.mSG_FETCH_DRIVER)
            
            //Simply, Call Progress Bar
            
            //Change background color
            //self.linearBar.backgroundColor = UIColor.gray
            // self.linearBar.progressBarColor = UIColor.white
            
            //Change height of progressBar
            // self.linearBar.heightForLinearBar = 5
            
            //Start Animation
            // self.linearBar.startAnimation()
            
            
            let parameters: Parameters = [
                "custId":sharedAppDelegate().currentUser!.uId,
                "carTypeId":self.carType.typeId,
                "subCarTypeId":self.subCartype.typeId,
                "paymentType":(isCash ? "c" : "w"),
                "pickUpLat":self.pickUpLocation.latitude,
                "pickUpLong":self.pickUpLocation.longitude,
                "pickUpLocation":self.pickUpLocation.location,
                "dropOffLat":self.dropLocation.latitude,
                "dropOffLong":self.dropLocation.longitude,
                "dropOffLocation":self.dropLocation.location,
                "totalDistance":self.fareEstimate.totalDistance,
                "fareDistance":String(self.fareEstimate.fareDistance),
                "fareAdditionalKm":self.fareEstimate.estimateExtraKm,
                "fareTime":String(self.fareEstimate.fareTime),
                "fareDistanceCharges":String(self.fareEstimate.fareDistanceCharges),
                "fareAdditionalCharges":String(self.fareEstimate.fareAdditionalCharges),
                "fareTimeCharges":String(self.fareEstimate.fareTimeCharges),
                "totalExtraCharges":self.fareEstimate.totalExtraCharges,
                "ridePathString":self.fareEstimate.ridePathString,
                "isLongRide":self.fareEstimate.isLongRide,
                "lId":String(Language.getLanguage().id)
            ]

            
            
            let alert = Alert()
            WSManager.getResponseFromDefaultEncoding(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Book.confirmRide, parameters: parameters, successBlock: { (json, urlResponse) in
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let tripDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    print("tripInfo \(tripDict)")
                    
                    DispatchQueue.main.async {
                        // self.stopIndicator()
                        
                        // Removing lastSendId inorder to create new booking
                        UserDefaults.standard.removeObject(forKey:"lastSendId")
                        UserDefaults.standard.synchronize()
                        
                        
                        let loaderView = self.view.window?.viewWithTag(99)
                        loaderView?.makeToast(message)
                        
                        // alert.showAlert(titleStr: "Message", messageStr: message, buttonTitleStr: "OK")
                        
                        // Start Checking if request is accepted.
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.stopIndicator()
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
    
    func getDefaultPaymentMethod(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.defaultPaymentMethod, parameters: parameters, successBlock: { (json, urlResponse) in
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let tripDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    self.defaultPaymentMethod = tripDict.object(forKey: "defaultPaymentMethod") as? String ?? "c"
                    
                    print("tripInfo \(dataAns)")
                    
                    DispatchQueue.main.async {
                        
                        if self.defaultPaymentMethod.lowercased() == "c"{
                            //self.btnCashClicked((Any).self)
                        }
                        else if self.defaultPaymentMethod.lowercased() == "w"{
                            //self.btnWalletClicked((Any).self)
                        }
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.stopIndicator()
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
    
    func checlWalletAmount(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.checkWalletAmount, parameters: parameters, successBlock: { (json, urlResponse) in
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    
                    DispatchQueue.main.async {

                        if let walletEmpty:String = jsonDict?.object(forKey: "walletEmpty") as? String{
                        
                        if walletEmpty.lowercased() == "y" {
                            // Go to Deposit Screen
                            let depositController = DepositFundVC(nibName: "DepositFundVC", bundle: nil)
                            self.navigationController?.pushViewController(depositController, animated: true)

                        }
                        else{
                            self.getFareEstimate(isBooking: true)
                        }
                    }
                    
                    
                    
                      
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.stopIndicator()
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func processAddress(){
        
        // if a timer is already active, prevent it from firing
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchAddress), userInfo:nil, repeats: false)
        
        //        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchAddress), userInfo: nil, repeats: false)
    }
    
    @objc func searchAddress(){
        
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(txtDropAddress.text!, bounds: nil, filter: nil, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                
                if self.locations.count>0 {
                    self.locations.removeAllObjects()
                }
                self.locations.addObjects(from: results)
                DispatchQueue.main.async {
                    self.addressTableView.reloadData()
                    self.addressViewHeightConstraint.constant = 200
                    self.view.layoutIfNeeded()
                }
                
            }
        })
        
    }
    
    
    func getLocation(placeId:String){
        
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            
            if let final = place{
                let currentLocation = final.coordinate
                
                
                DispatchQueue.main.async {
                    
                   // self.txtDropAddress.text = final.name + "," + final.formattedAddress!
                    
                    self.dropMarker.position = currentLocation
                    self.dropMarker.appearAnimation = .pop
                    self.dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
                    self.dropMarker.map = self.aMapView
                    
                    self.dropLocation.latitude =  String(format:"%@",final.coordinate.latitude.description)
                    self.dropLocation.longitude =  String(format:"%@",final.coordinate.longitude.description)
                   // self.dropLocation.location = final.name + "," + final.formattedAddress!
                    
                    
                    let bounds = GMSCoordinateBounds.init(coordinate: self.pickUpMarker.position, coordinate: self.dropMarker.position)
                    //                    let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 270, left: 40, bottom: 200, right: 40))
                    let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 270, left: 40, bottom: 10, right: 40))
                    self.aMapView.animate(with: cameraPosition)
                }
                
                
            }
            else{
                // remove search view
            }
            
        }
    }
    
    func displayFareEstimate(fare:FareEstimate){
        
        let fareController = FareEstimateVC(nibName: "FareEstimateVC", bundle: nil)
        fareController.delegate = self
        fareController.fare = fare
        self.addChildViewController(fareController)
        view.addSubview(fareController.view)
        
        fareController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint =  NSLayoutConstraint(item: fareController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint =  NSLayoutConstraint(item: fareController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint =  NSLayoutConstraint(item: fareController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        let bottomConstraint =  NSLayoutConstraint(item: fareController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        self.view.layoutIfNeeded()
        
        fareController.didMove(toParentViewController: self)
        
    }
    // MARK: - Button events
    
    @IBAction func btnFareEstimateClicked(_ sender: Any) {
        
        if dropLocation.latitude.isEmpty || dropLocation.location.isEmpty {
            
            let alert = Alert()
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_INVALID_DROP_LOC, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            getFareEstimate(isBooking: false)
        }
    }
    
    
    @IBAction func btnGetLocationsClicked(_ sender: Any) {
        
        self.txtDropAddress.resignFirstResponder()
        let locationController = LocationsVC(nibName: "LocationsVC", bundle: nil)
        locationController.delegate = self
        self.addChildViewController(locationController)
        view.addSubview(locationController.view)
        locationController.view.isHidden = true
        locationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint =  NSLayoutConstraint(item: locationController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint =  NSLayoutConstraint(item: locationController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint =  NSLayoutConstraint(item: locationController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        let bottomConstraint =  NSLayoutConstraint(item: locationController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        self.view.layoutIfNeeded()
        
        locationController.didMove(toParentViewController: self)
        
    }
    
    
    @IBAction func btnBookRideClicked(_ sender: Any) {
        
        if dropLocation.latitude.isEmpty || dropLocation.location.isEmpty {
            
            let alert = Alert()
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_INVALID_DROP_LOC, buttonTitleStr: appConts.const.bTN_OK)
        }
       else{
            dictParam["dropOffLocation"] = dropLocation.location
            dictParam["dropOffLat"] = dropLocation.latitude
            dictParam["dropOffLong"] = dropLocation.longitude
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let requestRideVC2 = storyBoard.instantiateViewController(withIdentifier: "RideRequestStep2VC") as! RideRequestStep2VC
            self.navigationController?.pushViewController(requestRideVC2, animated: true)
            }
            
        }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
    }
 }
 
 extension BookRideNowVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: addressIdentifier, for: indexPath) as? AddressCell
        
        if cell == nil {
            cell = AddressCell(style: UITableViewCellStyle.default, reuseIdentifier: addressIdentifier)
        }
        
        let prediction:GMSAutocompletePrediction = locations.object(at: indexPath.row) as! GMSAutocompletePrediction
        cell?.lblAddress.text = prediction.attributedFullText.string
        
        return cell!
        
    }
    
 }
 
 extension BookRideNowVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prediction:GMSAutocompletePrediction = locations.object(at: indexPath.row) as! GMSAutocompletePrediction
        
        
        self.txtDropAddress.resignFirstResponder()
        self.addressViewHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
        self.txtDropAddress.text = prediction.attributedFullText.string
        dropLocation.location = prediction.attributedFullText.string
        self.getLocation(placeId: prediction.placeID!)
        
    }
    
 }
 
 extension BookRideNowVC:LocationDelegate{
    
    func didSelectLocation(isHome: Bool) {
        
        clearLocationView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if isHome {
            
            let homeLocation = AddressLocation()
            homeLocation.latitude = (appDelegate.currentUser?.homeLat)!
            homeLocation.longitude = (appDelegate.currentUser?.homeLong)!
            homeLocation.location = (appDelegate.currentUser?.homeLocation)!
            animateToLocation(selectedLocation: homeLocation)
        }
        else{
            let workLocation = AddressLocation()
            workLocation.latitude = (appDelegate.currentUser?.workLat)!
            workLocation.longitude = (appDelegate.currentUser?.workLong)!
            workLocation.location = (appDelegate.currentUser?.workLocation)!
            animateToLocation(selectedLocation: workLocation)
        }
    }
    
    func dismissLocation() {
        
        clearLocationView()
    }
    
    func clearLocationView(){
        
        if let nav = self.navigationController, let locationVC = nav.topViewController as? BookRideNowVC {
            
            if locationVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let locationView =  locationVC.childViewControllers[0]
                    
                    locationView.willMove(toParentViewController: self)
                    locationView.view.removeFromSuperview()
                    locationView.removeFromParentViewController()
                }
            }
        }
    }
    
    func animateToLocation(selectedLocation:AddressLocation){
        
        self.txtDropAddress.text = selectedLocation.location
        
        let currentLocation = CLLocationCoordinate2DMake(Double(selectedLocation.latitude)!, Double(selectedLocation.longitude)!)
        
        self.dropMarker.position = currentLocation
        self.dropMarker.title = selectedLocation.location
        self.dropMarker.appearAnimation = .pop
        self.dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        self.dropMarker.map = self.aMapView
        
        self.dropLocation.latitude =  selectedLocation.latitude
        self.dropLocation.longitude = selectedLocation.longitude
        self.dropLocation.location = selectedLocation.location
        
        
        let bounds = GMSCoordinateBounds.init(coordinate: self.pickUpMarker.position, coordinate: self.dropMarker.position)
        //        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 270, left: 40, bottom: 150, right: 40))
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50))
        
        self.aMapView.animate(with: cameraPosition)
        
        
    }
 }
 
 
 extension BookRideNowVC:FareEstimateDelegate{
    
    func dimissFareEstimateClicked() {
        
        if let nav = self.navigationController, let bookNowVC = nav.topViewController as? BookRideNowVC {
            
            if bookNowVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let fareEstimateVC =  bookNowVC.childViewControllers[0]
                    
                    fareEstimateVC.willMove(toParentViewController: self)
                    fareEstimateVC.view.removeFromSuperview()
                    fareEstimateVC.removeFromParentViewController()
                }
            }
        }
        
    }
    
 }
 
 extension BookRideNowVC:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.getAddress(fromLocation: coordinate) { (selectedAddress) in
            
            let dropLocation = AddressLocation()
            dropLocation.latitude = coordinate.latitude.description
            dropLocation.longitude = coordinate.longitude.description
            dropLocation.location = selectedAddress
            self.animateToLocation(selectedLocation: dropLocation)
            
            DispatchQueue.main.async {
                self.addressViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.view.endEditing(true)
            }
            
        }
    }
    
    // Reverse Geocode for Tapping location(Drop Off location) on map
    func getAddress(fromLocation:CLLocationCoordinate2D,currentAdd : @escaping ( _ returnAddress :String)->Void){
        
        let geocoder = GMSGeocoder()
        let coordinate = fromLocation
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                
                currentAdd(currentAddress)
            }
        }
    }
    
 }
