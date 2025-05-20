//
//  PostNewAdvertiseVC.swift
//  Explore Local
//
//  Created by NCrypted on 13/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import AVFoundation
import Stripe
import PassKit

class PostNewAdvertiseVC: BaseViewController {

    static var storyboardInstance:PostNewAdvertiseVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: PostNewAdvertiseVC.identifier) as? PostNewAdvertiseVC
    }
    
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtStartDate: UITextField!{
        didSet{
            let datePickerView =  UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.minimumDate = Date()
            datePickerView.addTarget(self, action: #selector(dateDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtStartDate.inputView = datePickerView
            
            
        }
    }
     let datePickerViewEnd =  UIDatePicker()
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
           
            datePickerViewEnd.datePickerMode = .date
            datePickerViewEnd.addTarget(self, action: #selector(dateDiveChanged1(_:)), for: UIControlEvents.valueChanged)
            txtEndDate.inputView = datePickerViewEnd
           
            
        }
    }
    
    
    @IBOutlet weak var const: NSLayoutConstraint!
    @IBOutlet weak var collectionViewImage: UICollectionView!{
        didSet{
            collectionViewImage.delegate = self
            collectionViewImage.dataSource = self
            collectionViewImage.register(AddNewServiceImageCell.nib, forCellWithReuseIdentifier: AddNewServiceImageCell.identifier)
        }
    }
    var strTotal = String()
    var strselectedPage = String()
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
    var pickedImageNameAry = [String]()
    var pickedImage:UIImage?
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    var pageList = ["Home page","Search result page","Merchant detail page"]
    
    @IBOutlet weak var txtURL: UITextField!
    let pagePickerView = UIPickerView()
    @IBOutlet weak var txtSelectPage: UITextField!{
        didSet{
            pagePickerView.delegate = self
            txtSelectPage.inputView = pagePickerView
            txtSelectPage.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add New Advertisement", action: #selector(onClickMenu(_:)))
        
       STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.app.applepayexplorelocal"
        
    }
    
    @objc func dateDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtStartDate.text = formatter.string(from: sender.date)
    }
    
    @objc func dateDiveChanged1(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePickerViewEnd.minimumDate = formatter.date(from: txtStartDate.text ?? "")
        txtEndDate.text = formatter.string(from: sender.date)
        
    }
    

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtSelectPage.text?.isEmpty)! {
            ErrorMsg = "Please select page to display advertise"
        }else  if (txtURL.text?.isEmpty)! {
            ErrorMsg = "Please enter url of advertise"
        }else if !(txtURL.text?.isValidURL)!{
            ErrorMsg = "Please enter valid url"
        }
        else  if (txtStartDate.text?.isEmpty)! {
            ErrorMsg = "Please seelct start date"
        } else if (txtEndDate.text?.isEmpty)! {
            ErrorMsg = "Please select end date"
        }else if pickedImageAry.count == 0{
            ErrorMsg = "Please select image"
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
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
            callCheckPrice()
        }
    }
    
    func callCheckPrice(){
        let param = ["action":"check_price",
                     "page":strselectedPage,
                     "start":txtStartDate.text!,
                     "end":txtEndDate.text!]
        Modal.shared.checkPrice(vc: self, param: param) { (dic) in
            print(dic)
            self.strTotal = String(format: "%d", dic["price"] as! Int)
            let payRequest = Stripe.paymentRequest(withMerchantIdentifier: STPPaymentConfiguration.shared().appleMerchantIdentifier!, country: "US", currency: "USD")
            payRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Advertisement", amount: NSDecimalNumber(string: self.strTotal))]
            
            if Stripe.canSubmitPaymentRequest(payRequest) {
                let authVC = PKPaymentAuthorizationViewController(paymentRequest: payRequest)
                authVC?.delegate = self
                self.present(authVC!, animated: true, completion: nil)
            } else {
                print("Apple Pay is not configured")
            }
        }
        
        
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
    }
    
    @IBAction func onClickUploadImage(_ sender: UIButton) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.const.constant = self.collectionViewImage.contentSize.height
            self.collectionViewImage.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostNewAdvertiseVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
                //self.pickedImageNameAry.append(self.pickedImageName!)
    
                let imageCropper = ImageCropper.storyboardInstance
                imageCropper.delegate = self
                imageCropper.image = selectedImages
                self.present(imageCropper, animated: false, completion: nil)
            }
            
        }
    }
}
//MARK: ImageCropper Class
extension PostNewAdvertiseVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
        
        //txtUploadImg.text = pickedImageName
        
        //TODO: If ImageCropper Used then comment below line
        //self.pickedImage = selectedImage
       
        self.pickedImageAry.append(cropImage)
        pickedImage = cropImage
        btnUpload.isUserInteractionEnabled = false
        
        
        self.collectionViewImage.reloadData()
        self.setAutoHeight()
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}

extension PostNewAdvertiseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedImageAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewServiceImageCell.identifier, for: indexPath) as? AddNewServiceImageCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.indexPath = indexPath
        cell.imgUser.image = pickedImageAry[indexPath.row]
        cell.btnDelete.isHidden = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height:110)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    
}
extension PostNewAdvertiseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return pageList.count
    }

    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
            name = pageList[row]
        let str = name
        label.text = str
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0{
            strselectedPage = "home"
        }else if row == 1{
            strselectedPage = "search"
        }else{
            strselectedPage = "merchant"
        }
        txtSelectPage.text = pageList[row]
    }
    
}
extension PostNewAdvertiseVC:
PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    @available(iOS 11.0, *)
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            if error == nil {
                print("Stripe Token Here => =>",token?.tokenId as Any)
                let param = ["action":"post_advertisement",
                             "user_id":UserData.shared.getUser()!.user_id,
                             "token":token!.tokenId,
                             "amount":self.strTotal,
                             "page":self.strselectedPage,
                             "target":self.txtURL.text!,
                             "start":self.txtStartDate.text!,
                             "end":self.txtEndDate.text!]
                
                Modal.shared.postAdvertisement(vc: self, postImage: self.pickedImage, param: param, imageName: self.pickedImageName, success: { (dic) in
                    
               print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                })
                completion(PKPaymentAuthorizationResult.init(status: .success, errors: nil))
                
            } else {
                print("Error Here => => ",error?.localizedDescription as Any)
                completion(PKPaymentAuthorizationResult.init(status: .failure, errors: [error!]))
            }
        }
    }
    
}

