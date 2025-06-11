//
//  ChooseHDViewController.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DropDown
import  Foundation

class ChooseHDViewController: UIViewController {
    
    @IBOutlet weak var lblHomeDelivery: UILabel!{
        didSet{
            lblHomeDelivery.text = "home_delivery".localized.uppercased()
            lblHomeDelivery.addTextSpacing(spacing: 1.5)
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
    
    @IBOutlet weak var lblGrandTotalHead: UILabel!{
        didSet{
            lblGrandTotalHead.text = "Grand Total".localized
        }
    }
    @IBOutlet weak var btnProceedToPayment: UIButton!{
        didSet{
            btnProceedToPayment.setTitle("proceed_to_payment".localized, for: .normal)
            btnProceedToPayment.addTextSpacingButton(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblVatInclusive: UILabel!{
        didSet{
            lblVatInclusive.text = "vatInclusive".localized
            lblVatInclusive.isHidden  = shouldHideVatinclusive()
        }
    }
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var totalAmount: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                totalAmount.textAlignment = .right
            }else{
                totalAmount.textAlignment = .left
            }
        }
    }
    
    let dropDown = DropDown()
    var expressDeliveryTime: String? = ""
    var selectedDeliveryTime : String = ""
    var isHomeSelected: Bool = false
    var isWorkSelected: Bool = false
    var isTodaySelected: Bool = true
    var isTomorrowSelected: Bool = false
    var PickerView = UIPickerView()
    var toolBar = UIToolbar()
    var isAddressCheck: Bool = false
    var coupon = ""
     var voucher = ""
    var pricecategories = [String]()
    var checkoutOrderSummary = [Double]()
    var tblDataPricecategories = [String]()
    var tblDatacheckoutOrderSummary = [Double]()
    var homePaymentOrderSummary: [String: Any] = [:]
    var deliveryOptionDict: [String: Any] = [:]
    var shippingAddress = [Addresses]()
    var addressArray : [Addresses] = [Addresses]()
    var addressSelectionArray: [Bool] = [Bool]()
    var selectedCity = ""
    let viewModel = CheckoutViewModel()
    var selectAddress: Addresses?
    var shippingMethod : [EstimatedShippingModel] = [EstimatedShippingModel]()
    var timeSlotDict: [String: Any] = [:]
    var timeSlotArray: [[String: Any]] = [[String: Any]]()
    var tomorrowSlotArray: [String] = [String]()
    var todaySlotArray: [String] = [String]()
    
    var todayTime = ""
    var tomorrowTime = ""
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        todayTime = dateFormatter.string(from: date)
        //MARK:- Register Table Cells
        let cell = [HDShippingTableCell.className,HDDeliveryTableCell.className,HDAddNewAddressTableCell.className,HDDeliveryOptionTableCell.className,HDDeliverySelectionTableCell.className]
            tableView.register(cell)
        
        for i in 0..<addressArray.count{
            if addressArray[i].defaultBilling != true || (addressArray[i].defaultShipping == true && addressArray[i].defaultBilling == true)  {
                shippingAddress.append(addressArray[i])
            }
           
        }
    
       // DispatchQueue.main.async {
            if self.shippingAddress.count != 0{
            self.shippingAddress = self.shippingAddress.reversed()
            self.shippingAddress[0].isselected = true
            }
            else if(addressArray.count == 1){
                 shippingAddress.append(addressArray[0])
        }
        }
   // }
    
   func updateHeight() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedCity = ""
        let orderSummary = homePaymentOrderSummary["orderSummary"] as? [Double]
        if checkoutOrderSummary.count == 5{
        totalAmount.text = currencyFormater(amount: checkoutOrderSummary[4] ?? 0.0) + " " + "\(homePaymentOrderSummary["currency"] ?? "")".localized
        }else{
            totalAmount.text = currencyFormater(amount: checkoutOrderSummary[5] ?? 0.0) + " " + "\(homePaymentOrderSummary["currency"] ?? "")".localized
        }
        for i in 0..<addressArray.count{
            addressSelectionArray.append(addressArray[i].defaultShipping ?? false)
            if addressArray[i].defaultShipping == true && (addressArray[i].city)!.uppercased() == "DUBAI".localized{
                selectedCity = "DUBAI".localized
            }
            if addressArray[i].defaultShipping == true{
                 selectAddress = addressArray[i]
            }
            
        }
        if selectAddress == nil && addressArray.count > 0{
            selectAddress = addressArray[0]
        }
        let addrSel = addressSelectionArray.filter{$0 == true}
        if addrSel.count == 0 && addressSelectionArray.count > 0 {
            addressSelectionArray[0] = true
        }
        getExtimatedShippingAddress()
    }
    func  getExtimatedShippingAddress(){
        for i in 0..<shippingAddress.count{
            if shippingAddress[i].isselected == true{
                selectAddress = shippingAddress[i]
            }
        }
        var params: [String: Any] = [:]
        var addrParams: [String: Any] = [:]
        
        addrParams["firstname"] = selectAddress?.firstname
        addrParams["lastname"] = selectAddress?.lastname
        addrParams["company"] = selectAddress?.company
        addrParams["country_id"] = selectAddress?.countryId
        addrParams["street"] = selectAddress?.street
        addrParams["city"] = selectAddress?.city
        addrParams["region"] = ""
        //addrParams["id"] = selectAddress?.id?.val
        addrParams["postcode"] = selectAddress?.postcode
        addrParams["telephone"] = selectAddress?.telephone
        addrParams["same_as_billing"] = ""
        addrParams["save_in_address_book"] = ""
        
        params["address"] = addrParams
        print(params)
        
     
        
        
        viewModel.getEstimatedShippingMethod(params, success: { (response) in
            print(response)
            self.shippingMethod = response
            let  arr:[EstimatedShippingModel] = self.shippingMethod.filter{ $0.carrierCode == "matrixrate"}
            if(arr.count ?? 0 > 1){
            for index in 0..<(arr[0].estimatedExtentionAttribute?.timeSlot?.count ?? 0)!{
                if let str:String = arr[0].estimatedExtentionAttribute?.timeSlot?[index]{
                    if let data = str.data(using: .utf8){
                        do{
                            self.timeSlotDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                            self.timeSlotArray.append(self.timeSlotDict)
                            
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
                }}
            self.setTimeSlot()
            DispatchQueue.main.async {
             //   self.tableView.reloadData()
            }
        }) { (errorResponse) in
           print(errorResponse)
        }
    }
    
    func setTimeSlot(){
        for timeDict  in timeSlotArray{
            if timeDict["display_name"] as? String == "Tomorrow"{
                guard let timeRange:[String:Any] = timeDict["time_range"] as? [String:Any] else {
                    return
                }
                
                for key in timeRange.keys{
                    guard let timeStampDict: [String:Any] = timeRange[key] as? [String:Any] else {
                        return
                    }
                    
                    tomorrowSlotArray.append("\(timeStampDict["start_time"] as? String ?? "") - \(timeStampDict["end_time"] as? String ?? "")")
                    print(tomorrowSlotArray)
                }
                guard let internalDate:String = timeDict["internal_date"] as? String else {
                    return
                }
                print(internalDate)
                tomorrowTime = internalDate
            }
            
            if timeDict["display_name"] as? String == "Today"{
                guard let timeRange:[String:Any] = timeDict["time_range"] as? [String:Any] else {
                    return
                }
                
                for key in timeRange.keys{
                    guard let timeStampDict:[String:Any] = timeRange[key] as? [String:Any] else {
                        return
                    }
                    todaySlotArray.append("\(timeStampDict["start_time"] as? String ?? "") - \(timeStampDict["end_time"] as? String ?? "")")
                    
                }
                guard let internalDate:String = timeDict["internal_date"] as? String else {
                      return
                  }
                print(internalDate)
                 todayTime = internalDate
                
            }
        }
       
    }
    @IBAction func tapToBackButton(_ sender: UIButton){
     self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedToPaymentAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: ProceedToPaymentViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "ProceedToPaymentViewController") as? ProceedToPaymentViewController
        changeVC.coupon = coupon
        
       // var selectAddress: Addresses?
        for i in 0..<shippingAddress.count{
            if shippingAddress[i].isselected == true{
                selectAddress = shippingAddress[i]
            }
        }

        changeVC.priceCategories = pricecategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblDataPricecategories
        changeVC.tblDataCheckoutOrderSummary = tblDatacheckoutOrderSummary
        changeVC.deliveryOptionDict = deliveryOptionDict
        changeVC.addressArray = addressArray
        changeVC.addressDict = selectAddress
        changeVC.orderInformation = homePaymentOrderSummary
        self.navigationController?.pushViewController(changeVC, animated: true)
        
        
    }
}
func gotoReviewPage(){
  
}
extension ChooseHDViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return shippingAddress.count
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UITableViewAutomaticDimension
        case 1: return UITableViewAutomaticDimension
        case 2: return UITableViewAutomaticDimension
        case 3: return UITableViewAutomaticDimension
        case 4: return UITableViewAutomaticDimension

        default:
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            guard let CellHDShipping = tableView.dequeueReusableCell(withIdentifier: "HDShippingTableCell", for: indexPath) as? HDShippingTableCell else{return UITableViewCell()}
            return CellHDShipping
            
        case 1:
            
            guard let CellHDDelivery = tableView.dequeueReusableCell(withIdentifier: "HDDeliveryTableCell", for: indexPath) as? HDDeliveryTableCell else{return UITableViewCell()}
            CellHDDelivery.delegate = self
            CellHDDelivery.cellConfiguration(rowNumber: indexPath.row, isSelected: isAddressCheck)
            //Added by Nitikesh. temporary Solution.
           if(shippingAddress[indexPath.row].company != nil){
            CellHDDelivery._lblAddressType.text =  "\("Work") - \(shippingAddress [indexPath.row].company ?? "")"
           }
            if shippingAddress[indexPath.row].customAttributes != nil{
                for i in 0..<shippingAddress[indexPath.row].customAttributes!.count{
                    if shippingAddress[indexPath.row].customAttributes?[i].attributeCode == "address_type" {
                        if shippingAddress[indexPath.row].customAttributes?[i].value == "work"{
                            CellHDDelivery._lblAddressType.text =  "\(shippingAddress[indexPath.row].customAttributes?[i].value ?? "") - \(shippingAddress [indexPath.row].company ?? "")"
                    }else if shippingAddress[indexPath.row].customAttributes?[i].value == "other"{
                            CellHDDelivery._lblAddressType.text =  "\(shippingAddress[indexPath.row].customAttributes?[i].value ?? "")"
                    }else{
                            CellHDDelivery._lblAddressType.text = "\(shippingAddress[indexPath.row].customAttributes?[i].value ?? "")"
                    }
                       
            }
           
                
            }
            }
            CellHDDelivery.btnEdit.tag = indexPath.row
            CellHDDelivery.btnEdit.addTarget(self, action: #selector(onClickEdit), for: .touchUpInside)
            CellHDDelivery.datailAddressLabel.text = "\(shippingAddress[indexPath.row].firstname ?? "")" + " " + "\(shippingAddress[indexPath.row].lastname ?? "")" + "\n" + "\(shippingAddress[indexPath.row].street[0])" + "\n" + "\(shippingAddress[indexPath.row].city ?? "")" + "," + "\(shippingAddress[indexPath.row].countryId ?? "")"
            
           if shippingAddress[indexPath.row].isselected  == true{
                CellHDDelivery.radioBtnOutlet.setImage(UIImage(named: "radio_on"), for: .normal)
                CellHDDelivery._viewHome.backgroundColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1.0)
                
            }else{
                CellHDDelivery.radioBtnOutlet.setImage(UIImage(named: "radio_off"), for: .normal)
                CellHDDelivery._viewHome.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
            }
            return CellHDDelivery
            
        case 2:
            guard let CellHDAddNewAddress = tableView.dequeueReusableCell(withIdentifier: "HDAddNewAddressTableCell", for: indexPath) as? HDAddNewAddressTableCell else{return UITableViewCell()}
            CellHDAddNewAddress._btnAddNewAddress.tag = indexPath.row
            CellHDAddNewAddress.delegate = self
            return CellHDAddNewAddress
            
        case 3:
            guard let CellHDDeliveryOption = tableView.dequeueReusableCell(withIdentifier: "HDDeliveryOptionTableCell", for: indexPath) as? HDDeliveryOptionTableCell else{return UITableViewCell()}
            return CellHDDeliveryOption
            
        case 4:
            guard let CellHDDeliverySelection = tableView.dequeueReusableCell(withIdentifier: "HDDeliverySelectionTableCell", for: indexPath) as? HDDeliverySelectionTableCell else{return UITableViewCell()}
            
            CellHDDeliverySelection.delegate = self
            
            dropDown.anchorView = CellHDDeliverySelection._viewToday
            dropDown.anchorView = CellHDDeliverySelection._viewTomorrow
            if isTodaySelected{
                CellHDDeliverySelection.txtTomorrowDelivery.text = ""
                CellHDDeliverySelection.txtTodayDelivery.text = selectedDeliveryTime
            }else{
                CellHDDeliverySelection.txtTomorrowDelivery.text = selectedDeliveryTime
                CellHDDeliverySelection.txtTodayDelivery.text = ""
            }
            
            CellHDDeliverySelection._viewTomorrow.isHidden = true
            CellHDDeliverySelection.TotalViewHeight.constant = 0
            CellHDDeliverySelection.tomorrowConstraint.constant = 0
            CellHDDeliverySelection._viewToday.isHidden = true
            
            for timeDict  in timeSlotArray{
                if timeDict["display_name"] as? String == "Tomorrow"{
                    CellHDDeliverySelection._viewTomorrow.isHidden = false
                    CellHDDeliverySelection.tomorrowConstraint.constant = 85
                }
                
                if timeDict["display_name"] as? String == "Today"{
                    CellHDDeliverySelection._viewToday.isHidden = false
                    CellHDDeliverySelection.TotalViewHeight.constant = 85
                }
            }
            return CellHDDeliverySelection
        default:
            return UITableViewCell()
        }
    }
    
    @objc func onClickEdit(_ sender:UIButton){
        editAcdres(selectedAddress: shippingAddress[sender.tag])
    }
}
extension ChooseHDViewController:UIPickerViewDelegate,UIPickerViewDataSource{
   
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if isTodaySelected{
                return todaySlotArray.count
            }else{
                return tomorrowSlotArray.count
            }
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if isTodaySelected{
                return todaySlotArray[row]
            }else{
                return tomorrowSlotArray[row]
            }
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isTodaySelected == true {
            selectedDeliveryTime = todaySlotArray[row]
        }else if isTomorrowSelected == true{
            selectedDeliveryTime = tomorrowSlotArray[row]
        }
    }
}

extension ChooseHDViewController: HDDeliveryOptionProtocol, HDDeliverySelectionProtocol,AddNewAddressProtocol{
    
    
    func hdParentExpress() {
        onCancelButtonTapped()
        selectedDeliveryTime = ""
    }
    
    func hdParentToday() {
        onCancelButtonTapped()
        selectedDeliveryTime = ""
    }
    
    func hdParentTomorrow() {
        onCancelButtonTapped()
        selectedDeliveryTime = ""
    }
    
    func editAcdres(selectedAddress:Addresses?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        changeVC.addressArray = addressArray
        changeVC.selectedAddress = selectedAddress
        changeVC.isFromEditAdd = true
        changeVC.priceCategories = pricecategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblDataPricecategories
        changeVC.tblDataCheckoutOrderSummary = tblDatacheckoutOrderSummary
        changeVC.OrderSummary = homePaymentOrderSummary["orderSummary"] as! [Double]
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func didToggleRadioButton(_ cell: HDDeliveryTableCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
         for i in 0..<shippingAddress.count{
            shippingAddress[i].isselected = false
        }
        shippingAddress[indexPath.row].isselected = true
      
        self.tableView.reloadData()
        for i in 0..<shippingAddress.count{
            if indexPath.row == i{
                addressSelectionArray[i] = true
                let addr = shippingAddress[i]
                selectedCity = addr.city ?? ""
            }else{
                addressSelectionArray[i] = false
            }
        }
        getExtimatedShippingAddress()
    }
    func currencyFormater(amount: Double)-> String{
        let largeNumber = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return amount.clean
        //return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }

    func addNewAddress() {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: AddNewAddressShippingViewController!
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddNewAddressShippingViewController") as? AddNewAddressShippingViewController
        changeVC.addressArray = addressArray
        changeVC.isFromEditAdd = false
        changeVC.priceCategories = pricecategories
        changeVC.checkoutOrderSummary = checkoutOrderSummary
        changeVC.tblDataPriceCategories = tblDataPricecategories
        changeVC.tblDataCheckoutOrderSummary = tblDatacheckoutOrderSummary
        changeVC.OrderSummary = checkoutOrderSummary as! [Double]
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func HDhomeSelection() {
        isHomeSelected = true
        isWorkSelected = false
        tableView.reloadData()
    }
    func HDworkSelection() {
        isWorkSelected = true
        isHomeSelected = false
        tableView.reloadData()
    }
    func hdExpress() {
        
//        dropDown.show()
//        dropDown.dataSource = todaySlotArray
//        dropDown.direction = .bottom
//        dropDown.bottomOffset = CGPoint(x: 10, y:(dropDown.anchorView?.plainView.bounds.height)!)
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//            self.tomorrowDeliveryTime = item
//        }
    }
    func hdToday() {
        
        isTodaySelected = true
        isTomorrowSelected = false
        PickerViewLoad()
    }
    
    
    func hdTomorrow() {
        isTodaySelected = false
        isTomorrowSelected = true
        PickerViewLoad()
    }
    
    @objc func onDoneButtonTapped() {
        deliveryOptionDict["deliveryTime"] = selectedDeliveryTime
        if isTodaySelected{
            deliveryOptionDict["isDeliveryFlag"] = isTodaySelected
            deliveryOptionDict["deliverySchedule"] = "Today"
             deliveryOptionDict["deliveryDate"] = todayTime
        }else{
            deliveryOptionDict["isDeliveryFlag"] = isTomorrowSelected
            deliveryOptionDict["deliverySchedule"] =  "Tomorrow"
            deliveryOptionDict["deliveryDate"] = tomorrowTime
        }
        tableView.reloadData()
        toolBar.removeFromSuperview()
        PickerView.removeFromSuperview()
    }
       
       @objc func onCancelButtonTapped(){
           toolBar.removeFromSuperview()
           PickerView.removeFromSuperview()
       }
    
    //MARK:- Piker View
       func PickerViewLoad(){
           PickerView.delegate = self
           PickerView.dataSource = self
           
           PickerView.autoresizingMask = .flexibleWidth
           PickerView.backgroundColor = .white
           PickerView.contentMode = .center
           PickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
           self.view.addSubview(PickerView)
           toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
           toolBar.barStyle = .default
           toolBar.isTranslucent = true
           toolBar.tintColor = UIColor.black
           toolBar.sizeToFit()
           
           let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(onCancelButtonTapped))
           toolBar.setItems([cancelButton,spaceButton, doneButton], animated: false)
           
           self.view.addSubview(toolBar)
       }
    
}
