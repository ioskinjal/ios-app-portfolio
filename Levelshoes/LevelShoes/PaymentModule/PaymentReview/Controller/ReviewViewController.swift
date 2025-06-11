//
//  ReviewViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import Firebase
import Adjust
import WebKit
import SwiftyGif

var orderId: String?
class ReviewViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var shimmeringImgView: UIImageView!
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    @IBOutlet weak var lblHeader: UILabel!{
        didSet{
            lblHeader.text = "checkout".localized
            lblHeader.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var btnPlaceorder: UIButton!{
        didSet{
            btnPlaceorder.setTitle("placeOrder".localized, for: .normal)
            btnPlaceorder.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }
    @IBOutlet weak var lblGranTotal: UILabel!{
        didSet{
            lblGranTotal.text = "Grand Total".localized
        }
    }
    @IBOutlet weak var lblVatInclusive: UILabel!{
        didSet{
            lblVatInclusive.text = "vatInclusive".localized
            lblVatInclusive.isHidden = shouldHideVatinclusive()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                totalAmountLabel.textAlignment = .right
            }else{
                totalAmountLabel.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var webView: WKWebView!
    
    var allSkus = ""
    
    let shoppingViewModel = ShoppingBagViewModel()
    var totalCarddata: CartTotalModel?
    var totalcartItems: [Item] = [Item]()
    var paymentTypeParam = ""
    var paymetId = ""
    var coupon = ""
    var voucher = ""
    var total = Int()
    var reviewaymentOrderSummary: [String: Any] = [:]
    var deliveryOptionDict: [String: Any] = [:]
    var addressArray: Addresses?
    let viewModel = CheckoutViewModel()
    var allAddressArray = [Addresses]()
    var data: CartModel?
    var priceCategories = [String]()
    var checkoutOrderSummary = [Double]()
    var tblData_PriceCategories = [String]()
    var tblData_CheckoutOrderSummary = [Double]()
    var applePayPaymentId = ""
    let date = Date()
    let formatter = DateFormatter()
    let transactionTimeFormater = DateFormatter()
    var isFromApplePay = false
    let orderIdFirst = "APP"
    var userLanguage = UserDefaults.standard.string(forKey:string.language)?.uppercased()
    var scheme = ""
    let orderIdSecondTerm = "800311"
    var countryID =  "UAE"
    var quoteId: String?
    var isFromclickAndCollect: Bool = false
    var tokenKey: String?
    var currency = getWebsiteCurrency()
    var paymentType: String?
    var cardEndingNumber: String?
    var deliveryType: String?
    var deliveryDate: String?
    var deliveryTime: String?
    var customerDict: Customer?
    var billingAddressArray : Addresses?
    // cart item array
    var itemList: NSMutableArray = []
    var content = [[String: String]]()
    var orderObj = [[String: String]]()
    var primaryVpnList = [String]()
    var giftcardAmount = 0.0
    var giftcardName = ""
    var viewCount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enable the Place Order button each time it gets loaded
        self.btnPlaceorder.isUserInteractionEnabled = true
        self.btnPlaceorder.backgroundColor = UIColor.black
        fetchAttributeeData()
        
        do {
            let gif = try UIImage(gifName: "shimmering.gif")
            self.shimmeringImgView.setGifImage(gif, loopCount: -1)
        } catch  {
            print(error)
        }
        
        if(isFromApplePay){
            self.shimmeringImgView.isHidden = false
        }
        else{
            self.shimmeringImgView.isHidden = true
        }
        //Formatter should always be english
        formatter.locale = Locale(identifier: "en")
        transactionTimeFormater.locale = Locale(identifier: "en")
        for i in allAddressArray{
           if i.defaultBilling == true {
                self.billingAddressArray = i
            }
        }
        if(userLanguage == "EN"){userLanguage = "EN"}
          else{userLanguage = "OR"}
       
        let countryCode = (UserDefaults.standard.string( forKey: "storecode")?.uppercased()  ?? "UAE")
        if(countryCode.uppercased() == "AE"){ countryID = (userLanguage ?? "EN") + "UAE" }
        else if(countryCode.uppercased() == "SA"){ countryID = (userLanguage ?? "EN") + "KSA" }
          else if(countryCode.uppercased() == "KW"){ countryID = (userLanguage ?? "EN") + "KWT" }
          else if(countryCode.uppercased() == "OM"){ countryID = (userLanguage ?? "EN") + "OMN" }
          else if(countryCode.uppercased() == "BH"){ countryID = (userLanguage ?? "EN") + "BHR" }
        else{
            countryID = (userLanguage ?? "EN") + countryCode
        }
        
        let cells =
            [PaymentFlowCell.className,OrderReviewTableViewCell.className,ReviewHomeAddressTableViewCell.className,ReviewDeliveryOptionTableViewCell.className,PaymentOptionTableViewCell.className,PriceCell.className, NeedHelpBtn.className,ReviewItemTableViewCell.className,ReviewTermsTableViewCell.className]
       
        tableView.register(cells)
        
        formatter.dateFormat = "yyyyMMdd"
        transactionTimeFormater.timeZone = TimeZone(abbreviation: "UTC")
        transactionTimeFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
        orderId = self.generateOrderID(firstValue: self.orderIdFirst, secondValue: self.orderIdSecondTerm, quoteId: CartDataModel.shared.getCart()?.items?[0].quoteID ?? "" , countryID: self.countryID)
        globalQuoteId = CartDataModel.shared.getCart()?.items?[0].quoteID ?? "0"
        guard let customer = CartDataModel.shared.getCart()?.customer else{
            return
        }
        customerDict = customer
        
        
    }
    func generateOrderID(firstValue: String, secondValue: String, quoteId: String, countryID: String ) -> String{
        if(globalQuoteId == "0"){
            globalQuoteId = (quoteId)
        }
        return "\(orderIdFirst)" + "\(countryID)" + "\(orderIdSecondTerm)" + "000000\(quoteId)"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.webView.navigationDelegate = self
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        self.shimmeringImgView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.initializeReviewController()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.shimmeringImgView.isHidden = false
    }
    func initializeReviewController(){
        var orderSummary = reviewaymentOrderSummary["orderSummary"] as? [Double]
               let currency = reviewaymentOrderSummary["currency"] ?? ""
              var totalAmount = 0.0
               if(checkoutOrderSummary.count == 6){totalAmount = checkoutOrderSummary[5]}
               else{totalAmount = checkoutOrderSummary[4]}
                if(checkoutOrderSummary.count == 7){totalAmount = checkoutOrderSummary[6]}
                
        if(!isFromApplePay){
                totalAmountLabel.text = currencyFormater(amount: totalAmount ) + " " + "\(currency)".localized
        }
        shoppingViewModel.getCheckoutTotal(success: { (response) in
                   print(response)
                   self.getCartTotal(response)
               }) {
                   // failure
               }
    }
    func getCartTotal(_ response: CartTotalModel){
        self.totalCarddata = response
        guard let items = self.totalCarddata?.items else {
            return
        }
        self.totalcartItems = items
        DispatchQueue.main.async {
           self.tableView.reloadData()
           self.view.setNeedsLayout()
            var addressLog = ""
            addressLog += String((self.addressArray?.customerId) ?? 0) + ","
            addressLog += String( "\(self.addressArray?.defaultShipping)" ) + ","
            addressLog += String( "\(self.addressArray?.defaultBilling)" ) + ","
            addressLog += String((self.addressArray?.firstname) ?? "") + ","
            addressLog += String((self.addressArray?.lastname) ?? "") + ","
            addressLog += String(self.addressArray?.telephone ?? "") + ","
            addressLog += String(getWebsiteCurrency()) + ","
            addressLog += String("\(self.totalcartItems)") + ","
            addressLog += "TotalAmount: " + String("\(self.totalCarddata?.baseGrandTotal)") + ""
            addinfoToFirebase(akey:  generateCurrentTimeStamp() + (orderId ?? "") + " - " + "PROCEED TO PAYMENT",  aVal: addressLog)
            if(self.isFromApplePay)
           {
            self.callOMSAPI(paymentId: self.applePayPaymentId)
            }
           //MBProgressHUD.hide(for: self.view, animated: true)
           
            self.shimmeringImgView.isHidden = true
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func placeOrderBtnAction(_ sender: UIButton) {
        for items: Item in totalcartItems{
            let dataModel:[CartItem]? = CartDataModel.shared.getCart()?.items?.filter { $0.itemID == items.itemID }
                allSkus += (dataModel?[0].sku as? String ?? "") + ","
        }
        callOmsStockCheckApi(skus: String(allSkus.dropLast()))
      
      
    }
    func getStoreCode()->String{
        let strCode:String = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")"
        let storeCode="\(UserDefaults.standard.value(forKey: "language") ?? "en")_\(strCode.uppercased())"
        return storeCode
    }
    
    func callOMSAPI(paymentId:String){
        
        
        
        // MBProgressHUD.showAdded(to: self.view, animated: true)
        self.shimmeringImgView.isHidden = false
        //Adding Item in Server
        var params: [String:Any] = [:]
        var customer: [String: Any] = [:]
        var shipping: [String: Any] = [:]
        var billing: [String: Any] = [:]
        var item:[[String:Any]] = [[String:Any]]()
        var itemData: [String:Any] = [:]
        var payment: [[String: Any]] = [[String:Any]]()
        var paymentDict: [String:Any] = [:]
        var voucherDict: [String:Any] = [:]
        var delivery: [String: Any] = [:]
        var charges: [String: Any] = [:]
        var bilingaddress: [String: Any] = [:]
        var shippingaddress: [String: Any] = [:]
        
        
        
        if isWrapGiftShow {
        params["giftreceipt"] = "Y"
        params["giftWraping_note_from_name"] = giftWrapParam?.from
        params["giftWraping_note_message"] = giftWrapParam?.message
        params["giftWraping_note_to_name"] = giftWrapParam?.to
        params["giftWraping_required"] = "Y"
        }
        params["businessDate"] = formatter.string(from: date)
        params["transactionTime"] = transactionTimeFormater.string(from: date)
        params["store"] = "8003"
        
        params["transactionType"] = "LAYINT"
        params["orderId"] = orderId
        params["transactionNumber"] = "3000001236"
        params["baseCurrency"] = getWebsiteCurrency()
        params["initiatedBy"] = "Mobileapp"
        params["locale"] = self.getStoreCode()
        params["status"] = "NEW"
        //params["isRetry"] = false
        
        customer["title"] = customerDict?.prefixField
        customer["firstName"] = customerDict?.firstname
        customer["lastName"] =  customerDict?.lastname
        customer["email"] =  customerDict?.email
        customer["phone"] = addressArray?.telephone
        customer["id"] =  customerDict?.id
        
        print(params)
        var firebaseItems = ""
        for items: Item in totalcartItems{
            let dataModel:[CartItem]? = CartDataModel.shared.getCart()?.items?.filter { $0.itemID == items.itemID }
            let sourceData = globalProducts[items.extensionAttributes?.sku ?? ""] as! Hits.Source
            firebaseItems += "{Primaryvpn: " + sourceData.sku + ", SKU: " + (dataModel?[0].sku ?? "") + " : QTY: " + String(items.qty!)
            
            firebaseItems =  firebaseItems + " : Amount: " + String(items.price!) + "},"
            
        }
        var output = "\(params) CUSTOMER: \(customer) Items: \(firebaseItems)"
        addinfoToFirebase(akey:  generateCurrentTimeStamp() + (orderId ?? "") + " - " + "PRE ORDER DETAILS",  aVal: output)
        
        if isFromclickAndCollect{
            delivery["type"] = "3000"
        }else if (deliveryOptionDict.count != 0 || addressArray?.city?.uppercased() == "DUBAI"){
            delivery["type"] = "1001"
        }else{
            delivery["type"] = "2000"
        }
       
        if isFromclickAndCollect == true{
            delivery["name"] = "Click And Collect"
            
           shipping["title"] = addressArray?.prefix
            shipping["firstName"] = addressArray?.firstname
            shipping["lastName"] = addressArray?.lastname
           shipping["phone"] = addressArray?.telephone
           shippingaddress["line1"] = CommonUsed.globalUsed.ccLine1
           shippingaddress["country"] = addressArray?.countryId
           //shippingaddress["postalCode"] = CommonUsed.globalUsed.ccPostalCode
           shippingaddress["city"] = CommonUsed.globalUsed.ccCity
           
          
            shipping["address"] = shippingaddress
             if addressArray?.defaultBilling == true{
                           billing["title"] = addressArray?.prefix
                           billing["firstName"] = addressArray?.firstname
                           billing["lastName"] = addressArray?.lastname
                           billing["phone"] = addressArray?.telephone
                           bilingaddress["line1"] = addressArray?.street[0]
                           bilingaddress["country"] =  addressArray?.countryId
                           //bilingaddress["postalCode"] = addressArray?.postcode
                           bilingaddress["city"] = addressArray?.city
                if((addressArray?.street.count ?? 0)! > 1){
                           bilingaddress["line2"] = addressArray?.street[1]
                }
                       }else{
                for i in 0..<allAddressArray.count{
                    if allAddressArray[i].defaultBilling == true{
                       addressArray = allAddressArray[i]
                        break
                    }
                }
                billing["title"] = addressArray?.prefix
                billing["firstName"] = addressArray?.firstname
                billing["lastName"] = addressArray?.lastname
                billing["phone"] = addressArray?.telephone
                bilingaddress["line1"] = addressArray?.street[0]
                bilingaddress["country"] =  addressArray?.countryId
                //bilingaddress["postalCode"] = addressArray?.postcode
                bilingaddress["city"] = addressArray?.city
                if((addressArray?.street.count ?? 0)! > 1){
                bilingaddress["line2"] = addressArray?.street[1]
                }
                       }
            billing["address"] = bilingaddress
           
            

        }else{
            
            delivery["name"] = "Express Delivery"
            //shipping["title"] = addressArray?.prefix
            shipping["firstName"] = addressArray?.firstname
            shipping["lastName"] = addressArray?.lastname
            shipping["phone"] = addressArray?.telephone
            shippingaddress["line1"] = addressArray?.street[0] ?? ""
            shippingaddress["country"] = addressArray?.countryId
            //shippingaddress["postalCode"] = addressArray?.postcode
            shippingaddress["city"] = addressArray?.city
            
            //Checking for Address 2 . If it exists or not #nitikesh
            if((addressArray?.street.count ?? 0)! > 1){
                shippingaddress["line2"] = addressArray?.street[1] ?? ""
            }
             shipping["address"] = shippingaddress
            
           // billing["title"] = addressArray?.prefix
            
             if addressArray?.defaultBilling == true{
                                      billing["title"] = addressArray?.prefix
                                      billing["firstName"] = addressArray?.firstname
                                      billing["lastName"] = addressArray?.lastname
                                      billing["phone"] = addressArray?.telephone
                                      bilingaddress["line1"] = addressArray?.street[0]
                                      bilingaddress["country"] =  addressArray?.countryId
                                      //bilingaddress["postalCode"] = addressArray?.postcode
                                      bilingaddress["city"] = addressArray?.city
                if((addressArray?.street.count ?? 0)! > 1){
                                      bilingaddress["line2"] = addressArray?.street[1]
                }
                                  }else{
                                      for i in 0..<allAddressArray.count{
                                                         if allAddressArray[i].defaultBilling == true{
                                                            addressArray = allAddressArray[i]
                                                             break
                                                         }
                                                     }
                                                     billing["title"] = addressArray?.prefix
                                                     billing["firstName"] = addressArray?.firstname
                                                     billing["lastName"] = addressArray?.lastname
                                                     billing["phone"] = addressArray?.telephone
                                                     bilingaddress["line1"] = addressArray?.street[0]
                                                     bilingaddress["country"] =  addressArray?.countryId
                                                     //bilingaddress["postalCode"] = addressArray?.postcode
                                                     bilingaddress["city"] = addressArray?.city
                if((addressArray?.street.count ?? 0)! > 1){
                                                     bilingaddress["line2"] = addressArray?.street[1]
                }
                                  }
            billing["address"] = bilingaddress
           
        }
        customer["shipTo"] = shipping
        customer["billTo"] = billing
        
      
        
        if(paymentTypeParam == "VOUCH"){paymentDict["paymentTypeId"] = 4050}
        if((totalCarddata?.baseGrandTotal ?? 0) != 0){
            if(paymentTypeParam == "CCARD" && self.isFromApplePay){ paymentDict["paymentTypeId"] = 6003 }
            else if(paymentTypeParam == "CCARD"){ paymentDict["paymentTypeId"] = 3000 }
            else if(paymentTypeParam == "CASH"){ paymentDict["paymentTypeId"] = 1000 }
            
            paymentDict["paymentType"] = paymentTypeParam
            paymentDict["amount"] = totalCarddata?.baseGrandTotal ?? 0
            paymentDict["paymentCurrency"] = getWebsiteCurrency()
            paymentDict["paymentCurrencyAmount"] = totalCarddata?.baseGrandTotal
            paymentDict["paymentId"] = paymentId
            if coupon != totalCarddata?.coupon_code {
                              paymentDict["coupon"] = totalCarddata?.coupon_code
                          }
        }
       
        var strGift = ""
        
        if (totalCarddata?.totalSegments?.count ?? 0) > 0{
            for i in 0..<(totalCarddata?.totalSegments?.count ?? 0)!{
                if totalCarddata?.totalSegments?[i].code == "giftcardaccount"{
                  
                        strGift = totalCarddata?.totalSegments?[i].extensionAttributes?.gift_cards ?? ""
                    
                }
        }
        }
        if(paymentDict.count > 0){
        payment.append(paymentDict)
        }
        if strGift != ""{
            let d = convertToArray(text: strGift)
                giftcardName = d?[0]["c"] as? String ?? ""
                giftcardAmount = d?[0]["ba"] as? Double ?? 0
                    voucherDict["paymentType"] = "VOUCH"
                    voucherDict["paymentTypeId"] = 4050
                    voucherDict["amount"] = d?[0]["ba"]
                    voucherDict["paymentCurrency"] = getWebsiteCurrency()
                    voucherDict["paymentCurrencyAmount"] = d?[0]["ba"]
                    // voucherDict["paymentId"] = d?[0]["c"]
                    voucherDict["voucher"] = d?[0]["c"]
                     payment.append(voucherDict)
        }
       
         if coupon != totalCarddata?.coupon_code {
            charges["discount"] = totalCarddata?.baseDiscountAmount
        }
        var grandTotal = totalCarddata?.baseGrandTotal
        if(voucherDict["amount"] as? Double ?? 0.0 != 0.0){
            grandTotal = (grandTotal ?? 0.0) + (voucherDict["amount"] as? Double ?? 0.0)
        }
        charges["subtotal"] = (totalCarddata?.subtotalInclTax)!
        charges["total"] = grandTotal
        charges["discount"] = totalCarddata?.discountAmount
        charges["discountTaxPercentage"] = 0
        charges["discountTaxAmount"] = 0
        
        charges["taxAmount"] = totalCarddata?.taxAmount
        charges["shippingCharges"] = totalCarddata?.shippingInclTax
        if(Double(totalCarddata?.shippingTaxAmount ?? 0.0) > 0.0){
            charges["shippingTaxPercentage"] = ((totalCarddata?.shippingInclTax)! / (totalCarddata?.shippingTaxAmount)!).roundToDecimal(2)
        }
        else{
            charges["shippingTaxPercentage"] = 0
        }
        charges["shippingTaxAmount"] = totalCarddata?.shippingTaxAmount
        var count = 0
        var specialSubTotal = 0.0
        var totalDiscount = 0.0
        for items: Item in totalcartItems{
            let dataModel:[CartItem]? = CartDataModel.shared.getCart()?.items?.filter { $0.itemID == items.itemID }
            itemData = [:]
            itemData["sku"] =  dataModel?[0].sku ?? ""
            allSkus += itemData["sku"] as! String + ","
            itemData["comments"] = ""
            itemData["quantitySign"] = "P"
            itemData["quantity"] = items.qty
            
            let cartItems = globalCartDetails[count] as Item?
            let discountAmount = (items.baseDiscountAmount ?? 0.0) / Double(items.qty ?? 1)
            let stupidDiscountAmount = discountAmount + (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)) - (items.priceInclTax ?? 0.0)
            specialSubTotal = specialSubTotal + (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0))
            totalDiscount = totalDiscount + (stupidDiscountAmount * Double(items.qty ?? 1))
                itemData["discountAmount"] = stupidDiscountAmount//(items.baseDiscountAmount ?? 0.0) / Double(items.qty ?? 1)
            //Logic carts Mine with Carts Total temporary #nitikesh will be removed in future once naga will provide zone in total
           
           if(CommonUsed.globalUsed.zoneList.contains(cartItems?.extensionAttributes?.zone ?? 0)){
               itemData["concessionSku"] = cartItems?.extensionAttributes?.lvl_concession_core_sku
           }else{
               itemData["concessionSku"] = ""
           }
            let taxAmount = ((items.taxAmount ?? 0.0) /  Double(items.qty ?? 1)).roundToDecimal(2)
                       itemData["taxAmount"] = taxAmount
            if((items.baseDiscountAmount ?? 0.0) != 0.0){
                if(getWebsiteCurrency() == "SAR"){
                    itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2) - taxAmount
                }
                else if (customDuties != 0.0){
                    itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2) - taxAmount
                }
                else{
                     itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2)
                }
                itemData["productPricePaid"] = (items.priceInclTax ?? 0.0) - ((items.baseDiscountAmount ?? 0.0) / Double(items.qty ?? 1))
            }
            else{
                 if(getWebsiteCurrency() == "SAR"){
                    itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2) - taxAmount
                 }
                 else if (customDuties != 0.0){
                    itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2) - taxAmount
                 }
                 else{
                     itemData["unitRetail"] = (Double(cartItems?.extensionAttributes?.originalRowTotal ?? 0.0) / Double(items.qty ?? 1)).roundToDecimal(2)
                }
                itemData["productPricePaid"] = items.priceInclTax ?? 0.0
            }
           
            itemData["taxPercentage"] = items.taxPercent ?? 0
        
            itemData["vpn"] = ""
            
           
            
            
            charges["taxPercentage"] = items.taxPercent ?? 0
            count = count + 1
            item.append(itemData)
            let sourceData = globalProducts[cartItems?.extensionAttributes?.sku ?? ""] as! Hits.Source
            //adding cart item for analytics
            var selectedProduct: [String: Any] = [
                AnalyticsParameterItemID: sourceData.sku ,//@Nitikesh parent id will be here
                AnalyticsParameterItemName: items.name ?? "",
                AnalyticsParameterPrice: (items.priceInclTax ?? 0.0) / 1000000,
            
                AnalyticsParameterQuantity: items.qty ?? 0,
                AnalyticsParameterItemCategory: getCategoryName(id: String(sourceData.lvl_category)),//@Nitikesh category will be here
                //AnalyticsParameterItemCategory2: getColorName(id: String(sourceData.color)),//@Nitikesh
                AnalyticsParameterItemBrand: getBrandName(id: String(sourceData.manufacturer)),
                AnalyticsParameterCoupon: coupon,
            ]
            self.primaryVpnList.append(sourceData.sku)
            // Specify order quantity
            selectedProduct[AnalyticsParameterQuantity]  = items.qty
            //selectedProduct[AnalyticsParameterPrice] = "\(items.price ?? 0)"
            print("selectedProduct \(selectedProduct)")
            itemList.add(selectedProduct)
            
            //adding cart item for Adjust:content field
            let contentValue: [String: String] = ["id": "\( sourceData.sku)"]//@Nitikesh parent id will come here
            let contentValue1: [String: String] = ["quantity": "\(items.qty ?? 0)"]
            self.content.append(contentValue)
            self.content.append(contentValue1)
 
            orderObj = content
        }
        charges["subtotal"] = specialSubTotal
        charges["discount"] = totalDiscount
        if(getWebsiteCurrency() == "SAR"){
             customDuties = (totalCarddata?.taxAmount)!
             itemData = [:]
             itemData["sku"] = CommonUsed.globalUsed.customDutySku
            
             itemData["comments"] = "Custom Duty Charge"
             itemData["quantitySign"] = "P"
             itemData["quantity"] = 1
             itemData["discountAmount"] = 0
             itemData["unitRetail"] = customDuties.roundToDecimal(2)
             itemData["productPricePaid"] = customDuties.roundToDecimal(2)
             itemData["taxAmount"] = 0
             itemData["taxPercentage"] = 0
             item.append(itemData)
             customDuties = 0.0
        }
        if(customDuties != 0.0){
            itemData = [:]
            itemData["sku"] = CommonUsed.globalUsed.customDutySku
           
            itemData["comments"] = "Custom Duty Charge"
            itemData["quantitySign"] = "P"
            itemData["quantity"] = 1
            itemData["discountAmount"] = 0
            itemData["unitRetail"] = ((Double(customDuties) / 100) * (totalCarddata?.subtotal ?? 0.0) ).roundToDecimal(2)
            itemData["productPricePaid"] = ((Double(customDuties) / 100) * (totalCarddata?.subtotal ?? 0.0) ).roundToDecimal(2)
            itemData["taxAmount"] = 0
            itemData["taxPercentage"] = 0
            item.append(itemData)
        }
        params["customer"] = customer
        params["payment"] = payment
        params["items"] = item
        params["delivery"] = delivery
        params["charges"] = charges
        
        //print(params)
        addinfoToFirebase(akey:   generateCurrentTimeStamp() + (orderId ?? "") + " - " + "POSTPAYMENT", aVal: "\(params)")
        UserDefaults.standard.set(params, forKey: "omsParam")
        
        self.viewModel.OMSOrder(params, success: { (response) in
            
            //print(response)
            customDuties = 0.0
            afterOrderCreate = true
            addinfoToFirebase(akey:  generateCurrentTimeStamp() + (orderId ?? "") + " - " + "OMS RESPONSE", aVal: " Success")
            self.redeemGiftcard(orderid: orderId ?? "")
            self.InActiveCart()
            
        }) {(errorResponse) in
            print(errorResponse)
            addinfoToFirebase(akey:   (orderId ?? "") + " - " + "OMS RESPONSE", aVal: " Failure")
        }
    }
    func redeemGiftcard(orderid: String){
        let cards1 = [self.giftcardName : self.giftcardAmount]
        let cards = ["cards": cards1, "order": orderid] as [String : Any]
        let param = ["cards": cards]
        ApiManager.redeemGiftcardAfteruse(params: param,success: { (response) in
        }){}
    }
    func InActiveCart(){
        var params: [String:Any] = [:]
        var quote: [String:Any] = [:]
        var customer: [String:Any] = [:]
        if(globalQuoteId == "0"){
            let quoteId = CartDataModel.shared.getCart()?.items?[0].quoteID ?? "0"
            globalQuoteId = String(quoteId)
        }
        if(globalQuoteId != "0"){
        quote["id"] = globalQuoteId
        }
        quote["is_active"] = false
        quote["store_id"] = customerDict?.storeId
        customer["id"] = customerDict?.id
        quote["customer"] = customer
        params["quote"] = quote

        self.viewModel.inActiveCart(params, success: {
            DispatchQueue.main.async {
                
                // Google Analytics
                self.analyticsEventPurchase()
                self.shimmeringImgView.isHidden = true
                let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                let changeVC: OrderConfermationViewController!
                changeVC = storyboard.instantiateViewController(withIdentifier: "OrderConfermationViewController") as? OrderConfermationViewController
                 changeVC.orderId = orderId ?? ""
                changeVC.confirmpaymentOrderSummary = self.checkoutOrderSummary
                changeVC.priceCategories = self.priceCategories
                changeVC.confirmpaymentOrderSummary = self.checkoutOrderSummary
                changeVC.currency = self.currency
                changeVC.addressArray = self.addressArray
                //MBProgressHUD.hide(for: self.view, animated: true)
                self.shimmeringImgView.isHidden = true
                self.navigationController?.pushViewController(changeVC, animated: true)
            }
        }) {
            
        }
    }
    // MARK: - // Google Analytics
    func analyticsEventPurchase() {
        // Prepare purchase params
        //print("amount value =\(currencyFormater(amount: checkoutOrderSummary[4]))")
        //print("purchase amount = \(checkoutOrderSummary[4])")
        var totalAmount = 0.0
        if(checkoutOrderSummary.count == 6){totalAmount = checkoutOrderSummary[5]}
        else{totalAmount = checkoutOrderSummary[4]}
        if(checkoutOrderSummary.count == 7){totalAmount = checkoutOrderSummary[6]}
        
        
        var purchaseParams: [String: Any] = [
          AnalyticsParameterTransactionID: orderId ?? "",
          AnalyticsParameterAffiliation: "Apple Store",
          AnalyticsParameterCurrency: self.currency,
          AnalyticsParameterValue: totalAmount,
        ]

        // Add items
        purchaseParams[AnalyticsParameterItems] = self.itemList
        
        // Log purchase event
        Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams)
       // Analytics.logEvent("Purchase", parameters: purchaseParams)

        //**************** Adjust Event Tracking:uoiccc ************
        Adjust.trackSubsessionStart()

        let purchaseEvent = ADJEvent.init(eventToken: "uoiccc")
        purchaseEvent?.addPartnerParameter("p_product_id", value: self.primaryVpnList.joined(separator:","))//@Nitikesh parent id will be here
        purchaseEvent?.addPartnerParameter("content", value: content.description)
        purchaseEvent?.addPartnerParameter("content_type", value: "product")
        purchaseEvent?.addPartnerParameter("order_id", value: "\(orderId ?? "")")
        purchaseEvent?.addPartnerParameter("order_obj", value: orderObj.description)
        purchaseEvent?.addPartnerParameter("revenue", value: String(totalAmount))
        purchaseEvent?.addPartnerParameter("currency", value: "\(self.currency)")
        purchaseEvent?.addPartnerParameter("criteo_partner_id", value: "com.levelshoes.ios")
        purchaseEvent?.setRevenue(totalAmount, currency: currency)
        
        //purchaseEvent?.transactionId = orderId!
        Adjust.trackEvent(purchaseEvent)
        
        
       /* let revenueEvent = ADJEvent.init(eventToken: "uoiccc")
        revenueEvent?.revenue = String(totalAmount)
        revenueEvent?.currency = "\(self.currency)"
        revenueEvent?.addPartnerParameter("revenue", value: String(totalAmount))
        revenueEvent?.addPartnerParameter("currency", value: "\(self.currency)")
        Adjust.trackEvent(revenueEvent)*/
        //**************** Adjust Event Tracking: nrfotm ************
        
        Adjust.trackSubsessionStart()
        
        let new_customer_Event = ADJEvent.init(eventToken: "nrfotm")
        new_customer_Event?.addPartnerParameter("revenue", value: String(totalAmount))
        new_customer_Event?.addPartnerParameter("order_id", value: "\(orderId ?? "")")
        new_customer_Event?.addPartnerParameter("currency", value: "\(self.currency)")
        Adjust.trackEvent(new_customer_Event)
 
    }
}
extension ReviewViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6{
            return tblData_CheckoutOrderSummary.count
        }else{
        return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentFlowCell", for: indexPath) as? PaymentFlowCell else{return UITableViewCell()}
            cell.shippingImageView.image = #imageLiteral(resourceName: "check_payment")
            cell.paymentImageView.image = #imageLiteral(resourceName: "check_payment")
            cell.imgRemainStep.isHidden = true
            cell.reviewImageView.image = UIImage(named: "inprogress_option")
          //  cell.reviewLabel.textColor = UIColor.black
          //  cell.reviewLabel.font = UIFont(name:"brandon-grotesque-medium", size: 16.0)
           // cell.paymentLabel.textColor = UIColor.black
           // cell.paymentLabel.font = UIFont(name:"brandon-grotesque-medium", size: 16.0)
           // cell.shippingLabel.textColor = UIColor.black
           // cell.shippingLabel.font = UIFont(name:"brandon-grotesque-medium", size: 16.0)
            return cell
        }
        if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewTableViewCell", for: indexPath) as? OrderReviewTableViewCell else{return UITableViewCell()}
            if(isFromclickAndCollect){
                cell.lblShippingAddress.text = "billing_Add".localized.uppercased()
            }
            else{
                cell.lblShippingAddress.text = "shipping_add".localized.uppercased()
            }
            
            return cell
        }
        if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewHomeAddressTableViewCell", for: indexPath) as? ReviewHomeAddressTableViewCell else{return UITableViewCell()}
            if isFromclickAndCollect == true{
                if addressArray?.company != nil{
                    cell.addressTypeLabel.text = "Work - " + (addressArray?.company)! 
                }else{
                    cell.addressTypeLabel.text = "Home"
                }
                 cell.addressDetailLabel.text = "\(addressArray?.firstname ?? "")" + " " + "\(addressArray?.lastname ?? "")" + "\n" + "\(addressArray?.street[0] ?? "")" + "\n" + "\(addressArray?.city ?? "")" + "," + "\(addressArray?.countryId ?? "")"
            }else{
                if addressArray?.company != nil{
                    cell.addressTypeLabel.text = "Work - " + (addressArray?.company)! ?? ""
                }else{
                    cell.addressTypeLabel.text = "Home"
                }
                cell.addressDetailLabel.text = "\(addressArray?.firstname ?? "")" + " " + "\(addressArray?.lastname ?? "")" + "\n" + "\(addressArray?.street[0] ?? "")" + "\n" + "\(addressArray?.city ?? "")" + "," + "\(addressArray?.countryId ?? "")"
            }
            cell.btnEditYourAddress.tag = indexPath.row
            cell.btnEditYourAddress.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
            
            return cell
        }
        if indexPath.section == 3{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewDeliveryOptionTableViewCell", for: indexPath) as? ReviewDeliveryOptionTableViewCell else{return UITableViewCell()}
            if deliveryOptionDict.count == 0 && !isFromclickAndCollect{
                cell.deliveryDataLabel.text = "Express Delivery".localized
            }else if isFromclickAndCollect{
                cell.deliveryDataLabel.text = "Click and Collect".localized
            }
            else{
            cell.deliveryTimeLabel.text = deliveryOptionDict["deliveryTime"] as? String ?? ""
            cell.deliveryDataLabel.text = deliveryOptionDict["deliveryDate"] as? String ?? ""
            let dateformater = DateFormatter()
            dateformater.dateFormat = "yyyy-mm-dd"
                _ = dateformater.date(from: cell.deliveryDataLabel.text ?? "")
            dateformater.dateFormat = "dd MMMM, yyyy"
           // cell.deliveryDataLabel.text = "\(deliveryOptionDict["deliveryTime"] as? String ?? "") \(dateformater.string(from: date ?? Date()))"
            cell.deliveryTimeLabel.text = deliveryOptionDict["deliveryTime"]as? String ?? ""
            }
            cell.delegate = self
            return cell
        }
        if indexPath.section == 4{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionTableViewCell", for: indexPath) as? PaymentOptionTableViewCell else{return UITableViewCell()}
            if paymentTypeParam == "CCARD"{
                cell.cardEndingNumberLabel.text = "endingWith".localized +  " \(cardEndingNumber ?? "")"
                //need to enable for production
                if scheme == "Visa" {
                               //cell.cardImageView.image = #imageLiteral(resourceName: "creaditCard")
                               
                           }else if scheme == "American Express"{
                               //cell.cardImageView.image = #imageLiteral(resourceName: "AmericanExpress")
                           }else{
                               //cell.cardImageView.image = #imageLiteral(resourceName: "masterCard")
                           }
            }else{
            cell.cardEndingNumberLabel.isHidden = true
            }
            
            cell.cardTypeLabel.text = "\(paymentType ?? "")"
            cell.delegate = self
           
            return cell
        }
        if indexPath.section == 5{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewItemTableViewCell", for: indexPath) as? ReviewItemTableViewCell else{return UITableViewCell()}
            cell.viewSlideIndicator.numberOfItems = CartDataModel.cart?.items?.count ?? 0
           
            cell.reviewItemCollectionView.reloadData()
            
            return cell
        }
        if indexPath.section == 6{
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell else {
                fatalError("Cell can't be dequeue")
            }
            //if indexPath.row == 2 && priceCategories.count > 5 || indexPath.row == 1 {
            if  tblData_PriceCategories[indexPath.row].contains("Gift") || tblData_PriceCategories[indexPath.row].contains("Discount") {
                cell.lblType.text = tblData_PriceCategories[indexPath.row].localized.uppercased()
                
                cell.lblPrice.text = "\(currencyFormater(amount: tblData_CheckoutOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                cell.lblPrice.textColor = .red
            }
            else{
                cell.lblPrice.textColor = .black
                cell.lblType.text = tblData_PriceCategories[indexPath.row].localized
                cell.lblPrice.text = "\(currencyFormater(amount: tblData_CheckoutOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
            }
            if indexPath.row == self.tblData_PriceCategories.count - 1{
                cell.lblType.font = UIFont.boldSystemFont(ofSize: 15.0)
                cell.lblPrice.font = UIFont.boldSystemFont(ofSize: 15.0)
            }else{
                cell.lblType.font = UIFont(name: "BrandonGrotesque-Light", size: 15.0)
                cell.lblPrice.font = UIFont(name: "BrandonGrotesque-Light", size: 15.0)
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
        }
        if indexPath.section == 7{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedHelpBtn", for: indexPath) as? NeedHelpBtn else{return UITableViewCell()}
            cell.delegate = self
            return cell
        }
        if indexPath.section == 8{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTermsTableViewCell", for: indexPath) as? ReviewTermsTableViewCell else{return UITableViewCell()}
                   //cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func onClickEdit(_ sender:UIButton){
        editAcdres(selectedAddress: addressArray)
    }
    
    
    func editAcdres(selectedAddress:Addresses?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        changeVC.addressArray = allAddressArray
        changeVC.OrderSummary = reviewaymentOrderSummary["orderSummary"] as? [Double] ?? []
        changeVC.selectedAddress = selectedAddress
        changeVC.isFromEditAdd = true
        changeVC.priceCategories = priceCategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblData_PriceCategories
        changeVC.tblDataCheckoutOrderSummary = tblData_CheckoutOrderSummary
        self.navigationController?.pushViewController(changeVC, animated: true)
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 92.4
        }
        if indexPath.section == 1{
            return 130
        }
        if indexPath.section == 2{
            return 250
        }
        if indexPath.section == 3 {
            return 265
        }
        if indexPath.section == 4 {
            return 300
        }
        if indexPath.section == 5{
           return 500
        }
        if indexPath.section == 6{
                   return 54
               }

        if indexPath.section == 7{
            return 173
        }
        if indexPath.section == 8{
            return 120
        }

        return UITableViewAutomaticDimension
    }
}
extension ReviewViewController: ReviewDeliveryOptionPortocol,PaymentProtocol, NeedHelpProtocol {
    
    func currencyFormater(amount: Double)-> String{
        let largeNumber = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return amount.clean
        //return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }
    
    func needHelp() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    func editDeliveryOprion() {
        
               let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
               let changeVC: ChekOutVC!
                changeVC = storyboard.instantiateViewController(withIdentifier: "ChekOutVC") as? ChekOutVC
                changeVC.checkoutCategories = self.priceCategories

                changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                changeVC.totalCount = totalcartItems.count
                self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func editPaymentOption() {
        self.navigationController?.popViewController(animated: true)
        
    }
    func callOmsStockCheckApi(skus: String)
          {
              //MBProgressHUD.showAdded(to: self.view, animated: true)
        self.shimmeringImgView.isHidden = false
               let url = URL(string: CommonUsed.globalUsed.omsStockUrl)!
                      let params = [
                                 "api_user_id" : CommonUsed.globalUsed.omsUserId,
                                 "ean" : skus //111111,222222,333333,44444
                                 ] as [String : Any] as [String : Any]
                  
                      Alamofire.request(url,method: .post, parameters: params, headers: ["X-RUN-API-KEY":CommonUsed.globalUsed.omsATPApiKey,"Content-Type":"application/x-www-form-urlencoded"])
                          .responseJSON { (response) in
                              //MBProgressHUD.hide(for: self.view, animated: true)
                            self.shimmeringImgView.isHidden = true
                    
                              switch response.result {
                                         case .success(_):
                                         
                                             if let data = response.result.value as? [String : Any] {
                                                let soh = data["soh"] as? [[String:Any]] ?? [[String:Any]]()
                                                let allSku = skus.components(separatedBy: ",")
                                              var stockCount = 0
                                              for i in 0..<allSku.count{
                                                 
                                                  stockCount = stockCount +  self.checkStockForSku(sku: allSku[i], sohArray: soh)
                                              }
                                              
                                              if (soh.count > 0 && stockCount > 0) {
                                                    //Disable the Place Order Button
                                                    self.btnPlaceorder.isUserInteractionEnabled = false
                                                    self.btnPlaceorder.backgroundColor = UIColor.gray
                                               
                                                    if self.paymentTypeParam != "CCARD"{
                                                        self.callOMSAPI(paymentId: "")
                                                        }else{
                                                        self.callCheckoutAPI()
                                                        /* let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                                                         let changeVC: OrderConfermationViewController!
                                                         changeVC = storyboard.instantiateViewController(withIdentifier: "OrderConfermationViewController") as? OrderConfermationViewController
                                                         self.navigationController?.pushViewController(changeVC, animated: true)
                                                         */
                                                        }
                                                     self.dismiss(animated: true, completion: nil)
                                                     
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
                                            alert.addAction(UIAlertAction(title: "ok".localized.localized, style: UIAlertActionStyle.default, handler: nil))
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
//    func callCheckoutAPI(){
//         MBProgressHUD.showAdded(to: self.view, animated: true)
//        let orderSummary = reviewaymentOrderSummary["orderSummary"] as? [Double]
//        var dict: [String: Any] = [:]
//        var param: [String: Any] = [:]
//        var fixValue = Double()
//        var cartAmout = Double()
//        var finalAmout = Double()
//        if currency == "AED" || currency == "SAR"{
//            fixValue = 100.0
//            cartAmout  = (orderSummary?[4]) ?? 0.0
//            finalAmout = Double(fixValue) * cartAmout
//        }
//        if currency == "KWD" || currency == "OMR" || currency == "BHD"{
//            fixValue = 1000.0
//            cartAmout  = (orderSummary?[4]) ?? 0.0
//            finalAmout = Double(fixValue) * cartAmout
//        }
//        dict["type"] = "token"
//        dict["token"] = tokenKey
//        param["source"] = dict
//        param["amount"] = finalAmout
//        if(!CommonUsed.globalUsed.authCapture){
//        param["capture"] = CommonUsed.globalUsed.authCapture
//        }
//        param["currency"] = currency
//        param["reference"] = orderId
//
//        var dict3DS = [String:Any]()
//        dict3DS["enabled"] = true
//
//        param["3ds"] = dict3DS
//
//        self.viewModel.checkoutPayment(param, success: { (response) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            print(response)
//            DispatchQueue.main.async {
//                if(response["approved"] as? Int ?? 0 == 1){
//                    self.callOMSAPI(paymentId: response["id"] as? String ?? "")
//            }
//            else{
//                let successMessage:String = "Your payment didn't Went through!! Please check your Transaction Details and try again!"
//
//                let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
//                  alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
//
//                  let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
//                 let changeVC: ProceedToPaymentViewController!
//                  changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
//                  changeVC.isClickAndcollect = true
//                  changeVC.coupon = self.coupon
//                  changeVC.voucher = self.voucher
//                  changeVC.priceCategories = self.priceCategories
//                  changeVC.checkoutOrderSummary = self.checkoutOrderSummary
//
//
//                  changeVC.addressArray = self.allAddressArray
//                  changeVC.addressDict = self.allAddressArray.last
//                  self.navigationController?.pushViewController(changeVC, animated: true)
//                          //Presenting the Alert in the page.
//                  self.present(alert, animated: true, completion: nil)
//                // Payment Declined
//
//            }
//            }
//        }) {
//            let successMessage:String = "Your payment didn't Went through!! Please check your Transaction Details and try again!"
//
//            let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
//              alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let loadedURL = webView.url!.absoluteString
        //addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 2: ", aVal: " - inside 3ds - 1" + loadedURL)
        if let range = loadedURL.range(of: "?cko-session-id=") {
            let ac = loadedURL[range.upperBound...]
            if(self.viewCount == 0.0){
            self.viewCount += 1
            //addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 2: ", aVal: "\(ac) - inside 3ds - 1")
            self.webView.stopLoading()
            webView.stopLoading()
                self.webView.isHidden = true
                self.btnBack.isHidden = self.webView.isHidden == true ? false : true
                self.shimmeringImgView.isHidden = false
                print(ac)
                var request = URLRequest(url: URL(string: CommonUsed.globalUsed.checkoutPaymentUrl + "/" + ac)!)
                request.httpMethod = "GET"
                
                request.addValue(getCheckoutSecretKey(), forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    do {
                        
                        let response = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        //addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 3: ", aVal: "\(response) - inside 3ds - 2")
                        if((response["approved"] as? Int ?? 0) == 1){
                            DispatchQueue.main.async {
                                self.webView.isHidden = true
                                self.callOMSAPI(paymentId: response["id"] as? String ?? "")
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let str1 = "check_transaction".localized
                                let str2 = "facing_issue".localized
                                let successMessage:String = "\(str1) \n \(str2)"
                                self.shimmeringImgView.isHidden = true
                                let alert = UIAlertController(title:  "Payment failed", message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                                
                                //Presenting the Alert in the page.
                                self.present(alert, animated: true, completion: nil)
                                // Payment Declined
                            }
                        }
                        
                        
                    } catch {
                        print("error")
                        addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING -1: ", aVal: "ERROR - inside CATCH - 2")
                    }
                })
                
                task.resume()
            }
            
          }
        decisionHandler(.allow)
        
        
    }

    
    func callCheckoutAPI(){
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        self.shimmeringImgView.isHidden = false
        let orderSummary = reviewaymentOrderSummary["orderSummary"] as? [Double]
        
        var dict: [String: Any] = [:]
        var param: [String: Any] = [:]
        var fixValue = Double()
        var cartAmout = Double()
        var finalAmout = Double()
        if(checkoutOrderSummary.count == 6){cartAmout = checkoutOrderSummary[5]}
        else{cartAmout = checkoutOrderSummary[4]}
        if(checkoutOrderSummary.count == 7){cartAmout = checkoutOrderSummary[6]}
       
        finalAmout = cartAmout
       // if(orderSummary?.count == 6) {cartAmout = (orderSummary?[5]) ?? 0.0}
       // else{cartAmout = (orderSummary?[4]) ?? 0.0}
        if(currency == ""){
            currency = getWebsiteCurrency()
        }
       
        if currency == "AED" || currency == "SAR"{
            fixValue = 100.0
            //cartAmout  = (orderSummary?[4]) ?? 0.0
            finalAmout = Double(fixValue) * cartAmout
        }
        if currency == "KWD" || currency == "OMR" || currency == "BHD"{
            fixValue = 1000.0
            //cartAmout  = (orderSummary?[4]) ?? 0.0
            finalAmout = Double(fixValue) * cartAmout
        }
        dict["type"] = "token"
        dict["token"] = tokenKey
        param["source"] = dict
        param["amount"] = finalAmout
        if(!CommonUsed.globalUsed.authCapture){
            param["capture"] = CommonUsed.globalUsed.authCapture
        }
        param["currency"] = currency
        param["reference"] = orderId
        
        var dict3DS = [String:Any]()
        dict3DS["enabled"] = true
        
        param["3ds"] = dict3DS
        
        param["success_url"] = getWebsiteBaseUrl(with: "") + "payment-processing"
        param["failure_url"] = getWebsiteBaseUrl(with: "") + "payment-processing"
        addinfoToFirebase(akey:   generateCurrentTimeStamp() + (orderId ?? "") + " - " + "PREPAYMENT (CCARD)", aVal: "\(param)")
        //print(param)
        
        self.viewModel.checkoutPayment(param, success: { (response) in
            
            //print(response)
            DispatchQueue.main.async {
                //MBProgressHUD.hide(for: self.view, animated: true)
                self.shimmeringImgView.isHidden = true
                
                if let _ = response["3ds"] as? [String:Any]{
                    let responseDict = response["_links"] as! [String:Any]
                    let redirectDict = responseDict["redirect"] as! [String:Any]
                    
                    let link = redirectDict["href"] as? String ?? ""
                    
                    print(link)
                    
                    self.webView.isHidden = false
                    self.btnBack.isHidden = self.webView.isHidden == true ? false : true
                    self.shimmeringImgView.isHidden = true
                    //addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 0: ", aVal: "\(response) - inside 3ds")
                    let url = URL(string: link)
                    //addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 0.1: ", aVal: " - inside 3ds")
                    self.viewCount = 0.0
                    self.webView.load(URLRequest(url: url!))
                    self.webView.allowsBackForwardNavigationGestures = true
                   // addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 0.2: ", aVal: " - inside 3ds")
                    return
                }
                addinfoToFirebase(akey:   (orderId ?? "") + " - " + "LOGGING 1: ", aVal: "\(response) - outside 3ds")
                if((response["approved"] as? Int ?? 0) == 1){
                    self.callOMSAPI(paymentId: response["id"] as? String ?? "")
                }
                else{
                    let str1 = "check_transaction".localized
                    let str2 = "facing_issue".localized
                    let successMessage:String = "\(str1) \n \(str2)"
                    self.shimmeringImgView.isHidden = true
                    let alert = UIAlertController(title:  "Payment failed", message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    
                    let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                    let changeVC: ProceedToPaymentViewController!
                    changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
                    changeVC.isClickAndcollect = true
                    changeVC.coupon = self.coupon
                    changeVC.voucher = self.voucher
                    changeVC.priceCategories = self.priceCategories
                    changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                    
                    
                    changeVC.addressArray = self.allAddressArray
                    changeVC.addressDict = self.allAddressArray.last
                    self.navigationController?.pushViewController(changeVC, animated: true)
                    //Presenting the Alert in the page.
                    self.present(alert, animated: true, completion: nil)
                    // Payment Declined
                    
                }
            }
        }) {
            let str1 = "check_transaction".localized
            let str2 = "facing_issue".localized
            let successMessage:String = "\(str1) \n \(str2)"
            self.shimmeringImgView.isHidden = true
            let alert = UIAlertController(title:  "Payment failed", message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
    return (formatter.string(from: Date()) as NSString) as String
}
