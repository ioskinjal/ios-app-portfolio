//
//  mobilePopupVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 20/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
protocol mobilePopupVCDelegate : class {
    func continuousBtnAction(mobilePopupVC :mobilePopupVC, mobile: String)
}
//@IBOutlet weak var txtIsdCode: UITextField!
//@IBOutlet weak var txtMobile: UITextField!

class mobilePopupVC: UIViewController {
    weak var mobilePopupDelegate : mobilePopupVCDelegate?
    @IBOutlet weak var mobileView: addMobile!
    var userData: AddressInformation?
    var isdPicker = UIPickerView()
    let countryData =  Common.sharedInstance.countryCodeList()
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileView.btnClose.addTarget(self, action: #selector(onClickClose(_:)), for: .touchUpInside)
        addAction()
        // Do any additional setup after loading the view.
    }
    
    @objc func onClickClose(_ sender:UIButton)
    {
        self.mobilePopupDelegate?.continuousBtnAction(mobilePopupVC: self, mobile: "")
    }
    
    private func addAction(){
        mobileView.btnContinue.addTarget(self, action: #selector(continuewSelector), for: .touchUpInside)
        mobileView.btnDropdown.addTarget(self, action: #selector(dropdownSelector), for: .touchUpInside)
        mobileView.txtIsdCode.inputView = self.isdPicker
        self.isdPicker.delegate = self
        self.isdPicker.dataSource = self;
        self.isdPicker.selectRow(0, inComponent: 0, animated: false)
        self.isdPicker.reloadAllComponents()
    
    }
    @objc func continuewSelector(sender : UIButton) {
        let mobileNO = ValidationClass.verifyPhoneNumber(text: self.mobileView.txtMobile.text ?? "")
        if mobileNO.1 {
            mobileView.lblMobileError.isHidden = true
            //Write button action here
             var isdCode = self.mobileView.txtIsdCode.text ?? ""
             if !isdCode.isNumeric {
                 isdCode = ""
             }
             let mobileNO = self.mobileView.txtMobile.text ?? ""
             let finalMobileNo = "\(isdCode.deletingPrefix("+"))-\(mobileNO)"
             self.mobilePopupDelegate?.continuousBtnAction(mobilePopupVC: self, mobile: finalMobileNo.deletingPrefix("-"))
            // hidepopupWhenTappedAround()
             ///self.navigationController?.popViewController(animated: true)
        }else{
            mobileView.lblMobileError.isHidden = false
            mobileView.lblMobileError.text = "Please enter valid mobile number."
        }

    }
    @objc func dropdownSelector(sender : UIButton) {
        
        print("Show Picker to User")
        mobileView.txtIsdCode.becomeFirstResponder()
    }
    func hidepopupWhenTappedAround() {
        self.dismiss(animated: true, completion: nil)
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
extension mobilePopupVC : UIPickerViewDelegate,UIPickerViewDataSource{

     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryData.count
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        mobileView.txtIsdCode.text = "+\(countryData[row].countryCode)"
        
       }
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        let countryCode = countryData[row].countryCode
        let countryName = countryData[row].countryName
        label.text = "+\(countryCode)  \(countryName)"
        return label

    }

}


