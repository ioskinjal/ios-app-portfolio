//
//  pickupAddress.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 07/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD

class pickupAddress: UIViewController {
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var returnHeader: headerOrderReturn!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "pickupAddress".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.text = "pickupDesc".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
               lblDesc.font = UIFont(name: "Cairo-SemiBold", size: lblDesc.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblNeedHelp: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNeedHelp.font = UIFont(name: "Cairo-Regular", size: lblNeedHelp.font.pointSize)
            }
            lblNeedHelp.text = "Need Help".localized.uppercased()
            lblNeedHelp.addTextSpacing(spacing: 1.5)
        }
    }
    
    @IBOutlet weak var lblHome: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblHome.font = UIFont(name: "Cairo-SemiBold", size: lblHome.font.pointSize)
            }
            lblHome.text = "home".localized
        }
    }
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblContinue: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblContinue.font = UIFont(name: "Cairo-Regular", size: lblContinue.font.pointSize)
            }
            lblContinue.text = "slideContinue".localized
            lblContinue.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblDefault: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDefault.font = UIFont(name: "Cairo-SemiBold", size: lblDefault.font.pointSize)
            }
            lblDefault.addTextSpacing(spacing: 1.07)
        }
    }
    
    @IBOutlet weak var lblReturnPolicy: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReturnPolicy.font = UIFont(name: "Cairo-SemiBold", size: lblReturnPolicy.font.pointSize)
            }
            lblReturnPolicy.text = "return_policy".localized
        }
    }
    @IBOutlet weak var policyMsg: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReturnPolicy.font = UIFont(name: "Cairo-Light", size: lblReturnPolicy.font.pointSize)
            }
            policyMsg.text = "timeDesc".localized
        }
    }
    
    var ordersData = orderReturnModel()
        var customerDict: Customer?
    var dictInfo = [String:Any]()
   var dataArray = [lineItems]()
var shipingAddress = shipingDetail()
    var billingAddress = invoiceDetail()
   
     let viewModel = CheckoutViewModel()
    var productCurrency = ""
    let formatter = DateFormatter()
    let transactionTimeFormater = DateFormatter()
      let date = Date()
   
    var strReason = ""
    
    override func viewDidLoad() {
        formatter.locale = Locale(identifier: "en")
               formatter.dateFormat = "yyyyMMdd"
               transactionTimeFormater.locale = Locale(identifier: "en")
               transactionTimeFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
        super.viewDidLoad()
        loadHeaderAction()
        
        lblAddress.text = "\(shipingAddress.name )"  + "\n" + "\(shipingAddress.street)" + "\n" + "\(shipingAddress.city )" + "," + "\(shipingAddress.country )"
        
        
        let customer = CartDataModel.shared.getCart()?.customer
                      customerDict = customer
        
        print(dictInfo)
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.headerTitle.text = "return_order".localized

        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }

    }
    @IBAction func onclickContinue(_ sender: Any) {
        callOMSAPI(paymentId: "")
//        let storyboard = UIStoryboard(name: "orderReturn", bundle: Bundle.main)
//                let returnReasonVC: ReturnOrderVC! = storyboard.instantiateViewController(withIdentifier: "ReturnOrderVC") as? ReturnOrderVC
//        returnReasonVC.billingAddress = billingAddress
//        returnReasonVC.dataArray = dataArray
//        returnReasonVC.strReason = strReason
//        returnReasonVC.shipingAddress = shipingAddress
//        returnReasonVC.ordersData = ordersData
//        returnReasonVC.billingAddress = billingAddress
//        self.navigationController?.pushViewController(returnReasonVC, animated: true)
        
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Pick Address")
        self.navigationController?.popViewController(animated: true)
    }
    func getStoreCode()->String{
           let strCode:String = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")"
           let storeCode="\(UserDefaults.standard.value(forKey: "language") ?? "en")_\(strCode.uppercased())"
           return storeCode
       }
    
    func callOMSAPI(paymentId:String){
         MBProgressHUD.showAdded(to: self.view, animated: true)
        //Adding Item in Server
        let deliveryOptionDict: [String: Any] = [:]
        var params: [String:Any] = [:]
        var customer: [String: Any] = [:]
        var shipping: [String: Any] = [:]
        var billing: [String: Any] = [:]
         var itemData: [String:Any] = [:]
        var item:[[String:Any]] = [[String:Any]]()
        var _: [String:Any] = [:]
        let payment: [[String: Any]] = [[String:Any]]()
       // var paymentDict: [String:Any] = [:]
      //  var voucherDict: [String:Any] = [:]
        var delivery: [String: Any] = [:]
        var charges: [String: Any] = [:]
        var bilingaddressFinal: [String: Any] = [:]
        var shippingaddressFinal: [String: Any] = [:]
//        delivery = dictInfo["delivery"] as! [String : Any]
//        params["businessDate"] = formatter.string(from: date)
//        params["transactionTime"] = transactionTimeFormater.string(from: date)
//        params["store"] = "8003"
//        params["ruOrderId"] = dictInfo["ruOrderId"]
//        params["transactionType"] = "RETURN"
//        params["orderId"] = ordersData.order_reference.order_id
//        params["transactionNumber"] = "3000001236"
//        params["baseCurrency"] = getWebsiteCurrency()
//        params["initiatedBy"] = "Mobileapp"
//        params["locale"] = self.getStoreCode()
//        params["status"] = "Return Initiated"
//        //params["isRetry"] = false
//
        customer["title"] = customerDict?.prefixField
        customer["firstName"] = customerDict?.firstname
        customer["lastName"] =  customerDict?.lastname
        customer["email"] =  customerDict?.email
        customer["phone"] = ordersData.order_reference.telephone
        customer["id"] =  customerDict?.id
       
            
        shipping["firstName"] = customerDict?.firstname
        shipping["lastName"] = customerDict?.lastname
        shipping["phone"] = ordersData.order_reference.telephone
        shippingaddressFinal["line1"] = shipingAddress.street
        shippingaddressFinal["country"] = shipingAddress.country
        shippingaddressFinal["postalCode"] = shipingAddress.postal
        shippingaddressFinal["city"] = shipingAddress.city
        
        billing["firstName"] = customerDict?.firstname
        billing["lastName"] = customerDict?.lastname
        billing["phone"] = ordersData.order_reference.telephone
        bilingaddressFinal["line1"] = ordersData.invoice_details.street
        bilingaddressFinal["country"] = ordersData.invoice_details.country
        bilingaddressFinal["postalCode"] = ordersData.invoice_details.postal
        bilingaddressFinal["city"] = ordersData.invoice_details.city
        
            shipping["address"] = shippingaddressFinal
            billing["address"] = bilingaddressFinal
           
      
        customer["shipTo"] = shipping
        customer["billTo"] = billing
            
            charges["subtotal"] = Double(ordersData.payment_details.amount)
        charges["total"] = Double(ordersData.payment_details.amount)
            for i in ordersData.line_details{
                if i.name.contains("discount"){
                    charges["discount"] =  Double(i.price)
                }
                if i.name == "Shippingcosts"{
                    charges["shippingCharges"] = Double(i.price)
                }
            }

        charges["discountTaxPercentage"] = 0.0
        charges["discountTaxAmount"] = 0.0

        charges["taxAmount"] = Double(ordersData.payment_details.tax_amount)

        charges["shippingTaxPercentage"] = 0.0
        charges["shippingTaxAmount"] = 0.0
     
        let items:Array<[String:Any]> = (dictInfo["items"] as? Array<[String:Any]>)!
        
      
        for i in dataArray{
                  itemData = [:]
                                    itemData["sku"] = i.core_sku
                                    itemData["comments"] = ""
                                    itemData["quantitySign"] = "P"
             itemData["quantity"] = i.quantity
            itemData["discountAmount"] = (charges["discount"] as? NSString)?.doubleValue
                          
                            //  if((items.baseDiscountAmount ?? 0.0) != 0.0){
                                  itemData["unitRetail"] = Double(i.price)
                       itemData["productPricePaid"] = Double(i.price)
                            
                             
                               itemData["taxAmount"] = Double(ordersData.payment_details.tax_amount)
                               
                               itemData["taxPercentage"] =  5
                          
                               itemData["vpn"] = ""
                               itemData["returnReason"] = i.returnReason
            itemData["detailID"] = i.detailID
                              //Logic carts Mine with Carts Total temporary #nitikesh will be removed in future once naga will provide zone in total
                             
                               charges["taxPercentage"] =  0.0
//            for j in 0..<items.count{
//                if i.core_sku == items[j]["core_sku"]as? String {
//
//
//
//
//
//
//                }
//            }
             item.append(itemData)
               }
        
        dictInfo["charges"] = charges
        dictInfo["customer"] = customer
        
        dictInfo["items"] = item
       
        print(dictInfo)

        self.viewModel.OMSOrder(dictInfo, success: { (response) in

            print(response)
        
                let storyboard = UIStoryboard(name: "confirmReturn", bundle: Bundle.main)
                 let changeVC: confirmReturnVC! = storyboard.instantiateViewController(withIdentifier: "confirmReturnVC") as? confirmReturnVC
                 //let nav = UINavigationController()
            changeVC.orderId = self.dictInfo["ruOrderId"] as? String ?? ""
            self.navigationController?.pushViewController(changeVC, animated: true)

        }) {(errorResponse) in
            print(errorResponse)
       }
        MBProgressHUD.hide(for: self.view, animated: true)
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
