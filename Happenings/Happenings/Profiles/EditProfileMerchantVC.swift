//
//  EditProfileMerchantVC.swift
//  Happenings
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import GooglePlaces

class EditProfileMerchantVC: BaseViewController {

    static var storyboardInstance:EditProfileMerchantVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: EditProfileMerchantVC.identifier) as? EditProfileMerchantVC
    }
    
    @IBOutlet weak var viewBankAddress: UIView!{
        didSet{
            viewBankAddress.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    @IBOutlet weak var viewIfscCode: UIView!{
        didSet{
            viewIfscCode.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtBankAddress: UITextView!{
        didSet{
            txtBankAddress.placeholder = "Description"
        }
    }
    @IBOutlet weak var txtIfscCode: UITextField!
    
    @IBOutlet weak var viewBankName: UIView!{
        didSet{
            viewBankName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var txtBankName: UITextField!
    
     let categoryPickerView = UIPickerView()
    @IBOutlet weak var txtDealCategories: UITextField!{
        didSet{
            categoryPickerView.delegate = self
            txtDealCategories.inputView = categoryPickerView
            txtDealCategories.delegate = self
            txtDealCategories.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
            
        }
    }
    
    @IBOutlet weak var viewAccHolderName: UIView!{
        didSet{
            viewAccHolderName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var txtAccHoldername: UITextField!
    @IBOutlet weak var viewDealCategories: UIView!
        {
        didSet{
            viewDealCategories.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var viewContactNumber: UIView!{
        didSet{
            viewContactNumber.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var viewProductSold: UIView!{
        didSet{
            viewProductSold.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    
    @IBOutlet weak var viewBankAccNumber: UIView!{
        didSet{
            viewBankAccNumber.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var txtBankAccNumber: UITextField!{
        didSet{
            txtBankAccNumber.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var collectionViewConst: NSLayoutConstraint!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet{
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
            categoriesCollectionView.register(MerchantCategoryCell.nib, forCellWithReuseIdentifier: MerchantCategoryCell.identifier)
        }
    }
    
    @IBOutlet weak var txtCountProductSold: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var viewcountryCode: UIView!{
        didSet{
            viewcountryCode.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var viewWebsiteURL: UIView!{
        didSet{
            viewWebsiteURL.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtWebsiteURL: UITextField!
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Description"
        }
    }
  
    @IBOutlet weak var viewLocation: UIView!{
        didSet{
            viewLocation.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var viewCompanyName: UIView!{
        didSet{
            viewCompanyName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewLastName: UIView!{
        didSet{
            viewLastName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var viewFirstName: UIView!{
        didSet{
            viewFirstName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    
    @IBOutlet weak var viewDesc: UIView!{
        didSet{
            viewDesc.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
        }
    }
    
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var categoryList = [AnyObject]()
    var selectedCategoryList = [AnyObject]()
    var idList = [Int]()
    var strCatId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
         let user = UserData.shared.getUser()
        txtFirstName.text = user?.firstName
        txtLastName.text = user?.lastName
        txtLocation.text = user?.address
        txtContactNumber.text = user?.contact_no
        imgProfile.downLoadImage(url: user?.userProfileImage ?? "")
        txtDesc.text = user?.desc
        txtCompanyName.text = user?.store_name
        txtWebsiteURL.text = user?.website
        txtContactNumber.text = user?.contact_no
        txtCountProductSold.text = user?.no_of_product_sold
        txtAccHoldername.text = user?.bank_acc_holder_name
        txtBankAccNumber.text = user?.bank_acc_number
        txtBankName.text = user?.bank_name
        txtIfscCode.text = user?.bank_ifsc_code
        txtBankAddress.text = user?.bank_address
        latitude = (user?.addresslatitude as! NSString).doubleValue
        longitude = (user?.addresslongitude as! NSString).doubleValue
        if selectedCategoryList.count != 0{
            
            categoriesCollectionView.reloadData()
            setAutoHeight()
        }
        //txtBankName.text = user.
        
        
        callGetCategory()
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickUpdate(_ sender: UIButton) {
        if isValidated(){
            callEditProfileAPI()
        }
    }
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
    }
    @IBAction func onClickPhoto(_ sender: Any) {
         pickImage()
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter first name"
        }
        else if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter last name"
        }
        else if (txtCompanyName.text?.isEmpty)! {
            ErrorMsg = "Please enter cpmpany name"
        }
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "please select address"
        }else if (txtDesc.text?.isEmpty)!{
            ErrorMsg = "please enter description"
        }else if (txtWebsiteURL.text?.isEmpty)! {
            ErrorMsg = "please enter website url"
        }else if (txtContactNumber.text?.isEmpty)! {
            ErrorMsg = "please enter contact number"
        }else if (txtCountProductSold.text?.isEmpty)! {
            ErrorMsg = "please enter number of prodcut sold"
        }else if (txtAccHoldername.text?.isEmpty)! {
            ErrorMsg = "please enter account holder name"
        }else if (txtBankAccNumber.text?.isEmpty)! {
            ErrorMsg = "please enter bank account number"
        }else if (txtBankName.text?.isEmpty)! {
            ErrorMsg = "please enter bank name"
        }else if (txtIfscCode.text?.isEmpty)! {
            ErrorMsg = "please enter ifsc code"
        }else if (txtBankAddress.text?.isEmpty)! {
            ErrorMsg = "please select bank address"
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
   
   
    func callGetCategory() {
        let param = ["action":"categorylist"]
        Modal.shared.getCategory(vc: self, param: param) { (dic) in
            print(dic)
            
            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //            let dict = NSDictionary()
            //            dict = self.arrCategoryList[0] as! NSDictionary
            //            self.strCatId = dict.value(forKey: "id")
            if self.categoryList.count != 0 {
                self.categoryPickerView.reloadAllComponents()
            }
        }
    }
    
    func callEditProfileAPI(){
        for i in 0..<selectedCategoryList.count{
            let dict:NSDictionary = selectedCategoryList[i] as! NSDictionary
            idList.append(Int((dict.value(forKey: "id") as! NSString).intValue))
        }
        
        var strId:String = ""
        if idList.count > 1 {
        for i in 0..<idList.count{
            if strId == ""{
                strId = String(idList[0])
            }else{
            strId = String(format: "%@,%d", strId,idList[i])
            }
        }
        }else{
            strId = String(idList[0])
        }
       
        
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "first_name":txtFirstName.text!,
                     "last_name":txtLastName.text!,
                     "contact_no":txtContactNumber.text!,
                     "address":txtLocation.text!,
                     "addresslatitude":latitude!,
                     "addresslongitude":longitude!,
                     "company_name":txtCompanyName.text!,
                     "business_description":txtDesc.text!,
                     "website":txtWebsiteURL.text!,
                     "number_of_products":txtCountProductSold.text!,
                     "account_holder_name":txtAccHoldername.text!,
                     "account_bank_name":txtBankName.text!,
                     "account_number":txtBankAccNumber.text!,
                     "account_bank_ifsc":txtIfscCode.text!,
                     "account_bank_address":txtBankAddress.text!,
                     "category_id":strId,
                     "action":"merchant-update-profile"] as [String : Any]
        
        if selectedUserImage == nil{
            Modal.shared.editProfileNoImgMerchant(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }
        }else{
            Modal.shared.ediProfileMerchant(vc: self, postImage: selectedUserImage, param: param, imageName: pickedImageName) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }
        }
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ?
            JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        //    JSONSerialization.WritingOptionsJSONSerialization.WritingOptions.PrettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func openSettingForGivePermissionCamera() {
        self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                self.open(scheme:UIApplication.openSettingsURLString)
            }
            else{//Cancel
            }
        })
    }
    
    func checkCamera() {
        //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera
        //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera/27646311
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            openCamera() // Do your stuff here i.e. callCameraMethod()0
        case .denied, .restricted:
            openSettingForGivePermissionCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.openCamera()
                } else {
                    //access denied
                    self.openSettingForGivePermissionCamera()
                }
            })
        }
    }
    
    func checkCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            openCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.openCamera()
                } else {
                    //access denied
                    self.alert(title: "", message:"Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
                        if flag == 1{ //Setting
                            self.open(scheme:UIApplication.openSettingsURLString)
                        }
                        else{//Cancel
                        }
                    })
                    
                }
            })
        }
    }
    
    func openCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker = UIImagePickerController()
            self.picker.delegate = self
            self.picker.sourceType = .camera
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true, completion: nil)
        }
        else{
            self.alert(title: "Alert", message: "Camera is not available in this device")
        }
    }
    
    func pickImage() {
        let captureAction = UIAlertAction(title: "Capture", style: .default, handler: { (action) -> Void in
            print("Capture Button Pressed")
            self.checkCamera() //checkCameraPermission()
        })
        let selectImageFromGalleryAction = UIAlertAction(title: "From Gallery", style: .default, handler: { (action) -> Void in
            print("Select Image From Gallery Button Pressed")
            self.picker = UIImagePickerController()
            self.picker.openGallery(vc: self)
        })
        showActionSheetWithTitle(title: "Select Image", actions: [captureAction, selectImageFromGalleryAction])
    }
    
    func showActionSheetWithTitle(title:String, actions:[UIAlertAction]) {
        let actionSheet = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        for action in actions {
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        
        //For iPad display actionsheet
        actionSheet.popoverPresentationController?.sourceRect = imgProfile.frame
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        self.present(actionSheet, animated: true, completion: nil)
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
extension EditProfileMerchantVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        //2
        if let _ = selectedImage {
            pickedImageName = picker.getPickedFileName(info: info)
            //self.selectedUserImage = selectedImages
        }
        else{
            print("Something went wrong")
        }
        //3
        //dismiss(animated: true, completion: nil)
        dismiss(animated: false) {
            if let selectedImages = selectedImage {
                let imageCropper = ImageCropper.storyboardInstance
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
        }
    }
}
extension EditProfileMerchantVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.selectedUserImage = cropImage
        imgProfile.image = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
extension EditProfileMerchantVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place coordinate latitude: \(place.coordinate.latitude)")
        print("Place coordinate longitude: \(place.coordinate.longitude)")
        //latitude = String(place.coordinate.latitude)
        //longitude = String(place.coordinate.longitude)
        
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        txtLocation.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileMerchantVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtLocation == textField {
            txtLocation.text = nil
            //https://developers.google.com/places/ios-api/
            //TODO: Display google place picker
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtLocation == textField {
            return false
        }
        else{
            return true
        }
    }
    
}

extension EditProfileMerchantVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if categoryList.count > 0{
                var dict = NSDictionary()
                dict = categoryList[row] as! NSDictionary
                let str = dict.value(forKey: "name")
                txtDealCategories.text = str as? String
                strCatId = (dict.value(forKey: "id") as? String)!
                selectedCategoryList.append(dict)
                categoriesCollectionView.reloadData()
                setAutoHeight()
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
     
            var dict = NSDictionary()
            dict = categoryList[row] as! NSDictionary
            let str = dict.value(forKey: "categoryName")
            label.text = str as? String
       
        return label
    }
}
extension EditProfileMerchantVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MerchantCategoryCell.identifier, for: indexPath) as? MerchantCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        let dict:NSDictionary = selectedCategoryList[indexPath.row] as! NSDictionary
        cell.lblName.text = dict.value(forKey: "categoryName") as! String
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = true
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        selectedCategoryList.remove(at: sender.tag)
        categoriesCollectionView.reloadData()
        setAutoHeight()
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collectionViewConst.constant = self.categoriesCollectionView.contentSize.height
            self.categoriesCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dict:NSDictionary = selectedCategoryList[indexPath.row] as! NSDictionary
        let text = dict.value(forKey: "categoryName")
        let titleFont = TitilliumWebFont.regular(with: 17.0)
        let width = UILabel.textWidth(font: titleFont, text: text! as! String)
        return CGSize(width: width + 10 + 10+45, height: 50)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    
    //        return imageSize
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //    }
    
    //    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
    //        reloadMoreData(indexPath: indexPath)
    //
    //    }
    //
    //
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if merchantList.count - 1 == indexPath.row &&
    //            (merchantObj!.currentPage > merchantObj!.TotalPages) {
    //            self.callGetFollowingMerchant()
    //        }
    //    }
}
