//
//  ProfileVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import AVFoundation

var isFromLogin:Bool = false
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
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtContactNumber: UITextField!{
        didSet{
            txtContactNumber.keyboardType = .numberPad
            txtContactNumber.delegate = self
        }
    }
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
        }
    }
    var selectedUserImage:UIImage?
    var selectedImg:UIImage?
    var pickedImageName:String?
    var data:Profile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        if UserDefaults.standard.value(forKey: "cartCount") != nil{
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        }
        btnCancel.layer.borderColor = UIColor.init(hexString: "F20F30").cgColor
        if data != nil{
        txtFirstName.text = data?.fname
        txtLastName.text = data?.lname
        txtContactNumber.text = data?.phone
        imgProfile.downLoadImage(url: (data!.user_image))
        
        
        }else{
            txtFirstName.text = UserData.shared.getUser()?.first_name
            txtLastName.text = UserData.shared.getUser()?.last_name
            txtContactNumber.text = UserData.shared.getUser()?.phone
            imgProfile.downLoadImage(url: (UserData.shared.getUser()!.user_image))
            //selectedUserImage = imgProfile.image
        }
       // selectedUserImage = selectedImg
    }

    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        if isFromLogin == true {
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func isValidInput(Input:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        print("\(isValid)")
        
        return isValid
    }
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter first name"
        }else if !(isValidInput(Input: txtFirstName.text!)) {
            ErrorMsg = "firstname only accept characters"
        }
        else if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter last name"
        }else if !(isValidInput(Input: txtLastName.text!)) {
            ErrorMsg = "lastname only accept characters"
        }
        else if (txtContactNumber.text?.isEmpty)! {
            ErrorMsg = "Please enter contact number"
        }else if (txtContactNumber.text?.length)! != 10 {
            ErrorMsg = "please enter valid contact number"
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
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        if isFromLogin == true {
            Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
            Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
            self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
            isFromLogin = false
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func onClickSave(_ sender: Any) {
        if isValidated(){
            callEditProfile()
        }
    }
    
    func callEditProfile() {
        let param = [
            "uid":UserData.shared.getUser()!.user_id,
            "fname":txtFirstName.text!,
            "lname":txtLastName.text!,
            "contact_no":txtContactNumber.text!,
        ]
        if selectedUserImage == nil{
            Modal.shared.editProfile(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    if isFromLogin == true {
                        Modal.sharedAppdelegate.sideMenuController.rootViewController = HomeVC.storyboardInstance!
                        Modal.sharedAppdelegate.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
                        self.navigationController?.pushViewController(Modal.sharedAppdelegate.sideMenuController, animated: true)
                        isFromLogin = false
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }else{
       Modal.shared.editProfileImage(vc: self, postImage: selectedUserImage, param: param, imageName: pickedImageName) { (dic) in
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
        self.imgProfile.image = cropImage
        self.selectedUserImage = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
extension EditProfileVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if txtContactNumber == textField{
                //if (textField.text?.length)! >= 10{
                   // textField.deleteBackward()
               // }
                
            }
            return true
        }
    
    
}


