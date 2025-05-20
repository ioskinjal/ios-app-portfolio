//
//  AddProductVC.swift
//  MIShop
//
//  Created by NCrypted on 24/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class AddProductVC: BaseViewController {
    
    @IBOutlet weak var stackViewBiding: UIStackView!
    
    
    @IBOutlet weak var txtBidingDeadline: UITextField!{
        didSet{
            let pickerView =  UIDatePicker()
            pickerView.minimumDate = Date()
            pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(startTimeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtBidingDeadline.inputView = pickerView
            txtBidingDeadline.delegate = self
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            //timePicker.removeFromSuperview() // if you want to remove time picker
            let date = Date()
            
            let formatter2 = DateFormatter()
            
            formatter2.dateFormat = "dd-MMMM-yyyy HH:mm"
            let selectedDate = formatter2.string(from:date)
            txtBidingDeadline.text = selectedDate
        }
    }
    @IBOutlet weak var coverShotCollectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var sizeCollectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnwebCam: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var collectionViewCoverShot: UICollectionView!{
        didSet{
            collectionViewCoverShot.delegate = self
            collectionViewCoverShot.dataSource = self
            collectionViewCoverShot.register(AddNewServiceImageCell.nib, forCellWithReuseIdentifier: AddNewServiceImageCell.identifier)
        }
    }
    @IBOutlet weak var collectionViewSize: UICollectionView!{
        didSet{
            collectionViewSize.delegate = self
            collectionViewSize.dataSource = self
            collectionViewSize.register(SizeCell.nib, forCellWithReuseIdentifier: SizeCell.identifier)
        }
    }
    @IBOutlet weak var collectionViewProductTypes: UICollectionView!{
        didSet{
            collectionViewProductTypes.delegate = self
            collectionViewProductTypes.dataSource = self
            collectionViewProductTypes.register(CategoryCell.nib, forCellWithReuseIdentifier: CategoryCell.identifier)
        }
    }
    @IBOutlet weak var txtCalculatedPrice: UITextField!
    @IBOutlet weak var txtDiscountPrice: UITextField!{
        didSet{
            txtDiscountPrice.delegate = self
        }
    }
    @IBOutlet weak var txtActualPrice: UITextField!{
        didSet{
            txtActualPrice.delegate = self
        }
    }
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnNewItem: UIButton!
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Description"
            // txtDesc.layer.borderColor = colors.DarkGray.color.cgColor
        }
    }
    let brandPickerView = UIPickerView()
    
    @IBOutlet weak var txtBrandName: UITextField!{
        didSet{
            brandPickerView.delegate = self
            txtBrandName.inputView = brandPickerView
            txtBrandName.delegate = self
            brandPickerView.selectedRow(inComponent: 0)
        }
    }
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var btnUsedItem: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblAuction: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    
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
    var selectedProductID:String?
    var isEdit: Bool = false
    var strAuction: String = ""
    var strCondition : String = ""
    var requestDic:[String:Any] = [:]
    var discountedprice : Int = 0
    var selectedCategoryId:String = ""
    var selectedSizeId:String = ""
    var selectedow: Int?
    var selectedrow: Int?
    var pickedImageNameAry = [String]()
    var pickedImage:UIImage?
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    var qty : Int = 1
    var admin_commision : Int = 0
    var categoryList = [CategoryList]()
    var selectedBrand:BrandList?
    var brandList = [BrandList]()
    var sizeList = [SizeList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Product", action: #selector(btnSideMenuOpen))
        setAutoHeight()
        callBrandAP()
        callCategoryAPI()
        onClickAuction(btnYes)
        onClickProductCondition(btnNewItem)
        if isEdit{
            callGetProductdetailsAPI()
        }
    }
    
    func callGetProductdetailsAPI(){
        let param = [
            "productid":selectedProductID!
        ]
        ModelClass.shared.getProductDetail(vc: self, param: param) { (dic) in
            let data = ProductDetail(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.setUserData(data:data)
        }
    }
    
    func setUserData(data:ProductDetail) {
        txtProductName.text = data.productName
        txtBrandName.text = data.brand
        txtDesc.text = data.desc
        if data.condition == "n"{
            onClickProductCondition(btnNewItem)
        }else{
            onClickProductCondition(btnUsedItem)
        }
        if data.auction == "1" {
            onClickAuction(btnYes)
        }else{
            onClickAuction(btnNo)
        }
        txtActualPrice.text = data.orgAmount
        txtDiscountPrice.text = data.amount
        for i in 0..<categoryList.count {
            if data.category == categoryList[i].categoryname {
                let indexPathForFirstRow = IndexPath(row:i , section: 0)
                self.collectionViewProductTypes.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                self.collectionView(self.self.collectionViewProductTypes, didSelectItemAt: indexPathForFirstRow)
                break
            }
            
        }
        for i in 0..<self.sizeList.count {
            
            if data.size == self.sizeList[i].sizeCode {
                let indexPathForFirstRow = IndexPath(row:i , section: 0)
                self.collectionViewSize.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                self.collectionView(self.self.collectionViewSize, didSelectItemAt: indexPathForFirstRow)
                break
            }
        }
        
        
    }
    
    
    
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        txtBidingDeadline.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd"
        let selectedDate = formatter2.string(from: sender.date)
        requestDic["service_start_time"] = selectedDate
        print(requestDic["service_start_time"] as! String)
    }
    
    func callCategoryAPI() {
        ModelClass.shared.getcategory(vc: self) { (dic) in
            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({CategoryList(dic: $0 as! [String:Any])})
            let strCommision: String =  dic["admincommission"]as! String
            self.admin_commision = Int(strCommision)!
            if self.categoryList.count != 0 {
                self.collectionViewProductTypes.reloadData()
                self.setAutoHeight()
                let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                self.collectionViewProductTypes.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                self.collectionView(self.self.collectionViewProductTypes, didSelectItemAt: indexPathForFirstRow)
                
            }
        }
    }
    
    func callBrandAP() {
        ModelClass.shared.getBrand(vc: self) { (dic) in
            self.brandList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({BrandList(dic: $0 as! [String:Any])})
            self.brandPickerView.reloadAllComponents()
        }
    }
    override func viewDidLayoutSubviews()
    {
        txtProductName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtBrandName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtActualPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtDiscountPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtCalculatedPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtDesc.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtBidingDeadline.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.productsCollectionViewHeightConst.constant = self.collectionViewProductTypes.contentSize.height
            self.collectionViewProductTypes.layoutIfNeeded()
            self.sizeCollectionViewHeightConst.constant = self.collectionViewSize.contentSize.height
            self.collectionViewSize.layoutIfNeeded()
            self.coverShotCollectionViewHeightConst.constant = self.collectionViewCoverShot.contentSize.height
            self.collectionViewCoverShot.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    @IBAction func onClickProductCondition(_ sender: UIButton) {
        if sender.tag == 0 {
            strCondition = "n"
            btnNewItem.setImage(#imageLiteral(resourceName: "Blue_Radio"), for: .normal)
            btnUsedItem.setImage(#imageLiteral(resourceName: "Gray_radio"), for: .normal)
        }else{
            strCondition = "u"
            btnUsedItem.setImage(#imageLiteral(resourceName: "Blue_Radio"), for: .normal)
            btnNewItem.setImage(#imageLiteral(resourceName: "Gray_radio"), for: .normal)
        }
    }
    
    @IBAction func onClickMinus(_ sender: UIButton) {
        qty = qty-1
        if qty < 1 {
        }else{
            lblQuantity.text = "\(qty)"
        }
    }
    @IBAction func onClickPlus(_ sender: UIButton) {
        qty = qty+1
        lblQuantity.text = "\(qty)"
    }
    @IBAction func onClickAuction(_ sender: UIButton) {
        if sender.tag == 0 {
            strAuction = "1"
            btnYes.setImage(#imageLiteral(resourceName: "Blue_Radio"), for: .normal)
            btnNo.setImage(#imageLiteral(resourceName: "Gray_radio"), for: .normal)
            stackViewBiding.isHidden = false
        }else{
            strAuction = "0"
            stackViewBiding.isHidden = true
            btnNo.setImage(#imageLiteral(resourceName: "Blue_Radio"), for: .normal)
            btnYes.setImage(#imageLiteral(resourceName: "Gray_radio"), for: .normal)
        }
    }
    @IBAction func onclickUpload(_ sender: Any) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    @IBAction func onClickWebcam(_ sender: UIButton) {
        checkCamera()
    }
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
            addProductAPI()
        }
    }
    
    func addProductAPI() {
        let param : [String:Any]
        if strAuction == "1"{
            param = [
                "user_id":UserData.shared.getUser()!.uId,
                "productName":txtProductName.text!,
                "categoryId":selectedCategoryId,
                "sizeId":selectedSizeId,
                "brandId":selectedBrand!.id,
                "condition":strCondition,
                "amount":txtDiscountPrice.text!,
                "orgAmount":txtActualPrice.text!,
                "productDesc":txtDesc.text!,
                "quantity":lblQuantity.text!,
                "auction":strAuction,
                "bidding_deadline":txtBidingDeadline.text!
            ]
        }else{
            param = [
                "user_id":UserData.shared.getUser()!.uId,
                "productName":txtProductName.text!,
                "categoryId":selectedCategoryId,
                "sizeId":selectedSizeId,
                "brandId":selectedBrand!.id,
                "condition":strCondition,
                "amount":txtDiscountPrice.text!,
                "orgAmount":txtActualPrice.text!,
                "productDesc":txtDesc.text!,
                "quantity":lblQuantity.text!,
                "auction":strAuction
            ]
        }
        
        ModelClass.shared.addMyProduct(vc: self, param: param, withPostImageAry: pickedImageAry, withPostImageNameAry: pickedImageNameAry) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
            })
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
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtProductName.text?.isEmpty)! {
            ErrorMsg = "Please enter product name"
        }
        else if (txtBrandName.text?.isEmpty)! {
            ErrorMsg = "Please select brand name"
        }
        else if (txtDesc.text?.isEmpty)! {
            ErrorMsg = "Please enter description"
        }
        else if (txtActualPrice.text?.isEmpty)! {
            ErrorMsg = "Please enter actual price"
        }
        else if (txtDiscountPrice.text?.isEmpty)! {
            ErrorMsg = "Please enter discount price"
        }
        else if (txtCalculatedPrice.text?.isEmpty)! {
            ErrorMsg = "Please enter calculated price"
        }else{
            
        }
        if txtBidingDeadline.isHidden == false{
            if (txtBidingDeadline.text?.isEmpty)! {
                ErrorMsg = "Please enter biding deadline"
            }
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
    
    func CalculatedPrice()
    {
        if !(txtActualPrice.text?.isEmpty)! || !(txtDiscountPrice.text?.isEmpty)! {
            var calculatedPrice:Float =  Float((100 - admin_commision))
            calculatedPrice = calculatedPrice * Float(discountedprice)
            calculatedPrice = calculatedPrice/100
            txtCalculatedPrice.text = String(format: "%.2f", calculatedPrice)
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
extension AddProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewProductTypes {
            return categoryList.count
        }else if collectionView == collectionViewSize {
            return sizeList.count
        }else{
            return pickedImageAry.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewProductTypes {
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
        }else if collectionView == collectionViewSize {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeCell.identifier, for: indexPath) as? SizeCell else {
                fatalError("Cell can't be dequeue")
            }
            if selectedrow == indexPath.row {
                cell.layer.borderColor = colors.DarkBlue.color.cgColor
            }else{
                cell.layer.borderColor = colors.LightGray.color.cgColor
            }
            cell.lblSize.text = sizeList[indexPath.row].sizeCode
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewServiceImageCell.identifier, for: indexPath) as? AddNewServiceImageCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.indexPath = indexPath
            cell.imgUser.image = pickedImageAry[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewProductTypes {
            selectedow = indexPath.row
            selectedCategoryId = categoryList[selectedow!].id
            
            collectionViewProductTypes.reloadData()
            callGetSizeAPI()
        }else if collectionView == collectionViewSize {
            selectedrow = indexPath.row
            selectedSizeId = sizeList[selectedrow!].id
            collectionViewSize.reloadData()
        }else{
            
        }
    }
    
    func callGetSizeAPI(){
        let param = [
            "categoryid":selectedCategoryId
        ]
        ModelClass.shared.getSize(vc: self, param: param) { (dic) in
            self.sizeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({SizeList(dic: $0 as! [String:Any])})
            if self.sizeList.count != 0 {
                self.collectionViewSize.reloadData()
                self.setAutoHeight()
                if !self.isEdit {
                let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                self.collectionViewSize.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
                self.collectionView(self.self.collectionViewSize, didSelectItemAt: indexPathForFirstRow)
                }
                }
            }
        }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewProductTypes {
            return CGSize(width: 110, height:80)
        }else if collectionView == collectionViewSize {
            return CGSize(width: 40, height:40)
        }
        else{
            return CGSize(width: 110, height:110)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    
}


extension AddProductVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
            //self.pickedImage = selectedImage
            self.pickedImageAry.append(selectedImage)
            
            self.pickedImageNameAry.append(pickedImageName!)
            self.collectionViewCoverShot.reloadData()
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
extension AddProductVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
extension AddProductVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtDiscountPrice{
            if (txtDiscountPrice.text?.isEmpty)! {
                discountedprice = Int(string)!
            }else{
                let strPrice: String = String(format: "%@%@", txtDiscountPrice.text!,string)
                discountedprice = Int(strPrice)!
            }
            
            CalculatedPrice()
        }else if txtBrandName == textField {
            return false
        }else{
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDiscountPrice {
            CalculatedPrice()
        }
    }
    
}
extension AddProductVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBrand = brandList[row]
        txtBrandName.text = brandList[row].brand_name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        let str = brandList[row].brand_name
        label.text = str
        return label
    }
}
