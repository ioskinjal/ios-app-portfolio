//
//  VerifyMobileVC.swift
//  YUPPTV
//
//  Created by Chandra Sekhar on 11/24/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
class VerifyMobileViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,CountySelectionProtocol {

    @IBOutlet weak var yourMblNumberLbl: UILabel!
    @IBOutlet weak var verifyHeaderLbl2: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var verifyHeaderLbl1: UILabel!
    @IBOutlet weak var verifyMblHeaderLbl: UILabel!
    @IBOutlet weak var newMobile_countryCodeDropDownTF: UITextField!
    @IBOutlet weak var newMobile_countryFlagImageView: UIImageView!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var textFieldDivView: UIView!
    
    @IBOutlet weak var newMobileNumberTF: UITextField!
    var countriesInfoArray:[Country]!
    
    var countryCodeContainer = UIView()
    var contryFlagimgView = UIImageView()
    var countryCodeLbl = UILabel()
    var countryCodeContainerWidth = CGFloat()
    
    var countryCodeTap : UITapGestureRecognizer!
    var emailImView = UIImageView()
    var viewControllerName = String()
    
    var accountDelegate : AccontDelegate?
    var targetVC : UIViewController?
    @IBAction func removeKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    @IBAction func BackAction(_ sender: AnyObject) {
        self.stopAnimating()
        let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if self.targetVC != nil{
            if self.navigationController!.viewControllers.contains(self.targetVC!){
                self.navigationController?.popToViewController(self.targetVC!, animated: true)
                return;
            }
            self.navigationController?.popViewController(animated: true)
        }
        if viewControllerName.isEqual("OTPVC") {
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is OTPViewController {
                    (aviewcontroller as! OTPViewController).isFromBackButton = true
                    _ =  self.navigationController?.popToViewController(aviewcontroller, animated: true)
                    break
                }
            }
        }
        else if viewControllerName == "ProfileVC" {
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is UserProfileViewController {
                    _ =  self.navigationController?.popToViewController(aviewcontroller, animated: true)
                }
            }
        }
        else if viewControllerName.isEqual("SignInVC") || viewControllerName.isEqual("SignUpVC"){
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is SignUpViewController || aviewcontroller is SignInViewController {
                    AppDelegate.getDelegate().loadHomePage()
                    break
                }
            }
            
        }
        else if viewControllerName == "PlayerVC" {
            self.dismiss(animated: true, completion: nil)
        }

        /*
       // AppDelegate.getDelegate().stopAnimating()
        let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllerName.isEqual("OTPVC") {
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is OTPVC {
                    (aviewcontroller as! OTPVC).isFromBackButton = true
                    _ =  self.navigationController?.popToViewController(aviewcontroller, animated: true)
                    break
                }
            }
        }
        else if viewControllerName.isEqual("TVShowDetailsVC") || viewControllerName.isEqual("BrowseDetailsVC") || viewControllerName.isEqual("MovieDetailsVC"){
            _ = self.navigationController?.popViewController(animated: true)
        }
        else if viewControllerName.isEqual("PLAYERVC") || viewControllerName.isEqual("TVShowsVC") {
//            AppDelegate .getDelegate().loadTabbar()
//            AppDelegate .getDelegate().tabbar.selectedIndex = AppDelegate.getDelegate().selectedTabBarIndex
        }
        else if viewControllerName.isEqual("SignInVC") || viewControllerName.isEqual("SignUpVC"){
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is SignUpVC || aviewcontroller is SignInVC {
//                    AppDelegate.getDelegate().loadTabbar()
                    break
                }
            }

        }*/
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)
        self.newMobileNumberTF.delegate = self
        self.countryCodeContainer = UIView(frame: CGRect(x: newMobile_countryCodeDropDownTF.frame.origin.x - 5, y: newMobile_countryCodeDropDownTF.frame.origin.y - 15, width: 110.0, height: 30.0))
        self.countryCodeContainer.backgroundColor = UIColor.clear
        self.yourMblNumberLbl.text = "  Mobile Number".localized
        self.verifyHeaderLbl2.text = "An OTP will be sent to your mobile number\nfor verification".localized
        self.verifyHeaderLbl1.text = "Enter Your Mobile Number".localized
        
        textfieldView.viewBorderWithOne(cornersRequired: true)
        textfieldView.changeBorder(color: AppTheme.instance.currentTheme.textFieldBorderColor)
        textFieldDivView.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        
        self.verifyBtn.setTitle("Get OTP".localized, for: UIControl.State.normal)
        self.verifyBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        countryCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.showCountriesInfoPopUp(_:)))
        countryCodeTap.delegate = self
        self.countryCodeContainer.addGestureRecognizer(countryCodeTap)
        
        self.contryFlagimgView = UIImageView(frame: CGRect(x: 2.0, y: 4.0, width: 16, height: 13))
        
        self.countryCodeLbl = UILabel(frame: CGRect(x: (contryFlagimgView.frame.origin.x+contryFlagimgView.frame.size.width) + 20.0, y: -4.5, width: 100, height: countryCodeContainer.frame.size.height))
        countryCodeLbl.textColor = UIColor.init(red: 188.0/255.0, green: 188.0/255.0, blue: 189.0/255.0, alpha: 1.0)
        countryCodeLbl.textAlignment = NSTextAlignment.left
        countryCodeLbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        
        let countryDropDownImView = UIImageView(frame: CGRect(x: countryCodeLbl.frame.origin.x + 40.0, y: 10, width: 7, height: 5))
        countryDropDownImView.image = #imageLiteral(resourceName: "country_dropdown_icon")
        
        
        countryCodeContainer.addSubview(contryFlagimgView)
        countryCodeContainer.addSubview(countryCodeLbl)
        countryCodeContainer.addSubview(countryDropDownImView)
        newMobile_countryCodeDropDownTF.leftView = self.countryCodeContainer
        newMobile_countryCodeDropDownTF.delegate = self
        newMobile_countryCodeDropDownTF.leftViewMode = UITextField.ViewMode.always
        
        if #available(iOS 10.0, *) {
            self.newMobileNumberTF.keyboardType = .asciiCapableNumberPad
        } else {
            self.newMobileNumberTF.keyboardType = .numberPad
            // Fallback on earlier versions
        }

        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.appManager.updateLocation(onSuccess: { (response) in

            var countryCode = ""
             if response.ipInfo.countryCode.count > 0 {
                countryCode = response.ipInfo.countryCode
             }
            
            
            OTTSdk.appManager.getCountries(onSuccess: { (response) in
                self.stopAnimating()
                self.countriesInfoArray = response
                let predicate = NSPredicate(format: "code == %@", countryCode)
                
                let filteredarr = self.countriesInfoArray.filter { predicate.evaluate(with: $0) };
                let dict = filteredarr[0]
                self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
                self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
            }) { (error) in
                Log(message: error.message)
                self.stopAnimating()
            }
            
        }) { (error) in
            Log(message: error.message)
        }
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == newMobileNumberTF {
            var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            newString = newString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
            if checkContainsCharacters(inputStr: newString as String) || checkContainsSpecialCharacters(inputString: newString)  {
                return false
            }
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 15
        }
        else {
            return true
        }
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
    
    func checkContainsSpecialCharacters(inputString:NSString) -> Bool {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if (inputString.rangeOfCharacter(from: characterSet.inverted).location == NSNotFound){
            return false
        }
        else {
            return true
        }
        
    }

    @objc func showCountriesInfoPopUp(_ sender: UITapGestureRecognizer? = nil) {
        /**/
        self.newMobileNumberTF.resignFirstResponder()
        let popvc = CountriesInfoPopupViewController()
        popvc.countriesArray = self.countriesInfoArray
        popvc.delegate = self
        self.present(popvc, animated: true, completion: nil)
        
    }

    // MARK: - end show popup
    @IBAction func UpdateMobileNumberAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.newMobileNumberTF.text = self.newMobileNumberTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if self.newMobileNumberTF.text != "" && self.countryCodeLbl.text != ""  && (self.newMobileNumberTF.text?.count)! >= 7{
            var mobile = ""
            if self.countryCodeLbl.text != nil {
                mobile = String.init(format: "%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!)
            }
            else {
                mobile = String.init(format: "%@", ("".replacingOccurrences(of: "+", with: "")))
            }
             let newMobileString = mobile + self.newMobileNumberTF.text!
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            self.startAnimating(allowInteraction: false)
                        
            OTTSdk.userManager.userGetOtp(targetType: .mobile, context: .verifyMobile, onSuccess: { (response) in
                print(response)
                
                self.stopAnimating()
                let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                var containsOTPVC = false
                for aviewcontroller : UIViewController in fromViewController
                {
                    if aviewcontroller is OTPViewController {
                        containsOTPVC = true
                        (aviewcontroller as! OTPViewController).identifier = newMobileString
                        (aviewcontroller as! OTPViewController).otpSent = true
                        (aviewcontroller as! OTPViewController).referenceID = response.referenceId
                        (aviewcontroller as! OTPViewController).isFromBackButton = false
                        _ =  self.navigationController?.popToViewController(aviewcontroller, animated: true)
                        break
                    }
                    
                }
                if containsOTPVC == false {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    
                    otpVC.identifier = newMobileString
                    otpVC.otpSent = true
                    otpVC.referenceID = response.referenceId
                    otpVC.isFromBackButton = false
                    otpVC.viewControllerName = self.viewControllerName == "ProfileVC" ? "ProfileVC" : "VerifyMobileVC"
                    otpVC.accountDelegate = self.accountDelegate
                    otpVC.targetVC = self.targetVC
                    otpVC.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    
                }

            }, onFailure: { (error) in
                self.showAlertWithText(message: error.message)
                Log(message: error.message)
            })
            /*
            YuppTVSDK.userManager.update(newMobile: newMobileString, onSuccess: { (response) in
                self.stopAnimating()
                let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                var containsOTPVC = false
                for aviewcontroller : UIViewController in fromViewController
                {
                    if aviewcontroller is OTPVC {
                        containsOTPVC = true
                        (aviewcontroller as! OTPVC).mobileNumber = newMobileString
                        (aviewcontroller as! OTPVC).otpSent = true
                        (aviewcontroller as! OTPVC).isFromBackButton = false
                        _ =  self.navigationController?.popToViewController(aviewcontroller, animated: true)
                        break
                    }
                    
                }
                if containsOTPVC == false {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    
                    otpVC.mobileNumber = newMobileString
                    otpVC.otpSent = true
                    otpVC.isFromBackButton = false
                    otpVC.viewControllerName = "VerifyMobileVC"
                    otpVC.accountDelegate = self.accountDelegate
                    otpVC.targetVC = self.targetVC
                    otpVC.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    
                }
                
            }) { (error) in
                self.stopAnimating()
                 self.showAlertWithText(AppDelegate.getDelegate().genericAlertStr.getAppName(), message: error.message)
            }
 */
            
        }else{
            self.showAlertWithText(String.getAppName(), message:"Please enter a valid Mobile Number".localized)
        }
    }
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.newMobileNumberTF.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }

}
// MARK: - extension VerifyMobileVC
extension VerifyMobileViewController{
    /**/
    func countrySelected(countryObj:Country){
        contryFlagimgView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(countryObj.isdCode)")
    }
    
}
