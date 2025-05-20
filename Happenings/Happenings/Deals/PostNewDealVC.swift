//
//  PostNewDealVC.swift
//  Happenings
//
//  Created by admin on 2/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import GooglePlaces

class PostNewDealVC: BaseViewController {

    static var storyboardInstance:PostNewDealVC? {
        return StoryBoard.deals.instantiateViewController(withIdentifier: PostNewDealVC.identifier) as? PostNewDealVC
    }
    
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
            let pickerView =  UIDatePicker()
            pickerView.datePickerMode = .date
            let mydate = Date()
            pickerView.minimumDate = mydate
            pickerView.addTarget(self, action: #selector(endTime(_:)), for: UIControl.Event.valueChanged)
            txtEndDate.inputView = pickerView
        }
    }
    
    @IBOutlet weak var viewEndDate: UIView!{
        didSet{
            viewEndDate.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var btnEditCancel: UIButton!{
        didSet{
            btnEditCancel.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    @IBOutlet weak var viewEditDiscountPrice: UIView!{
        didSet{
            viewEditDiscountPrice.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtEditDiscountPrice: UITextField!
    @IBOutlet weak var viewEditDealDiscount: UIView!{
        didSet{
            viewEditDealDiscount.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtEditDealDiscount: UITextField!{
        didSet{
            txtEditDealDiscount.delegate = self
        }
    }
    @IBOutlet weak var txtEditDealPrice: UITextField!
    @IBOutlet weak var viewEditDealPrice: UIView!{
        didSet{
            viewEditDealPrice.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewEditDealOptionTitle: UIView!{
        didSet{
            viewEditDealOptionTitle.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtEditDealOptionTitle: UITextField!
    @IBOutlet weak var viewStartDate: UIView!{
        didSet{
            viewStartDate.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtEndTime: UITextField!{
        didSet{
            let pickerView =  UIDatePicker()
            pickerView.datePickerMode = .time
            let mydate = Date()
            pickerView.minimumDate = mydate
            pickerView.addTarget(self, action: #selector(startTime(_:)), for: UIControl.Event.valueChanged)
            txtEndTime.inputView = pickerView
        }
    }
    
    @IBOutlet weak var viewDiscountPrice: UIView!{
        didSet{
            viewDiscountPrice.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewDesc: UIView!{
        didSet{
            viewDesc.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewLocation: UIView!{
        didSet{
            viewLocation.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewDiscount: UIView!{
        didSet{
            viewDiscount.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewPrice: UIView!{
        didSet{
            viewPrice.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewOptTitle: UIView!{
        didSet{
            viewOptTitle.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewSubCategory: UIView!{
        didSet{
            viewSubCategory.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewCategory: UIView!{
        didSet{
            viewCategory.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var viewTitle: UIView!{
        didSet{
            viewTitle.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var imgCollectionView: UICollectionView!{
        didSet{
            imgCollectionView.delegate = self
            imgCollectionView.dataSource = self
            imgCollectionView.register(AddNewServiceImageCell.nib, forCellWithReuseIdentifier: AddNewServiceImageCell.identifier)
        }
    }
    @IBOutlet weak var viewEditOption: UIView!
    @IBOutlet weak var imgCollectionviewConst: NSLayoutConstraint!
    @IBOutlet weak var tblLocationConst: NSLayoutConstraint!
    
    @IBOutlet weak var tblOptionConst: NSLayoutConstraint!
    @IBOutlet weak var tblLocation: UITableView!{
        didSet{
            tblLocation.register(DealLocationCell.nib, forCellReuseIdentifier: DealLocationCell.identifier)
            tblLocation.delegate = self
            tblLocation.dataSource = self
            tblLocation.separatorStyle = .none
            tblLocation.showsVerticalScrollIndicator = false
            
        }
    }
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Deal Description"
        }
    }
    @IBOutlet weak var tblOptions: UITableView!{
        didSet{
            tblOptions.register(DealOptionCell.nib, forCellReuseIdentifier: DealOptionCell.identifier)
            tblOptions.delegate = self
            tblOptions.dataSource = self
            tblOptions.separatorStyle = .none
            tblOptions.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var txtDiscountPrice: UITextField!
    
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var txtDiscount: UITextField!{
        didSet{
            txtDiscount.delegate = self
        }
    }
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDealOptionTitle: UITextField!
    
    let subCategoryPickerView = UIPickerView()
    @IBOutlet weak var txtSubCategory: UITextField!{
        didSet{
            subCategoryPickerView.delegate = self
            txtSubCategory.inputView = subCategoryPickerView
            txtSubCategory.delegate = self
            txtSubCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
            
        }
    }
    var strDealId:String = ""
    var selectedEditTag:Int = -1
    var startdate:String?
    var endDate:String?
    var categoryList = [AnyObject]()
     var locationList = [AnyObject]()
    var subCategoryList = [AnyObject]()
    var strCatId:String = ""
    var strCatSubId:String = ""
    var selectedCategory: String?
    var selectedSubCategory: String?
    var sticks:String = ""
    var activityIndicator = UIActivityIndicatorView()
    let categoryPickerView = UIPickerView()
    @IBOutlet weak var txtCategory: UITextField!{
        didSet{
            categoryPickerView.delegate = self
            txtCategory.inputView = categoryPickerView
            txtCategory.delegate = self
            txtCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
           
        }
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtDealTitle: UITextField!
    
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
    var arrImages = [UIImage]()
    var arrSelectedImages = [UIImage]()
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var optionList = [AnyObject]()
    var dealDeatil:DealDetailCls?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        callGetCategory()
        sticks = String(Date().ticks)
        self.btnSubmit.isEnabled = false
        self.txtDiscountPrice.isUserInteractionEnabled = false
        self.txtEditDiscountPrice.isUserInteractionEnabled = false
        if strDealId != ""{
            callDealDetail()
        }
    }
    
    func callDealDetail(){
        let param = ["deal_id":strDealId,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getDealDetail(vc: self, param: param) { (dic) in
            print(dic)
            //self.dealDeatil = DealDetailCls(dictionary: dic["data"] as! [String : Any])
            let a = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            let b = a["deal"] as! [String:Any]
            self.dealDeatil = DealDetailCls(dictionary:b)
            self.setData(data: self.dealDeatil!)
        }
    }
    
     func setData(data:DealDetailCls){
        txtDealTitle.text = data.deal_title
        txtCategory.text = data.categoryName
        strCatId = data.deal_category_id
        txtSubCategory.text = data.subcategoryName
        strCatSubId = data.deal_sub_category_id
        
        if let list = dealDeatil?.optionList{
            for i in 0..<list.count{
                let dict = ["discount_price":dealDeatil?.optionList[i].discount_price,
                            "option_discount":dealDeatil?.optionList[i].option_discount,
                            "option_price":dealDeatil?.optionList[i].option_price,
                            "option_title":dealDeatil?.optionList[i].option_title]
                
                optionList.append(dict as AnyObject)
            }
        }
        
        if let list = dealDeatil?.locationList{
            for i in 0..<list.count{
                let dict = ["name":dealDeatil!.locationList[i].deal_location!,
                            "lat":((dealDeatil!.locationList[i].latitude! as NSString).doubleValue),
                            "long":((dealDeatil!.locationList[i].logitude! as NSString).doubleValue)] as [String : Any]
                
                locationList.append(dict as AnyObject)
            }
        }
        
    
        
        if let list = dealDeatil?.imageList{
            for i in 0..<list.count{
                let imageToInsert = UIImageView()
                imageToInsert.downLoadImage(url: (dealDeatil?.imageList[i].dealImage)!)
                arrSelectedImages.append(imageToInsert.image!)
            }
        }
        
        if arrSelectedImages.count != 0{
            self.btnSubmit.isEnabled = true
            imgCollectionView.reloadData()
            setAutoHeight()
        }
        
        txtEndDate.text = dealDeatil?.end_date
        txtEndTime.text = dealDeatil?.end_time
        txtDesc.placeholder = ""
        txtDesc.text = dealDeatil?.description
        
        tblOptions.reloadData()
        tblLocation.reloadData()
        setAutoHeighttbl()
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        // formatter.dateStyle = .medium
        txtEndTime.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd"
//        startdate = formatter2.string(from: sender.date)
//        print(startdate!)
    }
    @objc func endTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // formatter.dateStyle = .medium
        txtEndDate.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd"
//        endDate = formatter2.string(from: sender.date)
//        print(endDate!)
    }
    
    func callGetCategory() {
        let param = ["action":"categorylist"]
        Modal.shared.getCategory(vc: self, param: param) { (dic) in
            print(dic)
            
            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //            let dict = NSDictionary()
            //            dict = self.arrCategoryList[0] as! NSDictionary
            //            self.strCatId = dict.value(forKey: "id")
            if self.categoryList.count != 0 {
                self.categoryPickerView.reloadAllComponents()
            }
        }
    }
    
    func callGetSubCategory(){
        let param = ["action":"subcategorylist",
                     "categoryId":strCatId]
        Modal.shared.getSubCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.subCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //                let dict = NSDictionary()
            //                dict = self.arrSubCategoryList[0] as! NSDictionary
            //                self.strCatSubId = dict.value(forKey: "id")
            if self.subCategoryList.count != 0 {
                self.subCategoryPickerView.reloadAllComponents()
            }
        }
    }

    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtDealTitle.text?.isEmpty)! {
            ErrorMsg = "Please enter deal title"
        }
        else if (txtCategory.text?.isEmpty)! {
            ErrorMsg = "Please enter deal category"
        }
        else if (txtSubCategory.text?.isEmpty)! {
            ErrorMsg = "Please select deal subcategory"
        }
        else if (txtDesc.text?.isEmpty)! {
            ErrorMsg = "Please enter deal description"
        }else if optionList.count == 0{
            ErrorMsg = "Please add deal options"
        }else if locationList.count == 0{
            ErrorMsg = "please select location"
        }else if txtEndDate.text == ""{
            ErrorMsg = "please select end date"
        }else if txtEndTime.text == ""{
            ErrorMsg = "please select end time"
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
    
    
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.imgCollectionviewConst.constant = self.imgCollectionView.contentSize.height
            self.imgCollectionView.layoutIfNeeded()
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
                    self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
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
    
    @IBAction func onClickUpdateOption(_ sender: UIButton) {
      let  dict =  ["option_title":txtEditDealOptionTitle.text!,
                 "option_price":txtEditDealPrice.text!,
                 "option_discount":txtEditDealDiscount.text!,
                 "discount_price":txtEditDiscountPrice.text!]
        
        optionList[selectedEditTag] = dict as AnyObject
        tblOptions.reloadData()
        self.viewEditOption.isHidden = true
        self.navigationBar.isHidden = false
        
    }
    
    @IBAction func onClickCancelOption(_ sender: UIButton) {
        self.viewEditOption.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickAddLocation(_ sender: UIButton) {
        if txtLocation.text == "" {
            self.alert(title: "", message: "please enter location")
        }else{
            var dict = [String:Any]()
            dict = ["name":txtLocation.text!,
                    "lat":latitude!,
                    "long":longitude!]
            locationList.append(dict as AnyObject)
            tblLocation.reloadData()
            setAutoHeighttbl()
            txtLocation.text = ""
            txtEditDealOptionTitle.text = ""
            txtEditDealDiscount.text = ""
            txtEditDiscountPrice.text = ""
            txtEditDealPrice.text = ""
        }
    }
    @IBAction func onClickAddOption(_ sender: UIButton) {
        if txtDealOptionTitle.text == ""{
            self.alert(title: "", message: "please enter option title")
        }else if txtPrice.text == ""{
            self.alert(title: "", message: "please enter deal price")
        }else if txtDiscount.text == ""{
            self.alert(title: "", message: "please enter discount in %")
        }else if txtDiscountPrice.text == "" {
            self.alert(title: "", message: "please enter discount price")
        }else{
            var dict = [String:String]()
            
           dict =  ["option_title":txtDealOptionTitle.text!,
             "option_price":txtPrice.text!,
             "option_discount":txtDiscount.text!,
             "discount_price":txtDiscountPrice.text!]
            
            optionList.append(dict as AnyObject)
            if optionList.count != 0 {
            tblOptions.reloadData()
               // setAutoHeighttbl()
                txtDealOptionTitle.text = ""
                txtDiscount.text = ""
                txtDiscountPrice.text = ""
                txtPrice.text = ""
            }
            
        }
    }
    @IBAction func onClickAddImage(_ sender: UIButton) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
           
            let jsonStringPretty = JSONStringify(value: locationList as AnyObject, prettyPrinted: true)
            let jsonStringPretty1 = JSONStringify(value: optionList as AnyObject, prettyPrinted: true)
            print(jsonStringPretty)
            var strLocation:NSString = jsonStringPretty as NSString
            var strOption:NSString = jsonStringPretty1 as NSString
            strLocation = strLocation.replacingOccurrences(of: "\\", with: "") as NSString
            strOption = strOption.replacingOccurrences(of: "\\", with: "") as NSString
            
            var param = ["user_id":UserData.shared.getUser()!.user_id,
                         "deal_title":txtDealTitle.text!,
                         "deal_category_id":strCatId,
                         "deal_subcategory_id":strCatSubId,
                         "deal_end_at":txtEndDate.text!,
                         "deal_description":txtDesc.text!,
                         "deal_location":strLocation,
                         "deal_options":strOption,
                         "end_date":txtEndDate.text!,
                         "end_time":txtEndTime.text!,
                         
                         ] as [String : Any]
            
            if strDealId == ""{
                param["action"] = "merchant-add-deal"
                param["token"] = self.sticks
            }else{
               param["action"] = "update-deal"
                param["token"] = ""
                param["deal_id"] = strDealId
            }
             if strDealId == ""{
            Modal.shared.addNewDeal(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }
             }else{
                Modal.shared.editDeal(vc: self, param: param) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                }
            }
        }
    }
    
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ?
            JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        //    JSONSerialization.WritingOptionsJSONSerialization.WritingOptions.PrettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
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
extension PostNewDealVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrSelectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewServiceImageCell.identifier, for: indexPath) as? AddNewServiceImageCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.indexPath = indexPath
      
        cell.imgUser.image = arrSelectedImages[indexPath.row]
        
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelte(_:)), for: .touchUpInside)
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
       // self.activityIndicator.frame = CGRect(x: cell.imgUser.frame.origin.x, y: cell.imgUser.frame.origin.y, width:cell.imgUser.frame.size.width, height: cell.imgUser.frame.size.height)
        activityIndicator.center = CGPoint(x:cell.contentView.frame.size.width / 2, y:cell.contentView.frame.size.height / 2)
        self.activityIndicator.hidesWhenStopped = true
        
        cell.addSubview(self.activityIndicator)
    
        return cell
        
    }
    
    @objc func onClickDelte(_ sender: UIButton) {
       self.arrSelectedImages.remove(object: arrSelectedImages[sender.tag])
        self.imgCollectionView.reloadData()

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


extension PostNewDealVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
                self.pickedImageNameAry = [String]()
                self.pickedImageNameAry.append(self.pickedImageName!)
                self.arrImages = [UIImage]()
                self.arrImages.append(selectedImages)
                 self.arrSelectedImages.append(selectedImages)
                self.imgCollectionView.reloadData()
                self.setAutoHeight()
                self.activityIndicator.startAnimating()
                var param = ["action":"deal-images",
                             "user_id":UserData.shared.getUser()!.user_id]
                if self.strCatId != ""{
                    param["deal_id"] = self.strDealId
                    param["token"] = ""
                }else{
                   param["token"] = self.sticks
                }
                if self.strCatId != ""{
                    Modal.shared.editDealImages(vc: self, param: param, withPostImageAry: self.arrImages, withPostImageNameAry: self.pickedImageNameAry) { (dic) in
                        let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                        self.alert(title: "", message: str, completion: {
                            self.activityIndicator.stopAnimating()
                            self.btnSubmit.isEnabled = true
                        })
                    }
                }else{
                Modal.shared.addDealImages(vc: self, param: param, withPostImageAry: self.arrImages, withPostImageNameAry: self.pickedImageNameAry) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.activityIndicator.stopAnimating()
                        self.btnSubmit.isEnabled = true
                    })
                }
                }
            }
            
        }
    }

}
//MARK: ImageCropper Class
extension PostNewDealVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
        
        //txtUploadImg.text = pickedImageName
        
        //TODO: If ImageCropper Used then comment below line
        //self.pickedImage = selectedImage
      
        
        
        }
    
      func didCancel() {
        print("Cancel Crop Image")
    }
}


extension PostNewDealVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView{
            return categoryList.count
        }
        else{
            return subCategoryList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView{
            if categoryList.count > 0{
                var dict = NSDictionary()
                dict = categoryList[row] as! NSDictionary
                selectedCategory = dict.value(forKey: "categoryName") as? String
                let str = dict.value(forKey: "categoryName")
                txtCategory.text = str as? String
                strCatId = (dict.value(forKey: "id") as? String)!
                callGetSubCategory()
            }
        }
        else if pickerView == subCategoryPickerView{
            if subCategoryList.count > 0{
                var dict = NSDictionary()
                dict = subCategoryList[row] as! NSDictionary
                selectedSubCategory = dict.value(forKey: "subcategoryName") as? String
                let str = dict.value(forKey: "subcategoryName")
                txtSubCategory.text = str as? String
                strCatSubId = (dict.value(forKey: "id") as? String)!
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        if pickerView == categoryPickerView{
            var dict = NSDictionary()
            dict = categoryList[row] as! NSDictionary
            let str = dict.value(forKey: "categoryName")
            label.text = str as? String
        }
        else{
            var dict = NSDictionary()
            dict = subCategoryList[row] as! NSDictionary
            let str = dict.value(forKey: "subcategoryName") as? String
            label.text = str
        }
        return label
    }
}
extension PostNewDealVC: UITextFieldDelegate {
    
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
        if textField == txtCategory || textField == txtSubCategory || txtLocation == textField{
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCategory {
            callGetSubCategory()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtDiscount{
            let desimal:Float = Float(Float(txtDiscount.text!)!/100)
            let price = Float(txtPrice.text!)!*desimal
            let disPrice = Float(txtPrice.text!)! - price
            txtDiscountPrice.text = String(disPrice)
        }else if textField == txtEditDealDiscount{
            let desimal:Float = Float(Float(txtEditDealDiscount.text!)!/100)
            let price = Float(txtEditDealPrice.text!)!*desimal
            let disPrice = Float(txtEditDealPrice.text!)! - price
            txtEditDiscountPrice.text = String(disPrice)
        }
        return true
    }
    
}
//MARK:- Google Place API
//https://stackoverflow.com/questions/28793940/how-to-add-google-places-autocomplete-to-xcode-with-swift-tutorial
extension PostNewDealVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
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
extension PostNewDealVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Favorite Deals", action: #selector(onClickMenu(_:)))
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension PostNewDealVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblLocation {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DealLocationCell.identifier) as? DealLocationCell else {
                fatalError("Cell can't be dequeue")
            }
            
            cell.selectionStyle = .none
            var dict = [String:Any]()
            
            dict = locationList[indexPath.row] as! [String : Any]
            cell.lblLocation.text = dict["name"] as? String
            let london = MKPointAnnotation()
            london.title = dict["name"] as? String
            london.coordinate = CLLocationCoordinate2D(latitude:dict["lat"] as! CLLocationDegrees, longitude: dict["long"] as! CLLocationDegrees)
            cell.mapView.addAnnotation(london)
            cell.mapView.centerCoordinate = london.coordinate;
            
        
            cell.btnDelete.tag  = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete1(_:)), for: .touchUpInside)
            return cell
        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DealOptionCell.identifier) as? DealOptionCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.selectionStyle = .none
        var dict = [String:Any]()

        dict = optionList[indexPath.row] as! [String : Any]
        cell.lblDealOpt.text = dict["option_title"] as? String
        cell.lblPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,dict["option_price"]as! String)
        cell.lblDiscountPer.text = dict["option_discount"] as? String
        cell.lblDiscountPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,dict["discount_price"]as! String)
       
        cell.btnDelete.tag  = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEdit), for: .touchUpInside)
        return cell
        }
    }

    @objc func onClickDelete(_ sender:UIButton){
       
        optionList.remove(at: sender.tag)
        
        
        tblOptions.reloadData()
        //setAutoHeighttbl()
    }
    @objc func onClickEdit(_ sender:UIButton){
        var dict = [String:Any]()
        dict = optionList[sender.tag] as! [String : Any]
        txtEditDealOptionTitle.text = dict["option_title"] as? String
        txtEditDealPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,dict["option_price"]as! String)
        txtEditDealDiscount.text = dict["option_discount"] as? String
        txtEditDiscountPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,dict["discount_price"]as! String)
        self.viewEditOption.isHidden = false
        self.navigationBar.isHidden = true
        selectedEditTag = sender.tag
    }
    @objc func onClickDelete1(_ sender:UIButton){
        
        locationList.remove(at: sender.tag)
        
        
        tblLocation.reloadData()
        setAutoHeighttbl()
    }
    
    func setAutoHeighttbl() {

         DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.tblOptionConst.constant = self.tblOptions.contentSize.height
            self.tblLocationConst.constant = self.tblLocation.contentSize.height
            self.view.layoutIfNeeded()
        }
      

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblOptions {
            self.tblOptionConst.constant = self.tblOptions.contentSize.height
        }else if tableView == tblLocation{
            self.tblLocationConst.constant = self.tblLocation.contentSize.height
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblLocation{
            return locationList.count
        }else{
        return optionList.count
        }
    }


}
extension NSDate {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
