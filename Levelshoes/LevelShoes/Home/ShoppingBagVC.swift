//
//  ShoppingBagVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 22/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
import CoreData

var totalcartItems: [Item] = [Item]()
var globalQuoteId = ""
var globalProducts = [String : Any]()
var strGiftFrom = ""
var strGiftTo = ""
var strGiftMsg = ""
var giftWrapParam : GiftWrapParam?
var childrenData = [String : Any]()
var isWrapGiftShow:Bool = false
var globalCartDetails: [Item] = [Item]()
var afterOrderCreate = false
class ShoppingBagVC: UIViewController {

    var objattrList = [String]()
                      var designDetail = [OptionsList]()
                      var objList = [String]()
                     var designData: [NSManagedObject] = []
    
    @IBOutlet weak var lblDeleteGift: UILabel!{
        didSet{
            lblDeleteGift.text = "deleteGiftOrOffer".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDeleteGift.font = UIFont(name: "Cairo-SemiBold", size: lblDeleteGift.font.pointSize)
            }
        }
    }
    @IBOutlet weak var btnDeleteGift: UIButton!{
        didSet{
            btnDeleteGift.setTitle("yes".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnDeleteGift.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 20)
            }
            
        }
    }
    @IBOutlet weak var btnNoGift: UIButton!{
        didSet{
            btnNoGift.setTitle("no".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnNoGift.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 20)
            }
            
        }
    }
    @IBOutlet weak var lblDeleteOffer: UILabel!{
        didSet{
            lblDeleteOffer.text = "deleteGiftOrOffer".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDeleteOffer.font = UIFont(name: "Cairo-SemiBold", size: lblDeleteOffer.font.pointSize)
            }
        }
    }
    @IBOutlet weak var btnDeleteOffer: UIButton!{
        didSet{
            btnDeleteOffer.setTitle("yes".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnDeleteOffer.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 20)
            }
            
        }
    }
    @IBOutlet weak var btnNoOffer: UIButton!{
        didSet{
            btnNoOffer.setTitle("no".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnNoOffer.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 20)
            }
            
        }
    }
    
    @IBOutlet weak var viewDeleteGiftCard: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var shimmeringImgView: UIImageView!
    
    @IBOutlet weak var viewEmptyBag: UIView!
    @IBOutlet weak var lblemptyHeader: UILabel!{
        didSet{
            lblemptyHeader.addTextSpacing(spacing: 1)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblemptyHeader.font = UIFont(name: "Cairo-SemiBold", size: lblemptyHeader.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblEmptyDesc: UILabel!{
        didSet{
             lblEmptyDesc.addTextSpacing(spacing: 0.5)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEmptyDesc.font = UIFont(name: "Cairo-Light", size: lblEmptyDesc.font.pointSize)
            }
        }
       
    }
    @IBOutlet weak var btnStartShopping: UIButton!{
        didSet{
            btnStartShopping.setTitle("START SHOPPING".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnStartShopping.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnStartShopping.addTextSpacingButton(spacing: 1.5)
            btnStartShopping.underline()
        }
    }
    @IBOutlet weak var grandTotalLabel: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                grandTotalLabel.font = UIFont(name: "Cairo-SemiBold", size: grandTotalLabel.font.pointSize)//make font smaller
            }
        }
    }
    var stockATP = [String : Any]()
    var sizeArray = ["30","32","34","36","38","40"]
    var sizePickerView = UIPickerView()
    var toolbar = UIToolbar()
    var productData : NewInData?
    var selectedSize: String?
    var requseQty: Int?
    var isSizeStatus: Bool?
    var skuData = [String : Any]()
    var skuSourseData = [String : Any]()
    let viewModel = ShoppingBagViewModel()
    var data: CartModel?
    var totalCarddata: CartTotalModel?
    var cartItems: [CartItem] = [CartItem]()
    var strGift = ""
    var voucher : String = ""
    var coupon : String = ""
    var isSelected:Bool = false
    
    let checkoutviewModel = CheckoutViewModel()
    var priceCategories = [String]()
    var priceCategoryValue = [0.0,0,0,0.0,0.0]
    var tblData_PriceCategories = [String]()
    var tblData_PriceCategoryValue = [0.0,0,0,0.0,0.0]
    var selectedItems :[Bool] = [Bool]()
    @IBOutlet weak var grandTotalView : UIView?
  //  @IBOutlet weak var noIteamView = UIView()
   
    @IBOutlet weak var lblGrandTotal: UILabel!{
        didSet{
            lblGrandTotal.text = "Grand Total".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblGrandTotal.font = UIFont(name: "Cairo-SemiBold", size: 9)
            }
        }
    }
    @IBOutlet weak var btnVatinclusive: UILabel!{
        didSet{
            btnVatinclusive.text = "vatInclusive".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnVatinclusive.font = UIFont(name: "Cairo-Light", size: btnVatinclusive.font.pointSize)
            }
        }
    }
    @IBOutlet weak var btnProceedTobuy: UIButton!{
        didSet{
            btnProceedTobuy.setTitle("PROCEED TO BUY".localized, for: .normal)
            btnProceedTobuy.addTextSpacingButton(spacing: 1.5)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnProceedTobuy.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    
    @IBOutlet weak var cartBottomPopupHeightConstraint:NSLayoutConstraint!

      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var editBtn: UIButton!
      {
          didSet
          {
               editBtn.underline("Edit".localized)
          }
      }
    @IBOutlet weak var selectAllBtn:UIButton!
    @IBOutlet weak var cancelBtn:UIButton!
    
      @IBOutlet weak var lblTitle: UILabel!{
          didSet{
              if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
              lblTitle.addTextSpacing(spacing: 1.5)
              }else{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            lblTitle.text = "SHOPPING BAG".localized
          }
       
      }
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        
        do {
            let gif = try UIImage(gifName: "shimmering.gif")
            self.shimmeringImgView.setGifImage(gif, loopCount: -1)
        } catch  {
            print(error)
        }
        let topTitle = "SHOPPING BAG".localized
        self.lblTitle.text = "\(topTitle)"
        self.btnProceedTobuy.isUserInteractionEnabled = false
        self.btnProceedTobuy.alpha = 0.5
        fetchAttributeeData()
         self.setEmptyView()
        self.tableView.register([WrapGiftTableViewCell.identifier , CartEditBottomTableViewCell.identifier , CartSummaryTableViewCell.identifier ,PriceCell.identifier])
    }
    func setpriceCategoriesCounteryWise(){
        //KSA/Kuwait/Oman/Bahrain
       
          // priceCategories = ["Cart Subtotal","Discount","Shipping","VAT","Grand Total"]
        
    }
    
    func checkVATAvailable(vat:Double){
        btnVatinclusive.isHidden = false
        if vat > 0.0 {
             //priceCategories = ["Cart Subtotal","Discount","Shipping","VAT","Grand Total"]
            btnVatinclusive.isHidden = false
        }else{
             //priceCategories = ["Cart Subtotal","Discount","Shipping","Grand Total"]
             btnVatinclusive.isHidden = true
        }
        btnVatinclusive.isHidden = shouldHideVatinclusive()
    }
       
    override func viewWillAppear(_ animated: Bool) {
      
       // setpriceCategoriesCounteryWise()
        //  priceCategories = ["Cart Subtotal","Discount","Shipping","Grand Total"]
        super.viewWillAppear(animated)
        let topTitle = "SHOPPING BAG".localized
        self.lblTitle.text = "\(topTitle)"
        self.shimmeringImgView.isHidden = false
//        if priceCategories.count > 5 && strGift == ""{
//        priceCategoryValue.remove(at: 2)
//        priceCategories.remove(at: 2)
//        }
        voucher = ""
       // coupon = ""
        
        viewModel.getCheckoutTotal(success: { (response) in
            print(response)
            self.getCartTotal(response)
             CartDataModel.shared.setValue(self.data, cartTotal: response)
            self.shimmeringImgView.isHidden = true

        }) {
            // failure
        }
       
        updateValues()
        isSelected = false

       
       self.viewEmptyBag?.isHidden = true
        //self.tableView?.isHidden = true
       // MBProgressHUD.showAdded(to: self.view, animated: true)
       
        viewModel.getCartItems(success: { (response) in
            //MBProgressHUD.hide(for: self.view, animated: true)
            
            if (M2_isUserLogin && UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") == nil && UserDefaults.standard.string(forKey: "quote_id_to_convert") != nil ) {
               
                      self.InActiveCart(quote_id: response.id ?? 0)
                                                       
                                 }
            else{
                self.setCartData(response)
            }
            let quoteid:Int = response.id ?? 0
            if(quoteid != 0){
                globalQuoteId = String(quoteid)
            }
            self.shimmeringImgView.isHidden = true
        }) {
            //Failure
            print("hello")
        }

    }
    

    

  //Inactive the Cart if Guest User Converts to Login User
    func InActiveCart(quote_id: Int){
              var params: [String:Any] = [:]
              var quote: [String:Any] = [:]
              var customer: [String:Any] = [:]
              
              quote["is_active"] = false
              quote["store_id"] = UserDefaults.standard.value(forKey: string.storeId)
              customer["id"] =  UserDefaults.standard.string(forKey:"customerId")
              quote["customer"] = customer
              quote["id"] = quote_id
              params["quote"] =  quote
                //MBProgressHUD.showAdded(to: self.view, animated: true)
                self.shimmeringImgView.isHidden = false
              self.checkoutviewModel.inActiveCart(params, success: {
                //MBProgressHUD.hide(for: self.view, animated: true)
                self.shimmeringImgView.isHidden = true
                  DispatchQueue.main.async {
                      self.conversionLoginUserToGuestUser()
                  }
              }) {
                  //MBProgressHUD.hide(for: self.view, animated: true)
                    self.shimmeringImgView.isHidden = true
              }
          }
     
     func conversionLoginUserToGuestUser(){
           
        let param =  ["customerId" : UserDefaults.standard.value(forKey: string.customerId) , "storeId" : UserDefaults.standard.value(forKey: string.storeId) ]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.guestCartToLoggedUserCartConversionApiCall(params:param as [String : Any] ,success: { (response) in
              
            UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
            UserDefaults.standard.set(nil,forKey: "quote_id_to_convert")
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.updateCartItemsAfterInactive()
            }
           
          },failure:{
              () in
            MBProgressHUD.hide(for: self.view, animated: true)
          }
          )
           
       }
    func updateCartItemsAfterInactive(){
        isSelected = false
        self.viewEmptyBag?.isHidden = true
        self.shimmeringImgView.isHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.getCartItems(success: { (response) in
            self.setCartData(response)
            
        }) {
            //Failure
            print("hello")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getParentSkuDetail(){
        
        let url = getProductUrl()
        let  param = ["_source":["id","size_options","size","image","manufacturer","configurable_children.stock",
                                 "configurable_children.size","configurable_children.sku","configurable_children.final_price","configurable_options","sku","final_price","regular_price","lvl_category"],
                      "query":["bool":
                        ["must":
                            [
                                ["terms":["configurable_children.sku":getAllKuvID()]
                                ]
                            ]
                        ]
            ]
            ]as [String : Any]
        self.magentoApiCallForProduct(url:url,param:param,controller:self)
    }
    
    

    func callOmsStockCheckApi(skus: String)  // "1,2,3,4"
    {
        //create the url with NSURL
        let url = URL(string: CommonUsed.globalUsed.omsStockUrl)!
        let params = [
                   "api_user_id" : CommonUsed.globalUsed.omsUserId,
                   "ean" : skus //111111,222222,333333,44444
                   ] as [String : Any] as [String : Any]
    
        Alamofire.request(url,method: .post, parameters: params, headers: ["X-RUN-API-KEY":CommonUsed.globalUsed.omsATPApiKey,"Content-Type":"application/x-www-form-urlencoded"])
            .responseJSON { (response) in

                //ATP check for All SKUS
//                    print(response.result.value)
               /* let data = JSON(response.result.value as! String)
                if(data["status"] as? String ?? "" == "success"){
                    let soh = JSON(data["soh"])
                    
                    self.stockATP[soh["ean"].stringValue] = self.stockATP[soh["stock"].stringValue]
                    }
                
                */
                

        }
       
       
       
    }

    func magentoApiCallForProduct(url:String,param : Any , controller:UIViewController){
        MBProgressHUD.showAdded(to: view, animated: true)
        ApiManager.apiPost(url: url, params: param as! [String : Any]) { (response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    controller.present(nextVC, animated: true, completion: nil)
                    
                }
                controller.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil{
                var dict = [String:Any]()
                print("magentoApiCallForProduct===========>",response)
                dict["data"] = response?.dictionaryObject
                self.productData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                self.getConfigurationForeSkuId()
                
            }
        }
        
    }
    func getAllKuvID()->[String]{
        var kvuIds = [String]()
        for cartItem in cartItems{
            kvuIds.append(cartItem.sku!)
    
        }
        
        return kvuIds
    }

    
    func getConfigurationForeSkuId(){
        self.skuData = [String : [String:Any]]()
        self.skuSourseData = [String : Any]()
        for i in 0..<(productData!.hits?.hitsList.count)!{
            let histList = productData!.hits?.hitsList[i]._source?.configurable_children
            for j in 0..<(histList!.count) {
                let skuDatavalue = histList![j] as! [String : Any]
                self.skuData[skuDatavalue["sku"] as! String] = histList![j]
                self.skuSourseData[skuDatavalue["sku"] as! String] = self.productData!.hits!.hitsList[i]._source!
            }
        }
        
        globalProducts = self.skuSourseData
        childrenData = self.skuData
        print("skuData===========>",self.skuData)
        var skus = ""
        var count = 1
        
        for (key, _) in self.skuData {
                   
                   if(count == self.skuData.count){
                       skus = skus + key
                   }
                   else{
                       skus = skus + key + ","
                   }
                 
                 count += 1
               }
               //ATP Check for all Skus
               callOmsStockCheckApi(skus: skus)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func setCartData(_ response: CartModel){
        
        self.data = response
        //globalCartDetails = self.data
         MBProgressHUD.hide(for: self.view, animated: true)
        guard let items = self.data?.items else {
            self.cartItems.removeAll()
            UserDefaults.standard.set(self.cartItems.count, forKey: string.shopBagItemCount)
             NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
            self.grandTotalView?.isHidden = true
            self.viewEmptyBag?.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
            self.btnProceedTobuy.isUserInteractionEnabled = true
            self.btnProceedTobuy.alpha = 1.0
            return
        }
        
        if items.count < 1{
            self.cartItems.removeAll()
             UserDefaults.standard.set(self.cartItems.count, forKey: string.shopBagItemCount)
             NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
            self.tableView.reloadData()
            self.viewEmptyBag?.isHidden = false
            self.grandTotalView?.isHidden = true
        }else{
        self.viewEmptyBag?.isHidden = true
        self.shimmeringImgView.isHidden = true
        self.cartItems = items
        UserDefaults.standard.set(self.cartItems.count, forKey: string.shopBagItemCount)
        NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
        getParentSkuDetail()
        DispatchQueue.main.async {

           if self.cartItems.count > 0 {
            
            self.cancelBtn.isHidden = false
            //self.cartBottomPopupHeightConstraint.constant = 160
            MBProgressHUD.hide(for: self.view, animated: true)
            self.btnProceedTobuy.isUserInteractionEnabled = true
                       self.btnProceedTobuy.alpha = 1.0
             self.grandTotalView?.isHidden = false
           }else{
            
            self.cancelBtn.isHidden = true
            self.grandTotalView?.isHidden = true
            self.viewEmptyBag?.isHidden = true
            self.shimmeringImgView.isHidden = true
           // self.tableView.setEmptyView()
             MBProgressHUD.hide(for: self.view, animated: true)
            self.btnProceedTobuy.isUserInteractionEnabled = true
                       self.btnProceedTobuy.alpha = 1.0
            }
           self.tableView.reloadData()
           self.view.setNeedsLayout()
        }
        viewModel.getCheckoutTotal(success: { (response) in
            print(response)
            self.getCartTotal(response)
             CartDataModel.shared.setValue(self.data, cartTotal: response)

        }) {
            // failure
        }
        }
    }
    
    func getCartTotal(_ response: CartTotalModel){
        self.priceCategories.removeAll()
        self.priceCategoryValue.removeAll()
        self.tblData_PriceCategories.removeAll()
        self.tblData_PriceCategoryValue.removeAll()
        self.totalCarddata = response
       
        guard let items = self.totalCarddata?.items else {
            return
        }
        
        
        var taxes = [TaxGrandtotalDetail]()
      if totalCarddata?.totalSegments?.count != 0{
          for i in 0..<(totalCarddata?.totalSegments!.count)!{
              if totalCarddata?.totalSegments?[i].code == "giftcardaccount"{
                strGift = totalCarddata?.totalSegments?[i].extensionAttributes?.gift_cards ?? ""
//                if totalCarddata?.totalSegments?[i].code == "discount"{
//                    let array = totalCarddata?.totalSegments?[i].title?.components(separatedBy: " ")
//                    coupon = array?[1] ?? ""
//                   coupon = coupon.replaceString("(", withString: "")
//                    coupon = coupon.replaceString(")", withString: "")
//                }
              }
            if((totalCarddata?.totalSegments?[i].extensionAttributes?.taxGrandtotalDetails?.count ?? 0)>0){
            taxes = (totalCarddata?.totalSegments?[i].extensionAttributes?.taxGrandtotalDetails)!
            }
      }
      }
//        if strGift == "" {
//            priceCategoryValue.remove(at: 2)
//            priceCategories.remove(at: 2)
//9
//        }
     
      //  priceCategories = ["Cart Subtotal","Discount","Shipping","VAT","Grand Total"]
        
        totalcartItems = items
        globalCartDetails = items
        
        priceCategoryValue.append(totalCarddata?.subtotalInclTax ?? 0.0)
        priceCategories.append("Cart Subtotal")
        tblData_PriceCategoryValue.append(totalCarddata?.subtotalInclTax ?? 0.0)
        tblData_PriceCategories.append("Cart Subtotal")
        coupon = totalCarddata?.coupon_code ?? ""
        priceCategoryValue.append(Double(totalCarddata?.baseDiscountAmount ?? 0))
        priceCategories.append("Discount")
        //print("PRint DIscout \(totalCarddata?.baseDiscountAmount)")
        if let discount = totalCarddata?.baseDiscountAmount {
            if discount > 0 || discount < 0 {
                tblData_PriceCategoryValue.append(Double(totalCarddata?.baseDiscountAmount ?? 0))
                tblData_PriceCategories.append("Discount")
            }
        }
        
        if (strGift != "" && afterOrderCreate == false) {
            
            let d = convertToArray(text: strGift)
            let newGiftcard = "Gift Card".localized
            priceCategories.append("\(newGiftcard) (\(d?[0]["c"] ?? ""))")
            tblData_PriceCategories.append("\(newGiftcard) (\(d?[0]["c"] ?? ""))")
            let value:Double = Double(d?[0]["ba"] as? Int ?? 0)
            priceCategoryValue.append(value)
            tblData_PriceCategoryValue.append(value)
            voucher  = "\(d?[0]["c"] ?? "")"
            
        }
        if(afterOrderCreate == true){
            voucher = ""
        }
        
        priceCategoryValue.append(totalCarddata?.shippingInclTax ?? 0.0) 
        priceCategories.append("Shipping")
        if let shipping = totalCarddata?.shippingInclTax {
            if shipping > 0 {
                tblData_PriceCategoryValue.append(totalCarddata?.shippingInclTax ?? 0.0)
                tblData_PriceCategories.append("Shipping")
            }
        }
        priceCategoryValue.append(totalCarddata?.taxAmount ?? 0.0)
      
        if(taxes.count > 0 ){
            for i in 0..<(taxes.count ){
                var vatTitle = (taxes[i].rates?[0].title ?? "")
                vatTitle = vatTitle + " (" + (taxes[i].rates?[0].percent ?? "") + "%)"
                let vatAmount = taxes[i].amount ?? 0.0
                priceCategories.append( vatTitle)
                tblData_PriceCategories.append( vatTitle)
                tblData_PriceCategoryValue.append(vatAmount)
            }
            
        }
        else{
        priceCategories.append(getVatName())
        if let vat = totalCarddata?.taxAmount {
            if vat > 0 {
                tblData_PriceCategoryValue.append(totalCarddata?.taxAmount ?? 0.0)
                tblData_PriceCategories.append(getVatName())
            }
        }}
        checkVATAvailable(vat:Double(totalCarddata?.taxAmount ?? 0.0))
        
       
        priceCategoryValue.append(Double(totalCarddata?.baseGrandTotal ?? 0))
        priceCategories.append("Grand Total")
        tblData_PriceCategoryValue.append(Double(totalCarddata?.baseGrandTotal ?? 0))
        tblData_PriceCategories.append("Grand Total")
        
        
       // var giftcards: [String] = []
            // var giftAmounts: [Double]  = []
        // Remove all giftcards at initial load
//        for i in 5..<priceCategoryValue.count{
//            priceCategories.remove(at: i)
//            priceCategoryValue.remove(at: i)
//            break
//        }
        
        let grandTotalPriceValue = Double(self.totalCarddata?.baseGrandTotal ?? 0).clean
        self.grandTotalLabel.text = "\(grandTotalPriceValue) " +  (UserDefaults.standard.string(forKey: "currency") as? String ?? getWebsiteCurrency()).localized
       // self.grandTotalLabel.text = "\(self.totalCarddata?.baseGrandTotal ?? 0) " +  UserDefaults.standard.string(forKey: "currency")!.localized
        DispatchQueue.main.async {
           self.tableView.reloadData()
           self.view.setNeedsLayout()
        }
    }
    
    
    
    func updateValues() {
        self.viewModel.cartUpdated = {(type, response) in
            if type == "updateCart"{
                print("response",response)
            }else if type == "getCart"{
                self.setCartData(response as! CartModel)
            }
        }
    }
    func getgiftCardApiCallForProduct(url:String,param : Any , controller:UIViewController){
           MBProgressHUD.showAdded(to: view, animated: true)
           ApiManager.apiPut(url: M2_giftCard, params: (param as! [String : Any])) { (response, error) in
               MBProgressHUD.hide(for: self.view, animated: true)
               if let error = error{
                   //print(error)
                   if error.localizedDescription.contains(s: "offline"){
                       let nextVC = NoInternetVC.storyboardInstance!
                       nextVC.modalPresentationStyle = .fullScreen
                       controller.present(nextVC, animated: true, completion: nil)
                       
                   }
                   MBProgressHUD.hide(for: self.view, animated: true)
                   
                   return
               }
               if response != nil{
                _ = [String:Any]()
                   MBProgressHUD.hide(for: self.view, animated: true)
                if response?.description == "true"{
                    let errorMessage = "applied_success".localized
                   let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                   alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                }else{
                    let errorMessage = response?.dictionaryObject?["message"] as? String ?? "not_valid".localized
                    let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
               }
           }
           
       }
    
    
    /*
     * Function : getCouponApiCall
     * Params   : url, param
     * Modified : 3rd August 2020
     * Modified By : Nitikesh Pattanayak
     */
    func getCouponApiCall(url:String,param : Any){
        
        //Turning on the Loader
        MBProgressHUD.showAdded(to: view, animated: true)
        
        //Generating Coupon URL using Couponcode provided by User
        let couponUrl = url + "/" + coupon
        
        //Sending put request without any params. But with generated url to Magento 2.2.5
        ApiManager.apiPut(url: couponUrl, params: [:]) { (response, error) in
            
            //If The application is offline, then it should show the No Internet Connection Screen
            if let error = error{
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    //Presenting the no internet connection screen
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                //Hiding the Loader if screen got presented!
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
                // Statuscode has been checked in the apiPut function. if statusCode is not 200 then response will come nil always. If status code is 200 then it will return one JSON type object.
                if response != nil{
                    if response?.description == "true" {
                        self.tableView.reloadData()
                        self.viewModel.getCheckoutTotal(success: { (response) in
                                   print(response)
                           
                                   self.getCartTotal(response)
                                    CartDataModel.shared.setValue(self.data, cartTotal: response)

                               }) {
                                   // failure
                               }
                        MBProgressHUD.hide(for: self.view, animated: true)
                        _ = [String:Any]()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        //Showing Alert Message performing the API action
                        let successMessage = CommonUsed.globalUsed.couponSuccessMessage
                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                        
                        //Presenting the Alert in the page.
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        let successMessage:String = response?.dictionaryObject?["message"] as? String ?? ""
                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                        
                        //Presenting the Alert in the page.
                        self.present(alert, animated: true, completion: nil)
                        self.coupon = ""
                        self.tableView.reloadData()
                    //Turning off the Loader
                }
                }
                else{
                    
                    //Hiding the Loader if screen got presented!
                    
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }
        
    }
      
       func getVoucherApiCallForProduct(url:String,param : Any , controller:UIViewController){
           MBProgressHUD.showAdded(to: view, animated: true)
           ApiManager.apiPostWithHeader(url: url, params: param as! [String : Any]) { (response, error) in
               MBProgressHUD.hide(for: self.view, animated: true)
               if let error = error{
                   //print(error)
                   if error.localizedDescription.contains(s: "offline"){
                       let nextVC = NoInternetVC.storyboardInstance!
                       nextVC.modalPresentationStyle = .fullScreen
                       controller.present(nextVC, animated: true, completion: nil)
                       
                   }
                   MBProgressHUD.hide(for: self.view, animated: true)
                  
                   
                   return
               }
               if response != nil{
                if response?.description == "true" {
                     self.tableView.reloadData()
                  self.viewModel.getCheckoutTotal(success: { (response) in
                                                    print(response)
                                                    self.getCartTotal(response)
                                                     CartDataModel.shared.setValue(self.data, cartTotal: response)

                                                }) {
                                                    // failure
                                                }
                
                   MBProgressHUD.hide(for: self.view, animated: true)
                    let errorMessage = "applied_success".localized
                   let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                   alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
               }else{
                let errorMessage = response?.dictionaryValue["message"]?.stringValue
                                  let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                                  alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                                  self.present(alert, animated: true, completion: nil)
                    self.voucher = ""
                    self.tableView.reloadData()
               }
               }else{
                self.voucher = ""
                self.tableView.reloadData()
            }
        }
    }
       
    
    func showPickerView() {
        sizePickerView.delegate = self
        sizePickerView.backgroundColor = UIColor.white
        sizePickerView.setValue(UIColor.black, forKey: "textColor")
        sizePickerView.autoresizingMask = .flexibleWidth
        sizePickerView.contentMode = .center
        sizePickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sizePickerView)
        
        self.addToolbar()
        self.view.addSubview(toolbar)
    }
    func addToolbar(){
        toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonClicked))]
    }
    @objc func doneButtonClicked(_ sender:Any){
        self.tableView.reloadData()
        self.sizePickerView.removeFromSuperview()
        self.toolbar.removeFromSuperview()
    }
    @IBAction func onClickNo(_ sender: Any) {
        viewDelete.isHidden = true
    }
    @IBAction func onClickNoGift(_ sender: Any) {
        viewDeleteGiftCard.isHidden = true
    }
    @IBAction func onClickYesGift(_ sender: Any) {
        removeVoucher()
    }
    
    @IBAction func onClickYes(_ sender: Any) {
      removeCoupon()
    }
    
    
    func removeCoupon(){
        let url = M2_Coupon_Remove
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.apiDeleteWithHeader(url: url, params: [:]) { (response, error) in
            if let error = error{
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    //Presenting the no internet connection screen
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                //Hiding the Loader if screen got presented!
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
                // Statuscode has been checked in the apiPut function. if statusCode is not 200 then response will come nil always. If status code is 200 then it will return one JSON type object.
                if response != nil{
                    if response?.description == "true" {
                        self.tableView.reloadData()
                        self.viewModel.getCheckoutTotal(success: { (response) in
                                   print(response)
                                   self.getCartTotal(response)
                                    CartDataModel.shared.setValue(self.data, cartTotal: response)

                               }) {
                                   // failure
                               }
                        MBProgressHUD.hide(for: self.view, animated: true)
                        _ = [String:Any]()
                        DispatchQueue.main.async {
                            self.coupon = ""
                            self.tableView.reloadData()
                        }
                        
                        //Showing Alert Message performing the API action
//                        let successMessage = "Deleted Successfully !"
//                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
//
//                        //Presenting the Alert in the page.
//                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        let successMessage:String = response?.dictionaryObject?["message"] as? String ?? ""
                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                        
                        //Presenting the Alert in the page.
                        self.present(alert, animated: true, completion: nil)
                        self.coupon = ""
                    //Turning off the Loader
                }
                }
                else{
                    
                    //Hiding the Loader if screen got presented!
                    
            }
            self.viewDelete.isHidden = true
            self.coupon = ""
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }
    }
    @IBAction func onClickProceed(_ sender: Any) {
        if isWrapGiftShow{
           
        giftWrapParam?.from = strGiftFrom
        giftWrapParam?.to = strGiftTo
        giftWrapParam?.message = strGiftMsg
        }
        if UserDefaults.standard.value(forKey: "userToken") == nil {
            let loginVC = LoginViewController.storyboardInstance!
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(loginVC, animated: false)
        }else if totalcartItems.count > 0{
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: ChekOutVC!
        changeVC = storyboard.instantiateViewController(withIdentifier: "ChekOutVC") as? ChekOutVC
            changeVC.checkoutOrderSummary = priceCategoryValue
            changeVC.checkoutCategories = priceCategories
            changeVC.tbleData_CheckoutCategories = tblData_PriceCategories
            changeVC.tbleData_CheckoutOrderSummary = tblData_PriceCategoryValue
            changeVC.totalCount = totalcartItems.count
            changeVC.coupon = coupon
            changeVC.voucher = voucher
        self.navigationController?.pushViewController(changeVC, animated: true)
            
        }
    }
    @IBAction func onClickHelp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    @IBAction func onClickMenu(_ sender: UIButton) {
           
           switch sender.tag {
           case 0:
            self.tabBarController?.selectedIndex = 0
              
           case 1:
               print("")
           case 2:
               
               self.tabBarController?.selectedIndex = 2
           case 3:
               print("")
           case 4:
               print("")
           default:
               return
           }
       }
    
    @IBAction func editBtnAction(_ sender:UIButton){
        if isSelected {
            isSelected = false
            
            UIView.transition(with: tableView,
                              duration: 2,
            options: .transitionCrossDissolve,
            animations: {
                self.tableView.reloadData()
                 self.editBtn.underline("Edit".localized)
                
                self.cancelBtn.isHidden = false
                self.selectAllBtn.isHidden = true
                
            })
            
        }else{
            isSelected = true
            
            self.selectedItems = [Bool]()
            for _ in 0..<cartItems.count{
                selectedItems.append(false)
            }
            
            UIView.transition(with: tableView,
                              duration: 2,
            options: .transitionCrossDissolve,
            animations: {
                self.tableView.reloadData()
                
                self.editBtn.underline("Cancel".localized)
                self.cancelBtn.isHidden = true
                self.selectAllBtn.isHidden = false
                
            })
        }
    }
    
    @IBAction func selectAllBtnAction(_ sender:UIButton){
        for index in 0..<cartItems.count{
            selectedItems[index] = true
        }
        UIView.transition(with: tableView,
                                        duration: 2,
                                        options: .transitionCrossDissolve,
                                        animations: {
                                          self.tableView.reloadData()
                                          
                      })
    }
    
    @IBAction func cancelBtnAction(_ sender:UIButton){
        self.tabBarController?.selectedIndex = 0
    }
    @objc func moveHomeScree(_ sender:UIButton){
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 0)
        })
    }
//    @IBAction func ongiftApply(_ sender: Any) {
//          if(M2_isUserLogin){
//
//           getgiftCardApiCallForProduct(url: M2_giftCard + "/" + voucher , param: [:], controller: self)
//            }
//          else{
//            let errorMessage = CommonUsed.globalUsed.guestVoucherMessage
//            let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//          //voucher = ""
//       }
        @IBAction func onCoupenApply(_ sender: Any) {
            //Calling Set Coupon API for Guest as well as Loggedin Users
          //  getCouponApiCall(url: M2_coupon, param: [:])
            
            //coupon = ""
       }
    
    @objc func onclickApplyCoupon(_ sender:UIButton){
        getCouponApiCall(url: M2_coupon, param: [:])
    }
    
    @objc func onclickApplyVoucher(_ sender:UIButton){
        
//        {
//          "giftCardAccountData": {
        
//            "gift_cards": [
//              "8TYB3OK3G7CC"
//            ]
//          }
//        }
        if(M2_isUserLogin == false){
            let notAuthenticatedMessage = "login_before_use".localized
            let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:notAuthenticatedMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
            
                self.present(alert, animated: true, completion: nil)
            self.voucher = ""
            tableView.reloadData()
        }
        else{
        afterOrderCreate = false
        var arrayGiftCard = [String]()
        arrayGiftCard.append(voucher)
        let param = ["gift_cards":arrayGiftCard]
        let finalParam = ["giftCardAccountData":param]
       getVoucherApiCallForProduct(url: M2_giftCard, param: finalParam, controller: self)
        }
    }
 
    func setEmptyView(){
      
               
               lblemptyHeader.text = "Your shopping bag is empty".localized
               lblEmptyDesc.text = "browseCatlogMessage".localized
               btnStartShopping.titleLabel?.font = UIFont(name: "BrandonGrotesque-Light", size: 15.0)
               btnStartShopping.addTarget(self, action:  #selector(moveHomeScree(_:)), for: .touchUpInside)
   
    }
    func moveToLoginScreen(){
        let loginVC = LoginViewController.storyboardInstance!
                            let transition = CATransition()
                            transition.duration = 0.5
                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                            transition.type = kCATransitionPush
                            transition.subtype = kCATransitionFromTop
                              
                          self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                          self.navigationController?.pushViewController(loginVC, animated: false)
    }
}
extension ShoppingBagVC: MainCartProtocol{
    func deleteProduct(_ cell: BagCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let items = cartItems[indexPath.row]
         MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.deleteItem(items, success: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
        } )
    }
    
    func addToWishList(_ cell: BagCell) {
        guard self.tableView.indexPath(for: cell) != nil else {
            return
        }
         let indexPath = self.tableView.indexPath(for: cell)!
        
        if isWishListProduct(productId: cell.product_Sku_id) {
                if UserDefaults.standard.value(forKey: "userToken") == nil {
                    self.moveToLoginScreen()
                }else {
                    let sourceDataModel = self.skuSourseData[self.cartItems[indexPath.row].sku!] as! Hits.Source
                    var params:[String:Any] = [:]
                    params["product_id"] = sourceDataModel.id
                    params["sku"] = sourceDataModel.sku
                     MBProgressHUD.showAdded(to: self.view, animated: true)
                    ApiManager.removeWishList(params: params, success: { (response) in
                        print(response)
                          MBProgressHUD.hide(for: self.view, animated: true)
                        DispatchQueue.main.async {
                            cell.btnAddToWishlist.setImage(UIImage(named: "Default"), for: .normal)
                            self.refreshview()
                        }
                    }) {
                       MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
        }else{
                if UserDefaults.standard.value(forKey: "userToken") == nil {
                    self.moveToLoginScreen()
                }else {
                    var params:[String:Any] = [:]
                    params["product_id"] = cell.product_id
                    params["sku"] = cell.product_Sku_id
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    ApiManager.addTowishList(params: params, success: { (response) in
                        print(response)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        DispatchQueue.main.async {
                            cell.btnAddToWishlist.setImage(UIImage(named: "Selected"), for: .normal)
                            self.refreshview()
                        }
                    }) {
                      MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
        }
        

//         var params:[String:Any] = [:]
//        params["product_id"] = cell.product_id
//        params["sku"] = cell.product_Sku_id
//       // let items = cartItems[indexPath.row]
//       // viewModel.addToWishList(params)
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        ApiManager.addTowishList(params: params, success: { (response) in
//                   print(response)
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.refreshview()
//               }) {
//
//               }
    }
    
    func previousAction(_ cell: BagCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
       
        let items = cartItems[indexPath.row]
     
        let qty = (items.qty ?? 0) - 1
        
        viewModel.delegate = self
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.updateCartItemQuantity(qty:qty  , model:items, navigationController: self.navigationController!)
        
    }
    
    func nextAction(_ cell: BagCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let items = cartItems[indexPath.row]
        let qty = (items.qty ?? 0) + 1
        viewModel.delegate = self
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.updateCartItemQuantity(qty:qty  , model:items, navigationController: self.navigationController!)
    }
    
    func selectItems(_ cell:BagCell){
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        selectedItems[indexPath.row] =  !selectedItems[indexPath.row]
        
        UIView.transition(with: tableView,
                          duration: 2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tableView.reloadData()
                            
        })
    }
    
    func sizeDropDownAction(_ cell: BagCell) {
        let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
        let changeVC: AddToBagPopUp
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddToBagPopUp") as! AddToBagPopUp
        changeVC.comingScreen = "ShoppingBagVC"
        changeVC.delegate = self
        changeVC.cartItems = self.cartItems
        changeVC.itemId = cartItems[cell.rowNumber!].itemID!
        let ci: String = cartItems[cell.rowNumber!].sku ?? ""
        changeVC.cart_source_data = self.skuSourseData[ci] as? Hits.Source
        //changeVC.cart_source_data = productData?.hits?.hitsList[cell.rowNumber!]._source
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    
}
extension ShoppingBagVC: AddToBagPopUpDelegate, ShoppingBagViewModelDelegate{
    func showPopUpErrorMessage(response: [String : Any]) {
        
    }
    
    func refreshview(){
        updateValues()
        MBProgressHUD.hide(for: self.view, animated: true)
        isSelected = false
        viewModel.getCartItems(success: { (response) in
            print("getCartItems===========>",response)
           let quoteid:Int = response.id ?? 0
                       if(quoteid != 0){
                           globalQuoteId = String(quoteid)
                       }
            self.setCartData(response)
        }) {
            //Failure
        }
    }
}


extension ShoppingBagVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSize = sizeArray[row]
    }
}
extension ShoppingBagVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if tableView == self.tableView{
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BagCell.identifier, for: indexPath) as? BagCell else {
                fatalError("Cell can't be dequeue")
            }
            
            let model = cartItems[indexPath.row]
            if (self.skuData[cartItems[indexPath.row].sku!] != nil) {
              
                
                let size = self.skuData[cartItems[indexPath.row].sku!]  as! [String :Any]
                cell.selectedSize = "\(getSizeValueById(id: size["size"]! as! Int))"
                let sourceData = self.skuSourseData[cartItems[indexPath.row].sku!] as! Hits.Source
                _ = (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                let priceFinel =  Double(size["final_price"] as? Double  ?? 0).clean
                let currencyStr = (UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
                cell.lblPrice.text =  "\(priceFinel) " + "\((currencyStr))".localized
                
               // cell.lblPrice.text = String(format:"%.2f",Double(size["final_price"] as? Double ?? 0.0).roundToDecimal(2)) + " " + finalPrice.localized
                cell.lblBrand.text = getBrandName(id: String(sourceData.manufacturer))
                cell.imgProduct.image = nil
                cell.imgProduct.contentMode = .scaleAspectFit
                cell.imgProduct.sd_setImage(with: URL(string: CommonUsed.globalUsed.kimageUrl + sourceData.image), placeholderImage: UIImage(named: "imagePlaceHolder"))
                globalProducts = self.skuSourseData
                childrenData = self.skuData
                cell.product_id = sourceData.id
                cell.product_Sku_id = sourceData.sku
                if isWishListProduct(productId: String(sourceData.sku)){
                    cell.btnAddToWishlist.setImage(UIImage(named: "Selected"), for: .normal)
                }else{
                    cell.btnAddToWishlist.setImage(UIImage(named: "Default"), for: .normal)
                }
            }
            cell.cellConfiguration(model)
            cell.selectionStyle = .none
            cell.lblTag.isHidden = true
            cell.delegate = self
            cell.rowNumber = indexPath.row
            
            
            if isSelected {
                cell.selectBtn.isHidden = false
                cell.bottomButtonStackViewConstraint.constant = 0
                cell.bottomButtonSeperatorHeightConstraint.constant = 0
                cell.selectBtnWidthConstraint.constant = 50
                cell.checkUncheckedImg.isHidden = false
                cell.btnRemove.isHidden = true
                cell.btnAddToWishlist.isHidden = true
                
                if selectedItems.count > 0  &&
                    selectedItems.count >= indexPath.row && selectedItems[indexPath.row]{
                    cell.checkUncheckedImg.image =  UIImage(named: "radio_on")
                }else{
                    cell.checkUncheckedImg.image = UIImage(named: "radio_off")
                }
            }else{
                cell.selectBtn.isHidden = false
                cell.checkUncheckedImg.isHidden = true
                cell.bottomButtonStackViewConstraint.constant = 53
                cell.bottomButtonSeperatorHeightConstraint.constant = 20
                cell.selectBtnWidthConstraint.constant = 0
                cell.btnRemove.isHidden = false
                cell.btnAddToWishlist.isHidden = false
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnPrev)
                 Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnNext)
                cell.btnRemove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.btnAddToWishlist.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: cell.btnPrev)
                 Common.sharedInstance.rotateButton(aBtn: cell.btnNext)
                cell.btnRemove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
                cell.btnAddToWishlist.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                cell.btnAddToWishlist.titleLabel?.font = Common.sharedInstance.brandonLight(asize: 9)
            }
            return cell
        }else if indexPath.section == 1{
            if isSelected{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CartEditBottomTableViewCell.identifier, for: indexPath) as? CartEditBottomTableViewCell else {
                    fatalError("Cell can't be dequeue")
                }
                
                return cell
            }else {
                //return UITableViewCell()
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RedeemEGiftTableViewCell.identifier, for: indexPath) as? RedeemEGiftTableViewCell else {
                    fatalError("Cell can't be dequeue")
                }
                if voucher != ""{
                    cell.btnApply.isHidden = true
                    cell.stackViewCorrect.isHidden = false
                    cell.btnClose.tag = indexPath.row
                    cell.redeemGiftTextField?.text = voucher
                    cell.btnClose.addTarget(self, action: #selector(onClickCloseVoucher(_:)), for: .touchUpInside)
                }else{
                cell.redeemGiftTextField.text = ""
                 cell.stackViewCorrect.isHidden = true
                cell.delegate = self
                cell.btnApply.isHidden = false
                cell.btnApply.tag = indexPath.row
                cell.btnApply.addTarget(self, action:#selector(onclickApplyVoucher(_:)), for: .touchUpInside)
                }
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnApply)
                }
                else{
                    Common.sharedInstance.rotateButton(aBtn: cell.btnApply)
                }
                return cell
            }
        }else if indexPath.section == 2{
            guard let cell =
                tableView.dequeueReusableCell(withIdentifier: RedeemVoucherTableViewCell.identifier, for: indexPath) as? RedeemVoucherTableViewCell else {
                fatalError("Cell can't be dequeue")
            }
            if coupon != ""{
                cell.btnApply.isHidden = true
                cell.stackViewCorrect.isHidden = false
                cell.btnClose.tag = indexPath.row
                cell.btnClose.addTarget(self, action: #selector(onClickClose(_:)), for: .touchUpInside)
                cell.redeemVoucherTextField.text = coupon
            }else{
                cell.redeemVoucherTextField.text = ""
                cell.stackViewCorrect.isHidden = true
                cell.btnApply.isHidden = false
            cell.btnApply.tag = indexPath.row
                       cell.btnApply.addTarget(self, action:#selector(onclickApplyCoupon(_:)) , for: .touchUpInside)
            }
            cell.delegate = self
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnApply)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: cell.btnApply)
            }
           
            return cell
        }else if indexPath.section == 3{
            //return UITableViewCell()
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: WrapGiftTableViewCell.identifier, for: indexPath) as? WrapGiftTableViewCell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.txtFrom.delegate = self
            cell.txtTo.delegate = self
            cell.txtMessage.delegate = self
            cell.btnGiftWrap.tag = indexPath.row
            cell.btnGiftWrap.addTarget(self, action: #selector(onClickGiftWrap(_:)), for: .touchUpInside)
            cell.delegate = self
            return cell
 
        }else if indexPath.section == 4{
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: CartSummaryTableViewCell.identifier, for: indexPath) as? CartSummaryTableViewCell else {
                fatalError("Cell can't be dequeue")
            }
            let items = "items".localized
            cell.itemCount.text = "\(totalcartItems.count) \(items)"
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                cell.itemCount.textAlignment = .right
                cell.lblTitle.textAlignment = .left
            }
            else{
                cell.itemCount.textAlignment = .left
                cell.lblTitle.textAlignment = .right
            }
            return cell
        }else if indexPath.section == 5{
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell else {
                fatalError("Cell can't be dequeue")
            }
            if  tblData_PriceCategories[indexPath.row].contains("Gift") || tblData_PriceCategories[indexPath.row].contains("Discount") {
                if tblData_PriceCategories[indexPath.row] == "Discount"{
                    let localizedValue = tblData_PriceCategories[indexPath.row].localized
                    let couponName = coupon
                    cell.lblType.text = "\(localizedValue) (\(couponName))"
                }else{
                    cell.lblType.text = tblData_PriceCategories[indexPath.row].localized
                }
                let price1 = Double(tblData_PriceCategoryValue[indexPath.row]).clean
                cell.lblPrice.text = "\(price1) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
               // cell.lblPrice.text = "\(priceCategoryValue[indexPath.row]) " +  UserDefaults.standard.string(forKey: "currency")!.localized
                cell.lblPrice.textColor = .red
            }else if tblData_PriceCategories.count > 1 {
                cell.lblPrice.textColor = .black
                cell.lblType.text = tblData_PriceCategories[indexPath.row].localized
                
                let price2 = Double(tblData_PriceCategoryValue[indexPath.row]).clean
                cell.lblPrice.text = "\(price2) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
            }else if tblData_PriceCategories[indexPath.row].contains("Grand Total") {
                cell.lblPrice.textColor = .black
                cell.lblType.text = tblData_PriceCategories[indexPath.row].localized
                if tblData_PriceCategories.count > 1{
                    let price2 = Double(tblData_PriceCategoryValue[indexPath.row]).clean
                    cell.lblPrice.text = "\(price2) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                }else   {
                    let price2 = Double(tblData_PriceCategoryValue[indexPath.row + 1]).clean
                    cell.lblPrice.text = "\(price2) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                }
               
            }
            else{
                cell.lblPrice.textColor = .black
                cell.lblType.text = tblData_PriceCategories[indexPath.row].localized
                
                let price2 = Double(tblData_PriceCategoryValue[indexPath.row]).clean

                let currency: String = (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                cell.lblPrice.text = "\(price2) " +  currency

                
               // cell.lblPrice.text = "\(priceCategoryValue[indexPath.row]) " +  UserDefaults.standard.string(forKey: "currency")!.localized
            }
            if tblData_PriceCategories[indexPath.row].contains("Grand Total") {
//                cell.lblType.font = UIFont.boldSystemFont(ofSize: 15.0)
//                cell.lblPrice.font = UIFont.boldSystemFont(ofSize: 15.0)
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    cell.lblType.font = Common.sharedInstance.brandonMedium(asize: 16)
                    cell.lblPrice.font = Common.sharedInstance.brandonMedium(asize: 16)
                }
                else{
                    cell.lblType.font = UIFont(name: "Cairo-SemiBold", size: 16)
                    cell.lblPrice.font = UIFont(name: "Cairo-SemiBold", size: 16)
                }

            }else{
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    cell.lblType.font = UIFont(name: "BrandonGrotesque-Light", size: 16.0)
                    cell.lblPrice.font = UIFont(name: "BrandonGrotesque-Light", size: 16.0)
                }
                else{
                    cell.lblType.font = UIFont(name: "Cairo-Light", size: 16)
                    cell.lblPrice.font = UIFont(name: "Cairo-Light", size: 16)
                }

            }
            cell.selectionStyle = .none
            if indexPath.row % 2 != 1{
                cell.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            }else{
                cell.backgroundColor = .white
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                cell.lblType.textAlignment = .left
                cell.lblPrice.textAlignment = .right
            }
            else{
                cell.lblType.textAlignment = .right
                cell.lblPrice.textAlignment = .left
            }
            return cell
        }else if indexPath.section == 6{
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: HelpTableViewCell.identifier, for: indexPath) as? HelpTableViewCell else {
                fatalError("Cell can't be dequeue")
            }
            return cell
        }else {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: CartProceedTableViewCell.identifier, for: indexPath) as? CartProceedTableViewCell else {
                fatalError("Cell can't be dequeue")
            }
            return cell
        }
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
    @objc func onClickGiftWrap(_ sender:UIButton){
        if sender.currentImage == #imageLiteral(resourceName: "ic_switch_on") {
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
        }
    }
    
    @objc func onClickClose(_ sender:UIButton){
        viewDelete.isHidden = false
        //removeCoupon()
    }
    
    @objc func onClickCloseVoucher(_ sender:UIButton){
        viewDeleteGiftCard.isHidden = false
        //removeVoucher()
    }
    
    func removeVoucher(){
        let url = M2_GiftCard_Remove + voucher
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.apiDeleteWithHeader(url: url, params: [:]) { (response, error) in
            if let error = error{
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    //Presenting the no internet connection screen
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                //Hiding the Loader if screen got presented!
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
                // Statuscode has been checked in the apiPut function. if statusCode is not 200 then response will come nil always. If status code is 200 then it will return one JSON type object.
                if response != nil{
                    if response?.description == "true" {
                        self.strGift = ""
                        self.tableView.reloadData()
                        self.viewModel.getCheckoutTotal(success: { (response) in
                                   print(response)
                                   self.getCartTotal(response)
                                    CartDataModel.shared.setValue(self.data, cartTotal: response)

                               }) {
                                   // failure
                               }
                        MBProgressHUD.hide(for: self.view, animated: true)
                        _ = [String:Any]()
                        DispatchQueue.main.async {
                            self.voucher = ""
                            self.tableView.reloadData()
                        }
                        
                        //Showing Alert Message performing the API action
//                        let successMessage = "Deleted Successfully !"
//                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
//
//                        //Presenting the Alert in the page.
//                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        let successMessage:String = response?.dictionaryObject?["message"] as? String ?? ""
                        let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                        
                        //Presenting the Alert in the page.
                        self.present(alert, animated: true, completion: nil)
                        self.voucher = ""
                        self.tableView.reloadData()
                    //Turning off the Loader
                }
                }
                else{
                    self.voucher = ""
                    self.tableView.reloadData()
                    //Hiding the Loader if screen got presented!
                    
            }
            self.viewDeleteGiftCard.isHidden = true
           
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartItems.count > 0 {
           // self.tableView.restore()
            let topTitle = "SHOPPING BAG".localized
            self.lblTitle.text = "\(topTitle) (\(cartItems.count))"

            if section == 0{
                return cartItems.count
            }else if section == 5{
                return tblData_PriceCategories.count
            }else{
                return 1
            }
        }else{
           // self.tableView.setEmptyView()
            let topTitle = "SHOPPING BAG".localized
            self.lblTitle.text = "\(topTitle)"
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSelected{
            return 2
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
//             if isWrapGiftShow {
//                 return 60
//             }
             return 360
             //return 1
         }else if indexPath.section == 4 {
             //return 120 //order summery
             return 60
         }else if indexPath.section == 5 {
             return 54
         }else if indexPath.section == 6{
             return 173
         }else if indexPath.section == 7{
             return 140
         }

         else if indexPath.section == 1{
              return 213
             //return 1
         }
         else if indexPath.section == 2{
                 // return 233
             return 180
         }
         else{
             if isSelected && indexPath.section == 1 {
                 return 140
             }
             return UITableViewAutomaticDimension
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension ShoppingBagVC : WrapGiftTableViewProtocol {
    func wrapGiftShowOrHide(){
        isWrapGiftShow.toggle()
        
        UIView.transition(with: tableView,
                          duration: 3,
                          options: .showHideTransitionViews,
                          animations: {
                            self.tableView.reloadData()
                            
        })
    }
    
    func cartTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        
        print("txt ",textField.tag , "\(textField.text)\(string)")
        let text = textField.text! + string
        if textField.tag == 1001 {
                   coupon = text
               }else if textField.tag == 1002 {
            voucher = text
                   
               }
            //self.tableView.reloadData()
    }
    
    
}


extension ShoppingBagVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1003{
            strGiftFrom = textField.text ?? ""
        }else if textField.tag == 1004{
            strGiftTo = textField.text ?? ""
        }else{
            strGiftMsg = textField.text ?? ""
        }
    }
}
