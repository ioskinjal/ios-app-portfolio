//
//  EditProfileVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileVC: BaseVC,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var walletImgView: UIImageView!
    @IBOutlet weak var cashImgView: UIImageView!
    
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNoView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userProfileImage:UIImageView!
    @IBOutlet weak var userProfileImageHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var lblNavTitleConst: UILabel!
    @IBOutlet weak var lblPaymentMethodConst: UILabel!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    
    var isFromRegister = false
    var social:Bool = false
    
    var isCashSelected:Bool = false
    var isSelfie:Bool = false
    var isProfile:Bool = false
    var countryCodes = NSArray()
    
    var selectedCode = CountryCode()
    
    
    let imagePicker = UIImagePickerController()
    let selfieImagePickerView = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        displayUser()
        getCountryCodes()
        userProfileImageHeightConstraint.constant = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutSetup(){
        fNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        lNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        emailView.applyBorder(color: UIColor.lightGray, width: 1.0)
        mobileNoView.applyBorder(color: UIColor.lightGray, width: 1.0)
        
         lblNavTitleConst.text = appConts.const.tITLE_EDIT_PROFILE
         lblPaymentMethodConst.text = appConts.const.pAYMENT_METHOD
        
         updateBtn.setTitle(appConts.const.bTN_UPDATE_PROFILE, for: UIControlState.normal)
         lblWallet.text = appConts.const.wALLET
         lblCash.text = appConts.const.cASH
        
    }
    
    func displayUser(){
        selectedCode.country_code = (self.sharedAppDelegate().currentUser?.countryCode)!
        txtFirstName.text = sharedAppDelegate().currentUser?.firstName
        txtLastName.text = sharedAppDelegate().currentUser?.lastName
        txtMobileNumber.text = sharedAppDelegate().currentUser?.mobileNo
        txtEmail.text = sharedAppDelegate().currentUser?.email
        lblCountryCode.text = "+"+(sharedAppDelegate().currentUser?.countryCode)!
        if sharedAppDelegate().currentUser?.defaultPaymentMethod == "c" {
            isCashSelected = true
            walletImgView.image = #imageLiteral(resourceName: "Wallet")
            cashImgView.image = #imageLiteral(resourceName: "Coins")
            lblWallet.textColor = UIColor.darkGray
            lblCash.textColor =   UIColor.init(hexString: "F8C749")
            
        }
        else{
            self.btnWalletClicked((Any).self)
        }
        let profileImage = String(format:"%@/%@/%@",URLConstants.Domains.profileUrl,(sharedAppDelegate().currentUser?.uId)!,(sharedAppDelegate().currentUser?.profileImage)!)
        
        self.profileImgView.af_setImage(withURL: URL(string: profileImage)!)
        self.profileImgView.applyCorner(radius: self.profileImgView.frame.size.width/2)
        self.profileImgView.clipsToBounds = true
        
    }
    
    @IBAction func btnWalletClicked(_ sender: Any) {
        isCashSelected = false
        walletImgView.image = #imageLiteral(resourceName: "Wallet")
        cashImgView.image = #imageLiteral(resourceName: "Coins")
        
        lblWallet.textColor = UIColor.black
        lblCash.textColor = UIColor.darkGray
    }
    
   @IBAction func btnCashClicked(_ sender: Any) {
//        if sharedAppDelegate().currentUser?.defaultPaymentMethod.lowercased() == "w" {
//            let actionSheet = UIAlertController(title: "", message: appConts.const.TITLE_SELFEI, preferredStyle: .actionSheet)
//            let openCamera = UIAlertAction(title: appConts.const.MSG_TAKE_PHOTO, style: .default) { (actions) in
//                self.selfieImagePickerView.sourceType = .camera
//                self.selfieImagePickerView.delegate = self
//                self.selfieImagePickerView.allowsEditing = true
//                self.present(self.selfieImagePickerView, animated: true, completion: nil)
//            }
//            let openGallery = UIAlertAction(title: appConts.const.MSG_CHOOSE_PHOTO, style: .default) { (actions) in
//                self.selfieImagePickerView.sourceType = .photoLibrary
//                self.selfieImagePickerView.delegate = self
//                self.selfieImagePickerView.allowsEditing = true
//                self.present(self.selfieImagePickerView, animated: true, completion: nil)
//            }
//            let cancel = UIAlertAction(title: appConts.const.cANCEL, style: .cancel) { (actions) in
//                self.dismiss(animated: true, completion: nil)
//                self.isCashSelected = false
//            }
//
//            actionSheet.addAction(openCamera)
//            actionSheet.addAction(openGallery)
//            actionSheet.addAction(cancel)
//
//            present(actionSheet, animated: true, completion: nil)
//
//        }else{
            isCashSelected = true
            walletImgView.image = #imageLiteral(resourceName: "Wallet")
            cashImgView.image = #imageLiteral(resourceName: "Coins")
            lblWallet.textColor = UIColor.darkGray
            lblCash.textColor =   UIColor.black
            
            
//            let alert = Alert()
//            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_SELFIE, buttonTitleStr: appConts.const.bTN_OK)
       // }
    }

    
    @IBAction func btnUpdateProfileClicked(_ sender: Any) {
        if txtFirstName.text == ""{
            self.alert(title: "", message: "please enter firstname")
        }else if txtLastName.text == ""{
            self.alert(title: "", message: "please enter lastname")
        }else if txtEmail.text == ""{
            self.alert(title: "", message: "please enter email")
        }else if txtMobileNumber.text == ""{
            self.alert(title: "", message: "please enter mobile number")
        }else{
        if NetworkManager.isNetworkConneted(){
            
            self.startIndicator(title: "")
            var paymentMethod = ""
            if isCashSelected {
                paymentMethod = "c"
            }
            else{
                paymentMethod = "w"
                
            }
            
            let params: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "firstName":txtFirstName.text!,
                "lastName":txtLastName.text!,
                "countryCode":selectedCode.typeId,
                "mobileNo":txtMobileNumber.text!,
                "paymentMethod":paymentMethod,
                "registrationType":social ? "social" : "",
                "lId":String(Language.getLanguage().id)
                ]
            
            var imagesArray:[String:Any] = [:]
            let alert = Alert()
            
            if self.isProfile{
                imagesArray.updateValue(self.profileImgView.image!, forKey: "userProfileImage")
            }
          
            if self.isSelfie{
                imagesArray.updateValue(self.userProfileImage.image!, forKey: "userSelfie")
            }
            
            WSManager.getResponseFromMultiPart(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.editUpdateProfile, parameters: params, images: imagesArray, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                // let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                DispatchQueue.main.async {
                    
                    alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                        if self.isFromRegister {
                            self.sharedAppDelegate().rootToHome()
                        }
                        else{
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        }
    }
    
    func getCountryCodes(){
        
        if NetworkManager.isNetworkConneted(){
            
            self.startIndicator(title: "")
            let params: Parameters = ["lId":Language.getLanguage().id]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.countryCode, parameters: params, successBlock: { (json, urlResponse) in
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let codes = CountryCode.initWithResponse(array: (dataAns as! [Any]))
                    self.countryCodes = codes as NSArray
                    for code in self.countryCodes {
                        
                        let newCode = code as! CountryCode
                        
                        if newCode.typeId ==   self.selectedCode.country_code
                        {
                            self.selectedCode = newCode
                            DispatchQueue.main.async {
                                self.lblCountryCode.text = self.selectedCode.country_code
                            }
                            break
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if textField == txtEmail || textField == txtMobileNumber{
    //            self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    //
    //        }
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    //
    //    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            switch picker {
            case imagePicker:
                profileImgView.image = pickedImage
                self.isProfile = true
                self.isCashSelected = true
                self.walletImgView.image = #imageLiteral(resourceName: "wallet_deselect_icon")
                self.cashImgView.image = #imageLiteral(resourceName: "cash_selected_icon")
                self.lblWallet.textColor = UIColor.darkGray
                self.lblCash.textColor =   UIColor.init(hexString: "F8C749")
                break
            case selfieImagePickerView:
                self.userProfileImageHeightConstraint.constant = 80
                self.userProfileImage.image = pickedImage
                self.view.layoutIfNeeded()
                self.isSelfie = true
                self.isCashSelected = true
                self.walletImgView.image = #imageLiteral(resourceName: "wallet_deselect_icon")
                self.cashImgView.image = #imageLiteral(resourceName: "cash_selected_icon")
                self.lblWallet.textColor = UIColor.darkGray
                self.lblCash.textColor =   UIColor.init(hexString: "F8C749")
                break
            default:
                break
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        
        if self.countryCodes.count > 0 {
            let codeController = CountryCodeVC(nibName: "CountryCodeVC", bundle: nil)
            codeController.delegate = self
            codeController.codes = self.countryCodes
            self.addChildViewController(codeController)
            view.addSubview(codeController.view)
            
            codeController.view.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            let trailingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            let topConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
            self.view.layoutIfNeeded()
            
            codeController.didMove(toParentViewController: self)
        }
    }
    @IBAction func btnEditProfilePicClicked(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        if isFromRegister{
            self.sharedAppDelegate().rootToLogin()
        }
        else{
            goBack()
        }
    }
}

extension EditProfileVC:CodeDelegate{
    
    // MARK: - Code Delegate method
    func didSelectCode(code: CountryCode) {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? EditProfileVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        selectedCode = code
        lblCountryCode.text = code.country_code
    }
    
}

extension EditProfileVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Mobile Number textfield max length is fixed to 15
        if textField == self.txtMobileNumber {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered:String = compSepByCharInSet.joined(separator: "")
            let totalText:String = describe(self.txtMobileNumber.text)
            
            if (string == numberFiltered) && (totalText.count <= 14) {
                return true
            }
            else if string == "" {
                return true
            }
            else{
                return false
            }
        }
        return true
    }
}
