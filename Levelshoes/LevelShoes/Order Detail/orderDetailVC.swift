//
//  orderDetailVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SwiftyJSON

class orderDetailVC: UIViewController {
    @IBOutlet weak var header: headerView!
    
    
    
    @IBOutlet weak var viewOrderInfo: orderDetailHeader!
    @IBOutlet weak var viewOrderSummary: orderDetailFooter!
    @IBOutlet weak var tblOrderDetail: UITableView!
    var orderId = ""
    var qty = 0
    var ordersReturnOrderid = ""
    var ordersSubTotal = ""
    var orderTotalAmount = ""
    var productCurrency = ""
    var ordersTaxAmount = ""
    var ordersShipingAmount = ""
    var ordersDate = ""
    var ordersStatus = ""
    var dataArray  = [orderReturnModel]()
    var dataFilterArray = [lineItems]()
    var ordersData = orderReturnModel()
    var billingAddress = invoiceDetail()
    var shipingAddress = shipingDetail()
    var dictInfo = [String : Any]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        tblOrderDetail.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHeaderAction()
        viewOrderSummary.btnneedHelp.addTarget(self, action: #selector(needHelpSelector), for: .touchUpInside)
        
        print("INvoice detils \(billingAddress.name)")
        
        dataFilterArray.removeAll()
        let detailurl = "\(CommonUsed.globalUsed.ordeDetail)\(orderId)"
        
        
        ApiManager.apiOmsGet(url: detailurl, params: nil) { (myJson, myError) in
            print(myJson!)
            
            let data = myJson
            let returnOrderid:String = "\(self.ordersReturnOrderid)"
            let subTotal : String = "\(self.orderTotalAmount)"
            let totalAmount:String = "\(self.orderTotalAmount)"
            let discount = data?["orders"]["order"]["order_discount"]
            let discountTaxPercentage = "0"
            let discountTaxAmount = "0"
            let taxPercentage = data!["orders"]["order"]["order_tax"]
            let taxAmount : String = "\(self.ordersTaxAmount)"
            let shippingCharges = data!["orders"]["order"]["order_shipping"]
            let shippingTaxPercentage = "0"
            let shippingTaxAmount = "0"
            //Creating Packet For Return
            let currentdate = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd"
            let dateString = df.string(from: currentdate)
            self.dictInfo["businessDate"] = "\(dateString)" //Current date formated
            self.dictInfo["transactionTime"] = "\(currentdate)" //Current date time formated
            self.dictInfo["store"] = "8003"
            self.dictInfo["transactionType"] = "RETURN"
            self.dictInfo["transactionNumber"] = "3000040284"
            self.dictInfo["orderId"] = "\(data!["orders"]["order"]["order_id"])"
            
            
            
            
            self.dictInfo["baseCurrency"] = "\(data!["orders"]["order"]["payment_currency"])"
            
            self.dictInfo["initiatedBy"] = "Mobileapp"
            self.dictInfo["locale"] = self.getStoreCode()
            self.dictInfo["status"] = "Return Initiated"
            self.dictInfo["ruOrderId"] = "\(data!["orders"]["order"]["run_order_id"])"
            let subtotal = data?["orders"]["order"]["payment_amount"]
            let cartTotal = data?["orders"]["order"]["order_subtotal"].string
            let orderDiscount = data?["orders"]["order"]["order_discount"].string
            let chargesDict:[String:Any] =
                [
                    "subtotal":subtotal ?? 0 ,
                    "total" :subtotal ?? 0 ,
                    "discount" : discount ?? 0,
                    "discountTaxPercentage" : discountTaxPercentage,
                    "discountTaxAmount" : discountTaxAmount ,
                    "taxPercentage" : taxPercentage ,
                    "taxAmount" : taxAmount,
                    "shippingCharges":shippingCharges ,
                    "shippingTaxPercentage":shippingTaxPercentage,
                    "shippingTaxAmount":shippingTaxAmount]
            
            
            self.dictInfo["charges"] = chargesDict
            
            self.dictInfo["delivery"] = ["name" : "\(data!["orders"]["order"]["delivery"]["name"])" , "type" : "\(data!["orders"]["order"]["delivery"]["type"])"]
            
            // self.dictInfo = data?.dictionaryObject
            let array:Array<[String:Any]> = ((data!["orders"]["order"]["line_details"]["line"].arrayObject)! as? Array<[String : Any]>)!
            // var jsonArr:[JSON] = JSON["myArray"].arrayValue
            
            self.dictInfo["items"] = array
            self.dictInfo["payment"] = []
            let addressDict = ["line1" : "Test Address Al Nahda" , "country" : "AE" ,
                               "postalCode" : 0 , "city" : "Dubai" , "line2" : "" ] as [String : Any]
            
            
            
            
            
            ////END  OF RETURN PACKET //////////////////////
            
            
            for i in 0..<array.count {
                if let name = array[i]["type"] {
                    if name as! String == "PRODUCT"{
                        print("Inserted")
                        let item : lineItems?
                        
                        item = lineItems.init()
                        
                        item?.brand = array[i]["brand"] as? String ?? ""
                        item?.type = array[i]["type"] as? String ?? ""
                        item?.size = array[i]["size"] as? String ?? ""
                        item?.price = array[i]["price"] as? String ?? ""
                        item?.list_price = array[i]["list_price"] as? String ?? ""
                        item?.product_id = String(array[i]["product_id"] as? Int ?? 0)
                        item?.product_status = array[i]["product_status"] as? String ?? ""
                        item?.returnable = array[i]["returnable"] as? String ?? ""
                        item?.parcel_add_date = array[i]["parcel_add_date"] as? String ?? ""
                        item?.sku_code = array[i]["sku_code"] as? String ?? ""
                        item?.name = array[i]["name"] as? String ?? ""
                        item?.core_sku = array[i]["core_sku"] as? String ?? ""
                        item?.price_tax_amount = array[i]["price_tax_ammunt"] as? String ?? ""
                        item?.imag_url = array[i]["image_url"] as? String ?? ""
                        item?.delivery_type = array[i]["delivery_type"] as? String ?? ""
                        item?.detailID = ["\(array[i]["detail_id"] as? Int ?? 0)"]
                        item?.tax = array[i]["tax"] as? Double ?? 0.0
                        item?.quantity = 1
                        
                        self.dataFilterArray.append(item!)
                    }
                    else{
                        print("Not inserted")
                    }
                }
            }
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            dateFormatter.dateFormat = "dd MMM ,yyyy"
            let date: Date? = dateFormatterGet.date(from:"\(self.ordersDate)")
            let dateFromServer = "\(self.ordersDate)"
            //orderidArray = data["orders"]["order"].arrayValue.map {$0["order_id"].stringValue}
            var countReturn = 0
            for i in self.dataFilterArray{
                if i.product_status != "Delivered"{
                    countReturn = countReturn + 1
                }
            }
            if countReturn == self.dataFilterArray.count{
                self.viewOrderSummary.viewNewReturn.isHidden = true
            }
            else{
                self.viewOrderSummary.viewNewReturn.isHidden = false
            }
            let status =  Common.sharedInstance.getOrderStatus(stat: "\(self.ordersStatus)")
            ///Filing  Header Data
            self.viewOrderInfo.lblDeliveryStatus.text = status.name.localized
            self.viewOrderInfo.lblDeliveryStatus.textColor = status.color
            self.viewOrderInfo.viewIndicator.backgroundColor = status.color
            self.viewOrderInfo.lblOrderNo.text = self.orderId
            self.viewOrderInfo.lblUsername.text = self.shipingAddress.name
            self.viewOrderInfo.lblAddress.text = self.shipingAddress.street
            self.viewOrderInfo.lblCountry.text = self.shipingAddress.city
            //Billing Addess
            self.viewOrderInfo.lblBillingUser.text = self.billingAddress.name
            self.viewOrderInfo.lblBillingAddress.text = self.billingAddress.street
            self.viewOrderInfo.lblBillingCountry.text = self.billingAddress.city
            
            self.viewOrderInfo.lblDate.text = dateFormatter.string(from: date ?? Date())
            let items = "items".localized
            self.viewOrderInfo.lblItemsCount.text = "\(self.dataFilterArray.count) \(items)"
            self.productCurrency = "\(self.productCurrency)"
            
            //Filing Footer data //shippingCharges
            let currency = "\(self.productCurrency)".localized
            self.viewOrderSummary.lblCartSubtotalPrice.text = "\((cartTotal as NSString?)?.doubleValue.clean ?? "") \(currency)"
            let shipingParice = self.getShippingPrice().price
            let voucherCost  = self.getVoucherPrice(data: data!)
           // print("THIS VOUCHER \(voucherCost)")
            let shippingCost = data?["orders"]["order"]["order_shipping"].string
            self.viewOrderSummary.lblShippingPrice.text = "\((shippingCost as NSString?)?.doubleValue.clean ?? "")  \(currency)"
            let shippingCostinInt = (shippingCost! as NSString).integerValue
            if shippingCostinInt > 0 {
                self.viewOrderSummary.viewShippingHieghtConstant.constant = 54
                self.viewOrderSummary.viewShipping.isHidden = false
                self.viewOrderSummary.viewShipping.layoutIfNeeded()
            }else{
                self.viewOrderSummary.viewShippingHieghtConstant.constant = 0
                self.viewOrderSummary.viewShipping.isHidden = true
                self.viewOrderSummary.viewShipping.layoutIfNeeded()
            }
            self.viewOrderSummary.lblGiftcardValue.text = "\((voucherCost as NSString?)?.doubleValue.clean ?? "")  \(currency)"
            let discountContent = "Discount".localized
            let discountcodeName  = self.getDiscountCode(data: data!)
            self.viewOrderSummary.lblDiscount.text = "\(discountContent) (\(discountcodeName))"
            self.viewOrderSummary.lblDiscountValue.text = "\((orderDiscount as NSString?)?.doubleValue.clean ?? "")  \(currency)"
            self.viewOrderSummary.lblVatPrice.text = "\(Double(self.ordersData.payment_details.tax_amount)?.clean ?? "") \(currency)"
            self.viewOrderSummary.lblSummaryItems.text = "\(self.dataFilterArray.count ) \(items)"
            let finalsubTotal = Float(subTotal) ?? 0
            let finalVoucher = (voucherCost as NSString).floatValue
            if finalVoucher > 0 {
               // print("SHOW VOUCHER")
                self.viewOrderSummary.giftcardHeightConstant.constant = 54
                self.viewOrderSummary.viewGiftcard.layoutIfNeeded()
            }else{
                //print("HIDE VOUCHER")
                self.viewOrderSummary.giftcardHeightConstant.constant = 0
                self.viewOrderSummary.viewGiftcard.layoutIfNeeded()
            }
            if let itemDiscount = orderDiscount {
                let discountInint = (itemDiscount as NSString).integerValue
                if discountInint  > 0 {
                    print("SHOW Discount")
                    self.viewOrderSummary.discountHieghtConstant.constant = 54
                    self.viewOrderSummary.viewDiscount.layoutIfNeeded()
                }else{
                    print("HIDE Discount")
                    self.viewOrderSummary.discountHieghtConstant.constant = 0
                    self.viewOrderSummary.viewDiscount.layoutIfNeeded()
                }
            }

            let subTotalValu:Float? = finalsubTotal - finalVoucher
            let shipingPariceValu:Float? = Float(shipingParice) ?? 0
            let vatPariceValu:Float? = Float(self.ordersData.payment_details.tax_amount)
            let percent = String(format: "%.f", Float(((vatPariceValu ?? 0) / (subTotalValu  ?? 1)) * 100))
            let vat = getVatName()
            self.viewOrderSummary.lblVat.text = "\(vat)(\(percent ))%"
            let totalOrderPrice = ( subTotalValu ?? 0)
            self.viewOrderSummary.lblGrandtotalPrice.text = "\(Double(totalOrderPrice).clean) \(currency)"
            self.viewOrderSummary.btnNewReturn.addTarget(self, action: #selector(self.newReturnSelector), for: .touchUpInside)
            
            ///showing or hiding Retuen button
            let components: Set<Calendar.Component> = [.day]
            let cal = Calendar.current
            let days = cal.dateComponents(components, from: dateFormatterGet.date(from: dateFromServer) ?? Date() , to: Date.getCurrentDate() )
            //  if let checkDays = days.day , checkDays > 29 {
            // self.viewOrderSummary.viewNewReturn.isHidden = false
            // }
            
            //    self.viewOrderSummary.viewNewReturn.isHidden = false
            print("Printing dayes \(days)")
            
            self.tblOrderDetail.reloadData()
        }
        
        // }
        
        // print("Inside GET  api \(myJson!["orders"]["order"]["delivery_details"]["delivery_name"]) ")
        //}
        
    }
    @objc func needHelpSelector(){
         let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
         let changeVC: NeedHelpBottomPopUpViewController!
         changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
         self.navigationController?.present(changeVC, animated: true, completion: nil)
     }
    func getStoreCode()->String{
        let strCode:String = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")"
        let storeCode="\(UserDefaults.standard.value(forKey: "language") ?? "en")_\(strCode.uppercased())"
        return storeCode
    }
    func getShippingPrice()->lineItems{
        var orderShiping = lineItems()
        for item in ordersData.line_details{
            if item.name == "Shippingcosts"{
                orderShiping = item
                break
            }
            
        }
        return orderShiping
    }
    func getVoucherPrice(data : JSON)->String{
        var vaoucher = ""
        let payments = data["orders"]["order"]["payments"]["payment"].array
        for paymentItem in payments! as [JSON]{
            if paymentItem["payment_paymentMethod"] == "VOUCH"{
                vaoucher = paymentItem["payment_original_currency_amount"].string!
                break
            }
        }
        return vaoucher
    }
    func getDiscountCode(data : JSON)->String{
        var discountCode = ""
        let payments = data["orders"]["order"]["payments"]["payment"].array
        //print("PRINTING DECT \(payments)")
        for paymentItem in payments! as [JSON]{
            print("PRINTING DECT \(paymentItem)")
            if paymentItem["payment_Coupon_no"].exists() {
                discountCode = paymentItem["payment_Coupon_no"].string!
                break
            }
        }
        return discountCode
    }

    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.headerTitle.text = "orderDetails".localized
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)
            
        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Pick Address")
        self.navigationController?.popViewController(animated: true)
    }
    @objc func newReturnSelector(sender : UIButton) {
        
        let storyboard = UIStoryboard(name: "orderReturn", bundle: Bundle.main)
        let returnOrderVC: ReturnOrderVC! = storyboard.instantiateViewController(withIdentifier: "ReturnOrderVC") as? ReturnOrderVC
        returnOrderVC.dictInfo = self.dictInfo
        for i in dataFilterArray{
            if i.product_status == "Delivered" && i.returnable == "Y"{
                returnOrderVC.dataArray.append(i)
            }
        }
        if returnOrderVC.dataArray.count != 0 {
            // returnOrderVC.dataArray = dataFilterArray
            returnOrderVC.billingAddress = billingAddress
            returnOrderVC.shipingAddress = shipingAddress
            returnOrderVC.ordersData = ordersData
            returnOrderVC.productCurrency = self.productCurrency
            self.navigationController?.pushViewController(returnOrderVC, animated: true)
            print("Call return Api --")
        }else{
            let notShippedMsg = "notShipped".localized
            self.alert(title: "", message: notShippedMsg)
        }
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
extension orderDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFilterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        //result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
        if indexPath.row == 1 {
            cell.customLine.isHidden = true
        }
        
        //let name =

        // cell.btnInc.addTarget(self, action: #selector(qtyIncreaseAction(_:)), for: .touchUpInside)
        print("dataFilterArray = \(dataFilterArray)")
        cell.lblQty.text = "\(dataFilterArray[indexPath.row].quantity)"

        cell.lblProductName.text = dataFilterArray[indexPath.row].brand.uppercased()
        cell.lblMaterailType.text = dataFilterArray[indexPath.row].name
        let price = Double(Double(dataFilterArray[indexPath.row].price)  ?? 0).clean
        //let currencyStr = dataFilterArray[indexPath.row].currency
        let currencyStr = self.productCurrency
            //(UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
        cell.lblPrice.text =  "\(price) " + "\((currencyStr))".localized
        
        // cell.lblPrice.text = "\(dataFilterArray[indexPath.row].price) \(productCurrency)"
        cell.lblSizeNumber.text = dataFilterArray[indexPath.row].size

        
        // cell.lblQtyValue.text =  "\(dataFilterArray[indexPath.row].quantity)"//"\(dataFilterArray.count)"

        _ = dataFilterArray[indexPath.row].imag_url
        cell.productImage.sd_setImage(with: URL(string: dataFilterArray[indexPath.row].imag_url), placeholderImage: UIImage(named: "imagePlaceHolder"))
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected Details \(indexPath.row)")
        
        let storyboard = UIStoryboard(name: "orderReturn", bundle: Bundle.main)
        let returnOrderVC: ReturnOrderVC! = storyboard.instantiateViewController(withIdentifier: "ReturnOrderVC") as? ReturnOrderVC
        returnOrderVC.dictInfo = self.dictInfo
        self.navigationController?.pushViewController(returnOrderVC, animated: true)
        
    }
}
extension Date {
    
    static func getCurrentDate() -> Date {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return  Date()
        
    }
}
