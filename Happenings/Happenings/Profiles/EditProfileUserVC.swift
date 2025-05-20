//
//  EditProfileUserVC.swift
//  Happenings
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import PuiSegmentedControl
import GooglePlaces

class EditProfileUserVC: BaseViewController {

    static var storyboardInstance:EditProfileUserVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: EditProfileUserVC.identifier) as? EditProfileUserVC
    }
    
    @IBOutlet weak var viewFirstName: UIView!{
        didSet{
            viewFirstName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var viewLastName: UIView!{
        didSet{
            viewLastName.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
        txtLocation.delegate = self
        }
    }
    
    @IBOutlet weak var viewLocation: UIView!{
        didSet{
            viewLocation.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
   
  @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var viewCountryCode: UIView!{
        didSet{
            viewCountryCode.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtRadius: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var viewContactNumber: UIView!{
        didSet{
            viewContactNumber.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    var strGen:String = ""
    
    @IBOutlet weak var viewRadius: UIView!{
        didSet{
            viewRadius.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var genderView: PuiSegmentedControl!
    
    var unselectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : TitilliumWebFont.regular(with: 17.0),
        .foregroundColor : UIColor.black
    ]
    var selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : TitilliumWebFont.regular(with: 17.0),
        .foregroundColor : UIColor.black
    ]
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
        }
    }
    
    
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    override func viewDidLoad() {
        super.viewDidLoad()

        genderView.isSelectViewAllCornerRadius = true
        genderView.isAnimatedTabTransation = true
        genderView.items = ["Male", "Female"]
        genderView.backgroundCornerRadius = genderView.frame.height / 2
        genderView.borderCornerRadius = genderView.frame.height / 2
        selectedTextAttributes[.foregroundColor] = UIColor.white
        unselectedTextAttributes[.foregroundColor] = UIColor.black
        genderView.selectedTextAttributes = selectedTextAttributes
        genderView.unselectedTextAttributes = unselectedTextAttributes
        genderView.selectedViewBackgroundColor = UIColor.init(hexString: "E0171E")
        genderView.selectedIndex = 0
        didValueChanged(genderView)
        let user = UserData.shared.getUser()
        txtFirstName.text = user?.firstName
        txtLastName.text = user?.lastName
        txtLocation.text = user?.address
        txtContactNumber.text = user?.contact_no
       txtRadius.text = user?.selected_radius
        if user?.gender == "m"{
            genderView.selectedIndex = 0
        }else{
            genderView.selectedIndex = 1
        }
        imgProfile.downLoadImage(url: user?.userProfileImage ?? "")
        
         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
         
    }
    
    
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPhoto(_ sender: UIButton) {
        pickImage()
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickUpdate(_ sender: UIButton) {
        if isValidated(){
            callEditProfile()
        }
    }
    
    
    
    func callEditProfile(){
        let param = ["action":"update-customer-profile",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "first_name":txtFirstName.text!,
                     "last_name":txtLastName.text!,
                     "address":txtLocation.text!,
                     "contact_no":txtContactNumber.text!,
                     "gender":strGen,
                     "radius":"3",
                     "addresslatitude":latitude!,
                     "addresslongitude":longitude!] as [String : Any]
        
        if selectedUserImage != nil {
        Modal.shared.ediProfile(vc: self, postImage: selectedUserImage, param: param, imageName: pickedImageName) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.navigationController?.popViewController(animated: true)
                
            })
        }
        }else{
            Modal.shared.editProfileNoImage(vc: self, param: param) { (dic) in
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
            ErrorMsg = "Please enter first name"
        }
        else if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter last name"
        }
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "Please select location"
        }
       else if (txtContactNumber.text?.isEmpty)! {
            ErrorMsg = "please enter contact number"
        }else if txtContactNumber.text?.length != 10{
            ErrorMsg = "please enter valid contact number"
        }else if (txtRadius.text?.isEmpty)! {
            ErrorMsg = "please select near by radius"
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func didValueChanged(_ sender: PuiSegmentedControl) {
        if sender.selectedIndex == 0 {
            strGen = "m"
        }else{
            strGen = "f"
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

}
extension EditProfileUserVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
extension EditProfileUserVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.selectedUserImage = cropImage
        imgProfile.image = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
extension EditProfileUserVC: GMSAutocompleteViewControllerDelegate {
    
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

extension EditProfileUserVC: UITextFieldDelegate {
    
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
