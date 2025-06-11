//
//  ChooseCountry.swift
//  LevelShoes
//
//  Created by Maa on 22/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SwiftSVG
import Foundation

var selectedStoreCode = ""
   var selectedCountry = ""
    var selectedCurrency = ""
var selectedCountryFlag : String? = nil
class ChooseCountry: UIView {
    //    var data : onBoardingData?
    var countryPicker = UIPickerView()
    var data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
   
    var selectedCountryName : String? = nil
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var _lblChooseCountry: UILabel!{
        didSet{
            _lblChooseCountry.text = validationMessage.accountChooseCountry.localized
            
        }
    }
    @IBOutlet weak var _lblNotification: UILabel!{
        didSet{
            _lblNotification.text = validationMessage.registerlblNotification.localized
        }
    }
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var _txtCountryName: UITextField!{
        didSet{
            countryPicker.delegate = self
            self._txtCountryName.inputView = self.countryPicker
//            arrowButton.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
            _txtCountryName.placeholder = validationMessage.accountTxtCountry.localized
            _txtCountryName.addTarget(self, action: #selector(onTap(_:)), for: .touchDown)
            _txtCountryName.addTarget(self, action: #selector(onEnd(_:)), for: .editingDidEnd)
             
        }
    }
    @IBOutlet weak var toggle: Toggle!
       
    @IBAction func toogleInside(_ sender: Any) {
        if(self._lblNotification.isEnabled == true){
            self._lblNotification.isEnabled = false
            UserDefaults.standard.set(false, forKey: "offerNotification")

        }
        else{
            self._lblNotification.isEnabled = true
             UserDefaults.standard.set(true, forKey: "offerNotification")
        }
    }
    
    @IBOutlet weak var btnContinue: UIButton! {
        didSet {
            btnContinue.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnCreateHighlight), forState: .highlighted)
            btnContinue.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnCreateNormal), forState: .normal)
            
            btnContinue.setTitle(validationMessage.slideContinue.localized, for: .normal)
            
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnContinue.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            }
        }
    }
    
    @IBOutlet weak var countryView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
            countryView.addGestureRecognizer(gesture)
        }
    }
    @objc func checkAction(sender : UITapGestureRecognizer){
        if _txtCountryName.isFirstResponder {
            _txtCountryName.resignFirstResponder()
            arrowButton.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
        } else {
            _txtCountryName.becomeFirstResponder()
            arrowButton.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
        }
    }
    @IBAction func arrowTapped() {
        if _txtCountryName.isFirstResponder {
            _txtCountryName.resignFirstResponder()
            arrowButton.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
        } else {
            _txtCountryName.becomeFirstResponder()
            arrowButton.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        btnContinue.isEnabled = false
        _lblNotification.text = "registerlblNotification".localized
        imgCountryFlag.isHidden = true
    }
    
    @objc func onTap(_ sender:UITextField){
        arrowButton.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
        if _txtCountryName.text == "" {
            btnContinue.isUserInteractionEnabled = false
            btnContinue.alpha = 0.5
        }else{
            btnContinue.isUserInteractionEnabled = true
            btnContinue.alpha = 1.0
        }
       
        
    }
    @objc func onEnd(_ sender:UITextField) {
        arrowButton.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
        if selectedCountryName != nil{
                   _txtCountryName.text = selectedCountryName
                   //imgCountryFlag.image = nil
                   if selectedCountryFlag != nil {
                       //UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlags")
                       //UserDefaults.standard.setValue(selectedCountryName, forKey: "countryName")
                       imgCountryFlag.isHidden = false
                       imgCountryFlag.sd_setImage(with: URL(string: selectedCountryFlag!), placeholderImage: UIImage(named: "ic_flag"))
                         //UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
                      // UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
                       //UserDefaults.standard.setValue(selectedCountry, forKey: "country")
                       //UserDefaults.standard.setValue(selectedCurrency, forKey: "currency")
                   }
               } else {
                   _txtCountryName.text = data._source?.countryList[0].name
                   let flag = data._source?.countryList[0].flag
                   imgCountryFlag.isHidden = false
                   imgCountryFlag.sd_setImage(with: URL(string: flag!), placeholderImage: UIImage(named: "ic_flag"))
                   guard let source = data._source else { return }
                   selectedStoreCode = source.countryList[0].storecode
                   //UserDefaults.standard.setValue(selectedStoreCode, forKey: "selectedStoreCode")
                   //UserDefaults.standard.setValue(source.countryList[0].flag, forKey: "flagurl")
                   selectedCountry = source.countryList[0].name
                   selectedCurrency = source.countryList[0].currency
                   selectedCountryFlag = source.countryList[0].flag
                   selectedCountryName = selectedCountry
                   //UserDefaults.standard.setValue(flag, forKey: "countryFlags")
                   //UserDefaults.standard.setValue(_txtCountryName.text, forKey: "countryName")
                  // if UserDefaults.standard.value(forKey: "flagurl") != nil{
                   //UserDefaults.standard.setValue(data._source?.countryList[0].flag, forKey: "flagurl")
                  // }
                   //selectedStoreCode = data._source?.countryList[0].storecode as! String
                   //selectedCountry = data._source?.countryList[0].name as! String
                   //selectedCountry =  selectedCountry.replaceString(" ", withString: "")
                   //selectedCurrency = data._source?.countryList[0].currency as! String
                  // UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
                   //UserDefaults.standard.setValue(selectedCountry, forKey: "country")
                  // UserDefaults.standard.setValue(selectedCurrency, forKey: "currency")
               }
        if _txtCountryName.text == ""{
            btnContinue.isUserInteractionEnabled = false
            btnContinue.alpha = 0.5
        } else {
            btnContinue.isUserInteractionEnabled = true
            btnContinue.alpha = 1.0
        }
        btnContinue.isEnabled = _txtCountryName.text?.count ?? 0 > 0
    }
    
    func selectCurrentCountryIfPossible() {
        let name = Locale.getCurrentCountryName()
        guard let list = data._source?.countryList else { return }
        for (i, country) in list.enumerated() {
            if country.name == name {
                pickerView(countryPicker, didSelectRow: i, inComponent: 0)
                onEnd(_txtCountryName)
                return
            }
        }
    }
}

extension ChooseCountry: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data._source?.countryList.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let source = data._source else { return }
        selectedStoreCode = source.countryList[row].storecode
        //UserDefaults.standard.setValue(selectedStoreCode, forKey: "selectedStoreCode")
        UserDefaults.standard.setValue(source.countryList[row].flag, forKey: "flagurl")
        selectedCountry = source.countryList[row].name
        selectedCurrency = source.countryList[row].currency
        selectedCountryFlag = source.countryList[row].flag
        selectedCountryName = source.countryList[row].name
       
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = data._source?.countryList[row].name
        return label
    }
}


