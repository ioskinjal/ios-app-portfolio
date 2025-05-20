//
//  ProfileVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GoogleMaps

class ProfileVC: BaseVC {
    
    @IBOutlet weak var locationTableView: UITableView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var driverMapView: GMSMapView!
    @IBOutlet weak var lblMyCar:UILabel!
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var btnAddCar:UIButton!
    
    
    let defaultCarCellIdentifier  = "defaultCarCell"
    let carCellIdentifier  = "carCell"
    
    var userProfile = User()
    
    var carTypes:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        loadCars()
        setupMapView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblMyCar.text = appConts.const.lBL_MY_CARS
        getUserProfile()
        btnAddCar.setTitle(appConts.const.bTN_ADD_CAR, for: .normal)
        navTitle.text = appConts.const.pROFILE

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupMapView(){
    
        if sharedAppDelegate().currentLocaton != nil {

        let driverLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake((sharedAppDelegate().currentLocaton?.latitude)!, (sharedAppDelegate().currentLocaton?.longitude)!)
        
            let cameraPosition = GMSCameraUpdate.setTarget(driverLocation, zoom: 17.0)
            self.driverMapView.animate(with: cameraPosition)
            
            let driverMarker = GMSMarker()
            driverMarker.position = driverLocation
            driverMarker.isDraggable = false
            driverMarker.map = self.driverMapView
        }
        
        driverMapView.isMyLocationEnabled = true
        
    }
    
    func setupTable(){
        
        if ((locationTableView) != nil) {
            let nib1 = UINib(nibName: "ProfileDefaultCarCell", bundle: nil)
            locationTableView.register(nib1, forCellReuseIdentifier: defaultCarCellIdentifier)
            
            let nib2 = UINib(nibName: "ProfileCarCell", bundle: nil)
            locationTableView.register(nib2, forCellReuseIdentifier: carCellIdentifier)
            
            locationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            locationTableView.rowHeight  = UITableViewAutomaticDimension
            locationTableView.estimatedRowHeight = 115
            
        }
        
    }
    
    func getUserProfile(){
        
        startIndicator(title: "")
        
        let params: Parameters = ["userId":sharedAppDelegate().currentUser!.uId]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.profile, parameters: params, successBlock: { (json, urlResponse) in
            
            
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
                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                print("Items \(dataAns)")
                
                let person = User.initWithResponse(dictionary: userDict as? [String : Any])
                self.userProfile = person
                DispatchQueue.main.async {
                    
                    self.displayUser(loggedInUser: person)
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
        
    }
    
    func displayUser(loggedInUser:User){
        
        lblName.text = String(format:"%@ %@",loggedInUser.firstName,loggedInUser.lastName)
        lblMobileNumber.text = loggedInUser.mobileNo
        lblEmail.text = loggedInUser.email
        
        sharedAppDelegate().currentUser = loggedInUser
       // User.saveUser(loggedUser: loggedInUser)
        
        let profileImage = String(format:"%@/%@/%@",URLConstants.Domains.profileUrl,(sharedAppDelegate().currentUser?.uId)!,(sharedAppDelegate().currentUser?.profileImage)!)

        self.profileImgView.af_setImage(withURL: URL(string: profileImage)!)
        self.profileImgView.applyCorner(radius: self.profileImgView.frame.size.width/2)
        self.profileImgView.clipsToBounds = true
        
         locationTableView.reloadData()
        
    }
    
    func deleteCar(deleteCar:Car){
        
        startIndicator(title: "")
        
        
        let params: Parameters = ["driverId":sharedAppDelegate().currentUser!.uId,"carId":deleteCar.carId]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.deleteCar, parameters: params, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr:message, buttonTitleStr: appConts.const.bTN_OK)
                    self.loadCars()
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
    }
    
    // MARK: - Get Cars for user
    func loadCars(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = ["userId":sharedAppDelegate().currentUser?.uId as Any]
        
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
                    
                
                DispatchQueue.main.async {
                    
                    self.locationTableView.reloadData()
                    self.stopIndicator()
                }
            }
            else{
                DispatchQueue.main.async {
                    self.carTypes = []
                    self.locationTableView.reloadData()

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
    
    
    // MARK: - Button events
  
    
    @IBAction func btnEditCarClicked(_sender:UIButton){
      
        let editedCar:Car = self.carTypes.object(at: _sender.tag) as! Car
        navigateToAddCarVC(editMode: true, selectedCar: editedCar)
        
    }
    
    @IBAction func btnDeleteCarClicked(_sender:UIButton){
     
        let editedCar:Car = self.carTypes.object(at: _sender.tag) as! Car

        let alert = Alert()

        
        if self.carTypes.count > 1 && editedCar.isDefault == "n"{
            
            alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: appConts.const.mSG_DELETE_CAR, leftButtonTitle: appConts.const.bTN_YES, rightButtonTitle: appConts.const.bTN_NO, leftCompletionBlock: {
                self.deleteCar(deleteCar: editedCar)
            }, rightCompletionBlock: {
                
            })
        }
        else{
            // Not allow to delete default car or if only one car is available
            if editedCar.isDefault == "y"{
                //FIXME:- chnage alert message
                alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_DELETE_DEFAULT_CAR, buttonTitleStr: appConts.const.bTN_OK)
            }

            else{
                alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_ONLY_CAR, buttonTitleStr: appConts.const.bTN_OK)

            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        openMenu()
    }
    
    @IBAction func btnEditProfileClicked(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    @IBAction func btnMyLocationClicked(_ sender: Any) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func btnAddCarClicked(_ sender: Any) {
        navigateToAddCarVC(editMode: false, selectedCar: Car())
    }
    
    func navigateToAddCarVC(editMode:Bool,selectedCar:Car){
        
        let carControllerVC = AddEditCar(nibName: "AddEditCar", bundle: nil)
        carControllerVC.delegate = self
        if editMode {
            carControllerVC.editedCar = selectedCar
        }
        self.addChildViewController(carControllerVC)
        view.addSubview(carControllerVC.view)
        

        carControllerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint =  NSLayoutConstraint(item: carControllerVC.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint =  NSLayoutConstraint(item: carControllerVC.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint =  NSLayoutConstraint(item: carControllerVC.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        let bottomConstraint =  NSLayoutConstraint(item: carControllerVC.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        self.view.layoutIfNeeded()
        
        carControllerVC.didMove(toParentViewController: self)
        
    }
    
    
}

// MARK:- Tableview datasource methods
extension ProfileVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115;
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.carTypes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let car:Car = self.carTypes.object(at: indexPath.row) as! Car
        
        if car.isDefault.lowercased() == "y" {
            var cell = tableView.dequeueReusableCell(withIdentifier: defaultCarCellIdentifier, for: indexPath) as? ProfileDefaultCarCell
            if cell == nil {
                cell = ProfileDefaultCarCell(style: UITableViewCellStyle.default, reuseIdentifier: defaultCarCellIdentifier)
            }
            
            
            cell?.lblBrand.text = car.subTypeName
            cell?.lblCarName.text = "\(car.brandName) \(car.carName)"
            cell?.lblCarNumber.text = car.carNumber
            if let url = URL(string: URLConstants.Domains.CarUrl + "\(car.carTypeId)/" + car.typeImage){
                cell?.carIcon.af_setImage(withURL: url)
            }

            cell?.editBtn.tag = indexPath.row
            cell?.deleteBtn.tag = indexPath.row
            
            cell?.editBtn.addTarget(self, action: #selector(btnEditCarClicked(_sender:)), for: .touchUpInside)
            cell?.deleteBtn.addTarget(self, action: #selector(btnDeleteCarClicked(_sender:)), for: .touchUpInside)
            
            
            return cell!
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: carCellIdentifier, for: indexPath) as? ProfileCarCell
            if cell == nil {
                cell = ProfileCarCell(style: UITableViewCellStyle.default, reuseIdentifier: carCellIdentifier)
            }
            
            cell?.editBtn.tag = indexPath.row
            cell?.deleteBtn.tag = indexPath.row
            
            cell?.lblCarBrand.text = car.subTypeName
            cell?.lblCarName.text = "\(car.brandName) \(car.carName)"
            cell?.lblCarNumber.text = car.carNumber
            if let url = URL(string: URLConstants.Domains.CarUrl + "\(car.carTypeId)/" + car.typeImage){
                cell?.carIcon.af_setImage(withURL: url)
            }
            cell?.editBtn.addTarget(self, action: #selector(btnEditCarClicked(_sender:)), for: .touchUpInside)
            cell?.deleteBtn.addTarget(self, action: #selector(btnDeleteCarClicked(_sender:)), for: .touchUpInside)
            
            
            return cell!
        }
   
    }
}


extension ProfileVC:AddCarDelegate {

    func dismissCarClicked() {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? ProfileVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        self.loadCars()
        
    }
    
}

