//
//  EditProfileVC.swift
//  MIShop
//
//  Created by NCrypted on 17/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import AVFoundation


class EditProfileVC: BaseViewController {
    
    @IBOutlet weak var imgTimeLine: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.setRadius()
        }
    }
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var isUserImage : Bool = true
    var selectedBannerImg : UIImage?
    var selectedBannerImageName : String?
    let countryPickerView = UIPickerView()
    
    @IBOutlet weak var txtCountry: UITextField!{
        didSet{
            countryPickerView.delegate = self
            txtCountry.inputView = countryPickerView
            txtCountry.delegate = self
             txtCountry.rightViewMode = .always
            txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
    
    let statePickerView = UIPickerView()
    @IBOutlet weak var txtState: UITextField!{
        didSet{
            statePickerView.delegate = self
            txtState.inputView = statePickerView
            txtState.delegate = self
             txtState.rightViewMode = .always
            txtState.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    
    var countryList = [CountryList]()
    var selectedCountry : CountryList?
    var stateList = [StateList]()
    var selectedState : StateList?
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
        }
    }
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Edit Profile", action: #selector(btnSideMenuOpen))
        imgUser.setRadius()
        
        callGetMyProfile()
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
        self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                self.open(scheme:UIApplicationOpenSettingsURLString)
            }
            else{//Cancel
            }
        })
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
                    self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
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
        actionSheet.popoverPresentationController?.sourceRect = imgUser.frame
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickSaveProfile(_ sender: Any) {
        callEditProfile()
    }
    
    @IBAction func onClickChangeTimeLine(_ sender: Any) {
        isUserImage = false
       // pickImage()
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    
    
    @IBAction func onClickChangeProfile(_ sender: Any) {
        isUserImage = true
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
       // pickImage()
    }
    
    func callEditProfile(){
        let param = [
            "user_id":UserData.shared.getUser()!.uId,
            "firstname":txtFirstName.text!,
            "lastname":txtLastName.text!,
            "username":txtUserName.text!,
            "email":txtEmail.text!,
            "country":selectedCountry!.id,
            "state":selectedState!.StateID,
            "location":txtCity.text!,
            "website":txtWebsite.text!
        ]
        ModelClass.shared.editProfile(vc: self, param: param, postImage: selectedUserImage, bannerImage: selectedBannerImg, imageName: pickedImageName, bannerimageName: selectedBannerImageName) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
            })
        }
    }
    
    func getCountryList() {
        ModelClass.shared.getCountruList(vc: self) { (dic) in
            self.countryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({CountryList(dic: $0 as! [String:Any])})
            if self.countryList.count != 0{
                self.countryPickerView.reloadAllComponents()
            }
        }
    }
    
    func callStateListAPI() {
        let param = [
            "country_id":selectedCountry!.id
        ]
        ModelClass.shared.getStateList(vc: self, param: param) { (dic) in
            self.stateList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({StateList(dic: $0 as! [String:Any])})
            if self.stateList.count != 0{
                self.statePickerView.reloadAllComponents()
            }
        }
    }
    
    func callGetMyProfile() {
        let param = [
            "user_id":UserData.shared.getUser()!.uId
        ]
        ModelClass.shared.getMyProfile(vc: self, param: param) { (dic) in
            var data = [MyProfile]()
             data = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({MyProfile(dic: $0 as! [String:Any])})
            
            self.setUserData(data: data)
        }
    }
    
     func setUserData(data: [MyProfile]) {
        txtFirstName.text = data[0].firstName
        txtLastName.text = data[0].lastName
        txtUserName.text = data[0].userName
        txtCountry.text = data[0].country
        txtState.text = data[0].stateName
        txtCity.text = data[0].city
        txtWebsite.text = data[0].website
        imgUser.downLoadImage(url: data[0].profileImg)
        imgTimeLine.downLoadImage(url: data[0].bannerImg)
        let dict = CountryList()
        dict.setValue(data[0].country, forKey: "country")
         dict.setValue(data[0].loc_country, forKey: "id")
        selectedCountry = dict
        let dictState = StateList()
        dictState.setValue(data[0].stateName, forKey: "stateName")
        dictState.setValue(data[0].state, forKey: "StateID")
        dictState.setValue(data[0].loc_country, forKey: "CountryID")
        selectedState = dictState
        selectedUserImage = imgUser.image
        selectedBannerImg = imgTimeLine.image
        getCountryList()
        callStateListAPI()
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

extension EditProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView{
            return countryList.count
        }
        else{
            return stateList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView{
            if countryList.count > 0{
                selectedCountry = countryList[row]
                let str = countryList[row].country
                txtCountry.text = str
            }
        }
        else{
            if stateList.count > 0{
               selectedState = stateList[row]
                let str = stateList[row].stateName
                txtState.text = str
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        // label.font = RobotoFont.regular(with: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        if pickerView == countryPickerView{
            let str = countryList[row].country
            label.text = str
        }
        else{
            let str = stateList[row].stateName
            label.text = str
        }
        return label
    }
}
extension EditProfileVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCountry || textField == txtState  {
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if textField == txtCountry {
            getCountryList()
        }else if textField == txtState {
            var ErrorMsg = ""
            if selectedCountry == nil {
                ErrorMsg = "please select country first"
                let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }else{
                callStateListAPI()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCountry {
            callStateListAPI()
        }
    }
    
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
             if isUserImage {
            selectedImage = editedImage
             }else{
                selectedBannerImg = editedImage
            }
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
              if isUserImage {
            selectedImage = originalImage
            selectedUserImage = originalImage
              }else{
                selectedBannerImg = originalImage
            }
        }
        //2
        //if let _ = selectedImage {
         if isUserImage {
             pickedImageName = picker.getPickedFileName(info: info)
         }else{
             selectedBannerImageName = picker.getPickedFileName(info: info)
        }
            if isUserImage {
            imgUser.image = selectedUserImage
            }else{
                imgTimeLine.image = nil
                imgTimeLine.image = selectedBannerImg
            }
           
//        }
//        else{
//            print("Something went wrong")
//        }
        //3
        //dismiss(animated: true, completion: nil)
        dismiss(animated: false) {
        }
    }
}



