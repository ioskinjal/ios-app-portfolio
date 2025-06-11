//
//  AddNewAddressShippingViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField
import DropDown
import MBProgressHUD

var isHome: Bool = false
var isWork: Bool = false
var isBillingWork = false
var isOther: Bool = false
class AddNewAddressShippingViewController: UIViewController , saveAddressProceed {
    
    let CountryCodePickerBilling = UIPickerView()
    @IBOutlet weak var txtContryCodeBilling: RMTextField!{
        didSet{
            // txtContryCodeBilling.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            CountryCodePickerBilling.delegate = self
            self.txtContryCodeBilling.inputView = self.CountryCodePickerBilling
            txtContryCodeBilling.dtLayer.isHidden = true
            
            txtContryCodeBilling.placeholder = "lblcc".localized
            if UserDefaults.standard.string(forKey: string.language) == string.ar {
                txtContryCodeBilling.textAlignment = .right
            }else{
                txtContryCodeBilling.textAlignment = .left
            }
            
        }
    }
    let CountryCodePicker = UIPickerView()
    @IBOutlet weak var txtCountryCode: RMTextField!{
        didSet{
            // txtCountryCode.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            CountryCodePicker.delegate = self
            self.txtCountryCode.inputView = self.CountryCodePicker
            txtCountryCode.placeholder = "lblcc".localized
            txtCountryCode.dtLayer.isHidden = true
            
            if UserDefaults.standard.string(forKey: string.language) == string.ar {
                txtCountryCode.textAlignment = .right
            }else{
                txtCountryCode.textAlignment = .left
            }
        }
    }
    
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
    @IBOutlet weak var icFlag: UIImageView!
    @IBOutlet weak var icBillingFlag: UIImageView!
    @IBOutlet weak var viewBillinAddType: UIView!
    @IBOutlet weak var btnBillingOther: UIButton!{
        didSet {
            btnBillingOther.setTitle("Other".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnBillingHome: UIButton!{
        didSet {
            btnBillingHome.setTitle("Home".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnBillingWork: UIButton!{
        didSet {
            btnBillingWork.setTitle("Work".localized, for: .normal)
        }
    }
    @IBOutlet weak var errorBillingCompany: UILabel!
    @IBOutlet weak var linebillingCompany: UIView!
    @IBOutlet weak var icBillingCompany: UIImageView!
    @IBOutlet weak var viewBillingCompany: UIView!
    @IBOutlet weak var txtBillingCompany: RMTextField!{
        didSet{
            txtBillingCompany.placeHolder(text:"Company Name*".localized, textfieldname: txtBillingCompany)
            txtBillingCompany.addTarget(self, action: #selector(didChangeBillingCompanyName(textField:)), for: .editingChanged)
            txtBillingCompany.dtLayer.isHidden = true
            txtBillingCompany?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }
    }
    @IBOutlet weak var errorBillingSalutation: UILabel!
    
    @IBOutlet weak var lblAddbillingAdd: UILabel!{
        didSet{
            lblAddbillingAdd.text = "addBillingAddress".localized
        }
    }
    @IBOutlet weak var lineBillingsalutation: UIView!
    let saluttionPickerBilling = UIPickerView()
    @IBOutlet weak var stackViewShipping: UIStackView!
    @IBOutlet weak var billingTxtSalutation: UITextField!{
        didSet{
            billingTxtSalutation.placeHolder(text:"title".localized, textfieldname: billingTxtSalutation)
            saluttionPickerBilling.delegate = self
            self.billingTxtSalutation.inputView = self.saluttionPickerBilling
           // billingTxtSalutation.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            
        }
    }
    @IBOutlet weak var icBillingSalutation: UIImageView!
    @IBOutlet weak var lineCity: UIView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "home_delivery".localized.uppercased()
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    
    @IBOutlet weak var lblAddressNmHead: UILabel!{
        didSet{
            lblAddressNmHead.text = "add_name".localized
        }
    }
    @IBOutlet weak var cityError: UILabel!
    @IBOutlet weak var icCity: UIImageView!
    @IBOutlet weak var lineSalutation: UIView!
    @IBOutlet weak var salutationError: UILabel!
    @IBOutlet weak var icSalutation: UIImageView!
    @IBOutlet weak var errorCompanyName: UILabel!
    @IBOutlet weak var lineCompanyName: UIView!
    @IBOutlet weak var icCompnayName: UIImageView!
    @IBOutlet weak var lineAddress: UILabel!
    @IBOutlet weak var lineAdd2: UIView!
    @IBOutlet weak var lineFirstNm: UIView!
    @IBOutlet weak var lineAdd1: UIView!
    @IBOutlet weak var linePhone: UIView!
    @IBOutlet weak var lineLnm: UIView!
    @IBOutlet weak var icAddress: UIImageView!
    @IBOutlet weak var addressError: UILabel!
    @IBOutlet weak var ic_line2: UIImageView!
    @IBOutlet weak var icLine1: UIImageView!
    @IBOutlet weak var addLine2Error: UILabel!
    @IBOutlet weak var addLine1Error: UILabel!
    @IBOutlet weak var ic_phone: UIImageView!
    @IBOutlet weak var phoneError: UILabel!
    @IBOutlet weak var icFnm: UIImageView!
    @IBOutlet weak var icLnm: UIImageView!
    @IBOutlet weak var lastNmError: UILabel!
    @IBOutlet weak var errorBillingLnm: UILabel!
    @IBOutlet weak var icBillingLastNm: UIImageView!
    @IBOutlet weak var txtBillingLastName: RMTextField!{
        didSet{
            
            
            txtBillingLastName.placeHolder(text: "lName".localized, textfieldname: txtBillingLastName)
            txtBillingLastName.addTarget(self, action: #selector(didChangeLastNameBilling(textField:)), for: .editingChanged)
            txtBillingLastName.dtLayer.isHidden = true
            txtBillingLastName?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            
        }
    }
    @IBOutlet weak var lineBillingLnm: UIView!
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var txtLastName: RMTextField!{
        didSet{
            txtLastName.placeHolder(text: "lName".localized, textfieldname: txtLastName)
            txtLastName.addTarget(self, action: #selector(didChangeLastName), for: .editingChanged)
            txtLastName.dtLayer.isHidden = true
            txtLastName?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            
        }
    }
    @IBOutlet weak var btnDefault: UIButton!
    
    @IBOutlet weak var lblCount: UILabel!
    let cityPicker = UIPickerView()
    @IBOutlet weak var txtCity: RMTextField!{
        didSet{
            txtCity.placeHolder(text: "City*".localized, textfieldname: txtCity)
            cityPicker.delegate = self
            self.txtCity.inputView = self.cityPicker
            txtCity.dtLayer.isHidden = true
            txtCity.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtCity.addTarget(self, action: #selector(didChangeCity(textField:)), for: .editingChanged)
            
        }
    }
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblSelectCountry: UILabel!{
        didSet{
            lblSelectCountry.text = "Select Country".localized
        }
    }
    @IBOutlet weak var txtAddressLine2: RMTextField!{
        didSet{
            txtAddressLine2.placeHolder(text: "addLineSecond".localized, textfieldname: txtAddressLine2)
            txtAddressLine2.addTarget(self, action: #selector(didChangeAddLine2), for: .editingChanged)
            txtAddressLine2.dtLayer.isHidden = true
            txtAddressLine2?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtAddressLine2.delegate = self
        }
    }
    
    @IBOutlet weak var txtAddress: UITextView!{
        didSet{
            txtAddress.text = "Shipping Notes"
            txtAddress.textColor = UIColor.init(hexString: "474747")
            // txtAddress.addTarget(self, action: #selector(didChangeShoppingNotes), for: .editingChanged)
            txtAddress.delegate = self
        }
    }
    @IBOutlet weak var btnSaveAddress: UIButton!{
        didSet{
            
            btnSaveAddress.setTitle("save_add".localized, for: .normal)
            btnSaveAddress.addTextSpacing(spacing: 1.0, color: "FFFFFF")
            
        }
    }
    @IBOutlet weak var txtAddressLine1: RMTextField!{
        didSet{
            txtAddressLine1.placeHolder(text: "addLineFirst".localized, textfieldname: txtAddressLine1)
            txtAddressLine1.addTarget(self, action: #selector(didChangeAddLine1), for: .editingChanged)
            txtAddressLine1.dtLayer.isHidden = true
            txtAddressLine1?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtAddressLine1.delegate = self
        }
    }
    
    @IBOutlet weak var txtPhoneNumber: RMTextField!{
        didSet{
            txtPhoneNumber.placeHolder(text: "fNumber".localized, textfieldname: txtPhoneNumber)
            txtPhoneNumber.addTarget(self, action: #selector(didChangePhoneNumber), for: .editingChanged)
            txtPhoneNumber.dtLayer.isHidden = true
            txtPhoneNumber?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtPhoneNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCompanyName: RMTextField!{
        didSet{
            txtCompanyName.placeHolder(text:"Company Name*".localized, textfieldname: txtCompanyName)
            txtCompanyName.addTarget(self, action: #selector(didChangeCompanyName), for: .editingChanged)
            txtCompanyName.dtLayer.isHidden = true
            txtCompanyName?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }
    }
    var cityData : NewInData?
    var isFromClickCollect = false
    var selectedAddress:Addresses?
    var arrSalutation = ["Mrs".localized,"Ms".localized,"Mr".localized]
    let saluttionPicker = UIPickerView()
    var userInfoDic = [String:String]()
     var data: AddressInformation?
    
    @IBOutlet weak var txtSalutaion: UITextField!{
        didSet{
            txtSalutaion.placeHolder(text:"title".localized, textfieldname: txtSalutaion)
            saluttionPicker.delegate = self
            self.txtSalutaion.inputView = self.saluttionPicker
           // txtSalutaion.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            billingTxtSalutation.text = arrSalutation[0]
            txtSalutaion.text = arrSalutation[0]
            
        }
    }
    
    @IBOutlet weak var txtFirstName: RMTextField!{
        didSet{
            txtFirstName.placeHolder(text: "fName".localized, textfieldname: txtFirstName)
            txtFirstName.addTarget(self, action: #selector(didChangeFirstName), for: .editingChanged)
            txtFirstName.dtLayer.isHidden = true
            txtFirstName?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }
    }
    
    
    @IBOutlet weak var errorBillingCity: UILabel!
    @IBOutlet weak var lineBillingCity: UIView!
    @IBOutlet weak var txtBillingCity: RMTextField!{
        didSet{
            txtBillingCity.placeHolder(text: "City*".localized, textfieldname: txtBillingCity)
            txtBillingCity.delegate = self
            self.txtBillingCity.inputView = self.cityPicker
            txtBillingCity.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtBillingCity.addTarget(self, action: #selector(didChangeCityBilling(textField:)), for: .editingDidBegin)
            txtBillingCity.dtLayer.isHidden = true
            
        }
    }
    @IBOutlet weak var icBillingCity: UIImageView!
    @IBOutlet weak var lblBillingCountry: UILabel!
    @IBOutlet weak var lblBillingSelectCountry: UILabel!{
        didSet{
            lblBillingSelectCountry.text = "Select Country".localized
        }
    }
    @IBOutlet weak var lineBillingTelephone: UIView!
    @IBOutlet weak var errorBillingTelephone: UILabel!
    @IBOutlet weak var icBillingTelephone: UIImageView!
    @IBOutlet weak var txtBillingPhoneNumber: RMTextField!{
        didSet{
            txtBillingPhoneNumber.placeHolder(text: "fNumber".localized, textfieldname: txtBillingPhoneNumber)
            txtBillingPhoneNumber.addTarget(self, action: #selector(didChangePhoneNumberBilling(textField:)), for: .editingChanged)
            txtBillingPhoneNumber.dtLayer.isHidden = true
            txtBillingPhoneNumber?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtBillingPhoneNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var errorBillingFnm: UILabel!
    @IBOutlet weak var icBillingFnm: UIImageView!
    @IBOutlet weak var lineBillingFnm: UIView!
    @IBOutlet weak var txtBillingFirstNm: RMTextField!{
        didSet{
            txtBillingFirstNm.placeHolder(text: "fName".localized, textfieldname: txtBillingFirstNm)
            txtBillingFirstNm.addTarget(self, action: #selector(didChangeFirstNameBilling(textField:)), for: .editingChanged)
            txtBillingFirstNm.dtLayer.isHidden = true
            txtBillingFirstNm?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }
    }
    
    @IBOutlet weak var btnother: UIButton!{
        didSet{
            btnother.setTitle("Other".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnHome: UIButton!{
        didSet{
            btnHome.setTitle("Home".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var btnWork:UIButton!{
        didSet{
            btnWork.setTitle("Work".localized, for: .normal)
        }
    }
    @IBOutlet weak var stackViewDesfult: UIStackView!
    @IBOutlet weak var viewCompanyName: UIView!
    
    @IBOutlet weak var txtBillingAddress: UITextView!{
        didSet{
            txtBillingAddress.text = "Shipping Notes"
            txtBillingAddress.textColor = UIColor.init(hexString: "474747")
            txtBillingAddress.delegate = self
        }
    }
    @IBOutlet weak var txtBillingAdd2: RMTextField!{
        didSet{
            txtBillingAdd2.placeHolder(text: "addLineSecond".localized, textfieldname: txtBillingAdd2)
            txtBillingAdd2.addTarget(self, action: #selector(didChangeAddLine2Billing(textField:)), for: .editingChanged)
            txtBillingAdd2.dtLayer.isHidden = true
            txtBillingAdd2?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtBillingAdd2.delegate = self
            
        }
    }
    @IBOutlet weak var errorBillingAdd2: UILabel!
    @IBOutlet weak var lineBillingAdd2: UIView!
    @IBOutlet weak var icBillingAdd2: UIImageView!
    @IBOutlet weak var lblAddNewAdd: UILabel!{
        didSet{
            lblAddNewAdd.text = "addNewAdd".localized
        }
    }
    @IBOutlet weak var icBillingAddress: UIImageView!
    @IBOutlet weak var lineBillingAddress: UILabel!
    @IBOutlet weak var errorBillingAdd1: UILabel!
    @IBOutlet weak var lineBillingAdd1: UIView!
    @IBOutlet weak var icBillingAdd1: UIImageView!
    @IBOutlet weak var txtBillingAdd1: RMTextField!{
        didSet{
            txtBillingAdd1.placeHolder(text: "addLineFirst".localized, textfieldname: txtBillingAdd1)
            txtBillingAdd1.addTarget(self, action: #selector(didChangeAddLine1Billing(textField:)), for: .editingChanged)
            txtBillingAdd1.dtLayer.isHidden = true
            txtBillingAdd1?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtBillingAdd1.delegate = self
        }
    }
    @IBOutlet weak var errorBillingAddress: UILabel!
    
    @IBOutlet weak var lblUseDefault: UILabel!{
        didSet{
            lblUseDefault.text = "use_default".localized
        }
    }
    @IBOutlet weak var lblBillingCount: UILabel!
    var cityList = [String]()
    var priceCategories = [String]()
    var checkoutOrderSummary = [Double]()
    var tblDataPriceCategories = [String]()
    var tblDataCheckoutOrderSummary = [Double]()
    var addCustomer: AddressInformation?
    var dictStreet = [String:Any]()
    var arrStreet = [String]()
    var isDefaultAddress: Bool = false
    var isfromBillingCity = false
    var isFromEditAdd = false
    var errorIndex = 999
    var errorMessage = ""
    var params:[String:Any] = [:]
    let dropDown = DropDown()
    var dictNewAddress = [String:Any]()
    var addressNameDetail = ["Salutation","First Name","Last Name","Phone Number"]
    let addressDetail = ["City","Address line 1","Address line 2","Flat/House no.","Shipping notes"]
    var coupon = ""
    var isFromMyAccount = false
    var voucher = ""
    var countryCode = [Common.contryWithCode]()
    var countryCodeBilling = [Common.contryWithCode]()
    var orderInformation = [String:Any]()
    var addressArray : [Addresses] = [Addresses]()
    var billingAddress : Addresses?
    let viewModel = AddNewAddressViewModel()
     let addressviewModel = CheckoutViewModel()
    var OrderSummary = [Double]()
    var editingRowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countryCode =  Common.sharedInstance.countryCodeList()
        countryCodeBilling =  Common.sharedInstance.countryCodeList()
        
        if isFromEditAdd {
            print("selectedAddress = \(self.selectedAddress)")
            print("country code list =\(countryCode)")
            
            var phoneNumberValue = self.selectedAddress?.telephone ?? ""
            
            if phoneNumberValue.contains("+") {
                phoneNumberValue = phoneNumberValue.components(separatedBy: "+")[1]
            }
            
            let countryCodeArr = countryCode.compactMap { $0.countryCode }
            print("countryCodeArr = \(countryCodeArr)")
            
            let fourDigitCode = Array(Set(countryCodeArr.filter{$0.count == 4}))
            let threeDigitCode = Array(Set(countryCodeArr.filter{$0.count == 3}))
            let twoDigitCode = Array(Set(countryCodeArr.filter{$0.count == 2}))
            let oneDigitCode = Array(Set(countryCodeArr.filter{$0.count == 1}))
            
            print("fourDigitCode =\(fourDigitCode)")
            print("threeDigitCode =\(threeDigitCode)")
            print("twoDigitCode =\(twoDigitCode)")
            print("oneDigitCode =\(oneDigitCode)")
            
            let fourDigitFilter = fourDigitCode.filter{(phoneNumberValue.hasPrefix($0))}
            let threeDigitFilter = threeDigitCode.filter{(phoneNumberValue.hasPrefix($0))}
            let twoDigitFilter = twoDigitCode.filter{(phoneNumberValue.hasPrefix($0))}
            let oneDigitFilter = oneDigitCode.filter{(phoneNumberValue.hasPrefix($0))}
            
            print("fourDigitFilter = \(fourDigitFilter)")
            print("threeDigitFilter = \(threeDigitFilter)")
            print("twoDigitFilter = \(twoDigitFilter)")
            print("oneDigitFilter = \(oneDigitFilter)")
            
            var isdCode = ""
            var mobileNo = ""
            
            if fourDigitFilter.count > 0 {
                isdCode = fourDigitFilter[0]
                mobileNo = phoneNumberValue.components(separatedBy: isdCode)[1]
            }
            else if threeDigitFilter.count > 0{
                isdCode = threeDigitFilter[0]
                mobileNo = phoneNumberValue.components(separatedBy: isdCode)[1]
            }
            else if twoDigitFilter.count > 0{
                isdCode = twoDigitFilter[0]
                mobileNo = phoneNumberValue.components(separatedBy: isdCode)[1]
            }
            else if oneDigitFilter.count > 0{
                isdCode = oneDigitFilter[0]
                mobileNo = phoneNumberValue.components(separatedBy: isdCode)[1]
            }
            else{
                isdCode = "0"
                mobileNo = phoneNumberValue
            }
            txtCountryCode.text = isdCode
            txtContryCodeBilling.text = isdCode
            txtBillingPhoneNumber.text = mobileNo
            txtPhoneNumber.text = mobileNo
        }
        else{
            //var selectedCountryFlag = UserDefaults.standard.value(forKey: "flagurl")
            var defaultCountryCode = ""
            let countryCode = (UserDefaults.standard.string( forKey: "storecode")?.uppercased()  ?? "UAE")
            if(countryCode.uppercased() == "AE"){
                defaultCountryCode = "971"
            }
            else if(countryCode.uppercased() == "SA"){
                defaultCountryCode = "966"
            }
            else if(countryCode.uppercased() == "KW"){
                defaultCountryCode = "965"
            }
            else if(countryCode.uppercased() == "OM"){
                defaultCountryCode = "968"
            }
            else if(countryCode.uppercased() == "BH"){
                defaultCountryCode = "973"
            }
            else{
                defaultCountryCode = "971"
            }
            
            txtCountryCode.text = defaultCountryCode
            txtContryCodeBilling.text = defaultCountryCode
            txtBillingPhoneNumber.text = ""
            txtPhoneNumber.text =  ""
        }
        
        CountryCodePicker.reloadAllComponents()
        CountryCodePickerBilling.reloadAllComponents()
        CountryCodePicker.selectedRow(inComponent: 0)
        CountryCodePickerBilling.selectedRow(inComponent: 0)
        
        callCity()
        let defaults = UserDefaults.standard
        lblCountry.text = "\(defaults.value(forKey: "countryName") ?? "")"
        lblBillingCountry.text = "\(defaults.value(forKey: "countryName") ?? "")"
        
        icFlag.downloadSdImage(url: "\(UserDefaults.standard.value(forKey: "flagurl") ?? "")" )
        icBillingFlag.downloadSdImage(url: "\(UserDefaults.standard.value(forKey: "flagurl") ?? "")" )
        if isFromClickCollect{
            lblTitle.text = "CLICK AND COLLECT".localized
        }else{
            lblTitle.text = "home_delivery".localized.uppercased()
        }
        if selectedAddress?.customAttributes  != nil{
            var strType = ""
            for i in 0..<(selectedAddress?.customAttributes?.count)!{
                if selectedAddress?.customAttributes?[i].attributeCode == "lvl_address_type" {
                    strType = selectedAddress?.customAttributes?[i].value ?? ""
                }
                
            }
            if strType == "work"{
                onClickAddress(btnWork)
                onClickBillingAddress(btnBillingWork)
            }else if strType == "home" {
                onClickAddress(btnHome)
                onClickBillingAddress(btnBillingHome)
            }else{
                onClickAddress(btnother)
                onClickBillingAddress(btnBillingOther)
            }
        }else{
            onClickAddress(btnHome)
            onClickBillingAddress(btnBillingHome)
        }
        if ((isFromEditAdd && selectedAddress?.defaultShipping != true  && selectedAddress?.defaultBilling == true) || isFromClickCollect) {
            
            stackViewShipping.isHidden = true
            stackViewDesfult.isHidden = false
            btnSaveAddress.setTitle("save_add".localized, for: .normal)
            billingTxtSalutation.text = selectedAddress?.prefix
            txtBillingFirstNm.text = selectedAddress?.firstname
            txtBillingLastName.text = selectedAddress?.lastname
//            let strNumber:String = selectedAddress?.telephone ?? ""
//            txtBillingPhoneNumber.text = strNumber
            txtBillingCity.text = selectedAddress?.city
            txtBillingAdd1.text = selectedAddress?.street[0]
            txtBillingCompany.text = selectedAddress?.company
            if selectedAddress?.street.count ?? 0 > 1{
                txtBillingAdd2.text = selectedAddress?.street[1]
            }
        } else if isFromEditAdd && !isFromClickCollect && selectedAddress?.defaultBilling != true || (selectedAddress?.defaultShipping == true && selectedAddress?.defaultBilling == true){
            
            btnSaveAddress.setTitle("save_add".localized, for: .normal)
            txtSalutaion.text = selectedAddress?.prefix
            txtFirstName.text = selectedAddress?.firstname
            txtLastName.text = selectedAddress?.lastname
//            let strNumber:String = selectedAddress?.telephone ?? ""
//            txtPhoneNumber.text = strNumber
            txtCity.text = selectedAddress?.city
            txtAddressLine1.text = selectedAddress?.street[0]
            txtCompanyName.text = selectedAddress?.company
            if selectedAddress?.street.count ?? 0 > 1{
                txtAddressLine2.text = selectedAddress?.street[1]
                
            }
            
            
        }
            
        else{
            btnSaveAddress.setTitle("ADD ADDRESS".localized, for: .normal)
            onClickAddress(btnHome)
        }
        btnSaveAddress.addTextSpacing(spacing: 1.5, color: "ffffff")
        print("sel add = \(self.selectedAddress)")
        //        if self.isFromMyAccount {
        //            if self.isFromEditAdd {
        //                let CodeandNo = self.userInfoDic["mobileNo"]?.split(separator: "-")
        //                if CodeandNo?.count ?? 0 > 1 {
        //                    txtCountryCode.text = "+\(CodeandNo![0])"
        //                    //txtPhoneNumber.text = "\(CodeandNo![1])"
        //                }else{
        //                    txtCountryCode.text = "+ISD"
        //                    //txtPhoneNumber.text = "\(CodeandNo![0])"
        //                }
        //            }
        //        }
        
        //onClickAddress(btnHome)
        viewModel.isValidationError = {(msg) in
            self.validationMsg(msg: msg)
            
        }
        if isFromClickCollect {
            stackViewShipping.isHidden = true
            stackViewDesfult.isHidden = false
        }else{
            stackViewShipping.isHidden = false
            stackViewDesfult.isHidden = true
        }
        
        
    }
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        
            //stackViewDesfult.isHidden = true
        //Commented by #Nitikesh
        //        setAddressDict()
        //        if addressArray.count != 0{
        //            //print(addressArray)
        //            viewModel.addressArray = addressArray
        //
        //        }
        
    }
    
    @objc func didChangeFirstName(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineFirstNm?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["12"] = textField.text!
        self.ischeckFirstName()
        
    }
    
    @objc func didChangeCityBilling(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        isfromBillingCity = true
        lineBillingCity?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["12"] = textField.text!
        // self.ischeckCityBilling()
        
    }
    
    @objc func didChangeCity(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        isfromBillingCity = false
        lineCity?.backgroundColor = UIColor.init(hexString: "474747")
        //errorIndex = 999
        // params["12"] = textField.text!
        //    self.ischeckCity()
        
    }
    
    @objc func didChangeLastName(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineLnm?.backgroundColor = UIColor.init(hexString: "474747")
        // errorIndex = 999
        // params["13"] = textField.text!
        self.ischeckLastName()
        
    }
    
    @objc func didChangePhoneNumber(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        linePhone?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        //  params["14"] = textField.text!
        self.ischeckMobile()
        
    }
    
    @objc func didChangeAddLine1(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineAdd1?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["31"] = textField.text!
        self.ischeckAdd1()
        
    }
    
    @objc func didChangeAddLine2(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineAdd2?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["33"] = textField.text!
        // self.ischeckAdd2()
        
        
    }
    
    @objc func didChangeCompanyName(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineCompanyName?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["10"] = textField.text!
        self.ischecCompanyName()
        
    }
    
    @objc func didChangeBillingCompanyName(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        linebillingCompany?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["10"] = textField.text!
        self.ischecBillingCompanyName()
        
    }
    
    
    @objc func didChangeFirstNameBilling(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineBillingFnm?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["12"] = textField.text!
        self.ischeckFirstNameBilling()
        
    }
    
    @objc func didChangeLastNameBilling(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineLnm?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["13"] = textField.text!
        self.ischeckLastNameBilling()
        
    }
    
    @objc func didChangePhoneNumberBilling(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        linePhone?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        //  params["14"] = textField.text!
        self.ischeckMobileBilling()
        
    }
    
    @objc func didChangeAddLine1Billing(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineAdd1?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["31"] = textField.text!
        self.ischeckAdd1Billing()
        
    }
    
    @objc func didChangeAddLine2Billing(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        
        lineAdd2?.backgroundColor = UIColor.init(hexString: "474747")
        errorIndex = 999
        // params["33"] = textField.text!
        // self.ischeckAdd2Billing()
        
    }
    
    
    
    
    @IBAction func onClickCity(_ sender: Any) {
    }
    @IBAction func onClickBillingSalutation(_ sender: Any) {
    }
    
    @IBAction func onClickBillingCity(_ sender: Any) {
    }
    
    
    @IBAction func onClickSaveAddress(_ sender: Any) {
        if stackViewShipping.isHidden == true && stackViewDesfult.isHidden == false{
            if isAllValidBillingAddress() {
                addAddress({ (response) in
                    print(response)
                    DispatchQueue.main.async {
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                }) { (errorResponse) in
                    if let code:Int = errorResponse["code"] as? Int{
                        print(code)
                        //validationMsg(msg: code)
                    }
                }
            }
        }else if stackViewShipping.isHidden == false && stackViewDesfult.isHidden == false{
            if isAllValidBillingAddress() && isAllValid() {
                addAddress({ (response) in
                    print(response)
                    DispatchQueue.main.async {
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                }) { (errorResponse) in
                    if let code:Int = errorResponse["code"] as? Int{
                        print(code)
                        //validationMsg(msg: code)
                    }
                }
            }
        }else{
            if isAllValid(){
                addAddress({ (response) in
                    print(response)
                    DispatchQueue.main.async {
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                }) { (errorResponse) in
                    if let code:Int = errorResponse["code"] as? Int{
                        print(code)
                        //validationMsg(msg: code)
                    }
                }
            }
        }
        
    }
    func shippingAddAddressRequestParam(strCountry: String, from: String) -> [[String:Any]]{
        var arrayAddress = [[String:Any]]()
        var arrayStreet = [txtAddressLine1.text ?? "",txtAddressLine2.text ?? ""]
        
        
        for i in 0..<addressArray.count{
            
            let regionParam = ["region":addressArray[i].city ?? ""]
            var dict = [String:Any]()
            dict = ["prefix":addressArray[i].prefix ?? "",
                    "firstname":addressArray[i].firstname ?? "",
                    "lastname":addressArray[i].lastname ?? "",
                    "country_id":addressArray[i].countryId ?? "",
                    "company":addressArray[i].company ?? "",
                    "street":addressArray[i].street,
                    "city":addressArray[i].city ?? "",
                    "telephone":addressArray[i].telephone ?? "",
                    "default_shipping":false,
                    "region":regionParam,
                    "postcode":"000000",
                    "default_billing":false]
            
            var array = [[String:Any]]()
            if addressArray[i].customAttributes != nil{
                for j in 0..<addressArray[i].customAttributes!.count{
                    var dict = [String:Any]()
                    dict = ["attribute_code":addressArray[i].customAttributes?[j].attributeCode ?? "",
                            "value":addressArray[i].customAttributes?[j].value ?? ""]
                    array.append(dict)
                }
            }
            dict["custom_attributes"] = array
            dict["id"] = addressArray[i].id?.val ?? 0
            
            if(selectedAddress?.id?.val != addressArray[i].id?.val){
                arrayAddress.append(dict)
            }
        }
        let regionParam = ["region":txtCity.text ?? ""]
        let phoneNumberValue = (txtCountryCode.text ?? "") + (txtPhoneNumber.text ?? "")
        print("phoneNumberValue =\(phoneNumberValue)")
        
        dictNewAddress = ["prefix":txtSalutaion.text ?? ""
            ,"firstname":txtFirstName.text ?? "",
             "lastname":txtLastName.text ?? "",
             "country_id":strCountry.uppercased(),
             "street":arrayStreet,
             "city":txtCity.text ?? "",
             "telephone":phoneNumberValue,
             "region":regionParam,
             "postcode":"000000"] as [String:Any]
        
        if isWork{
            dictNewAddress["company"] = txtCompanyName.text
        }
        if stackViewDesfult.isHidden == false{
            dictNewAddress["default_shipping"] = true
        }
        else{
            dictNewAddress["default_shipping"] = true
            dictNewAddress["default_billing"] = true
        }
        if(from == "edit"){
            dictNewAddress["id"] = selectedAddress?.id?.val
        }
        var arrayCustomAttrib = [String:Any]()
        arrayCustomAttrib["attribute_code"] = "lvl_address_type"
        if btnWork.backgroundColor?.isEqual(UIColor.black) ?? false{
            arrayCustomAttrib["value"] = "work"
        }else if btnHome.backgroundColor?.isEqual(UIColor.black) ?? false{
            arrayCustomAttrib["value"] = "home"
        }else{
            arrayCustomAttrib["value"] = "other"
        }
        var customAttributes = [[String:Any]]()
        customAttributes.append(arrayCustomAttrib)
        
        dictNewAddress["custom_attributes"] = customAttributes
        arrayAddress.append(dictNewAddress)
        
        if stackViewDesfult.isHidden == false{
            var billingAddress = [String:Any]()
            let phoneNumberBillingValue = (txtContryCodeBilling.text ?? "") + (txtBillingPhoneNumber.text ?? "")
            print("phoneNumberBillingValue =\(phoneNumberBillingValue)")
            arrayStreet = [txtBillingAdd1.text ?? "",txtBillingAdd2.text ?? ""]
            billingAddress = ["prefix":billingTxtSalutation.text ?? ""
                ,"firstname":txtBillingFirstNm.text ?? "",
                 "lastname":txtBillingLastName.text ?? "",
                 "country_id":strCountry.uppercased(),
                 "street":arrayStreet,
                 "city":txtBillingCity.text ?? "",
                 "telephone":phoneNumberBillingValue,
                 //"default_shipping":false,
                "region":regionParam,
                "postcode":"000000"] as [String:Any]
            
            
            if isWork{
                billingAddress["company"] = txtBillingCompany.text
            }
            billingAddress["default_billing"] = true
            var arrayCustomAttrib = [String:Any]()
            arrayCustomAttrib["attribute_code"] = "lvl_address_type"
            if btnBillingWork.backgroundColor?.isEqual(UIColor.black) ?? false{
                arrayCustomAttrib["value"] = "work"
            }else if btnBillingHome.backgroundColor?.isEqual(UIColor.black) ?? false{
                arrayCustomAttrib["value"] = "home"
            }else{
                arrayCustomAttrib["value"] = "other"
            }
            var customAttributes = [[String:Any]]()
            customAttributes.append(arrayCustomAttrib)
            
            arrayCustomAttrib["attribute_code"] = "lvl_shipping_notes"
            arrayCustomAttrib["value"] = txtBillingAddress.text
            customAttributes.append(arrayCustomAttrib)
            
            billingAddress["custom_attributes"] = customAttributes
            arrayAddress.append(billingAddress)
        }
        return arrayAddress
    }
    func billingAddAddressRequestParam(strCountry: String, from: String) -> [[String:Any]]{
        var arrayAddress = [[String:Any]]()
        let arrayStreet = [txtBillingAdd1.text ?? "",txtBillingAdd2.text ?? ""]
        var shippingAddressCount = 0
        for i in 0..<addressArray.count{
            var dict = [String:Any]()
            let regionParam = ["region":addressArray[i].city ?? ""]
            dict = ["prefix":addressArray[i].prefix ?? "",
                    "firstname":addressArray[i].firstname ?? "",
                    "lastname":addressArray[i].lastname ?? "",
                    "country_id":addressArray[i].countryId ?? "",
                    "company":addressArray[i].company ?? "",
                    "street":addressArray[i].street,
                    "city":addressArray[i].city ?? "",
                    "telephone":addressArray[i].telephone ?? "",
                    "default_shipping":false,
                    "region":regionParam,
                    "postcode":"000000",
                    "default_billing": false]
            if(addressArray[i].defaultShipping == true){
                shippingAddressCount += 1
            }
            var array = [[String:Any]]()
            if addressArray[i].customAttributes != nil{
                for j in 0..<addressArray[i].customAttributes!.count{
                    var dict = [String:Any]()
                    dict = ["attribute_code":addressArray[i].customAttributes?[j].attributeCode ?? "",
                            "value":addressArray[i].customAttributes?[j].value ?? ""]
                    array.append(dict)
                }
            }
            dict["custom_attributes"] = array
            dict["id"] = addressArray[i].id?.val ?? 0
            if(selectedAddress?.id?.val != addressArray[i].id?.val){
                arrayAddress.append(dict)
            }
        }
        /*
         For first time Billing address to Shipping Address Conversion
         **/
        var defaultShipping = false
        if(shippingAddressCount == 0){
            defaultShipping = true
        }
        let phoneNumberBillingValue = (txtContryCodeBilling.text ?? "") + (txtBillingPhoneNumber.text ?? "")
        print("phoneNumberBillingValue =\(phoneNumberBillingValue)")
        let regionParam = ["region":txtBillingCity.text ?? ""]
        dictNewAddress = ["prefix":billingTxtSalutation.text ?? ""
            ,"firstname":txtBillingFirstNm.text ?? "",
             "lastname":txtBillingLastName.text ?? "",
             "country_id":strCountry.uppercased(),
             "street":arrayStreet,
             "city":txtBillingCity.text ?? "",
             "telephone":phoneNumberBillingValue,
             "default_shipping":defaultShipping,
             "region":regionParam,
             "postcode":"000000",
             "default_billing":true] as [String:Any]
        
        var arrayCustomAttrib = [String:Any]()
        arrayCustomAttrib["attribute_code"] = "lvl_address_type"
        if btnBillingWork.backgroundColor == UIColor.black{
            arrayCustomAttrib["value"] = "work"
        }else if btnBillingHome.backgroundColor == UIColor.black{
            arrayCustomAttrib["value"] = "home"
        }else{
            arrayCustomAttrib["value"] = "other"
        }
        var customAttributes = [[String:Any]]()
        customAttributes.append(arrayCustomAttrib)
        
        arrayCustomAttrib["attribute_code"] = "lvl_shipping_notes"
        arrayCustomAttrib["value"] = txtBillingAddress.text
        customAttributes.append(arrayCustomAttrib)
        
        dictNewAddress["custom_attributes"] = customAttributes
        if(from == "edit"){
            dictNewAddress["id"] = selectedAddress?.id?.val
        }
        if isBillingWork{
            dictNewAddress["company"] = txtBillingCompany.text
        }
        
        arrayAddress.append(dictNewAddress)
        return arrayAddress
    }
    func addAddress(_ success: @escaping (Any)-> () , failure:@escaping([String:Any])->()){
        params = [:]
        
        let userFirstName = UserDefaults.standard.value(forKey: "firstname")
        let userLastName = UserDefaults.standard.value(forKey: "lastname")
        let prefix = UserDefaults.standard.value(forKey: "prefix")
        params["prefix"] = prefix
        params["firstname"] = userFirstName
        params["lastname"] = userLastName
        
//        if isFromClickCollect{
//            params["prefix"] = billingTxtSalutation.text
//            params["firstname"] = txtBillingFirstNm.text
//            params["lastname"] = txtBillingLastName.text
//        }else{
//
//        }
        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else{
            return
        }
        params["email"] = email
        params["store_id"] = getStoreId()
        params["website_id"] = getWebsiteId()
        var strCountry:String = getM2StoreCode()
        let array = strCountry.components(separatedBy: "_")
        strCountry = array[0]
        var arrayStreet = [txtAddressLine1.text ?? "",txtAddressLine2.text ?? ""]
        
        var arrayAddress = [[String:Any]]()
        
        if !isFromEditAdd && isFromClickCollect{
            arrayAddress = billingAddAddressRequestParam(strCountry: strCountry, from: "add")
        }else if !isFromEditAdd && !isFromClickCollect{
            arrayAddress = shippingAddAddressRequestParam(strCountry: strCountry, from: "add")
        }else{
            if stackViewShipping.isHidden == false{
                arrayAddress =  shippingAddAddressRequestParam(strCountry: strCountry, from: "edit")
            }
            else if stackViewDesfult.isHidden == false{
                arrayAddress = billingAddAddressRequestParam(strCountry: strCountry, from: "edit")
            }
        }
        
        params["addresses"] = arrayAddress
        
        let finalParam = ["customer":params]
        ApiManager.addAddress(params: finalParam, success: { (response) in
            print(response)
            DispatchQueue.main.async {
                do{
                    
                    let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: response )
                    success(address)
                    if self.isFromClickCollect || self.selectedAddress?.defaultBilling == true{
                        /* let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                         let changeVC: ProceedToPaymentViewController!
                         changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
                         changeVC.isClickAndcollect = true
                         changeVC.coupon = self.coupon
                         changeVC.voucher = self.voucher
                         changeVC.priceCategories = self.priceCategories
                         changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                         
                         changeVC.orderInformation = self.orderInformation
                         changeVC.addressArray = self.addressArray
                         changeVC.addressDict = self.addressArray.last
                         self.navigationController?.pushViewController(changeVC, animated: true)*/
                        if self.isFromMyAccount{
                            self.navigationController?.popViewController(animated: true)
                            /*   let storyboard = UIStoryboard(name: "PersonalDetailStoryBord", bundle: Bundle.main)
                             let changeVC: PersonalDetailViewController!
                             
                             changeVC = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as? PersonalDetailViewController
                             
                             self.navigationController?.pushViewController(changeVC, animated: true)*/
                        }else{
                            
                            self.addressviewModel.getAddrssInformation(success: { (response) in
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
                                       let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                                                                  let changeVC: ProceedToPaymentViewController!
                                                                  changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
                                                                  changeVC.priceCategories = self.priceCategories
                                                                  changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                                        changeVC.tblDataPriceCategories = self.tblDataPriceCategories
                                        changeVC.tblDataCheckoutOrderSummary = self.tblDataCheckoutOrderSummary
                                        changeVC.addressArray = self.addressArray
                                        changeVC.addressDict = self.addressArray.first
                                          changeVC.isClickAndcollect = true
                                        
                                                                  self.navigationController?.pushViewController(changeVC, animated: true)
                                    }
                                }) {
                                //Failure
                            }
                            
                           
                        }
                        
                    }else{
                        if self.isFromMyAccount{
                            self.navigationController?.popViewController(animated: true)
                            /*                                        let storyboard = UIStoryboard(name: "PersonalDetailStoryBord", bundle: Bundle.main)
                             let changeVC: PersonalDetailViewController!
                             
                             changeVC = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as? PersonalDetailViewController
                             
                             self.navigationController?.pushViewController(changeVC, animated: true)*/
                        }else{
                            let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
                            let changeVC: ChekOutVC!
                            changeVC = storyboard.instantiateViewController(withIdentifier: "ChekOutVC") as? ChekOutVC
                            changeVC.checkoutCategories = self.priceCategories
                            changeVC.tbleData_CheckoutCategories = self.tblDataPriceCategories
                            changeVC.proceedToHomeDelivery = true
                            changeVC.checkoutOrderSummary = self.checkoutOrderSummary
                            changeVC.tbleData_CheckoutOrderSummary = self.tblDataCheckoutOrderSummary
                            changeVC.totalCount = totalcartItems.count
                           
                            self.navigationController?.pushViewController(changeVC, animated: true)
                        }
                    }
                }catch{
                    //failure([:])
                }
                
            }
        }) { (error) in
            let successMessage:String = error.description
            let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
            
            //Presenting the Alert in the page.
            self.present(alert, animated: true, completion: nil)
            // failure(error)
        }
    }
    
    
    
    @IBAction func onClickSelectCountry(_ sender: UIButton) {
    }
    @IBAction func onClickUseDefault(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "ic_switch_off") {
            sender.setImage(UIImage(named: "ic_switch_on"), for: .normal)
            stackViewDesfult.isHidden = true
        }else{
            sender.setImage(UIImage(named: "ic_switch_off"), for: .normal)
            stackViewDesfult.isHidden = false
        }
        
    }
    @IBAction func onClickAddress(_ sender: UIButton) {
        DeSelectAll()
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
        if sender.tag == 0 {
            viewCompanyName.isHidden = false
            
            isWork = true
        }else{
            viewCompanyName.isHidden = true
            
            isWork = false
        }
    }
    
    
    @IBAction func onClickBillingAddress(_ sender: UIButton) {
        DeSelectAllBilling()
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
        if sender.tag == 0 {
            
            viewBillingCompany.isHidden = false
            isBillingWork = true
        }else{
            
            viewBillingCompany.isHidden = true
            isBillingWork = false
        }
    }
    
    
    func DeSelectAllBilling(){
        btnBillingWork.backgroundColor = .clear
        btnBillingHome.backgroundColor = .clear
        btnBillingOther.backgroundColor = .clear
        btnBillingWork.setTitleColor(.black, for: .normal)
        btnBillingHome.setTitleColor(.black, for: .normal)
        btnBillingOther.setTitleColor(.black, for: .normal)
    }
    
    func DeSelectAll(){
        btnWork.backgroundColor = .clear
        btnHome.backgroundColor = .clear
        btnother.backgroundColor = .clear
        btnWork.setTitleColor(.black, for: .normal)
        btnHome.setTitleColor(.black, for: .normal)
        btnother.setTitleColor(.black, for: .normal)
    }
    func setAddressDict(){
        params = [:]
        
        
    }
    
    @objc func showDropDown(){
        
        dropDown.show()
        dropDown.dataSource = ["Mr","Mrs"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: txtSalutaion.frame.origin.x, y:(txtSalutaion.frame.origin.y+txtSalutaion.frame.size.height))
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.params["11"] = item
            self.txtSalutaion.text = item
            
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Validation on Click
    
    
    func ischeckShoppingNotes ()
    {
        let u_email = ValidationClass.verifyShoppingNotes(text: txtAddress.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtAddress.text?.count == 0 {
                addressError?.isHidden = true
                lineAddress?.backgroundColor = UIColor.init(hexString: "474747")
                icAddress?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                addressError?.text = errorMessage
                addressError?.isHidden = false
                icAddress?.isHidden = false
                lineAddress?.backgroundColor = UIColor.red
                icAddress?.image = UIImage(named: "icn_error@2x.png")
                // txtAddress?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icAddress?.image = UIImage(named: "Successnew.png")
            addressError?.isHidden = true
            lineAddress?.backgroundColor = UIColor.init(hexString: "474747")
            // txtAddressLine2?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            
        }
    }
    
    func ischecBillingCompanyName()
    {
        let u_email = ValidationClass.verifyCompanyName(text: txtBillingCompany.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingCompany.text?.count == 0 {
                errorBillingCompany?.isHidden = true
                linebillingCompany?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingCompany?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingCompany?.text = errorMessage
                errorBillingCompany?.isHidden = false
                icBillingCompany?.isHidden = false
                linebillingCompany?.backgroundColor = UIColor.red
                icBillingCompany?.image = UIImage(named: "icn_error@2x.png")
                txtBillingCompany?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingCompany?.image = UIImage(named: "Successnew.png")
            errorBillingCompany?.isHidden = true
            errorBillingCompany?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingCompany?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    func ischecCompanyName()
    {
        let u_email = ValidationClass.verifyCompanyName(text: txtCompanyName.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtCompanyName.text?.count == 0 {
                errorCompanyName?.isHidden = true
                lineCompanyName?.backgroundColor = UIColor.init(hexString: "474747")
                icCompnayName?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorCompanyName?.text = errorMessage
                errorCompanyName?.isHidden = false
                icCompnayName?.isHidden = false
                lineCompanyName?.backgroundColor = UIColor.red
                icCompnayName?.image = UIImage(named: "icn_error@2x.png")
                txtCompanyName?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icCompnayName?.image = UIImage(named: "Successnew.png")
            errorCompanyName?.isHidden = true
            errorCompanyName?.backgroundColor = UIColor.init(hexString: "474747")
            txtCompanyName?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func callCity(){
        let dictParam = ["identifier":"mobileapp_static_cities"]
        var dictMatch = [String:Any]()
        dictMatch["match"] = dictParam
        var arrMust = [[String:Any]]()
        arrMust.append(dictMatch)
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        let param = ["query":dictBool]
        print(param)
        
        let storeCode="\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        
        let url = CommonUsed.globalUsed.main + "/" +  storeCode + "/" + CommonUsed.globalUsed.cmsBlockDoc + "/" + CommonUsed.globalUsed.ESSearchTag
        
        ApiManager.apiPost(url: url, params: param as [String : Any]) { (response, error) in
            
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            
            // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                self.cityData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async {
                    if self.cityData != nil{
                        self.setData(data:(self.cityData!))
                    }
                }
                
                
            }else{
                self.alert(title: "server error", message: "server is down please try again letter")
            }
        }
    }
    
    
    func setData(data:NewInData){
        guard (data.hits?.hitsList) != nil else {
            return
        }
        
        
        let contentText1 : String = data.hits?.hitsList[0]._source!.content.replaceString("\r\n", withString: "") ?? ""
        let contentText2 = contentText1.replaceString("\\", withString: "")
        
        cityList = contentText2.components(separatedBy: ",")
        cityPicker.reloadAllComponents()
        if(txtCity.text == ""){ txtCity.text = cityList[0]}
        if( txtBillingCity.text == ""){ txtBillingCity.text = cityList[0]}
        
        
        
    }
    
    //    func ischeckAdd2 ()
    //    {
    //        let u_email = ValidationClass.verifyAdd1(text: txtAddressLine2.text ?? "")
    //        errorIndex = 999
    //        errorMessage = ""
    //
    //        if !u_email.1 {
    //            if txtAddressLine2.text?.count == 0 {
    //                addLine2Error?.isHidden = true
    //                lineAdd2?.backgroundColor = UIColor.init(hexString: "474747")
    //                ic_line2?.isHidden = true
    //
    //            }
    //            else
    //            {
    //                errorIndex = 2
    //                errorMessage = u_email.0
    //                addLine2Error?.text = errorMessage
    //                addLine2Error?.isHidden = false
    //                ic_line2?.isHidden = false
    //                addLine2Error?.backgroundColor = UIColor.red
    //                ic_line2?.image = UIImage(named: "icn_error@2x.png")
    //                txtAddressLine2?.floatPlaceholderActiveColor = UIColor.red
    //            }
    //        }
    //        else
    //        {
    //            ic_line2?.image = UIImage(named: "Successnew.png")
    //            addLine2Error?.isHidden = true
    //            addLine2Error?.backgroundColor = UIColor.init(hexString: "474747")
    //            txtAddressLine2?.floatPlaceholderActiveColor =  colorNames.c4747
    //
    //        }
    //    }
    
    func ischeckAdd1 ()
    {
        let u_email = ValidationClass.verifyAdd1(text: txtAddressLine1.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtAddressLine1.text?.count == 0 {
                addLine1Error?.isHidden = true
                lineAdd1?.backgroundColor = UIColor.init(hexString: "474747")
                icLine1?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                addLine1Error?.text = errorMessage
                addLine1Error?.isHidden = false
                icLine1?.isHidden = false
                addLine1Error?.backgroundColor = UIColor.red
                icLine1?.image = UIImage(named: "icn_error@2x.png")
                txtAddressLine1?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icLine1?.image = UIImage(named: "Successnew.png")
            addLine1Error?.isHidden = true
            addLine1Error?.backgroundColor = UIColor.init(hexString: "474747")
            txtAddressLine1?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckLastName ()
    {
        let u_email = ValidationClass.verifyLastname(text: txtLastName.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtLastName.text?.count == 0 {
                lastNmError?.isHidden = true
                lineLnm?.backgroundColor = UIColor.init(hexString: "474747")
                icLnm?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                lastNmError?.text = errorMessage
                lastNmError?.isHidden = false
                icLnm?.isHidden = false
                lineLnm?.backgroundColor = UIColor.red
                icLnm?.image = UIImage(named: "icn_error@2x.png")
                txtLastName?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icLnm?.image = UIImage(named: "Successnew.png")
            lastNmError?.isHidden = true
            lineLnm?.backgroundColor = UIColor.init(hexString: "474747")
            txtLastName?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckMobile ()
    {
        let mobileTextValue = (txtCountryCode.text ?? "") + (txtPhoneNumber.text ?? "")
       // let u_email = ValidationClass.verifyPhoneNumber(text: txtPhoneNumber.text ?? "")
         let u_email = ValidationClass.verifyPhoneNumber(text: mobileTextValue)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtPhoneNumber.text?.count == 0 {
                phoneError?.isHidden = true
                linePhone?.backgroundColor = UIColor.init(hexString: "474747")
                ic_phone?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                phoneError?.text = errorMessage
                phoneError?.isHidden = false
                ic_phone?.isHidden = false
                linePhone?.backgroundColor = UIColor.red
                ic_phone?.image = UIImage(named: "icn_error@2x.png")
                txtPhoneNumber.floatPlaceholderActiveColor = UIColor.red
                
            }
        }
        else
        {
            ic_phone?.image = UIImage(named: "Successnew.png")
            phoneError?.isHidden = true
            linePhone?.backgroundColor = UIColor.init(hexString: "474747")
            txtPhoneNumber.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    
    func ischeckCity ()
    {
        let u_email = ValidationClass.verifyFirstname(text: txtCity.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtCity.text?.count == 0 {
                cityError?.isHidden = true
                lineCity?.backgroundColor = UIColor.init(hexString: "474747")
                icCity?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                cityError?.text = errorMessage
                cityError?.isHidden = false
                icCity?.isHidden = false
                lineCity?.backgroundColor = UIColor.red
                icCity?.image = UIImage(named: "icn_error@2x.png")
                txtCity?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icCity?.image = UIImage(named: "Successnew.png")
            cityError?.isHidden = true
            lineCity?.backgroundColor = UIColor.init(hexString: "474747")
            txtCity?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    func ischeckCityBilling ()
    {
        let u_email = ValidationClass.verifyFirstname(text: txtBillingCity.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingCity.text?.count == 0 {
                errorBillingCity?.isHidden = true
                lineBillingCity?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingCity?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingCity?.text = errorMessage
                errorBillingCity?.isHidden = false
                icBillingCity?.isHidden = false
                lineBillingCity?.backgroundColor = UIColor.red
                icBillingCity?.image = UIImage(named: "icn_error@2x.png")
                txtBillingCity?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingCity?.image = UIImage(named: "Successnew.png")
            errorBillingCity?.isHidden = true
            lineBillingCity?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingCity?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckFirstName ()
    {
        let u_email = ValidationClass.verifyFirstname(text: txtFirstName.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtFirstName.text?.count == 0 {
                firstNameError?.isHidden = true
                lineFirstNm?.backgroundColor = UIColor.init(hexString: "474747")
                icFnm?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                firstNameError?.text = errorMessage
                firstNameError?.isHidden = false
                icFnm?.isHidden = false
                lineFirstNm?.backgroundColor = UIColor.red
                icFnm?.image = UIImage(named: "icn_error@2x.png")
                txtFirstName?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icFnm?.image = UIImage(named: "Successnew.png")
            firstNameError?.isHidden = true
            lineFirstNm?.backgroundColor = UIColor.init(hexString: "474747")
            txtFirstName?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    
    
    
    func ischeckShoppingNotesBilling ()
    {
        let u_email = ValidationClass.verifyShoppingNotes(text: txtBillingAddress.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingAddress.text?.count == 0 {
                errorBillingAddress?.isHidden = true
                lineBillingAddress?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingAddress?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingAddress?.text = errorMessage
                errorBillingAddress?.isHidden = false
                icBillingAddress?.isHidden = false
                lineBillingAddress?.backgroundColor = UIColor.red
                icBillingAddress?.image = UIImage(named: "icn_error@2x.png")
                // txtAddress?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingAddress?.image = UIImage(named: "Successnew.png")
            errorBillingAddress?.isHidden = true
            lineBillingAddress?.backgroundColor = UIColor.init(hexString: "474747")
            // txtAddressLine2?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            
        }
    }
    
    //    func ischeckAdd2Billing ()
    //    {
    //        let u_email = ValidationClass.verifyAdd1(text: txtBillingAdd2.text ?? "")
    //        errorIndex = 999
    //        errorMessage = ""
    //
    //        if !u_email.1 {
    //            if txtBillingAdd2.text?.count == 0 {
    //                errorBillingAdd2?.isHidden = true
    //                lineBillingAdd2?.backgroundColor = UIColor.init(hexString: "474747")
    //                icBillingAdd2?.isHidden = true
    //
    //            }
    //            else
    //            {
    //                errorIndex = 2
    //                errorMessage = u_email.0
    //                errorBillingAdd2?.text = errorMessage
    //                errorBillingAdd2?.isHidden = false
    //                icBillingAdd2?.isHidden = false
    //                lineBillingAdd2?.backgroundColor = UIColor.red
    //                icBillingAdd2?.image = UIImage(named: "icn_error@2x.png")
    //                txtBillingAdd2?.floatPlaceholderActiveColor = UIColor.red
    //            }
    //        }
    //        else
    //        {
    //            icBillingAdd2?.image = UIImage(named: "Successnew.png")
    //            errorBillingAdd2?.isHidden = true
    //            lineBillingAdd2?.backgroundColor = UIColor.init(hexString: "474747")
    //            txtBillingAdd2?.floatPlaceholderActiveColor =  colorNames.c4747
    //
    //        }
    //    }
    
    func ischeckAdd1Billing ()
    {
        let u_email = ValidationClass.verifyAdd1(text: txtBillingAdd1.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingAdd1.text?.count == 0 {
                errorBillingAdd1?.isHidden = true
                lineBillingAdd1?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingAdd1?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingAdd1?.text = errorMessage
                errorBillingAdd1?.isHidden = false
                icBillingAdd1?.isHidden = false
                lineBillingAdd1?.backgroundColor = UIColor.red
                icBillingAdd1?.image = UIImage(named: "icn_error@2x.png")
                txtBillingAdd1?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingAdd1?.image = UIImage(named: "Successnew.png")
            errorBillingAdd1?.isHidden = true
            errorBillingAdd1?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingAdd1?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckLastNameBilling ()
    {
        let u_email = ValidationClass.verifyLastname(text: txtBillingLastName.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingLastName.text?.count == 0 {
                errorBillingLnm?.isHidden = true
                lineBillingLnm?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingLastNm?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingLnm?.text = errorMessage
                errorBillingLnm?.isHidden = false
                icBillingLastNm?.isHidden = false
                lineBillingLnm?.backgroundColor = UIColor.red
                icBillingLastNm?.image = UIImage(named: "icn_error@2x.png")
                txtBillingLastName?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingLastNm?.image = UIImage(named: "Successnew.png")
            errorBillingLnm?.isHidden = true
            lineBillingLnm?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingLastName?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckMobileBilling ()
    {
        let mobileTextValue = (txtContryCodeBilling.text ?? "") + (txtBillingPhoneNumber.text ?? "")
        //let u_email = ValidationClass.verifyPhoneNumber(text: txtBillingPhoneNumber.text ?? "")
        let u_email = ValidationClass.verifyPhoneNumber(text: mobileTextValue)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingPhoneNumber.text?.count == 0 {
                errorBillingTelephone?.isHidden = true
                lineBillingTelephone?.backgroundColor = UIColor.init(hexString: "474747")
                icBillingTelephone?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingTelephone?.text = errorMessage
                errorBillingTelephone?.isHidden = false
                icBillingTelephone?.isHidden = false
                lineBillingTelephone?.backgroundColor = UIColor.red
                icBillingTelephone?.image = UIImage(named: "icn_error@2x.png")
                txtBillingPhoneNumber.floatPlaceholderActiveColor = UIColor.red
                
            }
        }
        else
        {
            icBillingTelephone?.image = UIImage(named: "Successnew.png")
            errorBillingTelephone?.isHidden = true
            lineBillingTelephone?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingPhoneNumber.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    
    func ischeckFirstNameBilling ()
    {
        let u_email = ValidationClass.verifyFirstname(text: txtBillingFirstNm.text ?? "")
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if txtBillingFirstNm.text?.count == 0 {
                errorBillingFnm?.isHidden = true
                lineBillingFnm?.backgroundColor = UIColor.white
                icBillingFnm?.isHidden = true
                
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                errorBillingFnm?.text = errorMessage
                errorBillingFnm?.isHidden = false
                icBillingFnm?.isHidden = false
                lineBillingFnm?.backgroundColor = UIColor.red
                icBillingFnm?.image = UIImage(named: "icn_error@2x.png")
                txtBillingFirstNm?.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            icBillingFnm?.image = UIImage(named: "Successnew.png")
            errorBillingFnm?.isHidden = true
            lineBillingFnm?.backgroundColor = UIColor.init(hexString: "474747")
            txtBillingFirstNm?.floatPlaceholderActiveColor =  colorNames.c4747
            
        }
    }
    func saveAddress(){
        if isAllValid(){
            if viewModel.validate(params, isWork: isWork){
                viewModel.addAddress({ (response) in
                    print(response)
                    DispatchQueue.main.async {
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                }) { (errorResponse) in
                    if let code:Int = errorResponse["code"] as? Int{
                        print(code)
                        //validationMsg(msg: code)
                    }
                    if let message:String = errorResponse["message"] as? String{
                        print(message)
                        //self.validationMsg(msg: message)
                    }
                }
            }
        }
    }
    
    
    func isAllValidBillingAddress() -> Bool {
        var isValid = false
        
        if isBillingWork{
            
            let company = ValidationClass.verifySalutation(text: txtBillingCompany.text ?? "")
            let salutation = ValidationClass.verifySalutation(text: billingTxtSalutation.text ?? "")
            let firstName = ValidationClass.verifyFirstname(text: txtBillingFirstNm.text ?? "")
            let lastName = ValidationClass.verifyLastname(text: txtBillingLastName.text ?? "")
            let phoneNumber = ValidationClass.verifyPhoneNumber(text: txtBillingPhoneNumber.text ?? "")
            let line1 = ValidationClass.verifyAdd1(text: txtBillingAdd1.text ?? "")
            // let line2 = ValidationClass.verifyAdd2(text: txtBillingAdd2.text ?? "")
            errorIndex = 999
            errorMessage = ""
            
            if !company.1 {
                errorIndex = 0
                errorMessage = firstName.0
                errorBillingCompany?.isHidden = false
                errorBillingCompany?.text = errorMessage
                linebillingCompany?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingCompany?.isHidden = false
                
            }else if !salutation.1 {
                errorIndex = 1
                errorMessage = firstName.0
                errorBillingSalutation?.isHidden = false
                errorBillingSalutation?.text = errorMessage
                lineBillingsalutation?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingSalutation?.isHidden = false
                
            }
            else if !firstName.1 {
                errorIndex = 2
                errorMessage = firstName.0
                errorBillingFnm?.isHidden = false
                errorBillingFnm?.text = errorMessage
                lineBillingFnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingFnm?.isHidden = false
                
            } else if !lastName.1 {
                errorIndex = 3
                errorMessage = firstName.0
                errorBillingLnm?.isHidden = false
                lineBillingLnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                errorBillingLnm?.text = errorMessage
                icBillingLastNm?.isHidden = false
                
            }
            else if !phoneNumber.1 {
                errorIndex = 4
                errorMessage = phoneNumber.0
                errorBillingTelephone?.isHidden = false
                errorBillingTelephone?.text = errorMessage
                lineBillingTelephone?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingTelephone?.isHidden = false
                
            }
            else if !line1.1 {
                errorIndex = 5
                errorMessage = line1.0
                errorBillingAdd1?.isHidden = false
                errorBillingAdd1?.text = errorMessage
                lineBillingAdd1?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingAdd1?.isHidden = false
                
            }
                //                   else if !line2.1 {
                //                       errorIndex = 6
                //                       errorMessage = line2.0
                //                       errorBillingAdd2?.isHidden = false
                //                       errorBillingAdd2?.text = errorMessage
                //                       lineBillingAdd2?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                //                       icBillingAdd2?.isHidden = false
                //
                //                   }
            else {
                isValid = true
            }
            
            return isValid
            
        }else{
            let salutation = ValidationClass.verifySalutation(text: billingTxtSalutation.text ?? "")
            let firstName = ValidationClass.verifyFirstname(text: txtBillingFirstNm.text ?? "")
            let lastName = ValidationClass.verifyLastname(text: txtBillingLastName.text ?? "")
            let phoneNumber = ValidationClass.verifyPhoneNumber(text: txtBillingPhoneNumber.text ?? "")
            let line1 = ValidationClass.verifyAdd1(text: txtBillingAdd1.text ?? "")
            let line2 = ValidationClass.verifyAdd2(text: txtBillingAdd2.text ?? "")
            errorIndex = 999
            errorMessage = ""
            
            if !salutation.1 {
                errorIndex = 0
                errorMessage = firstName.0
                errorBillingSalutation?.isHidden = false
                errorBillingSalutation?.text = errorMessage
                lineBillingsalutation?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingSalutation?.isHidden = false
                
            }
            else if !firstName.1 {
                errorIndex = 1
                errorMessage = firstName.0
                errorBillingFnm?.isHidden = false
                errorBillingFnm?.text = errorMessage
                lineBillingFnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingFnm?.isHidden = false
                
            } else if !lastName.1 {
                errorIndex = 2
                errorMessage = firstName.0
                errorBillingLnm?.isHidden = false
                lineBillingLnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                errorBillingLnm?.text = errorMessage
                icBillingLastNm?.isHidden = false
                
            }
            else if !phoneNumber.1 {
                errorIndex = 3
                errorMessage = phoneNumber.0
                errorBillingTelephone?.isHidden = false
                errorBillingTelephone?.text = errorMessage
                lineBillingTelephone?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingTelephone?.isHidden = false
                
            }
            else if !line1.1 {
                errorIndex = 4
                errorMessage = line1.0
                errorBillingAdd1?.isHidden = false
                errorBillingAdd1?.text = errorMessage
                lineBillingAdd1?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icBillingAdd1?.isHidden = false
                
            }
                //        else if !line2.1 {
                //            errorIndex = 5
                //            errorMessage = line2.0
                //            errorBillingAdd2?.isHidden = false
                //            errorBillingAdd2?.text = errorMessage
                //            lineBillingAdd2?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                //            icBillingAdd2?.isHidden = false
                //
                //        }
            else {
                isValid = true
            }
            
            return isValid
        }
        
    }
    
    
    func isAllValid() -> Bool {
        var isValid = false
        if isWork{
            let companyName = ValidationClass.verifyCompanyName(text: txtCompanyName.text ?? "")
            let salutation = ValidationClass.verifySalutation(text: txtFirstName.text ?? "")
            let firstName = ValidationClass.verifyFirstname(text: txtFirstName.text ?? "")
            let lastName = ValidationClass.verifyLastname(text: txtLastName.text ?? "")
            let phoneNumber = ValidationClass.verifyPhoneNumber(text: txtPhoneNumber.text ?? "")
            let city = ValidationClass.verifyCity(text: txtCity.text ?? "")
            let line1 = ValidationClass.verifyAdd1(text: txtAddressLine1.text ?? "")
            // let line2 = ValidationClass.verifyAdd2(text: txtAddressLine2.text ?? "")
            errorIndex = 999
            errorMessage = ""
            
            if !companyName.1 {
                errorIndex = 0
                errorMessage = companyName.0
                errorCompanyName?.isHidden = false
                errorCompanyName?.text = errorMessage
                lineCompanyName?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icCompnayName?.isHidden = false
                
            }else if !salutation.1 {
                errorIndex = 1
                errorMessage = firstName.0
                salutationError?.isHidden = false
                salutationError?.text = errorMessage
                lineSalutation?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icSalutation?.isHidden = false
                
            }
            else if !firstName.1 {
                errorIndex = 2
                errorMessage = firstName.0
                firstNameError?.isHidden = false
                firstNameError?.text = errorMessage
                lineFirstNm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icFnm?.isHidden = false
                
            } else if !lastName.1 {
                errorIndex = 3
                errorMessage = firstName.0
                lastNmError?.isHidden = false
                lineLnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                lastNmError?.text = errorMessage
                icLnm?.isHidden = false
                
            }
            else if !phoneNumber.1 {
                errorIndex = 4
                errorMessage = phoneNumber.0
                phoneError?.isHidden = false
                phoneError?.text = errorMessage
                linePhone?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                ic_phone?.isHidden = false
                
            }
            else if !city.1 {
                errorIndex = 5
                errorMessage = city.0
                cityError?.isHidden = false
                cityError?.text = errorMessage
                lineCity?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icCity?.isHidden = false
                
            }
            else if !line1.1 {
                errorIndex = 6
                errorMessage = line1.0
                addLine1Error?.isHidden = false
                addLine1Error?.text = errorMessage
                lineAdd1?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icLine1?.isHidden = false
                
            }
                //            else if !line2.1 {
                //                errorIndex = 6
                //                errorMessage = line2.0
                //                addLine2Error?.isHidden = false
                //                addLine2Error?.text = errorMessage
                //                lineAdd2?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                //                ic_line2?.isHidden = false
                //
                //            }
            else {
                isValid = true
            }
            print(errorIndex)
            return isValid
        }else{
            let salutation = ValidationClass.verifySalutation(text: txtFirstName.text ?? "")
            let firstName = ValidationClass.verifyFirstname(text: txtFirstName.text ?? "")
            let lastName = ValidationClass.verifyLastname(text: txtLastName.text ?? "")
            let phoneNumber = ValidationClass.verifyPhoneNumber(text: txtPhoneNumber.text ?? "")
            let city = ValidationClass.verifyCity(text: txtCity.text ?? "")
            let line1 = ValidationClass.verifyAdd1(text: txtAddressLine1.text ?? "")
            //  let line2 = ValidationClass.verifyAdd2(text: txtAddressLine2.text ?? "")
            errorIndex = 999
            errorMessage = ""
            
            if !salutation.1 {
                errorIndex = 0
                errorMessage = firstName.0
                salutationError?.isHidden = false
                salutationError?.text = errorMessage
                lineSalutation?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icSalutation?.isHidden = false
                
            }
            else if !firstName.1 {
                errorIndex = 1
                errorMessage = firstName.0
                firstNameError?.isHidden = false
                firstNameError?.text = errorMessage
                lineFirstNm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icFnm?.isHidden = false
                
            } else if !lastName.1 {
                errorIndex = 2
                errorMessage = firstName.0
                lastNmError?.isHidden = false
                lineLnm?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                lastNmError?.text = errorMessage
                icLnm?.isHidden = false
                
            }
            else if !phoneNumber.1 {
                errorIndex = 3
                errorMessage = phoneNumber.0
                phoneError?.isHidden = false
                phoneError?.text = errorMessage
                linePhone?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                ic_phone?.isHidden = false
                
            }
            else if !city.1 {
                errorIndex = 3
                errorMessage = city.0
                cityError?.isHidden = false
                cityError?.text = errorMessage
                lineCity?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icCity?.isHidden = false
                
            }
            else if !line1.1 {
                errorIndex = 4
                errorMessage = line1.0
                addLine1Error?.isHidden = false
                addLine1Error?.text = errorMessage
                lineAdd1?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                icLine1?.isHidden = false
                
            }
                //            else if !line2.1 {
                //                errorIndex = 5
                //                errorMessage = line2.0
                //                addLine2Error?.isHidden = false
                //                addLine2Error?.text = errorMessage
                //                lineAdd2?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                //                ic_line2?.isHidden = false
                //
                //            }
            else {
                isValid = true
            }
            
            return isValid
        }
    }
    func validationMsg(msg: String){
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}
//
//extension AddNewAddressShippingViewController: UITableViewDataSource, UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 7
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//            return 1
//        }
//        if section == 1{
//            /*if isWork == true{
//                return 5
//            }*/
//            return addressNameDetail.count
//        }
//        if section == 2{
//            return 1
//        }
//        if section == 3{
//            return addressDetail.count
//        }
//        if section == 4{
//            return 1
//        }
//        if section == 5{
//            return 1
//        }
//        if section == 6{
//            return 1
//        }
//        return 0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressNameCell", for: indexPath) as? AddressNameCell else{return UITableViewCell()}
//            cell.delegate = self
//            if isWork == true{
//                cell.workBtnOutlet.backgroundColor = UIColor.black
//                cell.workBtnOutlet.setTitleColor(UIColor.white, for: .normal)
//                cell.homeBtnOutlet.backgroundColor = UIColor.white
//                cell.homeBtnOutlet.setTitleColor(UIColor.black, for: .normal)
//                cell.otherBtnOutlet.backgroundColor = UIColor.white
//            }
//            if isHome == true{
//                cell.workBtnOutlet.backgroundColor = UIColor.white
//                cell.workBtnOutlet.setTitleColor(UIColor.black, for: .normal)
//                cell.homeBtnOutlet.backgroundColor = UIColor.black
//                cell.homeBtnOutlet.setTitleColor(UIColor.white, for: .normal)
//                cell.otherBtnOutlet.backgroundColor = UIColor.white
//            }
//            return cell
//        }
//        if indexPath.section == 1{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTextFieldCell", for: indexPath) as? addressTextFieldCell else{return UITableViewCell()}
//
//            cell.delegate = self
//            cell.addressTF.placeholder = addressNameDetail[indexPath.row]
//            if isWork{
//                cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row)")!
//                cell.addressTF.text = params["\(indexPath.section)\(indexPath.row)"] as? String
//
//                if Int("\(indexPath.section)\(indexPath.row)")! == 11{
//                    dropDown.anchorView = cell.addressTF
//                    //cell.addressTF.inputView = dropDown
//                    cell.dropDownBtnOutlet.isHidden = false
//                    cell.dropDownIcon.isHidden = false
//                    cell.dropDownBtnOutlet.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
//                }else{
//                    //cell.addressTF.inputView = nil
//                     cell.dropDownBtnOutlet.isHidden = true
//                     cell.dropDownIcon.isHidden = true
//                }
//            }else{
//              cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row + 1)")!
//                cell.addressTF.text = params["\(indexPath.section)\(indexPath.row + 1)"] as? String
//
//                if Int("\(indexPath.section)\(indexPath.row + 1)")! == 11{
//                    dropDown.anchorView = cell.addressTF
//                    //cell.addressTF.inputView = dropDown
//                    cell.dropDownBtnOutlet.isHidden = false
//                    cell.dropDownIcon.isHidden = false
//                    cell.dropDownBtnOutlet.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
//                }else{
//                    //cell.addressTF.inputView = nil
//                     cell.dropDownBtnOutlet.isHidden = true
//                     cell.dropDownIcon.isHidden = true
//                }
//            }
//
//            return cell
//        }
//        if indexPath.section == 2{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCountryTableViewCell", for: indexPath) as? SelectCountryTableViewCell else{return UITableViewCell()}
//            return cell
//        }
//        if indexPath.section == 3{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTextFieldCell", for: indexPath) as? addressTextFieldCell else{return UITableViewCell()}
//            cell.delegate = self
//            cell.addressTF.placeholder = addressDetail[indexPath.row]
//            cell.addressTF.tag = Int("\(indexPath.section)\(indexPath.row)")!
//            cell.addressTF.text = params["\(indexPath.section)\(indexPath.row)"] as? String
//
//            cell.dropDownBtnOutlet.isHidden = true
//            cell.dropDownIcon.isHidden = true
//            return cell
//        }
//        if indexPath.section == 4{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingNotesTableViewCell", for: indexPath) as? shoppingNotesTableViewCell else{return UITableViewCell()}
//            return cell
//        }
//        if indexPath.section == 5{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "setDefaultAdress", for: indexPath) as? setDefaultAdress else{return UITableViewCell()}
//            cell.delegate = self
//            if params["defaultShipping"] as? Bool ?? false{
//                cell.defaultAddressBtnOutlet.setImage(UIImage(named: "ic_switch_on"), for: .normal)
//            }else{
//                cell.defaultAddressBtnOutlet.setImage(UIImage(named: "ic_switch_off"), for: .normal)
//            }
//            return cell
//        }
//        if indexPath.section == 6{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "saveAddressTableViewCell", for: indexPath) as? saveAddressTableViewCell else{return UITableViewCell()}
//            cell.delegate = self
//            return cell
//        }
//        return UITableViewCell()
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 5{
//            return 150
//        }
//        if indexPath.section == 6{
//            return 80
//        }
//        return UITableViewAutomaticDimension
//    }
////}
//extension AddNewAddressShippingViewController: AddrerssNameProtocol,DefaultAddressProtocol{
//    func defaultAddress() {
//        params["defaultShipping"] = !(params["defaultShipping"] as! Bool)
//       // tableView.reloadData()
//    }
//    func work() {
//        isWork = true
//        isHome = false
//
//        let addDetail = addressNameDetail
//        addressNameDetail.removeAll()
//        addressNameDetail.append("Company Name")
//        addressNameDetail.append(contentsOf: addDetail)
//        tableView.reloadData()
//    }
//    func home() {
//        isWork = false
//        isHome = true
//        if addressNameDetail.contains("Company Name"){
//            addressNameDetail.remove(object: "Company Name")
//        }
//        tableView.reloadData()
//    }
//    func other() {
//        if addressNameDetail.contains("Company Name"){
//            addressNameDetail.remove(object: "Company Name")
//        }
//        isWork = false
//        isHome = true
//        tableView.reloadData()
//    }
//}
extension AddNewAddressShippingViewController : addressTextDelegate{
    func addressText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String){
        let text:String =  textField.text! + string
        
        /*let pointInTableView = textField.convert(textField.bounds.origin, to: self.tableView)
         let indexPath = self.tableView.indexPathForRow(at: pointInTableView)
         */
        params["\(textField.tag)"] = text
    }
}

extension AddNewAddressShippingViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtAddress{
            let characterCountLimit = 9999
            
            let startingLength = textView.text?.count ?? 0
            let lengthToAdd = text.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            self.lblCount.text = "\(newLength)/1000"
            return newLength <= characterCountLimit
        }else{
            let characterCountLimit = 9999
            
            let startingLength = textView.text?.count ?? 0
            let lengthToAdd = text.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            self.lblBillingCount.text = "\(newLength)/1000"
            return newLength <= characterCountLimit
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            textView.textAlignment = .left
        }
        else{
            textView.textAlignment = .right
        }
        if textView == txtAddress{
            if textView.textColor == UIColor.init(hexString: "474747") {
                textView.text = ""
                textView.textColor = UIColor.black
                
            }
        }else if textView == txtBillingAddress {
            if textView.textColor == UIColor.init(hexString: "474747") {
                textView.text = ""
                textView.textColor = UIColor.black
                
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtAddress{
            if textView.text == "" {
                
                textView.text = "Shipping notes"
                textView.textColor = UIColor.init(hexString: "474747")
            }else if textView == txtBillingAddress {
                textView.text = "Shipping notes"
                textView.textColor = UIColor.init(hexString: "474747")
            }
        }
    }
}
extension AddNewAddressShippingViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSalutaion{
            params["11"] = textField.text
            
        }else if textField == txtFirstName{
            params["12"] = textField.text
            
        }else if textField == txtLastName{
            params["13"] = textField.text
            
        }else if textField == txtPhoneNumber{
            params["14"] = textField.text
            
        }else if textField == txtCompanyName{
            if viewCompanyName.isHidden == false{
                params["10"] = textField.text
            }
        }else if textField == txtCity{
            
            params["30"] = textField.text
            
        }else if textField == txtAddressLine1{
            
            params["31"] = textField.text
            
        }else if textField == txtAddressLine2{
            
            params["32"] = textField.text
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        if textField == txtAddressLine1 || textField == txtAddressLine2 || textField == txtBillingAdd1 || textField == txtBillingAdd2{
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 35 characters
            return updatedText.count <= 35
        }
        else{
            return true
        }
    }
}

extension AddNewAddressShippingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.saluttionPickerBilling{
            return 1
        }else if pickerView == self.cityPicker{
            return 1
        }else if pickerView == self.saluttionPicker{
            return 1
        }else if pickerView == self.CountryCodePicker{
            return 1
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.saluttionPickerBilling{
            return arrSalutation.count
        }else if pickerView == self.cityPicker{
            return cityList.count
        }else if pickerView == self.saluttionPicker {
            return arrSalutation.count
        }else if pickerView == self.CountryCodePicker{
            return countryCode.count
        }else{
            return countryCodeBilling.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.saluttionPickerBilling{
            billingTxtSalutation.text = arrSalutation[row]
        }else if pickerView == self.cityPicker{
            if isfromBillingCity == true {
                txtBillingCity.text = cityList[row]
            }else{
                txtCity.text = cityList[row]
            }
        }else if pickerView == self.saluttionPicker {
            txtSalutaion.text = arrSalutation[row]
        }else if pickerView == self.CountryCodePicker{
            txtCountryCode.text = countryCode[row].countryCode
        }else{
            txtContryCodeBilling.text = countryCodeBilling[row].countryCode
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == self.saluttionPickerBilling{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.text = arrSalutation[row]
            return label
        }else if pickerView == self.cityPicker{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.text = cityList[row]
            return label
        }
        else if pickerView == self.saluttionPicker{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.text = arrSalutation[row]
            return label
        }else if pickerView == self.CountryCodePicker{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            let cCode = countryCode[row].countryCode
            let cName = countryCode[row].countryName
            label.text = "+\(cCode) \(cName)"
            return label
        }else{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            let cCode = countryCodeBilling[row].countryCode
            let cName = countryCodeBilling[row].countryName
            label.text = "+\(cCode) \(cName)"
            return label
        }
    }
}
extension AddNewAddressShippingViewController:NoInternetDelgate{
    func didCancel() {
        self.callCity()
    }
}
