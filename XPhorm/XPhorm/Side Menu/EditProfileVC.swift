//
//  EditProfileVC.swift
//  XPhorm
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GooglePlaces
import AVFoundation

class EditProfileVC: BaseViewController {
    @IBOutlet weak var viewImage: UIView!{
        didSet{
           viewImage.setRadius()
        }
    }
    @IBOutlet weak var lblMale: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewCertificate: UICollectionView!{
        didSet{
            collectionViewCertificate.delegate = self
            collectionViewCertificate.dataSource = self
            collectionViewCertificate.register(SubCategoryCell.nib, forCellWithReuseIdentifier: SubCategoryCell.identifier)
        }
    }
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblFemale: UIButton!
    @IBOutlet weak var btnF: UIButton!
    @IBOutlet weak var bntM: UIButton!
    @IBOutlet weak var btnUploadCertificate: UIButton!{
        didSet{
           DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                
             self.btnUploadCertificate.border(side: .all, color: UIColor(red: 230/255.0, green: 223/255.0, blue: 234/255.0, alpha: 1.0), borderWidth: 1.0)
            self.btnUploadCertificate.setRadius(6.0)
            }
        }
    }
    @IBOutlet weak var txtEmergency: Textfield!
    @IBOutlet weak var txtContact: Textfield!
    
    let datePickerViewDob =  UIDatePicker()
    @IBOutlet weak var txtDob: Textfield!{
    didSet{
    
    datePickerViewDob.datePickerMode = .date
    datePickerViewDob.addTarget(self, action: #selector(dateDiveChanged1(_:)), for: UIControl.Event.valueChanged)
    txtDob.inputView = datePickerViewDob
    
    
    }
}
    @IBOutlet weak var txtAddress: Textfield!{
    didSet{
    txtAddress.delegate = self
    }
    }
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Desccription"
            self.txtDesc.border(side: .all, color: UIColor(red: 230/255.0, green: 223/255.0, blue: 234/255.0, alpha: 1.0), borderWidth: 1.0)
            self.txtDesc.setRadius(8.0)
        }
    }
    @IBOutlet weak var txtLastName: Textfield!
    @IBOutlet weak var txtFirstName: Textfield!
    
    @IBOutlet weak var btnSave: UIButton!
    static var storyboardInstance:EditProfileVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: EditProfileVC.identifier) as? EditProfileVC
    }
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
        }
    }
    var pickedImageAry = [UIImage](){
        didSet{
            //self.collectionView.reloadData()
            //self.setAutoHeight()
        }
    }
    var str:String = ""
    var pickedImageNameAry = [String]()
    var removedImageArray = [UIImage]()
    var removedImageNameArray = [String]()
    var selectedGender = ""
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var selectedImage:UIImage?
    var selctedImageName:String?
    var isFromProfile = false
    var certificates = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile".localized, action: #selector(onClickBack(_:)))
        getEditProfile()
        
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getEditProfile(){
        let param = ["action":"getProfileData",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.profile(vc: self, param: param) { (dic) in
            let data:Profile?
            data = Profile(dic: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.showProfileData(data: data!)
            
        }
    }
    
     func showProfileData(data:Profile){
        imgProfile.downLoadImage(url: data.profileImg)
       
        txtFirstName.text = data.firstName
        txtLastName.text = data.lastName
        txtAddress.text = data.address
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let date = dateformat.date(from: data.birthDate)
        dateformat.dateFormat = "MM/dd/yyyy"
        txtDob.text = dateformat.string(from: date ?? Date())
        datePickerViewDob.setDate(date ?? Date(), animated: true)
        txtContact.text = data.contactNumber
        txtDesc.placeholder = nil
        txtDesc.text = data.desc
        txtDesc.placeholder = "Description"
        txtEmergency.text = data.emergencyContactNumber
        if data.gender == "m"{
            onClickGender(bntM)
        }else{
            onClickGender(btnF)
        }
        
        for i in data.certificates{
            
           let dict = [ "image": i.certificatePath,
                     "isImage" : false,
                     "name": i.certificate] as [String : Any]
            certificates.append(dict)
        }
        
        
        collectionViewCertificate.reloadData()
        if certificates.count != 0{
        collectionViewHeight.constant = collectionViewCertificate.contentSize.height
        }else{
            collectionViewHeight.constant = 1
        }
    }
    
    @objc func dateDiveChanged1(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        datePickerViewDob.maximumDate = Date()
        txtDob.text = formatter.string(from: sender.date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        txtFirstName.placeholder = "First Name".localized
        txtLastName.placeholder = "Last Name".localized
        txtAddress.placeholder = "Address".localized
        txtDob.placeholder = "Date of Birth".localized
        txtContact.placeholder = "Contact Number".localized
        txtEmergency.placeholder = "Emergency Number".localized
        lblGender.text = "Gender".localized
        lblMale.setTitle("Male".localized, for: .normal)
        lblFemale.setTitle("Female".localized, for: .normal)
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        isFromProfile = true
        pickImage()
    }
    @IBAction func onClickSave(_ sender: UIButton) {
        if isValidated(){
            callEditProfile()
        }
    }
    @IBAction func onClickCertificate(_ sender: UIButton) {
        isFromProfile = false
        pickImage()
    }
    
    func callEditProfile(){
        var strRemove:String = ""
        for i in 0..<removedImageNameArray.count{
            if strRemove == ""{
                strRemove = removedImageNameArray[i]
            }else{
                strRemove = strRemove + "," + removedImageNameArray[i]
            }
        }
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy"
        let date = dateformat.date(from: txtDob.text ?? "") ?? Date()
        dateformat.dateFormat = "yyyy-MM-dd"
        
        let param = ["action":"saveUser",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "firstName":txtFirstName.text!,
                     "lastName":txtLastName.text!,
                     "gender":selectedGender,
                     "address":txtAddress.text!,
                     "birthDate":dateformat.string(from: date),
                     "contactNumber":txtContact.text!,
                     "emergencyContactNumber":txtEmergency.text!,
                     "removedCerti":strRemove,
                     "description":txtDesc.text!]
        if pickedImageAry.count != 0 && selectedImage !=  nil{
        Modal.shared.EditProfile(vc: self, param: param, withPostImageAry: pickedImageAry, withPostImageNameAry: pickedImageNameAry, postImage: selectedImage, imageName: selctedImageName, failer: { (error) in
            print(error)
        }) { (dic) in
             let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
            }
        }else if pickedImageAry.count != 0 && selectedImage ==  nil{
            Modal.shared.EditProfileOnlyCertificate(vc: self, param: param, withPostImageAry: pickedImageAry, withPostImageNameAry: pickedImageNameAry, postImage: selectedImage, imageName: selctedImageName, failer: { (error) in
                print(error)
            }) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
        }
        }else if selectedImage == nil{
            Modal.shared.EditProfileWithoutImage(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }else{
            Modal.shared.EditProfileWithoutImageArray(vc: self, param: param, postImage: selectedImage, imageName: selctedImageName) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter first name".localized
        }
        else if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter last name".localized
        }else if (txtAddress.text?.isEmpty)! {
            ErrorMsg = "Please select address".localized
        }else if (txtDob.text?.isEmpty)! {
            ErrorMsg = "Please select date of birth".localized
        }else if (txtContact.text?.isEmpty)! {
            ErrorMsg = "Please enter contact number".localized
        }else if txtContact.text?.count != 10{
            ErrorMsg = "please enter valid contact number".localized
        }else if (txtEmergency.text?.isEmpty)! {
            ErrorMsg = "Please enter emergency number".localized
        }else if txtEmergency.text?.count != 10{
            ErrorMsg = "please enter valid emergency number".localized
        }else if selectedGender == ""{
            ErrorMsg = "please select gender".localized
        }else if (txtDesc.text?.isEmpty)! {
             ErrorMsg = "please enter description".localized
        }
//        else if pickedImageAry.count == 0 && certificates.count == 0{
//            ErrorMsg = "please select at least one certificate".localized
//        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title:"Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    
    
    @IBAction func onClickGender(_ sender: UIButton) {
        if sender.tag == 0{
            bntM.setImage(#imageLiteral(resourceName: "radioSelectButton"), for: .normal)
            btnF.setImage(#imageLiteral(resourceName: "radioButton"), for: .normal)
            selectedGender = "m"
        }else{
            bntM.setImage(#imageLiteral(resourceName: "uncheckedCon"), for: .normal)
            btnF.setImage(#imageLiteral(resourceName: "radioSelectButton"), for: .normal)
            selectedGender = "f"
        }
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pickImage() {
        let captureAction = UIAlertAction(title: "Capture".localized, style: .default, handler: { (action) -> Void in
            print("Capture Button Pressed")
            self.checkCamera() //checkCameraPermission()
        })
        let selectImageFromGalleryAction = UIAlertAction(title: "From Gallery".localized, style: .default, handler: { (action) -> Void in
            print("Select Image From Gallery Button Pressed")
            self.picker = UIImagePickerController()
            self.picker.openGallery(vc: self)
        })
        showActionSheetWithTitle(title: "Select Image".localized, actions: [captureAction, selectImageFromGalleryAction])
    }
    
    func showActionSheetWithTitle(title:String, actions:[UIAlertAction]) {
        let actionSheet = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        for action in actions {
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction(title:"Cancel".localized, style: .cancel, handler: nil))
        
        //For iPad display actionsheet
        actionSheet.popoverPresentationController?.sourceRect = imgProfile.frame
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        self.present(actionSheet, animated: true, completion: nil)
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
            self.alert(title: "Alert".localized, message: "Camera is not available in this device".localized)
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
                    self.alert(title: "", message:"Camera access required for capturing photos!".localized, actions: ["Cancel".localized,"Settings".localized], completion: { (flag) in
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
    
    func checkCamera() {
        //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera
        //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera/27646311
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            openCamera() // Do your stuff here i.e. callCameraMethod()
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
        func openSettingForGivePermissionCamera() {
            self.alert(title: "", message: "Camera access required for capturing photos!".localized, actions: ["Cancel".localized,"Settings".localized], completion: { (flag) in
                if flag == 1{ //Setting
                    self.open(scheme:UIApplication.openSettingsURLString)
                }
                else{//Cancel
                }
            })
        }

}
extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtAddress == textField {
            txtAddress.text = nil
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
        if txtAddress == textField {
            return false
        }
        else{
            return true
        }
    }
    
}
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        txtAddress.text = place.formattedAddress
        
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
extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        //2
        //        if let selectedImage = selectedImage {
        //
        //        }
        //        else{
        //            print("Something went wrong")
        //        }
        //3
        //dismiss(animated: true, completion: nil)
        dismiss(animated: false) {
            
            
            if let selectedImages = selectedImage {
               // self.pickedImageName = picker.getPickedFileName(info: info) ?? "image.jpeg"
                self.str = picker.getPickedFileName(info: info) ?? "image.jpeg"
                if self.isFromProfile{
                    self.selctedImageName = self.str
                   
                }else{
                    self.pickedImageNameAry.append(self.str)
                }
                let imageCropper = ImageCropper.storyboardInstance
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
            
        }
    }
    
   
}
extension EditProfileVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
       // self.pickedImage = cropImage
       
        //txtUploadImg.text = pickedImageName
        
        //TODO: If ImageCropper Used then comment below line
        //self.pickedImage = selectedImage
        //        if isFromEdit  == true {
        //            let dict = NSMutableDictionary()
        //            dict.setValue(cropImage, forKey: "image")
        //            dict.setValue("", forKey: "image_id")
        //            arrImages.add(dict)
        //        }
         if self.isFromProfile{
        selectedImage = cropImage
             imgProfile.image = cropImage
         }else{
            self.pickedImageAry.append(cropImage)
          
         let dict = [ "image": cropImage,
                     "isImage" : true,
                     "name": str] as [String : Any]
            certificates.append(dict)
            self.collectionViewCertificate.reloadData()
            if certificates.count != 0{
                collectionViewHeight.constant = 140
                
            }else{
                collectionViewHeight.constant = 1
            }
        }
        
       // self.imgCollectionview.reloadData()
      //  collectionViewHeight.constant = imgCollectionview.contentSize.height
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
extension EditProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return certificates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as? SubCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        if certificates[indexPath.row]["isImage"]as! Bool == false{
            cell.imgView.downLoadImage(url: certificates[indexPath.row]["image"] as! String)
        }else{
            cell.imgView.image = (certificates[indexPath.row]["image"] as! UIImage)
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onCLickDelete(_:)), for: .touchUpInside)
        
        cell.setRadius(10.0)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
   @objc func onCLickDelete(_ sender:UIButton){
    var dict = [String:Any]()
    dict = certificates[sender.tag]
   
   
        removedImageNameArray.append(dict["name"] as! String)
     if dict["isImage"]as! Bool == true{
    pickedImageAry.remove(object: dict["image"] as! UIImage)
    pickedImageNameAry.remove(object: dict["name"] as! String)
    }
    certificates.remove(at: sender.tag)
    
    self.collectionViewCertificate.reloadData()
    if certificates.count != 0{
        collectionViewHeight.constant = 140
        
    }else{
        collectionViewHeight.constant = 1
    }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 120, height:120)
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        
    }
    
    
}
