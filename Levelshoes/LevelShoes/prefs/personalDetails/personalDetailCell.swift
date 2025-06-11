//
//  personalDetailCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class personalDetailCell: PersnolDetailBaseCell {
    var userTitlePicker = UIPickerView()
    var titleArray = [String]()
   let countryData =  Common.sharedInstance.countryCodeList()

    @IBOutlet weak var lblCC: UILabel!{
        didSet{
            lblCC.text = "lblcc".localized
        }
    }
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var viewIsdCode: UIView!
    @IBOutlet weak var isdWidthConstant: NSLayoutConstraint!
    
    var flagUp = false
    @objc func onTap(_ sender:UITextField){
        self.btnDropDown.setImage(UIImage(named: "ic_up"), for: .normal)
   
    }
    
    @objc func onEnd(_ sender:UITextField){
        self.btnDropDown.setImage(UIImage(named: "ic_dropdown"), for: .normal)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateprefixCell(selected:String){
        titleArray = [validationMessage.MR.localized,validationMessage.Ms.localized,validationMessage.Mrs.localized]
        userTitlePicker.delegate = self
        userTitlePicker.dataSource = self;
        txtUserdetail.delegate = self
        txtUserdetail.inputView = self.userTitlePicker
        titleArray.index(of: selected)
        userTitlePicker.selectRow(titleArray.index(of: selected) ?? 0, inComponent: 0, animated: false)
        userTitlePicker.reloadAllComponents()
       
        
        self.txtUserdetail.addTarget(self, action: #selector(onTap(_:)), for: .touchDown)
        self.txtUserdetail.addTarget(self, action: #selector(onEnd(_:)), for: .editingDidEnd)
        
    }
    func updateIsdCode(){
        titleArray.removeAll()
        for items in countryData{
            let countryCode = items.countryCode
            let countryName = items.countryName
            titleArray.append("+\(countryCode)  \(countryName)")
        }
        userTitlePicker.delegate = self
        userTitlePicker.dataSource = self;
        txtIsdcode.delegate = self
        txtUserdetail.delegate = self
        txtIsdcode.inputView = self.userTitlePicker
        userTitlePicker.selectRow(0, inComponent: 0, animated: false)
        userTitlePicker.reloadAllComponents()
    }
    func updateFirstName(){
        txtUserdetail.delegate = self
    }
    func updateLastName(){
        txtUserdetail.delegate = self
    }
    func updateEmail(){
        txtUserdetail.delegate = self
    }

    func updategenderCell(){
        titleArray = ["",CommonUsed.globalUsed.accntGenderMen.localized,CommonUsed.globalUsed.accntGenderWomen.localized,CommonUsed.globalUsed.accntGenderKids.localized]
        userTitlePicker.delegate = self
        userTitlePicker.dataSource = self;
        txtUserdetail.delegate = self
        txtUserdetail.inputView = self.userTitlePicker
        
        userTitlePicker.selectRow(selectedGender, inComponent: 0, animated: false)
        userTitlePicker.reloadAllComponents()
        txtUserdetail.text = titleArray[selectedGender]
        
        self.txtUserdetail.addTarget(self, action: #selector(onTap(_:)), for: .touchDown)
        self.txtUserdetail.addTarget(self, action: #selector(onEnd(_:)), for: .editingDidEnd)
        
    }
    func updatedateCell(){
        self.txtUserdetail.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    @objc func tapDone() {
           if let datePicker = self.txtUserdetail.inputView as? UIDatePicker {
            let selectedDate = datePicker.date
               print(selectedDate)
               let formatter = DateFormatter()
               formatter.dateFormat = "dd-MM-yyyy"
               let strDate = formatter.string(from: selectedDate)
               self.txtUserdetail.text = strDate
            self.delegate?.updateDob(self.txtUserdetail, withCell: self)
           }
           self.txtUserdetail.resignFirstResponder() 
       }
    func showMobile(aBool : Bool){
        if aBool {
             viewIsdCode.isHidden = false
            isdWidthConstant.constant = 105
        }
        else{
             viewIsdCode.isHidden = true
            isdWidthConstant.constant = 0
        }

        

    }
}
extension personalDetailCell : UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

       
        return NSAttributedString(string: titleArray[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (userTitlePicker.window != nil) {
             self.btnDropDown.setImage(UIImage(named: "ic_up"), for: .normal)
        }
        return self.titleArray.count ?? 0
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
        switch self.cellType {
            case "genderCell":
            self.selectedGender = row
            txtUserdetail.text = titleArray[row]
            self.delegate?.updateGender(self.txtUserdetail, withCell: self)
            case "salutationcell":
                txtUserdetail.text = titleArray[row]
            self.delegate?.updatePrifex(self.txtUserdetail, withCell: self)
            case "mobileNoCell":
                txtIsdcode.text = countryData[row].countryCode//titleArray[row]
            self.delegate?.updateMobileNumber(self.txtIsdcode, withCell: self)
            default:
            return
        }
  
       }
       
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           var label: UILabel
           if let view = view as? UILabel { label = view }
           else { label = UILabel() }
           label.textAlignment = .center
           label.adjustsFontSizeToFitWidth = true
           label.minimumScaleFactor = 0.5
           label.text = self.titleArray[row]
           return label
       }

}
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView

        let stringA = formattedDateFromString(dateString: self.text ?? "", withFormat: "dd-MM-yyyy")
        self.text = stringA
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: self.text ?? "")
        datePicker.datePickerMode = .date
          let currentDate = Date()
        datePicker.maximumDate = currentDate
        if date != nil{
        datePicker.setDate(date!, animated: false)
        }
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: dateString) {

          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
}
