//
//  AddToBagPopUp.swift
//  LevelShoes
//
//  Created by Evan Dean on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
import MBProgressHUD
import SwiftyJSON
import Alamofire
import CoreData
import Firebase
import Adjust

protocol AddToBagPopUpDelegate: class {
    func refreshview()
}
class AddToBagPopUp: BottomPopupViewController {
    var objattrList = [String]()
                var designDetail = [OptionsList]()
                var objList = [String]()
               var designData: [NSManagedObject] = []
    var storckDataArray = [[String:Any]]()
@IBOutlet weak var popUpBackGroundView: UIView!
    @IBOutlet weak var sizeGuidButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var processBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSizeGuide: UIButton!{
        didSet{
            let sizeG : String = "Size Guide".localized.uppercased()
            btnSizeGuide.setTitle(sizeG, for: .normal)
            btnSizeGuide.addTextSpacingButton(spacing: 1.5)
        }
    }
    @IBOutlet weak var proceedBtn:UIButton! {
        didSet{
            proceedBtn.setTitle("PROCEED".localized, for: .normal)
            proceedBtn.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
            //proceedBtn
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                proceedBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    var height: CGFloat = 433
    var flagindex:Int = 500
    var comingScreen = ""
    var selectedPrice = 0
    var basketViewModel = MiniBasketViewModel()
    var cartItems:[CartItem] = [CartItem]()
    var selectedItem : Int = 0
    var itemId : Int = 0
     let viewModel = AddToBagPopUpViewModel()
    var cart_source_data: Hits.Source?
    var data: Array<Any> =  Array<Any>()
    var itemDict:[String:Any]  = [:]
    
    var delegate : AddToBagPopUpDelegate?
    var productVPN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAttributeeData()
        btnSizeGuide.underline()
        
        self.proceedBtn.isEnabled = false
        setData()
        
        print("vpn = \(self.productVPN)")
    }
    
    override func viewDidLayoutSubviews() {
        // popUpBackGroundView.layer.cornerRadius = 0
    }
    override func getPopupHeight() -> CGFloat {
        return height
    }
   @IBAction func crossBtnAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func setData(){
        guard let source = cart_source_data else{
            return
        }
        itemDict["image"] = source.image
        itemDict["name"] = source.name
        itemDict["CategoryName"] = getBrandName(id: String(source.manufacturer))
        
            
        self.data = source.configurable_children
        guard let configurableOptions:[String:Any] = source.configurableOptions[0] as? [String : Any] else {
            return
        }
        let attributeID:Int = configurableOptions["attribute_id"] as? Int ?? 0
        
       // itemDict["attributeID"] = Double(attributeID)
         itemDict["attributeID"] = attributeID
        /*guard let stock:[String:Any] = configurableOptions["stock"] as? [String:Any] else {
            return
        }
        let quantity = stock["qty"]
        let stockStatus = stock["stock_status"]
        
        itemDict["stock"] = stock
        itemDict["quantity"] = quantity
        itemDict["stockStatus"] = stockStatus*/
        
        var size:String = ""
        for ConfigOption in self.data {
            
            guard let option:[String:Any] = ConfigOption as? [String:Any] else {
                return
            }
            size = "\(size)\(option["size"] ?? "")\t"
        }
        itemDict["size"] = size
        itemDict["finalPrice"] = source.final_price as? Double ?? 0.0
        itemDict["regularPrice"] = source.regular_price as? Double ?? 0.0
         itemDict["actualPrice"] = source.final_price as? Double ?? 0.0
         itemDict["qty"] = 1
    }
    
    func fetchAttributeeData(){

           if CoreDataManager.sharedManager.fetchAttributeData() != nil{

               designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
               print("colorArray", designData.count)
           }
           
           
            for j in 0..<designData.count{
                let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
                designDetail.append(array[k])
                }
            }
       
           let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
                 designDetail = sorteddesignDetail
           
           let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
           for i in 0..<designDetail.count{
               for j in arrColorNm{
                   if designDetail[i].label == j{
                       designDetail[i].isSelected = true
                   }
               }
           }
           
           for i in 0..<designDetail.count{
               objList.append(designDetail[i].label)
           }
           objattrList = objList
          
       }
       
       func getBrandName(id:String) -> String{
           var strBrand = ""
           for i in 0..<(designDetail.count){
              if id == "\(designDetail[i].value)"{
               strBrand = designDetail[i].label
              }
           }
           return strBrand.uppercased()
       }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
        //Adding Item in Database
        callOmsStockCheckApi(skus: itemDict["sku"] as? String ?? "" , forTask:"proceedBtnAction")
       // proceedtoNextScreen()
    }
    
    func proceedtoNextScreen(){
        var cartData:[String:Any] = [:]
             cartData["sku"] = itemDict["sku"]
             cartData["imageURL"] = CommonUsed.globalUsed.kimageUrl + (itemDict["image"] as? String ?? "")!
             cartData["name"] = itemDict["name"]
             cartData["categoryName"] = itemDict["CategoryName"]
             cartData["price"] = itemDict["actualPrice"] as? Double ?? 0.0
             cartData["finalPrice"] = itemDict["finalPrice"] as? Double ?? 0.0
             cartData["selectedPrice"] = itemDict["finalPrice"] as? Double ?? 0.0
             cartData["regularPrice"] = itemDict["regularPrice"] as? Double ?? 0.0
             cartData["qty"] = 1
             cartData["size"] =   itemDict["selectedSize"]      //itemDict["size"]
             cartData["selectedSize"] = itemDict["selectedSize"]
             cartData["attributeID"] = itemDict["attributeID"]
             cartData["lvl_category"] = cart_source_data?.lvl_category
             cartData["manufacturer"] = cart_source_data?.manufacturer
             var params:[String:Any] = [:]
             params["sku"] = cart_source_data!.sku
             params["qty"] =  1
             
             var extension_attributes:[String:Any] = [:]
             extension_attributes["option_id"] = itemDict["attributeID"]
             extension_attributes["option_value"] = itemDict["selectedSize"]    //itemDict["size"]

             var   configurable_item_options = ["configurable_item_options" : [extension_attributes]]
             var productOption:[String:Any] = [:]
             productOption["extension_attributes"] = configurable_item_options
             
             
             params["product_option"] = productOption
              MBProgressHUD.showAdded(to: self.view, animated: true)
             if comingScreen == "ShoppingBagVC" {
                 
                 // params["itemId"] = "\(cartItems[selectedItem].itemID!)"
                 if(M2_isUserLogin){
                             params["quote_id"] = cartItems[selectedItem].quoteID
                             }
                 else{
                     params["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
                 }
                // params["quote_id"] = cartItems[selectedItem].quoteID
                 params["item_id"] = itemId
                 params["qty"] = cartItems[selectedItem].qty
                 
                 ApiManager.updateCartItem(params: params, success: { (response) in
                     
                     DispatchQueue.main.async {
                         self.delegate?.refreshview()
                         MBProgressHUD.hide(for: self.view, animated: true)
                         self.dismiss(animated: true, completion: {
                         })
                     }
                     
                 }) {
                     
                 }
                 return
             }
             //Adding Item in Server
                 self.viewModel.addItemInCart(params, success: { (response) in
                     print(response)
                     //Navigation to Next Controller
                     DispatchQueue.main.async {
                          MBProgressHUD.hide(for: self.view, animated: true)
                         weak var pvc = self.presentingViewController
                         self.dismiss(animated: true, completion: {
                            if UserDefaults.standard.value(forKey: string.shopBagItemCount) != nil {
                            let iTemCount =  UserDefaults.standard.integer(forKey: string.shopBagItemCount)
                            let updateCont = iTemCount + 1
                            UserDefaults.standard.set(updateCont, forKey: string.shopBagItemCount)
                            }else{
                                UserDefaults.standard.set(1, forKey: string.shopBagItemCount)
                            }
                            NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
                             let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
                             let changeVC: MiniBasketViewController
                             changeVC = storyboard.instantiateViewController(withIdentifier: "MiniBasketViewController") as! MiniBasketViewController
                             var selProduct:[String:Any] = [:]
                             selProduct["allSKU"] = self.itemDict["sku"] as? String
                             changeVC.selectedSize = "\(self.itemDict["selectedSize"]!)"
                             var resposeData = response as? [String:Any]
                             cartData["quote_id"] = resposeData!["quote_id"] as? String ?? ""
                             cartData["item_id"] = resposeData!["item_id"] as? Int ?? 0
                              var extension_attributes:[String:Any] = [:]
                             extension_attributes["option_id"] = self.itemDict["attributeID"]
                             extension_attributes["option_value"] = self.itemDict["selectedSize"]    //itemDict["size"]
                             var   configurable_item_options = ["configurable_item_options" : [extension_attributes]]
                                     var productOption:[String:Any] = [:]
                                     productOption["extension_attributes"] = configurable_item_options
                                     
                                     
                                   cartData["product_option"]  = productOption
                             
                             changeVC.itemDict =  cartData
                             changeVC.data = self.data
                             changeVC.selectedProduct = selProduct
                             self.addToCartEvent(itemDict: cartData)
                             pvc?.present(changeVC, animated: true, completion: nil)
                         })
                     }
                    
                 }) {
                     
                 }
    }
    func addToCartEvent(itemDict:[String:Any]) {
        //below for analytics categoryid and categoryname
       let categoryId = "\(itemDict["lvl_category"] ?? "")"
        //print("cateory name = \(categoryId)")
        let categoryName = getCategoryName(id: categoryId)
        var selectedProduct: [String: Any] = [
            AnalyticsParameterItemID: self.productVPN,//@Nitikesh parent id will be here
            AnalyticsParameterItemName: itemDict["name"] ?? "",
            AnalyticsParameterPrice: (itemDict["price"] as? Double ?? 0.0)/1000000,
            AnalyticsParameterCoupon:"",
            AnalyticsParameterItemCategory: categoryName,//@Nitikesh category will be here
            AnalyticsParameterItemBrand: getBrandName(id: String(itemDict["manufacturer"] as? Int ?? 1)),//@Nitikesh brand name will be here
        ]
        // Specify order quantity
        //@@narayan
        //selectedProduct[AnalyticsParameterQuantity]  = itemDict["qty"] as? Int ?? 0.0
        selectedProduct[AnalyticsParameterQuantity]  = 1
        
        // Prepare item detail params
        var itemDetails: [String: Any] = [
          AnalyticsParameterCurrency: getWebsiteCurrency(),
          //AnalyticsParameterValue: "\(itemDict["price"] ?? "")"
          AnalyticsParameterValue: itemDict["price"] as? Double ?? 0.0
        ]

        // Add items
        itemDetails[AnalyticsParameterItems] = [selectedProduct]

        // Log an event when product is added to cart
        Analytics.logEvent(AnalyticsEventAddToCart, parameters: itemDetails)
        
        
        //**************** Adjust Event Tracking:z5ppi3 ************
        
        var content = [[String: String]]()
        let contentValue: [String: String] = ["id": self.productVPN]// parent id will come here
        let contentValue1: [String: String] = ["quantity": "1"]
        content.append(contentValue)
        content.append(contentValue1)
        

       // let currency: String = UserDefaults.standard.string(forKey: "currency")!.localized
        let currency: String = (UserDefaults.standard.value(forKey: "currency") as? String ?? getWebsiteCurrency()).localized

        Adjust.trackSubsessionStart()
 
        let addToCardEvent = ADJEvent.init(eventToken: "z5ppi3")
        //@@narayan vpn
        addToCardEvent?.addPartnerParameter("C_product_id", value: self.productVPN)//@Nitikesh product parent id will be here
        addToCardEvent?.addPartnerParameter("content", value: content.description)
        addToCardEvent?.addPartnerParameter("content_type", value: "product")
        addToCardEvent?.addPartnerParameter("criteo_partner_id", value: "com.levelshoes.ios")
        addToCardEvent?.addPartnerParameter("price", value: "\(itemDict["price"] ?? "")")
        addToCardEvent?.addPartnerParameter("currency", value: currency)
        addToCardEvent?.addPartnerParameter("Brand", value: getBrandName(id: "\(itemDict["manufacturer"]!)" ))
        addToCardEvent?.addPartnerParameter("category", value: categoryName)
        Adjust.trackEvent(addToCardEvent)
        
    }
    
    @IBAction func sizeGuideAction(_ sender: UIButton) {
        print("OPen SIze Guide")
        let storyboard = UIStoryboard(name: "size", bundle: Bundle.main)
        let sizeVC: sizeGuideVC! = storyboard.instantiateViewController(withIdentifier: "sizeguide") as? sizeGuideVC
        sizeVC.modalPresentationStyle = .fullScreen
        self.present(sizeVC, animated: true, completion: nil)
    }

    func checkSkuStock(sku:String)->[String:Any]{
        var stockDetail = [String:Any]()
        for stock in storckDataArray{
            var skuvalu : String = "\(stock["ean"]!)"
            if (skuvalu == sku) {
               stockDetail = stock
                break
            }
        }
        return stockDetail
    }
    func callOmsStockCheckApi(skus: String, forTask:String)
      {
          MBProgressHUD.showAdded(to: self.view, animated: true)
           let url = URL(string: CommonUsed.globalUsed.omsStockUrl)!
                  let params = [
                             "api_user_id" : CommonUsed.globalUsed.omsUserId,
                             "ean" : skus //111111,222222,333333,44444
                             ] as [String : Any] as [String : Any]
              
                  Alamofire.request(url,method: .post, parameters: params, headers: ["X-RUN-API-KEY":CommonUsed.globalUsed.omsATPApiKey,"Content-Type":"application/x-www-form-urlencoded"])
                      .responseJSON { (response) in
                          MBProgressHUD.hide(for: self.view, animated: true)
                
                          switch response.result {
                                     case .success(_):
                                      
                                         if let data = response.result.value as? [String : Any] {
                                            
                                          let soh = data["soh"] as? [[String:Any]] ?? [[String:Any]]()
                                            if soh.count > 0 && (self.checkStockForSku(sku: skus, sohArray: soh) > 0 ){
                                                if forTask == "proceedBtnAction"{
                                                    self.proceedtoNextScreen()
                                                }
                                                 //self.moveToAddToPopup(storckDataArray :soh)
                                             }else {
                                               let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                                 alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                                 self.present(alert, animated: true, completion: nil)
                                             }
                                         } else {
                                           let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                             alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                             self.present(alert, animated: true, completion: nil)
                                         }
                                     case .failure(_):
                                       let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                         alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                         self.present(alert, animated: true, completion: nil)
                                     }
     
                  }
     
      }
    func checkStockForSku(sku:String, sohArray:[[String:Any]]) -> Int{
        var stock = 0
        for sohItem in sohArray {
            if sku == String(describing: sohItem["ean"] ?? "") {
                stock =  Int(String(describing: sohItem["stock"] ?? "")) ?? 0
            }
        }
        return stock
        
    }
}
extension AddToBagPopUp:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddBagPopUpCell = tblView.dequeueReusableCell(withIdentifier:"AddBagPopUpCell",for:indexPath ) as! AddBagPopUpCell
        
    if let dict:[String:Any] = data[indexPath.row] as? [String:Any] , let size:Int = dict["size"] as? Int , let stockDict:[String:Any] = dict["stock"] as? [String:Any] , let atpStock:Int = stockDict["qty"] as? Int {

       // if let dict:[String:Any] = data[indexPath.row] as? [String:Any] , let size:Int = dict["size"] as? Int , let stockDict:[String:Any] = dict["stock"] as? [String:Any]
//        {
//            let stockData =   checkSkuStock(sku: dict["sku"] as? String ?? "" )
//             var atpStock:Int =  stockData["stock"] as? Int ?? 0
//             let esStock:Int =  stockDict["qty"] as? Int ?? 0
//            if(esStock == 0 || atpStock == 0){
//                atpStock = 0
//            }
            cell.sizeLabel(size: size , stock: atpStock , price: dict["final_price"] as? Double ?? 0.0)
        }
        cell.CheckCurrentcell(cell: cell, index: indexPath.row, flagindex: flagindex)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //
        guard let configChildDict:[String:Any] = self.data[indexPath.row] as? [String:Any] else {
            return
        }
        guard let stockDict:[String:Any] = configChildDict["stock"] as? [String:Any] else {
            return
        }
        guard let esStock:Int = stockDict["qty"] as? Int else {
            return
        }
       
        if esStock == 0 {
            return
        }
//        var atpStock =   checkSkuStock(sku: configChildDict["sku"] as? String ?? "" )["stock"] as? Int ?? 0
//        if(esStock == 0 || atpStock == 0){
//            atpStock = 0
//        }
//        if atpStock == 0 {
//            return
//        }
        flagindex = indexPath.row
        itemDict["sku"] = configChildDict["sku"]
        itemDict["finalPrice"] = configChildDict["final_price"]
        itemDict["selectedPrice"] = configChildDict["final_price"]
        itemDict["regularPrice"] = configChildDict["regular_price"]
        itemDict["selectedSize"] = "\(configChildDict["size"] ?? "")"
        itemDict["visibility"] = configChildDict["visibility"]
        itemDict["name"] = configChildDict["name"]
        self.proceedBtn.isEnabled = true
        tblView.reloadData()
    }
    
    
}
