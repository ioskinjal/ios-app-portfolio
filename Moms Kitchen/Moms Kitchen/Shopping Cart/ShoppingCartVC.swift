//
//  ShoppingCartVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 30/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
//import SystemConfiguration


class ShoppingCartVC: BaseViewController,PGTransactionDelegate {

    static var storyboardInstance:ShoppingCartVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ShoppingCartVC.identifier) as? ShoppingCartVC
    }
    var arrSection : NSMutableArray = []
    //var data:PlaceOrder?
    var qty:Int = 1
    var selectedIndex : Int = -1
    var selectedTagHeader : Int = 0
    var selectedTagCustom:Int = 0
    var addressData:AddressData?
    var cartData : CustomizationList?
    var array = [AddressList]()
    var arrAddressList:[AddressList] = []
    var itemIdForDate:String?
    var cartItemIdForDate:String?
    var itemArray : NSMutableArray = []
    var strDeliveryDate:String?
    var isAddressSelcted:Bool = false
    var selectedTag: Int = -1
    var arrCustomization = [CustomizationList]()
     var arrItemSelected:NSMutableArray = []
    var arrBoolCustomization: [Bool] = []
    var cart:CartData?
    var order_id:String = ""
    var cartCount:Int = 0
    let SectionHeaderHeight: CGFloat = 40
    @IBOutlet weak var lblHeadCustomization: UILabel!
    @IBOutlet weak var viewBlank: UIView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var tblCustHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblCustomization: UITableView!{
        didSet{
            tblCustomization.register(CustomizationCell.nib, forCellReuseIdentifier: CustomizationCell.identifier)
            tblCustomization.register(selectAddressCell.nib, forCellReuseIdentifier: selectAddressCell.identifier)
            tblCustomization.dataSource = self
            tblCustomization.delegate = self
            tblCustomization.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var viewCustomization: UIView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblTotalPriceOrder: UILabel!
    @IBOutlet weak var lblCGSTHead: UILabel!
    
    @IBOutlet weak var lblSGSTHead: UILabel!
    @IBOutlet weak var lblTotalAmmount: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var viewAddress: UIStackView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewTotalAmmount: UIView!{
        didSet{
            self.viewTotalAmmount.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
            //            let rectShape = CAShapeLayer()
            //            rectShape.bounds = self.viewTotalAmmount.frame
            //            rectShape.position = self.viewTotalAmmount.center
            //            rectShape.path = UIBezierPath(roundedRect: self.viewTotalAmmount.bounds, byRoundingCorners: [ .bottomRight , .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
            //            //Here I'm masking the textView's layer with rectShape layer
            //            self.viewTotalAmmount.layer.mask = rectShape
        }
    }
    @IBOutlet weak var viewSgst: UIView!{
        didSet{
            self.viewSgst.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewCgst: UIView!{
        didSet{
            self.viewCgst.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var viewTotalPrice: UIView!{
        didSet{
            self.viewTotalPrice.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
            //            let rectShape = CAShapeLayer()
            //            rectShape.bounds = self.viewTotalPrice.frame
            //            rectShape.position = self.viewTotalPrice.center
            //            rectShape.path = UIBezierPath(roundedRect: self.viewTotalPrice.bounds, byRoundingCorners: [ .topRight , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
            //            //Here I'm masking the textView's layer with rectShape layer
            //            self.viewTotalPrice.layer.mask = rectShape
        }
    }
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var tblOrders: UITableView!{
        didSet{
            tblOrders.register(CartCell.nib, forCellReuseIdentifier: CartCell.identifier)
            tblOrders.dataSource = self
            tblOrders.delegate = self
            tblOrders.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Shopping Cart", action: #selector(onClickMenu(_:)), isRightBtn: false)
        navigationBar.viewCart.isHidden = true
        navigationBar.btnCart.isHidden = true
        picker.datePickerMode = UIDatePickerMode.date
        picker.addTarget(self, action: #selector(dueDateChanged(_:)), for: UIControlEvents.valueChanged)
       
        arrSection = ["BREAKFAST","LUNCH","DINNER"]
        autoDynamicHeight()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        strDeliveryDate = dateFormatter.string(from: date)
    }
    
    func callGetUserAddressAPI() {
        isAddressSelcted = true
        let param = ["uid":UserData.shared.getUser()!.user_id]
        Modal.shared.getUserAddress(vc: self, param: param) { (dic) in
            print(dic)
            
            
            self.arrAddressList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({AddressList(dic: $0 as! [String:Any])})
           // if self.arrAddressList.count == 0{
               // self.viewNoData.isHidden = false
                
          //  }else{
           if self.arrAddressList.count != 0 {
            self.arrBoolCustomization = [Bool]()
            for _ in self.arrAddressList {
                self.arrBoolCustomization.append(false)
            }
                self.tblCustomization.reloadData()
            self.lblHeadCustomization.text = "Select Address"
            self.viewCustomization.isHidden = false
            self.autoDynamicHeight()
            }
           // }
        }
        
        
    }
    func callGetCartDetail() {
        self.itemArray = NSMutableArray()
        let user = UserData.shared.getUser()
        var param = [String:Any]()
        if user != nil {
             param = ["uid":UserData.shared.getUser()!.user_id]
        }else{
            param = ["token_id":UserData.shared.deviceToken]
        }
        
        Modal.shared.getCart(vc: self, param: param) { (dic) in
            self.viewBlank.isHidden = true
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            let menu = CartData(data: data)
            if menu.dinner.count == 0 && menu.lunch.count == 0 && menu.breakfast.count == 0 {
                self.viewNoData.isHidden = false
            }else{
                self.viewBlank.isHidden = true
               self.viewNoData.isHidden = true
            }
            self.cart = menu
            
            self.autoDynamicHeight()
            if UserDefaults.standard.value(forKey: "cartCount") != nil {
                self.cartCount = self.cart!.cart_items_count
            }
            UserDefaults.standard.set(self.cartCount, forKey: "cartCount")
            UserDefaults.standard.synchronize()
            self.lblTotalPriceOrder.text = String(format: "Rs %.2f", self.cart!.total_order_price)
            self.lblCGST.text = String(format: "Rs %.1f", self.cart!.cgst_charge)
            self.lblSGST.text = String(format: "Rs %.1f", self.cart!.sgst_charge)
            self.lblTotalAmmount.text = String(format: "Rs %.2f", self.cart!.total_price)
            
             self.lblCGSTHead.text = String(format: "CGST(%.0f%%)", self.cart!.cgst_percentage)
            self.lblSGSTHead.text = String(format: "SGST(%.0f%%)", self.cart!.sgst_percentage)
//            self.cart?.breakfast[0].customizationList[0].customizationItemList[0].customizationItemID
            if self.cart?.breakfast.count != 0 {
                self.tblOrders.reloadData()
                if let listItem = self.cart?.breakfast{
                    for k in 0..<listItem.count{
                        if self.cart?.breakfast[k].isItemCustomizable == true{
                            if let list = self.cart?.breakfast[k].customizationList {
                                for i in 0..<list.count {
                                    var list1 = [CustomizationList]()
                                    list1.append((self.cart?.breakfast[k].customizationList[i])!)
                                    
                                    for j in 0..<list1.count {
                                        var dict = Dictionary<String, Any>()
                                        let strId = self.cart?.breakfast[k].customizationList[i].customizationItemList[j].customizationItemID
                                        if self.cart?.breakfast[k].customizationList[i].customizationItemList[j].is_checked == true{
                                            self.arrItemSelected.add(self.cart!.breakfast[k].customizationList[i].customizationItemList[j].customizationItemID)
                                            self.cart?.breakfast[k].customizationList[i].customizationItemList[j].isSelected = true
                                            
                                        }
                                        let strQty = self.cart?.breakfast[k].qty
                                        dict["id"] = strId
                                        dict["qty"] = strQty
                                        dict["date"] = self.cart?.breakfast[k].delivery_date
                                        
                                        self.itemArray.add(dict)
                                    }
                                    
                                }
                                
                            }
                        }else{
                            var dict = Dictionary<String, Any>()
                            dict["id"] = self.cart?.breakfast[k].itemID
                            dict["qty"] = self.cart?.breakfast[k].qty
                            dict["date"] = self.cart?.breakfast[k].delivery_date
                            self.itemArray.add(dict)
                        }
                        
                    }
                }
                print(self.itemArray)
            }
            
            if self.cart?.lunch.count != 0 {
                self.tblOrders.reloadData()
                if let listItem = self.cart?.lunch{
                    for k in 0..<listItem.count{
                        if self.cart?.lunch[k].isItemCustomizable == true{
                            if let list = self.cart?.lunch[k].customizationList {
                                for i in 0..<list.count {
                                    var list1 = [CustomizationList]()
                                    list1.append((self.cart?.lunch[k].customizationList[i])!)
                                    
                                    for j in 0..<list1.count {
                                        var dict = Dictionary<String, Any>()
                                        let strId = self.cart?.lunch[k].customizationList[i].customizationItemList[j].customizationItemID
                                        if self.cart?.lunch[k].customizationList[i].customizationItemList[j].is_checked == true{
                                            self.arrItemSelected.add(self.cart!.lunch[k].customizationList[i].customizationItemList[j].customizationItemID)
                                            self.cart?.lunch[k].customizationList[i].customizationItemList[j].isSelected = true
                                            
                                        }
                                        let strQty = self.cart?.lunch[k].qty
                                        dict["id"] = strId
                                        dict["qty"] = strQty
                                        dict["date"] = self.cart?.lunch[k].delivery_date
                                        
                                        self.itemArray.add(dict)
                                    }
                                    
                                }
                                
                            }
                        }else{
                            var dict = Dictionary<String, Any>()
                            dict["id"] = self.cart?.lunch[k].itemID
                            dict["qty"] = self.cart?.lunch[k].qty
                            dict["date"] = self.cart?.lunch[k].delivery_date
                            self.itemArray.add(dict)
                        }
                        
                    }
                }
                print(self.itemArray)
            }
            
            if self.cart?.dinner.count != 0 {
                self.tblOrders.reloadData()
                if let listItem = self.cart?.dinner{
                    for k in 0..<listItem.count{
                        if self.cart?.dinner[k].isItemCustomizable == true{
                if let list = self.cart?.dinner[k].customizationList {
                    for i in 0..<list.count {
                        var list1 = [CustomizationList]()
                        list1.append((self.cart?.dinner[k].customizationList[i])!)
                       
                            for j in 0..<list1.count {
                        var dict = Dictionary<String, Any>()
                                let strId = self.cart?.dinner[k].customizationList[i].customizationItemList[j].customizationItemID
                                if self.cart?.dinner[k].customizationList[i].customizationItemList[j].is_checked == true{
                                    self.arrItemSelected.add(self.cart!.dinner[k].customizationList[i].customizationItemList[j].customizationItemID)
                                    self.cart?.dinner[k].customizationList[i].customizationItemList[j].isSelected = true
                                    
                                }
                        let strQty = self.cart?.dinner[k].qty
                        dict["id"] = strId
                        dict["qty"] = strQty
                        dict["date"] = self.cart?.dinner[k].delivery_date
                    
                        self.itemArray.add(dict)
                            }
                    
                    }
                    
                    }
                        }else{
                            var dict = Dictionary<String, Any>()
                            dict["id"] = self.cart?.dinner[k].itemID
                            dict["qty"] = self.cart?.dinner[k].qty
                            dict["date"] = self.cart?.dinner[k].delivery_date
                            self.itemArray.add(dict)
                        }
                    
                }
                }
                print(self.itemArray)
            }
        }
//        if cart?.dinner == nil && cart?.lunch == nil && cart?.breakfast == nil {
//            self.viewNoData.isHidden = false
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if strAddressID != nil{
            callViewAddressAPI()
        }else{
            viewAddress.isHidden = true
        }
        self.callGetCartDetail()
    }
    
    func callViewAddressAPI(){
        let param = ["address_id":strAddressID!]
        Modal.shared.viewAddress(vc: self, param: param) { (dic) in
            print(dic)
             self.addressData = AddressData(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.viewAddress.isHidden = false
//            self.addressData?.area_name + "," + self.addressData.area_nick_name + "," + self.addressData.address_line1 + "," +
//                self.addressData?.address_line2 + "," + self.addressData.address_line3 + "," + self.addressData.pincode
            self.lblAddress.text = (self.addressData?.area_name)! + "," + (self.addressData?.area_nick_name)! + "," + (self.addressData?.address_line1)! + "," + (self.addressData?.address_line2)! + "," + (self.addressData?.address_line3)! + "," + (self.addressData?.pincode)!
            self.lblAddress.sizeToFit()
            strAddressID = nil
         }
    }
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.heightConst.constant = self.tblOrders.contentSize.height
            self.tblCustHeightConst.constant = self.tblCustomization.contentSize.height
            self.view.layoutIfNeeded()
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
    
    @IBAction func onClickSelectAddress(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user != nil {
             callGetUserAddressAPI()
        }else{
                let presentVc = LoginVC.storyboardInstance!
                isFromSideMenu = true
                self.navigationController?.pushViewController(presentVc, animated: true)
            }
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewPicker.isHidden = true
    }
    @IBAction func onClickDone(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        var param = [String:String]()
        if user != nil {
            param = ["uid":UserData.shared.getUser()!.user_id,
                     "item_id":itemIdForDate,
                     "cart_item_id":cartItemIdForDate,
                     "date":strDeliveryDate] as! [String : String]
        }else{
            param = ["token_id":UserData.shared.deviceToken,
                     "item_id":itemIdForDate,
                     "cart_item_id":cartItemIdForDate,
                     "date":strDeliveryDate] as! [String : String]
        }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.callGetCartDetail()
            })
        }
        viewPicker.isHidden = true
    }
    @IBAction func onClickClose(_ sender: UIButton) {
         self.navigationBar.isHidden = false
        viewCustomization.isHidden = true
    }
    @IBAction func onClickUpdate(_ sender: Any) {
        if isAddressSelcted{
            if strAddressID == nil {
                self.lblAddress.text =  self.arrAddressList[0].address_line1 + "," +
                    self.arrAddressList[0].address_line2 + "," +
                    self.arrAddressList[0].address_line3 + "," +
                    self.arrAddressList[0].landmark + "," +
                    self.arrAddressList[0].area_name +  "," +
                    self.arrAddressList[0].city + "-" +
                    self.arrAddressList[0].pincode + "," +
                    self.arrAddressList[0].state + "," + "India"
                strAddressID = arrAddressList[0].id
                self.viewAddress.isHidden = false
            }
            self.alert(title: "", message: "Address selected", completion: {
                self.viewCustomization.isHidden = true
               
            })
        }else{
        let user = UserData.shared.getUser()
        
          let strCustomId = arrItemSelected.componentsJoined(by: ",")
        var param =  [String:Any]()
        if selectedTag == 0 {
            if user != nil{
         param = ["uid":UserData.shared.getUser()!.user_id,
                     "cart_item_id":cart!.breakfast[selectedIndex].cartItemId,
                     "quantity":qty,
                     "customization_item_id":strCustomId,
                    ] as [String : Any]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.breakfast[selectedIndex].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId,
                         ] as [String : Any]
            }
        }else if selectedTag == 1{
            if user != nil{
                param = ["uid":UserData.shared.getUser()!.user_id,
                         "cart_item_id":cart!.lunch[selectedIndex].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId,
                         ] as [String : Any]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.lunch[selectedIndex].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId,
                         ] as [String : Any]
            }
        }else{
            if user != nil{
                param = ["uid":UserData.shared.getUser()!.user_id,
                         "cart_item_id":cart!.dinner[selectedIndex].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId,
                         ] as [String : Any]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.dinner[selectedIndex].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId,
                         ] as [String : Any]
            }
        }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            print(dic)
            // let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            // self.alert(title: "", message: str, completion: {
            //   self.dismiss(animated: true, completion: nil)
             self.navigationBar.isHidden = false
            self.viewCustomization.isHidden = true
            self.callGetCartDetail()
            // })
        }
        }
    }
    @IBAction func onClickPlaceOrder(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user == nil {
            let presentVc = LoginVC.storyboardInstance!
            isFromSideMenu = true
            self.navigationController?.pushViewController(presentVc, animated: true)
        }else{
        if strAddressID != nil {
            if cart!.payable_paytm_amt != 0.0 && cart?.credits != 0.0 {
                let str = String(format: "Rs %.2f will be taken from your credits and Rs %.2f will be taken from your paytm", (self.cart?.credits)!,(self.cart?.payable_paytm_amt)!)
                self.alert(title: "", message: str, completion: {
                    self.callPlaceOrderAPI(isOpenPaytm: true)
                })
            
            }else if cart!.payable_paytm_amt == 0.0 && cart?.credits != 0.0 {
                let str = String(format: "Rs %.2f will be taken from your credits", (self.cart?.credits)!,(self.cart?.credits)!)
                self.alert(title: "", message: str, completion: {
                    self.callPlaceOrderAPI(isOpenPaytm: false)
                })
                
            }
            else{
                let str = String(format: "Rs %.2f will be taken from your paytm",(self.cart?.payable_paytm_amt)!)
                self.alert(title: "", message: str, completion: {
                    self.callPlaceOrderAPI(isOpenPaytm: true)
                })
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "please select delivery address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func didFinishedResponse(_ controller: PGTransactionViewController!, response responseString: String!) {
        print(responseString)
        
        
        let dict = convertToDictionary(text: responseString)
        print(dict)
//        let arrRes:NSArray = responseString.components(separatedBy: ",") as NSArray
//        let arrayFinal:NSMutableArray = []
//         arrayFinal.addObjects(from: arrRes as! [Any])
//        var str:String = arrayFinal[0] as! String
//        var arraySep:NSArray  = str.components(separatedBy: "\"") as NSArray
//         arraySep = str.components(separatedBy: ":") as NSArray
//        str = arraySep[1] as! String
//        var str1:String = arrayFinal[2] as! String
//         arraySep = str1.components(separatedBy: "\"") as NSArray
//        arraySep = str1.components(separatedBy: ":") as NSArray
//        str1 = arraySep[1] as! String
//        str1 = str.digitsOnly()
//        var str2:String = arrayFinal[3] as! String
//        arraySep = str2.components(separatedBy: "\"") as NSArray
//        arraySep = str2.components(separatedBy: ":") as NSArray
//        str2 = arraySep[1] as! String
//       str2 = str2.digitsOnly()
        let param = ["uid":UserData.shared.getUser()!.user_id,
                     "ORDER_ID":order_id,
                     "TXN_ID":dict!["TXNID"]!,
                     "amount_paid":dict!["TXNAMOUNT"]!,
                     "response_arr":responseString!,
                     "credits":cart!.credits,
                     "payable_paytm_amt":cart!.payable_paytm_amt] as [String : Any]
        Modal.shared.completePayment(vc: self, param: param) { (dic) in
            print(dic)
           
                self.dismiss(animated: true, completion: nil)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                let nextVC = MyOrderVC.storyboardInstance!
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
           
        }
        self.present(controller, animated: true)
    }
    
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        print("CANCELLED")
    }
    
    func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        print("Parameter is missing %@", error?.localizedDescription as Any)
        controller.navigationController?.popViewController(animated: true)
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
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
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    func callPlaceOrderAPI(isOpenPaytm:Bool) {
        let jsonStringPretty = JSONStringify(value: self.itemArray, prettyPrinted: true)
        print(jsonStringPretty)
        var strParam:NSString = jsonStringPretty as NSString
        strParam = strParam.replacingOccurrences(of: "\\", with: "") as NSString
        print(strParam)
        order_id = randomStringWithLength(len: 10) as String
        let param = ["uid":UserData.shared.getUser()!.user_id,
                     "items":strParam,
                     "address_id":strAddressID!,
                     "ORDER_ID":order_id] as [String : Any]
        Modal.shared.placeOrder(vc: self, param: param) { (dic) in
            print(dic)
            //self.data = PlaceOrder(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            if isOpenPaytm == true {
            let defaultConfig = PGMerchantConfiguration.default
            defaultConfig().checksumGenerationURL = String(format: "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=%@", self.order_id)
            defaultConfig().checksumValidationURL = String(format: "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=%@", self.order_id)
                
            let param = ["MID":"KisanK34439848409137",
                         "ORDER_ID":self.order_id,
                "CUST_ID":UserData.shared.getUser()!.user_id,
                "INDUSTRY_TYPE_ID":"Retail",
                "CHANNEL_ID":"WAP",
                "TXN_AMOUNT":String(format: "%.2f", self.cart!.payable_paytm_amt),
                "WEBSITE":"APPSTAGING",
                "CALLBACK_URL": String(format: "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=%@", self.order_id)] as [String : Any]
            Modal.shared.checkSum(vc: self, param: param, success: { (dic) in
                print(dic)
              let data = CheckSum(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
                var orderDict = [String : Any]()
                orderDict["MID"] = "KisanK34439848409137";
                orderDict["ORDER_ID"] = self.order_id
                orderDict["CUST_ID"] = UserData.shared.getUser()!.user_id;
                orderDict["INDUSTRY_TYPE_ID"] = "Retail";
                orderDict["CHANNEL_ID"] = "WAP";
                orderDict["TXN_AMOUNT"] = String(format: "%.2f", self.cart!.payable_paytm_amt);
                orderDict["WEBSITE"] = "APPSTAGING";
                orderDict["CALLBACK_URL"] = String(format: "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=%@", self.order_id);
                orderDict["CHECKSUMHASH"] = data.CHECKSUMHASH;
                
                let mc = defaultConfig
                let pgOrder = PGOrder(params: orderDict )
                let transaction = PGTransactionViewController.init(transactionFor: pgOrder)
                transaction!.serverType = eServerTypeStaging
                transaction!.merchant = mc()
                transaction!.loggingEnabled = true
                transaction!.delegate = self
                self.present(transaction!, animated: true)
            })
            }else{
                let param = ["uid":UserData.shared.getUser()!.user_id,
                             "ORDER_ID":self.order_id,
                             "TXN_ID":"",
                             "amount_paid":self.cart!.total_price,
                             "response_arr":"",
                             "credits":self.cart!.credits,
                             "payable_paytm_amt":self.cart!.payable_paytm_amt] as [String : Any]
                Modal.shared.completePayment(vc: self, param: param) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                     self.alert(title: "", message: str, completion: {
                        let nextVC = MyOrderVC.storyboardInstance!
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    })
                    
                }
                
                
            }
           
        }
    }
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user != nil {
        
        let nextVC = AddNewAddressVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let presentVc = LoginVC.storyboardInstance!
            isFromSideMenu = true
            self.navigationController?.pushViewController(presentVc, animated: true)
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

extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == tblOrders {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier) as? CartCell else {
                fatalError("Cell can't be dequeue")
            }
            
        if indexPath.section == 0{
            cell.btnCart.tag = indexPath.row
            cell.btnCart.addTarget(self, action: #selector(onClickAddToCart1(_:)), for: .touchUpInside)
           // selectedTag = 0
        cell.imgFood.layer.cornerRadius = 5
        cell.imgFood.downLoadImage(url: cart!.breakfast[indexPath.row].itemImage)
        cell.lblFoodName.text = cart!.breakfast[indexPath.row].itemName
        cell.lblPrice.text = "Rs " + cart!.breakfast[indexPath.row].itemPrice
        cell.imgFood.layer.masksToBounds = true
        cell.btnMinus.tag = indexPath.row
            
        cell.btnPlus.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEditDate), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(onClickMinus(_:)), for: .touchUpInside)
        cell.btnPlus.addTarget(self, action: #selector(onClickPlus(_:)), for: .touchUpInside)
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: (cart?.breakfast[indexPath.row].delivery_date)!)
            inputFormatter.dateFormat = "dd MMM yy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            cell.lblDate.text = resultString
        cell.lblQty.text =  cart!.breakfast[indexPath.row].qty
        
            if cart?.breakfast[indexPath.row].isItemCustomizable == true {
                
                cell.viewCustomization.isHidden = false
                if let list = cart?.breakfast[indexPath.row].customizationList {
                    cell.lblCustomization.text = ""
                    for i in 0..<list.count {
                        if let list1 = cart?.breakfast[indexPath.row].customizationList[i].customizationItemList {
                            for j in 0..<list1.count {
                                if cart?.breakfast[indexPath.row].customizationList[i].customizationItemList[j].is_checked == true {
                                    if cell.lblCustomization.text == "Customization Available"{
                                        cell.lblCustomization.text = ""
                                    }
                                    if cell.lblCustomization.text == ""{
                                        cell.lblCustomization.text = cart!.breakfast[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName
                                    }else{
                                        cell.lblCustomization.text = String(format: "%@,%@", cell.lblCustomization.text!,(cart?.breakfast[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName)!)
                                    }
                                }
                            }
                        }
                        else{
                            cell.lblCustomization.text = "Customization Available"
                        }
                    }
                }
                
                
            }else{
                
                cell.viewCustomization.isHidden = true
            }
        }else if indexPath.section == 1{
            cell.btnCart.tag = indexPath.row
            cell.btnCart.addTarget(self, action: #selector(onClickAddToCart2(_:)), for: .touchUpInside)
            //selectedTag = 1
            cell.imgFood.layer.cornerRadius = 5
            cell.imgFood.downLoadImage(url: cart!.lunch[indexPath.row].itemImage)
            cell.lblFoodName.text = cart!.lunch[indexPath.row].itemName
            cell.lblPrice.text = "Rs " + cart!.lunch[indexPath.row].itemPrice
            cell.imgFood.layer.masksToBounds = true
            cell.btnMinus.tag = indexPath.row
            cell.btnPlus.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEditDate2), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete2(_:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(onClickMinus1(_:)), for: .touchUpInside)
            cell.btnPlus.addTarget(self, action: #selector(onClickPlus1(_:)), for: .touchUpInside)
            cell.lblQty.text = cart!.lunch[indexPath.row].qty
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: (cart?.lunch[indexPath.row].delivery_date)!)
            inputFormatter.dateFormat = "dd MMM yy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            cell.lblDate.text = resultString
            if cart?.lunch[indexPath.row].isItemCustomizable == true {
                
                cell.viewCustomization.isHidden = false
                if let list = cart?.lunch[indexPath.row].customizationList {
                    cell.lblCustomization.text = ""
                    for i in 0..<list.count {
                        if let list1 = cart?.lunch[indexPath.row].customizationList[i].customizationItemList {
                            for j in 0..<list1.count {
                                if cart?.lunch[indexPath.row].customizationList[i].customizationItemList[j].is_checked == true {
                                    if cell.lblCustomization.text == "Customization Available"{
                                        cell.lblCustomization.text = ""
                                    }
                                    if cell.lblCustomization.text == ""{
                                        cell.lblCustomization.text = cart!.lunch[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName
                                    }else{
                                        cell.lblCustomization.text = String(format: "%@,%@", cell.lblCustomization.text!,(cart?.lunch[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName)!)
                                    }
                                }
                            }
                        }
                        else{
                            cell.lblCustomization.text = "Customization Available"
                        }
                    }
                }
                
                
            }else{
                
                cell.viewCustomization.isHidden = true
            }
        }else if indexPath.section == 2{
            cell.btnCart.tag = indexPath.row
            cell.btnCart.addTarget(self, action: #selector(onClickAddToCart3(_:)), for: .touchUpInside)
            //selectedTag = 2
            cell.imgFood.layer.cornerRadius = 5
            cell.imgFood.downLoadImage(url: cart!.dinner[indexPath.row].itemImage)
            cell.lblFoodName.text = cart!.dinner[indexPath.row].itemName
            cell.lblPrice.text = "Rs " + cart!.dinner[indexPath.row].itemPrice
            cell.imgFood.layer.masksToBounds = true
            cell.btnMinus.tag = indexPath.row
            cell.btnPlus.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEditDate3), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete3(_:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(onClickMinus2(_:)), for: .touchUpInside)
            cell.btnPlus.addTarget(self, action: #selector(onClickPlus2(_:)), for: .touchUpInside)
            cell.lblQty.text = cart!.dinner[indexPath.row].qty
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: (cart?.dinner[indexPath.row].delivery_date)!)
            inputFormatter.dateFormat = "dd MMM yy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            cell.lblDate.text = resultString
            if cart?.dinner[indexPath.row].isItemCustomizable == true {
                
                cell.viewCustomization.isHidden = false
                if let list = cart?.dinner[indexPath.row].customizationList {
                    cell.lblCustomization.text = ""
                    for i in 0..<list.count {
                        if let list1 = cart?.dinner[indexPath.row].customizationList[i].customizationItemList {
                            for j in 0..<list1.count {
                                if cart?.dinner[indexPath.row].customizationList[i].customizationItemList[j].is_checked == true {
                                    if cell.lblCustomization.text == "Customization Available"{
                                        cell.lblCustomization.text = ""
                                    }
                                    if cell.lblCustomization.text == ""{
                                        cell.lblCustomization.text = cart!.dinner[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName
                                    }else{
                                        cell.lblCustomization.text = String(format: "%@,%@", cell.lblCustomization.text!,(cart?.dinner[indexPath.row].customizationList[i].customizationItemList[j].customizationItemName)!)
                                    }
                                }
                            }
                        }
                                else{
                                    cell.lblCustomization.text = "Customization Available"
                                }
                        }
                }
                
                
            }else{
                
                cell.viewCustomization.isHidden = true
            }
        }
        
        return cell
        }else{
            if isAddressSelcted == true{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: selectAddressCell.identifier) as? selectAddressCell else {
                    fatalError("Cell can't be dequeue")
                }
                
                cell.lbladdress.text =  array[indexPath.row].address_line1 + "," +
                    array[indexPath.row].address_line2 + "," +
                    array[indexPath.row].address_line3 + "," +
                    array[indexPath.row].landmark + "," +
                    array[indexPath.row].area_name +  "," +
                    array[indexPath.row].city + "-" +
                    array[indexPath.row].pincode + "," +
                    array[indexPath.row].state + "," + "India"
                
                
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
                
            }else if arrCustomization[indexPath.section].customizationType == "4" || arrCustomization[indexPath.section].customizationType == "1" {
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
    }
    
    @objc func dueDateChanged(_ sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        strDeliveryDate = dateFormatter.string(from: sender.date)
        
       
    }
    @objc func onClickEditDate(_ sender:UIButton){
        let currentDate = NSDate()
        let calendar = Calendar.init(identifier: .gregorian)
        let dateComponents = NSDateComponents()
        dateComponents.day = 6
        dateComponents.hour = 6
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
        picker.maximumDate = maxDate
        itemIdForDate = cart!.breakfast[sender.tag].itemID
        cartItemIdForDate = cart!.breakfast[sender.tag].cartItemId
        viewPicker.isHidden = false
    }
    
    @objc func onClickEditDate2(_ sender:UIButton){
        picker.minimumDate = Date()
        let currentDate = NSDate()
        let calendar = Calendar.init(identifier: .gregorian)
        let dateComponents = NSDateComponents()
        dateComponents.day = 6
        dateComponents.hour = 11
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
        picker.maximumDate = maxDate
        itemIdForDate = cart!.lunch[sender.tag].itemID
        cartItemIdForDate = cart!.lunch[sender.tag].cartItemId
        viewPicker.isHidden = false
    }
    
    @objc func onClickEditDate3(_ sender:UIButton){
        picker.minimumDate = Date()
        let currentDate = NSDate()
        let calendar = Calendar.init(identifier: .gregorian)
        let dateComponents = NSDateComponents()
        dateComponents.day = 6
        dateComponents.hour = 19
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
        picker.maximumDate = maxDate
        itemIdForDate = cart!.dinner[sender.tag].itemID
        cartItemIdForDate = cart!.dinner[sender.tag].cartItemId
        viewPicker.isHidden = false
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
                    let _:Int = arrCustomization[selectedTagCustom].customizationItemList.count
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
    
    @objc func onClickAddToCart1(_ sender:UIButton) {
        isAddressSelcted = false
        selectedTag = 0
        selectedIndex = sender.tag
        arrCustomization = [CustomizationList]()
        arrItemSelected = NSMutableArray()
        //        var list:[RecommendedList] = []
        //        list.append(arrRecommendationList[sender.tag])
        //        for i in 0..<list.count {
        qty = Int((self.cart?.breakfast[sender.tag].qty)!)!
            self.arrCustomization = (self.cart?.breakfast[sender.tag].customizationList)!
        for i in 0..<arrCustomization.count{
            for j in 0..<arrCustomization[i].customizationItemList.count{
            if arrCustomization[i].customizationItemList[j].is_checked == true{
                self.arrCustomization[i].customizationItemList[j].isSelected = true
            }else{
                self.arrCustomization[i].customizationItemList[j].isSelected = false
            }
            }
        }
        
        // }
        for _ in self.arrCustomization {
            
            self.arrBoolCustomization.append(false)
        }
      //  selectedTag = sender.tag
         self.navigationBar.isHidden = true
        self.lblHeadCustomization.text = "Select Customization"
        viewCustomization.isHidden = false
        isFromMenu = true
        tblCustomization.reloadData()
        autoDynamicHeight()
    }
    
    @objc func onClickAddToCart2(_ sender:UIButton) {
        isAddressSelcted = false
        selectedTag = 1
        selectedIndex = sender.tag
        arrCustomization = [CustomizationList]()
        arrItemSelected = NSMutableArray()
        //        var list:[RecommendedList] = []
        //        list.append(arrRecommendationList[sender.tag])
        //        for i in 0..<list.count {
        qty = Int((self.cart?.lunch[sender.tag].qty)!)!
        self.arrCustomization = (self.cart?.lunch[sender.tag].customizationList)!
         self.arrCustomization[0].customizationItemList[0].isSelected = true
        print(arrCustomization)
        // }
        for i in 0..<arrCustomization.count{
            for j in 0..<arrCustomization[i].customizationItemList.count{
                if arrCustomization[i].customizationItemList[j].is_checked == true{
                    self.arrCustomization[i].customizationItemList[j].isSelected = true
                }else{
                    self.arrCustomization[i].customizationItemList[j].isSelected = false
                }
            }
        }
        for _ in self.arrCustomization {
            self.arrBoolCustomization.append(false)
        }
        //selectedTag = sender.tag
         self.navigationBar.isHidden = true
        self.lblHeadCustomization.text = "Select Customization"
        viewCustomization.isHidden = false
        isFromMenu = true
        tblCustomization.reloadData()
        autoDynamicHeight()
    }
    
    @objc func onClickAddToCart3(_ sender:UIButton) {
        isAddressSelcted = false
        selectedTag = 2
        selectedIndex = sender.tag
        arrCustomization = [CustomizationList]()
        arrItemSelected = NSMutableArray()
        //        var list:[RecommendedList] = []
        //        list.append(arrRecommendationList[sender.tag])
        //        for i in 0..<list.count {
        qty = Int((self.cart?.dinner[sender.tag].qty)!)!
        self.arrCustomization = (self.cart?.dinner[sender.tag].customizationList)!
         self.arrCustomization[0].customizationItemList[0].isSelected = true
        // }
        for i in 0..<arrCustomization.count{
            for j in 0..<arrCustomization[i].customizationItemList.count{
                if arrCustomization[i].customizationItemList[j].is_checked == true{
                    self.arrCustomization[i].customizationItemList[j].isSelected = true
                }else{
                    self.arrCustomization[i].customizationItemList[j].isSelected = false
                }
            }
        }
        for _ in self.arrCustomization {
            self.arrBoolCustomization.append(false)
        }
       // selectedTag = sender.tag
         self.navigationBar.isHidden = true
        self.lblHeadCustomization.text = "Select Customization"
        viewCustomization.isHidden = false
        isFromMenu = true
        tblCustomization.reloadData()
        autoDynamicHeight()
    }
    @objc func onClickDelete(_ sender:UIButton){
        let user = UserData.shared.getUser()
        var param = [String:String]()
        if user != nil {
        param = ["uid":UserData.shared.getUser()!.user_id, "item_id":cart!.breakfast[sender.tag].itemID,"cart_item_id":cart!.breakfast[sender.tag].cartItemId]
        }else{
            param = ["token_id":UserData.shared.deviceToken, "item_id":cart!.breakfast[sender.tag].itemID,"cart_item_id":cart!.breakfast[sender.tag].cartItemId]
        }
        Modal.shared.deleteCart(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.callGetCartDetail()
            })
        }
        }
@objc func onClickDelete2(_ sender:UIButton){
    let user = UserData.shared.getUser()
    var param = [String:String]()
    if user != nil {
     param = ["uid":UserData.shared.getUser()!.user_id, "item_id":cart!.lunch[sender.tag].itemID,"cart_item_id":cart!.lunch[sender.tag].cartItemId]
    }else{
        param = ["token_id":UserData.shared.deviceToken, "item_id":cart!.lunch[sender.tag].itemID,"cart_item_id":cart!.lunch[sender.tag].cartItemId]
    }
    Modal.shared.deleteCart(vc: self, param: param) { (dic) in
        let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
        self.alert(title: "", message: str, completion: {
            self.callGetCartDetail()
        })
    }
}
@objc func onClickDelete3(_ sender:UIButton){
    let user = UserData.shared.getUser()
    var param = [String:String]()
    if user != nil {
     param = ["uid":UserData.shared.getUser(
        )!.user_id, "item_id":cart!.dinner[sender.tag].itemID,"cart_item_id":cart!.dinner[sender.tag].cartItemId]
    }else{
        param = ["token_id":UserData.shared.deviceToken, "item_id":cart!.dinner[sender.tag].itemID,"cart_item_id":cart!.dinner[sender.tag].cartItemId]
    }
    Modal.shared.deleteCart(vc: self, param: param) { (dic) in
        let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
        self.alert(title: "", message: str, completion: {
            self.callGetCartDetail()
        })
    }
}

    @objc func onClickMinus(_ sender:UIButton) {
        qty = Int(cart!.breakfast[sender.tag].qty)!
        if qty > 1 {
        qty = qty - 1
        
        let arrId : NSMutableArray = []
        if let list = cart?.breakfast {
            for i in 0..<list.count {
                if let list1 = cart?.breakfast[i].customizationList {
                    for j in 0..<list1.count {
                        if let list2 = cart?.breakfast[i].customizationList[j].customizationItemList {
                            for k in 0..<list2.count {
                                if cart!.breakfast[i].customizationList[j].customizationItemList[k].is_checked == true {
                                    arrId.add(cart!.breakfast[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }else{
                                    arrId.remove(cart!.breakfast[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        selectedIndex = sender.tag
        tblOrders.reloadData()
        let user = UserData.shared.getUser()
             let strCustomId = arrItemSelected.componentsJoined(by: ",")
            var param = [String:Any]()
            if user != nil {
                param = ["uid":UserData.shared.getUser()!.user_id,
                     "cart_item_id":cart!.breakfast[sender.tag].cartItemId,
                     "quantity":qty,
                      "customization_item_id":strCustomId
                    ]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.breakfast[sender.tag].cartItemId,
                         "quantity":qty,
                          "customization_item_id":strCustomId
                         ]
            }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            print(dic)
           // let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
          //  self.alert(title: "", message: str, completion: {
              //  self.dismiss(animated: true, completion: nil)
                self.callGetCartDetail()
            //})
        }
        }
    }
    
    @objc func onClickMinus1(_ sender:UIButton) {
        qty = Int(cart!.lunch[sender.tag].qty)!
        if qty > 1 {
            qty = qty - 1
            
            let arrId : NSMutableArray = []
            if let list = cart?.lunch {
                for i in 0..<list.count {
                    if let list1 = cart?.lunch[i].customizationList {
                        for j in 0..<list1.count {
                            if let list2 = cart?.lunch[i].customizationList[j].customizationItemList {
                                for k in 0..<list2.count {
                                    if cart!.lunch[i].customizationList[j].customizationItemList[k].is_checked == true {
                                        arrId.add(cart!.lunch[i].customizationList[j].customizationItemList[k].customizationItemID)
                                    }else{
                                        arrId.remove(cart!.lunch[i].customizationList[j].customizationItemList[k].customizationItemID)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
          
            selectedIndex = sender.tag
            tblOrders.reloadData()
            let user = UserData.shared.getUser()
             let strCustomId = arrItemSelected.componentsJoined(by: ",")
            var param = [String : Any]()
            if user != nil {
            param = ["uid":UserData.shared.getUser()!.user_id,
                         "cart_item_id":cart!.lunch[sender.tag].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId
                        ]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.lunch[sender.tag].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId
                ]
            }
            Modal.shared.updateCart(vc: self, param: param) { (dic) in
                print(dic)
               // let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
               // self.alert(title: "", message: str, completion: {
                 //   self.dismiss(animated: true, completion: nil)
                    self.callGetCartDetail()
               // })
            }
        }
    }
    
    @objc func onClickMinus2(_ sender:UIButton) {
        qty = Int(cart!.dinner[sender.tag].qty)!
        if qty > 1 {
            qty = qty - 1
            
            let arrId : NSMutableArray = []
            if let list = cart?.dinner {
                for i in 0..<list.count {
                    if let list1 = cart?.dinner[i].customizationList {
                        for j in 0..<list1.count {
                            if let list2 = cart?.dinner[i].customizationList[j].customizationItemList {
                                for k in 0..<list2.count {
                                    if cart!.dinner[i].customizationList[j].customizationItemList[k].is_checked == true {
                                        arrId.add(cart!.dinner[i].customizationList[j].customizationItemList[k].customizationItemID)
                                    }else{
                                        arrId.remove(cart!.dinner[i].customizationList[j].customizationItemList[k].customizationItemID)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
            
            selectedIndex = sender.tag
            tblOrders.reloadData()
            let user = UserData.shared.getUser()
             let strCustomId = arrItemSelected.componentsJoined(by: ",")
            var param = [String : Any]()
            if user != nil {
            param = ["uid":UserData.shared.getUser()!.user_id,
                         "cart_item_id":cart!.dinner[sender.tag].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId
                         
                        ]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "cart_item_id":cart!.dinner[sender.tag].cartItemId,
                         "quantity":qty,
                         "customization_item_id":strCustomId
                ]
            }
            Modal.shared.updateCart(vc: self, param: param) { (dic) in
                print(dic)
              //  let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                //self.alert(title: "", message: str, completion: {
                //    self.dismiss(animated: true, completion: nil)
                    self.callGetCartDetail()
               // })
            }
        }
    }
    
    @objc func onClickPlus(_ sender:UIButton) {
        qty = Int(cart!.breakfast[sender.tag].qty)!
        qty = qty + 1
        let arrId : NSMutableArray = []
        if let list = cart?.breakfast {
        for i in 0..<list.count {
            if let list1 = cart?.breakfast[i].customizationList {
                for j in 0..<list1.count {
                    if let list2 = cart?.breakfast[i].customizationList[j].customizationItemList {
                        for k in 0..<list2.count {
                            if cart!.breakfast[i].customizationList[j].customizationItemList[k].is_checked == true {
                                arrId.add(cart!.breakfast[i].customizationList[j].customizationItemList[k].customizationItemID)
                            }else{
                                arrId.remove(cart!.breakfast[i].customizationList[j].customizationItemList[k].customizationItemID)
                            }
                        }
                    }
            
            }
            }
        }
            
        }
      
        selectedIndex = sender.tag
        tblOrders.reloadData()
        let user = UserData.shared.getUser()
        let strCustomId = arrItemSelected.componentsJoined(by: ",")
        var param = [String : Any]()
        if user != nil {
         param = ["uid":UserData.shared.getUser()!.user_id,
                     "cart_item_id":cart!.breakfast[sender.tag].cartItemId,
                     "quantity":qty,
                     "customization_id":strCustomId]
        }else{
            param = ["token_id":UserData.shared.deviceToken,
                     "cart_item_id":cart!.breakfast[sender.tag].cartItemId,
                     "quantity":qty,
            "customization_id":strCustomId]
        }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            print(dic)
            //let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            //self.alert(title: "", message: str, completion: {
              //  self.dismiss(animated: true, completion: nil)
                self.callGetCartDetail()
            //})
        }
    }
    
    @objc func onClickPlus1(_ sender:UIButton) {
        qty = Int(cart!.lunch[sender.tag].qty)!
        qty = qty + 1
        let arrId : NSMutableArray = []
        if let list = cart?.lunch {
            for i in 0..<list.count {
                if let list1 = cart?.lunch[i].customizationList {
                    for j in 0..<list1.count {
                        if let list2 = cart?.lunch[i].customizationList[j].customizationItemList {
                            for k in 0..<list2.count {
                                if cart!.lunch[i].customizationList[j].customizationItemList[k].is_checked == true {
                                    arrId.add(cart!.lunch[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }else{
                                    arrId.remove(cart!.lunch[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
       
        selectedIndex = sender.tag
        tblOrders.reloadData()
        let user = UserData.shared.getUser()
         let strCustomId = arrItemSelected.componentsJoined(by: ",")
        var param = [String : Any]()
        if user != nil {
         param = ["uid":UserData.shared.getUser()!.user_id,
                     "cart_item_id":cart!.lunch[sender.tag].cartItemId,
                     "quantity":qty,
                     "customization_item_id":strCustomId
                    ]
        }else{
            param = ["token_id":UserData.shared.deviceToken,
                     "cart_item_id":cart!.lunch[sender.tag].cartItemId,
                     "quantity":qty,
                     "customization_item_id":strCustomId
            ]
        }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            print(dic)
          //  let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
           // self.alert(title: "", message: str, completion: {
           //     self.dismiss(animated: true, completion: nil)
                self.callGetCartDetail()
           // })
        }
    }
    
    @objc func onClickPlus2(_ sender:UIButton) {
        qty = Int(cart!.dinner[sender.tag].qty)!
        qty = qty + 1
        let arrId : NSMutableArray = []
        if let list = cart?.dinner {
            for i in 0..<list.count {
                if let list1 = cart?.dinner[i].customizationList {
                    for j in 0..<list1.count {
                        if let list2 = cart?.dinner[i].customizationList[j].customizationItemList {
                            for k in 0..<list2.count {
                                if cart!.dinner[i].customizationList[j].customizationItemList[k].is_checked == true {
                                    arrId.add(cart!.dinner[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }else{
                                    arrId.remove(cart!.dinner[i].customizationList[j].customizationItemList[k].customizationItemID)
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
      
        selectedIndex = sender.tag
        tblOrders.reloadData()
        let user = UserData.shared.getUser()
        let strCustomId = arrItemSelected.componentsJoined(by: ",")
        var param =  [String : Any]()
        if user != nil {
        param = ["uid":UserData.shared.getUser()!.user_id,
                     "cart_item_id":cart!.dinner[sender.tag].cartItemId,
                     "quantity":qty,
                     "customization_item_id":strCustomId
                     ]
        }else{
            param = ["token_id":UserData.shared.deviceToken,
                     "cart_item_id":cart!.dinner[sender.tag].cartItemId,
                     "quantity":qty,
                     "customization_item_id":strCustomId
                     ]
        }
        Modal.shared.updateCart(vc: self, param: param) { (dic) in
            print(dic)
           // let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
          //  self.alert(title: "", message: str, completion: {
          //      self.dismiss(animated: true, completion: nil)
                self.callGetCartDetail()
          //  })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         guard let cart = cart else {return 0}
        if tableView == tblOrders {
        if section == 0{
            return (cart.breakfast.count)
        }else if section == 1 {
            return (cart.lunch.count)
        }else if section == 2{
            return (cart.dinner.count)
        }else{
            return 0
        }
        }else{
            if isAddressSelcted == true{
                if (arrBoolCustomization[section]) {
                array = [AddressList]()
                for i in 0..<arrAddressList.count{
                    if arrAddressList[selectedTagCustom].id == arrAddressList[i].id{
                        array.append(arrAddressList[i])
                    }
                }
                return array.count
                }else{
                    return 0
                }
            }else{
            if (arrBoolCustomization[section]) {
                return (arrCustomization[section].customizationItemList.count)
            }else{
                return 0
            }
            }
    }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCustomization{
            if isAddressSelcted == true{
                strAddressID = self.array[indexPath.row].id
                self.lblAddress.text =  self.array[indexPath.row].address_line1 + "," +
                    self.array[indexPath.row].address_line2 + "," +
                    self.array[indexPath.row].address_line3 + "," +
                    self.array[indexPath.row].landmark + "," +
                    self.array[indexPath.row].area_name +  "," +
                    self.array[indexPath.row].city + "-" +
                    self.array[indexPath.row].pincode + "," +
                    self.array[indexPath.row].state + "," + "India"
                self.viewAddress.isHidden = false
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblOrders {
       return arrSection.count
        }else{
            if isAddressSelcted == true{
            return arrAddressList.count
            }else{
                 return arrCustomization.count
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblOrders {
        return SectionHeaderHeight
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblOrders {
       //  let viewSpace = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
         //viewSpace.backgroundColor = UIColor.groupTableViewBackground
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = UIColor.init(hexString: "F0FAFA")
        view.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
       // let button = UIButton(frame: CGRect(x: view.frame.size.width-120, y: viewSpace.frame.size.height+viewSpace.frame.origin.y, width: 110, height: 40
        //))
        label.textColor = UIColor.init(hexString: "35bfe1")
       // button.setTitle("CUSTOMIZE ITEM", for: .normal)
       // button.setTitleColor(UIColor.init(hexString: "53c17f"), for: .normal)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        //button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
           
        label.text = arrSection[section] as? String
          
        view.addSubview(label)
        //view.addSubview(button)
     //   view.addSubview(viewSpace)
        autoDynamicHeight()
        return view
}else{
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
            if isAddressSelcted == true{
                lblHeaderTitle.text = arrAddressList[section].area_nick_name
            }else{
    lblHeaderTitle.text = arrCustomization[section].customizationName
            }
    viewHeader.addSubview(lblHeaderTitle)
    
    let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
    
    viewHeaderMain.addGestureRecognizer(headerTapped)
    
    return viewHeaderMain
    
}
}
    @objc func headerSectionTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
        
        var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
        selectedTagCustom = indexPath.section
        let collapsed: Bool = arrBoolCustomization[indexPath.section]
        var sectionno: Int = 0
        if indexPath.row == 0 {
            for i in 0..<arrBoolCustomization.count {
                if (arrBoolCustomization[i]) == true {
                    sectionno = i
                }
                arrBoolCustomization[i] = false
            }
            if isAddressSelcted == true{
                for i in 0..<arrAddressList.count {
                    if indexPath.section == i {
                        arrBoolCustomization[indexPath.section] = !collapsed ? true : false
                    }
                }
            }else{
            for i in 0..<arrCustomization.count {
                if indexPath.section == i {
                    arrBoolCustomization[indexPath.section] = !collapsed ? true : false
                }
            }
            }
            // [arrData replaceObjectAtIndex:indexPath.section withObject:dict];
            
            tblCustomization.reloadData()
            autoDynamicHeight()
        }
    }
//    func autoDynamicHeight() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//            self.tblCustHeightConst.constant = self.tblCustomization.contentSize.height
//            self.view.layoutIfNeeded()
//        }
//}
}
