//
//  FilterByVC.swift
//  XPhorm
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GooglePlaces

class FilterByVC: BaseViewController {

    static var storyboardInstance:FilterByVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: FilterByVC.identifier) as? FilterByVC
    }
    
//    @IBOutlet weak var weekStack: UIStackView!{
//        didSet{
//           weekStack.setRadius(4.0)
//        }
//    }
    @IBOutlet weak var btnApply: UIButton!
    let datePickerViewEnd =  UIDatePicker()
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
            
            datePickerViewEnd.datePickerMode = .date
            datePickerViewEnd.addTarget(self, action: #selector(dateDiveChanged1(_:)), for: UIControl.Event.valueChanged)
            txtEndDate.inputView = datePickerViewEnd
            
        }
    }
    @IBOutlet weak var viewDate: UIView!{
        didSet{
            viewDate.setRadius(6.0)
            
        }
    }
    @IBOutlet weak var txtStartDate: UITextField!{
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.datePickerMode = .date
            startPickerview.addTarget(self, action: #selector(dateDiveChanged(_:)), for: UIControl.Event.valueChanged)
            txtStartDate.inputView = startPickerview
            
            
        }
    }
    @IBOutlet weak var btnSat: weekButton!
    @IBOutlet weak var btnF: weekButton!
    
    @IBOutlet weak var btnThu: weekButton!
    @IBOutlet weak var btnW: weekButton!
    @IBOutlet weak var btnT: weekButton!
    @IBOutlet weak var btnM: weekButton!
    @IBOutlet weak var btnS: weekButton!
    
    let serviceTypePicker = UIPickerView()
    @IBOutlet weak var txtLocation: Textfield!{
        didSet{
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var txtServiceType: Textfield!{
        didSet{
            serviceTypePicker.delegate = self
            serviceTypePicker.dataSource = self
            txtServiceType.inputView = serviceTypePicker
            txtServiceType.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image: #imageLiteral(resourceName: "dateIcon-1"))
        }
    }
    
    var serviceTypeList = [ServiceTypeList]()
    var selectedType:ServiceTypeList?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var selectedWeek = [String]()
    var param = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getServiceTypes()
         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Filter By".localized, action: #selector(onClickBack(_:)))
//        self.txtLocation.text = param["address"] as? String
//        self.txtEndDate.text = param["endDate"] as? String
//        self.txtStartDate.text = param["startDate"] as? String
//        let str:String = param["days"] as! String
//
//        let arrayWeek:Array =  str.components(separatedBy: ",")
//        for i in 0..<arrayWeek.count{
//            if arrayWeek[i] == "monday"{
//                selected(button: btnM)
//            }else if arrayWeek[i] == "tuesday"{
//                selected(button: btnT)
//            }else if arrayWeek[i] == "wednesday"{
//                selected(button: btnW)
//            }else if arrayWeek[i] == "thursday"{
//                selected(button: btnThu)
//            }else if arrayWeek[i] == "friday"{
//                selected(button: btnF)
//            }else if arrayWeek[i] == "saturday"{
//                selected(button: btnSat)
//            }else{
//                selected(button: btnS)
//            }
//        }
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dateDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtStartDate.text = formatter.string(from: sender.date)
    }
    
    @objc func dateDiveChanged1(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        datePickerViewEnd.minimumDate = formatter.date(from: txtStartDate.text ?? "")
        txtEndDate.text = formatter.string(from: sender.date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
        
    }
    
    func setupLanguage(){
        self.txtServiceType.placeholder = "Service Type".localized
        self.txtLocation.placeholder = "Location".localized
        self.txtStartDate.placeholder = "Start Date".localized
        self.txtEndDate.placeholder = "End Date".localized
        self.btnApply.setTitle("APPLY NOW".localized, for: .normal)
        
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtServiceType.text?.isEmpty)! {
            ErrorMsg = "Please select service type".localized
        }
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "Please select location".localized
        }else if (txtStartDate.text?.isEmpty)! {
            ErrorMsg = "Please select start date".localized
        }else if (txtEndDate.text?.isEmpty)! {
            ErrorMsg = "Please select end date".localized
        }else if selectedWeek.count == 0{
            ErrorMsg = "Please select days".localized
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title:"Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    func selected(button: UIButton) {
        
        button.isSelected = true
        button.backgroundColor = UIColor(red: 187.0/255.0, green: 229.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
    }
    
    func deselected(button: UIButton) {
        
        button.isSelected = false
        button.backgroundColor = UIColor.clear
    }
    
    func getServiceTypes(){
        
        let param = ["action":"getServiceType",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: self, param: param) { (dic) in
            self.serviceTypeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({ServiceTypeList(dic: $0 as! [String:Any])})
            self.serviceTypePicker.reloadAllComponents()
            for i in 0..<self.serviceTypeList.count{
                if param["service_type"] == self.serviceTypeList[i].id{
                    self.txtServiceType.text = self.serviceTypeList[i].categoryName
                }
            }
        }
    }
    
//    @IBAction func onClickWeek(_ sender: UIButton) {
//        if sender.isSelected{
//
//            selectedWeek.remove(at: sender.tag)
//            deselected(button: sender)
//        }else{
//
//            selected(button: sender)
//            if sender.tag == 0{
//                selectedWeek.append("Monday")
//            }else if sender.tag == 1{
//                selectedWeek.append("tuesday")
//            }else if sender.tag == 2{
//                selectedWeek.append("wednesday")
//            }else if sender.tag == 3{
//                selectedWeek.append("thurday")
//            }else if sender.tag == 4{
//                selectedWeek.append("friday")
//            }else if sender.tag == 5{
//                selectedWeek.append("saturday")
//            }else{
//                selectedWeek.append("sunday")
//            }
//
//
//        }
//        print(selectedWeek)
//    }
//
    @IBAction func onclickApply(_ sender: UIButton) {
        //if isValidated(){
        if !(txtServiceType.text?.isEmpty)! {
           param["serviceType"] = selectedType?.id
        }
        else if !(txtLocation.text?.isEmpty)! {
          param["address"] = txtLocation.text
            param["locationLng"] = longitude
            param["locationLat"] = latitude
        }else if !(txtStartDate.text?.isEmpty)! {
            param["startDate"] = txtStartDate.text
        }else if !(txtEndDate.text?.isEmpty)! {
            param["endDate"] = txtEndDate.text
        }
        //else if selectedWeek.count != 0{
            param["days"] = ""
        //}
            let nextVC = SearchResultVC.storyboardInstance!
            
            nextVC.param = param
            self.navigationController?.pushViewController(nextVC, animated: true)
        //}
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
extension FilterByVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serviceTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = serviceTypeList[row]
        txtServiceType.text = selectedType?.categoryName
    }
}
extension FilterByVC: UITextFieldDelegate {
    
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
extension FilterByVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
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
