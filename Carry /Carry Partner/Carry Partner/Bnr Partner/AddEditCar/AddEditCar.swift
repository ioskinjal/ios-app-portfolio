//
//  AddEditCar.swift
//  BnR Partner
//
//  Created by KASP on 10/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import DropDown
import Alamofire


protocol AddCarDelegate {
    func dismissCarClicked()
    
}

class AddEditCar: BaseVC {
    
    let brandDropDown = DropDown()
    let carDropDown = DropDown()
    let subCarDropDown = DropDown()
    
    @IBOutlet weak var brandSelectionView: UIView!
    @IBOutlet weak var brandImgView: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    
    @IBOutlet weak var carSelectionView: UIView!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var subCarSelectionView: UIView!
    @IBOutlet weak var subCarImgView: UIImageView!
    @IBOutlet weak var lblSubCarName: UILabel!
    
    @IBOutlet weak var carNameView: UIView!
    @IBOutlet weak var carNumberView: UIView!
    
    @IBOutlet weak var txtCarName: UITextField!
    @IBOutlet weak var txtCarNumber: UITextField!
    
    @IBOutlet weak var defaultBtn: UIButton!
    @IBOutlet weak var lblSetAsDefult:UILabel!
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var lblAddCar:UILabel!
    var isDefaultLoad = true
    
    var editedCar:Car?
    
    var delegate: AddCarDelegate?
    
    var brand:Brands!
    var car:AddCar!
    var subCar:SubCar!
    
    
    var brandTypes:NSMutableArray = []
    var carTypes:NSMutableArray = []
    var subCarTypes:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDown.appearance().textFont = UIFont.init(name: "Roboto-Regular", size: 16)!
        
        brandSelectionView.applyBorder(color: UIColor.darkGray, width: 1.0)
        carSelectionView.applyBorder(color: UIColor.darkGray, width: 1.0)
        subCarSelectionView.applyBorder(color: UIColor.darkGray, width: 1.0)
        carNameView.applyBorder(color: UIColor.darkGray, width: 1.0)
        carNumberView.applyBorder(color: UIColor.darkGray, width: 1.0)
        
        
        getBrands()
        loadCars()
        
        if (self.editedCar != nil) {
            
            if self.editedCar?.isDefault.lowercased() == "y"{
                self.defaultBtn.isSelected = true
            }
            
            self.txtCarName.text = self.editedCar?.carName
            self.txtCarNumber.text = self.editedCar?.carNumber
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblBrandName.text = appConts.const.sELECT_BRAND
        self.lblSubCarName.text = appConts.const.sELECT_SUB_CAR_TYPE
        self.lblCarName.text = appConts.const.sELECT_CAR_TYPE
        
        self.txtCarName.placeholder = appConts.const.lBL_CAR_NAME
        self.txtCarNumber.placeholder = appConts.const.lBL_CAR_NO
        lblSetAsDefult.text = appConts.const.lBL_SET_DEFAULT
        lblAddCar.text = appConts.const.bTN_ADD_CAR
        btnCancel.setTitle(appConts.const.cANCEL, for: .normal)
        btnSubmit.setTitle(appConts.const.lBL_SUBMIT, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBrands(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Brand.getBrands, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                print("Response Dict \(dataAns)")
                
                
                let brands = Brands.initWithResponse(array: (dataAns as! [Any]))
                
                self.brandTypes = (brands as NSArray).mutableCopy() as! NSMutableArray
                
                // Set Default first brand type
                if self.brandTypes.count > 0 {
                    
                    if self.editedCar == nil {
                        self.brand = (self.brandTypes.object(at: 0) as! Brands)
                        
                    }
                    else{
                        for (_,element) in self.brandTypes.enumerated(){
                            
                            let newCar = element as! Brands
                            
                            if newCar.brandName == self.editedCar?.brandName {
                                self.brand = newCar
                                break
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.lblBrandName.text = self.brand?.brandName
                    }
                    
                }
                
                
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
        
    }
    
    // MARK: - Get Cars for user
    func loadCars(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getCarType, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                print("Items \(dataAns)")
                
                let cars = AddCar.initWithResponse(array: (dataAns as! [Any]))
                
                self.carTypes = (cars as NSArray).mutableCopy() as! NSMutableArray
                
                // Set Default first brand type
                if self.carTypes.count > 0 {
                    
                    if self.editedCar == nil {
                        self.car = (self.carTypes.object(at: 0) as! AddCar)
                        
                    }
                    else{
                        
                        for (_,element) in self.carTypes.enumerated(){
                            
                            let newCar = element as! AddCar
                            
                            if newCar.typeName == self.editedCar?.typeName {
                                self.car = newCar
                                self.isDefaultLoad = true
                                break
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.lblCarName.text = self.car?.typeName
                        self.carImgView.af_setImage(withURL: URL(string: URLConstants.Domains.CarUrl + self.car.id + "/" + self.car.typeImage)!)
                    }
                    
                    if self.isDefaultLoad {
                        self.loadSubCarTypes(car: self.car!)
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    func loadSubCarTypes(car:AddCar){
        
        startIndicator(title: "")
        let parameters: Parameters = ["carTypeId":car.id,"lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getSubCarType, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                print("Items \(dataAns)")
                
                let cars = SubCar.initWithResponse(array: (dataAns as! [Any]))
                
                self.subCarTypes = (cars as NSArray).mutableCopy() as! NSMutableArray
                
                // Set Default first Sub car type
                if self.subCarTypes.count > 0 {
                    
                    if self.editedCar == nil {
                        self.subCar = (self.subCarTypes.object(at: 0) as! SubCar)
                    }
                    else{
                        
                        for (_,element) in self.subCarTypes.enumerated(){
                            
                            let newCar = element as! SubCar
                            
                            if newCar.subTypeName == self.editedCar?.subTypeName {
                                self.subCar = newCar
                                break
                            }
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.lblSubCarName.text = self.subCar?.subTypeName
                         self.subCarImgView.af_setImage(withURL: URL(string: URLConstants.Domains.SubCarUrl+self.subCar.subTypeImage)!)
                    }
                    
                    if self.isDefaultLoad {
                        self.isDefaultLoad = false
                    }
                }
                
            }
            else{
                DispatchQueue.main.async {
                    self.subCarTypes = []
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    func addNewCar(){
        
        startIndicator(title: "")
        
        let parameters:Parameters
        let apiURL:String
        
        if (self.editedCar != nil) {
            
                apiURL = URLConstants.Domains.ServiceUrl+URLConstants.Car.editCar
            parameters = [
                "carId":self.editedCar?.carId as Any,
                "driverId":self.sharedAppDelegate().currentUser!.uId,
                "brandId":self.brand.brandId,
                "carTypeId":self.car.id,
                "subCarTypeId":self.subCar.typeId,
                "carName":self.txtCarName.text!,
                "carNumber":self.txtCarNumber.text!,
                "isDefault":self.defaultBtn.isSelected ? "y" : "n",
                "lId":Language.getLanguage().id
            ]
        }
        else{
            apiURL = URLConstants.Domains.ServiceUrl+URLConstants.Car.addCar

            parameters = [
                "driverId":self.sharedAppDelegate().currentUser!.uId,
                "brandId":self.brand.brandId,
                "carTypeId":self.car.id,
                "subCarTypeId":self.subCar.typeId,
                "carName":self.txtCarName.text!,
                "carNumber":self.txtCarNumber.text!,
                "isDefault":self.defaultBtn.isSelected,
                "lId":Language.getLanguage().id
            ]
        }
        
        
        
        let alert = Alert()
        
         WSManager.getResponseFrom(serviceUrl: apiURL, parameters: parameters, successBlock: { (json, urlResponse) in
        
        self.stopIndicator()
        print("Request: \(String(describing: urlResponse?.request))")   // original url request
        print("Response: \(String(describing: urlResponse?.response))") // http url response
        print("Result: \(String(describing: urlResponse?.result))")                         // response serialization
        
        let jsonDict = json as NSDictionary?
        
        let status = jsonDict?.object(forKey: "status") as! Bool
        let message = jsonDict?.object(forKey: "message") as! String
        
        if status == true{
            
            DispatchQueue.main.async {

            alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
            
            self.delegate?.dismissCarClicked()
            }
        }
        else{
            DispatchQueue.main.async {
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                
            }
        }
    }) { (error) in
    DispatchQueue.main.async {
    self.stopIndicator()
    
    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
    }
    }

    
}


@IBAction func btnShowBrandsClicked(_ sender: Any) {
    
    // The view to which the drop down will appear on
    brandDropDown.anchorView = brandSelectionView // UIView or UIBarButtonItem
    
    // The list of items to display. Can be changed dynamically
    
    var newArray = [String]()
    for case let brand as Brands in self.brandTypes {
        
        newArray.append(brand.brandName)
    }
    
    brandDropDown.dataSource = newArray
    
    brandDropDown.cellNib = UINib(nibName: "CarCell", bundle: nil)
    
    
    brandDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
        guard let cell = cell as? CarCell else { return }
        
        // Setup your custom UI components
        cell.optionLabel.text = self.brandDropDown.dataSource[index]
        cell.brandBtn.tag = index
        cell.brandBtn.addTarget(self, action: #selector(self.btnDismissBrandsClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.brandIconImgView.isHidden = true
    }
    brandDropDown.dismissMode = .onTap
    brandDropDown.show()
    
    
}

@IBAction func btnDismissBrandsClicked(_ sender: UIButton) {
    print( sender.tag)
    
    brandDropDown.hide()
    
    let selectedBrand = self.brandTypes.object(at: sender.tag) as! Brands
    self.lblBrandName.text = selectedBrand.brandName
    
    
}

@IBAction func btnShowCarsClicked(_ sender: Any) {
    
    // The view to which the drop down will appear on
    carDropDown.anchorView = carSelectionView // UIView or UIBarButtonItem
    
    // The list of items to display. Can be changed dynamically
    var newArray = [String]()
    for case let newCar as AddCar in self.carTypes {
        
        newArray.append(newCar.typeName)
    }
    
    carDropDown.dataSource = newArray
    
    carDropDown.cellNib = UINib(nibName: "CarCell", bundle: nil)
    
    carDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
        guard let cell = cell as? CarCell else { return }
        
        // Setup your custom UI components
        cell.optionLabel.text = self.carDropDown.dataSource[index]
        cell.brandBtn.tag = index
        cell.brandBtn.addTarget(self, action: #selector(self.btnDismissCarsClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.brandIconImgView.isHidden = false
        
        let car:AddCar = self.carTypes.object(at: index) as! AddCar
        cell.brandIconImgView.af_setImage(withURL: URL(string: URLConstants.Domains.CarUrl + car.id + "/" + car.typeImage)!)
        
    }
    carDropDown.dismissMode = .onTap
    carDropDown.show()
    
}

@IBAction func btnDismissCarsClicked(_ sender: UIButton) {
    
    print( sender.tag)
    carDropDown.hide()
    let selectedCar = self.carTypes.object(at: sender.tag) as! AddCar
    self.lblCarName.text = selectedCar.typeName
    self.carImgView.af_setImage(withURL: URL(string: URLConstants.Domains.CarUrl + selectedCar.id + "/" + selectedCar.typeImage)!)
    self.loadSubCarTypes(car: selectedCar)
    self.lblSubCarName.text = "Select Category"
    
    self.car = selectedCar
    self.subCar = SubCar()
}

@IBAction func btnShowSubCarsClicked(_ sender: Any) {
    
    
    if self.subCarTypes.count == 0{
        let alert = Alert()
        alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_CATEGORY_NOT_AVAILABLE, buttonTitleStr: appConts.const.bTN_OK)
            return
    }
    
    
    // The view to which the drop down will appear on
    subCarDropDown.anchorView = subCarSelectionView // UIView or UIBarButtonItem
    
    // The list of items to display. Can be changed dynamically
    var newArray = [String]()
    for case let newCar as SubCar in self.subCarTypes {
        
        newArray.append(newCar.subTypeName)
    }
    
    subCarDropDown.dataSource = newArray
    
    subCarDropDown.cellNib = UINib(nibName: "CarCell", bundle: nil)
    
    subCarDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
        guard let cell = cell as? CarCell else { return }
        
        // Setup your custom UI components
        cell.optionLabel.text = self.subCarDropDown.dataSource[index]
        cell.brandBtn.tag = index
        cell.brandBtn.addTarget(self, action: #selector(self.btnDismissSubCarsClicked(_:)), for: UIControlEvents.touchUpInside)
        cell.brandIconImgView.isHidden = false
        
        let car:SubCar = self.subCarTypes.object(at: index) as! SubCar
        cell.brandIconImgView.af_setImage(withURL: URL(string: URLConstants.Domains.SubCarUrl+car.subTypeImage )!)
        
        cell.brandIconImgView.clipsToBounds = true
        
    }
    subCarDropDown.dismissMode = .onTap
    subCarDropDown.show()
    
}

@IBAction func btnDismissSubCarsClicked(_ sender: UIButton) {
    
    print( sender.tag)
    subCarDropDown.hide()
    let selectedCar = self.subCarTypes.object(at: sender.tag) as! SubCar
    self.lblSubCarName.text = selectedCar.subTypeName
    self.subCarImgView.af_setImage(withURL: URL(string: URLConstants.Domains.SubCarUrl+selectedCar.subTypeImage)!)
    self.subCar = selectedCar
}

@IBAction func btnSetDefaultClicked(_ sender: Any) {
    
    if self.defaultBtn.isSelected{
        self.defaultBtn.isSelected = false
    }
    else{
        self.defaultBtn.isSelected = true
    }
}

@IBAction func btnSubmitClicked(_ sender: Any) {
    
    let alert = Alert()
    
    
    if (self.subCar  == nil) {
        
        if self.subCarTypes.count == 0{
            alert.showAlert(titleStr: "", messageStr: appConts.const.rEQ_CATEGORY, buttonTitleStr: appConts.const.bTN_OK)

        }
        else{
            alert.showAlert(titleStr: "", messageStr: appConts.const.lBL_SELECT_CATEGORY, buttonTitleStr: appConts.const.bTN_OK)
////*
        }
    }
    else if (self.txtCarName.text?.isEmpty)! {
        alert.showAlert(titleStr: "", messageStr: appConts.const.lBL_SELECT_CAR, buttonTitleStr: appConts.const.bTN_OK)
    }
    else if (self.txtCarNumber.text?.isEmpty)! {
        alert.showAlert(titleStr: "", messageStr: appConts.const.eNTER_CAR_NUMBER, buttonTitleStr: appConts.const.bTN_OK)
        
    }
    else{
            addNewCar()
    }
    
}

@IBAction func btnCancelClicked(_ sender: Any) {
    
    delegate?.dismissCarClicked()
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override
 re(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}

extension AddEditCar:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtCarNumber {
            // Get invalid characters
            let invalidChars = NSCharacterSet.alphanumerics.inverted
            
            // Attempt to find the range of invalid characters in the input string. This returns an optional.
            let range = string.rangeOfCharacter(from: invalidChars)
            
            if range != nil && string != " " {
                // We have found an invalid character, don't allow the change
                return false
            } else {
                // No invalid character, allow the change
                return true
            }
        }
        return true
    }
}
