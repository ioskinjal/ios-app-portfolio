//
//  orderModel.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 20/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import SwiftyJSON
class orderReturnModel: NSObject{
        
        var order_reference = orderRefrence()
        var payment_details = paymentDetail()
        var tender_details = [tenderDetail]()
        var invoice_details = invoiceDetail()
        var delivery_details  = shipingDetail()
        var line_details = [lineItems]()
    func parseData (dict:JSON) -> orderReturnModel{
        if dict["order_reference"].exists(){
            let orderData = orderRefrence()
            self.order_reference = orderData.parseOrderRefrence(dict: dict["order_reference"])
        }
        if dict["line_details"].exists(){
            let orderData = lineItems()
            self.line_details = orderData.parseLineitem(dict:dict["line_details"])
        }
        if dict["payment_details"].exists(){
            let orderData = paymentDetail()
            self.payment_details = orderData.parsePaymentDetails(dict:dict["payment_details"])
        }
        if dict["invoice_details"].exists(){
            let orderData = invoiceDetail()
            self.invoice_details = orderData.parseInvoice(dict: dict["invoice_details"])
        }
        if dict["delivery_details"].exists(){
            let orderData = shipingDetail()
            self.delivery_details = orderData.parseShipping(dict: dict["delivery_details"])
        }
        if dict["tender_details"].exists(){
            let orderData = tenderDetail()
            self.tender_details = orderData.parseTender(dict:dict["tender_details"])
        }

        return self
    }

}
class orderRefrence: NSObject {
        var order_id : String = ""
        var date : String = ""
        var order_status : String = ""
        var gender : String = ""
        var order_date :Date = Date()
        var telephone: String = ""
    func parseOrderRefrence(dict:JSON) -> orderRefrence{
         self.order_id = dict["order_id"].stringValue
         self.date =  dict["date"].stringValue
         self.order_status  =  dict["order_status"].stringValue
         self.gender  =  dict["gender"].stringValue
         self.telephone = dict["telephone"].stringValue
        if let order_date = dict["date"] as? String{
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: Date? = dateFormatterGet.date(from: order_date)
            self.order_date = date!
        }
        return self
    }
}
//PAYMENT DETAILS
class paymentDetail : NSObject {
    var amount : String = ""
    var currency : String  = ""
    var tax_amount : String = ""
    
    func parsePaymentDetails(dict:JSON) -> paymentDetail{
        amount = dict["amount"].stringValue
        currency = dict["currency"].stringValue
        tax_amount = dict["tax_amount"].stringValue
        return self
    }

}
class lineItems: NSObject{
    var name : String = ""
    var type : String = ""
    var sku_code : String = ""
    var core_sku : String = ""
    var price : String = ""
    var price_tax_amount = ""
    var reason = [[String:Any]]()
    var detailID = [String]()
    var list_price : String = ""
    var delivery_type : String = ""
    var product_status : String = ""
    var parcel_add_date : String = ""
    var brand : String = ""
    var size : String = ""
    var imag_url : String = ""
    var quantity : Int = 0
    var product_id = ""
    var isSelected = false
    var tax = 0.0
    var returnReason = ""
    var returnable : String = ""
        
    func parseLineitem(dict:JSON) -> [lineItems]{
       
        var listOflineItems = [lineItems]()
        
        for (index,subJson):(String, JSON) in dict {
            let newItem = lineItems()
            if subJson["type"].stringValue == "PRODUCT" {
                newItem.name = subJson["name"].stringValue
                newItem.type = subJson["type"].stringValue
                newItem.sku_code = subJson["sku_code"].stringValue
                newItem.price = subJson["price"].stringValue
                newItem.list_price = subJson["list_price"].stringValue
                newItem.delivery_type = subJson["delivery_type"].stringValue
                newItem.product_status = subJson["product_status"].stringValue
                newItem.parcel_add_date = subJson["parcel_add_date"].stringValue
                newItem.brand = subJson["brand"].stringValue
                newItem.size = subJson["size"].stringValue
                newItem.imag_url = subJson["imag_url"].stringValue
                newItem.product_id = subJson["product_id"].stringValue
                newItem.isSelected = subJson["isSelected"].boolValue
                newItem.returnReason = subJson["returnReason"].stringValue
                newItem.core_sku = subJson["core_sku"].stringValue
                 newItem.detailID = subJson["detailID"] as? [String] ?? [String]()
                newItem.reason = subJson["reason"] as? [[String:Any]] ?? [[String:Any]]()
                newItem.returnable = subJson["retur'nable"].stringValue
                newItem.price_tax_amount = subJson["price_tax_amount"] as? String ?? ""
                newItem.tax = subJson["tax"] as? Double ?? 0.0
                listOflineItems.append(newItem)
            }
        }
        return listOflineItems
    }
}
////PAYMENT DETAILS
class tenderDetail : NSObject {
    var tender_type : String = ""
    var tender_value : String = ""
    
    func parseTender(dict:JSON) -> [tenderDetail]{
        var listOfTender = [tenderDetail]()
        for (index,subJson):(String, JSON) in dict {
            let newItem = tenderDetail()
            newItem.tender_type = subJson["tender_type"].stringValue
            newItem.tender_value = subJson["tender_value"].stringValue
            listOfTender.append(newItem)
           
        }
        return listOfTender
    }
}
////inVoice Details
class invoiceDetail : NSObject {
    var name : String = ""
    var street : String = ""
    var number : String = ""
    var number_add : String = ""
    var postal : String = ""
    var city : String = ""
    var country : String = ""
    
    func parseInvoice(dict:JSON) -> invoiceDetail{
        name = dict["name"].stringValue
        street = dict["street"].stringValue
        number = dict["number"].stringValue
        number_add = dict["number_add"].stringValue
        postal = dict["postal"].stringValue
        city = dict["city"].stringValue
        country = dict["country"].stringValue
        return self
    }
}
class shipingDetail : NSObject {
    var name : String = ""
    var street : String = ""
    var number : String = ""
    var number_add : String = ""
    var postal : String = ""
    var city : String = ""
    var country : String = ""
    var delivery_type : String = ""
    
    func parseShipping(dict:JSON) -> shipingDetail{
        name = dict["name"].stringValue
        street = dict["street"].stringValue
        number = dict["number"].stringValue
        number_add = dict["number_add"].stringValue
        postal = dict["postal"].stringValue
        city = dict["city"].stringValue
        country = dict["country"].stringValue
        delivery_type = dict["delivery_type"].stringValue
        return self
    }
}


//Order Return Details
//struct ckOrderReturn : Codable {
//    var order_reference : [orderRefrence]
//    var payment_details : [paymentDetail]
//    var tender_details : [tenderDetail]
//    var invoice_details : [invoiceDetail]
//    var delivery_details : [deliveryDetail]
//    var line_details : [lineItems]
//}
////ORDER LIST
//struct orderRefrence : Codable {
//    var order_id : String
//    var date : String
//    var order_status : String
//    var gender : String
//}
//
////PAYMENT DETAILS
//struct paymentDetail : Codable {
//    var amount : String
//    var currency : String
//    var tax_amount : String
//}
//
////PAYMENT DETAILS
//struct tenderDetail : Codable {
//    var tender_type : String
//    var tender_value : String
//}
//
////inVoice Details
//struct invoiceDetail : Codable {
//    var name : String
//    var street : String
//    var number : String
//    var number_add : String
//    var postal : String
//    var city : String
//    var country : String
//}
//
////deliveryDetail
//struct deliveryDetail : Codable {
//    var name : String
//    var street : String
//    var number : String
//    var number_add : String
//    var postal : String
//    var city : String
//    var country : String
//}
//
////line items
//struct lineItems : Codable {
//    var name : String
//    var type : String
//    var sku_code : String
//    var price : String
//    var list_price : String
//    var delivery_type : String
//    var product_status : String
//    var parcel_add_date : String
//    var brand : String
//    var size : String
//    var imag_url : String
//}
////ALL Data for orders
//struct allOrderData : Codable {
//    var corders : [ckOrderReturn]
//}

