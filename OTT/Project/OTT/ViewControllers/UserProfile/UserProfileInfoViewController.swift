//
//  UserProfileInfoViewController.swift
//  OTT
//
//  Created by Rajesh Nekkanti on 17/03/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import MaterialComponents
import OTTSdk

class UserProfileInfoViewController: UIViewController {
    @IBOutlet weak var profileScrollView: UIScrollView?
    @IBOutlet weak var profileBgView: UIView?
    
    @IBOutlet weak var firstName: MDCTextField!
    @IBOutlet weak var LastName: MDCTextField!
    @IBOutlet weak var email: MDCTextField!
    @IBOutlet weak var dateOfBirth: MDCTextField!
    @IBOutlet weak var hallTicketNo: MDCTextField!
    @IBOutlet weak var grade: MDCTextField!
    @IBOutlet weak var board: MDCTextField!
    @IBOutlet weak var targetedExam: MDCTextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailAcceptButton: UIButton?
    
    var isGradePickerHandled : Bool = false
    var isBoardPickerHandled : Bool = false
    var isTargerPickerHandled : Bool = false
    var selectedGrade: String?
    var selectedBoard: String?
    var selectedTarget: String?
    
    var receiveMail:Bool = false
    
    var gradeList = [String]()
    var boardList = [String]()
    var targetList = [String]()
    
    var gradeObject:UserFormElement?
    var boardObject:UserFormElement?
    var targetObject:UserFormElement?
    
    
    var firstController: MDCTextInputControllerOutlined?
    var lastController: MDCTextInputControllerOutlined?
    var emailController: MDCTextInputControllerOutlined?
    var dobController: MDCTextInputControllerOutlined?
    var hallController: MDCTextInputControllerOutlined?
    var gradeController: MDCTextInputControllerOutlined?
    var boardController: MDCTextInputControllerOutlined?
    var targetedController: MDCTextInputControllerOutlined?
    
    var pickerViewGrade = UIPickerView()
    var pickerViewBoard = UIPickerView()
    var pickerViewTarget = UIPickerView()
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    @IBOutlet weak var nextButton: UIButton?
    @IBOutlet weak var headerLabel1: UILabel?
    @IBOutlet weak var headerLabel2: UILabel?
    @IBOutlet weak var headerLabel2HeightConstraint: NSLayoutConstraint?
    
    var isFromAccountPage:Bool = false
    
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
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.profileScrollView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.profileBgView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        //        self.backButton?.isHidden = true
        gradeList = ["Male", "Female", "Others"]
        if let name = OTTSdk.preferenceManager.user?.name, name.count > 0 {
            firstName.text = name
        }
        if let dob = OTTSdk.preferenceManager.user?.dob, dob.doubleValue > 0 {
            dateOfBirth.text = dob.doubleValue.getDateOfBirth()
        }
        if let gender = OTTSdk.preferenceManager.user?.gender, gender.count > 0 {
            grade.text = gender
        }
        self.emailAcceptButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.headerLabel1?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.headerLabel2?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.nextButton?.setButtonBackgroundcolor()
        setupToHideKeyboardOnTapOnView()
        firstController = MDCTextInputControllerOutlined(textInput: firstName)
        lastController = MDCTextInputControllerOutlined(textInput: LastName)
        emailController = MDCTextInputControllerOutlined(textInput: email)
        dobController = MDCTextInputControllerOutlined(textInput: dateOfBirth)
        hallController = MDCTextInputControllerOutlined(textInput: hallTicketNo)
        gradeController = MDCTextInputControllerOutlined(textInput: grade)
        boardController = MDCTextInputControllerOutlined(textInput: board)
        targetedController = MDCTextInputControllerOutlined(textInput: targetedExam)
        
        firstController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        firstController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        firstController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        firstController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        firstController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        firstName.center = .zero
        firstName.clearButtonMode = .never
        
        
        lastController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        lastController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        lastController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        lastController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        lastController?.textInput?.textColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        LastName.center = .zero
        LastName.clearButtonMode = .never
        
        
        
        emailController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        emailController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        emailController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        emailController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        emailController?.textInput?.textColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        email.center = .zero
        email.clearButtonMode = .never
        
        
        dobController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        dateOfBirth.center = .zero
        dateOfBirth.clearButtonMode = .never
        
        hallController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        hallController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        hallController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        hallController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        hallController?.textInput?.textColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        hallTicketNo.center = .zero
        hallTicketNo.clearButtonMode = .never
        
        
        gradeController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        gradeController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        gradeController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        gradeController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        gradeController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        grade.center = .zero
        grade.clearButtonMode = .never
        
        
        boardController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        boardController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        boardController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        boardController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        boardController?.textInput?.textColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        board.center = .zero
        board.clearButtonMode = .never
        
        targetedController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        targetedController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        targetedController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        targetedController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        targetedController?.textInput?.textColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        targetedExam.center = .zero
        targetedExam.clearButtonMode = .never
        
        
        pickerViewGrade.delegate = self
        grade.inputView = pickerViewGrade
        
        pickerViewBoard.delegate = self
        board.inputView = pickerViewBoard
        
        
        pickerViewTarget.delegate = self
        targetedExam.inputView = pickerViewTarget
        
        
        self.dismissPickerView()
        self.showDatePicker()
        //        self.callGradServer()
        if self.isFromAccountPage {
            self.fillUpUserDetails()
            self.nextButton?.setTitle("Update".localized, for: .normal)
            self.headerLabel1?.text = "Profile"
            self.headerLabel2?.isHidden = true
            self.headerLabel2HeightConstraint?.constant = 0.0
            self.backButton?.isHidden = false
        } else {
            self.headerLabel1?.text = "Hey! welcome"
            self.headerLabel2?.isHidden = false
            self.headerLabel2HeightConstraint?.constant = 21.0
            self.backButton?.isHidden = true
        }
    }
    
    func fillUpUserDetails() {
        if let user = OTTSdk.preferenceManager.user {
            self.firstController?.textInput?.text = user.firstName
            self.lastController?.textInput?.text = user.lastName
            self.emailController?.textInput?.text = user.email
            self.hallController?.textInput?.text = user.attributes.iit_jee_neet_application_no
            self.gradeController?.textInput?.text = user.attributes.grade
            self.boardController?.textInput?.text = user.attributes.board
            self.targetedController?.textInput?.text = user.attributes.targeted_exam
            self.dobController?.textInput?.text = Date().getFullDate("\(user.dob.intValue)")
        }
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.maximumDate = maxDate
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton,doneButton], animated: false)
        dateOfBirth.inputAccessoryView = toolbar
        dateOfBirth.inputView = datePicker
    }
    
    @objc
    func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    
    
    func callGradServer()  {
        OTTSdk.userManager.getUserFormElements(onSuccess: { (userInfo) in
            let predicate = NSPredicate(format: "code == %@", "grade")
            let filteredarr = userInfo.filter { predicate.evaluate(with: $0) };
            self.gradeObject = filteredarr[0]
            self.gradeList = (self.gradeObject?.info.value.components(separatedBy: ","))!
            
            let predicateBoard = NSPredicate(format: "code == %@", "board")
            let filteredarrBoard = userInfo.filter { predicateBoard.evaluate(with: $0) };
            self.boardObject = filteredarrBoard[0]
            self.boardList = (self.boardObject?.info.value.components(separatedBy: ","))!
            
        }) { (error) in
            Log(message: "\(error)")
        }
    }
    
    func callBoardServce(_ formCode:String, _ groupCode:String) {
        OTTSdk.userManager.getNextUserFormElements(form_code:formCode , group_code: groupCode, onSuccess: { (boardInfo) in
            if boardInfo.count != 0 {
                self.targetObject = boardInfo[0]
                self.targetList = (self.targetObject?.info.value.components(separatedBy: ","))!
                Log(message: "\(self.boardList)")
            }else {
                self.targetList.removeAll()
            }
        }) { (error) in
            Log(message: "\(error)")
        }
    }
    
    
    func dismissPickerView() {
        toolBar.sizeToFit()
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([flexibleButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        grade.inputAccessoryView = toolBar
        board.inputAccessoryView = toolBar
        targetedExam.inputAccessoryView = toolBar
        dateOfBirth.inputAccessoryView = toolBar
        
    }
    
    @objc func action() {
        if (board.isFirstResponder && isBoardPickerHandled == false && (self.boardList.count > 0)){
            selectedBoard = boardList[0] // selected item
            board.text = selectedBoard
        }
        else if (grade.isFirstResponder && isGradePickerHandled == false &&  (self.gradeList.count > 0)){
            selectedGrade = gradeList[0] // selected item
            grade.text = selectedGrade
            targetedExam.text = ""
            //            self.callBoardServce(self.gradeObject!.nextForm, selectedGrade!)
        }
        else if (targetedExam.isFirstResponder  && isTargerPickerHandled == false  &&  (self.targetList.count > 0)){
            self.targetedExam.text = self.targetList[0]
        }
        view.endEditing(true)
    }
    
    func checkContainsNumbers(inputStr:String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = inputStr.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        } else {
            return false
        }
    }
    
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: true) { (flag) in
            if self.firstName.text == "" && self.LastName.text == "" && self.email.text == "" && flag {
                self.firstName.becomeFirstResponder()
            }
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        // self.printLog(log:"validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func emailAcceptence(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitle("  Yes, I want to receive \(String.getAppName()) Emails ", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "user_profile_checkbox_selected"), for: .normal)
            receiveMail = true
        } else{
            sender.setTitle("  Yes, I want to receive \(String.getAppName()) Emails ", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "user_profile_checkbox_normal"), for: .normal)
            receiveMail = false
            
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        var firstNameFeild = self.firstName.text
        var lastNameFeild = self.LastName.text
        var emailNameFeild = self.email.text
        var gradeFeild = self.grade.text
        var boardFeild = self.board.text
        var targetExamFeild = self.targetedExam.text
        let dateOfBirthFeild = self.dateOfBirth.text
        
        if firstNameFeild == "" {
            self.showAlertWithText(String.getAppName(), message: "Please enter First Name".localized)
            return
        } else if self.checkContainsNumbers(inputStr: firstNameFeild!) {
            self.showAlertWithText(String.getAppName(), message: "Full Name should not contain numbers".localized)
            return
        }
        /*if lastNameFeild == "" {
         self.showAlertWithText(String.getAppName(), message: "Please enter Last Name".localized)
         return
         } else if self.checkContainsNumbers(inputStr: lastNameFeild!) {
         self.showAlertWithText(String.getAppName(), message: "Last Name should not contain numbers".localized)
         return
         }
         let newString = (emailNameFeild!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)) as String
         
         if newString == "" {
         self.showAlertWithText(String.getAppName(), message: "Please enter Email ID".localized)
         return
         }
         if !(newString .isEmpty) {
         if !isValidEmail(testStr: newString) {
         self.showAlertWithText(String.getAppName(), message: "Please enter a valid Email Id".localized)
         return
         }
         }*/
        if dateOfBirthFeild == "" {
            self.showAlertWithText(String.getAppName(), message: "Please select Date Of Birth".localized)
            return
        }
        
        if gradeFeild == "" {
            self.showAlertWithText(String.getAppName(), message: "Please select Gender".localized)
            return
        }
        /*if boardFeild == "" {
         self.showAlertWithText(String.getAppName(), message: "Please select Board".localized)
         return
         }
         if targetExamFeild == "" {
         self.showAlertWithText(String.getAppName(), message: "Please select Target Exam".localized)
         return
         }
         if receiveMail == false {
         self.showAlertWithText(String.getAppName(), message: "Please select check Box".localized)
         return
         }*/
        if let user = OTTSdk.preferenceManager.user {
            if user.firstName == firstNameFeild {
                firstNameFeild = nil
            }
            if user.lastName == lastNameFeild {
                lastNameFeild = nil
            }
            if user.email == emailNameFeild{
                emailNameFeild = nil
            }
            if user.attributes.grade == gradeFeild {
                gradeFeild = nil
            }
            if user.attributes.board == boardFeild {
                boardFeild = nil
            }
            if user.attributes.targeted_exam == targetExamFeild{
                targetExamFeild = nil
            }
        }
        /*self.startAnimating(allowInteraction: true)
         OTTSdk.userManager.updateUserDetails(first_name: firstNameFeild, last_name: lastNameFeild, email_id: emailNameFeild, grade: gradeFeild, board: boardFeild, targeted_exam: targetExamFeild, email_notification: self.receiveMail,date_of_birth: dateOfBirthFeild!, iit_jee_neet_application_no: self.hallTicketNo.text!, onSuccess: { (message) in
         if self.isFromAccountPage {
         self.navigationController?.popViewController(animated: true)
         }
         else{
         TargetPage.userNavigationPage(fromViewController: self, shouldUpdateUserObj: true, actionCode: -1) { (pageType) in
         switch pageType {
         case .home :
         if playerVC != nil {
         playerVC?.showHidePlayerView(false)
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
         _ = self.navigationController?.popViewController(animated: true)
         let topVC = UIApplication.topVC()!
         topVC.navigationController?.popViewController(animated: true)
         } else {
         AppDelegate.getDelegate().loadHomePage(toFristViewController : true)
         }
         break;
         case .packages:
         AppDelegate.getDelegate().loadNoPackagesPage()
         break;
         case .userProfile:
         break;
         case .OTP:
         break;
         case .unKnown:
         self.showAlertWithText(message: "Something went wrong")
         break;
         }
         }
         }
         
         self.stopAnimating()
         }) { (error) in
         self.showAlertWithText(String.getAppName(), message: error.message)
         self.stopAnimating()
         }*/
    }
    
    func checkContainsCharacters(inputStr:String) -> Bool {
        
        let charStatusArr = NSMutableArray()
        
        
        for chr in inputStr{
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                charStatusArr.add(NSNumber.init(value: false))
            }
            else {
                charStatusArr.add(NSNumber.init(value: true))
            }
        }
        if charStatusArr.contains(NSNumber.init(value: true)) {
            return true
        }
        else {
            return false
        }
    }
    
}

extension UserProfileInfoViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        isGradePickerHandled = false
        isBoardPickerHandled = false
        isTargerPickerHandled = false
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewGrade  {
            return gradeList.count // number of dropdown items
        }else if pickerView == pickerViewBoard {
            return boardList.count // number of dropdown items
        }else if pickerView == pickerViewTarget {
            return targetList.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewGrade  {
            return gradeList[row] // dropdown item
        }else if pickerView == pickerViewBoard {
            return boardList[row] // dropdown item
        }else if pickerView == pickerViewTarget {
            return targetList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewGrade  {
            isGradePickerHandled = true
            selectedGrade = gradeList[row] // selected item
            grade.text = selectedGrade
            targetedExam.text = ""
            //            self.callBoardServce(self.gradeObject!.nextForm, selectedGrade!)
        }else if pickerView == pickerViewBoard {
            isBoardPickerHandled = true
            selectedBoard = boardList[row] // selected item
            board.text = selectedBoard
        }else if pickerView == pickerViewTarget {
            isTargerPickerHandled = true
            if targetList.isEmpty {
                return
            }else {
                selectedTarget = targetList[row]
                targetedExam.text = selectedTarget
            }
        }
        
    }
    
    
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UserProfileInfoViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}



