//
//  AddNewAddressVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
var isEdit:Bool = false
class AddNewAddressVC: BaseViewController {
    
    static var storyboardInstance:AddNewAddressVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: AddNewAddressVC.identifier) as? AddNewAddressVC
    }
    
    @IBOutlet weak var txtLandmark: UITextField!
    @IBOutlet weak var viewLandMark: UIView!{
        didSet{
            self.viewLandMark.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var stackViewSave: UIStackView!
    @IBOutlet weak var txtAddressType: UITextField!
    @IBOutlet weak var txtSelectCity: UITextField!
    @IBOutlet weak var txtSelectState: UITextField!
    @IBOutlet weak var txtAddressLine3: UITextField!
    @IBOutlet weak var txtAddressLine2: UITextField!
    @IBOutlet weak var txtAddressLine1: UITextField!
    @IBOutlet weak var txtAddressNickName: UITextField!
     var areaList = [AddressData.AreaList]()
    let areaPickerView = UIPickerView()
    @IBOutlet weak var txtAreaName: UITextField!{
        didSet{
            areaPickerView.delegate = self
            txtAreaName.inputView = areaPickerView
            txtAreaName.delegate = self
        }
    }
    @IBOutlet weak var txtPincode: UITextField!{
        didSet{
            txtPincode.delegate = self
            txtPincode.keyboardType = .numberPad
        }
    }
    var editData:AddressList?
    @IBOutlet weak var viewPinCode: UIView!{
        didSet{
            self.viewPinCode.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAreaName: UIView!{
        didSet{
            self.viewAreaName.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAdress1: UIView!{
        didSet{
            self.viewAdress1.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAddress2: UIView!{
        didSet{
            self.viewAddress2.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAddress3: UIView!{
        didSet{
            self.viewAddress3.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAddressNick: UIView!{
        didSet{
            self.viewAddressNick.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewState: UIView!{
        didSet{
            self.viewState.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewCity: UIView!{
        didSet{
            self.viewCity.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewAddressType: UIView!{
        didSet{
            self.viewAddressType.border(side: .bottom, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    
    var strID:String?
    var dataAddress:AddressData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add New Address", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        
        if isEdit == true {
            txtPincode.text = editData?.pincode
            txtAreaName.text = editData?.area_name
            txtAddressNickName.text = editData?.area_nick_name
            txtAddressLine1.text = editData?.address_line1
            txtAddressLine2.text = editData?.address_line2
            txtAddressLine3.text = editData?.address_line3
            txtSelectState.text = editData?.state
            txtSelectCity.text = editData?.city
            txtLandmark.text = editData?.landmark
            if editData?.address_type_id == "1" {
                strID = "1"
                txtAddressType.text = "Office"
            }else if editData?.address_type_id == "2" {
                strID = "2"
                txtAddressType.text = "Home"
            }else{
                strID = "3"
                txtAddressType.text = "Other"
            }
            self.viewAddressNick.isHidden = false
            self.viewAdress1.isHidden = false
            self.viewAddress2.isHidden = false
            self.viewAddress3.isHidden = false
            self.viewCity.isHidden = false
            self.viewState.isHidden = false
            self.viewLandMark.isHidden = false
            self.stackViewSave.isHidden = false
            self.viewAreaName.isHidden = false
            self.viewAddressType.isHidden = false
        }else{
            self.viewAddressNick.isHidden = true
            self.viewAdress1.isHidden = true
            self.viewAddress2.isHidden = true
            self.viewAddress3.isHidden = true
            self.viewCity.isHidden = true
            self.viewState.isHidden = true
            self.viewLandMark.isHidden = true
            self.stackViewSave.isHidden = true
            self.viewAreaName.isHidden = true
            self.viewAddressType.isHidden = true
        }
        
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        isEdit = false
        if isFromSideMenu == true {
            self.navigationController?.pushViewController(HomeVC.storyboardInstance!, animated: true)
        }else{
        self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtPincode.text?.isEmpty)! {
            ErrorMsg = "Please enter pincode"
        }else  if validZipCode(postalCode: txtPincode.text!) {
            ErrorMsg = "Please enter valid pincode"
        }else if (txtPincode.text?.length)! != 6 {
            ErrorMsg = "Please enter valid pincode"
        }
        else  if (txtAreaName.text?.isEmpty)! {
            ErrorMsg = "Please enter area name"
        }else  if (txtAddressNickName.text?.isEmpty)! {
            ErrorMsg = "Please enter address nick name"
        } else if (txtAddressLine1.text?.isEmpty)! {
            ErrorMsg = "Please enter address line 1"
        } else  if (txtAddressLine2.text?.isEmpty)! {
            ErrorMsg = "Please enter address line 2"
        }else  if (txtAddressLine3.text?.isEmpty)! {
            ErrorMsg = "Please enter address line 3"
        }else  if (txtLandmark.text?.isEmpty)! {
            ErrorMsg = "Please enter landmark"
        }else  if (txtSelectState.text?.isEmpty)! {
            ErrorMsg = "Please select state"
        }else  if (txtSelectCity.text?.isEmpty)! {
            ErrorMsg = "Please select state"
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
    
    func validZipCode(postalCode:String)->Bool{
        let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let bool = pinPredicate.evaluate(with: postalCode) as Bool
        return bool
    }
    
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickaddressType(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Address Type", message: "", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "Office", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.strID = "1"
            self.txtAddressType.text = "Office"
        })
        
        let deleteAction = UIAlertAction(title: "Home", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.strID = "2"
            self.txtAddressType.text = "Home"
        })
        
        let cancelAction = UIAlertAction(title: "Other", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.strID = "3"
            self.txtAddressType.text = "Other"
        })
        
        let cancelAction1 = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        alertController.addAction(cancelAction1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        isEdit = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSave(_ sender: UIButton) {
        if isValidated(){
            if isEdit == true{
                callEditAddressAPI()
            }else{
                callAddAddressAPI()
            }
        }
        
    }
    
    func callEditAddressAPI() {
        let param = ["address_id":editData!.id,
                     "uid":UserData.shared.getUser()!.user_id,
                     "pincode":txtPincode.text!,
                     "area_name":txtAreaName.text!,
                     "area_nick_name":txtAddressNickName.text!,
                     "address_line1":txtAddressLine1.text!,
                     "address_line2":txtAddressLine2.text!,
                     "address_line3":txtAddressLine3.text!,
                     "state":txtSelectState.text!,
                     "city":txtSelectCity.text!,
                     "address_type_id":strID!,
                     "landmark":txtLandmark.text!]
       
        
        Modal.shared.editAddress(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    func callAddAddressAPI() {
        let param = ["uid":UserData.shared.getUser()!.user_id,
                     "pincode":txtPincode.text!,
                     "area_name":txtAreaName.text!,
                     "area_nick_name":txtAddressNickName.text!,
                     "address_line1":txtAddressLine1.text!,
                     "address_line2":txtAddressLine2.text!,
                     "address_line3":txtAddressLine3.text!,
                     "state":txtSelectState.text!,
                     "city":txtSelectCity.text!,
                     "address_type_id":strID!,
                     "landmark":txtLandmark.text!
            
        ]
        Modal.shared.addNewAddress(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func callGetAddressDetailAPI() {
        let param = ["pincode":txtPincode.text!]
        Modal.shared.getAddressDetail(vc: self, param: param, failer: { (error) in
            self.viewAddressNick.isHidden = true
            self.viewAdress1.isHidden = true
            self.viewAddress2.isHidden = true
            self.viewAddress3.isHidden = true
            self.viewCity.isHidden = true
            self.viewState.isHidden = true
            self.stackViewSave.isHidden = true
            self.viewAddressType.isHidden = true
            let alert = UIAlertController(title: "Error", message: "Sorry delivery service is not available in this area", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }) { (dic) in
                self.dataAddress = AddressData(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
                
                //            self.txtPincode.text = self.dataAddress?.pincode
            self.viewAddressNick.isHidden = false
            self.viewAdress1.isHidden = false
            self.viewAddress2.isHidden = false
            self.viewAddress3.isHidden = false
            self.viewCity.isHidden = false
            self.viewState.isHidden = false
            self.viewLandMark.isHidden = false
            self.stackViewSave.isHidden = false
            self.viewAreaName.isHidden = false
            self.viewAddressType.isHidden = false
                self.txtAreaName.text = self.dataAddress?.area_name
                self.txtAddressNickName.text = self.dataAddress?.area_nick_name
                self.txtAddressLine1.text = self.dataAddress?.address_line1
                self.txtAddressLine2.text = self.dataAddress?.address_line2
                self.txtAddressLine3.text = self.dataAddress?.address_line3
                self.txtSelectState.text = self.dataAddress?.state
                self.txtSelectCity.text = self.dataAddress?.city
                self.txtLandmark.text = self.dataAddress?.landmark
            
            self.areaList = (self.dataAddress?.areas)!
            if self.areaList.count == 1{
                self.txtAreaName.text = self.areaList[0].area_name
                self.txtAreaName.isUserInteractionEnabled = false
            }else{
                self.txtAreaName.text = self.areaList[0].area_name
                self.txtAreaName.isUserInteractionEnabled = true
            }
            if self.areaList.count != 0{
                self.areaPickerView.reloadAllComponents()
            }
                if self.dataAddress?.address_type_id == "1" {
                    self.strID = "1"
                    self.txtAddressType.text = "Office"
                }else if self.dataAddress?.address_type_id == "2" {
                    self.strID = "2"
                    self.txtAddressType.text = "Home"
                }else{
                    self.strID = "3"
                    self.txtAddressType.text = "Other"
                }
                self.txtSelectState.isUserInteractionEnabled = false
                self.txtSelectCity.isUserInteractionEnabled = false
               // self.txtAreaName.isUserInteractionEnabled = false
                
            }
            if dataAddress == nil {
                self.txtSelectState.isUserInteractionEnabled = true
                self.txtSelectCity.isUserInteractionEnabled = true
               // self.txtAreaName.isUserInteractionEnabled = true
            }
        }
}

extension AddNewAddressVC:UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtPincode {
           // if isEdit == false {
         //   if textField.text?.length == 6 {
                if (textField.text?.length) != 6 {
                    let alert = UIAlertController(title: "Error", message: "Please enter valid pincode", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                    present(alert, animated: true, completion: nil)
                }else{
                    callGetAddressDetailAPI()
                }
            }
           // }
        //}
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPincode {
            if (textField.text?.length)! <= 6{
                //textField.deleteBackward()
           // }else{
                self.viewAddressNick.isHidden = true
                self.viewAdress1.isHidden = true
                self.viewAddress2.isHidden = true
                self.viewAddress3.isHidden = true
                self.viewCity.isHidden = true
                self.viewState.isHidden = true
                self.viewLandMark.isHidden = true
                self.stackViewSave.isHidden = true
                self.viewAreaName.isHidden = true
                self.viewAddressType.isHidden = true
            }
        }
        if txtAreaName == textField{
            
            return false
        }
        else{
            return true
        }
    }
    
}

extension AddNewAddressVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return areaList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtAreaName.text = areaList[row].area_name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.text = areaList[row].area_name
        
        return label
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

