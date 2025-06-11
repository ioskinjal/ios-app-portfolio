//
//  UserProfileUpdateVC.swift
//  OTT
//
//  Created by Pramodkumar on 30/09/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import MaterialComponents
protocol UserProfileUpdateDelegate : class {
    func updateUserDetails()
}
class UserProfileUpdateVC: UIViewController {
    @IBOutlet weak var navigationView : UIView!
    @IBOutlet weak var firstNameTf: MDCTextField!
    @IBOutlet weak var lastNameTf: MDCTextField!
    @IBOutlet weak var dobTf: MDCTextField!
    @IBOutlet weak var continueButton : UIButton!
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var toolBar : UIToolbar!
    @IBOutlet var checkBoxImageViewArray: [UIImageView]!
    @IBOutlet var genderLabelsArray: [UILabel]!
    var firstNameControler: MDCTextInputControllerOutlined?
    var lastNameController: MDCTextInputControllerOutlined?
    var dobController: MDCTextInputControllerOutlined?
    var genderIndex = -1
    var tempTimeInterval : TimeInterval!
    weak var delegate : UserProfileUpdateDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for label in genderLabelsArray {
            label.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        setupUI()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    private func setupUI() {
        datePicker.maximumDate = Date()
        continueButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        continueButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        continueButton.cornerDesignWithoutBorder()
        continueButton.setTitle("Update".localized, for: .normal)
        continueButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        firstNameTf.font = UIFont.ottRegularFont(withSize: 14)
        lastNameTf.font = UIFont.ottRegularFont(withSize: 14)
        dobTf.font = UIFont.ottRegularFont(withSize: 14)
        dobTf.inputView = datePicker
        dobTf.inputAccessoryView = toolBar
        firstNameControler = MDCTextInputControllerOutlined(textInput: firstNameTf)
        firstNameControler?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameControler?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameControler?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameControler?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameControler?.textInput?.textColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameControler?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        firstNameTf.center = .zero
        firstNameTf.clearButtonMode = .never
        
        lastNameController = MDCTextInputControllerOutlined(textInput: lastNameTf)
        lastNameController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        lastNameTf.center = .zero
        lastNameTf.clearButtonMode = .never
        
        dobController = MDCTextInputControllerOutlined(textInput: dobTf)
        dobController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        dobTf.center = .zero
        dobTf.clearButtonMode = .never
        if let name = OTTSdk.preferenceManager.user?.firstName, name.count > 0 {
            firstNameTf.text = name
        }
        if let lastname = OTTSdk.preferenceManager.user?.lastName, lastname.count > 0 {
            lastNameTf.text = lastname
        }
        if let firstname = OTTSdk.preferenceManager.user?.firstName, firstname.count == 0, let lastname = OTTSdk.preferenceManager.user?.lastName, lastname.count == 0, let name = OTTSdk.preferenceManager.user?.name, name.count > 0 {
            firstNameTf.text = name
        }
        if let dob = OTTSdk.preferenceManager.user?.dob, dob.doubleValue > 0 {
            tempTimeInterval = dob.doubleValue// / 1000.0
            dobTf.text = tempTimeInterval.getDateOfBirth()
            datePicker.date = Date(timeIntervalSince1970: tempTimeInterval/1000)
        }
        if let gender = OTTSdk.preferenceManager.user?.gender, gender.count > 0 {
            updateGender(gender)
        }
    }
    private func updateGender(_ gender : String) {
        switch gender {
        case "M":
            genderIndex = 0
        case "F":
            genderIndex = 1
        case "O":
            genderIndex = 2
        default:
            genderIndex = -1
        }
        updateData()
    }
    private func getGenderString()->String {
        switch genderIndex {
        case 0: return "M"
        case 1: return "F"
        case 2: return "O"
        default:
            return ""
        }
    }
    private func updateData() {
        for imageView in checkBoxImageViewArray {
            imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_normal")
        }
        if genderIndex >= 0 {
            if let imageView = checkBoxImageViewArray.first(where: {$0.tag == genderIndex}) {
                imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_selected")
            }
        }
    }
    @IBAction func doneButtonAction(_ sender : Any) {
        dobTf.resignFirstResponder()
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTf.text = tempTimeInterval.getDateOfBirth()
    }
    @IBAction func datePickerValueChanged(_ sender : UIDatePicker) {
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTf.text = tempTimeInterval.getDateOfBirth()
    }
    @IBAction func backAction(_ sender : Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func genderButtonAction(_ sender : UIButton) {
        genderIndex = sender.tag
        updateData()
    }
    @IBAction func updateUserInfoAction(_ sender : Any) {
        view.endEditing(true)
        guard let firstName = firstNameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines), firstName.count > 0 else {
            errorAlert(forTitle: String.getAppName(), message: "Please enter First Name".localized, needAction: false) { flag in}
            return
        }
        guard checkSpecialCharacters(firstName.components(separatedBy: .whitespaces).joined()) == true else {
            errorAlert(forTitle: String.getAppName(), message: "First Name should not contain special characters and numbers".localized, needAction: false) { flag in}
            return
        }
        guard let lastName = lastNameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines), lastName.count > 0 else {
            errorAlert(forTitle: String.getAppName(), message: "Please enter Last Name".localized, needAction: false) { flag in}
            return
        }
        guard let dob = dobTf.text?.trimmingCharacters(in: .whitespacesAndNewlines), dob.count > 0 else {
            errorAlert(forTitle: String.getAppName(), message: "Please select Date Of Birth".localized, needAction: false) { flag in}
            return
        }
        guard genderIndex >= 0 else {
            errorAlert(forTitle: String.getAppName(), message: "Please select Gender".localized, needAction: false) { flag in}
            return
        }
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = datePicker.date.getCurrentTimeStamp()
        let timezoneEpochOffset = (epochDate + Int64(timezoneOffset))
        self.startAnimating(allowInteraction: true)//"\(tempTimeInterval ?? 0)"
        OTTSdk.userManager.updateUserDetails(first_name: firstName, last_name: lastName, email_id: nil, grade: nil, board: nil, targeted_exam: nil, email_notification: nil, date_of_birth: "\(timezoneEpochOffset)", iit_jee_neet_application_no: nil, gender: getGenderString(), onSuccess: { (response) in
            self.delegate.updateUserDetails()
            self.errorAlert(forTitle: String.getAppName(), message: response, needAction: true) { flag in
               self.navigationController?.popViewController(animated: true)
            }
            self.stopAnimating()
        }) { (error) in
            self.stopAnimating()
            self.errorAlert(forTitle: String.getAppName(), message: error.description, needAction: false) { flag in}
        }
    }
}
extension UserProfileUpdateVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTf, tempTimeInterval != nil {
            datePicker.date = Date(timeIntervalSince1970: tempTimeInterval/1000)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTf {
            return checkSpecialCharacters(string) && range.location < 50
        }else if textField == lastNameTf {
            return checkSpecialCharacters(string) && range.location < 50
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    private func checkSpecialCharacters(_ string : String)->Bool {
        let letters = CharacterSet.letters
        let whiteSpaces = CharacterSet.whitespaces
        let characterSet = CharacterSet(charactersIn: string)
        return (letters.isSuperset(of: characterSet) || whiteSpaces.isSuperset(of: characterSet))
    }
}
