//
//  MyOrdersVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 29/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

//var priceArray = [String]()

//var payment_amount : String
//var payment_currency : String

class MyOrdersVC: UIViewController {
    @IBOutlet weak var tblHeader: tblHeaderView!
    @IBOutlet weak var tblFooter: tblFooterView!
    var orderidArray = [String]()
    var orderDateArray = [String]()
    var orderTypeArray = [String]()
    var orderStatusArray = [String]()
    var orderAmountArray = [String]()
    var currencyArray = [String]()
    var ordersData = [orderReturnModel]()
    var formatedDate = ""
    
    func didSelectedRowWith(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MyOrders", bundle: nil)
              let viewC = storyboard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
              self.navigationController?.pushViewController(viewC, animated: true)
    }
    

    @IBOutlet weak var header: headerView!
    
    @IBOutlet weak var tblMyOrders: UITableView!
    static var storyboardMyOrderInstance:MyOrdersVC? {
        return StoryBoard.myOrder.instantiateViewController(withIdentifier: MyOrdersVC.identifier) as? MyOrdersVC
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFooter.btnNeedHelp.addTarget(self, action: #selector(needHelpSelector), for: .touchUpInside)
    }
     
    override func viewWillAppear(_ animated: Bool) {
        callOrderApi()
        loadHeaderAction()
        let nib = UINib(nibName: "MyOrderCell", bundle: nil)
        tblMyOrders.register(nib, forCellReuseIdentifier: "MyOrderCell")
    }
    
   @objc func needHelpSelector(){
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    
    func callOrderApi(){//nm500@idslogic.co.uk
        tblHeader.isHidden = true
          let custEmail = UserDefaults.standard.string(forKey: "userEmail")
          let param =  ["request" : ["customer_email":custEmail]]
       

          //let param =  ["request" : ["customer_email":"anitharavanesh@gmail.com"]]
          
        let url = CommonUsed.globalUsed.orderHistory
          MBProgressHUD.showAdded(to: self.view, animated: true)
          ApiManager.apiOmsPost(url: url, params: param) { (myJson, myError) in
              MBProgressHUD.hide(for: self.view, animated: true)
              if let data = myJson {
                  
                  let jsonData = data["orders"]
                  //print("Whole data \(jsonData)")
                 self.ordersData.removeAll()
                 self.ordersData = [orderReturnModel]()
                  for (index,subJson):(String, JSON) in jsonData {
                      let itemorderData =  orderReturnModel()
                      itemorderData.parseData(dict:subJson)
                      self.ordersData.append(itemorderData)
                      
                  }
                self.tblHeader.isHidden = false
                self.tblHeader.lblOrdersTitle.text = "myOrdAllorder".localized
                  var sortedOrder  = self.getSortedOrderList(orderList:self.ordersData)
                  self.ordersData = sortedOrder
                let orders = "myOrdersOrder".localized.uppercased()
                self.tblHeader.lblNumbersofOrder.text = "\(self.ordersData.count) \(orders)"
                  self.tblMyOrders.reloadData()
              }//ordersData

          }
    }
    func getSortedOrderList(orderList:[orderReturnModel]) -> [orderReturnModel]{
        var sortedList = [orderReturnModel]()
       
        let myOrderList : [orderReturnModel] =  orderList.sorted(by: {$0.order_reference.order_date > $1.order_reference.order_date})
            removeAllWishListArray()
        for odrList in myOrderList {
            sortedList.append(odrList)
           
        }
        return sortedList
    }

    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
       // header.buttonClose.addTarget(self, action: #selector(backSelectorForCloseButton), for: .touchUpInside)
        header.headerTitle.text = "my_orders".localized
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
    @objc func backSelectorForCloseButton(sender : UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func stringTodate(date:String){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "MMM dd, yyyy"

        let date: Date? = dateFormatterGet.date(from: date)
        formatedDate = dateFormatter.string(from: date!)
       // return formatedDate
       // print(dateFormatter.string(from: date!))

    }
    func getGiftcardPrice(data : [tenderDetail])->String{
        var vaoucher = ""
        let payments = data
        for paymentItem in payments{
            if paymentItem.tender_type == "VOUCH"{
                vaoucher = paymentItem.tender_value
                break
            }
        }
        return vaoucher
    }
}


extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell

        
        let Row = indexPath.row
        let Items = "items".localized.uppercased()
        
        cell.lblItemsCount.text = "\(ordersData[Row].line_details.count) \(Items)"
        stringTodate(date: ordersData[Row].order_reference.date)
        
        let currencyStr = ordersData[Row].payment_details.currency
        let giftCard = self.getGiftcardPrice(data: ordersData[Row].tender_details)
        let giftCardCost = (giftCard as NSString).floatValue
        let totalPrice =  (ordersData[Row].payment_details.amount as NSString).floatValue
        let orderPrice = totalPrice - giftCardCost
        let price = Double(orderPrice).clean
        //let currencyStr = (UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
        cell.lblPrice.text =  "\(price) " + "\((currencyStr))".localized
        
        
       // cell.lblPrice.text = "\(ordersData[Row].payment_details.amount) \(ordersData[Row].payment_details.currency)"
        cell.ordersImage.sd_setImage(with: URL(string: getImageUrl(lineItems:ordersData[Row].line_details)), placeholderImage: UIImage(named: "imagePlaceHolder"))
        let status =  Common.sharedInstance.getOrderStatus(stat: "\(ordersData[Row].order_reference.order_status)")
        cell.lblStatus.text = status.name.localized
        cell.lblStatus.textColor = status.color
        cell.viewIndicator.backgroundColor = status.color
            
        cell.lblDate.text =   formatedDate
        cell.lblOrderNumber.text = "\(ordersData[Row].order_reference.order_id)"
        return cell
        
    }
    func getImageUrl(lineItems:[lineItems])->String{
        var imagepath = ""
        for item in lineItems {
            if item.imag_url.length > 1{
                imagepath = item.imag_url
                break
            }
            
        }
        return imagepath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "orderDetail", bundle: Bundle.main)
        let orderDetailVC: orderDetailVC! = storyboard.instantiateViewController(withIdentifier: "orderDetailVC") as? orderDetailVC
        orderDetailVC.ordersStatus = "\(ordersData[indexPath.row].order_reference.order_status)"
        orderDetailVC.orderId = "\(ordersData[indexPath.row].order_reference.order_id)"
        orderDetailVC.ordersData = ordersData[indexPath.row]
        orderDetailVC.dataFilterArray = getFilterDataArray(lineItem:ordersData[indexPath.row].line_details)       //ordersData[indexPath.row].line_details
        //orderDetailVC.dataArray[orderReturnModel] = ordersData[indexPath.row]
        
        orderDetailVC.billingAddress = ordersData[indexPath.row].invoice_details
        orderDetailVC.shipingAddress = ordersData[indexPath.row].delivery_details
        orderDetailVC.productCurrency = ordersData[indexPath.row].payment_details.currency
        orderDetailVC.ordersSubTotal = ordersData[indexPath.row].payment_details.amount
        orderDetailVC.orderTotalAmount = ordersData[indexPath.row].payment_details.amount
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
        
    }
    
    func getFilterDataArray(lineItem:[lineItems])->[lineItems]{
        var lineItemArray = [lineItems]()
        var productIDDic = [String:lineItems]()
        for item in lineItem{
//             if  item.product_id != "" {
//            if  let val = productIDDic[item.product_id] {
//                var qty = val.quantity + 1
//                item.quantity = qty
            if(item.type == "PRODUCT"){
               item.quantity = 1
                productIDDic[item.product_id] = item
               
                 lineItemArray.append(productIDDic[item.product_id] ?? lineItems())
            }
//            }else{
//                var qty = item.quantity + 1
//                    item.quantity = qty
//               productIDDic[item.product_id] = item
//            }
            //}
        }
       
        return lineItemArray
    }
}

extension String {
  func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: self) else {
      preconditionFailure("Take a look to your format")
    }
    return date
  }
}
