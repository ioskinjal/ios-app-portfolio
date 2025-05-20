//
//  BeforeHomeScreenVC.swift
//  XPhorm
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GooglePlaces

class BeforeHomeScreenVC: BaseViewController  {
    
    @IBOutlet weak var lblMyReviews: UILabel!
    
    let datePickerViewEnd =  UIDatePicker()
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
            datePickerViewEnd.setDate(Date(), animated: true)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            txtEndDate.text = formatter.string(from: datePickerViewEnd.date)
            datePickerViewEnd.datePickerMode = .date
            datePickerViewEnd.addTarget(self, action: #selector(dateDiveChanged1(_:)), for: UIControl.Event.valueChanged)
            txtEndDate.inputView = datePickerViewEnd
            txtEndDate.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image: #imageLiteral(resourceName: "dateIcon-1"))
            
        }
    }
    @IBOutlet weak var txtStartDate: UITextField!
        {
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.setDate(Date(), animated: true)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            txtStartDate.text = formatter.string(from: startPickerview.date)
            startPickerview.datePickerMode = .date
            startPickerview.addTarget(self, action: #selector(dateDiveChanged(_:)), for: UIControl.Event.valueChanged)
            txtStartDate.inputView = startPickerview
             txtStartDate.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image: #imageLiteral(resourceName: "dateIcon-1"))
            
        }
    }
    @IBOutlet weak var txtLocation: Textfield!{
        didSet{
            txtLocation.delegate = self
        }
    }
    
    let serviceTypePicker = UIPickerView()
    @IBOutlet weak var txtServiceType: Textfield!{
        didSet{
            serviceTypePicker.delegate = self
            serviceTypePicker.dataSource = self
            txtServiceType.inputView = serviceTypePicker
            txtServiceType.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image: #imageLiteral(resourceName: "downArrrow"))
        }
    }
    @IBOutlet weak var dateStack:UIStackView!{
        didSet{
            dateStack.setRadius(4)
        }
    }
    @IBOutlet weak var viewDate: UIView!{
        didSet{
            viewDate.setRadius(6.0)
            
        }
    }
    @IBOutlet weak var weekStack:UIStackView!{
        didSet{
            weekStack.setRadius(4)
        }
    }
    @IBOutlet weak var btnSignin:UIButton!{
        didSet{
            btnSignin.setRadius(4)
        }
    }
    @IBOutlet weak var myReviewCollectionView:UICollectionView!{
        didSet{
            myReviewCollectionView.register(BeforeHomeScreenCell.nib, forCellWithReuseIdentifier: BeforeHomeScreenCell.identifier)
            myReviewCollectionView.delegate = self
            myReviewCollectionView.dataSource = self
        }
    }
    
    var serviceTypeList = [ServiceTypeList]()
    var selectedType:ServiceTypeList?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var selectedWeek = [String]()
    var reviewList = [TestiMonialList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.lblTitle.text = "Search".localized
        self.tabBarController?.tabBar.isHidden = true
        getServiceTypes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    
    func setupLanguage(){
        self.txtServiceType.placeholder = "Service Type".localized
        self.txtLocation.placeholder = "Location".localized
        self.txtStartDate.placeholder = "Start Date".localized
        self.txtEndDate.placeholder = "End Date".localized
        self.btnSignin.setTitle("Search".localized, for: .normal)
        
    }
    
    @objc func dateDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        txtStartDate.text = formatter.string(from: sender.date)
    }
    
    @objc func dateDiveChanged1(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        datePickerViewEnd.minimumDate = formatter.date(from: txtStartDate.text ?? "")
        txtEndDate.text = formatter.string(from: sender.date)
        
    }
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        //if isValidated(){
        callSearchAPI()
        // }
    }
    
    func callSearchAPI(){
        let nextVC = SearchResultVC.storyboardInstance!
        
        
        let param = ["action":"search",
                     "service_type":selectedType?.id ?? "",
                     "address":txtLocation.text ?? "",
                     "startDate":txtStartDate.text ?? "",
                     "endDate":txtEndDate.text ?? "",
                     "lId":UserData.shared.getLanguage,
                     "locationLat":latitude ?? 0.0,
                     "locationLng":longitude ?? 0.0,
                     "days":""
            ] as [String : Any]
        
        nextVC.param = param
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtServiceType.text?.isEmpty)! {
            ErrorMsg = "Please select service type".localized
        }
        else if (txtLocation.text?.isEmpty)! {
            ErrorMsg = "Please select location".localized
        }else if (txtStartDate.text?.isEmpty)! {
            ErrorMsg = "Please select start date".localized
        }else if (txtEndDate.text?.isEmpty)! {
            ErrorMsg = "Please select end date".localized
        }else if selectedWeek.count == 0{
            ErrorMsg = "Please select days".localized
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title:"Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    
    @IBAction func onClickWeek(_ sender: UIButton) {
        if sender.isSelected{
            
            selectedWeek.remove(object: (sender.titleLabel?.text?.lowercased())!)
            deselected(button: sender)
        }else{
            selected(button: sender)
            selectedWeek.append((sender.titleLabel?.text?.lowercased())!)
            
        }
        print(selectedWeek)
    }
    
    func selected(button: UIButton) {
        
        button.isSelected = true
        button.backgroundColor = UIColor(red: 187.0/255.0, green: 229.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
    }
    
    func deselected(button: UIButton) {
        
        button.isSelected = false
        button.backgroundColor = UIColor.clear
    }
    
    func getServiceTypes(){
        
        let param = ["action":"getServiceType",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: nil, param: param) { (dic) in
            self.serviceTypeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({ServiceTypeList(dic: $0 as! [String:Any])})
            self.serviceTypePicker.reloadAllComponents()
            self.serviceTypePicker.selectedRow(inComponent: 0)
            self.selectedType = self.serviceTypeList[0]
            self.txtServiceType.text = self.selectedType?.categoryName
            self.getTestimonials()
        }
    }
    
    func getTestimonials(){
        let param = ["action":"getTestimonials",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.home(vc: nil, param: param) { (dic) in
            self.reviewList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({TestiMonialList(dic: $0 as! [String:Any])})
            self.myReviewCollectionView.reloadData()
        }
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        if sender.tag == 0{
            self.tabBarController?.selectedIndex = 0
        }else if sender.tag == 1{
            self.tabBarController?.selectedIndex = 1
        }else{
            self.tabBarController?.selectedIndex = 2
        }
    }
    
}
extension BeforeHomeScreenVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reviewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeforeHomeScreenCell.identifier, for: indexPath) as? BeforeHomeScreenCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.mainView.layer.borderColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0).cgColor
        let data:TestiMonialList = reviewList[indexPath.row]
        cell.imgProfile.downLoadImage(url: data.profileImg)
        cell.lbluserName.text = data.userName
        //   cell.lblDate.text = data.da
        cell.lblDesc.text = data.desc
        cell.viewrate.rating = (data.ratting as NSString).doubleValue
         cell.lblDate.isHidden = true
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let width = (self.view.frame.size.width - 41)/2
        
        return CGSize(width: collectionView.frame.size.width/2, height:140)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        
    }
    
}


extension BeforeHomeScreenVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serviceTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
        name = serviceTypeList[row].categoryName
        let str = name
        label.text = str
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = serviceTypeList[row]
        txtServiceType.text = selectedType?.categoryName
    }
}
extension BeforeHomeScreenVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtLocation == textField {
            txtLocation.text = nil
            //https://developers.google.com/places/ios-api/
            //TODO: Display google place picker
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtLocation == textField {
            return false
        }
        else{
            return true
        }
    }
    
}
extension BeforeHomeScreenVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        txtLocation.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
