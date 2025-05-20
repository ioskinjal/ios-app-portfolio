//
//  AddNewBusinessVC.swift
//  Explore Local
//
//  Created by NCrypted on 13/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import GooglePlaces

var isFromEdit:Bool = false
class AddNewBusinessVC: BaseViewController,MKMapViewDelegate {

    static var storyboardInstance: AddNewBusinessVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: AddNewBusinessVC.identifier) as? AddNewBusinessVC
    }
    
    @IBOutlet weak var txtTwitterLink: UITextField!
    @IBOutlet weak var txtFbLink: UITextField!
    @IBOutlet weak var txtGoogleLink: UITextField!
    @IBOutlet weak var switchSun: UIButton!
    @IBOutlet weak var switchSat: UIButton!
    @IBOutlet weak var switchFri: UIButton!
    @IBOutlet weak var switchThu: UIButton!
    @IBOutlet weak var switchWed: UIButton!
    @IBOutlet weak var switchTue: UIButton!
    @IBOutlet weak var switchMon: UIButton!
    var strBusinessId:String?
    @IBOutlet weak var txtBusinessTitle: UITextField!
    
    @IBOutlet weak var txtInstaLink: UITextField!
    let categoryPickerView = UIPickerView()
    @IBOutlet weak var txtCategory: UITextField!{
        didSet{
            categoryPickerView.delegate = self
            txtCategory.inputView = categoryPickerView
            txtCategory.delegate = self
            txtCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
           // txtCategory.border(side: .bottom, color: Color.Black.theam, borderWidth: 1.0)
           // txtCategory.setPlaceHolderColor(color: Color.Black.theam)
        }
    }
    
    let subCategoryPickerView = UIPickerView()
    @IBOutlet weak var txtSubCategory: UITextField!{
        didSet{
            subCategoryPickerView.delegate = self
            txtSubCategory.inputView = subCategoryPickerView
            txtSubCategory.delegate = self
            txtSubCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
            //txtSubCategory.border(side: .bottom, color: Color.Black.theam, borderWidth: 1.0)
           // txtSubCategory.setPlaceHolderColor(color: Color.Black.theam)
        }
    }
    
    @IBOutlet weak var stackViewSun: UIView!
    @IBOutlet weak var stackViewSat: UIView!
    @IBOutlet weak var stackViewFri: UIView!
    @IBOutlet weak var stackViewThu: UIView!
    @IBOutlet weak var stackViewWed: UIView!
    @IBOutlet weak var stackViewTue: UIView!
    @IBOutlet weak var stackViewMon: UIView!
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            txtLocation.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Map"))
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var tableViewConst: NSLayoutConstraint!
    @IBOutlet weak var tblFacelity: UITableView!{
        didSet{
            tblFacelity.register(FacilityCell.nib, forCellReuseIdentifier: FacilityCell.identifier)
            tblFacelity.dataSource = self
            tblFacelity.delegate = self
            tblFacelity.tableFooterView = UIView()
            tblFacelity.separatorStyle = .none
            tblFacelity.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
             mapView.delegate = self
        }
    }
    @IBOutlet weak var txtContact: UITextField!{
        didSet{
            txtContact.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtFaxNumber: UITextField!{
        didSet{
            txtFaxNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Description"
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    var weekList:Array = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
     let weekView = UIPickerView()
   
    
    var arrImages:NSMutableArray = []
    @IBOutlet weak var txtCloseMon: UITextField!{
        didSet{
            txtCloseMon.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
           // pickerView.minimumDate = Date()
           // pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedMon(_:)), for: UIControlEvents.valueChanged)
            txtCloseMon.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
            pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseSun: UITextField!{
        didSet{
            txtCloseSun.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
           // pickerView.minimumDate = Date()
           // pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedSun(_:)), for: UIControlEvents.valueChanged)
            txtCloseSun.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenSun: UITextField!{
        didSet{
            txtOpenSun.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
           // pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenSun(_:)), for: UIControlEvents.valueChanged)
            txtOpenSun.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseSat: UITextField!{
        didSet{
            txtCloseSat.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
           // pickerView.minimumDate = Date()
           // pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedSat(_:)), for: UIControlEvents.valueChanged)
            txtCloseSat.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenSat: UITextField!{
        didSet{
            txtOpenSat.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenSat(_:)), for: UIControlEvents.valueChanged)
            txtOpenSat.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseFri: UITextField!{
        didSet{
            txtCloseFri.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
         //   pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedFri(_:)), for: UIControlEvents.valueChanged)
            txtCloseFri.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenFri: UITextField!{
        didSet{
            txtOpenFri.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenFri(_:)), for: UIControlEvents.valueChanged)
            txtOpenFri.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseThu: UITextField!{
        didSet{
            txtCloseThu.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
           // pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedThu(_:)), for: UIControlEvents.valueChanged)
            txtCloseThu.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenThu: UITextField!{
        didSet{
            txtOpenThu.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenThu(_:)), for: UIControlEvents.valueChanged)
            txtOpenThu.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseWed: UITextField!{
        didSet{
            txtCloseWed.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
          //  pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedWed(_:)), for: UIControlEvents.valueChanged)
            txtCloseWed.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenWed: UITextField!{
        didSet{
            txtOpenWed.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
         //   pickerView.minimumDate = Date()
         //   pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenWed(_:)), for: UIControlEvents.valueChanged)
            txtOpenWed.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtCloseTue: UITextField!{
        didSet{
            txtCloseTue.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
         //   pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedClosedTue(_:)), for: UIControlEvents.valueChanged)
            txtCloseTue.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtOpenMon: UITextField!{
        didSet{
            txtOpenMon.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
          //  pickerView.minimumDate = Date()
         //   pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenMon(_:)), for: UIControlEvents.valueChanged)
            txtOpenMon.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    
    @IBOutlet weak var txtOpenTue: UITextField!{
        didSet{
            txtOpenTue.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
            let pickerView =  UIDatePicker()
         //   pickerView.minimumDate = Date()
         //   pickerView.minuteInterval = 15
            //pickerView.datePickerMode = .time
            pickerView.addTarget(self, action: #selector(timeDiveChangedOpenTue(_:)), for: UIControlEvents.valueChanged)
            txtOpenTue.inputView = pickerView
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
             pickerView.datePickerMode = .time
        }
    }
    @IBOutlet weak var txtWebsiteURL: UITextField!
    @IBOutlet weak var txtAddInfo: UITextView!{
        didSet{
            txtAddInfo.placeholder = "Add Info"
        }
    }
    @IBOutlet weak var txtFacility: UITextField!
    @IBOutlet weak var collectionViewConst: NSLayoutConstraint!
    @IBOutlet weak var collectionViewImage: UICollectionView!{
        didSet{
            collectionViewImage.delegate = self
            collectionViewImage.dataSource = self
            collectionViewImage.register(AddNewServiceImageCell.nib, forCellWithReuseIdentifier: AddNewServiceImageCell.identifier)
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
    var pickedImageNameAry = [String]()
    var pickedImage:UIImage?
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    var categoryList = [AnyObject]()
    var subCategoryList = [AnyObject]()
    var selectedCategory: String?
    var selectedSubCategory: String?
    var categoryId:String?
     var subcategoryId:String?
    var arrFacelity:NSMutableArray = []
    var arrayFacility:NSMutableArray = []
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    var itemArrayWeek = NSMutableArray()
    var dict = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add New Business", action: #selector(onClickMenu(_:)))
        if isFromEdit == true{
            callEditBusiness()
        }else{
             callGetCategory()
        }
       
        
    }
    func callEditBusiness(){
        let param = ["action":"get_edit_business",
                     "business_id":strBusinessId!]
        Modal.shared.getEditBusiness(vc: self, param: param) { (dic) in
            let data:NSDictionary = dic["business"] as! NSDictionary
            print(data)
            self.txtGoogleLink.text = data.value(forKey: "gp_link") as? String
            self.txtInstaLink.text = data.value(forKey: "inst_link") as? String
              self.txtTwitterLink.text = data.value(forKey: "tw_link") as? String
              self.txtFbLink.text = data.value(forKey: "fb_link") as? String
            self.txtBusinessTitle.text = data.value(forKey: "business_name") as? String
            self.txtBusinessTitle.isUserInteractionEnabled = false
            self.categoryId = data.value(forKey: "category_id") as? String
            self.subcategoryId = data.value(forKey: "sub_category_id") as? String
            self.callGetCategory()
            self.txtLocation.text = data.value(forKey: "location")as? String
            self.txtLocation.isUserInteractionEnabled = false
            self.latitude = (data.value(forKey: "addressLat")as? NSString)?.doubleValue
            self.longitude = (data.value(forKey: "addressLng")as? NSString)?.doubleValue
            if self.latitude != nil{
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                annotation.title = self.txtLocation.text
                self.mapView.addAnnotation(annotation)
                
                self.mapView?.setCenter(CLLocationCoordinate2D.init(latitude: self.latitude!, longitude: self.longitude!), animated: true)
            }
                self.txtContact.text = data.value(forKey: "contact_no")as? String
                self.txtFaxNumber.text = data.value(forKey: "fax")as? String
                self.txtDesc.text = data.value(forKey: "business_description") as? String
                self.txtDesc.placeholder = ""
                self.txtAddInfo.placeholder = ""
                self.txtEmail.text = data.value(forKey: "business_email") as? String
                self.txtAddInfo.text = data.value(forKey: "add_info")as? String
            self.arrayFacility.addObjects(from: data.value(forKey: "facility") as! [Any])
            if self.arrayFacility.count != 0 {
                self.tblFacelity.reloadData()
                self.setAutoHeighttbl()
            }
                self.itemArrayWeek.addObjects(from: data.value(forKey: "operating_hours") as! [Any])
            if self.itemArrayWeek.count != 0 {
                var dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[0] as! NSDictionary
                if dictWeek.value(forKey: "mon")as? String == "o"{
                    self.onClickSwitch(self.switchMon)
                    self.txtOpenMon.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseMon.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[1] as! NSDictionary
                if dictWeek.value(forKey: "tue")as? String == "o"{
                    self.onClickSwitch(self.switchTue)
                    self.txtOpenTue.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseTue.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[2] as! NSDictionary
                if dictWeek.value(forKey: "wed")as? String == "o"{
                    self.onClickSwitch(self.switchWed)
                    self.txtOpenWed.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseWed.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[3] as! NSDictionary
                if dictWeek.value(forKey: "thu")as? String == "o"{
                    self.onClickSwitch(self.switchThu)
                    self.txtOpenThu.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseThu.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[4] as! NSDictionary
                if dictWeek.value(forKey: "fri")as? String == "o"{
                    self.onClickSwitch(self.switchFri)
                    self.txtOpenFri.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseFri.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[5] as! NSDictionary
                if dictWeek.value(forKey: "sat")as? String == "o"{
                    self.onClickSwitch(self.switchSat)
                    self.txtOpenSat.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseSat.text = dictWeek.value(forKey: "end_time")as? String
                }
                dictWeek = NSDictionary()
                dictWeek = self.itemArrayWeek[6] as! NSDictionary
                if dictWeek.value(forKey: "sun")as? String == "o"{
                    self.onClickSwitch(self.switchSun)
                    self.txtOpenSun.text = dictWeek.value(forKey: "start_time")as? String
                    self.txtCloseSun.text = dictWeek.value(forKey: "end_time")as? String
                }
        }
                self.txtWebsiteURL.text = data.value(forKey: "business_URL")as? String
            
            
            self.arrImages.addObjects(from: data.value(forKey: "images") as! [Any])
            if self.arrImages.count != 0 {
                self.collectionViewImage.reloadData()
                self.setAutoHeight()
            }
            
        }
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func callGetCategory() {
        
        let param = ["action":"category",
                    "type":"full"]
        Modal.shared.home(vc: self, param: param) { (dic) in
            print(dic)
            
            self.categoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .category) as [AnyObject]
            
            self.categoryPickerView.reloadAllComponents()
            if isFromEdit == true{
                for i in 0..<self.categoryList.count{
                    var dict = NSDictionary()
                    dict = self.categoryList[i] as! NSDictionary
                    if dict.value(forKey: "id")as? String == self.categoryId{
                        self.txtCategory.text = dict.value(forKey: "name")as? String
                        self.txtCategory.isUserInteractionEnabled = false
                    }
                }
                self.txtSubCategory.text = ""
                self.subcategoryId = ""
                self.callGetSubCategory()
            }
            
        }
    }
    
    func callGetSubCategory() {
        if categoryId == nil{
            self.alert(title: "", message: "please select category first")
        }else{
        let param = ["action":"subcategory",
            "category_id":categoryId!]
        Modal.shared.home(vc: self, param: param) { (dic) in
            print(dic)
            
            self.subCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .subcategory) as [AnyObject]
            self.subCategoryPickerView.reloadAllComponents()
            if isFromEdit == true{
                for i in 0..<self.subCategoryList.count{
                    var dict = NSDictionary()
                    dict = self.subCategoryList[i] as! NSDictionary
                    if dict.value(forKey: "id")as? String == self.subcategoryId{
                        self.txtSubCategory.text = dict.value(forKey: "name")as? String
                        self.txtSubCategory.isUserInteractionEnabled = false
                    }
                }
            }
            }
        }
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtBusinessTitle.text?.isEmpty)! {
            ErrorMsg = "Please enter business title"
        }
        else if (txtCategory.text?.isEmpty)! {
            ErrorMsg = "Please select category"
        }
        else if (txtSubCategory.text?.isEmpty)! {
            ErrorMsg = "Please select sub category"
        }
            
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "please select location"
        }else if (txtContact.text?.isEmpty)! {
            ErrorMsg = "please enter contact number"
        }else if (txtContact.text?.length != 10) {
            ErrorMsg = "please enter valid contact number"
        }else if (txtDesc.text?.isEmpty)! {
            ErrorMsg = "please enter description"
        }else if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "please enter email address"
        }else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "please enter valid email address"
//        }else if (txtWebsiteURL.text?.isEmpty)! {
//            ErrorMsg = "please enter website url"
//        }else if (txtGoogleLink.text?.isEmpty)! {
//            ErrorMsg = "please enter website url"
//        }else if (txtFbLink.text?.isEmpty)! {
//            ErrorMsg = "please enter website url"
//        }else if (txtTwitterLink.text?.isEmpty)! {
//            ErrorMsg = "please enter website url"
        }else if (txtAddInfo.text?.isEmpty)! {
            ErrorMsg = "please enter contact number"
        }
        if stackViewMon.isHidden == false{
            if (txtOpenMon.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseMon.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewTue.isHidden == false{
            if (txtOpenTue.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseTue.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewWed.isHidden == false{
            if (txtOpenWed.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseWed.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewThu.isHidden == false{
            if (txtOpenThu.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseThu.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewFri.isHidden == false{
            if (txtOpenFri.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseFri.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewSat.isHidden == false{
            if (txtOpenSat.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseSat.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if stackViewSun.isHidden == false{
            if (txtOpenSun.text?.isEmpty)! {
                ErrorMsg = "please select open time"
            }else if (txtCloseSun.text?.isEmpty)! {
                ErrorMsg = "please select close time"
            }
        }
        if txtWebsiteURL.text != "" {
            if !(txtWebsiteURL.text?.isValidURL)!{
                ErrorMsg = "please enter valid website url"
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
    
    
    
    @objc func timeDiveChangedClosedMon(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseMon.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
       // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedTue(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
       formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseTue.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedWed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseWed.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedThu(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseThu.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedFri(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseFri.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedSat(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseSat.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedClosedSun(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtCloseSun.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
      
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenMon(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenMon.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenTue(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenTue.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenWed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
       formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenWed.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenThu(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
       formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenThu.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenFri(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenFri.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenSat(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenSat.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    @objc func timeDiveChangedOpenSun(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
        txtOpenSun.text = formatter.string(from: sender.date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
       
        // let selectedDate = formatter2.string(from: sender.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickAdd(_ sender: UIButton) {
        if txtFacility.text != ""{
        if isFromEdit == true {
        let dictFacility = NSMutableDictionary()
        dictFacility.setValue(txtFacility.text!, forKey: "value")
        dictFacility.setValue("", forKey: "facility_id")
        arrayFacility.add(dictFacility)
    }
        arrFacelity.add(txtFacility.text!)
        txtFacility.text = ""
        tblFacelity.reloadData()
        setAutoHeighttbl()
        }else{
            self.alert(title: "", message: "please enter facility to add")
        }
    }
    @IBAction func onClickSwitch(_ sender: UIButton) {
        let button:UIButton = sender
        if button.tag == 0{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewMon.isHidden = false
               
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewMon.isHidden = true
                
            }
        }else if button.tag == 1{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewTue.isHidden = false
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewTue.isHidden = true
                
            }
            
        }else if button.tag == 2{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewWed.isHidden = false
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewWed.isHidden = true
                
            }
            
        }else if button.tag == 3{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewThu.isHidden = false
                
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewThu.isHidden = true
                
            }
        }else if button.tag == 4{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewFri.isHidden = false
               
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewFri.isHidden = true
                
            }
        }else if button.tag == 5{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewSat.isHidden = false
                
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewSat.isHidden = true
               
            }
        }else if button.tag == 6{
            if button.currentImage == #imageLiteral(resourceName: "Off"){
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                stackViewSun.isHidden = false
                
            }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                stackViewSun.isHidden = true
               
            }
        }
    }
    @IBAction func onClickUploadImage(_ sender: UIButton) {
        self.picker = UIImagePickerController()
        self.picker.openGallery(vc: self)
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
      if  isValidated(){
        itemArrayWeek = NSMutableArray()
        
        if stackViewMon.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["mon"] = "o"
            dict["start_time"] = txtOpenMon.text
            dict["end_time"] = txtCloseMon.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["mon"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewTue.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["tue"] = "o"
            dict["start_time"] = txtOpenTue.text
            dict["end_time"] = txtCloseTue.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["tue"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewWed.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["wed"] = "o"
            dict["start_time"] = txtOpenWed.text
            dict["end_time"] = txtCloseWed.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["wed"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewThu.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["thu"] = "o"
            dict["start_time"] = txtOpenThu.text
            dict["end_time"] = txtCloseThu.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["thu"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewFri.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["fri"] = "o"
            dict["start_time"] = txtOpenFri.text
            dict["end_time"] = txtCloseFri.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["fri"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewSat.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["sat"] = "o"
            dict["start_time"] = txtOpenSat.text
            dict["end_time"] = txtCloseSat.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["sat"] = "c"
            itemArrayWeek.add(dict)
        }
        if stackViewSun.isHidden == false{
            dict = Dictionary<String, Any>()
            dict["sun"] = "o"
            dict["start_time"] = txtOpenSun.text
            dict["end_time"] = txtCloseSun.text
            itemArrayWeek.add(dict)
        }else{
            dict = Dictionary<String, Any>()
            dict["sun"] = "c"
            itemArrayWeek.add(dict)
        }
            callAddBusiness()
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

    func callAddBusiness(){
        let jsonStringPretty = JSONStringify(value: itemArrayWeek, prettyPrinted: true)
        print(jsonStringPretty)
        var strParam:NSString = jsonStringPretty as NSString
       
        strParam = strParam.replacingOccurrences(of: "\\", with: "") as NSString
//        jsonStringPretty = JSONStringify(value: arrFacelity as AnyObject, prettyPrinted: true)
//        print(jsonStringPretty)
//        var strParam1:NSString = jsonStringPretty as NSString
//        strParam1 = strParam1.replacingOccurrences(of: "\\", with: "") as NSString
        
        
        var param =  [String : Any]()
        
        if isFromEdit == true{
            param = ["action":"edit_business",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "business_name":txtBusinessTitle.text!,
                     "category_id":categoryId!,
                     "sub_category_id":subcategoryId!,
                     "location":txtLocation.text!,
                     "business_description":txtDesc.text!,
                     "add_info":txtAddInfo.text!,
                     "fax":txtFaxNumber.text!,
                     "business_email":txtEmail.text!,
                     "business_URL":txtWebsiteURL.text!,
                     "contact_no":txtContact.text!,
                     "array_week":strParam,
                     "business_id":strBusinessId!,
                     "fb_link":txtFbLink.text!,
                     "tw_link":txtTwitterLink.text!,
                     "gp_link":txtGoogleLink.text!,
                     "inst_link":txtInstaLink.text!
            ]
        }
        else{
        param = ["action":"post_business",
            "user_id":UserData.shared.getUser()!.user_id,
            "business_name":txtBusinessTitle.text!,
            "category_id":categoryId!,
            "sub_category_id":subcategoryId!,
            "location":txtLocation.text!,
            "business_description":txtDesc.text!,
            "add_info":txtAddInfo.text!,
            "fax":txtFaxNumber.text!,
            "business_email":txtEmail.text!,
            "business_URL":txtWebsiteURL.text!,
            "contact_no":txtContact.text!,
            "array_week":strParam,
            "fb_link":txtFbLink.text!,
            "tw_link":txtTwitterLink.text!,
            "gp_link":txtGoogleLink.text!,
            "inst_link":txtInstaLink.text!
            ]
        }
//        if isFromEdit == true{
//            arrFacelity = NSMutableArray()
//             for i in 0..<arrayFacility.count{
//                let dict:NSDictionary = arrayFacility[i] as! NSDictionary
//                arrFacelity.add(dict.value(forKey: "value")!)
//                let strParam:String = String(format: "facility[%d]", i)
//                param[strParam] = arrFacelity[i]
//            }
//        }else{
        if isFromEdit == true{
            arrFacelity = NSMutableArray()
        for i in 0..<arrayFacility.count{
            let dict:NSDictionary = arrayFacility[i] as! NSDictionary
            arrFacelity.add(dict.value(forKey: "value")!)
            
        }
        }
       
        for i in 0..<arrFacelity.count{
            let strParam:String = String(format: "facility[%d]", i)
            param[strParam] = arrFacelity[i]
        }
            
        
        //}
        Modal.shared.postBusiness(vc: self, param: param, withPostImageAry: pickedImageAry, withPostImageNameAry: pickedImageNameAry) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
                
            })
        }
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collectionViewConst.constant = self.collectionViewImage.contentSize.height
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
extension AddNewBusinessVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFromEdit  == true {
            return arrImages.count
        }else{
            return pickedImageAry.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewServiceImageCell.identifier, for: indexPath) as? AddNewServiceImageCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.indexPath = indexPath
        if isFromEdit{
            var dict = NSDictionary()
            dict = arrImages[indexPath.row] as! NSDictionary
            if dict.value(forKey: "image_id")as! String != "" {
            cell.imgUser.downLoadImage(url: dict.value(forKey: "image") as! String)
            }else{
                cell.imgUser.image = dict.value(forKey: "image") as? UIImage
            }
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelte(_:)), for: .touchUpInside)
            
        }else{
            cell.imgUser.image = pickedImageAry[indexPath.row]
        }
        
            return cell
        
    }
    
    @objc func onClickDelte(_ sender: UIButton) {
        var dictImg = NSDictionary()
        dictImg = arrImages[sender.tag] as! NSDictionary
        if pickedImageAry.count != 0 {
            
            self.pickedImageAry.remove(object: dictImg.value(forKey: "image") as! UIImage)
        }
        if dictImg.value(forKey: "image_id") as! String != "" {
            let param = [
                "image_id" : dictImg.value(forKey: "image_id")as! String,
                "action":"delete_image"
            ]
            Modal.shared.deleteMedia(vc: self, param: param) { (dic) in
                self.arrImages.remove(sender.tag)
                self.collectionViewImage.reloadData()
            }
        }else{
            self.arrImages.remove(sender.tag)
            self.collectionViewImage.reloadData()
        }
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


extension AddNewBusinessVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
                self.pickedImageNameAry.append(self.pickedImageName!)
             let imageCropper = ImageCropper.storyboardInstance
             imageCropper.delegate = self
             imageCropper.image = selectedImages
             self.present(imageCropper, animated: false, completion: nil)
             }
 
        }
    }
}
//MARK: ImageCropper Class
extension AddNewBusinessVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.pickedImage = cropImage
      
        //txtUploadImg.text = pickedImageName
        
        //TODO: If ImageCropper Used then comment below line
        //self.pickedImage = selectedImage
         if isFromEdit  == true {
            let dict = NSMutableDictionary()
        dict.setValue(cropImage, forKey: "image")
            dict.setValue("", forKey: "image_id")
        arrImages.add(dict)
        }
        self.pickedImageAry.append(cropImage)
        
       
        self.collectionViewImage.reloadData()
        self.setAutoHeight()
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}

extension AddNewBusinessVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView{
            return categoryList.count
        }
        else if pickerView == subCategoryPickerView{
            return subCategoryList.count
        }else{
        return weekList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView{
            if categoryList.count > 0{
                var dict = NSDictionary()
                dict = categoryList[row] as! NSDictionary
                selectedCategory = dict.value(forKey: "name") as? String
                let str = dict.value(forKey: "name")
                txtCategory.text = str as? String
                categoryId = dict.value(forKey: "id") as? String
                    callGetSubCategory()
            }
        }
        else if pickerView == subCategoryPickerView{
            if subCategoryList.count > 0{
                var dict = NSDictionary()
                dict = subCategoryList[row] as! NSDictionary
                selectedSubCategory = dict.value(forKey: "name") as? String
                let str = dict.value(forKey: "name")
                txtSubCategory.text = str as? String
                subcategoryId = dict.value(forKey: "id") as? String
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
            let str = dict.value(forKey: "name")
            label.text = str as? String
        }
        else if pickerView == subCategoryPickerView{
            var dict = NSDictionary()
            dict = subCategoryList[row] as! NSDictionary
            let str = dict.value(forKey: "name") as? String
            label.text = str
        }else{
        let str = weekList[row]
        label.text = str
        }
        return label
    }
}
extension AddNewBusinessVC: UITextFieldDelegate {
    
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
    
}
//MARK:- Google Place API
//https://stackoverflow.com/questions/28793940/how-to-add-google-places-autocomplete-to-xcode-with-swift-tutorial
extension AddNewBusinessVC: GMSAutocompleteViewControllerDelegate {
    
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
        
        if latitude != nil{
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        annotation.title = place.name
        mapView.addAnnotation(annotation)
       
        mapView?.setCenter(place.coordinate, animated: true)
        }
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
extension AddNewBusinessVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FacilityCell.identifier) as? FacilityCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
        if isFromEdit == true{
            var dict = NSDictionary()
            
            dict = arrayFacility[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "value")as? String
        }else{
        cell.lblName.text = arrFacelity[indexPath.row] as? String
        }
        cell.btnDelete.tag  = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        
            return cell
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        var dict = NSDictionary()
        dict = arrayFacility[sender.tag] as! NSDictionary
        if isFromEdit == true{
           
            arrayFacility.remove(dict)
        }
             arrFacelity.remove(sender.tag)
        
       
        tblFacelity.reloadData()
        setAutoHeighttbl()
    }
    func setAutoHeighttbl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tableViewConst.constant = self.tblFacelity.contentSize.height
            self.tblFacelity.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromEdit == true{
            return arrayFacility.count
        }else{
        return arrFacelity.count
        }
    }
    
    
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
