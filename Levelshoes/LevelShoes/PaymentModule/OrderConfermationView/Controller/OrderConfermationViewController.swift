//
//  OrderConfermationViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class OrderConfermationViewController: UIViewController {

    @IBOutlet weak var viewOrderBtnOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblheaderTitle: UILabel!{
        didSet{
            lblheaderTitle.text = "orderConfirm".localized.uppercased()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblheaderTitle.font =  UIFont(name: "Cairo-SemiBold", size: 14)
            }
        }
    }
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            btnContinue.setTitle("continue_shopping".localized, for: .normal)
            btnContinue.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }
    @IBOutlet weak var btnViewOrderDetails: UIButton!{
        didSet{
            btnViewOrderDetails.setTitle("view_order_details".localized, for: .normal)
            btnViewOrderDetails.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }
    
     let viewModel = CheckoutViewModel()
    var priceCategories = [String]()
    var tblPriceCategories = [String]()
     var addressArray: Addresses?
     var confirmpaymentOrderSummary = [Double]()
    var tblConfirmpaymentOrderSummary = [Double]()
     var currency = String()
    var orderId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells =
            [ThanksTableViewCell.className, WhathappenTableViewCell.className,PriceCell.className, NeedHelpBtn.className]
        tableView.register(cells)
        
        UserDefaults.standard.set(0, forKey: string.shopBagItemCount)
        NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // continueShoppingAction(UIButton())
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func crossBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
               let changeVC: ShoppingBagVC!
               changeVC = storyboard.instantiateViewController(withIdentifier: "ShoppingBagVC") as? ShoppingBagVC
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    @IBAction func continueShoppingAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
               let changeVC: LatestHomeViewController!
               changeVC = storyboard.instantiateViewController(withIdentifier: "LatestHomeViewController") as? LatestHomeViewController
        self.navigationController?.pushViewController(changeVC, animated: true)
        
        
        /* below code will keep user on same tab i.e shopping
        self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            if vc.isKind(of: ShoppingBagVC.self) {
                return false
            } else {
                return true
            }
        })
       */
    }
    @IBAction func viewOrderDetailAction(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
//        let changeVC: ViewOrderDetailViewController!
//        changeVC = storyboard.instantiateViewController(withIdentifier: "ViewOrderDetailViewController") as? ViewOrderDetailViewController
//        changeVC.viewOrderpaymentOrderSummary = confirmpaymentOrderSummary
//        changeVC.currency = currency
//        changeVC.addressArray = addressArray
//        self.navigationController?.pushViewController(changeVC, animated: true)
        let storyboard = UIStoryboard(name: "orderDetail", bundle: Bundle.main)
                       let orderDetailVC: orderDetailVC! = storyboard.instantiateViewController(withIdentifier: "orderDetailVC") as? orderDetailVC
               orderDetailVC.orderId = "\(orderId)"
               self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    override func viewDidLayoutSubviews() {
//        viewOrderBtnOutlet.layer.cornerRadius = 5
//        viewOrderBtnOutlet.layer.borderWidth = 1
//        viewOrderBtnOutlet.layer.borderColor = UIColor.black.cgColor
    }
}
extension OrderConfermationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return tblPriceCategories.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThanksTableViewCell", for: indexPath) as? ThanksTableViewCell else{return UITableViewCell()}
            cell.lblThanks.text = "Thanks".localized + " \(UserDefaults.standard.value(forKey: "firstname") ?? "")"
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WhathappenTableViewCell", for: indexPath) as? WhathappenTableViewCell else{return UITableViewCell()}
            return cell
        case 2:
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell else {
                                      fatalError("Cell can't be dequeue")
                                  }
             // if indexPath.row == 2 && priceCategories.count > 5 || indexPath.row == 1 {
            if  tblPriceCategories[indexPath.row].contains("Gift") || tblPriceCategories[indexPath.row].contains("Discount") {
                cell.lblType.text = tblPriceCategories[indexPath.row].localized
                cell.lblPrice.text = "\(currencyFormater(amount: tblConfirmpaymentOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
                  cell.lblPrice.textColor = .red
              }
              else{
                  cell.lblPrice.textColor = .black
                cell.lblType.text = tblPriceCategories[indexPath.row].localized
                cell.lblPrice.text = "\(currencyFormater(amount: tblConfirmpaymentOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
              }
              if indexPath.row == self.tblPriceCategories.count - 1{
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
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedHelpBtn", for: indexPath) as? NeedHelpBtn else{return UITableViewCell()}
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 350
        case 1: return 280
        case 2: return 54
        case 3: return 173
        default:
            return UITableViewAutomaticDimension
        }
    }
}
extension OrderConfermationViewController: NeedHelpProtocol{
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
        // return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }
}
