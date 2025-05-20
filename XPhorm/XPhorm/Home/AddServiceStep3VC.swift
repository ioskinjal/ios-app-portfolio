//
//  AddServiceStep3VC.swift
//  XPhorm
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation

class AddServiceStep3VC: BaseViewController {

    static var storyboardInstance:AddServiceStep3VC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: AddServiceStep3VC.identifier) as? AddServiceStep3VC
    }
    @IBOutlet weak var view3: UIView!{
        didSet{
            view3.setRadius()
        }
    }
    @IBOutlet weak var view2: UIView!{
        didSet{
            view2.setRadius()
        }
    }
    @IBOutlet weak var view1: UIView!{
        didSet{
            view1.setRadius()
        }
    }
    @IBOutlet weak var btnContinue: SignInButton!{
        didSet{
           btnContinue.setTitle("FINISH".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            btnBack.setTitle("BACK".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var btnUpload: UIButton!{
        didSet{
           btnUpload.setTitle("Upload Image".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgCollectionview: UICollectionView!{
        didSet{
            imgCollectionview.delegate = self
            imgCollectionview.dataSource = self
            imgCollectionview.register(SubCategoryCell.nib, forCellWithReuseIdentifier: SubCategoryCell.identifier)
        }
    }
    @IBOutlet weak var btnUploadImage: UIButton!{
        didSet{
            btnUploadImage.border(side: .all, color: UIColor(red: 230/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0), borderWidth: 1.0)
        }
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
    
     var data:ServiceDetail?
    var service_id:String = ""
     var arrImages:NSMutableArray = []
    var editImages = [[String:Any]]()
    var pickedImageNameAry = [String]()
    var pickedImage:UIImage?
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Services".localized, action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickImage(_:)), btnRightImg: #imageLiteral(resourceName: "financeIcon"))
        if isFromEdit{
            callGetServiceDetail()
        }
    }
    
    func callGetServiceDetail(){
        let param = ["action":"getServiceInfo",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "id":service_id]
        
        Modal.shared.serviceDetail(vc: self, param: param) { (dic) in
            
            self.data = ServiceDetail(dic: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            for i in self.data!.serviceImages{
                self.editImages.append(["image":i.imagePath,
                                   "id":i.id]
                )
            }
            if self.editImages.count != 0{
            self.imgCollectionview.reloadData()
            }
        }
    }
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    
    @IBAction func onClickUpload(_ sender: UIButton) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    
    
    func checkCamera() {
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
        @unknown default:
            print("Error")
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
                    self.alert(title: "", message: "Camera access required for capturing photos!".localized, actions: ["Cancel".localized,"Settings".localized], completion: { (flag) in
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
            self.alert(title: "Alert".localized, message: "Camera is not available in this device".localized)
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickContinue(_ sender: SignInButton) {
        
//        if pickedImageAry.count == 0 && isFromEdit == false{
//            self.alert(title: "", message: "please upload image".localized)
//        }else{
            callAddService()
//        }
    }
    
    func callAddService(){
        let param = ["action":"addServiceData",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "id":service_id,
        "step":"3"
        ]
        
        Modal.shared.addServiceImage(vc: self, param: param, withPostImageAry: pickedImageAry, withPostImageNameAry: pickedImageNameAry, failer: { (error) in
            
        }) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
               self.navigationController?.popToRootViewController(animated: true)
            })
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
extension AddServiceStep3VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as? SubCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        if editImages[indexPath.row]["id"]as? String == ""{
        cell.imgView.image = editImages[indexPath.row]["image"] as? UIImage
        }else{
            cell.imgView.downLoadImage(url: editImages[indexPath.row]["image"] as! String)
           
        }
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        
        cell.setRadius(10.0)
        return cell
        
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        if editImages[sender.tag]["id"]as? String != ""{
        let param = ["action":"deleteImage",
        "imageId":editImages[sender.tag]["id"]!,
        "id":service_id,
        "lId":UserData.shared.getLanguage,
        "userId":UserData.shared.getUser()!.id]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.editImages = [[String:Any]]()
                self.callGetServiceDetail()
            })
        }
        }else{
            editImages.remove(at: sender.tag)
            imgCollectionview.reloadData()
            collectionViewHeight.constant = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2-7, height:collectionView.frame.size.width / 2-7)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionViewHeight.constant = imgCollectionview.contentSize.height    
    }
}
extension AddServiceStep3VC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
                self.pickedImageName = picker.getPickedFileName(info: info) ?? "image.jpeg"
                self.pickedImageNameAry.append(self.pickedImageName!)
                let imageCropper = ImageCropper.storyboardInstance
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
            
        }
    }
    
   /* @objc private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey]) {
        //1
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
                self.pickedImageName = picker.getPickedFileName(info: info) ?? "image.jpeg"
                self.pickedImageNameAry.append(self.pickedImageName!)
                let imageCropper = ImageCropper.storyboardInstance
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
            
        }
    }*/
}
extension AddServiceStep3VC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
        
        //txtUploadImg.text = pickedImageName
        
        //TODO: If ImageCropper Used then comment below line
        //self.pickedImage = selectedImage
//        if isFromEdit  == true {
//            let dict = NSMutableDictionary()
//            dict.setValue(cropImage, forKey: "image")
//            dict.setValue("", forKey: "image_id")
//            arrImages.add(dict)
//        }
        self.pickedImageAry.append(cropImage)
        
        editImages.append(["image":cropImage,
                           "id":""])
        self.imgCollectionview.reloadData()
        collectionViewHeight.constant = imgCollectionview.contentSize.height
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
