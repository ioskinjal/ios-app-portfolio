//
//  HomeVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

import AlamofireImage
import Alamofire
import CoreLocation
import GoogleMaps
import GooglePlaces

class HomeVC: BaseVC {
    
   
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var viewAddress: UIView!{
        didSet{
            viewAddress.layer.borderColor = UIColor.lightGray.cgColor
            viewAddress.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var addressTableView: UITableView!
    
    @IBOutlet weak var aMapView: GMSMapView!
    
    @IBOutlet weak var navView: UIView!
    
     @IBOutlet weak var addressViewHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNavTitle:UILabel!
    
    
    var locationManager = CLLocationManager()
    var pickupMarker = GMSMarker()
    var dropMarker = GMSMarker()
    
    let selectedcellIdentifier  = "carSelectedCell"
    let deSelectedcellIdentifier  = "carDeSelectedCell"
    let addressIdentifier = "addressCell"
    
    
    var carTypes:NSMutableArray = []
    var subCarTypes:NSMutableArray = []
    
    var locations: NSMutableArray = []
    
    var carIndexPath = IndexPath(item: -1, section: 1)
    var subCarIndexPath = IndexPath(item: -1, section: 1)
    
    var pickUpLocation = AddressLocation()
      var dropLocation = AddressLocation()
    
    var searchTimer: Timer?
    
    var loaderTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedAppDelegate().checkDeepLink()
        searchAddressSetup()
        loaderTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.addressValidator), userInfo: nil, repeats: false)
        findMyLocation()
        // Do any additional setup after loading the view.
    }
    
    func searchAddressSetup(){
        let nib = UINib(nibName: "AddressCell", bundle: nil)
        self.addressTableView.register(nib, forCellReuseIdentifier: addressIdentifier)
        
        txtAddress.addTarget(self, action: #selector(processAddress),
                             for: UIControlEvents.editingChanged)
        
    }
    @objc func processAddress(){
        
        // if a timer is already active, prevent it from firing
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchAddress), userInfo:nil, repeats: false)
        
        
        // NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAddress), object: nil)
        // self.perform(#selector(searchAddress), with: Any?.self, afterDelay: 1.5)
        
    }
    
    
    
    @objc func searchAddress(){
        
        if (txtAddress.text?.isEmpty)!{
            return
        }
        else{
            let placesClient = GMSPlacesClient()
            
            placesClient.autocompleteQuery(txtAddress.text!, bounds: nil, filter: nil, callback: {(results, error) -> Void in
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
                        self.addressViewHeightContraint.constant = 200
                        self.view.layoutIfNeeded()
                    }
                    
                }
            })
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblNavTitle.text = appConts.const.tITLE_HOME
    }
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //processDeepLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if loaderTimer != nil{
            loaderTimer?.invalidate()
            loaderTimer = nil
        }
    }
    @objc func addressValidator(){
        
        if (self.txtAddress.text?.isEmpty)!{
            self.stopIndicator()
        }
        
    }
    
    // MARK: - Home setup methods
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Here we start locating
        locationManager.startUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Cars for user
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func navigateToBookNowVC(){
    
        if pickUpLocation.location.isEmpty{
            
            let alert = Alert()
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_PICKUP_LOCATION, buttonTitleStr: appConts.const.bTN_OK)
        }
        else {
        let seletedCarType = carTypes.object(at: carIndexPath.row) as! Car
        let seletedSubCarType = subCarTypes.object(at: subCarIndexPath.row) as! SubCar
        
        let bookNowVC = BookRideNowVC(nibName: "BookRideNowVC", bundle: nil)
        bookNowVC.pickUpLocation = pickUpLocation
        bookNowVC.carType = seletedCarType
        bookNowVC.subCartype = seletedSubCarType
        self.navigationController?.pushViewController(bookNowVC, animated: true)
        }
    }
    
    // MARK: - Fatch address
    
    func getAddress(currentLocation:CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        let coordinate = currentLocation
        
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    self.txtAddress.text = currentAddress
                    self.pickUpLocation.location = currentAddress
                    
                }
                self.stopIndicator()
                
            }
        }
    }
    
    // MARK: - Button Action events
    @IBAction func onClickLocation(_ sender: UIButton) {
       findMyLocation()
    }
    @IBAction func btnMenuClicked(_ sender: Any) {
        openMenu()
    }
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        let validation = Validator()
        let tempLatitude = pickUpLocation.latitude
    
        if !tempLatitude.isEmpty && validation.isNotNull(object: tempLatitude as AnyObject) {
            
            dictParam["pickUpLocation"] = txtAddress.text
            dictParam["pickUpLat"] = pickUpLocation.latitude
            dictParam["pickUpLong"] = pickUpLocation.longitude
            let oopsVC = BookRideNowVC(nibName: "BookRideNowVC", bundle: nil)
            oopsVC.pickUpLocation = pickUpLocation
            self.navigationController?.pushViewController(oopsVC, animated: true)
        }
        else{
            presentLocationAlert()
        }
        
    }
    
    
    // MARK: - Search Location Methods
    

    
    
    
    func getLocation(placeId:String){
        
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            
            if let final = place{
                let currentLocation = final.coordinate
                
                DispatchQueue.main.async {
                  
                    //self.txtAddress.text =  final.formattedAddress!
                    
                    self.pickupMarker.position = currentLocation
                    self.pickupMarker.title = "Pickup"
                    self.pickUpLocation.latitude =  String(format:"%@",final.coordinate.latitude.description)
                    self.pickUpLocation.longitude =  String(format:"%@",final.coordinate.longitude.description)
                   // self.pickUpLocation.location =  final.formattedAddress!
                    
                    let cameraPosition = GMSCameraUpdate.setTarget(currentLocation, zoom: 19.0)
                    self.aMapView.animate(with: cameraPosition)
                }
                
            }
            else{
                // remove search view
            }
            
        }
    }
    

}

extension HomeVC:UITableViewDataSource{
    
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


extension HomeVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prediction:GMSAutocompletePrediction = locations.object(at: indexPath.row) as! GMSAutocompletePrediction
        
        self.getLocation(placeId: prediction.placeID!)
        self.addressViewHeightContraint.constant = 0
        self.txtAddress.text =  prediction.attributedFullText.string
        pickUpLocation.location = prediction.attributedFullText.string
        self.view.layoutIfNeeded()
    }
    
}
// MARK: - Location manager methods

extension HomeVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        let currentLocation = locations.first?.coordinate
        
        pickupMarker.title = appConts.const.LBL_PICKUP
        pickupMarker.position = currentLocation!
        pickupMarker.appearAnimation = .pop
        pickupMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickupMarker.map = aMapView
        
        let cameraPosition = GMSCameraUpdate.setTarget(currentLocation!, zoom: 19.0)
        aMapView.animate(with: cameraPosition)
        
        locationManager.stopUpdatingLocation()
        
        self.pickUpLocation.latitude =  String(format:"%@",(pickupMarker.position.latitude.description))
        self.pickUpLocation.longitude =  String(format:"%@",(pickupMarker.position.longitude.description))
        
        getAddress(currentLocation: pickupMarker.position)
    }
    
    
}
