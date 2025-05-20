//
//  FavoriteVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire

class FavoriteVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var aMapView: GMSMapView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var addressViewHeightConstraint: NSLayoutConstraint! //200
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    
    let addressIdentifier = "addressCell"
    
    public var isHomelocation = false
    
    var locationManager = CLLocationManager()
    var pickupMarker = GMSMarker()
    
    var locations = NSMutableArray.init()
    
    var latitude = ""
    var longitude = ""
    
    var searchTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if isHomelocation == true {
            lblTitle.text = appConts.const.hOME_LOC
        }
        else{
            lblTitle.text = appConts.const.wORK_LOC
        }
        let nib = UINib(nibName: "AddressCell", bundle: nil)
        addressTable.register(nib, forCellReuseIdentifier: addressIdentifier)
        
        locationView.applyBorder(color: UIColor.lightGray, width: 1.0)
        
        txtAddress.addTarget(self, action: #selector(processAddress),
                             for: UIControlEvents.editingChanged)
        
        findMyLocation()
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Home setup methods
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        // Here we start locating
        locationManager.startUpdatingLocation()
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
        
        if self.locations.count>0 {
            self.locations.removeAllObjects()
        }
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
                    self.addressTable.reloadData()
                    self.addressViewHeightConstraint.constant = 200
                    self.view.layoutIfNeeded()
                }
                //                for result in results {
                //                    print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID))")
                //
                //
                //
                //                }
                
                
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
                    
                }
            }
            
            
        }
    }
    
    func getLocation(placeId:String){
        
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            
            if let final = place{
                let currentLocation = final.coordinate
                
                
                DispatchQueue.main.async {
                    
                    self.txtAddress.text = final.formattedAddress
                    
                    self.pickupMarker.position = currentLocation
                    self.latitude =  "\(final.coordinate.latitude)"
                    
                    self.longitude =  "\(final.coordinate.longitude)"
                    
                    let cameraPosition = GMSCameraUpdate.setTarget(currentLocation, zoom: 19.0)
                    self.aMapView.animate(with: cameraPosition)
                }
                
                
            }
            else{
                // remove search view
            }
            
        }
    }
    
    func updateLocation(){
        
        if NetworkManager.isNetworkConneted(){
            var locationKey = ""
            var latitudeKey = ""
            var longitudeKey = ""
            var locationType = ""
            if isHomelocation == true {
                locationKey = "homeLocation"
                latitudeKey = "homeLat"
                longitudeKey = "homeLong"
                locationType = "home"
            }
            else{
                locationKey = "workLocation"
                latitudeKey = "workLat"
                longitudeKey = "workLong"
                locationType = "work"
            }
            
            
            
            let params: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "locationType":locationType,
                locationKey: String(format:"%@",txtAddress.text!),
                latitudeKey: String(format:"%@",self.latitude),
                longitudeKey: String(format:"%@",self.longitude),
                "lId":Language.getLanguage().id
                
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.editLocation, parameters: params, successBlock: { (json, urlResponse) in
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        alert.showAlertWithCompletionHandler(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
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
    
    @IBAction func btnSaveLocationClicked(_ sender: Any) {
        
        let valid = Validator()
        
        
        if valid.isNotNull(object: txtAddress.text as AnyObject){
            updateLocation()
        }
        else{
            let alert = Alert()
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.MSG_SELECT_LOCATION    , buttonTitleStr: appConts.const.bTN_OK)
            
        }
        
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
    }
}

extension FavoriteVC:UITableViewDataSource{
    
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

extension FavoriteVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prediction:GMSAutocompletePrediction = locations.object(at: indexPath.row) as! GMSAutocompletePrediction
        
        self.getLocation(placeId: prediction.placeID!)
        
        self.txtAddress.resignFirstResponder()
        self.addressViewHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
}


extension FavoriteVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.placeID))")
        //dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

// MARK: - Location manager methods

extension FavoriteVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        let currentLocation = locations.first?.coordinate
        
        pickupMarker.position = currentLocation!
        pickupMarker.appearAnimation = .pop
        pickupMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickupMarker.map = aMapView
        
        let cameraPosition = GMSCameraUpdate.setTarget(currentLocation!, zoom: 19.0)
        aMapView.animate(with: cameraPosition)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
}
