//
//  ProfileVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import AVFoundation
import GooglePlaces

class EditProfileVC: BaseViewController {
    
    static var storyboardInstance:EditProfileVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: EditProfileVC.identifier) as? EditProfileVC
    }
    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
            imgProfile.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickPickImage(_:)))
            imgProfile.addGestureRecognizer(tapGest)
        }
    }
    @IBOutlet weak var txtAboutMe: UITextView!{
        didSet{
            txtAboutMe.placeholder = "About Me"
        }
    }
    
    @IBOutlet weak var txtLastname: UITextField!
    
    @IBOutlet weak var txtAddress: UITextView!{
        didSet{
            txtAddress.placeholder = "Address"
        }
    }
    
  
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            //txtLocation.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "map-white"))
            txtLocation.delegate = self
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
    var data:Profile?
    override func viewDidLoad() {
        super.viewDidLoad()
       // setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.isHidden = true
        txtFirstName.text = data?.first_name
        txtLastname.text = data?.last_name
        txtLocation.text = data?.location
        imgProfile.downLoadImage(url: (data?.image ?? ""))
        txtAddress.text = data?.address
        txtAboutMe.text = data?.about_description
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        if data == nil {
        let prevVC = HomeVC.storyboardInstance!
        self.navigationController?.popToViewController(prevVC, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter first name"
        }
        else if (txtLastname.text?.isEmpty)! {
            ErrorMsg = "Please enter last name"
        }
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "Please select location"
        }
        
        else if (txtAddress.text?.isEmpty)! {
            ErrorMsg = "please enter address"
        }else if (txtAboutMe.text?.isEmpty)! {
            ErrorMsg = "please enter about me"
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
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickSave(_ sender: Any) {
        if isValidated(){
            callEditProfile()
        }
    }
    
    func callEditProfile() {
        let param = [
            "user_id":UserData.shared.getUser()!.user_id,
            "action":"edit_profile",
            "first_name":txtFirstName.text!,
            "last_name":txtLastname.text!,
            "location":txtLocation.text!,
            "address":txtAddress.text!,
            "about_description":txtAboutMe.text!

        ]
        if selectedUserImage != nil{
        Modal.shared.ediProfile(vc: self, postImage: selectedUserImage, param: param,  imageName: pickedImageName) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                if self.data == nil {
                let prevVC = HomeVC.storyboardInstance!
                self.navigationController?.popToViewController(prevVC, animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        }else{
            Modal.shared.editProfileNoImage(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    if self.data == nil {
                        let prevVC = HomeVC.storyboardInstance!
                        self.navigationController?.popToViewController(prevVC, animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
   
    @objc func onClickPickImage(_ sender: UITapGestureRecognizer){
        //picker = UIImagePickerController()
        //picker.openGallery(vc: self)
        pickImage()
    }
    
    func openSettingForGivePermissionCamera() {
        self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                self.open(scheme:UIApplicationOpenSettingsURLString)
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
                            self.open(scheme:UIApplicationOpenSettingsURLString)
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

}
extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
extension EditProfileVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.selectedUserImage = cropImage
        imgProfile.image = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
//MARK:- Google Place API
//https://stackoverflow.com/questions/28793940/how-to-add-google-places-autocomplete-to-xcode-with-swift-tutorial
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
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

extension EditProfileVC: UITextFieldDelegate {
    
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
