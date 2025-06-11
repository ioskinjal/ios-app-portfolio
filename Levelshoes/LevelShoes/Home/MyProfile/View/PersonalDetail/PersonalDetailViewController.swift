//
//  PersonalDetailViewController.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
protocol PersonalDetailViewControllerDelegate: class {
    func didSelectedRowWith(indexPath: IndexPath)
}

class PersonalDetailViewController: UIViewController {
    let UserGeneralInfo = "UserGeneralInfo"
    let UserSecurityInfo = "UserSecurityInfo"
    let UserAddressBook = "UserAddressBook"
    let salutationcell = "salutation"
    let firstNameCell = "firstNameCell"
    let lastNameCell = "LstNameCell"
    let mobileNoCell = "mobileNoCell"
    let emailAddressCell = "emailAddressCell"
    let genderCell = "genderCell"
    // let birthDayCell = "birthDayCell"
    let csaveChangeCell = "saveChangeCell"
    let ckchangePasswordCell = "changePasswordCell"
    let homeAddressBookCell = "homeAddressBookCell"
    let workAddressBookCell = "workAddressBookCell"
    
    let otherAddressBookCell = "otherAddressBookCell"
    
    let addAddressBookCell = "addAddressBookCell"
    @IBOutlet weak var header: headerView!
    let preferredLanguage = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
    var cellArray = [String]()
    var sectionArray = [String]()
    var tableDic = [String:[String]]()
    var userData: AddressInformation?
    let checkoutModel = CheckoutViewModel()
    var addressArray : [Addresses] = [Addresses]()
    var counteryList = [[String:Any]] ()
    
    var workAddresses = [Addresses]()
    var homeAddresses = [Addresses]()
    var otherAddresses = [Addresses]()
    
    @IBOutlet weak var tableView: UITableView!
    var isEnglish: Bool = false
    var isArbic: Bool = false
    var dataDic = [String:String]()
    var ISD = "+ISD"
    override func viewDidLoad() {
        super.viewDidLoad()
        //get countery List with ISD code and name
        counteryList = getCountryList()
        dataDic =  ["dob":"","salutation":"","firstName":"","lastName":"","mobileNo":"","emailAddress":"","gender":""]
        var customAtr = self.userData?.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                dataDic["mobileNo"] = customAtrbt.value
            }
        }
        loadHeaderAction()
        updateLayoutForUser()
        
        tableView.separatorColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let cells =
            [UserGeneralInfoCellTableViewCell.className,UserSecurityInfoCell.className,UserAddressBookCell.className,
             personalDetailCell.className,saveChangeCell.className,changePasswordCell.className,addressBookCell.className,addAddressCell.className]
        tableView.register(cells)
        
    }
    override func viewWillAppear(_ animated: Bool)  {
        if UserDefaults.standard.value(forKey: "userToken") != nil {
            getUserDetail()
        }
    }
    func updateLayoutForUser(){
        
        if UserDefaults.standard.bool(forKey: string.isFBuserLogin){
            sectionArray = [UserGeneralInfo,UserAddressBook]
            tableDic = [UserGeneralInfo : [firstNameCell,lastNameCell,mobileNoCell,emailAddressCell,genderCell,csaveChangeCell],UserAddressBook :[homeAddressBookCell,workAddressBookCell,otherAddressBookCell,addAddressBookCell]]
        }else{
            sectionArray = [UserGeneralInfo,UserSecurityInfo,UserAddressBook]
            tableDic = [UserGeneralInfo : [firstNameCell,lastNameCell,mobileNoCell,emailAddressCell,genderCell,csaveChangeCell],UserSecurityInfo :[ckchangePasswordCell],UserAddressBook :[homeAddressBookCell,workAddressBookCell,otherAddressBookCell,addAddressBookCell]]
        }
        
        if addressArray.count > 0 {
            
            workAddresses.removeAll()
            homeAddresses.removeAll()
            otherAddresses.removeAll()
            tableDic[UserAddressBook] = []
            
            for i in 0..<addressArray.count{
                var dict = addressArray[i]
                
                dict.defaultShipping = false
                dict.defaultBilling = false
                
                userData?.addresses[i].defaultShipping = false
                userData?.addresses[i].defaultBilling = false
                
                
                if(addressArray.count == 1){
                    dict.defaultShipping = true
                    dict.defaultBilling = true
                    
                    userData?.addresses[i].defaultShipping = true
                    userData?.addresses[i].defaultBilling = true
                }
                else{
                    if let shippingId = self.userData?.defaultShipping{
                        if(Int(shippingId) == dict.id?.val){
                            dict.defaultShipping = true
                            userData?.addresses[i].defaultShipping = true
                        }
                    }
                    
                    if let billingId = self.userData?.defaultBilling{
                        if(Int(billingId) == dict.id?.val){
                            dict.defaultBilling = true
                            userData?.addresses[i].defaultBilling = true
                        }
                    }
                }

                if dict.customAttributes != nil{
                    if dict.customAttributes!.count > 0 {
                        let custom_attributes = dict.customAttributes![0]
                        if(custom_attributes.value! == "work"){
                            workAddresses.append(dict)
                            tableDic[UserAddressBook]?.append(workAddressBookCell)
                        }
                        else if(custom_attributes.value! == "home"){
                            homeAddresses.append(dict)
                            tableDic[UserAddressBook]?.append(homeAddressBookCell)
                        }
                        else if(custom_attributes.value! ==  "other"){
                            otherAddresses.append(dict)
                            tableDic[UserAddressBook]?.append(otherAddressBookCell)
                        }
                        
                    }
                }
                else{
                    otherAddresses.append(dict)
                    tableDic[UserAddressBook]?.append(otherAddressBookCell)
                }
                
            }
       
            tableDic[UserAddressBook]?.append(addAddressBookCell)
        }else{
            tableDic[UserAddressBook] = [addAddressBookCell]
        }
        
    }
    func updateUserDate(){
        dataDic =  ["dob":"\(userData?.dob ?? "")","salutation":"\(userData?.prefix ?? "")","firstName":"\(userData?.firstname ?? "")","lastName":"\(userData?.lastname ?? "")","mobileNo":"","emailAddress":"\(userData?.email ?? "")","gender":"\(userData?.gender ?? 0)"]
        var customAtr = self.userData?.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                dataDic["mobileNo"] = customAtrbt.value
            }
        }
    }
    func getUserDetail()  {
        checkoutModel.getAddrssInformation(success: { (response) in

            self.userData = response
            self.updateUserDate()
            guard let items = self.userData?.addresses else {
                return
            }
           
            self.addressArray = items
            DispatchQueue.main.async {
                self.updateLayoutForUser()
                self.tableView.reloadData()
            }
            
        }) {
            
        }
        
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
        header.headerTitle.text = "account_info".localized
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)
            
        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        self.navigationController?.popViewController(animated: true)
    }
    func saveChangeApiCall()  {
        
        var arrAddresses = [[String:Any]]()
        
        for i in 0..<addressArray.count{
            let addr = addressArray[i]
            
            
            
            var dictAddress = [String:Any]()
            dictAddress["id"] = addr.id?.val
            dictAddress["customer_id"] = addr.customerId
            
            var dictRegion = [String:Any]()
            
            dictRegion["region_code"] = addr.region?.regionCode
            dictRegion["region"] = addr.region?.region
            dictRegion["region_id"] = addr.region?.regionID
            
            
            dictAddress["region"] = dictRegion
            
            dictAddress["region_id"] = addr.regionId
            dictAddress["country_id"] = addr.countryId
            dictAddress["street"] = addr.street
            dictAddress["telephone"] = addr.telephone
            dictAddress["postcode"] = addr.postcode
            dictAddress["city"] = addr.city
            dictAddress["firstname"] = addr.firstname
            dictAddress["lastname"] = addr.lastname
            dictAddress["prefix"] = addr.prefix
            
            var arrCustomAttributes = [[String:Any]]()
            
            if addr.customAttributes != nil{
                
                for i in 0..<(addr.customAttributes?.count)!{
                    let attribute = addr.customAttributes?[i]
                    
                    var dictAttributes = [String:Any]()
                    dictAttributes["attribute_code"] = attribute?.attributeCode
                    dictAttributes["value"] = attribute?.value
                    
                    arrCustomAttributes.append(dictAttributes)
                }
            }
            
            dictAddress["custom_attributes"] = arrCustomAttributes
            
            arrAddresses.append(dictAddress)
            
        }
        
        print(arrAddresses.count)
        
        var dobstr = dataDic["dob"]?.replace(string: "/", replacement: "-")
        var mobno = ""
        if let number = dataDic["mobileNo"]{
            mobno = number
            print("mob no = \(mobno)")
        }
        var paramdata =
            [
                
                "customer": [
                    "prefix": dataDic["salutation"] ,
                    "firstname": dataDic["firstName"],
                    "lastname": dataDic["lastName"] ,
                    "email":dataDic["emailAddress"] ,
                    "middlename": "",
                    "dob": dobstr,
                    "gender": dataDic["gender"],
                    "store_id": userData?.storeId ,
                    "website_id": userData?.websiteId ,
                    "addresses": arrAddresses,
                    "custom_attributes": [
                        [
                            "attribute_code" : "telephone",
                            "value": dataDic["mobileNo"]
                        ]
                    ]
                    
                ]
                
                ] as! [String : Any]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.saveChangePref(params: paramdata, success: {  (response, error)  in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.updateLayoutForUser()
            self.tableView.reloadData()
            self.showThankyouPopup()
            
        }) {_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Error".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func showThankyouPopup() {
        let storyboard = UIStoryboard(name: "thanksPopup", bundle: Bundle.main)
        let popupVC: ThanksPopupVC! = storyboard.instantiateViewController(withIdentifier: "ThanksPopupVC") as? ThanksPopupVC
        popupVC.popupHeader = "Thanks".localized
        // popupVC.popupDesc = "Pass your ANy Desc Here TO see DESC"
        popupVC.popupDescHidden = true
        self.present(popupVC, animated: true, completion: nil)
        
    }
    func editAddressBook(Cell:addressBookCell){
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        let addressArrayObj = addressArray
      
//        if addressArrayObj.count > 0{
//            if Cell.cellType  == "homeAddressBookCell" {
//                addressArrayObj.removeFirst()
//            }else if Cell.cellType  == "homeAddressBookCell"{
//                addressArrayObj.removeLast()
//            }
//        }
       // print("cell address =\(Cell.addressdataCell)")
        changeVC.addressArray = addressArrayObj
        let addressdataCell = userData?.addresses[Cell.addressIndex]
       
        changeVC.selectedAddress = addressdataCell
        changeVC.userInfoDic = dataDic
        changeVC.editingRowIndex = Cell.addressIndex
        changeVC.isFromEditAdd = true
        changeVC.isFromMyAccount = true
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    
    func removeAddressBook(Cell:addressBookCell){
        
        let alertText = "removeAlert".localized
        let removeText = "remove".localized
        let refreshAlert = UIAlertController(title: removeText, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action: UIAlertAction!) in
            
            print(Cell.addressIndex)
            
            self.addressArray.remove(at: Cell.addressIndex)
            self.userData?.addresses.remove(at: Cell.addressIndex)
            self.updateLayoutForUser()
            self.tableView.reloadData()
            
            self.saveChangeApiCall()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
        
        
        
        //        var addressArrayObj = addressArray
        //        var params = [:] ;
        //        params["prefix"] = txtSalutaion.text
        //        params["firstname"] = txtFirstName.text
        //        params["lastname"] = txtLastName.text
        //        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else{
        //            return
        //        }
        //        params["email"] = email
        //        params["store_id"] = getStoreId()
        //        params["website_id"] = getWebsiteId()
        //        var strCountry:String = getM2StoreCode()
        //        let array = strCountry.components(separatedBy: "_")
        //        strCountry = array[0]
        //        var arrayStreet = [txtAddressLine1.text ?? "",txtAddressLine2.text ?? ""]
        //        var arrayAddress = [[String:Any]]()
    }
    
}
extension PersonalDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellString = tableDic[sectionArray[indexPath.section]]![indexPath.row]
        if cellString == csaveChangeCell || cellString == ckchangePasswordCell || cellString == addAddressBookCell  {
            return  113
        }
        else if cellString == homeAddressBookCell || cellString == workAddressBookCell || cellString == otherAddressBookCell{
            return UITableViewAutomaticDimension
        }
        return  90//UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 110
        }
        else{
            return 78
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let xPosition = preferredLanguage == "en" ? 30 : -30
        //let xPosition = 30
        print("Print Pos ==== \(xPosition) and \(preferredLanguage)")
        //            // Create the view.
        let tblheaderView = UIView()
        if sectionArray[section] == UserGeneralInfo {
            //add Size to headerview
            tblheaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 78)
            tblheaderView.backgroundColor = .white
            // Create the label that goes inside the view.
            let headerLabel = UILabel(frame: CGRect(x: xPosition, y: 40, width: Int(tableView.bounds.size.width), height: 27))
            headerLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 20)
            headerLabel.textColor = .black
            headerLabel.text = "accountInfoHelp".localized.uppercased() //self.sectionArray[section]
//            let attributedString = NSMutableAttributedString(string: headerLabel.text!)
//            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSRange(location: 0, length: headerLabel.text!.count))
//            headerLabel.attributedText = attributedString
            
            //headerLabel.sizeToFit()
            // headerView.frame = headerLabel.frame
            // Add label to the view.
            tblheaderView.addSubview(headerLabel)
            
        }
        else if sectionArray[section] == UserSecurityInfo  {
            //add Size to headerview
            tblheaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 78)
            tblheaderView.backgroundColor = .white
            // Create the label that goes inside the view.
            let headerLabel = UILabel(frame: CGRect(x: xPosition, y: 40, width: Int(tableView.bounds.size.width), height: 27))
            headerLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 20)
            headerLabel.textColor = .black
            headerLabel.text = "secureDetails".localized //self.sectionArray[section]
//            let attributedString = NSMutableAttributedString(string: headerLabel.text!)
//            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSRange(location: 0, length: headerLabel.text!.count))
//            headerLabel.attributedText = attributedString
            
            //headerLabel.sizeToFit()
            // headerView.frame = headerLabel.frame
            // Add label to the view.
            tblheaderView.addSubview(headerLabel)
        }
        else{
            //add Size to headerview
            tblheaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 110)
            tblheaderView.backgroundColor = .white
            // Create the label that goes inside the view.
            let headerLabel = UILabel(frame: CGRect(x: xPosition, y: 40, width: Int(tableView.bounds.size.width), height: 27))
            headerLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 20)
            headerLabel.textColor = .black
            headerLabel.text = "addDetails".localized //self.sectionArray[section]
//            let attributedString = NSMutableAttributedString(string: headerLabel.text!)
//            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSRange(location: 0, length: headerLabel.text!.count))
//            headerLabel.attributedText = attributedString
            
            //headerLabel.sizeToFit()
            // headerView.frame = headerLabel.frame
            // Add label to the view.
            tblheaderView.addSubview(headerLabel)
        }
        
        // Return view.
        return tblheaderView
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableDic[sectionArray[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = tableDic[sectionArray[indexPath.section]]![indexPath.row]
        
        switch cellString
        {
        case salutationcell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.delegate = self
            cell.cellType  = "salutationcell"
            cell.lblHeaderTitle.text = "Title".localized
            cell.txtUserdetail.text =    dataDic["salutation"]
            cell.updateprefixCell(selected:dataDic["salutation"] ?? "")
            cell.btnDropDown.setImage(UIImage(named: "ic_dropdown"), for: .normal)
            return cell
            
        case firstNameCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.txtUserdetail.keyboardType = .alphabet
            cell.delegate = self
            cell.cellType  = "firstNameCell"
            cell.lblHeaderTitle.text = "registerStarFirstName".localized
            cell.txtUserdetail.text =   dataDic["firstName"]  // userData?.firstname
            //  dataDic["firstName"] = cell.txtUserdetail.text
            cell.updateFirstName()
            cell.viewDropDown.isHidden = true
            return cell
        case lastNameCell:
            ///// updateFirstName() updateLastName() updateEmail()
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.delegate = self
            cell.txtUserdetail.keyboardType = .alphabet
            cell.lblHeaderTitle.text = "registerStarLastName".localized
            cell.txtUserdetail.text =   dataDic["lastName"] //userData?.lastname
            cell.viewDropDown.isHidden = true
            cell.cellType  = "lastNameCell"
            cell.updateLastName()
            // dataDic["lastName"] = cell.txtUserdetail.text
            return cell
        case mobileNoCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.delegate = self
            cell.txtUserdetail.keyboardType = .numberPad
            cell.lblHeaderTitle.text = "registerStarMobileNum".localized
            
            if dataDic["mobileNo"] == "" {
                cell.txtIsdcode.text = ISD
                cell.txtUserdetail.text = "0"
            }
            else{
                let CodeandNo = dataDic["mobileNo"]?.split(separator: "-")
                print("PRINTING CODE \(CodeandNo) and Count \(CodeandNo?.count)")
                if CodeandNo?.count ?? 0 > 1 {
                    cell.txtIsdcode.text = "+\(CodeandNo![0])"
                    cell.txtUserdetail.text = "\(CodeandNo![1])"
                }else{
                    cell.txtIsdcode.text = ISD
                    cell.txtUserdetail.text = "\(CodeandNo![0])"
                }
            }
            
            //
            cell.viewDropDown.isHidden = true
            cell.cellType  = "mobileNoCell"
            cell.showMobile(aBool: true)
            cell.updateIsdCode()
            return cell
            
        case emailAddressCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.delegate = self
            cell.lblStar.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            cell.lblHeaderTitle.text = "registerStarEmail".localized
            cell.lblHeaderTitle.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            cell.txtUserdetail.text = dataDic["emailAddress"]
            cell.txtUserdetail.isEnabled = false
            cell.txtUserdetail.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            cell.viewDropDown.isHidden = true
            cell.cellType  = "emailAddressCell"
            // dataDic["emailAddress"] = cell.txtUserdetail.text
            cell.updateEmail()
            return cell
        case genderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            cell.delegate = self
            cell.lblHeaderTitle.text = "Gender".localized
            cell.selectedGender = Int(dataDic["gender"] ?? "0")  ?? 0
            cell.viewDropDown.isHidden = false
            cell.btnDropDown.setImage(UIImage(named: "ic_dropdown"), for: .normal)
            cell.cellType  = "genderCell"
            cell.updategenderCell()
            //  dataDic["gender"] = "\(userData?.gender  ?? 0)"
            
            return cell
            //        case birthDayCell:
            //                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as? personalDetailCell else{return UITableViewCell()}
            //                        cell.delegate = self
            //                        cell.lblHeaderTitle.text = "Birthday".localized
            //                       //userData?.dob
            //                        cell.viewDropDown.isHidden = false
            //                        cell.cellType  = "birthDayCell"
            //                        cell.updatedateCell()
            //                         cell.txtUserdetail.text = dataDic["dob"]
            //                      //  dataDic["dob"] = cell.txtUserdetail.text
            //                        return cell
            
        case csaveChangeCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "saveChangeCell", for: indexPath) as? saveChangeCell else{return UITableViewCell()}
            cell.delegate = self
            cell.cellType  = "csaveChangeCell"
            return cell
            
        case ckchangePasswordCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath) as? changePasswordCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case homeAddressBookCell:
          
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell", for: indexPath) as? addressBookCell else{return UITableViewCell()}
            let firstName = userData?.addresses[indexPath.row].firstname ?? ""
            let lastName = userData?.addresses[indexPath.row].lastname ?? ""
            cell.lblUserName.text = "\(firstName) \(lastName)"
            cell.lblUserAddress.text = userData?.addresses[indexPath.row].street[0]
            cell.lblUserCountry.text =  userData?.addresses[indexPath.row].city
            print("index =\(indexPath.row) value =\(userData?.addresses[indexPath.row])")
            cell.addressdataCell = userData?.addresses[indexPath.row]
            cell.delegate = self
            cell.lblTitle.text = "Home"
            cell.viewDefault.isHidden = true
            cell.cellType  = "homeAddressBookCell"
            cell.btnRemove.tag = indexPath.row
            cell.btnEditAddress.tag = indexPath.row
            
            cell.btnRemove.isHidden = false
            cell.underline.isHidden = false
            cell.viewDefault.isHidden = true
            
            print("default shipping = \(userData?.addresses[indexPath.row].defaultShipping)")
            print("default shipping = \(userData?.addresses[indexPath.row].defaultShipping)")
            if(userData?.addresses[indexPath.row].defaultShipping == true || userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.btnRemove.isHidden = true
                cell.underline.isHidden = true
                cell.viewDefault.isHidden = false
            }
            if(userData?.addresses[indexPath.row].defaultShipping == true && userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.lblDefault.text = "DEFAULT"
                cell.viewDefaultWidth.constant = 60
            }
            else if(userData?.addresses[indexPath.row].defaultShipping == true){
                cell.lblDefault.text = "DEFAULT SHIPPING"
                cell.viewDefaultWidth.constant = 140
            }
            else if(userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.lblDefault.text = "DEFAULT BILLING"
                cell.viewDefaultWidth.constant = 140
            }
            
            return cell
        case workAddressBookCell:
           
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell", for: indexPath) as? addressBookCell else{return UITableViewCell()}
            let firstName = userData?.addresses[indexPath.row].firstname ?? ""
            let lastName = userData?.addresses[indexPath.row].lastname ?? ""
            cell.lblUserName.text = "\(firstName) \(lastName)"
            cell.lblUserAddress.text = userData?.addresses[indexPath.row].street[0]
            cell.lblUserCountry.text =  userData?.addresses[indexPath.row].city
            cell.addressdata = userData?.addresses[indexPath.row]
            cell.delegate = self
            
            if let _ = userData?.addresses[indexPath.row].company {
                 cell.lblTitle.text = "Work - " + (userData?.addresses[indexPath.row].company)!
            }
            else{
                 cell.lblTitle.text = "Work"
            }
            
            cell.viewDefault.isHidden = true
            cell.cellType  = "workAddressBookCell"
            cell.btnRemove.tag = indexPath.row
            
            cell.btnEditAddress.tag = indexPath.row
            cell.btnRemove.isHidden = false
            cell.underline.isHidden = false
            cell.viewDefault.isHidden = true
            
            if(userData?.addresses[indexPath.row].defaultShipping == true || userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.btnRemove.isHidden = true
                cell.underline.isHidden = true
                cell.viewDefault.isHidden = false
            }
            
            if(userData?.addresses[indexPath.row].defaultShipping == true && userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.lblDefault.text = "DEFAULT"
                cell.viewDefaultWidth.constant = 60
            }
            else if(userData?.addresses[indexPath.row].defaultShipping == true){
                cell.lblDefault.text = "DEFAULT SHIPPING"
                cell.viewDefaultWidth.constant = 140
            }
            else if(userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.lblDefault.text = "DEFAULT BILLING"
                cell.viewDefaultWidth.constant = 140
            }
            
            return cell
        case otherAddressBookCell:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell", for: indexPath) as? addressBookCell else{return UITableViewCell()}
            let firstName = userData?.addresses[indexPath.row].firstname ?? ""
            let lastName = userData?.addresses[indexPath.row].lastname ?? ""
            cell.lblUserName.text = "\(firstName) \(lastName)"
            cell.lblUserAddress.text = userData?.addresses[indexPath.row].street[0]
            cell.lblUserCountry.text =  userData?.addresses[indexPath.row].city
            cell.addressdata = userData?.addresses[indexPath.row]
            cell.delegate = self
            cell.lblTitle.text = "Other"
            cell.viewDefault.isHidden = true
            cell.cellType  = "otherAddressBookCell"
            cell.btnRemove.tag = indexPath.row
            
            cell.btnEditAddress.tag = indexPath.row
            cell.btnRemove.isHidden = false
            cell.underline.isHidden = false
            cell.viewDefault.isHidden = true
            
            if(userData?.addresses[indexPath.row].defaultShipping == true || userData?.addresses[indexPath.row].defaultBilling == true ){
                cell.btnRemove.isHidden = true
                cell.underline.isHidden = true
                cell.viewDefault.isHidden = false
            }
            
              if(userData?.addresses[indexPath.row].defaultShipping == true && userData?.addresses[indexPath.row].defaultBilling == true ){
                       cell.lblDefault.text = "DEFAULT"
                       cell.viewDefaultWidth.constant = 60
                   }
                   else if(userData?.addresses[indexPath.row].defaultShipping == true){
                       cell.lblDefault.text = "DEFAULT SHIPPING"
                       cell.viewDefaultWidth.constant = 140
                   }
                   else if(userData?.addresses[indexPath.row].defaultBilling == true ){
                       cell.lblDefault.text = "DEFAULT BILLING"
                       cell.viewDefaultWidth.constant = 140
                   }
            
            return cell
        case addAddressBookCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAddressCell", for: indexPath) as? addAddressCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserGeneralInfoCellTableViewCell", for: indexPath) as? UserGeneralInfoCellTableViewCell else{return UITableViewCell()}
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellString = tableDic[sectionArray[indexPath.section]]![indexPath.row]
        //            var cellString = cellArray[indexPath.row]
        print("Inside Pressed \(cellString)")
        switch cellString
        {
        case ckchangePasswordCell:
            let storyboard = UIStoryboard(name: "changePassword", bundle: Bundle.main)
            let returnOrderVC: changePasswordVC! = storyboard.instantiateViewController(withIdentifier: "changePasswordVC") as? changePasswordVC
            self.navigationController?.pushViewController(returnOrderVC, animated: true)
        case addAddressBookCell :
            
            
            let changeVC: AddNewAddressShippingViewController!
            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
            changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
            changeVC.isFromClickCollect = false
            changeVC.isFromEditAdd = false
            changeVC.addressArray = addressArray
            changeVC.isFromMyAccount = true
            changeVC.userInfoDic = dataDic
            self.navigationController?.pushViewController(changeVC, animated: true)
        default:
            print("Hari bol")
        }
    }
}

extension PersonalDetailViewController: MyLanguageTableViewCellDelegate{
    
    func selectArabic() {
        isArbic = true
        isEnglish = false
    }
    
    func selectEnglish() {
        isArbic = false
        isEnglish = true
    }
    
    
}
extension PersonalDetailViewController: PersnolDetailBaseCellDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField, withCell:PersnolDetailBaseCell ){
        
    }
    func textFieldDidChangeSelection(_ textField: UITextField, withCell:PersnolDetailBaseCell){
        
        switch withCell.cellType {
        case "birthDayCell":
            dataDic["birthDay"] = textField.text
        case "salutationcell":
            dataDic["salutation"] = textField.text
        case "firstNameCell":
            dataDic["firstName"] =  withCell.txtUserdetail.text//textField.text
        case "lastNameCell":
            dataDic["lastName"] = withCell.txtUserdetail.text//textField.text
        case "mobileNoCell":
            dataDic["mobileNo"] =  withCell.txtUserdetail.text//textField.text
            print("MObile NO \(dataDic["mobileNo"])")
        case "emailAddressCell":
            dataDic["emailAddress"] = textField.text
        case "genderCell":
            dataDic["gender"] = "\(withCell.selectedGender)"
            
        default:
            return
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField,withCell:PersnolDetailBaseCell){
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String,withCell:PersnolDetailBaseCell) -> Bool{
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField,withCell:PersnolDetailBaseCell) -> Bool{
        return true
    }
    
    func saveChangeBtnPress(){
        self.saveChangeApiCall()
    }
    func updateDob(_ textField: UITextField,withCell:PersnolDetailBaseCell){
        dataDic["dob"] = textField.text
    }
    func updatePrifex(_ textField: UITextField,withCell:PersnolDetailBaseCell){
        dataDic["salutation"] = textField.text
    }
    func updateGender(_ textField: UITextField,withCell:PersnolDetailBaseCell){
        dataDic["gender"] = "\(withCell.selectedGender)"
    }
    func updateMobileNumber(_ textField: UITextField,withCell:PersnolDetailBaseCell){
        
        let test = "\(withCell.txtIsdcode.text!)-\(withCell.txtUserdetail.text!)"
        ISD = withCell.txtIsdcode.text!
        if ISD.uppercased() == "+ISD" {
            ISD = ""
        }
        print("UPdated NO \(test)")
        
        dataDic["mobileNo"] = "\(ISD)-\(withCell.txtUserdetail.text!)"
        
    }
}


