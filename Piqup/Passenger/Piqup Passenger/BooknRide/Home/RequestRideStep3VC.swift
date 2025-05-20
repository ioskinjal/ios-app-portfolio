//
//  RequestRideStep3VC.swift
//  Carry
//
//  Created by NCrypted on 20/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class RequestRideStep3VC: BaseVC {

    let logisticsPickerView = UIPickerView()
     let personPickerView = UIPickerView()
    let personList = NSMutableArray()
    var strSelectedPerson:String = "0"
    
    @IBOutlet weak var txtWeight: UITextField!{
        didSet{
            txtWeight.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtHeightDimension: UITextField!{
        didSet{
            txtHeightDimension.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtBreadth: UITextField!{
        didSet{
            txtBreadth.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtWidth: UITextField!{
        didSet{
            txtWidth.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var btnConfirmDimension: UIButton!
    @IBOutlet weak var btnConfirmWeight: UIButton!
    @IBOutlet weak var txtPersons: UITextField!{
        didSet{
            personPickerView.delegate = self
            txtPersons.inputView = personPickerView
            txtPersons.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
    @IBOutlet weak var txtSelectCategory: UITextField!{
        didSet{
            logisticsPickerView.delegate = self
            txtSelectCategory.inputView = logisticsPickerView
            txtSelectCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
    
    var logisticsList = NSMutableArray()
    
    var selectedCategory = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...10{
            personList.add(String(i))
        }
        if personList.count != 0{
            personPickerView.reloadAllComponents()
            personPickerView.selectedRow(inComponent: 0)
            txtPersons.text = "0"
        }
        getLogistics()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getLogistics(){
        
        
        
        let alert = Alert()
        
        startIndicator(title: "")
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.getlogisticdetails, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                self.logisticsList.addObjects(from: jsonDict?.value(forKey: "dataAns") as! [Any])
                if self.logisticsList.count != 0{
                   self.logisticsPickerView.reloadAllComponents()
                }
                
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
        
    }
    
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        
        
            if (txtSelectCategory.text?.isEmpty)! {
                ErrorMsg = "Please select category name"
            }else if (txtWeight.text?.isEmpty)! {
            ErrorMsg = "Please enter weight in kg"
            }else if (txtWidth.text?.isEmpty)! {
                ErrorMsg = "Please enter width"
            }else if (txtHeightDimension.text?.isEmpty)! {
                ErrorMsg = "Please enter height"
            }else if (txtBreadth.text?.isEmpty)! {
                ErrorMsg = "Please enter breadh"
            }
            else if txtWeight.text == "0"{
                ErrorMsg = "Please enter valid weight"
            }
            else if txtWidth.text == "0"{
                ErrorMsg = "Please enter valid width"
            }
            else if txtHeightDimension.text == "0"{
                ErrorMsg = "Please enter valid height"
            }
            else if txtBreadth.text == "0"{
                ErrorMsg = "Please enter valid breadth"
            }
//            else if btnConfirmWeight.currentImage == #imageLiteral(resourceName: "Checkbox") {
//                ErrorMsg = "please check I confirm package is less than 50kg"
//            }
//            else if btnConfirmDimension.currentImage == #imageLiteral(resourceName: "Checkbox") {
//                ErrorMsg = "Please check I confirm package dimension is less than 14inx14inx14in"
//            }
            else if (txtPersons.text?.isEmpty)! {
                ErrorMsg = "Please selct number of extra persons"
            }
    
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        if sender.tag == 0{
            //if Int(txtWeight.text!)! > 15 {
            if sender.currentImage == #imageLiteral(resourceName: "Checkbox"){
                sender.setImage(#imageLiteral(resourceName: "Checkbox-checked"), for: .normal)
            }else{
                sender.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)
            }
            //}
        }else{
            if sender.currentImage == #imageLiteral(resourceName: "Checkbox"){
                sender.setImage(#imageLiteral(resourceName: "Checkbox-checked"), for: .normal)
            }else{
                sender.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)
            }
        }
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        if isValidated(){
            dictParam["logistic_category"] = selectedCategory
            if btnConfirmWeight.currentImage == #imageLiteral(resourceName: "Checkbox"){
                dictParam["confirm_logistic_weight"] = "0"
            }else{
                dictParam["confirm_logistic_weight"] = "1"
            }
            if btnConfirmDimension.currentImage == #imageLiteral(resourceName: "Checkbox"){
                dictParam["confirm_logistic_dimension"] = "0"
            }else{
                dictParam["confirm_logistic_dimension"] = "1"
            }
            dictParam["number_of_extra_person_required"] = strSelectedPerson
            dictParam["width"] = txtWidth.text
            dictParam["height"] = txtHeightDimension.text
            dictParam["breadth"] = txtBreadth.text
            dictParam["weight"] = txtWeight.text
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let requestRideVC2 = storyBoard.instantiateViewController(withIdentifier: "RideRequest4VC") as! RideRequest4VC
        self.navigationController?.pushViewController(requestRideVC2, animated: true)
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

}
extension RequestRideStep3VC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == logisticsPickerView{
        return logisticsList.count
        }else{
            return personList.count
        }
    }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            var str = String()
             if pickerView == logisticsPickerView{
                let dict:NSDictionary = logisticsList[row] as! NSDictionary
                str = dict.value(forKey: "name") as! String
             }else{
                str = personList[row] as! String
            }
            return str
        }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == logisticsPickerView{
             let dict:NSDictionary = logisticsList[row] as! NSDictionary
       selectedCategory = dict.value(forKey: "id") as! Int
            txtSelectCategory.text = (dict.value(forKey: "name") as! String)
        }else{
            strSelectedPerson = personList[row] as! String
            txtPersons.text = (personList[row] as! String)
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
        if pickerView == logisticsPickerView{
            let dict:NSDictionary = logisticsList[row] as! NSDictionary
            name = dict.value(forKey: "name") as! String
        }else{
            name = personList[row] as! String
        }
        let str = name
        label.text = str

        return label
    }
    
}

