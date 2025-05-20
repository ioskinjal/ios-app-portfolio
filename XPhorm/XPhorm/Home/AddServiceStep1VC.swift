//
//  AddServiceStep1VC.swift
//  XPhorm
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GooglePlaces

var isFromEdit = false

class AddServiceStep1VC: BaseViewController {

    static var storyboardInstance:AddServiceStep1VC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: AddServiceStep1VC.identifier) as? AddServiceStep1VC
    }
    var service_id = ""
    
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var btnContinue: SignInButton!
    
    var policyType = [[
        "id": "1",
        "name": "Flexible".localized
        ],[
            "id": "2",
            "name": "Moderate".localized
        ],[
            "id": "3",
            "name": "Strict".localized
        ]]
    
    var selectedPolicy:[String:String] = [:]
    var policyPicker = UIPickerView()
    @IBOutlet weak var txtCancellationPolicy: Textfield!{
        didSet{
            self.policyPicker.delegate = self
            self.policyPicker.dataSource = self
            self.txtCancellationPolicy.inputView = self.policyPicker
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.txtCancellationPolicy.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image:   #imageLiteral(resourceName: "downArrrow"))
            }
        }
    }
    
    @IBOutlet weak var txtLocation: Textfield!{
    didSet{
    txtLocation.delegate = self
    }
}
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
//            txtDesc.placeholder = "Description".localized
            
            txtDesc.border(side: .all, color: #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            
            txtDesc.setRadius(6.0)
            
        }
    }
    @IBOutlet weak var txtSuperVisionTime: Textfield!
    @IBOutlet weak var txtPrice: Textfield!
    
    let agePicker = UIPickerView()
    @IBOutlet weak var txtPersonalAge: Textfield!{
        didSet{
            
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.agePicker.delegate = self
                self.agePicker.dataSource = self
                self.txtPersonalAge.inputView = self.agePicker
                self.txtPersonalAge.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image:   #imageLiteral(resourceName: "downArrrow"))
            }
        }
    }
    @IBOutlet weak var txtHolidayRate: Textfield!
    
     let serviceDurationPicker = UIPickerView()
    @IBOutlet weak var txtServiceDuration: Textfield!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.serviceDurationPicker.delegate = self
                self.serviceDurationPicker.dataSource = self
                self.txtServiceDuration.inputView = self.serviceDurationPicker
                self.txtServiceDuration.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image:   #imageLiteral(resourceName: "downArrrow"))
            }
        }
    }
    @IBOutlet weak var txtAdditionalRate: Textfield!
    
    let serviceTypePicker = UIPickerView()
    @IBOutlet weak var txtServiceType: Textfield!{
        didSet{
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.serviceTypePicker.delegate = self
                self.serviceTypePicker.dataSource = self
                self.txtServiceType.inputView = self.serviceTypePicker
                self.txtServiceType.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image:   #imageLiteral(resourceName: "downArrrow"))
            }
        }
    }
    @IBOutlet weak var view3: UIView!{
        didSet{
            view3.setRadius()
        }
    }
    @IBOutlet weak var view2: UIView!{
        didSet{
            view2.setRadius()
        }
    }
    @IBOutlet weak var view1: UIView!{
        didSet{
            view1.setRadius()
        }
    }
    
    var serviceTypeList = [ServiceTypeList]()
    var selectedType:ServiceTypeList?
    var durationList = [DurationList]()
    var selectedDuration:DurationList?
    var ageList = [AgeList]()
    var selectedAge:AgeList?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var postalCode:String = ""
    var data:ServiceDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Services ", action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickImage(_:)), btnRightImg: #imageLiteral(resourceName: "financeIcon"))
        
        if isFromEdit == true{
            callGetServiceDetail()
        }else{
            getServiceTypes()
        }
        
       
    }
    

    
    func callGetServiceDetail(){
        let param = ["action":"getServiceInfo",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "id":service_id]
        
        Modal.shared.serviceDetail(vc: self, param: param) { (dic) in
            
            self.data = ServiceDetail(dic: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.showProfileData(data: self.data!)
        }
    }
    
     func showProfileData(data:ServiceDetail){
        getServiceTypes()
        txtServiceType.text = data.serviceType
        txtAdditionalRate.text = data.additionalRate
        txtPrice.text = data.price
        txtPersonalAge.text = data.age
        txtHolidayRate.text = data.holidayRate
        txtCancellationPolicy.text = data.cancellationPolicy
        selectedPolicy["id"] = data.cancellationPolicyId
        selectedPolicy["name"] = data.cancellationPolicy
        txtSuperVisionTime.text = data.supervisionTime
        txtLocation.text = data.location
        latitude = CLLocationDegrees(data.latitude)
        longitude = CLLocationDegrees(data.longitude)
        txtDesc.placeholder = data.description.isEmpty ? "" : nil
        txtDesc.text = data.description
        txtDesc.placeholder = "Descprition".localized
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
        if isFromEdit{
            stackViewBottom.isHidden = true
            setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Services".localized, action: #selector(onClickBack(_:)))
        }else{
            self.navigationBar.lblTitle.text = "Add Services".localized
            stackViewBottom.isHidden = false
        }
    }
    
    @objc func onClickBack(_ sender:UIButton){
        isFromEdit = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLanguage(){
        txtServiceType.placeholder = "Service Type".localized
        txtServiceDuration.placeholder = "Service Duration".localized
        txtAdditionalRate.placeholder = "Addiotional Rate".localized
        txtHolidayRate.placeholder = "Holiday Rate".localized
        txtPrice.placeholder = "Price".localized
        txtPersonalAge.placeholder = "Personal Age".localized
        txtCancellationPolicy.placeholder = "Cancellation Policy".localized
        txtSuperVisionTime.placeholder = "Supervision Time".localized
        txtLocation.placeholder = "Location".localized
        txtDesc.placeholder = "Descprition".localized
        btnContinue.setTitle("CONTINUE".localized, for: .normal)
    }
    
    func getServiceTypes(){
        
        let param = ["action":"getServiceType",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: self, param: param) { (dic) in
            self.serviceTypeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({ServiceTypeList(dic: $0 as! [String:Any])})
            if self.serviceTypeList.count != 0{
            self.serviceTypePicker.reloadAllComponents()
            }
            if isFromEdit{
                for i in self.serviceTypeList{
                    if i.id == self.data?.serviceType{
                        self.selectedType = i
                        self.txtServiceType.text = i.categoryName
                    }
                }
            }
            self.getServiceDuration()
        }
    }
    
    func getServiceDuration(){
        let param = ["action":"getDuration",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: self, param: param) { (dic) in
            self.durationList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({DurationList(dic: $0 as! [String:Any])})
            if self.durationList.count != 0{
            self.serviceDurationPicker.reloadAllComponents()
            }
            if isFromEdit{
                for i in self.durationList{
                    if i.id == self.data?.durationId{
                        self.selectedDuration = i
                        self.txtServiceDuration.text = i.duration
                    }
                }
            }
            self.getAge()
        }
        
    }
    
    func getAge(){
        let param = ["action":"getDogAge",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: self, param: param) { (dic) in
            self.ageList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({AgeList(dic: $0 as! [String:Any])})
            if self.ageList.count != 0{
                if isFromEdit{
                    for i in self.ageList{
                        if i.id == self.data?.dogAgeId{
                            self.selectedAge = i
                            self.txtPersonalAge.text = i.age
                        }
                    }
                }
            self.agePicker.reloadAllComponents()
            }
        }
        
    }
    
    @IBAction func onClickContinue(_ sender: SignInButton) {
        if isValidated(){
            if isFromEdit{
               callEditServiceStep1()
            }else{
            callAddServiceStep1()
            }
        }
    }
    
    func callAddServiceStep1(){
        let param = ["action":"addServiceData",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "step":1,
            "type":"add",
            "serviceType":selectedType!.id,
            "durationId":selectedDuration!.id,
            "additionalRate":txtAdditionalRate.text!,
            "holidayRate":txtHolidayRate.text!,
            "price":txtPrice.text!,
            "dogAgeId":selectedAge!.id,
            "cancellationPolicyId":selectedPolicy["id"]!,
            "location_address":txtLocation.text!,
            "supervisionTime":txtSuperVisionTime.text!,
            "description":txtDesc.text!,
            "lat":latitude!,
            "lng":longitude!,
            "postal_code":postalCode
            ] as [String : Any]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            print(dic)
            let dict:[String:Any] = dic["data"] as! [String : Any]
            let nextVC = AddServiceStep2.storyboardInstance!
            nextVC.data = self.data
            nextVC.service_id = dict["serviceId"] as! String
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    func callEditServiceStep1(){
        let param = ["action":"addServiceData",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "step":1,
                     "type":"edit",
                     "serviceType":selectedType!.id,
                     "durationId":selectedDuration!.id,
                     "additionalRate":txtAdditionalRate.text!,
                     "holidayRate":txtHolidayRate.text!,
                     "price":txtPrice.text!,
                     "dogAgeId":selectedAge!.id,
                     "cancellationPolicyId":selectedPolicy["id"]!,
                     "location_address":txtLocation.text!,
                     "supervisionTime":txtSuperVisionTime.text!,
                     "description":txtDesc.text!,
                     "lat":latitude!,
                     "lng":longitude!,
                     "id":service_id
            ] as [String : Any]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            print(dic)
            let dict:[String:Any] = dic["data"] as! [String : Any]
            let nextVC = AddServiceStep2.storyboardInstance!
            nextVC.service_id = dict["serviceId"] as! String
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtServiceType.text?.isEmpty)! {
            ErrorMsg = "Please select Service type".localized
        }else  if (txtServiceDuration.text?.isEmpty)! {
            ErrorMsg = "Please select service duration".localized
        }else if (txtHolidayRate.text?.isEmpty)! {
            ErrorMsg = "Please enter holiday rate".localized
        }else if (txtPrice.text?.isEmpty)! {
            ErrorMsg = "Please enter price".localized
        }
        else  if (txtPersonalAge.text?.isEmpty)! {
            ErrorMsg = "Please select personal age".localized
        }else  if (txtCancellationPolicy.text?.isEmpty)! {
            ErrorMsg = "please select cancellation policy".localized
        }else  if (txtSuperVisionTime.text?.isEmpty)! {
            ErrorMsg = "Please enter supervison time".localized
        }else  if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "please select location".localized
        }else  if (txtDesc.text?.isEmpty)! {
            ErrorMsg = "Please enter description".localized
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        isFromEdit = false
        if sender.tag == 2{
            if UserData.shared.getUser()?.isCertificate == 0{
                self.alert(title: "", message: "please upload certificates in your profile to add service".localized)
            }else if UserData.shared.getUser()?.insta_verify == "n" {
                self.alert(title: "", message: "please verify your instagram account".localized)
            }else{
                self.tabBarController?.selectedIndex = sender.tag
            }
        }else{
            self.tabBarController?.selectedIndex = sender.tag
        }
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddServiceStep1VC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if serviceDurationPicker == pickerView{
            return durationList.count
        }else if agePicker == pickerView{
            return ageList.count
        }else if policyPicker == pickerView{
            return policyType.count
        }
        else{
        return serviceTypeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if serviceDurationPicker == pickerView{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            var name = String()
            name = durationList[row].duration
            let str = name
            label.text = str
            
            return label
        }else if agePicker == pickerView{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            var name = String()
            name = ageList[row].age
            let str = name
            label.text = str
            
            return label
        }else if policyPicker == pickerView{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            var name = String()
            let dic = policyType[row]
            name = dic["name"] ?? ""
            let str = name
            label.text = str
            
            return label
        }
        else{
            
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
        name = serviceTypeList[row].categoryName
        let str = name
        label.text = str
        
        return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if serviceDurationPicker == pickerView{
            selectedDuration = durationList[row]
            txtServiceDuration.text = selectedDuration?.duration
        }else if agePicker == pickerView{
            selectedAge = ageList[row]
            txtPersonalAge.text = selectedAge?.age
        }else if policyPicker == pickerView{
            selectedPolicy = policyType[row]
            txtCancellationPolicy.text = selectedPolicy["name"]
        }
        else if pickerView == serviceTypePicker{
            
        selectedType = serviceTypeList[row]
        txtServiceType.text = selectedType?.categoryName
        }
        }
}
extension AddServiceStep1VC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtLocation == textField {
            txtLocation.text = nil
            //https://developers.google.com/places/ios-api/
            //TODO: Display google place picker
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtLocation == textField {
            return false
        }
        else{
            return true
        }
    }
    
}
extension AddServiceStep1VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       let geoCoder = CLGeocoder()
       
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        let location = CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placemarks![0]
                self.postalCode = pm.postalCode ?? "0"
            }

        })
        txtLocation.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
