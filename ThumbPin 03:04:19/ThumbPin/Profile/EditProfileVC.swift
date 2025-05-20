//
//  EditProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 20/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Photos

class EditProfileVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtAbnNumber: CustomTextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelLanguagesKnown: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
            imgvwProfile.layer.borderWidth = 2
            imgvwProfile.layer.borderColor = Color.Custom.mainColor.cgColor
        }
    }
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtContact: CustomTextField!
    @IBOutlet weak var txtLanguages: CustomTextField!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnChangeProfileImage: UIButton!{
        didSet {
            btnChangeProfileImage.createCorenerRadiusButton()
            btnChangeProfileImage.backgroundColor = Color.Custom.whiteColor
            btnChangeProfileImage.layer.borderWidth = 2
            btnChangeProfileImage.layer.borderColor = Color.Custom.whiteColor.cgColor
        }
    }
    
    
    static var storyboardInstance:EditProfileVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: EditProfileVC.identifier) as? EditProfileVC
    }
    var userProfile = UserProfile()
    var lattitude = ""
    var longitude = ""
    var pincode = ""
    var imageName = ""
    var imagePicker = UIImagePickerController()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtAddress.delegate = self
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        callApiGetProfile()
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
    func callApiGetProfile() {
        let dictParam = [
            "action": Action.getProfile,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.userProfile = UserProfile(dic: dict)
            self.showDataProfile()
        }
    }
    func callApiSaveProfile(_ image: UIImage,_ imageName:String) {
        let dictParam = [
            "action": Action.editProfile,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "name": txtName.text!,
            "phone": txtContact.text!,
            "aboutus": "",
            "address": txtAddress.text!,
            "addressLat": lattitude,
            "addressLng": longitude,
            "pincode": pincode,
            "languages": txtLanguages.text!,
            "abn_num":txtAbnNumber.text!
        ] as [String : Any]
        ApiCaller.shared.editProfile(vc: self, param: dictParam, withPostImage: image, withPostImageName: imageName, withParamName: "user_image", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.navigationController?.popViewController(animated: true)
            //UserData.shared.setProfileImage(imageUrl: dict["thumb_image_url"] as? String ?? "")
        }
    }
    func showDataProfile() {
        txtName.text = userProfile.profileData.user_name
        txtAddress.text = userProfile.profileData.user_location
        txtEmail.text = userProfile.profileData.user_email
        txtContact.text = userProfile.profileData.user_contact
        txtLanguages.text = userProfile.profileData.languages
        txtAbnNumber.text = userProfile.profileData.abn_num
        if let strUrl = userProfile.profileData.user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
        }
        if let lattitude = userProfile.profileData.latitude.toDouble(),let longitude = userProfile.profileData.longitude.toDouble() {
            let coordiante = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
            setPinOnMapview(coordiante)
        }
        lattitude = userProfile.profileData.latitude
        longitude = userProfile.profileData.longitude
        pincode = userProfile.profileData.pincode
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Edit Profile")
        labelEmail.text = localizedString(key: "Email*")
        labelName.text = localizedString(key: "Name*")
        labelContact.text = localizedString(key: "Contact*")
        labelLanguagesKnown.text = localizedString(key: "Languages Known*")
        labelAddress.text = localizedString(key: "Address*")
        btnSave.setTitle(localizedString(key: "Save"), for: .normal)
        txtAbnNumber.placeholder = localizedString(key: "ABN/ACN number*")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAddress {
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
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
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtEmail.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return false
        }
        else if AppHelper.isValidEmail(txtEmail.text!) == false {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.validEmail)
            return false
        }
        else if (txtName.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.name)
            return false
        }
        else if (txtContact.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.contactno)
            return false
        }
        else if (txtAbnNumber.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.ABNMumber)
            return false
        }
        else if (txtLanguages.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.languages)
            return false
        }
        else if (txtAddress.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.address)
            return false
        }
        return true
    }
    // MARK: - Open Camera
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            AppHelper.showAlertMsg(StringConstants.alert, message: "Camera is not available")
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if checkValidation() {
            callApiSaveProfile(imgvwProfile.image ?? UIImage(), imageName)
        }
    }
    @IBAction func btnChangeProfileImageAction(_ sender: UIButton) {
        let alert = UIAlertController(title: StringConstants.alert, message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
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
extension EditProfileVC: GMSMapViewDelegate {
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
extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
    }
}
extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgvwProfile.image = pickedImage
            
          //  if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
               // let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
               // let asset = result.firstObject
                imageName = picker.getPickedFileName(info: info) ?? "image.jpeg"
                print(imageName)
            //}
        }
        dismiss(animated: true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
// MARK: - CLLocationManagerDelegate
extension EditProfileVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        //locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      /*  guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 5, bearing: 0, viewingAngle: 0)
        setPinOnMapview(location.coordinate)
        locationManager.stopUpdatingLocation()  */
    }
}
