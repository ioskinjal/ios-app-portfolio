//
//  MyLanguageTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SwiftSVG
import Firebase

class MyLocationTableCell: UITableViewCell {
    
    let countryPicker = UIPickerView()
    var selectedStoreCode = ""
    var selectedFlag = ""
    var parentVC = MyAccountViewController()
    var selectedCountry = ""
    //    var data : onBoardingData?
    
    
    
    @IBOutlet weak var _lblMyLocation: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblMyLocation.font = UIFont(name: "Cairo-SemiBold", size: _lblMyLocation.font.pointSize)
            }
            _lblMyLocation.text =  "accountLocation".localized
        }
    }
    @IBOutlet weak var _lblChooseCountry: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblChooseCountry.font = UIFont(name: "Cairo-Light", size: _lblChooseCountry.font.pointSize)
            }
            _lblChooseCountry.text =  "accountChooseCountry".localized
        }
    }
    @IBOutlet weak var _imgCountryFlag: UIImageView!
    @IBOutlet weak var _txtCountryName: UITextField!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _txtCountryName.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            countryPicker.delegate = self
            self._txtCountryName.delegate = self
            self._txtCountryName.inputView = self.countryPicker
            //                       txtCountry.delegate = self
            
            _ = SVGView.init(SVGNamed: "ic_dropdown")
           // _txtCountryName.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            _txtCountryName.placeholder = validationMessage.accountChooseCountry.localized
            _txtCountryName.addTarget(self, action: #selector(onTap(_:)), for: .touchDown)
            _txtCountryName.addTarget(self, action: #selector(onEnd(_:)), for: .editingDidEnd)
            
        }
        
    }
    var data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    
    
    
    @objc func onTap(_ sender:UITextField){
      //  _txtCountryName.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_up"))
        
        _txtCountryName.text = data._source?.countryList[0].name
        self.selectedStoreCode = self.data._source?.countryList[0].storecode ?? ""
        self.selectedCountry = self.data._source?.countryList[0].name ?? ""
        selectedCurrency = self.data._source?.countryList[0].currency  ?? ""
        selectedFlag = self.data._source?.countryList[0].flag ?? ""
        
    }
    
    @objc func onEnd(_ sender:UITextField){
      //  _txtCountryName.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
        
    }
    
    //
    //    stic let nib = UINib(nibName: MyLanguageTableViewCell.name, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //  _imgCountryFlag.sd_setImage(with: URL(string:(data._source?.countryList[0].flag)!), placeholderImage: UIImage(named: ""))
        //        self.imgBack.downLoadImage(url: (data?._source?.onBoardingList[1].url)!)
    }
    func updateLocatioCell(){
        for i in 0..<(data._source?.countryList.count)! {
            let strName = UserDefaults.standard.string(forKey: "country") ?? ""
            if strName == data._source?.countryList[i].name{
                UserDefaults.standard.setValue(data._source?.countryList[i].name, forKey: "countryName")
                 UserDefaults.standard.setValue(data._source?.countryList[i].flag, forKey: "flagurl")
                _imgCountryFlag.downloadSdImage(url: data._source?.countryList[i].flag ?? "")
            }
        }
        
        print(data._source?.countryList[0].flag)
        if UserDefaults.standard.value(forKey: "flagurl") != nil {
            _imgCountryFlag.downloadSdImage(url: "\(UserDefaults.standard.value(forKey: "flagurl") ?? "")" )
        }else{
            _imgCountryFlag.sd_setImage(with: URL(string:(data._source?.countryList[0].flag)!), placeholderImage: UIImage(named: ""))
        }
        if UserDefaults.standard.value(forKey: "countryName") != nil{
            _txtCountryName.text = "\(UserDefaults.standard.value(forKey: "countryName") ?? "")"
        }else{
            _txtCountryName.text = data._source?.countryList[0].name
        }
        
        //        isCountryCodeChanged = true
        //        
        //        let vc = LatestHomeViewController.storyboardInstance!
        //        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
}

extension MyLocationTableCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data._source?.countryList.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _txtCountryName.text = data._source?.countryList[row].name
        self.selectedStoreCode = self.data._source?.countryList[row].storecode ?? ""
        self.selectedCountry = self.data._source?.countryList[row].name ?? ""
        selectedCurrency = self.data._source?.countryList[row].currency  ?? ""
        selectedFlag = self.data._source?.countryList[row].flag as? String ?? ""
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
extension MyLocationTableCell:UITextFieldDelegate{
    
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let userCountry = UserDefaults.standard.value(forKey: "countryName") as? String ?? ""
        if (self.selectedCountry != "" && self.selectedCountry != userCountry) {
            let refreshAlert = UIAlertController(title: "refresh".localized, message: "change_country".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                
                self.selectedCountry =  self.selectedCountry.replaceString(" ", withString: "")
                UserDefaults.standard.setValue(self.selectedCountry, forKey: "countryName")
                self._imgCountryFlag.sd_setImage(with: URL(string:self.selectedFlag), placeholderImage: UIImage(named: ""))
                UserDefaults.standard.setValue(self.selectedFlag, forKey: "flagurl")
                isCountryCodeChanged = true
                UserDefaults.standard.setValue(self.selectedStoreCode, forKey: "storecode")
                UserDefaults.standard.setValue(self.selectedCountry, forKey: "country")
                UserDefaults.standard.setValue(selectedCurrency, forKey: "currency")
                UserDefaults.standard.removePersistentDomain(forName: "UserKey")
                UserDefaults.standard.removeObject(forKey: "UserKey")
                UserDefaults().synchronize()
                
                //User is Not Loggedin case Handle
                UserDefaults.standard.set(nil,forKey: "userToken")
                userLoginStatus(status: false)
                M2_isUserLogin = false
                
                //Analytics: Set user properties
                let selectedCountryName = UserDefaults.standard.value(forKey: "countryName")
                let selectedLanguage = UserDefaults.standard.value(forKey: string.userLanguage)
                Analytics.setUserProperty("\(selectedCountryName ?? "")", forName: "Country")
                Analytics.setUserProperty("\(selectedLanguage ?? "")", forName: "Language")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                UserDefaults.standard.setValue(nil, forKey: "guest_carts__item_quote_id")
                UserDefaults.standard.setValue(nil, forKey: "quote_id_to_convert")
                UIApplication.shared.keyWindow?.rootViewController = nextViewController
                
                    // To remove badge count in cart tab 
                UserDefaults.standard.set(0, forKey: string.shopBagItemCount)
                NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
                    
                    UserDefaults.standard.set(0, forKey: string.notificationItemCount)
                    NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self._txtCountryName.text = userCountry
                //self._imgCountryFlag.downloadSdImage(url: UserDefaults.standard.value(forKey: "flagurl") as? String ?? "")
            }))
            
            self.parentVC.present(refreshAlert, animated: true)
        }
    }
}
