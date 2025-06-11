//
//  AddEventLocation.swift
//  Luxongo
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class AddEventLocation: UIViewController {

    //MARK: Variables
    var lat:String?
    var long:String?
    var addrCountry: String?
    var addrState: String?
    var addrCity: String?
    
    var listOfCountry:[Country] = []
    var listOfState:[State] = []
    var listOfCity:[City] = []
    
    var selectedCountrID:String?
    var selectedStateID:String?
    var selectedCityID:String?
    
    //MARK: Properties
    static var storyboardInstance:AddEventLocation {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: AddEventLocation.identifier) as! AddEventLocation
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var lblAddress: LabelSemiBold!
    @IBOutlet weak var lblContry: LabelSemiBold!
    @IBOutlet weak var lblState: LabelSemiBold!
    @IBOutlet weak var lblCity: LabelSemiBold!
    @IBOutlet weak var lblPincode: LabelSemiBold!
    
    @IBOutlet weak var tfAddress: TextField!{
        didSet{
            tfAddress.delegate = self
        }
    }
    @IBOutlet weak var tfCountry: TextField!{
        didSet{
            tfCountry.delegate = self
        }
    }
    @IBOutlet weak var tfState: TextField!{
        didSet{
            tfState.delegate = self
        }
    }
    @IBOutlet weak var tfCity: TextField!{
        didSet{
            tfCity.delegate = self
        }
    }
    @IBOutlet weak var tfPinCode: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreLoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fatchGooglePlaceData()
    }
    
}

//MARK: API methods
extension AddEventLocation{
    
    func callCountry() {
        API.shared.call(with: .getCountries, viewController: self, param: [:], failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.listOfCountry = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({Country(dictionary: $0 as! [String : Any])})
            if self.listOfCountry.count < 1 {
                self.tfCity.resignFirstResponder()
            }else{
                self.openCountryPickerView()
            }
        }
    }
    
    func callState() {
        if let selectedCountrID = self.selectedCountrID{
            let param:[String:Any] = ["country_id": selectedCountrID]
            API.shared.call(with: .getStates, viewController: self, param: param, failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfState = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({State(dictionary: $0 as! [String : Any])})
                if self.listOfCountry.count < 1 {
                    self.tfCity.resignFirstResponder()
                }else{
                    self.openStatePickerView()
                }
            }
        }
    }
    
    func callCity() {
        if let selectedStateID = self.selectedStateID{
            let param:[String:Any] = ["state_id": selectedStateID]
            API.shared.call(with: .getCities, viewController: self, param: param, failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfCity = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({City(dictionary: $0 as! [String : Any])})
                if self.listOfCountry.count < 1 {
                    self.tfCity.resignFirstResponder()
                }else{
                    self.openCityPickerView()
                }
            }
        }
    }
    
    func autoFillCountryBaseOnAddr() {
        //This is nested function no need to declare out side
        func setCountry(){
            if let index = self.listOfCountry.firstIndex(where: { $0.countryName.lowercased() == (self.addrCountry ?? "").lowercased()}){
                self.tfCountry.text = self.listOfCountry[index].countryName
                self.selectedCountrID = "\(self.listOfCountry[index].id)"
                //TODO: reset subcategory
                if !self.tfState.isEmpty{
                    self.selectedStateID = nil
                    self.tfState.text = nil
                    self.listOfState.removeAll()
                }
                if !self.tfCity.isEmpty{
                    self.selectedCityID = nil
                    self.tfCity.text = nil
                    self.listOfCity.removeAll()
                }
                //Call State API
                self.autoFillStateBaseOnAddr()
            }
        }
        
        if self.listOfCountry.count > 0{
            setCountry()
        }else{
            API.shared.call(with: .getCountries, viewController: self, param: [:], failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfCountry = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({Country(dictionary: $0 as! [String : Any])})
                setCountry()
            }
        }
    }
    
    func autoFillStateBaseOnAddr() {
        //This is nested function no need to declare out side
        func setState(){
            if let index = self.listOfState.firstIndex(where: { $0.stateName.lowercased() == (self.addrState ?? "").lowercased()}){
                self.tfState.text = self.listOfState[index].stateName
                //Fatch Id to send to the server
                self.selectedStateID = "\(self.listOfState[index].id)"
                if !self.tfCity.isEmpty{
                    self.selectedCityID = nil
                    self.tfCity.text = nil
                    self.listOfCity.removeAll()
                }
                //Call City API
                self.autoFillCityBaseOnAddr()
            }
        }
        
        if self.listOfState.count > 0{
            setState()
        }else if let selectedCountrID = self.selectedCountrID{
            let param:[String:Any] = ["country_id": selectedCountrID]
            API.shared.call(with: .getStates, viewController: self, param: param, failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfState = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({State(dictionary: $0 as! [String : Any])})
                setState()
            }
        }
    }
    
    func autoFillCityBaseOnAddr() {
        //This is nested function no need to declare out side
        func setCity(){
            if let index = self.listOfCity.firstIndex(where: { $0.cityName.lowercased() == (self.addrCity ?? "").lowercased()}){
                self.tfCity.text = self.listOfCity[index].cityName
                //Fatch Id to send to the server
                self.selectedCityID = "\(self.listOfCity[index].id)"
            }
        }
        
        if self.listOfCity.count > 0{
            setCity()
        }else if let selectedStateID = self.selectedStateID{
            let param:[String:Any] = ["state_id": selectedStateID]
            API.shared.call(with: .getCities, viewController: self, param: param, failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfCity = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({City(dictionary: $0 as! [String : Any])})
                setCity()
            }
        }
    }
    
}

//MARK: Custom function
extension AddEventLocation{
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if tfAddress.isEmpty || self.lat == nil || self.long == nil{
            ErrorMsg = "Please pick the Address"
        }
        else if tfCountry.isEmpty || selectedCountrID == nil{
            ErrorMsg = "Please select Country"
        }
        else if tfState.isEmpty || selectedStateID == nil{
            ErrorMsg = "Please select State"
        }
        else if tfCity.isEmpty || selectedCityID == nil{
            ErrorMsg = "Please select City"
        }
        else if tfPinCode.isEmpty {
            ErrorMsg = "Please enter Pincode"
        }
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func saveDataWithOutValidate() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            eventData.event_addr_2 = ""
            eventData.event_addr_1 = tfAddress._text
            eventData.event_country_id = selectedCountrID ?? ""
            eventData.event_state_id = selectedStateID ?? ""
            eventData.event_city_id = selectedCityID ?? ""
            eventData.event_pincode = tfPinCode._text
            eventData.event_country = tfCountry._text
            eventData.event_state = tfState._text
            eventData.event_city = tfCity._text
            eventData.event_lat = self.lat ?? ""
            eventData.event_long = self.long ?? ""
        }
    }
    
    private func saveData() -> dictionary {
        let param:dictionary = [
            "event_addr_2":"",
            "event_addr_1":tfAddress._text,
            "event_country_id":selectedCountrID!,
            "event_state_id":selectedStateID!,
            "event_city_id":selectedCityID!,
            "event_country": tfCountry._text,
            "event_state": tfState._text,
            "event_city": tfCity._text,
            "event_pincode": tfPinCode._text,
            "event_lat": self.lat!,
            "event_long": self.long!,
        ]
        
        return param
    }
    
    func setDataForEvent( eventData: inout CreateEvent) {
        let dic = saveData()
        eventData.event_addr_2 = dic["event_addr_2",""]
        eventData.event_addr_1 = dic["event_addr_1",""]
        eventData.event_country_id = dic["event_country_id",""]
        eventData.event_state_id = dic["event_state_id",""]
        eventData.event_city_id = dic["event_city_id",""]
        eventData.event_pincode = dic["event_pincode",""]
        eventData.event_country = dic["event_country",""]
        eventData.event_state = dic["event_state",""]
        eventData.event_city = dic["event_city",""]
        eventData.event_lat = dic["event_lat",""]
        eventData.event_long = dic["event_long",""]
    }
    
    func setUpPreLoadData() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            self.lat = eventData.event_lat.isBlank ? nil : eventData.event_lat
            self.long = eventData.event_long.isBlank ? nil : eventData.event_long
            selectedCountrID = eventData.event_country_id
            selectedStateID = eventData.event_state_id
            selectedCityID = eventData.event_city_id
            tfAddress.text = eventData.event_addr_1
            tfCountry.text = eventData.event_country
            tfState.text = eventData.event_state
            tfCity.text = eventData.event_city
            tfPinCode.text = eventData.event_pincode
        }
    }
    
    func fatchGooglePlaceData()  {
        GooglePlaceAPI.shared.googlePlaceBlock = { (lat, long, addr, placeObj) in
            print("Place address: \(addr)")
            print("Place coordinate latitude: \(lat)")
            print("Place coordinate longitude: \(long)")
            self.tfAddress.text = addr
            self.lat = "\(lat)"
            self.long = "\(long)"
            //Set Country,State,Ciry
            for addr in placeObj.addressComponents ?? []{
                let str = addr.types
                if (str.contains("country")){
                    print("Country: \(addr.name)")
                    self.addrCountry = addr.name
                }
                else if (str.contains("administrative_area_level_1")) {
                    print("State: \(addr.name)")
                    self.addrState = addr.name
                }
                else if (str.contains("administrative_area_level_2")) {
                    print("City: \(addr.name)")
                    self.addrCity = addr.name
                }
            }
            //Set PostalCode
            self.getAddressFromLatLong(withLatitude: "\(lat)", withLongitude: "\(long)")
            
            //Auto Fill Coutry, State, City
            self.autoFillCountryBaseOnAddr()
        }
    }
    
    func getAddressFromLatLong(withLatitude pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country ?? "")
                    print(pm.locality ?? "")
                    print(pm.subLocality ?? "")
                    print(pm.thoroughfare ?? "")
                    print(pm.postalCode ?? "")
                    print(pm.subThoroughfare ?? "")
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    
                    //TODO:SetPopstalCode
                    self.tfPinCode.text = pm.postalCode
                }
        })
    }
    
    
    
    func openCountryPickerView() {
        if self.listOfCountry.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfCountry)
            PickerVC.UIDisplayData.title = "Select Country"
            //TODO: Selected Language
            nextVC.listOfDataSource = self.listOfCountry.map({ PickerData(id: String($0.id), title: $0.countryName, value: $0.CurrencyCode) })
            nextVC.selectedLanguage = PickerData(id: "", title: (tfCountry.isEmpty ? addrCountry ?? "" : tfCountry._text), value: "")
            present(asPopUpView: nextVC)
        }else{
            callCountry()
        }
    }
    
    func openStatePickerView() {
        if self.listOfState.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfState)
            PickerVC.UIDisplayData.title = "Select State"
            //TODO: Selected Language
            nextVC.listOfDataSource = self.listOfState.map({ PickerData(id: String($0.id), title: $0.stateName, value: $0.Code) })
            nextVC.selectedLanguage = PickerData(id: "", title: (tfState.isEmpty ? addrState ?? "" : tfState._text), value: "")
            present(asPopUpView: nextVC)
        }else{
            callState()
        }
    }
    
    func openCityPickerView() {
        if self.listOfCity.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfCity)
            PickerVC.UIDisplayData.title = "Select City"
            //TODO: Selected Language
            nextVC.listOfDataSource = self.listOfCity.map({ PickerData(id: String($0.id), title: $0.cityName, value: $0.County) })
            nextVC.selectedLanguage = PickerData(id: "", title: (tfCity.isEmpty ? addrCity ?? "" : tfCity._text), value: "")
            present(asPopUpView: nextVC)
        }else{
            callCity()
        }
    }
    
}

extension AddEventLocation: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if tfAddress == textField {
            tfAddress.text = nil
            GooglePlaceAPI.shared.showGooglePlaceView(vc: self)
            return false
        }else if textField === tfCountry{
            openCountryPickerView()
            return false
        }else if textField === tfState{
            openStatePickerView()
            return false
        }else if textField == tfCity{
            openCityPickerView()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfCountry || textField == tfState || textField == tfCity{
            return false
        }
        else {
            return true
        }
    }
    
}

//MARK: PickerView delegate
extension AddEventLocation: pickerViewData{
    func fatchData(element: PickerData, textField: UITextField) {
        if textField == tfCountry{
            tfCountry.text = element.title
            //Fatch Id to send to the server
            selectedCountrID = element.id
            //TODO: reset subcategory
            if !self.tfState.isEmpty{
                self.selectedStateID = nil
                self.tfState.text = nil
                self.listOfState.removeAll()
            }
            if !self.tfCity.isEmpty{
                self.selectedCityID = nil
                self.tfCity.text = nil
                self.listOfCity.removeAll()
            }
            //callSubCategory()
        }else if textField == tfState{
            tfState.text = element.title
            //Fatch Id to send to the server
            selectedStateID = element.id
            if !self.tfCity.isEmpty{
                self.selectedCityID = nil
                self.tfCity.text = nil
                self.listOfCity.removeAll()
            }
        }else if textField == tfCity{
            tfCity.text = element.title
            //Fatch Id to send to the server
            selectedCityID = element.id
        }
    }
}
