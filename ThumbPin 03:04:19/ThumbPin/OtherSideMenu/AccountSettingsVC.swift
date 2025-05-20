//
//  AccountSettingsVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class AccountSettingsVC: BaseViewController {

    @IBOutlet weak var labelLanguageSettings: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var txtLanguages: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var txtCurrentPassword: CustomTextField!
    @IBOutlet weak var labelChangePassword: UILabel!
    
    static var storyboardInstance:AccountSettingsVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: AccountSettingsVC.identifier) as? AccountSettingsVC
    }
    var arrLanguagelist = [LanguageList]()
    var pickerViewLanguage = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewLanguage.delegate = self
        txtLanguages.inputView = pickerViewLanguage
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApiGetlanguageList()
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetlanguageList() {
        let dictParam = [
            "action": Action.getLanguage,
            "lId": UserData.shared.getLanguage,
        ] as [String : Any]
        ApiCaller.shared.geLanguageList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.arrLanguagelist = ResponseKey.fatchData(res: dict, valueOf: .data).ary.map({LanguageList(dic: $0 as! [String:Any])})
            self.showLanguage()
        }
    }
    func showLanguage() {
        for i in 0..<self.arrLanguagelist.count {
            if self.arrLanguagelist[i].lId == UserData.shared.getLanguage {
                self.txtLanguages.text = self.arrLanguagelist[i].languageName
            }
        }
        if (txtLanguages.text?.isEmpty)! {
            if arrLanguagelist.count > 0 {
                txtLanguages.text = arrLanguagelist[0].languageName
            }
        }
    }
    func callApiChangePassword() {
        let dictParam = [
            "action": Action.changePassword,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "password": txtCurrentPassword.text!,
            "npassword": txtNewPassword.text!,
            "cpassword": txtConfirmPassword.text!,
        ] as [String : Any]
        ApiCaller.shared.changePassword(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Account Setting")
        labelChangePassword.text = localizedString(key: "Change Password")
        txtCurrentPassword.placeholder = localizedString(key: "Enter current password")
        txtNewPassword.placeholder = localizedString(key: "Enter new password")
        txtConfirmPassword.placeholder = localizedString(key: "Confirm password")
        btnSave.setTitle(localizedString(key: "Save"), for: .normal)
        labelLanguageSettings.text = localizedString(key: "Language Settings")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtCurrentPassword.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.password)
            return false
        }
        else if (txtNewPassword.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.newpassword)
            return false
        }
        else if (txtConfirmPassword.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.confirmpassword)
            return false
        }
        else if (txtCurrentPassword.text?.count)! < 6 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.minipassword)
            return false
        }
        else if (txtNewPassword.text?.count)! < 6 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.minipassword)
            return false
        }
        else if (txtConfirmPassword.text?.count)! < 6 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.minipassword)
            return false
        }
        else if txtNewPassword.text != txtConfirmPassword.text {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.confirmPassword)
            return false
        }
        return true
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if checkValidation() {
            callApiChangePassword()
        }
    }
}
extension AccountSettingsVC: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLanguagelist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLanguagelist[row].languageName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtLanguages.text = arrLanguagelist[row].languageName
        UserData.shared.setLanguage(language: arrLanguagelist[row].lId)
        setUpLang()
        NotificationCenter.default.post(name: .changeLangNotifi, object: nil)
    }
}
