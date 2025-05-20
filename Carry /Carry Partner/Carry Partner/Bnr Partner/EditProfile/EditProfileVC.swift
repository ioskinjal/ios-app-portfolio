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
    
    
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNoView: UIView!
    @IBOutlet weak var lblEditProfile:UILabel!
    @IBOutlet weak var btnUpdateProfile:UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var countryCodes = NSArray()
    
    var selectedCode = CountryCode()
    
    var isFromRegister = false
    var social = false
    
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        displayUser()
        getCountryCodes()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblEditProfile.text = appConts.const.tITLE_EDIT_PROFILE
        btnUpdateProfile.setTitle(appConts.const.bTN_UPDATE_PROFILE, for: .normal)
        txtEmail.placeholder = appConts.const.lBL_EMAIL
        txtLastName.placeholder = appConts.const.lBL_LAST_NAME
        txtFirstName.placeholder = appConts.const.lBL_FIRST_NAME
        txtMobileNumber.placeholder = appConts.const.lBL_MOBILE_NO
        
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
    }
    
    func displayUser(){
        selectedCode.country_code = (self.sharedAppDelegate().currentUser?.countryCode)!
        txtFirstName.text = sharedAppDelegate().currentUser?.firstName
        txtLastName.text = sharedAppDelegate().currentUser?.lastName
        txtMobileNumber.text = sharedAppDelegate().currentUser?.mobileNo
        txtEmail.text = sharedAppDelegate().currentUser?.email
        lblCountryCode.text = "+"+(sharedAppDelegate().currentUser?.countryCode)!
        //        if sharedAppDelegate().currentUser?.defaultPaymentMethod == "c" {
        //            self.btnCashClicked((Any).self)
        //
        //        }
        //        else{
        //            self.btnWalletClicked((Any).self)
        //        }
        let profileImage = String(format:"%@/%@/%@",URLConstants.Domains.profileUrl,(sharedAppDelegate().currentUser?.uId)!,(sharedAppDelegate().currentUser?.profileImage)!)
        
        self.profileImgView.af_setImage(withURL: URL(string: profileImage)!)
        self.profileImgView.applyCorner(radius: self.profileImgView.frame.size.width/2)
        self.profileImgView.clipsToBounds = true
        
    }
    
    @IBAction func btnUpdateProfileClicked(_ sender: Any) {
        
        if NetworkManager.isNetworkConneted(){
            
            startIndicator(title: "")
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let params: Parameters = [
                "userId":delegate.currentUser!.uId,
                "firstName":txtFirstName.text!,
                "lastName":txtLastName.text!,
                "countryCode":selectedCode.typeId,
                "mobileNo":txtMobileNumber.text!,
                "lId":String(Language.getLanguage().id)
//                "registrationType":social ? "social" : "",
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFromMultiPart(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.editUpdateProfile, parameters: params, image: profileImgView.image!, successBlock: { (json, urlResponse) in
                
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
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    })
                }
                
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func getCountryCodes(){
        
        if NetworkManager.isNetworkConneted(){
            
            startIndicator(title: "")
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
                        
                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEmail || textField == txtMobileNumber{
            // self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //profileImgView.contentMode = .scaleAspectFit
            profileImgView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
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
    @IBAction func btnEditProfilePicClicked(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if isFromRegister{
            self.sharedAppDelegate().rootToHome()
        }
        else{
            goBack()
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
