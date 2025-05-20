//
//  MenuListVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 31/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

var toptitle:String?
class MenuListVC: BaseViewController {
    
    static var storyboardInstance:MenuListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MenuListVC.identifier) as? MenuListVC
    }
    var selectedCuisin:String?
    var arrBoolBreakfast: [Bool] = []
    var arrBoolLunch: [Bool] = []
    var arrBoolDinner: [Bool] = []
    var arrBoolCustomization: [Bool] = []
    var arrCustomization = [CustomizationList]()
    var breakfast : BreakFastList?
    var strDateType:String?
    var cuisineMenu:CuisineMenu?
    var strDeliveryDate:String = ""
    var selectedIndexPath:IndexPath?
    var strSelectedId:String?
    var selectedTagHeader:Int = 0
    var selectedTagCustom:Int = 0
    var cartCount:Int = 0
    var isSelected:Bool = false
    var arrItemSelected:NSMutableArray = []
    var selectedTag:Int?
    var selectedMenu:String?
    @IBOutlet weak var viewBlank: UIView!
    @IBOutlet weak var customizeHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblCustomization: UITableView!{
        didSet{
            tblCustomization.register(CustomizationCell.nib, forCellReuseIdentifier: CustomizationCell.identifier)
            tblCustomization.dataSource = self
            tblCustomization.delegate = self
            tblCustomization.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var lblDeliveryDateDinner: UILabel!
    @IBOutlet weak var lblDeliveryDateLunch: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblSeprator: UILabel!
    @IBOutlet weak var tblDinner: UITableView!{
        didSet{
            tblDinner.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
            tblDinner.dataSource = self
            tblDinner.delegate = self
            tblDinner.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var tblLunch: UITableView!{
        didSet{
            tblLunch.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
            tblLunch.dataSource = self
            tblLunch.delegate = self
            tblLunch.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var tblBreakfast: UITableView!{
        didSet{
            tblBreakfast.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
            tblBreakfast.dataSource = self
            tblBreakfast.delegate = self
            tblBreakfast.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var viewDinner: UIView!
    @IBOutlet weak var viewLunch: UIView!
    @IBOutlet weak var viewBreakfast: UIView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var viewCustomization: UIView!
    @IBOutlet weak var btnDinner: UIButton!
    @IBOutlet weak var btnLunch: UIButton!
    @IBOutlet weak var btnBreakfast: UIButton!
    var totalWidth : CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        
        arrItemSelected = NSMutableArray()
       callGetMenuListAPI()
        if UserDefaults.standard.value(forKey: "cartCount") != nil{
            let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
            self.navigationBar.lblCount.text = String(format: "%d", count)
        }
        
        //tblBreakfast.reloadData()
        //tblDinner.reloadData()
       // tblLunch.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        if UserDefaults.standard.value(forKey: "cartCount") != nil {
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        }
        var time = "6:00:00"
        let dateTime = Date()
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm:ss"
        let strdateTime = dateFormatterTime.string(from: dateTime)
        
        let date = Date()
        if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            strDateType = "dinner"
            dateComponents.day = 1
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
            dateFormatterTime.dateFormat = "yyyy-MM-dd"
            dateFormatterTime.calendar = Calendar(identifier: .gregorian)
            lblDeliveryDate.text = dateFormatterTime.string(from: maxDate!)
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            
            
            
            lblDeliveryDate.text = dateFormatter.string(from: date)
            strDeliveryDate = dateFormatter.string(from: date)
        }
        dateFormatterTime.dateFormat = "HH:mm:ss"
       
        time = "11:00:00"
        
        if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            strDateType = "dinner"
            dateComponents.day = 1
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
            dateFormatterTime.dateFormat = "yyyy-MM-dd"
            dateFormatterTime.calendar = Calendar(identifier: .gregorian)
            lblDeliveryDateLunch.text = dateFormatterTime.string(from: maxDate!)
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            
            
            
            lblDeliveryDateLunch.text = dateFormatter.string(from: date)
            strDeliveryDate = dateFormatter.string(from: date)
        }
        dateFormatterTime.dateFormat = "HH:mm:ss"
        time = "19:00:00"
        if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            strDateType = "dinner"
            dateComponents.day = 1
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
            dateFormatterTime.dateFormat = "yyyy-MM-dd"
            dateFormatterTime.calendar = Calendar(identifier: .gregorian)
            lblDeliveryDateDinner.text = dateFormatterTime.string(from: maxDate!)
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            
            
            
            lblDeliveryDateDinner.text = dateFormatter.string(from: date)
            strDeliveryDate = dateFormatter.string(from: date)
        }
        
        
       // lblDeliveryDateLunch.text = dateFormatter.string(from: date)
        //lblDeliveryDateDinner.text = dateFormatter.string(from: date)
        
        lblDeliveryDate.sizeToFit()
        lblDeliveryDateLunch.sizeToFit()
        lblDeliveryDateDinner.sizeToFit()
        tblBreakfast.reloadData()
        totalWidth = viewBreakfast.frame.size.width * 3
        scrollView.contentSize = CGSize(width: totalWidth!, height: self.scrollView.frame.size.height)
        if toptitle == "Breakfast List" || mealType == "1"{
            onClickMenuList(btnBreakfast)
            toptitle = ""
        }else  if toptitle == "Lunch List" || mealType == "2"{
            onClickMenuList(btnLunch)
            toptitle = ""
        }else  if toptitle == "Dinner List" || mealType == "3"{
            onClickMenuList(btnDinner)
            toptitle = ""
        }else{
            onClickMenuList(btnBreakfast)
        }
        
       
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
            let nextVC = ShoppingCartVC.storyboardInstance!
            self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func callGetMenuListAPI(){
        
        Modal.shared.getMenuList(vc: self) { (dic) in
            self.viewBlank.isHidden = true
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            let menu = CuisineMenu(data: data)
            self.cuisineMenu = menu
            // self.tblDinner.reloadData()
            //self.tblLunch.reloadData()
            // self.tblBreakfast.reloadData()
            self.arrCustomization = [CustomizationList]()
            if self.cuisineMenu?.breakfast.count != 0{
                if let filteredCustomReqList = self.cuisineMenu?.breakfast {
                    for i in 0..<filteredCustomReqList.count {
                        if self.cuisineMenu?.breakfast[i].cuisineName == self.selectedCuisin{
                            self.arrBoolBreakfast.append(true)
                            self.selectedTagHeader = i
                            
                        }else{
                    self.arrBoolBreakfast.append(false)
                        }
                }
                }
                self.tblBreakfast.reloadData()
                
            }
            
            if self.cuisineMenu?.lunch.count != 0{
                if let filteredCustomReqList = self.cuisineMenu?.lunch {
                    for i in 0..<filteredCustomReqList.count {
                         if self.cuisineMenu?.lunch[i].cuisineName == self.selectedCuisin{
                            self.arrBoolLunch.append(true)
                            self.selectedTagHeader = i
                           
                         }else{
                            self.arrBoolLunch.append(false)
                        }
                }
                }
                if self.lblSeprator.frame.origin.x == self.btnLunch.frame.origin.x {
                   
                }
                self.tblLunch.reloadData()
                
            }
            
            if self.cuisineMenu?.dinner.count != 0{
                if let filteredCustomReqList = self.cuisineMenu?.dinner {
                    for i in 0..<filteredCustomReqList.count {
                        if self.cuisineMenu?.dinner[i].cuisineName == self.selectedCuisin{
                             self.arrBoolDinner.append(true)
                            self.selectedTagHeader = i
                            
                        }else{
                             self.arrBoolDinner.append(false)
                        }
                    }
                }
              self.tblDinner.reloadData()
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickAddToCartCustom(_ sender: Any) {
        isFromMenu = true
        let user = UserData.shared.getUser()
        let strCustomId = arrItemSelected.componentsJoined(by: ",")
        
            if strDeliveryDate != "" {
                var param =  [String:String]()
                
                if selectedMenu == "breakfast" {
                    if user != nil {
                 param = ["uid":UserData.shared.getUser()!.user_id,
                          "item_id":cuisineMenu!.breakfast[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                             "date":self.lblDeliveryDate.text!,
                             "customization_item_id":strCustomId]
                    }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.breakfast[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                                 "date":self.lblDeliveryDate.text!,
                                 "customization_item_id":strCustomId]
                    }
                }else if selectedMenu == "lunch"{
                      if user != nil {
                    param = ["uid":UserData.shared.getUser()!.user_id,
                             "item_id":cuisineMenu!.lunch[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                             "date":self.lblDeliveryDateLunch.text!,
                    "customization_item_id":strCustomId]
                      }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.lunch[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                                 "date":self.lblDeliveryDateLunch.text!,
                                 "customization_item_id":strCustomId]
                    }
                }else{
                    if user != nil {
                    param = ["uid":UserData.shared.getUser()!.user_id,
                             "item_id":cuisineMenu!.dinner[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                             "date":self.lblDeliveryDateDinner.text!,
                    "customization_item_id":strCustomId]
                    }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.dinner[selectedTagHeader].cuisineItemsList![selectedTag!].itemID,
                                 "date":self.lblDeliveryDateDinner.text!,
                                 "customization_item_id":strCustomId]
                    }
                }
                Modal.shared.addToCart(vc: self, param: param, failer: { (error) in
                     self.navigationBar.isHidden = false
                    self.viewCustomization.isHidden = true
                }) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationBar.isHidden = false
                        self.viewCustomization.isHidden = true
                        if UserDefaults.standard.value(forKey: "cartCount") != nil{
                            let count = UserDefaults.standard.value(forKey: "cartCount") as! Int
                            self.navigationBar.lblCount.text = String(format: "%d", count+1)
                            UserDefaults.standard.set(count, forKey: "cartCount")
                            UserDefaults.standard.synchronize()
                        }
                })
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "please select delivery date", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    
    @IBAction func onClickCloseCutomization(_ sender: UIButton) {
         self.navigationBar.isHidden = false
        viewCustomization.isHidden = true
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewPicker.isHidden = true
    }
    @IBAction func onClickDone(_ sender: UIButton) {
        viewPicker.isHidden = true
    }
    
    @IBAction func onClickCalendar(_ sender: UIButton) {
        viewPicker.isHidden = false
        if sender.tag == 0 {
            
            
            let currentDate = NSDate()
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            dateComponents.day = 6
            dateComponents.hour = 6
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
            strDateType = "breakfast"
            picker.maximumDate = maxDate
            
            let time = "6:00:00"
            let dateTime = Date()
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "HH:mm:ss"
            let strdateTime = dateFormatterTime.string(from: dateTime)
            
            let date = Date()
            if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
                
                let calendar = Calendar.init(identifier: .gregorian)
                let dateComponents = NSDateComponents()
                dateComponents.day = 1
                let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
                picker.minimumDate = maxDate
            picker.setDate(maxDate!, animated: true)
                dateFormatterTime.dateFormat = "yyyy-MM-dd"
                strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
            }else{
                
                picker.minimumDate = Date()
                picker.setDate(Date(), animated: true)
                dateFormatterTime.dateFormat = "yyyy-MM-dd"
                strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
           }
            self.lblDeliveryDate.text = strDeliveryDate
            
        }else if sender.tag == 1 {
            
            let currentDate = NSDate()
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            strDateType = "lunch"
            dateComponents.day = 6
            dateComponents.hour = 11
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
            picker.maximumDate = maxDate
           
            
            let time = "11:00:00"
            let dateTime = Date()
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "HH:mm:ss"
            let strdateTime = dateFormatterTime.string(from: dateTime)
            
            let date = Date()
            if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
                let calendar = Calendar.init(identifier: .gregorian)
                let dateComponents = NSDateComponents()
                dateComponents.day = 1
                let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
                picker.minimumDate = maxDate
                picker.setDate(maxDate!, animated: true)
                 dateFormatterTime.dateFormat = "yyyy-MM-dd"
                strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
                
            }else{
                
                picker.minimumDate = Date()
                picker.setDate(Date(), animated: true)
                dateFormatterTime.dateFormat = "yyyy-MM-dd"
                 strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
            }
            self.lblDeliveryDateLunch.text = strDeliveryDate
        }else if sender.tag == 2{
            
            let currentDate = NSDate()
            let calendar = Calendar.init(identifier: .gregorian)
            let dateComponents = NSDateComponents()
            strDateType = "dinner"
            dateComponents.day = 6
            dateComponents.hour = 19
            let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
            picker.maximumDate = maxDate
            
            let time = "19:00:00"
            let dateTime = Date()
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "HH:mm:ss"
            let strdateTime = dateFormatterTime.string(from: dateTime)
            
            let date = Date()
            if dateFormatterTime.date(from: strdateTime)! > dateFormatterTime.date(from: time)!{
                let calendar = Calendar.init(identifier: .gregorian)
                let dateComponents = NSDateComponents()
                dateComponents.day = 1
                let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: date as Date)
                picker.minimumDate = maxDate
                picker.setDate(maxDate!, animated: true)
                dateFormatterTime.dateFormat = "yyyy-MM-dd"
                strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
            }else{
                
                picker.minimumDate = Date()
                picker.setDate(Date(), animated: true)
                dateFormatterTime.dateFormat = "yyyy-MM-dd"
                strDeliveryDate = dateFormatterTime.string(from: picker.minimumDate!)
            }
            self.lblDeliveryDateDinner.text = strDeliveryDate
        }
        picker.datePickerMode = UIDatePickerMode.date
        picker.addTarget(self, action: #selector(dueDateChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    @objc func dueDateChanged(_ sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        if strDateType == "breakfast" {
            self.lblDeliveryDate.text = dateFormatter.string(from: sender.date)
            strDeliveryDate = self.lblDeliveryDate.text!
            lblDeliveryDate.sizeToFit()
            
        }else if strDateType == "lunch" {
            self.lblDeliveryDateLunch.text = dateFormatter.string(from: sender.date)
            strDeliveryDate = self.lblDeliveryDateLunch.text!
            lblDeliveryDateLunch.sizeToFit()
            
        }else{
            self.lblDeliveryDateDinner.text = dateFormatter.string(from: sender.date)
            strDeliveryDate = self.lblDeliveryDateDinner.text!
            lblDeliveryDateDinner.sizeToFit()
        }
    }
    @IBAction func onClickMenuList(_ sender: UIButton) {
         selectedTagCustom = 0
        selectedTagHeader = 0
        self.viewPicker.isHidden = true
        if sender.tag == 0 {
            
            lblSeprator.frame = CGRect(x: btnBreakfast.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnBreakfast.frame.size.width, height: lblSeprator.frame.size.height)
            scrollView.setContentOffset(CGPoint(x: self.viewBreakfast.frame.origin.x, y: scrollView.contentOffset.y), animated: true)
            if let filteredCustomReqList = self.cuisineMenu?.breakfast {
                arrBoolBreakfast = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.breakfast[i].cuisineName == self.selectedCuisin{
                        self.arrBoolBreakfast.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolBreakfast.append(false)
                    }
                }
            }
            tblBreakfast.reloadData()
            
        }else if sender.tag == 1 {
            lblSeprator.frame = CGRect(x: btnLunch.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnLunch.frame.size.width, height: lblSeprator.frame.size.height)
            scrollView.setContentOffset(CGPoint(x: self.viewLunch.frame.origin.x, y: scrollView.contentOffset.y), animated: true)
            if let filteredCustomReqList = self.cuisineMenu?.lunch {
                arrBoolLunch = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.lunch[i].cuisineName == self.selectedCuisin{
                        self.arrBoolLunch.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolLunch.append(false)
                    }
                }
            }
            tblLunch.reloadData()
        }else{
            
            lblSeprator.frame = CGRect(x: btnDinner.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnDinner.frame.size.width, height: lblSeprator.frame.size.height)
            scrollView.setContentOffset(CGPoint(x: self.viewDinner.frame.origin.x, y: scrollView.contentOffset.y), animated: true)
            if let filteredCustomReqList = self.cuisineMenu?.dinner {
                arrBoolDinner = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.dinner[i].cuisineName == self.selectedCuisin{
                        self.arrBoolDinner.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolDinner.append(false)
                    }
                }
            }
            tblDinner.reloadData()
        }
       
        
        //self.callGetMenuListAPI()
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
extension MenuListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cuisineMenu = cuisineMenu else {return UITableViewCell()}
        if tableView == tblBreakfast {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.imgFood.layer.cornerRadius = 5
            cell.imgFood.layer.masksToBounds = true
            cell.lblfoodName.text = cuisineMenu.breakfast[indexPath.section].cuisineItemsList![indexPath.row].itemName
            cell.imgFood.downLoadImage(url: cuisineMenu.breakfast[indexPath.section].cuisineItemsList![indexPath.row].itemImage)
            cell.lblPrice.text = cuisineMenu.breakfast[indexPath.section].cuisineItemsList![indexPath.row].itemPrice
            selectedIndexPath = indexPath
            cell.btncart.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickAddToCart(_:)), for: .touchUpInside)
            cell.btncart.addTarget(self, action: #selector(onClickAddToCart(_:)), for: .touchUpInside)
            if cuisineMenu.breakfast[indexPath.section].cuisineItemsList![indexPath.row].isItemCustomizable == true{
                cell.stackViewCustomize.isHidden = false
            }else{
                cell.stackViewCustomize.isHidden = true
            }
            return cell
        }else if tableView == tblLunch{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.imgFood.layer.cornerRadius = 5
            cell.imgFood.layer.masksToBounds = true
            cell.lblfoodName.text = cuisineMenu.lunch[indexPath.section].cuisineItemsList![indexPath.row].itemName
            cell.imgFood.downLoadImage(url: cuisineMenu.lunch[indexPath.section].cuisineItemsList![indexPath.row].itemImage)
            cell.lblPrice.text = cuisineMenu.lunch[indexPath.section].cuisineItemsList![indexPath.row].itemPrice
            cell.btncart.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickAddToCart2(_:)), for: .touchUpInside)
            cell.btncart.addTarget(self, action: #selector(onClickAddToCart2(_:)), for: .touchUpInside)
            if cuisineMenu.lunch[indexPath.section].cuisineItemsList![indexPath.row].isItemCustomizable == true{
                cell.stackViewCustomize.isHidden = false
            }else{
                cell.stackViewCustomize.isHidden = true
            }
            return cell
        }else if tableView == tblDinner{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.imgFood.layer.cornerRadius = 5
            cell.imgFood.layer.masksToBounds = true
            cell.lblfoodName.text = cuisineMenu.dinner[indexPath.section].cuisineItemsList![indexPath.row].itemName
            cell.imgFood.downLoadImage(url:cuisineMenu.dinner[indexPath.section].cuisineItemsList![indexPath.row].itemImage)
            cell.lblPrice.text = cuisineMenu.dinner[indexPath.section].cuisineItemsList![indexPath.row].itemPrice
            cell.btncart.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickAddToCart3(_:)), for: .touchUpInside)
            cell.btncart.addTarget(self, action: #selector(onClickAddToCart3(_:)), for: .touchUpInside)
            if cuisineMenu.dinner[indexPath.section].cuisineItemsList![indexPath.row].isItemCustomizable == true{
                cell.stackViewCustomize.isHidden = false
            }else{
                cell.stackViewCustomize.isHidden = true
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationCell.identifier) as? CustomizationCell else {
                fatalError("Cell can't be dequeue")
            }
            
            cell.lblName.text = (arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemName) + " - " + (arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemPrice)
            if arrCustomization[indexPath.section].customizationType == "2" || arrCustomization[indexPath.section].customizationType == "3"  {
                if arrCustomization[indexPath.section].customizationItemList[indexPath.row].isSelected == true {
                    cell.btnCheck.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
                    arrItemSelected.add(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
                }else{
                    cell.btnCheck.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
                }
                
            }else if arrCustomization[indexPath.section].customizationType == "4" || arrCustomization[indexPath.section].customizationType == "1"  {
                if arrCustomization[indexPath.section].customizationItemList[indexPath.row].isSelected == true {
                cell.btnCheck.setImage(#imageLiteral(resourceName: "radio-icon-fill"), for: .normal)
                arrItemSelected.add(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
                } else{
                    cell.btnCheck.setImage(#imageLiteral(resourceName: "radio-icon"), for: .normal)
                    arrItemSelected.remove(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
                }
            }
        
                    

                cell.btnCheck.tag = indexPath.row
                cell.btnCheck.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
            
            return cell
        }
        
        
    }
    
    @objc func onClickCheck(_ sender:UIButton){
        
        let button:UIButton = sender
        if arrCustomization[selectedTagCustom].customizationType == "4" || arrCustomization[selectedTagCustom].customizationType == "1" {

            let list:Int = arrCustomization[selectedTagCustom].customizationItemList.count
            for i in 0..<list {

                if arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemName == arrCustomization[selectedTagCustom].customizationItemList[i].customizationItemName {
                   if arrCustomization[selectedTagCustom].customizationType == "1" {
                        if arrCustomization[selectedTagCustom].customizationItemList[i].isSelected == true{
                            arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = false
                        }else{
                           arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = true
                        }
                    }else{
                    arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = true
                    }
                }else{
                    arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = false
                }
           }
        
        
            
            
            tblCustomization.reloadData()
            
        }else if arrCustomization[selectedTagCustom].customizationType == "2" || arrCustomization[selectedTagCustom].customizationType == "3"  {
            
            if button.currentImage == #imageLiteral(resourceName: "checkbox_checked") {
                
               
                
                if arrCustomization[selectedTagCustom].customizationType == "3"{
                    let list:Int = arrCustomization[selectedTagCustom].customizationItemList.count
                    let selectedArray = arrCustomization[selectedTagCustom].customizationItemList.filter({$0.isSelected==true})
                    if selectedArray.count == 1{
                        let i = arrCustomization[selectedTagCustom].customizationItemList.index(of: selectedArray.first!)
                        if sender.tag == i {
                            return
                        }
                    }else{
                        button.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
                        arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = false
                        arrItemSelected.remove(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
                    }
                    //for type "2" "3"
                }else{
                     button.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
                arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = false
                arrItemSelected.remove(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
                }
            }else{
                button.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
                arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = true
                arrItemSelected.add(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
            }
        }
        
    }
    @objc func onClickAddToCart(_ sender:UIButton) {
        selectedTag = sender.tag
        if self.cuisineMenu?.breakfast[selectedTagHeader].cuisineItemsList![sender.tag].isItemCustomizable == true {
        arrItemSelected = NSMutableArray()
        arrCustomization = [CustomizationList]()
        
        if let filteredCustomReqList = self.cuisineMenu?.breakfast[selectedTagHeader].cuisineItemsList {
            for _ in 0..<filteredCustomReqList.count {
                if self.lblSeprator.frame.origin.x == self.btnBreakfast.frame.origin.x {
                    self.arrCustomization = (self.cuisineMenu?.breakfast[selectedTagHeader].cuisineItemsList![sender.tag].customizationList!)!
                    if arrCustomization.count != 0 {
                         if self.arrCustomization[0].customizationItemList.count != 0{
                    self.arrCustomization[0].customizationItemList[0].isSelected = true
                        }
                }
                }
                
                
            }
        }
        
        for _ in self.arrCustomization {
            if arrCustomization.count == 1 {
                self.arrBoolCustomization.append(true)
                selectedTagCustom = 0
            }else{
            self.arrBoolCustomization.append(false)
            }
        }
        selectedMenu = "breakfast"
        viewCustomization.isHidden = false
        tblCustomization.reloadData()
        autoDynamicHeight()
        }else{
            isFromMenu = true
            let user = UserData.shared.getUser()
           // let strCustomId = arrItemSelected.componentsJoined(by: ",")
            
            if strDeliveryDate != "" {
                var param =  [String:String]()
                
               
                    if user != nil {
                        param = ["uid":UserData.shared.getUser()!.user_id,
                                 "item_id":cuisineMenu!.breakfast[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDate.text!,
                                 ]
                    }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.breakfast[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDate.text!,
                                 ]
                    }
                
                Modal.shared.addToCart(vc: self, param: param, failer: { (error) in
                    self.navigationBar.isHidden = false
                    self.viewCustomization.isHidden = true
                }) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationBar.isHidden = false
                        self.viewCustomization.isHidden = true
                        if UserDefaults.standard.value(forKey: "cartCount") != nil {
                            self.cartCount = UserDefaults.standard.value(forKey: "cartCount") as! Int
                        }
                        self.navigationBar.lblCount.text = String(format: "%d", self.cartCount+1)
                        UserDefaults.standard.set(self.cartCount, forKey: "cartCount")
                        UserDefaults.standard.synchronize()
                    })
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "please select delivery date", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func onClickAddToCart2(_ sender:UIButton) {
        selectedTag = sender.tag
        if self.cuisineMenu?.lunch[selectedTagHeader].cuisineItemsList![sender.tag].isItemCustomizable == true {
        arrItemSelected = NSMutableArray()
        arrCustomization = [CustomizationList]()
        if let filteredCustomReqList = self.cuisineMenu?.lunch[selectedTagHeader].cuisineItemsList {
            for _ in 0..<filteredCustomReqList.count {
            if self.lblSeprator.frame.origin.x == self.btnLunch.frame.origin.x {
                self.arrCustomization = (self.cuisineMenu?.lunch[selectedTagHeader].cuisineItemsList![sender.tag].customizationList!)!
                 if self.arrCustomization[0].customizationItemList.count != 0{
                self.arrCustomization[0].customizationItemList[0].isSelected = true
                }
            }
        }
            for _ in self.arrCustomization {
                if arrCustomization.count == 1 {
                    self.arrBoolCustomization.append(true)
                    selectedTagCustom = 0
                }else{
                self.arrBoolCustomization.append(false)
                }
            }
            self.tblCustomization.reloadData()
            
            selectedMenu = "lunch"
            self.navigationBar.isHidden = true
            viewCustomization.isHidden = false
            isFromMenu = true
            tblCustomization.reloadData()
            autoDynamicHeight()
            }
        }else{
            isFromMenu = true
            let user = UserData.shared.getUser()
    //let strCustomId = arrItemSelected.componentsJoined(by: ",")
            
            if strDeliveryDate != "" {
                var param =  [String:String]()
                
                    if user != nil {
                        param = ["uid":UserData.shared.getUser()!.user_id,
                                 "item_id":cuisineMenu!.lunch[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDateLunch.text!,
                                 ]
                    }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.lunch[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDateLunch.text!,
                                 ]
                    }
                Modal.shared.addToCart(vc: self, param: param, failer: { (error) in
                    self.navigationBar.isHidden = false
                    self.viewCustomization.isHidden = true
                }) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationBar.isHidden = false
                        self.viewCustomization.isHidden = true
                        if UserDefaults.standard.value(forKey: "cartCount") != nil {
                            self.cartCount = UserDefaults.standard.value(forKey: "cartCount") as! Int
                        }
                        self.navigationBar.lblCount.text = String(format: "%d", self.cartCount+1)
                        UserDefaults.standard.set(self.cartCount, forKey: "cartCount")
                        UserDefaults.standard.synchronize()
                    })
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "please select delivery date", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            }
        
    }
    
    @objc func onClickAddToCart3(_ sender:UIButton) {
         selectedTag = sender.tag
        if self.cuisineMenu?.dinner[selectedTagHeader].cuisineItemsList![sender.tag].isItemCustomizable == true {
        arrItemSelected = NSMutableArray()
        arrCustomization = [CustomizationList]()
        if let filteredCustomReqList = self.cuisineMenu?.dinner[selectedTagHeader].cuisineItemsList {
            for _ in 0..<filteredCustomReqList.count {
                if self.lblSeprator.frame.origin.x == self.btnDinner.frame.origin.x {
                    self.arrCustomization = (self.cuisineMenu?.dinner[selectedTagHeader].cuisineItemsList![sender.tag].customizationList!)!
                    if self.arrCustomization[0].customizationItemList.count != 0{
                    self.arrCustomization[0].customizationItemList[0].isSelected = true
                    }
                }
            }
        }
        for _ in self.arrCustomization {
            if arrCustomization.count == 1 {
                self.arrBoolCustomization.append(true)
                selectedTagCustom = 0
            }else{
            self.arrBoolCustomization.append(false)
            }
            
        }
       
        selectedMenu = "dinner"
         self.navigationBar.isHidden = true
        viewCustomization.isHidden = false
        isFromMenu = true
        tblCustomization.reloadData()
        autoDynamicHeight()
        }else{
            isFromMenu = true
            let user = UserData.shared.getUser()
           // let strCustomId = arrItemSelected.componentsJoined(by: ",")
            
            if strDeliveryDate != "" {
                var param =  [String:String]()
                
                    if user != nil {
                        param = ["uid":UserData.shared.getUser()!.user_id,
                                 "item_id":cuisineMenu!.dinner[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDateDinner.text!,
                                 ]
                    }else{
                        param = ["token_id":UserData.shared.deviceToken,
                                 "item_id":cuisineMenu!.dinner[selectedTagHeader].cuisineItemsList![sender.tag].itemID,
                                 "date":self.lblDeliveryDateDinner.text!,
                                 ]
                }
                Modal.shared.addToCart(vc: self, param: param, failer: { (error) in
                    self.navigationBar.isHidden = false
                    self.viewCustomization.isHidden = true
                }) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.navigationBar.isHidden = false
                        self.viewCustomization.isHidden = true
                        if UserDefaults.standard.value(forKey: "cartCount") != nil {
                            self.cartCount = UserDefaults.standard.value(forKey: "cartCount") as! Int
                        }
                        self.navigationBar.lblCount.text = String(format: "%d", self.cartCount+1)
                        UserDefaults.standard.set(self.cartCount, forKey: "cartCount")
                        UserDefaults.standard.synchronize()
                    })
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "please select delivery date", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cuisineMenu = cuisineMenu else {return 0 }
        if tableView == tblBreakfast{
            guard let breakfastList = cuisineMenu.breakfast[section].cuisineItemsList else{ fatalError() }
            if (arrBoolBreakfast[section]) {
                return breakfastList.count
            }else{
                return 0
            }
        }else if tableView == tblLunch {
            guard let breakfastList = cuisineMenu.lunch[section].cuisineItemsList else{ fatalError() }
            if (arrBoolLunch[section]) {
                return breakfastList.count
            }else{
                return 0
            }
        }else if tableView == tblDinner{
            guard let breakfastList = cuisineMenu.dinner[section].cuisineItemsList else{ fatalError() }
            if (arrBoolDinner[section]) {
                return breakfastList.count
            }else{
                return 0
            }
        }else if tableView == tblCustomization{
            if (arrBoolCustomization[section]) {
                return (arrCustomization[section].customizationItemList.count)
            }else{
                return 0
            }
        }else{
            return 0
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let cuisineMenu = cuisineMenu else {return 0}
        if tableView == tblBreakfast {
            return cuisineMenu.breakfast.count
        }else if tableView == tblLunch {
            return cuisineMenu.lunch.count
        }else if tableView == tblDinner{
            return cuisineMenu.dinner.count
        }else{
            return arrCustomization.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblBreakfast {
            let viewHeaderMain = UIView(frame: CGRect(x: 0, y: 5, width: tblBreakfast.frame.size.width, height: 60))
            viewHeaderMain.backgroundColor = UIColor.clear
            
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: viewHeaderMain.frame.size.width, height: viewHeaderMain.frame.size.height - 10))
            let viewSeprator =  UIView(frame: CGRect(x: 0, y: viewHeader.frame.size.height-1, width: tblBreakfast.frame.size.width, height:1))
            viewSeprator.backgroundColor = UIColor.lightGray
            viewHeader.addSubview(viewSeprator)
            viewHeaderMain.addSubview(viewHeader)
            viewHeaderMain.tag = section
            
            viewHeader.backgroundColor = UIColor.white
            
            let imgViewArrow = UIImageView(frame: CGRect(x: viewHeader.frame.size.width - 20, y: 20, width: 10, height: 6))
            viewHeader.addSubview(imgViewArrow)
            
            if (arrBoolBreakfast[section]) {
                imgViewArrow.image = #imageLiteral(resourceName: "down-arrow-ico")
                imgViewArrow.frame = CGRect(x: viewHeader.frame.size.width - 20, y: 17, width: 10, height: 6)
            } else {
                imgViewArrow.image = #imageLiteral(resourceName: "up-arrow-ico")
            }
            let lblHeaderTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tblBreakfast.bounds.size.width - 50, height: 50))
            
            lblHeaderTitle.textColor = UIColor.black
            lblHeaderTitle.text = cuisineMenu?.breakfast[section].cuisineName
            viewHeader.addSubview(lblHeaderTitle)
            
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
           
            viewHeaderMain.addGestureRecognizer(headerTapped)
            
            return viewHeaderMain
        }else if tableView == tblLunch {
            let viewHeaderMain = UIView(frame: CGRect(x: 0, y: 0, width: tblBreakfast.frame.size.width, height: 60))
            viewHeaderMain.backgroundColor = UIColor.clear
            
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: viewHeaderMain.frame.size.width, height: viewHeaderMain.frame.size.height - 10))
            let viewSeprator =  UIView(frame: CGRect(x: 0, y: viewHeader.frame.size.height-1, width: tblBreakfast.frame.size.width, height:1))
            viewSeprator.backgroundColor = Color.Seprator.lightDeviderColor
            viewHeader.addSubview(viewSeprator)
            viewHeaderMain.addSubview(viewHeader)
            viewHeaderMain.tag = section
            
            viewHeader.backgroundColor = UIColor.white
            
            let imgViewArrow = UIImageView(frame: CGRect(x: viewHeader.frame.size.width - 20, y: 20, width: 10, height: 6))
            viewHeader.addSubview(imgViewArrow)
            
            if (arrBoolLunch[section]){
                imgViewArrow.image = #imageLiteral(resourceName: "down-arrow-ico")
                imgViewArrow.frame = CGRect(x: viewHeader.frame.size.width - 20, y: 17, width: 10, height: 6)
            } else {
                imgViewArrow.image = #imageLiteral(resourceName: "up-arrow-ico")
            }
            let lblHeaderTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tblLunch.bounds.size.width - 50, height: 50))
            
            lblHeaderTitle.textColor = UIColor.black
            lblHeaderTitle.text = cuisineMenu?.lunch[section].cuisineName
            viewHeader.addSubview(lblHeaderTitle)
            
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
            
            viewHeaderMain.addGestureRecognizer(headerTapped)
            
            return viewHeaderMain
        }else if tableView == tblDinner {
            let viewHeaderMain = UIView(frame: CGRect(x: 0, y: 0, width: tblBreakfast.frame.size.width, height: 60))
            viewHeaderMain.backgroundColor = UIColor.clear
            
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: viewHeaderMain.frame.size.width, height: viewHeaderMain.frame.size.height - 10))
            let viewSeprator =  UIView(frame: CGRect(x: 0, y: viewHeader.frame.size.height-1, width: tblBreakfast.frame.size.width, height:1))
            viewSeprator.backgroundColor = UIColor.lightGray
            viewHeader.addSubview(viewSeprator)
            viewHeaderMain.addSubview(viewHeader)
            viewHeaderMain.tag = section
            
            viewHeader.backgroundColor = UIColor.white
            
            let imgViewArrow = UIImageView(frame: CGRect(x: viewHeader.frame.size.width - 20, y: 20, width: 10, height: 6))
            viewHeader.addSubview(imgViewArrow)
            
            if (arrBoolDinner[section]) {
                imgViewArrow.image = #imageLiteral(resourceName: "up-arrow-ico")
                imgViewArrow.frame = CGRect(x: viewHeader.frame.size.width - 20, y: 17, width: 10, height: 6)
            } else {
                imgViewArrow.image = #imageLiteral(resourceName: "down-arrow-ico")
            }
            let lblHeaderTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tblDinner.bounds.size.width - 50, height: 50))
            
            lblHeaderTitle.textColor = UIColor.black
            lblHeaderTitle.text = cuisineMenu?.dinner[section].cuisineName
            viewHeader.addSubview(lblHeaderTitle)
            
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
            
            viewHeaderMain.addGestureRecognizer(headerTapped)
            
            return viewHeaderMain
        }else {
            let viewHeaderMain = UIView(frame: CGRect(x: 0, y: 0, width: tblCustomization.frame.size.width, height: 60))
            viewHeaderMain.backgroundColor = UIColor.clear
            
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: viewHeaderMain.frame.size.width, height: viewHeaderMain.frame.size.height - 10))
            let viewSeprator =  UIView(frame: CGRect(x: 0, y: viewHeader.frame.size.height-1, width: tblCustomization.frame.size.width, height:1))
            viewSeprator.backgroundColor = UIColor.lightGray
            viewHeader.addSubview(viewSeprator)
            viewHeaderMain.addSubview(viewHeader)
            viewHeaderMain.tag = section
            
            viewHeader.backgroundColor = UIColor.white
            
            let imgViewArrow = UIImageView(frame: CGRect(x: viewHeader.frame.size.width - 20, y: 20, width: 10, height: 6))
            viewHeader.addSubview(imgViewArrow)
            
            if (arrBoolCustomization[section]) {
                imgViewArrow.image = #imageLiteral(resourceName: "up-arrow-ico")
                imgViewArrow.frame = CGRect(x: viewHeader.frame.size.width - 20, y: 17, width: 10, height: 6)
            } else {
                imgViewArrow.image = #imageLiteral(resourceName: "down-arrow-ico")
            }
            let lblHeaderTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tblCustomization.bounds.size.width - 50, height: 50))
            
            lblHeaderTitle.textColor = UIColor.black
            lblHeaderTitle.text = arrCustomization[section].customizationName
            viewHeader.addSubview(lblHeaderTitle)
            
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
            
            viewHeaderMain.addGestureRecognizer(headerTapped)
            
            return viewHeaderMain
        }
    }
    
    @objc func headerSectionTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
        
        if lblSeprator.frame.origin.x == btnBreakfast.frame.origin.x && viewCustomization.isHidden == true {
            let section = gestureRecognizer?.view!.tag
             var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
            selectedTagHeader = indexPath.section
            
            let collapsed: Bool = arrBoolBreakfast[section!]
            var sectionno: Int = 0
           // if section == 0 {
                for i in 0..<arrBoolBreakfast.count {
                    if (arrBoolBreakfast[i]) {
                        sectionno = i
                    }
                    arrBoolBreakfast[i] = false
                }
                if let list = cuisineMenu?.breakfast {
                    for i in 0..<list.count {
                        if section == i {
                            arrBoolBreakfast[section!] = !collapsed ? true : false
                        }
                    }
                }
              //  tblBreakfast.reloadSections(NSIndexSet(index: section!) as IndexSet, with: .automatic)
               // tblBreakfast.reloadSections(NSIndexSet(index: sectionno) as IndexSet, with: .automatic)
                tblBreakfast.reloadData()
           // }
        }else if lblSeprator.frame.origin.x == btnLunch.frame.origin.x && viewCustomization.isHidden == true {
            
            let section = gestureRecognizer?.view!.tag
             var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
            selectedTagHeader = indexPath.section
            let collapsed: Bool = arrBoolLunch[section!]
            var sectionno: Int = 0
           // if section == 0 {
                for i in 0..<arrBoolLunch.count {
                    if (arrBoolLunch[i]) {
                        sectionno = i
                    }
                    arrBoolLunch[i] = false
                }
                if let list = cuisineMenu?.lunch {
                    for i in 0..<list.count {
                        if section == i {
                            arrBoolLunch[section!] = !collapsed ? true : false
                        }
                    }
                }
                
              //  tblLunch.reloadSections(NSIndexSet(index: section!) as IndexSet, with: .automatic)
              //  tblLunch.reloadSections(NSIndexSet(index: sectionno) as IndexSet, with: .automatic)
                tblLunch.reloadData()
           // }
        }else if lblSeprator.frame.origin.x == btnDinner.frame.origin.x && viewCustomization.isHidden == true{
             var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
          let collapsed: Bool = arrBoolDinner[indexPath.section]
           selectedTagHeader = indexPath.section
            var sectionno: Int = 0
            if indexPath.row == 0 {
                
                for i in 0..<arrBoolDinner.count {
                    if (arrBoolDinner[i]) {
                        sectionno = i
                    }
                    arrBoolDinner[i] = false
                }
                if let list = cuisineMenu?.dinner {
                    for i in 0..<list.count {
                        if indexPath.section == i {
                            arrBoolDinner[indexPath.section] = !collapsed ? true : false
                        }
                    }
                }
               
                tblDinner.reloadData()
            }
        }else{
            var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
            let collapsed: Bool = arrBoolCustomization[indexPath.section]
            selectedTagCustom = indexPath.section
            var sectionno: Int = 0
      //      if indexPath.row == 0 {
                for i in 0..<arrBoolCustomization.count {
                    if (arrBoolCustomization[i]) == true {
                        sectionno = i
                    }
                    arrBoolCustomization[i] = false
                }
                for i in 0..<arrCustomization.count {
                    if indexPath.section == i {
                        arrBoolCustomization[indexPath.section] = !collapsed ? true : false
                    }
                }
                
            
                
                tblCustomization.reloadData()
                autoDynamicHeight()
         
    }
    }
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.customizeHeightConst.constant = self.tblCustomization.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
}

extension MenuListVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView == self.scrollView {
        selectedTagHeader = 0
        selectedTagCustom = 0
        self.viewPicker.isHidden = true
        if scrollView.contentOffset.x == self.viewBreakfast.frame.origin.x {
            lblSeprator.frame = CGRect(x: btnBreakfast.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnBreakfast.frame.size.width, height: lblSeprator.frame.size.height)
            
            if let filteredCustomReqList = self.cuisineMenu?.breakfast {
                arrBoolBreakfast = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.breakfast[i].cuisineName == self.selectedCuisin{
                        self.arrBoolBreakfast.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolBreakfast.append(false)
                    }
                }
            }
            
            tblBreakfast.reloadData()
        }else if scrollView.contentOffset.x == self.viewLunch.frame.origin.x {
            lblSeprator.frame = CGRect(x: btnLunch.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnLunch.frame.size.width, height: lblSeprator.frame.size.height)
            
            if let filteredCustomReqList = self.cuisineMenu?.lunch {
                arrBoolLunch = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.lunch[i].cuisineName == self.selectedCuisin{
                        self.arrBoolLunch.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolLunch.append(false)
                    }
                }
            }
            
            tblLunch.reloadData()
        }else if scrollView.contentOffset.x == self.viewDinner.frame.origin.x{
            lblSeprator.frame = CGRect(x: btnDinner.frame.origin.x, y: lblSeprator.frame.origin.y, width: btnDinner.frame.size.width, height: lblSeprator.frame.size.height)
            if let filteredCustomReqList = self.cuisineMenu?.dinner {
                arrBoolDinner = [Bool]()
                for i in 0..<filteredCustomReqList.count {
                    if self.cuisineMenu?.dinner[i].cuisineName == self.selectedCuisin{
                        self.arrBoolDinner.append(true)
                        self.selectedTagHeader = i
                        
                    }else{
                        self.arrBoolDinner.append(false)
                    }
                }
            }
            tblDinner.reloadData()
        }
        
        //self.callGetMenuListAPI()
    }
    }
}
