//
//  EditProfileVC.swift
//  Luxongo
//
//  Created by admin on 7/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EditProfileVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:EditProfileVC {
        return StoryBoard.profile.instantiateViewController(withIdentifier: EditProfileVC.identifier) as! EditProfileVC
    }
    
    var isEditMode = false
    var email:String?
    var password:String?
    var selectedImage:UIImage?
    var selectedImageNm:String?
    var gender: String?
    
    let birthDtPickerView:UIDatePicker = {
        let bDtPickerView =  UIDatePicker()
        bDtPickerView.datePickerMode = .date
        //let minutes30Later = TimeInterval(18.years)
        //pickerView.minimumDate = Date().addingTimeInterval(minutes30Later)
        //pickerView.minuteInterval = 15
        // For 24 Hrs
        //pickerView.locale = Locale(identifier: "en_GB")
        //For 12 Hrs
        //pickerView.locale = Locale(identifier: "en_US")
        bDtPickerView.set18YearValidation()
        bDtPickerView.addTarget(self, action: #selector(startTimeDiveChanged), for: .valueChanged)
        return bDtPickerView
    }()
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
 
    
    @IBOutlet weak var txtPayPalEmail: TextField!
    @IBOutlet weak var viewImgPick: GreyView!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            self.imgUser.isHidden = true
            self.imgUser.setRadius(radius: nil)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMethod(_:)))
            self.imgUser.isUserInteractionEnabled = true
            self.imgUser.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var btnSubmit: BlackBgButton!
    @IBOutlet weak var lblProfilePic: LabelSemiBold!
    @IBOutlet weak var lblgender: LabelSemiBold!
    @IBOutlet weak var btnMale: UIButton!{
        didSet{
            self.btnMale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }
    }
    @IBOutlet weak var btnFemale: UIButton!{
        didSet{
            self.btnFemale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)

        }
    }
    @IBOutlet weak var lblFirstNm: LabelSemiBold!
    @IBOutlet weak var lblDateOfBdy: LabelSemiBold!
    @IBOutlet weak var lblMobile: LabelSemiBold!
    @IBOutlet weak var lblOrganization: LabelSemiBold!
    @IBOutlet weak var lblWesite: LabelSemiBold!
    @IBOutlet weak var lblAddress: LabelSemiBold!
    
    @IBOutlet weak var tfFirstNm: TextField!
    
    @IBOutlet weak var tfDateOfBdy: TextField!{
        didSet{
            self.tfDateOfBdy.isPreventCaret = true
            tfDateOfBdy.inputView = birthDtPickerView
            tfDateOfBdy.delegate = self
        }
    }
    @IBOutlet weak var tfMobile: TextField!{
        didSet{
            self.tfMobile.keyboardType = .phonePad
            self.tfMobile.delegate = self
        }
    }
    @IBOutlet weak var tfOrganization: TextField!
    @IBOutlet weak var tfWesite: TextField!
    @IBOutlet weak var tfAddress: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAttachment()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickPicImage(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .images)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if isEditMode{
            callEditProfile()
        }else{
            callSignUpProcess()
        }
    }
    
    @IBAction func onClickMale(_ sender: Any) {
        setGender(isFemale: false)
    }
    
    @IBAction func onClickFemale(_ sender: Any) {
        setGender(isFemale: true)
    }
}

//MARK: Custom functions
extension EditProfileVC{
    
    func setUpUI() {
        if isEditMode{
            if !UserData.shared.getUser()!.avatar_100x_100.isEmpty && !UserData.shared.getUser()!.avatar_100x_100.contains(string: "no_image"){
                self.imgUser.downLoadImage(url: UserData.shared.getUser()!.avatar_100x_100)
                self.viewImgPick.isHidden = true
                self.imgUser.isHidden = false
                
                if let user = UserData.shared.getUser(){
                    tfFirstNm.text = user.name
                    tfDateOfBdy.text = user.date_of_birth
                    tfMobile.text = user.user_mobile_no
                    tfOrganization.text = user.organisation
                    tfWesite.text = user.website
                    tfAddress.text = user.address
                     txtPayPalEmail.text = user.paypal_email
                     if (txtPayPalEmail.text ?? "").isBlank{
                        txtPayPalEmail.text = user.email
                    }
                    
                    
                    if let birthDt = user.date_of_birth.convertDate(dateFormate: DateFormatter.appDateFormat){
                        birthDtPickerView.date = birthDt
                    }
                    if user.gender.lowercased() == "male"{
                        btnMale.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                        btnFemale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
                    }else if user.gender.lowercased() == "female"{
                        btnMale.setImage( #imageLiteral(resourceName: "radioNormal"), for: .normal)
                        btnFemale.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                    }else{
                        btnMale.setImage( #imageLiteral(resourceName: "radioNormal"), for: .normal)
                        btnFemale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
                    }
                }
            }
        }else{
            btnBack.isHidden = false
        }
       
    }
    
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        //let formatter = DateFormatter()
        //formatter.timeStyle = .none
        //formatter.dateStyle = .medium
        //tfDateOfBdy.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        let formatter2 = DateFormatter()
        formatter2.dateFormat = DateFormatter.appDateFormat //"yyyy-MM-dd HH:mm" //"yyyy-MM-dd" //"yyyy-MM-dd HH:mm:ss"
        let selectedDate = formatter2.string(from: sender.date)
        tfDateOfBdy.text = selectedDate
        //requestDic["service_start_time"] = selectedDate
        //print(requestDic["service_start_time"] as! String)
    }
    
    @objc func tappedMethod(_ sender:AnyObject){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .images)
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfFirstNm.text ?? "").isBlank {
            ErrorMsg = "Please enter your name"
        }
        if !(txtPayPalEmail.text ?? "").isBlank{
        if !txtPayPalEmail.text!.isValidEmailId{
            ErrorMsg = "Please enter valid paypal email"
        }
        }
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func getAttachment() {
        AttachmentHandler.shared.imagePickedBlock = { [weak self]  (image, imageName) in
            guard let self = self else{ return }
//            DispatchQueue.updateUI_WithDelay {
                self.selectedImage = image
                self.selectedImageNm = imageName
            
                if let selectedImages = self.selectedImage {
                    let imageCropper = ImageCropper.storyboardInstance
                    imageCropper.delegate = self
                    imageCropper.image = selectedImages
                    self.present(imageCropper, animated: false, completion: nil)
                }
//            }
        }
    }
    
    func setGender(isFemale : Bool) {
        self.btnMale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        self.btnFemale.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        if(isFemale) {
            self.gender = "Female"
            self.btnFemale.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        } else {
            self.gender = "Male"
            self.btnMale.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
    }
    
}

//MARK: API methods
extension EditProfileVC{
    func callSignUpProcess() {
        if isValidated(), let password = self.password, let email = self.email{
            let param:dictionary = ["name": tfFirstNm._text,
                                    "email": email,
                                    "password": password,
                                    "mobile": tfMobile.text ?? "",
                                    "dob": tfDateOfBdy.text ?? "",
                                    "organisation": tfOrganization.text ?? "",
                                    "website": tfWesite.text ?? "",
                                    "address": tfAddress.text ?? "",
                                    "gender": gender ?? "",
                                    "paypal_email":txtPayPalEmail.text ?? ""
            ]
            API.shared.callImageAttachment(with: .signup, viewController: self, param: param, image: selectedImage, imageName: selectedImageNm, withParamName: "profile_picture", failer: { (err) in
                print("\(err)")
            }) { (response) in
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                print(dic)
                UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                    self.popToRootViewController(animated: true)
                })
            }
            
        }
    }
    
    func callEditProfile()  {
        let param:dictionary = [
                                "user_slug":UserData.shared.getUser()!.slug,
                                "name": tfFirstNm._text,
                                "mobile": tfMobile.text ?? "",
                                "dob": tfDateOfBdy.text ?? "",
                                "organisation": tfOrganization.text ?? "",
                                "website": tfWesite.text ?? "",
                                "address": tfAddress.text ?? "",
                                "gender": gender ?? UserData.shared.getUser()!.gender,
                                 "paypal_email":txtPayPalEmail.text ?? ""
        ]
        API.shared.callImageAttachment(with: .userEditProfile, viewController: self, param: param, image: selectedImage, imageName: selectedImageNm, withParamName: "profile_picture", failer: { (err) in
            print("\(err)")
        }) { (response) in
            let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
            print(dic)
            UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                if let slug = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)["slug"] as? String{
                    if let user = UserData.shared.getUser(){
                        user.slug = slug
                        if let userDic = user.convertToDictionary{
                            UserData.shared.setUser(dic: userDic)
                            NotificationCenter.default.post(name: .editProfile, object: ["flag":true] as [String:Any])
                        }
                    }
                }
                self.popViewController(animated: true)
            })
        }
    }
}

//MARK: ImageCropper Class
extension EditProfileVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.selectedImage = cropImage
        self.imgUser.image = cropImage
        self.viewImgPick.isHidden = true
        self.imgUser.isHidden = false
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}


//MARK: TextField delegates
extension EditProfileVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfMobile{
            return string.allowCharacterSets(with: "01234567789+")
        }else if textField == tfDateOfBdy{
            return false
        }
        else{
            return true
        }
    }
    
}
