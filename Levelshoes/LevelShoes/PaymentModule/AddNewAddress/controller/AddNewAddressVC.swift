//
//  AddNewAddressVC.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit
import DropDown


class AddNewAddressVC: UIViewController {
    
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
    @IBOutlet weak var lblPagetitle: UILabel!{
        didSet{
            lblPagetitle.text = "home_delivery".localized
            lblPagetitle.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var btnProceed: UIButton!{
        didSet{
            btnProceed.setTitle("proceed_payment", for: .normal)
            btnProceed.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }
    @IBOutlet weak var totalAmount: UILabel!
    var isWork: Bool = false
    var isHome: Bool = false
    var isOther: Bool = false
    var isDefaultAddress: Bool = false
    var params:[String:Any] = [:]
    let dropDown = DropDown()
    
    let viewModel = AddNewAddressViewModel()
    var homePaymentOrderSummary: [String: Any] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    var addressNameDetail = ["Salutation","First Name","Last Name","Phone Number"]
    let addressDetail = ["City","Address line 1","Address line 2","Flat/House no.","Shipping notes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.isValidationError = {(msg) in
            self.validationMsg(msg: msg)
        }
        let cell = [AddressNameCell.className,addressTextFieldCell.className,setDefaultAdress.className,SelectCountryTableViewCell.className,shoppingNotesTableViewCell.className,DeliveryOptionTableViewCell.className,HDDeliverySelectionTableCell.className]
        tableView.register(cell)
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        let orderSummary = homePaymentOrderSummary["orderSummary"] as? [Double]
        totalAmount.text = currencyFormater(amount: orderSummary?[4] ?? 0.0) + " " + "\(homePaymentOrderSummary["currency"] ?? "")"
            setAddressDict()
    }
    
    func setAddressDict(){
        params = [:]
        
        params["10"] = ""
        params["defaultShipping"] = true
        
        for index in 0..<addressNameDetail.count{
            let tag = "1\(index+1)"
            params[tag] = ""
        }
        for index in 0..<addressDetail.count{
            let tag = "3\(index)"
            params[tag] = ""
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceed(_ sender:UIButton){
        if viewModel.validate(params, isWork: isWork){
            viewModel.addAddress({ (response) in
                guard let address:AddressInformation = response as? AddressInformation else {
                    return
                }
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                    let changeVC: ProceedToPaymentViewController!
                    changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
                    changeVC.address = address
                    changeVC.orderInformation = self.homePaymentOrderSummary
                    
                    self.navigationController?.pushViewController(changeVC, animated: true)
                }
            }) { (errorResponse) in
                if let code:Int = errorResponse["code"] as? Int{
                    print(code)
                     //validationMsg(msg: code)
                }
                if let message:String = errorResponse["message"] as? String{
                    print(message)
                    self.validationMsg(msg: message)
                }
            }
        }
    }
    func validationMsg(msg: String){
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)

    }
}
extension AddNewAddressVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        if section == 1{
            /*if isWork == true{
                return 5
            }*/
            return addressNameDetail.count
        }
        if section == 2{
            return 1
        }
        if section == 3{
            return addressDetail.count
        }
        if section == 4{
           // return 1
            return 0
        }
        if section == 5{
            return 1
        }
        if section == 6{
            return 1
        }
        if section == 7{
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressNameCell", for: indexPath) as? AddressNameCell else{return UITableViewCell()}
            cell.delegate = self
            if isWork == true{
                cell.workBtnOutlet.backgroundColor = UIColor.black
                cell.workBtnOutlet.setTitleColor(UIColor.white, for: .normal)
                cell.homeBtnOutlet.backgroundColor = UIColor.white
                cell.homeBtnOutlet.setTitleColor(UIColor.black, for: .normal)
                cell.otherBtnOutlet.backgroundColor = UIColor.white
            }
            if isHome == true{
                cell.workBtnOutlet.backgroundColor = UIColor.white
                cell.workBtnOutlet.setTitleColor(UIColor.black, for: .normal)
                cell.homeBtnOutlet.backgroundColor = UIColor.black
                cell.homeBtnOutlet.setTitleColor(UIColor.white, for: .normal)
                cell.otherBtnOutlet.backgroundColor = UIColor.white
            }
            return cell
        }
        if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTextFieldCell", for: indexPath) as? addressTextFieldCell else{return UITableViewCell()}
            
            cell.delegate = self
            cell.addressTF.placeholder = addressNameDetail[indexPath.row]
            if isWork{
                cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row)")!
                cell.addressTF.text = params["\(indexPath.section)\(indexPath.row)"] as? String
                
                if Int("\(indexPath.section)\(indexPath.row)")! == 11{
                    dropDown.anchorView = cell.addressTF
                    //cell.addressTF.inputView = dropDown
                    cell.dropDownBtnOutlet.isHidden = false
                    cell.dropDownIcon.isHidden = false
                    cell.dropDownBtnOutlet.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
                }else{
                    //cell.addressTF.inputView = nil
                     cell.dropDownBtnOutlet.isHidden = true
                     cell.dropDownIcon.isHidden = true
                }
            }else{
              cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row + 1)")!
                cell.addressTF.text = params["\(indexPath.section)\(indexPath.row + 1)"] as? String
                
                if Int("\(indexPath.section)\(indexPath.row + 1)")! == 11{
                    dropDown.anchorView = cell.addressTF
                    //cell.addressTF.inputView = dropDown
                    cell.dropDownBtnOutlet.isHidden = false
                    cell.dropDownIcon.isHidden = false
                    cell.dropDownBtnOutlet.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
                }else{
                    //cell.addressTF.inputView = nil
                     cell.dropDownBtnOutlet.isHidden = true
                     cell.dropDownIcon.isHidden = true
                }
            }
            
            return cell
        }
        if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCountryTableViewCell", for: indexPath) as? SelectCountryTableViewCell else{return UITableViewCell()}
            return cell
        }
        if indexPath.section == 3{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTextFieldCell", for: indexPath) as? addressTextFieldCell else{return UITableViewCell()}
            cell.delegate = self
            cell.addressTF.placeholder = addressDetail[indexPath.row]
            cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row)")!
            cell.addressTF.text = params["\(indexPath.section)\(indexPath.row)"] as? String
            
            cell.dropDownBtnOutlet.isHidden = true
            cell.dropDownIcon.isHidden = true
            return cell
        }
        if indexPath.section == 4{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingNotesTableViewCell", for: indexPath) as? shoppingNotesTableViewCell else{return UITableViewCell()}
            
            return cell
        }
        if indexPath.section == 5{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "setDefaultAdress", for: indexPath) as? setDefaultAdress else{return UITableViewCell()}
            cell.delegate = self
            if params["defaultShipping"] as? Bool ?? false{
                cell.defaultAddressBtnOutlet.setImage(UIImage(named: "ic_switch_on"), for: .normal)
            }else{
                cell.defaultAddressBtnOutlet.setImage(UIImage(named: "ic_switch_off"), for: .normal)
            }
            return cell
        }
        if indexPath.section == 6{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryOptionTableViewCell", for: indexPath) as? DeliveryOptionTableViewCell else{return UITableViewCell()}
            return cell
        }
        if indexPath.section == 7{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HDDeliverySelectionTableCell", for: indexPath) as? HDDeliverySelectionTableCell else{return UITableViewCell()}
            return cell
        }
        return UITableViewCell()
    }
}
extension AddNewAddressVC: AddrerssNameProtocol, DefaultAddressProtocol{
    func currencyFormater(amount: Double)-> String{
        let largeNumber = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return amount.clean
        //return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }
    func defaultAddress() {
        params["defaultShipping"] = !(params["defaultShipping"] as! Bool)
        tableView.reloadData()
    }
    func work() {
        isWork = true
        isHome = false
        
        let addDetail = addressNameDetail
        addressNameDetail.removeAll()
        addressNameDetail.append("Company Name")
        addressNameDetail.append(contentsOf: addDetail)
        tableView.reloadData()
    }
       func home() {
        isWork = false
        isHome = true
        if addressNameDetail.contains("Company Name"){
            addressNameDetail.remove(object: "Company Name")
        }
        tableView.reloadData()
    }
    func other() {
        if addressNameDetail.contains("Company Name"){
            addressNameDetail.remove(object: "Company Name")
        }
        isWork = false
        isHome = true
        tableView.reloadData()
    }
}
extension AddNewAddressVC : addressTextDelegate{
    func addressText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String){
        let text:String =  textField.text! + string
        
        /*let pointInTableView = textField.convert(textField.bounds.origin, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: pointInTableView)
         */
        params["\(textField.tag)"] = text
    }
    @objc func showDropDown(){
        
        dropDown.show()
        dropDown.dataSource = ["Mr","Mrs"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height ?? 0.0) + 10))
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.params["11"] = item
            self.tableView.reloadData()
        }
    }
}
