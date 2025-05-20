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

class HomeVC: BaseVC {
    
    @IBOutlet weak var goOnlineBtn: UIButton!
    @IBOutlet weak var goOfflineBtn: UIButton!
    
    @IBOutlet weak var carTableView: UITableView!
    @IBOutlet weak var lblHome:UILabel!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    
    let selectedcellIdentifier  = "carSelectedCell"
    let deSelectedcellIdentifier  = "carDeSelectedCell"
    
    
    var carTypes:NSMutableArray = []
    var carIndexPath = IndexPath(item: -1, section: 1)
    
    var isOnline = ""
    var isUnderRide = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
       // navigateToNewRideRequest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        tableSetup()
         findMyLocation()
        loadCars()
        getPartnerStatus()
        sharedAppDelegate().checkDeepLink()
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
    
    func tableSetup(){
        
        if ((carTableView) != nil) {
            let nib = UINib(nibName: "CarSelectedCell", bundle: nil)
            carTableView.register(nib, forCellReuseIdentifier: selectedcellIdentifier)

            let nib1 = UINib(nibName: "CarDeselectedCell", bundle: nil)
            carTableView.register(nib1, forCellReuseIdentifier: deSelectedcellIdentifier)
            
            carTableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeader")

            carTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            carTableView.rowHeight  = UITableViewAutomaticDimension
            carTableView.estimatedRowHeight = 110
            
            carTableView.estimatedSectionHeaderHeight = 40
            carTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Home setup methods
    func findMyLocation() {
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        // Here we start locating
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Partener Status
    func getPartnerStatus(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = ["driverId":sharedAppDelegate().currentUser?.uId as Any,"lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Partener.partnerStatus, parameters: parameters, successBlock: { (json, urlResponse) in
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary

                print("Response Dict \(userDict)")
                
                 self.isOnline = String(format:"%@", userDict.object(forKey: "isOnline") as! CVarArg)
                self.isUnderRide = String(format:"%@", userDict.object(forKey: "isUnderRide") as! CVarArg)
               // let lastRideId:String = String(format:"%@", userDict.object(forKey: "lastRideId") as! CVarArg)
                
               // print(lastRideId)
                
                if self.isUnderRide.lowercased() == "y" {
                    UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isUnderRide)

                }
                else{
                    UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isUnderRide)

                }
                
                if self.isOnline.lowercased() == "y" {
                UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isOnline)
                }
                else{
                    UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isOnline)

                }
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                                      
                    if self.isOnline.lowercased() == "y"{
                        self.goOfflineBtn.isHidden = false
                        self.goOnlineBtn.isHidden = true
                    }
                    else{
                        self.goOfflineBtn.isHidden = true
                        self.goOnlineBtn.isHidden = false
                    }
                    self.carTableView.reloadData()
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    self.carIndexPath = IndexPath(item: -1, section: 1)
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    // MARK: - Get Cars for user
    func loadCars(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = ["userId":sharedAppDelegate().currentUser?.uId as Any,"lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getCars, parameters: parameters, successBlock: { (json, urlResponse) in
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                print("Items \(dataAns)")
                
                let cars = Car.initWithResponse(array: (dataAns as! [Any]))
                
                self.carTypes = (cars as NSArray).mutableCopy() as! NSMutableArray
                
                for (index,element) in self.carTypes.enumerated() {
                    
                    let car:Car  = element as! Car
                    
                    if car.selected.lowercased() == "y" {
                        self.carIndexPath = IndexPath.init(row: index, section: 0)
                        UserDefaults.standard.set(car.carId, forKey: ParamConstants.Defaults.carId)
                        UserDefaults.standard.synchronize()
                        break
                    }
                    if car.isDefault.lowercased() == "y"{
                        UserDefaults.standard.set(car.carId, forKey: ParamConstants.Defaults.carId)
                        UserDefaults.standard.synchronize()
                    }
                    
                }
                DispatchQueue.main.async {
                    
                    self.carTableView.reloadData()
                    self.stopIndicator()
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    self.carIndexPath = IndexPath(item: -1, section: 1)
                    self.carTableView.reloadData()
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    // MARK: - GoOnline
    func goOnline(){
        
        startIndicator(title: "")
        
        let car:Car = self.carTypes.object(at: self.carIndexPath.row) as! Car
        let parameters: Parameters = [
            "driverId":sharedAppDelegate().currentUser?.uId as Any,
            "carId":car.carId,
            "driverLat":sharedAppDelegate().currentLocaton?.latitude.description ?? "",
            "driverLong":sharedAppDelegate().currentLocaton?.longitude.description ?? "",
            "lId":Language.getLanguage().id
            
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.OnlineOffline.partnerGoOnline, parameters: parameters, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                DispatchQueue.main.async {
            
                    self.isOnline = "y"
                    self.stopIndicator()
                    self.carTableView.reloadData()

                    self.goOnlineBtn.isHidden = true
                    self.goOfflineBtn.isHidden = false
                    
                    
                    UserDefaults.standard.set(car.carId, forKey: ParamConstants.Defaults.carId)
                    UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isOnline)
                    UserDefaults.standard.synchronize()
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    self.carIndexPath = IndexPath(item: -1, section: 1)
                    self.carTableView.reloadData()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_YES)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    // MARK: - GoOnline
    func goOffline(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "driverId":sharedAppDelegate().currentUser?.uId as Any,
            "driverLat":sharedAppDelegate().currentLocaton?.latitude.description ?? "",
            "driverLong":sharedAppDelegate().currentLocaton?.longitude.description ?? "",
            "lId":Language.getLanguage().id
            
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.OnlineOffline.partnerGoOffline, parameters: parameters, successBlock: { (json, urlResponse) in
            self.stopIndicator()

            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                DispatchQueue.main.async {
                    
                    self.isOnline = "n"
                    self.stopIndicator()
                    self.carIndexPath = IndexPath.init(row: -1, section: 0)
                    self.carTableView.reloadData()
                    
                    self.goOnlineBtn.isHidden = false
                    self.goOfflineBtn.isHidden = true
                    self.carTableView.isUserInteractionEnabled = true
                
                    UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isOnline)
                     UserDefaults.standard.synchronize()
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    self.carIndexPath = IndexPath(item: -1, section: 1)
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    // MARK: - Button Action events
    
    @IBAction func btnOnlineClicked(_ sender: Any) {
        
        if self.carIndexPath.row >= 0 {
            goOnline()
        }
        else{
            let alert = Alert()
            alert.showAlert(titleStr: "", messageStr: appConts.const.cAR_SELECT, buttonTitleStr: appConts.const.bTN_OK)
        }
    }
    
    @IBAction func btnGoOfflineClicked(_ sender: Any) {
        
        if self.isUnderRide.lowercased() == "y"{
        
            let alert = Alert()
            alert.showAlert(titleStr: "", messageStr: appConts.const.cANNOT_OFFLINE, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
        goOffline()
        }
    }
    @IBAction func btnMenuClicked(_ sender: Any) {
        openMenu()
        
    }
    
    // MARK: - Navigaiton methods
    func navigateToNewRideRequest(){
        
        let rideAcceptVc = RideAcceptRejectVC(nibName: "RideAcceptRejectVC", bundle: nil)
        self.navigationController?.pushViewController(rideAcceptVc, animated: true)
    }
    
    
}
// MARK: - Location manager methods
    extension HomeVC:CLLocationManagerDelegate{
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            print(locations)
            
          //  let currentLocation = locations.first?.coordinate
            

        }
    }
    
    // MARK: - Collectionview methods
    extension HomeVC:UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return carTypes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let car:Car = self.carTypes.object(at: indexPath.row) as! Car
            
            if indexPath.row == self.carIndexPath.row {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: selectedcellIdentifier, for: indexPath) as? CarSelectedCell
                
                if cell == nil {
                    cell = CarSelectedCell(style: UITableViewCellStyle.default, reuseIdentifier: selectedcellIdentifier)
                }
                
                cell?.displaySelectedData(car: car)
                return cell!

            }
            else{
                var cell = tableView.dequeueReusableCell(withIdentifier: deSelectedcellIdentifier, for: indexPath) as? CarDeselectedCell
                
                if cell == nil {
                    cell = CarDeselectedCell(style: UITableViewCellStyle.default, reuseIdentifier: deSelectedcellIdentifier)
                }
                
                cell?.displayDeSelectedData(car: car)
                return cell!

            }
            
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! HeaderView
            headerView.lblSelecteCar.text = appConts.const.lBL_SELECT_CAR
            let bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            headerView.backgroundView = bgView
                return headerView

            }
            else{
                let headerView = UIView.init()
                return headerView

            }
            
        }
        
    }

extension HomeVC:UITableViewDelegate{
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if self.isOnline.lowercased() == "y" {
                
            }
            else{
                if self.carIndexPath.row != indexPath.row{
                    self.carIndexPath = indexPath
                    self.carTableView.reloadData()
                }
            }
            
        }
    
}


