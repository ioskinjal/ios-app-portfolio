//
//  ReturnOrderVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReturnOrderVC: UIViewController {

    
    @IBOutlet weak var footer: footerOrderReturn!
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var headerOftable: headerOrderReturn!
    
    @IBOutlet weak var tblReturn: UITableView!
    @IBOutlet weak var lblHeader: UILabel!{
        didSet{
            lblHeader.text = "select_return_item".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblHeader.font = UIFont(name: "Cairo-SemiBold", size: lblHeader.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.text = "returnDesc".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
               lblDesc.font = UIFont(name: "Cairo-Light", size: lblDesc.font.pointSize)
            }
        }
    }
    
    
    var billingAddress = invoiceDetail()
    var strReason = ""
    var currentTag = 0
    var isFirstTime = true
    var totalProducts = 0
    var selectedQuantity = 0
    var qty = 0
      var productCurrency = ""
     var ordersData = orderReturnModel()
     var customerDict: Customer?
    var shipingAddress = shipingDetail()
    var dictInfo  = [String: Any]()
    
    var dataArray  = [lineItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        
        print("INformation -- \(dictInfo)")
        for i in dataArray{
            i.isSelected = false
        }
        footer.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    
        footer.btnContinue.alpha = 0.5
        footer.btnContinue.isUserInteractionEnabled = false
        
        
   
        tblReturn.register(UINib(nibName: "orderDetailCell", bundle: nil), forCellReuseIdentifier: "orderDetailCell")
        
      let customer = CartDataModel.shared.getCart()?.customer
               customerDict = customer
       
        loadHeaderAction()
        
    
        
    }
    
    
    @objc func onClickContinue(_ sender:UIButton){
          
            let storyboard = UIStoryboard(name: "returnReason", bundle: Bundle.main)
                    let returnReasonVC: returnReasonVC! = storyboard.instantiateViewController(withIdentifier: "returnReasonVC") as? returnReasonVC
            returnReasonVC.billingAddress = billingAddress
            returnReasonVC.shipingAddress = shipingAddress
            returnReasonVC.ordersData = ordersData
        returnReasonVC.dictInfo = dictInfo
            for i in dataArray{
                if i.isSelected{
                    returnReasonVC.dataArray.append(i)
                }
            }
           
            self.navigationController?.pushViewController(returnReasonVC, animated: true)
            
            
        }
        
        
     func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.headerTitle.text = "return_order".localized
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
        
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
   
}
extension ReturnOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! orderDetailCell
//        if indexPath.row == 0 {
//            cell.viewMultiQty.isHidden = false
//            cell.viewSingleQty.isHidden = true
//        }
//        else{
//            cell.viewMultiQty.isHidden = true
//            cell.viewSingleQty.isHidden = false
//        }
//         cell.btnInc.tag = indexPath.row
//        cell.btnInc.addTarget(self, action: #selector(qtyIncreaseAction(_:)), for: .touchUpInside)
        //if qty != 0{
        //cell.lblQty.text = "\(qty)"
        //}else{
        //    cell.lblQty.text = "\(dataArray[indexPath.row].quantity)"
        //}
       
//        cell.btnDec.addTarget(self, action: #selector(qtyReduceAction(_:)), for: .touchUpInside)
//        cell.btnDec.tag = indexPath.row
       cell.lblProductName.text = dataArray[indexPath.row].brand.uppercased()
        cell.lblMaterailType.text = dataArray[indexPath.row].name
        cell.lblPrice.text = "\(dataArray[indexPath.row].price) \((UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized)"
         let price = Double(Double(dataArray[indexPath.row].price)  ?? Double(0 * qty)).clean
        cell.lblSizeNumber.text = dataArray[indexPath.row].size
        cell.lblQtyValue.text =  "\(dataArray[indexPath.row].quantity)"//"\(dataFilterArray.count)"
        let url = dataArray[indexPath.row].imag_url
        cell.productImage.sd_setImage(with: URL(string: dataArray[indexPath.row].imag_url), placeholderImage: UIImage(named: "imagePlaceHolder"))
        cell.btnCheck.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
        cell.btnCheck.tag = indexPath.row
        if dataArray[indexPath.row].isSelected{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "blackMark"), for: .normal)
        }else{
            cell.btnCheck.setImage(nil, for: .normal)
        }
        //result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
        return cell
        
    }
    
    @IBAction func qtyReduceAction(_ sender: UIButton) {
        if(self.currentTag != sender.tag) {
            self.currentTag = sender.tag
            self.isFirstTime = true
        }
           let quentity:Int? = dataArray[sender.tag].quantity
        if(self.isFirstTime){ self.totalProducts = quentity!
            self.isFirstTime = false
            
        }
           if quentity! > 1 {
           qty = quentity! - 1
           
       let price = Double(Double(dataArray[sender.tag].price)  ?? Double(0 * qty)).clean
       dataArray[sender.tag].quantity = qty
       dataArray[sender.tag].price = price
       tblReturn.reloadData()
        }
       }
       
       @IBAction func qtyIncreaseAction(_ sender: UIButton) {
           let quantity:Int? = dataArray[sender.tag].quantity
            
        if qty  < self.totalProducts {
           qty = quantity! + 1
           let price = Double(Double(dataArray[sender.tag].price)  ?? Double(0 * qty)).clean
           
           dataArray[sender.tag].quantity = qty
           dataArray[sender.tag].price = price
           tblReturn.reloadData()
        }
       }
    
    @objc func onClickCheck(_ sender:UIButton){
        if dataArray[sender.tag].isSelected{
            dataArray[sender.tag].isSelected = false
            tblReturn.reloadData()
        }else{
            dataArray[sender.tag].isSelected = true
            tblReturn.reloadData()
        }
        var count = 0
        for i in dataArray{
            if i.isSelected{
                count = count + 1
            }
        }
        if count > 0{
        footer.btnContinue.alpha = 1.0
        footer.btnContinue.isUserInteractionEnabled = true
        }else{
            footer.btnContinue.alpha = 0.5
            footer.btnContinue.isUserInteractionEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected Row Return Order \(indexPath.row)")
              
        
    }
}
