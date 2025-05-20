//
//  EditBusinessProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 05/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class EditBusinessProfileVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var labelBusinessSubCategory: UILabel!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var btnSaveSubCategory: UIButton!
    @IBOutlet weak var txtSubCategoryView: CustomTextField!
    @IBOutlet weak var labelAddSubcategory: UILabel!
    @IBOutlet weak var viewAddSubCategory: UIView!{
        didSet {
            viewAddSubCategory.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtDescrption: UITextView!{
        didSet {
            txtDescrption.layer.borderWidth = 1
            txtDescrption.layer.borderColor = Color.Custom.blackColor.cgColor
        }
    }
    @IBOutlet weak var txtPaypalEmail: CustomTextField!
    @IBOutlet weak var txtDate: CustomTextField!
    @IBOutlet weak var collViewSubCategory: UICollectionView!{
        didSet{
            collViewSubCategory.register(SubCategoryCell.nib, forCellWithReuseIdentifier: SubCategoryCell.identifier)
            collViewSubCategory.dataSource = self
            collViewSubCategory.delegate = self
            if let flowlayout = collViewSubCategory.collectionViewLayout as? UICollectionViewFlowLayout{
                flowlayout.estimatedItemSize = CGSize(width: 1, height: 1)
               // flowlayout.minimumInteritemSpacing = 20
                //flowlayout.minimumLineSpacing = 10
                flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            }
        }
    }
    @IBOutlet weak var txtService: CustomTextField!
    @IBOutlet weak var txtWillingNessToTravel: CustomTextField!
    @IBOutlet weak var txtBusinessName: CustomTextField!
    
    static var storyboardInstance:EditBusinessProfileVC? {
        return StoryBoard.profileProvider.instantiateViewController(withIdentifier: EditBusinessProfileVC.identifier) as? EditBusinessProfileVC
    }
    
    var businessProfile = BusinessProfile()
    var arrSubCategory = [BusinessProfile.SubCategoryList]()
    var arrSubCategoryDisp = [BusinessProfile.SubCategoryList]()
    var arrSubCategoryPicker = [BusinessProfile.SubCategoryList]()
    var pickerViewSubCategory = UIPickerView()
    var pickerViewCategory = UIPickerView()
    var arrCategory = [CategoryListProfile]()
    
    
    var lattitude = ""
    var longitude = ""
    var pincode = ""
    var categoryId = ""
    let datePicker:UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewSubCategory.delegate = self
        txtSubCategoryView.inputView = pickerViewSubCategory
        pickerViewCategory.delegate = self
        txtService.inputView = pickerViewCategory
        txtService.delegate = self
        txtAddress.delegate = self
        datePicker.datePickerMode = .date
        txtDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValue), for: UIControlEvents.valueChanged)
        callApiGetBusinessProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetBusinessProfile() {
        let dictParam = [
            "action": Action.business,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.businessProfile = BusinessProfile(dic: dict["businessprofile"] as? [String : Any] ?? [String : Any]())
            self.showBusinessProfileData()
            self.callApiGetCategory()
        }
    }
    func callApiGetCategory() {
        let dictParam = [
            "action": Action.getCategory,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getCategoryProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.arrCategory = ResponseKey.fatchData(res: dict, valueOf: .categoryList).ary.map({CategoryListProfile(dic: $0 as! [String:Any])})
            self.pickerViewCategory.reloadAllComponents()
            self.callApiGetSubCategory(self.businessProfile.bus_cat_id)
        }
    }
    func callApiGetSubCategory(_ categoryId: String) {
        let dictParam = [
            "action": Action.getSubCategory,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "category_id": categoryId
        ] as [String : Any]
        ApiCaller.shared.getCategoryProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            if categoryId != self.businessProfile.bus_cat_id {
                self.arrSubCategoryDisp.removeAll()
                self.collViewSubCategory.isHidden = true
            }
            self.collViewSubCategory.reloadData()
            self.arrSubCategory = ResponseKey.fatchData(res: dict, valueOf: .subCategoryList).ary.map({BusinessProfile.SubCategoryList(dic: $0 as! [String:Any])})
            self.pickerViewSubCategory.reloadAllComponents()
        }
    }
    func callApiSaveBusinessProfile(_ categoryId: String) {
        var dictParam = [
            "action": Action.editBusinessProfile,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "business_name": txtBusinessName.text!,
            "business_detail": txtDescrption.text!,
            "business_location": txtAddress.text!,
            "bus_pincode": pincode,
            "willing_to_travel": txtWillingNessToTravel.text!,
            "est_date": txtDate.text!,
            "bus_addressLat": lattitude,
            "bus_addressLng": longitude,
            "paypal_number": txtPaypalEmail.text!,
            "business_category": categoryId,
        ] as [String : Any]
        for i in 0..<arrSubCategoryDisp.count {
            dictParam["business_subcategory[\(i)]"] = arrSubCategoryDisp[i].id
        }
        ApiCaller.shared.editBusinessProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func showBusinessProfileData() {
        txtBusinessName.text = businessProfile.business_name
        txtWillingNessToTravel.text = businessProfile.w_travel
        txtService.text = businessProfile.category
        txtDate.text = businessProfile.est_date
        txtPaypalEmail.text = businessProfile.business_paypal_email
        txtDescrption.text = businessProfile.business_desc
        txtAddress.text = businessProfile.business_location
        self.arrSubCategoryDisp = self.businessProfile.arrSubCategoryList
        collViewSubCategory.reloadData()
        if let lattitude = businessProfile.bus_addressLat.toDouble(),let longitude = businessProfile.bus_addressLng.toDouble() {
            let coordiante = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
            setPinOnMapview(coordiante)
        }
        categoryId = businessProfile.bus_cat_id
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Edit Business Profile")
        txtBusinessName.placeholder = localizedString(key: "Business Name*")
        txtWillingNessToTravel.placeholder = localizedString(key: "Willingness to travel*")
        labelBusinessSubCategory.text = localizedString(key: "Business Sub-Category")
        txtDate.placeholder = localizedString(key: "Business Established Date*")
        txtPaypalEmail.placeholder = localizedString(key: "Paypal Email")
        txtAddress.placeholder = localizedString(key: "Address*")
        btnSave.setTitle(localizedString(key: "Save"), for: .normal)
        labelAddSubcategory.text = localizedString(key: "Add Sub Category")
        btnSaveSubCategory.setTitle(localizedString(key: "Save"), for: .normal)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAddress {
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
        }
        else if textField == txtSubCategoryView {
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtService {
            if (txtService.text?.isEmpty)! {
                return
            }
            for i in 0..<arrCategory.count {
                if arrCategory[i].category_name == txtService.text {
                    callApiGetSubCategory(arrCategory[i].id)
                }
            }
        }
    }
    
    func setPinOnMapview(_ coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let markerr = GMSMarker(position: coordinate)
        markerr.position.latitude = coordinate.latitude
        markerr.position.longitude = coordinate.longitude
        print("hello")
        print(markerr.position.latitude)
        let ULlocation = markerr.position.latitude
        let ULlgocation = markerr.position.longitude
        print(ULlocation)
        print(ULlgocation)
        mapView.animate(toLocation: coordinate)
        markerr.map = self.mapView
        mapView.delegate = self
        mapView.animate(toZoom: 15.0)
        let address = reverseGeocodeCoordinate(coordinate)
        print(address)
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        // 1
        let geocoder = GMSGeocoder()
        var strReturn = ""
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            print(response?.results() ?? "")
            strReturn = lines.joined(separator: "\n")
            //self.txtAddress.text = lines.joined(separator: "\n")
            self.updateData(address)
        }
        return strReturn
    }
    func updateData(_ address: GMSAddress) {
        self.txtAddress.text = (address.lines?.joined(separator: "")) ?? ""
        pincode = address.postalCode ?? ""
        lattitude = "\(address.coordinate.latitude)"
        longitude = "\(address.coordinate.longitude)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func pressButtonDelete(_ sender: UIButton) {
        arrSubCategoryDisp.remove(at: sender.tag)
        collViewSubCategory.reloadData()
    }
    @objc func datePickerValue(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        // dateFormatter.dateStyle = DateFormatter.Style.medium
        txtDate.text = dateFormatter.string(from: sender.date)
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtBusinessName.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.businessNameEmpty)
            return false
        }
        else if (txtWillingNessToTravel.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.willingEmpty)
            return false
        }
        else if (txtService.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.categoryEmpty)
            return false
        }
        else if arrSubCategoryDisp.count == 0 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.subCategoryEmpty)
            return false
        }
        else if (txtDate.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.businessDateEmpty)
            return false
        }
        else if (txtPaypalEmail.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return false
        } else if AppHelper.isValidEmail(txtPaypalEmail.text!) == false {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.validEmail)
            return false
        }
        else if (txtDescrption.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.businessDetailEmpty)
            return false
        }
        else if (txtAddress.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.address)
            return false
        }
        return true
    }
    
    // MARK: - Navigation
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if checkValidation() {
            callApiSaveBusinessProfile(categoryId)
        }
    }
    @IBAction func btnAddSubCategoryAction(_ sender: UIButton) {
        viewBackGround.isHidden = false
        viewAddSubCategory.isHidden = false
        arrSubCategoryPicker = arrSubCategory
        for i in 0..<arrSubCategoryDisp.count {
            for j in 0..<arrSubCategoryPicker.count {
                if arrSubCategoryDisp[i].sub_category_name == arrSubCategoryPicker[j].sub_category_name {
                    arrSubCategoryPicker.remove(at: j)
                    break
                }
            }
        }
        pickerViewSubCategory.reloadAllComponents()
        if arrSubCategoryPicker.count > 0 {
            txtSubCategoryView.text = arrSubCategoryPicker[0].sub_category_name
        }
        
    }
    @IBAction func btnSaveSubCategoryAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (txtSubCategoryView.text?.isEmpty)! {
            return
        }
        for i in 0..<arrSubCategoryPicker.count {
            if arrSubCategoryPicker[i].sub_category_name == txtSubCategoryView.text {
                arrSubCategoryDisp.append(arrSubCategoryPicker[i])
            }
        }
        collViewSubCategory.reloadData()
        viewBackGround.isHidden = true
        viewAddSubCategory.isHidden = true
        txtSubCategoryView.text = ""
        collViewSubCategory.isHidden = false
    }
    @IBAction func btnCloseSubCategoryAction(_ sender: UIButton) {
        viewBackGround.isHidden = true
        viewAddSubCategory.isHidden = true
        txtSubCategoryView.text = ""
        self.view.endEditing(true)
    }
    
}
extension EditBusinessProfileVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place addressComponents: \(place.addressComponents)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        let formatedAddre = place.formattedAddress
        //  textFieldLocation.text = formatedAddre
        //  cityName = ""
        //  stateName = ""
        //  countryame = ""
        txtAddress.text = formatedAddre
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    print(field.name)
                //  street_number = field.name
                case kGMSPlaceTypeRoute:
                    print(field.name)
                //route = field.name
                case kGMSPlaceTypeNeighborhood:
                    print(field.name)
                //   neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    print(field.name)
                    //  txtCity.text = field.name
                //   cityName = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    print(field.name)
                    //  txtState.text = field.name
                //   stateName = field.name
                case kGMSPlaceTypeCountry:
                    print(field.name)
                    //  txtCountry.text = field.name
                //  countryame = field.name
                case kGMSPlaceTypePostalCode:
                    print(field.name)
                    //  txtZip.text = field.name
                    pincode = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    print(field.name)
                    // postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        // filterCustom.latLong = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        //  fillAddress()
        lattitude = "\(place.coordinate.latitude)"
        longitude = "\(place.coordinate.longitude)"
        print(place.coordinate)
        dismiss(animated: true) {
            self.setPinOnMapview(place.coordinate)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension EditBusinessProfileVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        setPinOnMapview(coordinate)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let coordinate = mapView.myLocation?.coordinate
        setPinOnMapview(coordinate!)
        return true
    }
}
extension EditBusinessProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubCategoryDisp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as? SubCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrSubCategoryDisp[indexPath.row].sub_category_name
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(self.pressButtonDelete(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}
extension EditBusinessProfileVC: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewSubCategory {
             return arrSubCategoryPicker.count
        }else {
             return arrCategory.count
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewSubCategory {
            return arrSubCategoryPicker[row].sub_category_name
        }else {
            return arrCategory[row].category_name
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewSubCategory {
            txtSubCategoryView.text = arrSubCategoryPicker[row].sub_category_name
        }else {
            txtService.text = arrCategory[row].category_name
            categoryId = arrCategory[row].id
        }
        
    }
}

