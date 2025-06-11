//
//  ProceedToPaymentViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import PassKit
import Frames
import MBProgressHUD
var customDuties: Double = 0.0
class ProceedToPaymentViewController: UIViewController,ApplePayPaymentStatus {
    
    
    
    
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
    @IBOutlet weak var lblGrandtotal: UILabel!{
        didSet{
            lblGrandtotal.text = "Grand Total".localized
        }
    }
    @IBOutlet weak var lblVatinclusive: UILabel!{
        didSet{
            lblVatinclusive.text = "vatInclusive".localized
            lblVatinclusive.isHidden = shouldHideVatinclusive()
        }
    }
    @IBOutlet weak var orderReviewBtnOutlet: UIButton!{
        didSet{
            orderReviewBtnOutlet.setTitle("review_order".localized, for: .normal)
            orderReviewBtnOutlet.addTextSpacingButton(spacing: 1.5)
        }
    }
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var cardCvv = ""
    let cardExpairy = ""
    var cereditCardNo = ""
    var cardholdername = ""
    var cartData: CartModel?
    var isClickAndcollect: Bool = false
    var isCreditCard: Bool = false
    var isApplePay: Bool = true
    var isCashOnDelivery: Bool = false
    let orderIdFirst = "APP"
    var userLanguage = UserDefaults.standard.string(forKey:string.language)?.uppercased()
    var scheme = ""
    let orderIdSecondTerm = "800311"
    var countryID =  "UAE"
    var checkoutOrderSummary = [Double]()
    var tblDataCheckoutOrderSummary = [Double]()
    let viewModel = CheckoutViewModel()
    var data: AddressInformation?
    var coupon = ""
    var voucher = ""
    var priceCategories = [String]()
    var tblDataPriceCategories = [String]()
    let paymentHandler = PaymentHandler()
    var address: AddressInformation? = nil
    var addressDict: Addresses?
    var addressArray: [Addresses] = [Addresses]()
    var billingAddress : Addresses?
    let viewModelTotal = ShoppingBagViewModel()
    var totalCarddata: CartTotalModel?
    var cartItems: [CartItem] = [CartItem]()
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    let dateFormatter = DateFormatter()
    var isFirstTime = true
    var expiryDate = ""
    var reviewViewController : ReviewViewController?
    var orderInformation: [String: Any] = [:]
    var deliveryOptionDict: [String: Any] = [:]
    var customerData:AddressInformation?
    //var CCRowHieght : CGFloat = 510.0
    
    var CCRowHieght : CGFloat = UITableViewAutomaticDimension
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in addressArray{
            if i.defaultBilling == true{
                billingAddress = i
            }
        }
        let cells =
            [PaymentFlowCell.className, SecureTableViewCell.className, CreditCardTableViewCell.className,ApplePayTableViewCell.className,CashOnDeliveryTableViewCell.className,BillingAddressTableViewCell.className,OrderSummaryCell.className, NeedHelpBtn.className,CartSummaryTableViewCell.identifier,PriceCell.identifier,HDAddNewAddressTableCell.className]
        tableView.register(cells)
        datePicker.datePickerMode = .date
        let calendar = Calendar(identifier: .gregorian)
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
        
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = 0
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        let maxDate = calendar.date(byAdding: components, to: tenDaysfromNow)!
        components.year = -150
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    var tenDaysfromNow: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .year, value: 10, to: Date(), options: [])!
    }
    func getCartTotal(_ response: CartTotalModel){
        self.totalCarddata = response
        guard let items = self.totalCarddata?.items else {
            return
        }
        
        
        
        /*  if totalCarddata?.totalSegments?.count != 0{
         for i in 0..<(totalCarddata?.totalSegments!.count)!{
         if totalCarddata?.totalSegments?[i].code == "giftcardaccount"{
         strGift = totalCarddata?.totalSegments?[i].extensionAttributes?.gift_cards ?? ""
         }
         }
         }*/
        //        if strGift == "" {
        //            priceCategoryValue.remove(at: 2)
        //            priceCategories.remove(at: 2)
        //9
        //        }
        
        
        
        var strGift = ""
        for i in 0..<(totalCarddata?.totalSegments!.count)!{
                if totalCarddata?.totalSegments?[i].code == "giftcardaccount"{
                    strGift = totalCarddata?.totalSegments?[i].extensionAttributes?.gift_cards ?? ""
                }
        }
        if totalCarddata?.totalSegments?.count != 0{
        for i in 0..<(totalCarddata?.totalSegments!.count)!{
            if((totalCarddata?.totalSegments?[i].extensionAttributes?.taxGrandtotalDetails?.count ?? 0) > 0){

            for j in 0..<(totalCarddata?.totalSegments?[i].extensionAttributes?.taxGrandtotalDetails?.count ?? 0){
                let rate = totalCarddata?.totalSegments?[i].extensionAttributes?.taxGrandtotalDetails?[j].rates?[0]
                if(rate?.title == "Duties" || rate?.title == "الرسوم الجمركية" ){
                    customDuties = Double(rate?.percent ?? "0") ?? 0.0
                }
                }
                
            }
            }
        }
        
        
        //Giftcard Logic Implementation #Nitikesh
        var giftCardAmount = 0.0
        if strGift != ""{
            let d = convertToArray(text: strGift)
            let newGiftcard = "Gift Card".localized
            giftCardAmount = Double(d?[0]["ba"] as? Int ?? 0)
        }
        var isGiftcardAvailable = false
        if(checkoutOrderSummary.count == 6 || checkoutOrderSummary.count == 7){ isGiftcardAvailable = true}
        
        totalcartItems = items
        let subTotalInclTax = totalCarddata?.subtotalInclTax ?? 0.0
        let baseDiscountAmount = Double(totalCarddata?.baseDiscountAmount ?? 0)
        let shippingInclTax = Double(totalCarddata?.shippingInclTax ?? 0)
        let taxAmount = totalCarddata?.taxAmount ?? 0.0
        let grandTotal = Double(totalCarddata?.baseGrandTotal ?? 0)
        if(!isGiftcardAvailable){
            checkoutOrderSummary[0] = subTotalInclTax
            checkoutOrderSummary[1] = baseDiscountAmount
            checkoutOrderSummary[2] = shippingInclTax
            checkoutOrderSummary[3] = taxAmount
            checkoutOrderSummary[4] = grandTotal
            //checkoutOrderSummary(vat:checkoutOrderSummary[3])
        }else{
            checkoutOrderSummary[0] = subTotalInclTax
            checkoutOrderSummary[1] = baseDiscountAmount
            checkoutOrderSummary[2] = giftCardAmount
            checkoutOrderSummary[3] = shippingInclTax
            checkoutOrderSummary[4] = taxAmount
            checkoutOrderSummary[5] = grandTotal
        }
        
        
        let currency = orderInformation["currency"] ?? ""
        totalAmountLabel.text = currencyFormater(amount: grandTotal ) + " " + "\(currency)".localized

        if(grandTotal == 0){
            
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
            let changeVC: ReviewViewController!
            changeVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController
            if voucher != ""{
                changeVC.paymentTypeParam = voucher
            }
            
            changeVC.priceCategories = priceCategories
            changeVC.checkoutOrderSummary = checkoutOrderSummary
            changeVC.tblData_PriceCategories = tblDataPriceCategories
            changeVC.tblData_CheckoutOrderSummary = tblDataCheckoutOrderSummary
            changeVC.coupon = coupon
            changeVC.voucher = voucher
            changeVC.addressArray = self.addressDict
            changeVC.reviewaymentOrderSummary = self.orderInformation
            changeVC.isFromclickAndCollect = self.isClickAndcollect
            changeVC.deliveryOptionDict = self.deliveryOptionDict
            changeVC.allAddressArray = self.addressArray
            changeVC.paymentType = "Voucher"
            self.navigationController?.pushViewController(changeVC, animated: true)
        }
        
        
        
    }
    func callShippingCostApi(shippingAddress: Addresses, billingAddress: Addresses){
        
        var shippingParam: [String: Any] = [:]
        var billingParam: [String: Any] = [:]
        var addressInfo: [String: Any] = [:]
        var addressMainDict : [String: Any] = [:]
        var params: [String: Any] = [:]
        var lshippingAddress: [String: Any] = [:]
        var lbillingAddress: [String: Any] = [:]
        lshippingAddress["firstname"] = shippingAddress.firstname
        lshippingAddress["lastname"] = shippingAddress.lastname
        lshippingAddress["company"] = shippingAddress.company
        lshippingAddress["country_id"] = shippingAddress.countryId
        lshippingAddress["street"] = shippingAddress.street
        lshippingAddress["city"] = shippingAddress.city
        lshippingAddress["region"] = ""
        //addrParams["id"] = selectAddress?.id?.val
        lshippingAddress["postcode"] = shippingAddress.postcode
        lshippingAddress["telephone"] = "\(shippingAddress.telephone)"
        
        
        billingParam = lshippingAddress
        shippingParam = lshippingAddress
        var shippingCarrier = ""
        if(self.isClickAndcollect){  shippingCarrier = CommonUsed.globalUsed.clickandcollectCarrierCode }
        else{
            
            shippingCarrier = CommonUsed.globalUsed.homedeliveryCarrierCode
        }
        addressMainDict = ["shipping_address": shippingParam, "billing_address": billingParam, "shipping_carrier_code": shippingCarrier, "shipping_method_code": shippingCarrier]
        addressInfo["addressInformation"] = addressMainDict
        print(addressInfo)
        let jsonData = try! JSONSerialization.data(withJSONObject: addressInfo)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        print(jsonString)
        ApiManager.setShippingInformation(params: addressInfo, success: { (response) in
            self.viewModelTotal.getCheckoutTotal(success: { (response) in
                print(response)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.getCartTotal(response)
                //CartDataModel.shared.setValue(self.cartData, cartTotal: response)
                
            }) {
                // failure
            }
        }) { (errorResponse) in
            // failure(errorResponse)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        customDuties = 0.0
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if(isClickAndcollect){
            isCreditCard = true
            isApplePay = false
            isCashOnDelivery = false
        }
        globalQuoteId = CartDataModel.shared.getCart()?.items?[0].quoteID ?? "0"
        if(getWebsiteCurrency() != "AED" && getWebsiteCurrency() != "SAR"  ){
           isCreditCard = true
           isApplePay = false
           isCashOnDelivery = false
           }

        viewModel.getAddrssInformation(success: { (response) in
            self.data = response
            guard let items = self.data?.addresses else {
                return
            }
            
            
            self.addressArray = []
            if(items.count > 0){
                
                for i in 0...items.count-1{
                    
                    self.addressArray.append(items[i])
                    if(items[i].defaultBilling == true){
                        self.billingAddress=items[i]
                    }
                }}
            if(self.billingAddress == nil){
                //Temporary solution. If there is no default billing and default shipping  (But will act as permanent fix)
                self.billingAddress = self.addressDict
                
            }
            
            
            self.callShippingCostApi(shippingAddress: self.addressDict!, billingAddress: self.billingAddress!)
            
            //self.addressArray = items
            
        }) {
            //Failure
        }
        
        
        
        
        
        isFirstTime = true
        //self.tableView.reloadData()
        
        _ = orderInformation["orderSummary"] as? [Double]
        let currency = orderInformation["currency"] ?? ""
        var totalAmount = 0.0
        if(checkoutOrderSummary.count == 6){totalAmount = checkoutOrderSummary[5]}
        else{totalAmount = checkoutOrderSummary[4]}
        if(checkoutOrderSummary.count == 7){totalAmount = checkoutOrderSummary[6]}
       
        totalAmountLabel.text = currencyFormater(amount: totalAmount ) + " " + "\(currency)".localized
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func reviewOrderAction(_ sender: UIButton) {
        
        
        if isCreditCard{
            if isValid(){
                checkoutAction(cardNumber: cereditCardNo, expiary: cardExpairy, evv: cardCvv, name: cardholdername)
            }else{
                isFirstTime = false
                self.tableView.reloadData()
            }
        }else if isCashOnDelivery{
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
            let changeVC: ReviewViewController!
            changeVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController
            if self.isApplePay || self.isCreditCard && voucher == ""{
                changeVC.paymentTypeParam = "CCARD"
            }else if voucher != ""{
                changeVC.paymentTypeParam = voucher
            }
            else{
                changeVC.paymentTypeParam = "CASH"
            }
            changeVC.priceCategories = priceCategories
            changeVC.checkoutOrderSummary = checkoutOrderSummary
            changeVC.tblData_PriceCategories = tblDataPriceCategories
            changeVC.tblData_CheckoutOrderSummary = tblDataCheckoutOrderSummary
            changeVC.coupon = coupon
            changeVC.voucher = voucher
            changeVC.addressArray = self.addressDict
            changeVC.reviewaymentOrderSummary = self.orderInformation
            changeVC.isFromclickAndCollect = self.isClickAndcollect
            changeVC.deliveryOptionDict = self.deliveryOptionDict
            changeVC.allAddressArray = self.addressArray
            changeVC.paymentType = "Cash on delivery"
            self.navigationController?.pushViewController(changeVC, animated: true)
        }else{
            paymentHandler.delegate = self
            paymentHandler.startPayment(addressDict:addressDict, total: totalAmountLabel.text ?? "") { (success) in
                print("Apple Pay Success.........!")
            }
        }
    }
    
    
    func createCheckoutToken(paymentJSONResponse : AnyObject,currency: String, amount:Double){
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        var headerData = [String:Any]()
        headerData = paymentJSONResponse["header"] as! [String:Any]
        
        var tokenData = [String:Any]()
        tokenData["version"] = paymentJSONResponse["version"] as! String
        tokenData["data"] = paymentJSONResponse["data"] as! String
        tokenData["signature"] = paymentJSONResponse["signature"] as! String
        tokenData["header"] = headerData
        
        let params = ["type":"applepay", "token_data": tokenData] as [String:Any]
        
        var request = URLRequest(url: URL(string: CommonUsed.globalUsed.checkoutTokenUrl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue(getCheckoutPublicKey(), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                self.processCheckoutPayment(token: json["token"] as! String,currency: currency, amount:amount)
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    func generateOrderID(quoteId: String) -> String{
        if(globalQuoteId == "0"){
            globalQuoteId = (quoteId)
            
        }
        return "\(orderIdFirst)" + "\(countryID)" + "\(orderIdSecondTerm)" + "000000\(quoteId)"
    }
    func processCheckoutPayment(token : String,currency: String, amount:Double){
        var sourceData = [String:Any]()
        sourceData["type"] = "token"
        sourceData["token"] = token
        
        var params = [String:Any]()
        params["source"] = sourceData
        params["amount"] = amount
        params["currency"] = currency
        params["reference"] = generateOrderID(quoteId: globalQuoteId)
        addinfoToFirebase(akey:  generateOrderID(quoteId: globalQuoteId) + " - " + "AP", aVal: "\(params)")
        //print(params)
        var request = URLRequest(url: URL(string: CommonUsed.globalUsed.checkoutPaymentUrl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue(getCheckoutSecretKey(), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                DispatchQueue.main.async {
                    if((json["approved"] as? Int ?? 0) == 1){
                    
                      
                    let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                    let reviewViewController: ReviewViewController!
                    reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController
                    //self.reviewViewController = ReviewViewController()
                    reviewViewController?.isFromApplePay = true
                    reviewViewController?.applePayPaymentId = json["id"] as? String ?? ""
                    reviewViewController?.paymentTypeParam = "CCARD"
                    reviewViewController?.priceCategories = self.priceCategories
                    reviewViewController?.checkoutOrderSummary = self.checkoutOrderSummary
                    reviewViewController?.coupon = self.coupon
                    reviewViewController?.voucher = self.voucher
                    reviewViewController?.addressArray = self.addressDict
                    reviewViewController?.reviewaymentOrderSummary = self.orderInformation
                    reviewViewController?.isFromclickAndCollect = self.isClickAndcollect
                    reviewViewController?.deliveryOptionDict = self.deliveryOptionDict
                    reviewViewController?.allAddressArray = self.addressArray
                    reviewViewController?.paymentType = "Apple Pay"
                   // self.reviewViewController?.initializeReviewController()
                    //DispatchQueue.main.async {
                    //self.reviewViewController?.callOMSAPI(paymentId: "")
                    //}
                    self.navigationController?.pushViewController(reviewViewController, animated: true)
                
                    }
                    else{
                        let str1 = "check_transaction".localized
                        let str2 = "facing_issue".localized
                        let successMessage:String = "\(str1) \n \(str2)"
                        //self.shimmeringImgView.isHidden = true
                        let alert = UIAlertController(title:  "Payment failed", message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                        
                        //Presenting the Alert in the page.
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    func isValid() -> Bool{
        let cardUtils = CardUtils()
        if cardholdername.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 {
            self.tableView.reloadData()
            return false
        }
        if !cardUtils.isValid(cardNumber: cereditCardNo) {
            self.tableView.reloadData()
            return false
        }
        //Kanhiya to look
        
        if !(cardCvv.trimmingCharacters(in: .whitespacesAndNewlines).count == 3 && cardCvv.trimmingCharacters(in: .whitespacesAndNewlines).count <= 4) {
            self.tableView.reloadData()
            return false
        }
        return true
    }
    func creditCardAlert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension ProceedToPaymentViewController{
    @objc func doneDatePickerClicked(_ sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        expiryDate = formatter.string(from: datePicker.date)
        
        self.tableView.reloadData()
    }
}
extension ProceedToPaymentViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isClickAndcollect == true{
            return 9
        }
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 7 {
            return tblDataPriceCategories.count
        }
        if section == 5{
            if isClickAndcollect == true{
                return 1
            }else{
                return 1
            }
        }
        if section == 4{
            if isClickAndcollect == true{
                return 0
            }
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 92.4
        case 1: return 80
        case 2:
            print(CCRowHieght)
            if CCRowHieght > 30{
               return CCRowHieght - 30
            }
            else{
                return CCRowHieght
            }
        case 3:return 110
        case 4:return 145
        case 5: return 342
        case 6: return 90
        case 7: return 54
        case 8:return 173
            
        default:
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentFlowCell", for: indexPath) as? PaymentFlowCell else{return UITableViewCell()}
            cell.shippingImageView.image = #imageLiteral(resourceName: "check_payment")
            cell.shippingLabel.textColor = UIColor.black
            //  cell.shippingLabel.font = UIFont(name:"brandon-grotesque-medium", size: 16.0)
            
            cell.paymentImageView.image = #imageLiteral(resourceName: "check_payment")
            cell.imgRemainStep.isHidden = true
            cell.paymentLabel.textColor = UIColor.black
            //  cell.paymentLabel.font = UIFont(name:"brandon-grotesque-medium", size: 16.0)
            
            cell.reviewImageView.image = UIImage(named: "radio_off")
            cell.reviewLabel.textColor = UIColor(red: 199 / 255, green: 199 / 255, blue: 199 / 255, alpha: 1.0)
            //  cell.reviewLabel.font = UIFont(name:"brandon-grotesque-medium", size: 8.0)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecureTableViewCell", for: indexPath) as? SecureTableViewCell else{return UITableViewCell()}
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTableViewCell", for: indexPath) as? CreditCardTableViewCell else{return UITableViewCell()}
            cell.delegate = self
            cell.cardNumberTextField.delegate = self
            cell.creditCardHolderName.delegate = self
            cell.expiaryTxtField.delegate = self
            cell.securityCode.delegate = self
            
            if isCreditCard == true{
                if !isFirstTime{
                    if cardholdername.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 {
                        cell.errorCreditCard?.text = "please enter valid card name".localized
                        cell.errorCreditCard?.isHidden = false
                        cell.icCreditCard?.isHidden = false
                        cell.lineCreditCard?.backgroundColor = UIColor.red
                        cell.icCreditCard?.image = UIImage(named: "icn_error@2x.png")
                        cell.creditCardHolderName?.floatPlaceholderActiveColor = UIColor.red
                    }
                    else
                    {
                        cell.icCreditCard?.image = UIImage(named: "Successnew.png")
                        cell.errorCreditCard?.isHidden = true
                        cell.lineCreditCard?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        cell.creditCardHolderName?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        
                    }
                    
                    if (cereditCardNo.trimmingCharacters(in: .whitespacesAndNewlines).count < 13 || cereditCardNo.trimmingCharacters(in: .whitespacesAndNewlines).count > 19) {
                        cell.errorCardNumber?.text = "please enter valid card number".localized
                        cell.errorCardNumber?.isHidden = false
                        cell.icCardNumber?.isHidden = false
                        cell.lineCardNumber?.backgroundColor = UIColor.red
                        cell.icCardNumber?.image = UIImage(named: "icn_error@2x.png")
                        cell.cardNumberTextField?.floatPlaceholderActiveColor = UIColor.red
                    }
                    else
                    {
                        cell.icCardNumber?.image = UIImage(named: "Successnew.png")
                        cell.errorCardNumber?.isHidden = true
                        cell.lineCardNumber?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        cell.cardNumberTextField?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        
                    }
                    if expiryDate.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 {
                        
                        cell.errorExpiry?.text = "please enter expiry date".localized
                        cell.errorExpiry?.isHidden = false
                        cell.icExpiry?.isHidden = false
                        cell.lineExpiry?.backgroundColor = UIColor.red
                        cell.icExpiry?.image = UIImage(named: "icn_error@2x.png")
                        cell.expiaryTxtField?.floatPlaceholderActiveColor = UIColor.red
                    }
                    else
                    {
                        cell.icExpiry?.image = UIImage(named: "Successnew.png")
                        cell.errorExpiry?.isHidden = true
                        cell.lineExpiry?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        cell.expiaryTxtField?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        
                    }
                    
                    if (cardCvv.trimmingCharacters(in: .whitespacesAndNewlines).count < 3) || cardCvv.trimmingCharacters(in: .whitespacesAndNewlines).count > 4 {
                        cell.errorSecurityCode?.text = "please enter security code".localized
                        cell.errorSecurityCode?.isHidden = false
                        cell.icSecurity?.isHidden = false
                        cell.lineSecurityCode?.backgroundColor = UIColor.red
                        cell.icSecurity?.image = UIImage(named: "icn_error@2x.png")
                        cell.securityCode?.floatPlaceholderActiveColor = UIColor.red
                    }
                    else
                    {
                        cell.icSecurity?.image = UIImage(named: "Successnew.png")
                        cell.errorSecurityCode?.isHidden = true
                        cell.lineSecurityCode?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        cell.securityCode?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                        
                    }
                    
                    //                    cell.creditCardHolderName.delegate = self
                    //                    cell.cardNumberTextField.delegate = self
                    //                     cell.expiaryTxtField.delegate = self
                    //                     cell.securityCode.delegate = self
                }else{
                    cell.creditCardHolderName.text = ""
                    cell.errorCreditCard?.isHidden = true
                    cell.lineCreditCard?.backgroundColor = UIColor.black
                    cell.icCreditCard?.isHidden = true
                    cell.lineCreditCard?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    cell.creditCardHolderName?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    
                    cell.cardNumberTextField.text = ""
                    cell.errorCardNumber?.isHidden = true
                    cell.lineCardNumber?.backgroundColor = UIColor.black
                    cell.icCardNumber?.isHidden = true
                    cell.lineCardNumber?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    cell.cardNumberTextField?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    
                    cell.expiaryTxtField.text = ""
                    cell.errorExpiry?.isHidden = true
                    cell.lineExpiry?.backgroundColor = UIColor.black
                    cell.icExpiry?.isHidden = true
                    cell.lineExpiry?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    cell.expiaryTxtField?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    
                    cell.securityCode.text = ""
                    cell.errorSecurityCode?.isHidden = true
                    cell.lineSecurityCode?.backgroundColor = UIColor.black
                    cell.icSecurity?.isHidden = true
                    cell.lineSecurityCode?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    cell.securityCode?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                    
                    
                }
                
                
                
                cell.creditCardCheckBtnOutlet.setImage(UIImage(named: "radio_on"), for: .normal)
                cell.viewOne.isHidden = false
                cell.viewTwo.isHidden = false
                cell.viewThree.isHidden = false
                cell.viewFour.isHidden = false
                cell.viewBg.backgroundColor = .white
                cell.viewBg.layer.shadowColor = UIColor.black.cgColor
                              cell.viewBg.layer.shadowOpacity = 0.3
                              cell.viewBg.layer.shadowOffset = .zero
                              cell.viewBg.layer.shadowRadius = 5
            }else{
                cell.creditCardCheckBtnOutlet.setImage(UIImage(named: "radio_off"), for: .normal)
                cell.viewOne.isHidden = true
                cell.viewTwo.isHidden = true
                cell.viewThree.isHidden = true
                cell.viewBg.backgroundColor = UIColor.init(hexString: "FAFAFA")
                cell.viewFour.isHidden = true
                cell.viewBg.layer.shadowColor = UIColor.clear.cgColor
                cell.viewBg.layer.shadowOpacity = 0
                cell.viewBg.layer.shadowOffset = .zero
                cell.viewBg.layer.shadowRadius = 0
            }
            
            
            
            cell.expiaryTxtField.placeholder =  "MM/YY".localized
            // cell.expiaryTxtField.inputView = datePicker
            // cell.expiaryTxtField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneDatePickerClicked(_:)))
            cell.expiaryTxtField.text = expiryDate
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApplePayTableViewCell", for: indexPath) as? ApplePayTableViewCell else{return UITableViewCell()}
            cell.delegate = self
            if isApplePay == true{
                cell.applePayCheckBtnOutlet.setImage(UIImage(named: "radio_on"), for: .normal)
                cell.viewBg.backgroundColor = .white
                cell.viewBg.layer.shadowColor = UIColor.black.cgColor
                cell.viewBg.layer.shadowOpacity = 0.3
                cell.viewBg.layer.shadowOffset = .zero
                cell.viewBg.layer.shadowRadius = 5
            }else{
                cell.applePayCheckBtnOutlet.setImage(UIImage(named: "radio_off"), for: .normal)
                cell.viewBg.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
                cell.viewBg.layer.shadowColor = UIColor.clear.cgColor
                cell.viewBg.layer.shadowOpacity = 0
                cell.viewBg.layer.shadowOffset = .zero
                cell.viewBg.layer.shadowRadius = 0
            }
            var button: UIButton?
            let result = PaymentHandler.applePayStatus()
            
            if result.canMakePayments {
                button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
                button?.addTarget(self, action: #selector(payPressed), for: .touchUpInside)
            } else if result.canSetupCards {
                button = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
                button?.addTarget(self, action: #selector(setupPressed), for: .touchUpInside)
            }
            
            //            if let applePayButton = button {
            //                let constraints = [
            //                    applePayButton.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            //                    applePayButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
            //                ]
            //                applePayButton.translatesAutoresizingMaskIntoConstraints = false
            //  cell.addSubview(applePayButton)
            //NSLayoutConstraint.activate(constraints)
            //
            
            
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CashOnDeliveryTableViewCell", for: indexPath) as? CashOnDeliveryTableViewCell else{return UITableViewCell()}
            cell.delegate = self
            if isCashOnDelivery == true{
                cell.cashOnDeliveryCheckbtnoutlet.setImage(UIImage(named: "radio_on"), for: .normal)
                cell.cashOnDeliveryView.backgroundColor = .white
                cell.cashOnDeliveryView.layer.shadowColor = UIColor.black.cgColor
                cell.cashOnDeliveryView.layer.shadowOpacity = 0.3
                cell.cashOnDeliveryView.layer.shadowOffset = .zero
                cell.cashOnDeliveryView.layer.shadowRadius = 5
            }else{
                cell.cashOnDeliveryCheckbtnoutlet.setImage(UIImage(named: "radio_off"), for: .normal)
                cell.cashOnDeliveryView.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
                cell.cashOnDeliveryView.layer.shadowColor = UIColor.clear.cgColor
                cell.cashOnDeliveryView.layer.shadowOpacity = 0
                cell.cashOnDeliveryView.layer.shadowOffset = .zero
                cell.cashOnDeliveryView.layer.shadowRadius = 0
            }
            if(getWebsiteCurrency() != "AED"){
                cell.isHidden = true
            }
            return cell
            
        case 5:
            if addressDict != nil {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "BillingAddressTableViewCell", for: indexPath) as? BillingAddressTableViewCell else{return UITableViewCell()}
                cell.delegate = self
                if billingAddress?.customAttributes != nil{
                    for i in 0..<(billingAddress?.customAttributes!.count)!{
                        if billingAddress?.customAttributes?[i].attributeCode == "address_type" {
                            if billingAddress?.customAttributes?[i].value == "work"{
                                cell.addressTypeLabel.text =  "\(billingAddress?.customAttributes?[i].value ?? "") - \(billingAddress?.company ?? "")"
                            }else if billingAddress?.customAttributes?[i].value == "other"{
                                cell.addressTypeLabel.text =  "\(billingAddress?.customAttributes?[i].value ?? "") - \(billingAddress?.company ?? "")"
                            }else{
                                cell.addressTypeLabel.text = "\(billingAddress?.customAttributes?[i].value ?? "")"
                            }
                        }
                        
                        
                    }
                    
                }
                if(billingAddress?.company != nil){
                    cell.addressTypeLabel.text =  "\("Work") - \(billingAddress?.company ?? "")"
                }
                cell.addressDetailsLabel.text = "\(billingAddress?.firstname ?? "")" + " " + "\(billingAddress?.lastname ?? "")" + "\n" + "\(billingAddress?.street[0] ?? "")" + "\n" + "\(billingAddress?.city ?? "")" + "," + "\(billingAddress?.countryId ?? "")"
                cell.btnEdit.tag = indexPath.row
                cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
                return cell
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HDAddNewAddressTableCell", for: indexPath) as? HDAddNewAddressTableCell else{return UITableViewCell()}
                cell.delegate = self
                return cell
            }
            
        case 6:
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: CartSummaryTableViewCell.identifier, for: indexPath) as? CartSummaryTableViewCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.itemCount.text = "\(orderInformation["totalItemCount"] ?? 0)" + "items".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                cell.itemCount.textAlignment = .right
                cell.lblTitle.textAlignment = .left
            }
            else{
                cell.itemCount.textAlignment = .left
                cell.lblTitle.textAlignment = .right
            }
            return cell
        case 7:
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell else {
                fatalError("Cell can't be dequeue")
            }
            //if indexPath.row == 2 && priceCategories.count > 5 || indexPath.row == 1 {
            if  tblDataPriceCategories[indexPath.row].contains("Gift") || tblDataPriceCategories[indexPath.row].contains("Discount") {
                cell.lblType.text = tblDataPriceCategories[indexPath.row].localized
                cell.lblPrice.text = "\(currencyFormater(amount: tblDataCheckoutOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                cell.lblPrice.textColor = .red
            }
            else{
                cell.lblPrice.textColor = .black
                cell.lblType.text = tblDataPriceCategories[indexPath.row].localized
                cell.lblPrice.text = "\(currencyFormater(amount: tblDataCheckoutOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
            }
            if indexPath.row == self.tblDataPriceCategories.count - 1{
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
        case 8:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedHelpBtn", for: indexPath) as? NeedHelpBtn else{return UITableViewCell()}
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    @objc func onClickEdit(_ sender:UIButton){
        editAddress(selectedAddress: billingAddress)
    }
    
    
    func editAddress(selectedAddress:Addresses?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        changeVC.addressArray = addressArray
        
        // changeVC.OrderSummary = reviewaymentOrderSummary["orderSummary"] as? [Double] ?? []
        changeVC.selectedAddress = selectedAddress
        changeVC.isFromEditAdd = true
        changeVC.priceCategories = priceCategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblDataPriceCategories
        changeVC.tblDataCheckoutOrderSummary = tblDataCheckoutOrderSummary
        changeVC.isFromClickCollect = isClickAndcollect
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
}
extension ProceedToPaymentViewController:cashonDeliveryProtocol,applePayProtocol,creditCardProtocol,BillingAddressProtocol{
    
    
    func editBillingAddress() {
        
    }
    func currencyFormater(amount: Double)-> String{
        _ = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return amount.clean
        // return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? "0"
    }
    func creditCardEnable() {
        CCRowHieght = UITableViewAutomaticDimension
        isCreditCard = true
        isApplePay = false
        isCashOnDelivery = false
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3),IndexPath(row: 0, section: 4),IndexPath(row: 0, section: 2)], with: .none)
        self.tableView.endUpdates()
       // tableView.reloadData()
    }
    func cashOnDeliveryEnable() {
        CCRowHieght = 145.0
        isCreditCard = false
        isApplePay = false
        isCashOnDelivery = true
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3),IndexPath(row: 0, section: 4),IndexPath(row: 0, section: 2)], with: .none)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: false)
        //  tableView.reloadData()
        
        
    }
    func applePayEnable() {
        CCRowHieght = 145.0
        isCreditCard = false
        isApplePay = true
        isCashOnDelivery = false
        
      //  tableView.reloadData()
        
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3),IndexPath(row: 0, section: 4),IndexPath(row: 0, section: 2)], with: .none)
     
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: false)
       
        
    }
    
    
    
    @objc func payPressed(sender: AnyObject) {
        paymentHandler.startPayment(addressDict: addressDict, total: totalAmountLabel.text ?? "") { (success) in
            print("Apple Pay Success.........!")
        }
    }
    
    @objc func setupPressed(sender: AnyObject) {
        let passLibrary = PKPassLibrary()
        passLibrary.openPaymentSetup()
    }
    
}
extension ProceedToPaymentViewController: NeedHelpProtocol,AddNewAddressProtocol{
    func addNewAddress() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        changeVC.addressArray = addressArray
        changeVC.addCustomer = customerData
        changeVC.priceCategories = priceCategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblDataPriceCategories
        changeVC.tblDataCheckoutOrderSummary = tblDataCheckoutOrderSummary
        changeVC.OrderSummary = self.orderInformation["orderSummary"] as? [Double] ?? []
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func proceedToPayment() {
        if let Vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "OrderConfermationViewController") as? OrderConfermationViewController
        {
            Vc.addressArray = addressDict
            
            Vc.confirmpaymentOrderSummary = checkoutOrderSummary
            Vc.priceCategories = priceCategories
            Vc.tblConfirmpaymentOrderSummary = tblDataCheckoutOrderSummary
            Vc.tblPriceCategories = tblDataPriceCategories
            navigationController?.pushViewController(Vc, animated: true)
        }
    }
    
    
    func needHelp() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    func checkoutAction(cardNumber: String, expiary: String, evv: String, name: String ){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //let cardUtils = CardUtils()
        /// verify card number
        
        // let cardNumber = "4242424242424242"
        
        
        // let isCardValid = cardUtils.isValid(cardNumber: cardNumber)
        //if isCardValid
        // create the phone number
        let strCountryCode:String = UserDefaults.standard.value(forKey: "storecode") as? String ?? "ae"
        let countryCode:String = addressDict?.telephone ?? ""
        let strCode = String(countryCode).subStringWithRange(0, end: 1)
        let phoneNumber = CkoPhoneNumber(countryCode: strCode, number:String(countryCode))
        // create the address
        var address = CkoAddress()
        if addressDict?.street.count ?? 0 > 1{
                  address = CkoAddress(addressLine1: addressDict?.street[0], addressLine2:
                      addressDict?.street[1], city: addressDict?.city, state: addressDict?.city, zip: "00000", country:strCountryCode.uppercased())
              }else{
                  address = CkoAddress(addressLine1: addressDict?.street[0], addressLine2:
                      "", city: addressDict?.city, state: addressDict?.city, zip: "00000", country:strCountryCode.uppercased())
              }
        // create the card token request
        
        if(expiryDate.count <= 3){
            //expiryDate = "07/23"
            let successMessage = "Please correct the expiry date in the format MM/YY.".localized
            let alert = UIAlertController(title:  "Expiry Date is Invalid", message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
            MBProgressHUD.hide(for: self.view, animated: true)
            //Presenting the Alert in the page.
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        
        let array = expiryDate.components(separatedBy: "/")
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        let yearVal = dateFormatter.string(from: todaysDate as Date)
        print("year str = \(yearVal)")
        dateFormatter.dateFormat = "MM"
        let monthVal = dateFormatter.string(from: todaysDate as Date)
        print("month str = \(monthVal)")
        let enteredMonth = array[0]
        let enteredYear = array[1]
        
        if Int(enteredYear) ?? 0 < Int(yearVal) ?? 0 {
            let alertMessage = "Please correct the expiry year.".localized
            let alert = UIAlertController(title:  "Expiry Date is Invalid", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
            MBProgressHUD.hide(for: self.view, animated: true)
            //Presenting the Alert in the page.
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        if Int(enteredYear) ?? 0 == Int(yearVal) ?? 0 {
            if Int(enteredMonth) ?? 0 < Int(monthVal) ?? 0 {
                let alertMessage = "Please correct the expiry month.".localized
                let alert = UIAlertController(title:  "Expiry Date is Invalid", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                MBProgressHUD.hide(for: self.view, animated: true)
                //Presenting the Alert in the page.
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        }
        let cardTokenRequest = CkoCardTokenRequest(number: cardNumber, expiryMonth: array[0] , expiryYear: array[1] , cvv: cardCvv, name: cardholdername, billingAddress: address, phone: phoneNumber)
        
        var checkoutAPIClient = CheckoutAPIClient(publicKey: getCheckoutPublicKey(), environment: .sandbox)
        if(CommonUsed.globalUsed.environment == "production"){checkoutAPIClient = CheckoutAPIClient(publicKey: getCheckoutPublicKey(), environment: .live)}
        else{checkoutAPIClient = CheckoutAPIClient(publicKey: getCheckoutPublicKey(), environment: .sandbox)}
        
        // create the card token request
        checkoutAPIClient.createCardToken(card: cardTokenRequest, successHandler: { cardToken in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            let tokenData = cardToken.token
            print(cardToken)
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                let changeVC: ReviewViewController!
                changeVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController
                if self.isApplePay || self.isCreditCard{
                    changeVC.paymentTypeParam = "CCARD"
                }else{
                    changeVC.paymentTypeParam = "CASH"
                }
                
                changeVC.addressArray = self.addressDict
                changeVC.priceCategories = self.priceCategories
                changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                changeVC.reviewaymentOrderSummary = self.orderInformation
                changeVC.isFromclickAndCollect = self.isClickAndcollect
                changeVC.deliveryOptionDict = self.deliveryOptionDict
                changeVC.tokenKey = tokenData
                changeVC.allAddressArray = self.addressArray
                changeVC.scheme = cardToken.scheme ?? ""
                changeVC.cardEndingNumber = String(cardNumber.suffix(4))
                
                changeVC.paymentType = "Credit Card".localized
                self.navigationController?.pushViewController(changeVC, animated: true)
            }
        }, errorHandler:  { error in
            // error
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
}

//extension ProceedToPaymentViewController:UITextFieldDelegate{
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 0{
//            creditCardParm[1001] = textField.text
//        }else if textField.tag == 1{
//            creditCardParm[1002] = textField.text
//        }else if textField.tag == 2{
//            creditCardParm[1003] = textField.text
//        }else{
//            creditCardParm[1004] = textField.text
//        }
//
//    }
//}
extension ProceedToPaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1002 {
            // textField.floatPlaceholderActiveColor = .black
            let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
            if text.count > 19 {
                return false
            }else{
                
                return true
            }
        }
        if textField.tag == 1001{
            //  creditCardHolderName.floatPlaceholderActiveColor = .black
            let correctLetters = containsOnlyLetters(input: string)
            if(correctLetters){
                
                return true
            }
            else{
                return false
            }
            
        }
        if textField.tag == 1003 {
            // expiaryTxtField.floatPlaceholderActiveColor = .black
            //            if (textField.text?.count == 2) {
            //                                   //Handle backspace being pressed
            //                let month = Int(string) ?? 0
            //                                   if !(string == "" && month > 12) {
            //
            //                                       // append the text
            //                                       textField.text = (textField.text)! + "/"
            //                                   }else{
            //                                    return false
            //                }
            //        }
            //             let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
            //            if text.count > 5 {
            //                return false
            //            }else{
            //                self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
            //                return true
            //            }
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            if string == "" {
                
                if textField.text?.count == 3
                {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
                
                return true
            }
            
            if updatedText.count == 5
            {
                
                expDateValidation(dateStr:updatedText)
                return updatedText.count <= 5
            } else if updatedText.count > 5
            {
                return updatedText.count <= 5
            } else if updatedText.count == 1{
                if updatedText > "1"{
                    return updatedText.count < 1
                }
            }  else if updatedText.count == 2{   //Prevent user to not enter month more than 12
                if updatedText > "12"{
                    return updatedText.count < 2
                }
            }
            
            textField.text = updatedText
            
            
            if updatedText.count == 2 {
                
                textField.text = "\(updatedText)/"   //This will add "/" when user enters 2nd digit of month
            }
            
            //                return true
            
            return false
        }
        if textField.tag == 1004 {
            // securityCode.floatPlaceholderActiveColor = .black
            let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
            if text.count > 4 {
                return false
            }else{
                
                return true
            }
        }
            //        if textField == expiaryTxtField{
            //                if (textField.text?.count == 2) {
            //                        //Handle backspace being pressed
            //                        if !(string == "") {
            //                            // append the text
            //                            textField.text = (textField.text)! + "/"
            //                        }
            //                   self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
            //                    return !(textField.text!.count == 5 && (string.count ) > range.length)
            //                }else{
            //                    return true
            //            }
            //            }
        else{
            
            return true
        }
        // return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1001{
            cardholdername = textField.text ?? ""
        }else if textField.tag == 1002{
            cereditCardNo = textField.text ?? ""
        }else if textField.tag == 1003{
            expiryDate = textField.text ?? ""
        }else if textField.tag == 1004{
            cardCvv = textField.text ?? ""
        }
    }
    func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enterdYr > currentYear
        {
            if (1 ... 12).contains(enterdMonth){
                print("Entered Date Is Right")
            } else
            {
                print("Entered Date Is Wrong")
            }
            
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                    print("Entered Date Is Right")
                }  else
                {
                    print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else
        {
            print("Entered Date Is Wrong")
        }
        
    }
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ")  && !(chr == "'") && !(chr == ".") ) {
                return false
            }
        }
        return true
    }
}
