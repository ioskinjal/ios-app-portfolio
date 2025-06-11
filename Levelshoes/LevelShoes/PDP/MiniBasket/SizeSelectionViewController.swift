//
//  SizeSelectionViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
import MBProgressHUD
import Alamofire

protocol SizeSelectionDelegate:class {
    func reloadSize(withSize:String ,qty:Int)
}
class SizeSelectionViewController: BottomPopupViewController {

    @IBOutlet weak var tableView: UITableView!
    var flagindex:Int = 500
    var height: CGFloat = 433
    var sizeArray:Array<Any> = Array<Any>()
    var data:Array<Any> = Array<Any>()
    var selectedSize: String = ""
    var itemDict:[String:Any]  = [:]
    var requseQty: Int = 1
  //  var cartData:Cart?
    weak var delegate:SizeSelectionDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func getPopupHeight() -> CGFloat {
        return height
    }
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateItemSize(){
        var params:[String:Any] = [:]
        params["sku"] = itemDict["sku"]
        params["qty"] = self.requseQty ?? 1
        params["product_option"] = itemDict["product_option"]
        
        params["item_id"] = itemDict["item_id"]
        //   params["qty"] = cartItems[selectedItem].qty
        
        var extension_attributes:[String:Any] = [:]
        extension_attributes["option_id"] = itemDict["attributeID"]
        extension_attributes["option_value"] = itemDict["selectedSize"]    //itemDict["size"]

        var   configurable_item_options = ["configurable_item_options" : [extension_attributes]]
        var productOption:[String:Any] = [:]
        productOption["extension_attributes"] = configurable_item_options
        
        
        params["product_option"] = productOption
        
        if(M2_isUserLogin){
            params["quote_id"] = itemDict["quote_id"]
        }
        else{
            params["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
        }
        
        ApiManager.updateCartItem(params: params, success: { (response) in
            
            DispatchQueue.main.async {
                self.delegate?.reloadSize(withSize: self.selectedSize, qty: self.requseQty)
                self.dismiss(animated: true, completion: {
                })
            }
            
        }) {
            
        }
        
    }
    
}
extension SizeSelectionViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddBagPopUpCell = tableView.dequeueReusableCell(withIdentifier:"AddBagPopUpCell",for:indexPath ) as! AddBagPopUpCell
        
        if let dict:[String:Any] = data[indexPath.row] as? [String:Any] , let size:Int = dict["size"] as? Int , let stockDict:[String:Any] = dict["stock"] as? [String:Any] , let stock:Int = stockDict["qty"] as? Int {
            cell.sizeLabel(size: size , stock: stock, price: dict["final_price"] as? Double ?? 0.0)
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
        guard let stock:Int = stockDict["qty"] as? Int else {
            return
        }
        if stock == 0 {
            return
        }
        flagindex = indexPath.row
        itemDict["selectedSize"] =
        self.selectedSize = "\(configChildDict["size"] as? Int ?? 0)"
        itemDict["selectedSize"] = self.selectedSize
       
        tableView.reloadData()
        //kkk upadet api call
        callOmsStockCheckApi(skus: itemDict["sku"] as? String ?? "")
       
    }
   func callOmsStockCheckApi(skus: String)
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
                                              //if soh.count > 0{
                                            if soh.count > 0 && (self.checkStockForSku(sku: skus, sohArray: soh) > 0 ){
                                                  self.updateItemSize()
                                                  self.delegate.reloadSize(withSize: self.selectedSize, qty: self.requseQty)
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

