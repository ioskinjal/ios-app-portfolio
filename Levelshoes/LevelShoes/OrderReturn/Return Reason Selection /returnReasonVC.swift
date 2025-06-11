//
//  returnReasonVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class returnReasonVC: UIViewController {
    
    @IBOutlet weak var returnTable: UITableView!
    @IBOutlet weak var lblReturnthisItem: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReturnthisItem.font = UIFont(name: "Cairo-SemiBold", size: lblReturnthisItem.font.pointSize)
            }
            lblReturnthisItem.text = "return_this_item".localized
        }
    }
    
    
    var arrReason = [[String:Any]]()
   
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var lblReasonMsg: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReasonMsg.font = UIFont(name: "Cairo-Light", size: lblReasonMsg.font.pointSize)
            }
            lblReasonMsg.text = "reason_msg".localized
            lblReasonMsg.addTextSpacing(spacing: 0.5)
        }
    }
    
    @IBOutlet weak var lblApply: UILabel!{
        didSet{
            lblApply.text = "apply".localized
            lblApply.addTextSpacing(spacing: 1.5)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblApply.font = UIFont(name: "Cairo-Regular", size: lblApply.font.pointSize)
            }
            
            
        }
    }

    @IBOutlet weak var btnApply: UIButton!
    
    var ordersData = orderReturnModel()
    var billingAddress = invoiceDetail()
    var shipingAddress = shipingDetail()
    var dataArray = [lineItems]()
    var strReason = ""
    var dictInfo = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ["The size doesn’t fit","I don’t like the product","The item is damaged","The packaging is tampered","I changed my mind"]
        
        //Code BY KInjal Ghadia
        var dictReason = ["reason":"The size doesn’t fit",
                          "isSelected":false] as [String : Any]
        
        arrReason.append(dictReason)
        
         dictReason = ["reason":"I don’t like the product",
                          "isSelected":false]
        
        arrReason.append(dictReason)
        
        dictReason = ["reason":"The item is damaged",
                                 "isSelected":false]
        
               
               arrReason.append(dictReason)
        
        dictReason = ["reason":"The packaging is tampered",
                                       "isSelected":false]
              
                     
                     arrReason.append(dictReason)
        
        dictReason = ["reason":"I changed my mind",
                                             "isSelected":false]
                    
                           
                           arrReason.append(dictReason)
        
        
        //End of Code//
        
        loadHeaderAction()
    
            
           
        
        // Do any additional setup after loading the view.
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
        header.headerTitle.text = "return_order".localized
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }

        
        //Code BY KInjal Ghadia
        for i in 0..<dataArray.count{
                       dataArray[i].reason = self.arrReason
                   }
        returnTable.reloadData()
        //End of Code//
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction Buttons
    @IBAction func applySelector(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "pickupAddress", bundle: Bundle.main)
        let returnReasonVC: pickupAddress! = storyboard.instantiateViewController(withIdentifier: "pickupAddress") as? pickupAddress
        returnReasonVC.dictInfo = dictInfo
        returnReasonVC.billingAddress = billingAddress
        returnReasonVC.dataArray = dataArray
        returnReasonVC.strReason = strReason
        returnReasonVC.shipingAddress = shipingAddress
        returnReasonVC.ordersData = ordersData
        returnReasonVC.billingAddress = billingAddress
        self.navigationController?.pushViewController(returnReasonVC, animated: true)
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
extension returnReasonVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray[section].reason.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 370
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnHeader:returnItemHeader = returnItemHeader()
        //returnHeader.lblPrice.text = "2,500 AED"
        returnHeader.lblTitle.text = dataArray[section].brand
        returnHeader.lblSubtitle.text = dataArray[section].name
        returnHeader.lblPrice.text = "\(dataArray[section].price) \((UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized)"
        returnHeader.lblQty.text = "\(dataArray[section].quantity)"
        returnHeader.productImage.downloadSdImage(url: dataArray[section].imag_url)
        return returnHeader
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let returnFooter:UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width , height: 30))
        let helperView =  UIView(frame: CGRect(x: 30, y: 0, width:tableView.frame.width - 60, height: 30))
        helperView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        returnFooter.addSubview(helperView)
        return returnFooter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reasonSelectionCell", for: indexPath) as! reasonSelectionCell
        let reasonStr = dataArray[indexPath.section].reason[indexPath.row]["reason"]as? String ?? ""
        cell.lblReason.text = reasonStr.localized
    
       
        if dataArray[indexPath.section].reason[indexPath.row]["isSelected"]as? Bool ?? false == true{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                 cell.lblReason.font = UIFont(name: "Cairo-SemiBold", size: cell.lblReason.font.pointSize)
            }else{
                cell.lblReason.font = BrandenFont.medium(with: 18.0)
            }
                
            cell.buttonSelect.isHidden = false
            }
            else{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                 cell.lblReason.font = UIFont(name: "Cairo-Light", size: cell.lblReason.font.pointSize)
            }else{
                cell.lblReason.font = BrandenFont.thin(with: 18.0)
            }
            cell.buttonSelect.isHidden = true
            }
    
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblApply.alpha = 1.0
        btnApply.isUserInteractionEnabled = true
        for j in 0..<dataArray[indexPath.section].reason.count{
                 dataArray[indexPath.section].reason[j]["isSelected"] = false
            }
        
       // DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
          self.dataArray[indexPath.section].reason[indexPath.row]["isSelected"] = true
            self.returnTable.reloadData()
       // })
        print("SeleCt your reason \(indexPath.row)")
        strReason = dataArray[indexPath.section].reason[indexPath.row]["reason"]as? String ?? ""
        dataArray[indexPath.section].returnReason = strReason
        
        //        let storyboard = UIStoryboard(name: "pickupAddress", bundle: Bundle.main)
        //                let returnReasonVC: pickupAddress! = storyboard.instantiateViewController(withIdentifier: "pickupAddress") as? pickupAddress
        //        self.navigationController?.pushViewController(returnReasonVC, animated: true)
        
    }
}
