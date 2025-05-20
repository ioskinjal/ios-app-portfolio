//
//  SignUpVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices.UTType
import Photos

class SignUpVC: BaseVC,CodeDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var btnUploadSelfie: UIButton!
    @IBOutlet weak var lblImgName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var documentTableView: UITableView!{
        didSet{
            documentTableView.delegate = self
            documentTableView.dataSource = self
        }
    }
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var lblNavTitle:UILabel!
    
    @IBOutlet weak var documentTableViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnUploadDocument: UIButton!{
        didSet{
            btnUploadDocument.addTarget(self, action: #selector(didTapBtnUploadDocument), for: .touchUpInside)
        }
    }
    
    
    var selectedCode = CountryCode()
    var documentItems = [Document]()
    var selectedImage:UIImage?
    var selectedImageName:String?
    let imagePicker = UIImagePickerController()
    let selfieImagePickerView = UIImagePickerController()
    var countryCodes = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCode.country_code = "+91"
        layoutSetup()
        getCountryCodes()
        documentTableViewheightConstraint.constant = 0
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtFirstName.placeholder = appConts.const.lBL_FIRST_NAME
        txtPassword.placeholder = appConts.const.lBL_PASSWORD
        txtEmail.placeholder = appConts.const.lBL_EMAIL
        txtLastName.placeholder = appConts.const.lBL_LAST_NAME
        txtMobileNumber.placeholder = appConts.const.lBL_MOBILE_NO
        btnUploadDocument.setTitle(appConts.const.bTN_UPLOAD_DOCUMENT, for: .normal)
        
        btnUploadSelfie.setTitle(appConts.const.UPLOAD_SELFIE, for: .normal)
        btnSignUp.setTitle(appConts.const.lBL_SUBMIT, for: .normal)
        lblNavTitle.text = appConts.const.cREATE_AN_ACCOUNT
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func layoutSetup(){
        fNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        lNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        emailView.applyBorder(color: UIColor.lightGray, width: 1.0)
        mobileNumberView.applyBorder(color: UIColor.lightGray, width: 1.0)
        passwordView.applyBorder(color: UIColor.lightGray, width: 1.0)
    }
    
    
    
    func openDocumentPickerView() {
        _ = self.resignFirstResponder()
        let allowFileSelection = [String(kUTTypePDF),String(kUTTypeText),String(kUTTypePlainText)]
    
        let documentPicker = UIDocumentPickerViewController(documentTypes: allowFileSelection, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func getCountryCodes(){
        
        if NetworkManager.isNetworkConneted() {
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
                        
                        if newCode.country_code == "+91"
                        {
                            self.selectedCode = newCode
                            break
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.stopIndicator()
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }
        else{
            displayNetworkAlert()
            
        }
        
    }
    
    // MARK: - Register User
    func register(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let params: Parameters = [
                "firstName": String(describe(txtFirstName.text)),
                "lastName": String(describe(txtLastName.text)),
                "email": String(describe(txtEmail.text)),
                "mobileNo": String(describe(txtMobileNumber.text)),
                "countryCode": selectedCode.typeId,
                "password": String(describe(txtPassword.text)),
                "lId":String(Language.getLanguage().id)
            ]
            
           
            let alert = Alert()
            
            
            WSManager.getResponseFromMultiPart(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.register, parameters: params, fileName: documentItems.map({$0.name}), fileData: documentItems.map({$0.data}),image: selectedImage!, successBlock: { (json, urlResponse) in
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        alert.showAlertWithCompletionHandler(titleStr: appConts.const.lBL_SUCCESS, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        //alert.showAlertAndPopVC(titleStr: "Success", messageStr: message, buttonTitleStr: "OK")
                    }
                }
                else{
                    DispatchQueue.main.async {
                        
                        alert.showAlert(titleStr: appConts.const.bTN_OK, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                    // self.navigationController?.present(oopsVC, animated: true, completion: nil)
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }
        else{
            displayNetworkAlert()
        }
    }
            
            
//            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.register, parameters: params, successBlock: { (json, urlResponse) in
//                
//                self.stopIndicator()
//                
//                print("Request: \(String(describing: urlResponse?.request))")   // original url request
//                print("Response: \(String(describing: urlResponse?.response))") // http url response
//                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
//                
//                let jsonDict = json as NSDictionary?
//                
//                let status = jsonDict?.object(forKey: "status") as! Bool
//                let message = jsonDict?.object(forKey: "message") as! String
//                
//                if status == true{
//                    
//                    DispatchQueue.main.async {
//                        
//                        alert.showAlertWithCompletionHandler(titleStr: appConts.const.lBL_SUCCESS, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                        //alert.showAlertAndPopVC(titleStr: "Success", messageStr: message, buttonTitleStr: "OK")
//                    }
//                }
//                else{
//                    DispatchQueue.main.async {
//                        
//                        alert.showAlert(titleStr: appConts.const.bTN_OK, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
//                    }
//                }
//            }) { (error) in
//                DispatchQueue.main.async {
//                    self.stopIndicator()
//                    
//                    // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
//                    // self.navigationController?.present(oopsVC, animated: true, completion: nil)
//                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
//                }
//            }
//        }
//        else{
//            displayNetworkAlert()
//        }
//    }
    
    // MARK: - Code Delegate method
    func didSelectCode(code: CountryCode) {
        
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? SignUpVC {
            
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
    
    
    
    // MARK: - Button Events
    @IBAction func onClickUploadSelfie(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "", message: appConts.const.TITLE_SELFEI, preferredStyle: .actionSheet)
        let openCamera = UIAlertAction(title: appConts.const.MSG_TAKE_PHOTO, style: .default) { (actions) in
            self.selfieImagePickerView.sourceType = .camera
            self.selfieImagePickerView.delegate = self
            self.selfieImagePickerView.allowsEditing = true
            self.present(self.selfieImagePickerView, animated: true, completion: nil)
        }
        let openGallery = UIAlertAction(title: appConts.const.MSG_CHOOSE_PHOTO, style: .default) { (actions) in
            self.selfieImagePickerView.sourceType = .photoLibrary
            self.selfieImagePickerView.delegate = self
            self.selfieImagePickerView.allowsEditing = true
            self.present(self.selfieImagePickerView, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: appConts.const.cANCEL, style: .cancel) { (actions) in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(openCamera)
        actionSheet.addAction(openGallery)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       
        
        
        
//        if let fileName = (asset.value(forKey: "filename")) as? String {
//            print("\(fileName)")
//            return fileName
//        }
        
//
//        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
//                print(imageURL)
//            }
//            self.selectedImage = pickedImage
//            self.selectedImageName = picker.getPickedFileName(info: info)
//            self.lblImgName.text = selectedImageName
//              //  self.userProfileImageHeightConstraint.constant = 80
//               // self.userProfileImage.image = pickedImage
//              //  self.view.layoutIfNeeded()
//               // self.isSelfie = true
//        }
        
        //1
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }

        //2
//        if let _ = selectedImage {
//            self.selectedImageName = picker.getPickedFileName(info: info)
//        }
        
        if let pickedURL = info[UIImagePickerControllerReferenceURL] as? URL {
            print(pickedURL.lastPathComponent)
            self.selectedImageName = pickedURL.lastPathComponent
        }
        
        self.selectedImage = selectedImage
        self.lblImgName.text = selectedImageName

        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickTerms(_ sender: UIButton) {
        let termsVC = Terms_ConditionsVC.storyboardInstance!
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    @IBAction func onClickTermsCheck(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "checkbox_deselected"){
            sender.setImage(#imageLiteral(resourceName: "checkbox_selected"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "checkbox_deselected"), for: .normal)
        }
    }
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        
        if self.countryCodes.count > 0 {
            self.view.endEditing(true)
            
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
        else{
            getCountryCodes()
        }
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        let validate = Validator()
        let alert = Alert()
        
        if (txtFirstName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_FIRST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtLastName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_LAST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL ,buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtMobileNumber.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.pLEASE_ENTER_MOBILE_NO, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (txtPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_PASSWORD, buttonTitleStr: appConts.const.bTN_OK)
        }else if (btnCheck.currentImage == #imageLiteral(resourceName: "checkbox_deselected")){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.ACCEPT_TERMS, buttonTitleStr: appConts.const.bTN_OK)
        }else if documentItems.count == 0 {
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.UPLOAD_DOC, buttonTitleStr: appConts.const.bTN_OK)
        }else if selectedImage == nil {
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.UPLOAD_SELFIE_MSG, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            self.view.endEditing(true)
            register()
        }
    }
    
    @objc func didTapBtnUploadDocument(){
        openDocumentPickerView()
    }
    
    // End
}

extension SignUpVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumetsTableViewCell", for: indexPath) as? DocumetsTableViewCell else {
            fatalError()
        }
        cell.data = documentItems[indexPath.row]
        cell.delegate = self
        return cell
    }


}


extension SignUpVC:UIDocumentPickerDelegate{
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("URL", url)
        
        let fileUrl = url as URL
        
        do {
            let data = try Data(contentsOf: fileUrl)
            print("data=\(data)")
            
            //create Document object and append in document array
            
            
            if documentItems.count <= 9{
                if !documentItems.contains(where: {$0.name == fileUrl.lastPathComponent }){
                    self.documentItems.append(Document(name: fileUrl.lastPathComponent, data: data))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.documentTableViewheightConstraint.constant = self.documentTableView.contentSize.height
                    }
                    self.documentTableView.reloadData()
                }
                
            }else{
                print("reached limit")
            }
           
           
            
        }
        catch {
//            Util.showMessageResult(vc: self, success: false, message: Util.localizedString(key: "File data is not found")) //Show alert
        }
        
        self.dismiss(animated: true) {
            
        }
    }
}


extension SignUpVC:DocumetsTableViewCellDelegate{
   
    func remove(item name: String) {
        self.documentItems.remove(at: self.documentItems.index(where: {$0.name == name})!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.documentTableViewheightConstraint.constant = self.documentTableView.contentSize.height
        }
        self.documentTableView.reloadData()
    }
    
    
}
