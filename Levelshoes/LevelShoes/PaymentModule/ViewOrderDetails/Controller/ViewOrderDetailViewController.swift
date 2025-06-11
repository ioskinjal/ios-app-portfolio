//
//  ViewOrderDetailViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 25/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ViewOrderDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewOrderpaymentOrderSummary: [String: Any] = [:]
    var total = Int()
    var addressArray : Addresses?
    var currency = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells =
            [orderInformationTableViewCell.className, OrderSummaryCell.className,NeedHelpBtn.className]
        tableView.register(cells)
        
    }
    @IBAction func newReturnBtnAction(_ sender: UIButton) {
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ViewOrderDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderInformationTableViewCell", for: indexPath) as? orderInformationTableViewCell else{return UITableViewCell()}
            cell.circleLabel.layer.cornerRadius = cell.circleLabel.frame.height / 2
            cell.circleLabel.clipsToBounds = true
            if addressArray?.company != nil{
                 cell.lblAddType.text = "Work"
             }else{
                 cell.lblAddType.text = "Home"
             }
            cell.lblAdd.text = "\(addressArray?.firstname ?? "")" + " " + "\(addressArray?.lastname ?? "")" + "\n" + "\(addressArray?.street[0] ?? "" )" + "\n" +
                "\(addressArray?.street[1] ?? "" )" + "\n" + "\(addressArray?.city ?? "")" + "," + "\(addressArray?.countryId ?? "")"
            
            return cell
        }
        if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as? OrderSummaryCell else{return UITableViewCell()}
        
            let orderSummary = viewOrderpaymentOrderSummary["orderSummary"] as? [Double]
            cell.vatLabel.text = getVatName() + "(\(viewOrderpaymentOrderSummary["vat_persentage"] ?? ""))"
            cell.subtotalLeftLabel.text = "Subtotal".localized + "(\(viewOrderpaymentOrderSummary["totalItemCount"] ?? 0)" + "items".localized
            cell.subTotalLabel.text = currencyFormater(amount: orderSummary?[0] ?? 0.0) + " " + "\(viewOrderpaymentOrderSummary["currency"] ?? "")"
            cell.autoDiscount.text = currencyFormater(amount: orderSummary?[1] ?? 0.0) + " " + "\(viewOrderpaymentOrderSummary["currency"] ?? "")"
            cell.shippingLabel.text = currencyFormater(amount: orderSummary?[2] ?? 0.0) + " " + "\(viewOrderpaymentOrderSummary["currency"] ?? "")"
            cell.taxLabel.text =  currencyFormater(amount: orderSummary?[3] ?? 0.0) + " " + "\(viewOrderpaymentOrderSummary["currency"] ?? "")"
            cell.grandTotalLabel.text =  currencyFormater(amount: orderSummary?[4] ?? 0.0) + " " + "\(viewOrderpaymentOrderSummary["currency"] ?? "")"
            cell.totalItemLabel.text = "\(viewOrderpaymentOrderSummary["totalItemCount"] ?? 0)" + "items".localized
            return cell
        }
        if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedHelpBtn", for: indexPath) as? NeedHelpBtn else{return UITableViewCell()}
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return  120
        }
        return UITableViewAutomaticDimension
    }
}
extension ViewOrderDetailViewController: NeedHelpProtocol{
    func needHelp() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    func currencyFormater(amount: Double)-> String{
        let largeNumber = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return amount.clean
        //return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }
}
