//
//  AddOrganizerVC.swift
//  Luxongo
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class AddOrganizerVC: BaseViewController {

    //MARK: Variables
    var getCreatedOrg:( ( MyOrgenizersCls.List)->() )?
    var selectedImage:UIImage?
    var selectedImageNm:String?
    
    //MARK: Properties
    static var storyboardInstance:AddOrganizerVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: AddOrganizerVC.identifier) as! AddOrganizerVC
    }
    
    @IBOutlet weak var btnClose: GreyButton!
    @IBOutlet weak var lblAddOrg: LabelBold!
    @IBOutlet weak var lblOrgName: LabelSemiBold!
    @IBOutlet weak var lblOrgPhoto: LabelSemiBold!
    @IBOutlet weak var lblOrgDesc: LabelSemiBold!
    @IBOutlet weak var lblWebsite: LabelSemiBold!
    @IBOutlet weak var lblConnectWith: LabelSemiBold!
    
    @IBOutlet weak var tfOrgName: TextField!
    @IBOutlet weak var txvOrgDesc: UITextView!{
        didSet{
            txvOrgDesc.placeholder = "Description"
        }
    }
    @IBOutlet weak var tfWebsite: TextField!
    @IBOutlet weak var tfFb: TextField!
    @IBOutlet weak var tfTwitter: TextField!
    @IBOutlet weak var tfGoogle: TextField!
    @IBOutlet weak var tfLinkeIn: TextField!
    
    @IBOutlet weak var btnAdd: BlackBgButton!
    
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
    
    var isFromEdit = false
    var data:MyOrgenizersCls.List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromEdit{
            btnAdd.setTitle("UPDATE".localized, for: .normal)
            lblAddOrg.text = "Edit Organizer".localized
            if let data = self.data, !data.image.isEmpty && !data.image.contains(string: "no_image"){
                imgUser.downLoadImage(url: data.image)
                self.viewImgPick.isHidden = true
                self.imgUser.isHidden = false
            }            
            tfOrgName.text = data?.name
            txvOrgDesc.placeholder = nil
            txvOrgDesc.text = data?.organizer_desc
            txvOrgDesc.placeholder = "Description"
            tfWebsite.text = data?.website
            tfFb.text = data?.fb_link
            tfTwitter.text = data?.twitter_link
            tfLinkeIn.text = data?.link_in_link
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAttachment()
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        callAddOrg()
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        popViewController(animated: false)
    }
    
    @IBAction func onClickPicImage(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .images)
    }
}

//MARK: Custom functions
extension AddOrganizerVC{
    
    func getAttachment() {
        AttachmentHandler.shared.imagePickedBlock = { [weak self]  (image, imageName) in
            guard let self = self else{ return }
            self.selectedImage = image
            self.selectedImageNm = imageName
            
            if let selectedImages = self.selectedImage {
                let imageCropper = ImageCropper.storyboardInstance
                //imageCropper.cropWidth = 4.0
                //imageCropper.cropHeight = 3.0
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
        }
    }
    
    @objc func tappedMethod(_ sender:AnyObject){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .images)
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfOrgName.text ?? "").isBlank {
            ErrorMsg = "Please enter an Organizer name"
        }
        else if selectedImage == nil && !isFromEdit{
            ErrorMsg = "Please choose Organizer photo"
        }
        else if (txvOrgDesc.text ?? "").isBlank {
            ErrorMsg = "Please enter Description"
        }
        else if (tfWebsite.text ?? "").isBlank {
            ErrorMsg = "Please enter Description"
        }
        else if !tfWebsite.text!.isValidURL {
            ErrorMsg = "Please enter valid URL"
        }
        else if !(tfFb.text ?? "").isBlank && !tfFb.text!.isValidURL {
            ErrorMsg = "Please enter valid facebook URL"
        }
        else if !(tfGoogle.text ?? "").isBlank && !tfGoogle.text!.isValidURL {
            ErrorMsg = "Please enter valid facebook URL"
        }
        else if !(tfTwitter.text ?? "").isBlank && !tfTwitter.text!.isValidURL {
            ErrorMsg = "Please enter valid facebook URL"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
}

//MARK: API methods
extension AddOrganizerVC{
    func callAddOrg() {
        if isValidated(){
            var param:dictionary = ["userid":UserData.shared.getUser()!.userid,
                "new_organizer_name":tfOrgName.text!,
                "new_organizer_desc":txvOrgDesc.text!,
                "new_organizer_website":tfWebsite.text!,
                "new_organizer_fb_link":tfFb.text ?? "",
                "new_organizer_twitter_link":tfTwitter.text ?? "",
                "new_organizer_linked_in_link":tfLinkeIn.text ?? "",
            ]
            if let data = self.data, isFromEdit{
                param["organizer_id"] = data.organizer_id
            }
            API.shared.callImageAttachment(with: isFromEdit ? .editUserOrganizer : .addNewUserOrganizer, viewController: self, param: param, image: selectedImage, imageName: selectedImageNm, withParamName: "new_organizer_image", failer: { (err) in
                print("\(err)")
            }) { (response) in
                let newOrg = MyOrgenizersCls.List(dictionary: ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data))
                print(newOrg.name)
                self.getCreatedOrg?(newOrg)
                NotificationCenter.default.post(name: .editProfile, object: ["flag":true] as [String:Any])
                self.popViewController(animated: true)
            }
        }
    }
}


//MARK: ImageCropper Class
extension AddOrganizerVC: ImageCropperDelegate{
    
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

