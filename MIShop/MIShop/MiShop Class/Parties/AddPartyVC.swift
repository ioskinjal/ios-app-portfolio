//
//  AddPartyVC.swift
//  MIShop
//
//  Created by NCrypted on 24/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class AddPartyVC: BaseViewController {

    @IBOutlet weak var btnUpload: UIButton!{
        didSet{
        btnUpload.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var collectionImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var categoriesCollectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var ImageCollectionView: UICollectionView!{
        didSet{
            ImageCollectionView.delegate = self
            ImageCollectionView.dataSource = self
            ImageCollectionView.register(AddNewServiceImageCell.nib, forCellWithReuseIdentifier: AddNewServiceImageCell.identifier)
        }
    }
    
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
             strDate = "endDate"
            txtEndDate.delegate = self
            let pickerView =  UIDatePicker()
            pickerView.minimumDate = Date()
            pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(startTimeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtEndDate.inputView = pickerView
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            //timePicker.removeFromSuperview() // if you want to remove time picker
            //let date = Date()
            
            let formatter2 = DateFormatter()
            
            formatter2.dateFormat = "dd-MMMM-yyyy HH:mm"
           // let selectedDate = formatter2.string(from:date)
            //txtEndDate.text = selectedDate
        }
    }
    var strDate : String?
    @IBOutlet weak var txtFromDate: UITextField!{
        didSet{
            strDate = "fromDate"
            txtFromDate.delegate = self
            let pickerView =  UIDatePicker()
            pickerView.minimumDate = Date()
            pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(startTimeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtFromDate.inputView = pickerView
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            //timePicker.removeFromSuperview() // if you want to remove time picker
         //   let date = Date()
            
            let formatter2 = DateFormatter()
            
            formatter2.dateFormat = "dd-MMMM-yyyy HH:mm"
           // let selectedDate = formatter2.string(from:date)
          //  txtFromDate.text = selectedDate
        }
    }
    var selectedow: Int?
    var pickedImageNameAry = [String]()
    var pickedImage:UIImage?
    var selectedUserImage:UIImage?
     var selectedCategoryId:String = ""
    var pickedImageName:String?
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet{
            categoriesCollectionView.delegate = self
            categoriesCollectionView.dataSource = self
            categoriesCollectionView.register(CategoryCell.nib, forCellWithReuseIdentifier: CategoryCell.identifier)
        }
    }
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Description"
        }
    }
    @IBOutlet weak var txtPartyTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Party", action: #selector(btnSideMenuOpen))
       
        setAutoHeight()
        
        callCategoryAPI()
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
    var categoryList = [CategoryList]()

    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.categoriesCollectionHeightConst.constant = self.categoriesCollectionView.contentSize.height
            self.categoriesCollectionView.layoutIfNeeded()
            self.collectionImageHeightConst.constant = self.ImageCollectionView.contentSize.height
            self.ImageCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MMMM-yyyy HH:mm" //"yyyy-MM-dd"
        let selectedDate = formatter2.string(from: sender.date)
        if strDate == "endDate"{
            txtEndDate.text = selectedDate
        }else{
            txtFromDate.text = selectedDate
        }
    }
    
    func callCategoryAPI() {
        ModelClass.shared.getcategory(vc: self) { (dic) in
            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({CategoryList(dic: $0 as! [String:Any])})
            if self.categoryList.count != 0 {
                self.categoriesCollectionView.reloadData()
                self.setAutoHeight()
                let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                self.categoriesCollectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                self.collectionView(self.self.categoriesCollectionView, didSelectItemAt: indexPathForFirstRow)
                
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        txtDesc.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtPartyTitle.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtEndDate.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtFromDate.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtPartyTitle.text?.isEmpty)! {
            ErrorMsg = "Please enter party name"
        }else if (txtDesc.text?.isEmpty)!{
            ErrorMsg = "please enter description"
        }else if (txtFromDate.text?.isEmpty)!{
            ErrorMsg = "please enter from date"
        }else if (txtEndDate.text?.isEmpty)!{
            ErrorMsg = "please enter end date"
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
    @IBAction func onClickUpload(_ sender: Any) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
            calladdPartyAPI()
        }
    }
    
    func calladdPartyAPI() {
        let param : [String:Any]
            param = [
                "user_id":UserData.shared.getUser()!.uId,
                "partyname":txtPartyTitle.text!,
                "description":txtDesc.text!,
                "category":selectedCategoryId,
                "from_date":txtFromDate.text!,
                "end_date":txtEndDate.text!,
            ]
        ModelClass.shared.addNewParty(vc: self, param: param, postImage:pickedImage , imageName: pickedImageName ) { (dic) in
                 let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                })
        }
    }
}
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

extension AddPartyVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
        if let selectedImage = selectedImage {
            pickedImageName = picker.getPickedFileName(info: info) ?? "image.jpeg"
            //txtUploadImg.text = pickedImageName
            
            //TODO: If ImageCropper Used then comment below line
            self.pickedImage = selectedImage
            self.pickedImageAry.append(selectedImage)
            btnUpload.isHidden = true
            self.pickedImageNameAry.append(pickedImageName!)
            self.ImageCollectionView.reloadData()
            self.setAutoHeight()
        }
        else{
            print("Something went wrong")
        }
        //3
        //dismiss(animated: true, completion: nil)
        dismiss(animated: false) {
            
            /*
             if let selectedImages = selectedImage {
             let imageCropper = ImageCropper.storyboardInstance
             imageCropper.delegate = self
             imageCropper.image = selectedImages
             self.present(imageCropper, animated: false, completion: nil)
             }
             */
        }
    }
}
//MARK: ImageCropper Class
extension AddPartyVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


extension AddPartyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
        return categoryList.count
        }else{
            return pickedImageAry.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == categoriesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.imgCategory.downLoadImage(url: categoryList[indexPath.row].image)
            cell.lblCategoryName.text = categoryList[indexPath.row].categoryname
            if selectedow == indexPath.row {
                cell.contentView.layer.borderColor = colors.DarkBlue.color.cgColor
            }else{
                cell.contentView.layer.borderColor = colors.LightGray.color.cgColor
            }
        return cell
         }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewServiceImageCell.identifier, for: indexPath) as? AddNewServiceImageCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.imgUser.image = pickedImageAry[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedow = indexPath.row
        selectedCategoryId = categoryList[selectedow!].id
        
        categoriesCollectionView.reloadData()
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == categoriesCollectionView {
        return CGSize(width: 110, height:80)
         }else{
            return CGSize(width: 110, height:110)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
extension AddPartyVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
        if textField == txtFromDate {
            strDate = "fromDate"
        }else{
            strDate = "endDate"
        }
        return true
    }
}
