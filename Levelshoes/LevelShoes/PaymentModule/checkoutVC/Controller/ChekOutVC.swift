//
//  ChekOutVC.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit
import MBProgressHUD

class ChekOutVC: UIViewController {
    
    var isNotLogin: Bool = true
    var clickCollectSize = 0.0
    let viewModel = CheckoutViewModel()
    var data: AddressInformation?
    
    var addressArray : [Addresses] = [Addresses]()
    var shippingAddresses : [Addresses] = [Addresses]()
    var billingAddresses : [Addresses] = [Addresses]()
    //Coming from ShoppingBagVC
    var coupon = ""    //pass
    var voucher = ""   //pass
    var totalCount = Int()   //pass
    var checkoutOrderSummary = [Double]()   //pass
    var checkoutCategories = [String]()   //pass
    var tbleData_CheckoutOrderSummary = [Double]()   //pass
    var tbleData_CheckoutCategories = [String]()   //pass
    var proceedToHomeDelivery: Bool = false
    
    // END
    
    
    var currency = UserDefaults.standard.value(forKey: string.currency) ?? "AED".localized
    
    var orderInformation: [String: Any] = [:]
    
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
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "checkout".localized.uppercased()
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells =
            [PaymentFlowCell.className,OrderHanldingCell.className,DeliveryNoteCell.className,InformationCell.className,PriceCell.className,NeedHelpBtn.className]
        
        tableView.register(cells)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var percent = "0"
        let tSegment: [TotalSegment]? = CartDataModel.shared.getCartTotalModel()?.totalSegments?.filter {$0.title == "VAT"}
        if(tSegment?.count ?? 0 > 0 ){
        if(tSegment?[0].extensionAttributes?.taxGrandtotalDetails?.count != 0){
            percent = tSegment?[0].extensionAttributes?.taxGrandtotalDetails?[0].rates?[0].percent as? String ?? ""
            }}
        print(percent ?? "")
        
        orderInformation["vat_persentage"] = percent ?? ""
        orderInformation["currency"] = currency
        orderInformation["orderSummary"] = checkoutOrderSummary
        orderInformation["totalItemCount"] = totalCount
        
         MBProgressHUD.showAdded(to: self.view, animated: true)
           viewModel.getAddrssInformation(success: { (response) in
            print(response)
            self.data = response
             guard let items = self.data?.addresses else {
                return
            }
           
            var list: [String: Any]
            self.addressArray = []
            if(items.count > 0){
            for i in 0...items.count-1{
                
                    self.addressArray.append(items[i])
                
                }}
            MBProgressHUD.hide(for: self.view, animated: true)
            //self.addressArray = items
    
            if self.addressArray.count > 0 {
                if self.proceedToHomeDelivery {
                    self.homeDelivery()
                }
            }
        }) {
            //Failure
        }
    
        if getWebsiteCurrency() == "AED"{
            clickCollectSize = 335
        }else{
            clickCollectSize = 0
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChekOutVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
            return tbleData_CheckoutCategories.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentFlowCell", for: indexPath) as? PaymentFlowCell else{return UITableViewCell()}
            cell.shippingImageView.image = #imageLiteral(resourceName: "check_payment")
           // cell.shippingLabel.textColor = UIColor.black
           // cell.shippingLabel.font = BrandenFont.medium(with: 16.0)
            cell.reviewImageView.image = UIImage(named: "Pending")
           // cell.reviewLabel.textColor = UIColor(red: 199 / 255, green: 199 / 255, blue: 199 / 255, alpha: 1.0)
           // cell.reviewLabel.font = BrandenFont.medium(with: 16.0)
            cell.paymentImageView.image = UIImage(named: "Current")
           // cell.paymentLabel.textColor = UIColor(red: 199 / 255, green: 199 / 255, blue: 199 / 255, alpha: 1.0)
          //  cell.paymentLabel.font = BrandenFont.medium(with: 16.0)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHanldingCell", for: indexPath) as? OrderHanldingCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryNoteCell", for: indexPath) as? DeliveryNoteCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case 4:
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell else {
                fatalError("Cell can't be dequeue")
            }
            if  tbleData_CheckoutCategories[indexPath.row].contains("Gift") || tbleData_CheckoutCategories[indexPath.row].contains("Discount") {
                cell.lblPrice.textColor = .red
            }
            else{
                cell.lblPrice.textColor = .black
            }
            /*
            if indexPath.row == 2 && checkoutCategories.count > 5 || indexPath.row == 1 {
               
                cell.lblPrice.textColor = .red
            }
            else{
                cell.lblPrice.textColor = .black
            
            }
 */
            cell.lblType.text = tbleData_CheckoutCategories[indexPath.row].localized
            cell.lblPrice.text = "\(currencyFormater(amount: tbleData_CheckoutOrderSummary[indexPath.row])) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
            if indexPath.row == self.tbleData_CheckoutCategories.count - 1{
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
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedHelpBtn", for: indexPath) as? NeedHelpBtn else{return UITableViewCell()}
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryNoteCell", for: indexPath) as? DeliveryNoteCell else{return UITableViewCell()}
            return cell
        }
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 92.4
        case 1: return 390
        case 2: return CGFloat(clickCollectSize)
        case 3: return 60
        case 4: return 54
        case 5: return 157
        default:
            return UITableViewAutomaticDimension
        }
    }
}
extension ChekOutVC: NeedHelpProtocol, HomeDeliveryProtocol, InformationProtocol, DeliveryNotesProtocol{
    func currencyFormater(amount: Double)-> String{
           let largeNumber = amount
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
        return amount.clean
        //return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
       }
    func collectAndPayAction() {
        var selectAddress: Addresses?
               for addr in 0..<addressArray.count{
                   if (addressArray[addr].defaultBilling ?? false) == true{
                       selectAddress = addressArray[addr]
                   }
               }
        if addressArray.count == 0 || selectAddress == nil{
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                     
                        let changeVC: AddNewAddressShippingViewController!
                        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
                       // changeVC.passd = passDataDict
                        changeVC.isFromEditAdd = false
                        changeVC.coupon = coupon
                        changeVC.voucher = voucher
                        changeVC.isFromClickCollect = true
                        changeVC.priceCategories = checkoutCategories
                        changeVC.checkoutOrderSummary = checkoutOrderSummary
                        changeVC.tblDataPriceCategories = tbleData_CheckoutCategories
                        changeVC.tblDataCheckoutOrderSummary = tbleData_CheckoutOrderSummary
                        changeVC.addressArray = addressArray
                        changeVC.OrderSummary = checkoutOrderSummary
                        changeVC.orderInformation = orderInformation
                        self.navigationController?.pushViewController(changeVC, animated: true)
        }else{
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: ProceedToPaymentViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
        changeVC.isClickAndcollect = true
        changeVC.coupon = coupon
        changeVC.priceCategories = checkoutCategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tbleData_CheckoutCategories
        changeVC.tblDataCheckoutOrderSummary = tbleData_CheckoutOrderSummary
        changeVC.isClickAndcollect = true
        changeVC.voucher = voucher
        changeVC.orderInformation = orderInformation
        changeVC.addressArray = addressArray
        changeVC.addressDict = selectAddress
        self.navigationController?.pushViewController(changeVC, animated: true)
        }
    }
    func homeDelivery() {
        if addressArray.count > 0{
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
            let changeVC: ChooseHDViewController!
            changeVC = storyboard.instantiateViewController(withIdentifier: "ChooseHDViewController") as? ChooseHDViewController
            changeVC.addressArray = addressArray
            changeVC.coupon = coupon
            changeVC.voucher = voucher
            changeVC.pricecategories = checkoutCategories
            changeVC.checkoutOrderSummary = checkoutOrderSummary
            changeVC.tblDataPricecategories = tbleData_CheckoutCategories
            changeVC.tblDatacheckoutOrderSummary = tbleData_CheckoutOrderSummary
            changeVC.homePaymentOrderSummary = orderInformation
            if self.proceedToHomeDelivery {
                self.navigationController?.pushViewController(changeVC, animated: false)
            }
            else{
                self.navigationController?.pushViewController(changeVC, animated: true)
            }
            
        }else{
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
            let changeVC: AddNewAddressShippingViewController!
            changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
           // changeVC.passd = passDataDict
            changeVC.isFromEditAdd = false
            changeVC.coupon = coupon
            changeVC.voucher = voucher
            changeVC.priceCategories = checkoutCategories
            changeVC.checkoutOrderSummary = checkoutOrderSummary
            changeVC.tblDataPriceCategories = tbleData_CheckoutCategories
            changeVC.tblDataCheckoutOrderSummary = tbleData_CheckoutOrderSummary
            changeVC.addressArray = addressArray
            changeVC.OrderSummary = checkoutOrderSummary
            changeVC.orderInformation = orderInformation
            self.navigationController?.pushViewController(changeVC, animated: true)
        }
    }
    func needHelp() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: NeedHelpBottomPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "NeedHelpBottomPopUpViewController") as? NeedHelpBottomPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    func showInformation() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: InformationPopUpViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "InformationPopUpViewController") as? InformationPopUpViewController
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
}


