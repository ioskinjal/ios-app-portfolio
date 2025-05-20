//
//  ServiceTitleVC.swift
//  ThumbPin
//
//  Created by NCT109 on 26/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

struct LocationDetails {
    var lattitude = ""
    var longitude = ""
    var postalCode = ""
    var address = ""
}
enum QuesdtionType: String {
    case selectTitle = "selecttitle"
    case textType = "text"
    case imagecheckboxType = "imagecheckbox"
    case selectType = "select"
    case budgetType = "budget"
    case serviceDateType = "servicedate"
    case serviceDescriptionType = "servicedescription"
    case locationType = "location"
    case radioType = "radio"
    case checkboxType = "checkbox"
    case textareaType = "textarea"
    case datepickerType = "datepicker"
    case timepickerType = "timepicker"
}

import UIKit
import GoogleMaps
import GooglePlaces
import MobileCoreServices

var locationDetails = LocationDetails()
var ansQuestionList = AnsQuestionList()
var askQuestionList = AskQuestionList()
class ServiceTitleVC: BaseViewController,UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tblSelectMaterial: UITableView!{
        didSet{
            tblSelectMaterial.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            tblSelectMaterial.dataSource = self
            tblSelectMaterial.delegate = self
            tblSelectMaterial.separatorStyle = .singleLine
            
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tblMaterial: UITableView!{
        didSet{
            tblMaterial.dataSource = self
            tblMaterial.delegate = self
            tblMaterial.separatorStyle = .singleLine
            
        }
    }
    
    @IBOutlet weak var tblMaterialHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblPDF: UILabel!
    @IBOutlet weak var tblErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var tblError: UITableView!{
        didSet{
            tblError.dataSource = self
            tblError.delegate = self
            tblError.separatorStyle = .none
         //   tblError.sectionHeaderHeight = 30
        
        }
    }
    @IBOutlet weak var viewErrorList: UIView!
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var txtQuantity: CustomTextField!
    let pickerMaterialUnit = UIPickerView()
    @IBOutlet weak var txtUnit: CustomTextField!{
        didSet{
            pickerMaterialUnit.delegate = self
            txtUnit.delegate = self
            txtUnit.inputView = pickerMaterialUnit
            
        }
    }
   // let pickerMaterial = UIPickerView()
    @IBOutlet weak var txtSelectMaterial: CustomTextField!{
        didSet{
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.txtSelectMaterial.delegate = self
               // self.pickerMaterial.delegate = self
               // self.txtSelectMaterial.inputView = self.pickerMaterial
            }
            
            
        }
    }
    @IBOutlet weak var stackViewPDF: UIStackView!
    @IBOutlet weak var viewAddMaterial: UIView!
    @IBOutlet weak var tblQuestions: UITableView!{
        didSet{
            tblQuestions.dataSource = self
            tblQuestions.delegate = self
            tblQuestions.sectionFooterHeight = 6
            tblQuestions.separatorStyle = .none
            tblQuestions.sectionHeaderHeight = 40
        }
    }
    @IBOutlet weak var btnUploadPDF: UIButton!
    @IBOutlet weak var btnAddMaterial: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtBudget: CustomTextField!{
        didSet{
            txtBudget.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtPostalCode: CustomTextField!{
        didSet{
            txtPostalCode.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtAddress: CustomTextField!{
        didSet{
            txtAddress.delegate = self
        }
    }
    
    @IBOutlet weak var txtServiceDesc: UITextView!{
        didSet{
        txtServiceDesc.placeholder = "Service Description"
        }
    }
    
    let datePicker:UIDatePicker = UIDatePicker()
    @IBOutlet weak var txtServiceDate: CustomTextField!{
        didSet{
            datePicker.minimumDate = Date()
            datePicker.datePickerMode = .date
            txtServiceDate.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.datePickerValue), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var txtServiceTitle: CustomTextField!
    @IBOutlet weak var lblMarkLocation: UILabel!
    @IBOutlet weak var lblServiceDesc: UILabel!
    
    
    @IBOutlet weak var lblServiceDate: UILabel!
    
    
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    static var storyboardInstance:ServiceTitleVC? {
        return StoryBoard.askQuestionList.instantiateViewController(withIdentifier: ServiceTitleVC.identifier) as? ServiceTitleVC
    }
      var indexOld:Int = -1
    var dictValidation:[String:Any] = [:]
    var dictTemplate:[String:Any] = [:]
     var array = [String]()
    var form_id:String = ""
    var cat_id:String = ""
    var subCat_id:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var subcategory_name:String = ""
    var postal_code:String = ""
    var materialList = MaterialList()
    var materialData = [MaterialList.MaterialData]()
    
    var selectedMaterial:MaterialList.MaterialData?
    
    var materialUnitList = MaterialUnitList()
    var materialUnitData = [MaterialUnitList.MaterialUnitData]()
    var arrSelectedMaterial: NSMutableArray = []
    var selectedMaterialUnit:MaterialUnitList.MaterialUnitData?
    var questionListNew = [QuestionList]()
    var formDataList = [FormsData]()
    private let locationManager = CLLocationManager()
    var pincode = ""
    var arrValidation = [QuestionList]()
    var arrTemplate = [QuestionList]()
    var fileData = Data()
    var fileName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        AttachmentHandler.shared.filePickedBlock
        AttachmentHandler.shared.filePickedBlock = { [weak self] (filePath, fileData) in
            guard let self = self else{ return }
            if fileData != nil {
                self.lblPDF.text = filePath.lastPathComponent
                self.fileName = filePath.lastPathComponent
                self.fileData = fileData!
            }
            else {
                self.alert(title: "", message: "File is not found")
//                Util.showMessageResult(vc: self, success: false, message: Util.localizedString(key: "File data is not found"))
            }
        }
        locationManager.delegate = self
        txtAddress.delegate = self
        locationManager.requestWhenInUseAuthorization()
        callApiGetQuestion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        txtAddress.text = locationDetails.address
        txtPostalCode.text = locationDetails.postalCode
        if let lattitude = locationDetails.lattitude.toDouble(),let longitude = locationDetails.longitude.toDouble() {
            let coordiante = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
            setPinOnMapview(coordiante)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        
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
        self.txtPostalCode.text = pincode
        latitude = "\(address.coordinate.latitude)"
        longitude = "\(address.coordinate.longitude)"
        
         locationDetails = LocationDetails(lattitude: latitude, longitude: longitude, postalCode: txtPostalCode.text!, address: txtAddress.text!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //  NotificationCenter.default.removeObserver(self)
    }
    
    @objc func datePickerValue(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        // dateFormatter.dateStyle = DateFormatter.Style.medium
        txtServiceDate.text = dateFormatter.string(from: sender.date)
    }
    
    
    func callApiGetQuestion() {
        var dictParam = [
            "action": Action.getQuestion,
            "lId": UserData.shared.getLanguage,
            "service_id": subCat_id,
            "service_name": subcategory_name,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        
        if isFromExplore{
            dictParam["lat"] = ""
            dictParam["long"] = ""
            dictParam["user_postal_code"] = ""
        }else{
            dictParam["lat"] = latitude
            dictParam["long"] = longitude
            dictParam["user_postal_code"] = postal_code
        }
        ApiCaller.shared.requestService(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            
            self.questionListNew = ResponseKey.fatchDataAsArray(res: dict, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            self.dictValidation = ["data":self.questionListNew]
            //self.arrValidation = ResponseKey.fatchDataAsArray(res: dict, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            // self.formDataList = self.questionList!.arrFormData
            self.tblQuestions.reloadData()
        }
        self.getMaterialList()
    }
    
    func setUpLang() {
        lblServiceTitle.text = localizedString(key: "Service Title")
        labelTitle.text = localizedString(key: "Request Service")
        lblBudget.text = localizedString(key: "Budget")
        lblServiceDate.text = localizedString(key: "Service Date")
        lblServiceDesc.text = localizedString(key: "Service Description")
        txtServiceTitle.placeholder = localizedString(key: "Service Title")
        txtBudget.placeholder = localizedString(key: "Budget")
        txtServiceDate.placeholder = localizedString(key: "Service Date")
        txtServiceDesc.toolbarPlaceholder = localizedString(key: "Service Description")
        txtAddress.placeholder = localizedString(key: "Address: Mark on the map")
        txtPostalCode.placeholder = localizedString(key: "Postal Code: Mark on the map")
        btnAddMaterial.setTitle(localizedString(key: "Add Material"), for: .normal)
        btnUploadPDF.setTitle(localizedString(key: "Uplaod PDF"), for: .normal)
        
        //btnNext.setTitle("  \(localizedString(key: "Next"))  ", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onclickOk(_ sender: UIButton) {
        viewErrorList.isHidden = true
    }
    
    @IBAction func onClickSendRequest(_ sender: UIButton) {
        //self.view.endEditing(true)
        
        
        if (txtServiceTitle.text?.isEmpty)! {
            self.alert(title: "", message: "please enter service name")
        }else if (txtBudget.text?.isEmpty)! {
            self.alert(title: "", message: "please enter budget")
        }else if (txtServiceDate.text?.isEmpty)! {
            self.alert(title: "", message: "please select service date")
        }else if (txtServiceDesc.text?.isEmpty)! {
            self.alert(title: "", message: "please enter service description")
        }else if arrSelectedMaterial.count == 0{
            self.alert(title: "", message: "please add material")
        }else if lblPDF.text == ""{
            self.alert(title: "", message: "please select pdf file")
        }
        else{
            
            
            if let data = self.dictValidation["data"] as? [QuestionList]{
                for i in data{
                    for j in i.arrFormData{
                        if j.form_element_type == "imagecheckbox"{
                            for k in j.arrElementList{
                                if k.isChecked{
                                    j.isChecked = true
                                    break
                                }
                            }
                        }else if j.form_element_type == "checkbox"{
                            for k in j.arrElementList{
                                if k.isChecked{
                                    j.isChecked = true
                                    break
                                }
                            }
                            
                        }else if j.form_element_type == "select"{
                            for k in j.arrElementList{
                                if k.isChecked{
                                    j.isChecked = true
                                    break
                                }
                            }
                            
                        }else if j.form_element_type == "radio"{
                            for k in j.arrElementList{
                                if k.isChecked{
                                    j.isChecked = true
                                    break
                                }
                            }
                        }else if j.form_element_type == "textbox"{
//                            if j.isChecked{
//                                j.isChecked = true
//                                break
//                            }
                            
                        }else if j.form_element_type == "text"{
//                            if j.isChecked{
//                                j.isChecked = true
//                                break
//                           }
                        }
                    }
                }
            }
            
            
            
            
            if let data = self.dictValidation["data"] as? [QuestionList]{
//                self.dictValidation["categoryName"] = [String]()
                self.dictValidation["dataError"] = [String:[FormsData]]()
                for i in data{
                    if var dic = dictValidation["dataError"] as? [String:[FormsData]]{
                        dic[i.subCategoryName] = [FormsData]()
                        dictValidation["dataError"] = dic
                        for j in i.arrFormData{
                            if j.form_element_type != "text" ||  j.form_element_type == "textarea"{
                            var arr = [FormsData.ElementList]()
                            for k in j.arrElementList{
                                if k.isChecked{
                                    arr.append(k)
                                }
                            }
                            if arr.count == 0{
                                j.isChecked = false
                                
                            }
                            }else{
                                if j.isChecked{
                                    j.isChecked = true
                                }
                            }
                            if !j.isChecked{
                               
                                if var formdata = self.dictValidation["dataError"] as? [String:[FormsData]]{
                                    if var formarr = formdata[i.subCategoryName]{
                                        formarr.append(j)
                                        formdata[i.subCategoryName] = formarr
                                        self.dictValidation["dataError"] = formdata
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
        
       
        var count:Int = 0
        
        if let formdata = self.dictValidation["dataError"] as? [String:[FormsData]]{
            for (key,value) in formdata{
                print(key)
                array.append(key)
                print("***************")
                for i in value{
                    print(i.label)
                    count = count + 1
                }
            }
            
            
            
        }
        
        if count != 0{
            tblError.reloadData()
            tblErrorHeight.constant = tblError.contentSize.height
            self.viewErrorList.isHidden = false
            
        } else{
            if let fileName = fileName, !fileName.isEmpty{
                callApiPostService()
            }
        }
        }
    }
    
    func getMaterialUnit(){
        let dictParam = [
            "action": Action.getMaterialUnit]
        ApiCaller.shared.getMaterialUnit(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.materialUnitList = MaterialUnitList(dic: dict)
            self.materialUnitData = self.materialUnitList.materialUnitData
            self.pickerMaterialUnit.reloadAllComponents()
        }
    }
    
    
    func getMaterialList(){
        let dictParam = [
            "action": Action.getMaterial,
            "category":cat_id]
        ApiCaller.shared.getMaterial(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.materialList = MaterialList(dic: dict)
            self.materialData = self.materialList.materialData
           // self.pickerMaterial.reloadAllComponents()
            self.tblSelectMaterial.reloadData()
           // self.tblSelectMaterial.isHidden = false
        }
        self.getMaterialUnit()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func onClickSubmitMaterial(_ sender: UIButton) {
        if txtSelectMaterial.text == ""{
            self.alert(title: "", message: "please select metrial")
        }else if txtUnit.text == ""{
            self.alert(title: "", message: "please select material unit")
        }else if txtQuantity.text == ""{
            self.alert(title: "", message: "please enter material quantity")
        }else{
        let dict = NSMutableDictionary()
        dict.setValue(txtSelectMaterial.text, forKey: "material_name")
        dict.setValue(selectedMaterialUnit?.material_unit_name, forKey: "unit_name")
        dict.setValue(txtQuantity.text, forKey: "qty")
        dict.setValue(selectedMaterial?.material_id, forKey: "material_id")
        dict.setValue(selectedMaterialUnit?.material_unit_id, forKey: "material_unit_id")
            if selectedMaterial?.material_name != txtSelectMaterial.text{
        dict.setValue("", forKey: "material_id")
            }else{
               dict.setValue(selectedMaterial?.material_id, forKey: "material_id")
            }
        arrSelectedMaterial.add(dict)
        tblMaterial.reloadData()
        self.tblMaterialHeightConst.constant = tblMaterial.contentSize.height
        self.viewAddMaterial.isHidden = true
        self.txtSelectMaterial.text = ""
        self.txtUnit.text = ""
        self.txtQuantity.text = ""
    }
    }
    @IBAction func onClickAddMaterial(_ sender: UIButton) {
        self.viewAddMaterial.isHidden = false
    }
    
//    func clickFunction(){
//        
//        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//        importMenu.delegate = self
//        importMenu.modalPresentationStyle = .formSheet
//        self.present(importMenu, animated: true, completion: nil)
//    }
    
    @IBAction func onClickUploadPdf(_ sender: UIButton) {
        //AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .file)
        //clickFunction()
    }
    // MARK: - Button Action
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewAddMaterial.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAddress {
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtSelectMaterial{
           // for (i,_) in materialList.materialData.enumerated(){
              //  if txtSelectMaterial.text?.contains(materialList.materialData[i].material_name) ?? false  {
            let userEnteredString = textField.text
            let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if newString != ""{
                let predicate=NSPredicate(format: "SELF.material_name CONTAINS[cd] %@", textField.text ?? "")
                let arr=(materialList.materialData as NSArray).filtered(using: predicate)
                if arr.count > 0{
                    
                   // txtSelectMaterial.inputView = pickerMaterial
                    tblSelectMaterial.isHidden = false
                    textField.reloadInputViews()
                  
                }else{
                     tblSelectMaterial.isHidden = true
                  // txtSelectMaterial.inputView = nil
                    textField.reloadInputViews()
                }
            }else{
               // txtSelectMaterial.inputView = nil
                //textField.reloadInputViews()
            }
            //i}
            
        }
        return true
    }
    
//    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        let myURL = url as URL
//        print("import result : \(myURL)")
//        let fileName = URL(fileURLWithPath:myURL.relativeString).deletingPathExtension().lastPathComponent
//        lblPDF.text = fileName + ".pdf"
//        let weatherData = NSData(contentsOf: myURL)
//        print(weatherData ?? "")
//    }
//
//
//    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
    
//
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        print("view was cancelled")
//        dismiss(animated: true, completion: nil)
//    }
}


extension ServiceTitleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMaterial{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MaterialCell.identifier) as? MaterialCell else {
                fatalError("Cell can't be dequeue")
            }
            
            var dict = NSDictionary()
            dict = arrSelectedMaterial[indexPath.row] as! NSDictionary
            cell.lblMaterialName.text = dict.value(forKey: "material_name") as? String
            cell.lblQuantity.text = "\(String(describing: dict.value(forKey: "qty")!)) (\(String(describing: dict.value(forKey: "unit_name")!)))"
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
            
            return cell
        }
        else if tableView == tblError{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            
//            cell.textLabel?.text = arrValidation[indexPath.section].arrFormData[indexPath.row].label
            
            if let data = self.dictValidation["dataError"] as? [String:[FormsData]]
            {
                if let label = data[array[indexPath.section]]{
                cell.textLabel?.text = label[indexPath.row].label
                }
                
//                for (key,value) in data{
//                    print("Headerview \n \(key)")
//
//                    print("***************")
//                    print(value.count)
//
//                    for label in value {
//                     cell.textLabel?.text = label.label
//                    }
//
//                }
                
//                for (_,value) in data{
//                    cell.textLabel?.text = value[indexPath.row].label
//                }
            }else{
                cell.textLabel?.text = ""
            }

            
            return cell
        }else if tableView == tblSelectMaterial{
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel?.text = materialData[indexPath.row].material_name
            return cell
        }
        else{
            
            if questionListNew[indexPath.section].arrFormData[indexPath.row].form_element_type == "imagecheckbox"{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckImageCell.identifier) as? CheckImageCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.formID = questionListNew[indexPath.section].form_id
                cell.lblTitle.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.selectionStyle = .none
                cell.section = indexPath.row
                cell.arrElementList = questionListNew[indexPath.section].arrFormData
                cell.collectionViewImage.reloadData()
                // cell.heightConst.constant = cell.collectionViewImage.contentSize.height
                return cell
            }else if questionListNew[indexPath.section].arrFormData[indexPath.row].form_element_type == "radio"{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRadioCell.identifier) as? AddRadioCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.parentVC = self
                cell.section = indexPath.row
                cell.selectionStyle = .none
                cell.formID = questionListNew[indexPath.section].form_id
                cell.lblTitle.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.elementList = [FormsData]()
                cell.elementList = questionListNew[indexPath.section].arrFormData
                
                cell.tblRadio.reloadData()
                cell.tblHeightConst.constant = cell.tblRadio.contentSize.height
                return cell
            }else if questionListNew[indexPath.section].arrFormData[indexPath.row].form_element_type == "textarea"{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier) as? TextViewCell else {
                    fatalError("Cell can't be dequeue")
                }
                
                cell.selectionStyle = .none
                cell.formId = questionListNew[indexPath.section].form_id
                cell.elementList = questionListNew[indexPath.section].arrFormData
                cell.lblTitle.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.txtView.resetPlaceHolder()
                cell.txtView.placeholder = cell.lblTitle.text
                cell.indexpath = indexPath
                cell.elementList[indexPath.row].isChecked = false
                return cell
            }else if questionListNew[indexPath.section].arrFormData[indexPath.row].form_element_type == "select"{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifier) as? DropDownCell else {
                    fatalError("Cell can't be dequeue")
                }
                 cell.section = indexPath.row
                cell.selectionStyle = .none
                cell.formId = questionListNew[indexPath.section].form_id
                cell.lblTilte.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.elementList = questionListNew[indexPath.section].arrFormData
                cell.txtDropDown.placeholder = cell.lblTilte.text
                
                cell.pickerView.reloadAllComponents()
                return cell
            }else if questionListNew[indexPath.section].arrFormData[indexPath.row].form_element_type == "text"{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier) as? TextFieldCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.selectionStyle = .none
                cell.formId = questionListNew[indexPath.section].form_id
                cell.lblTitle.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.txtContent.placeholder = cell.lblTitle.text
                cell.elementList = questionListNew[indexPath.section].arrFormData
                cell.indexpath = indexPath
                if cell.lblTitle.text == "Zipcode"{
                    cell.txtContent.keyboardType = .numberPad
                }
                return cell
            }
            else{
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCheckboxCell.identifier) as? AddCheckboxCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.section = indexPath.row
                cell.selectionStyle = .none
                 cell.formId = questionListNew[indexPath.section].form_id
                cell.lblTitle.text = questionListNew[indexPath.section].arrFormData[indexPath.row].label
                cell.elementList = questionListNew[indexPath.section].arrFormData
                cell.tblCheck.reloadData()
                cell.tblHeightConst.constant = cell.tblCheck.contentSize.height
                
                return cell
            }
        }
        
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        var dict = NSDictionary()
        dict = arrSelectedMaterial[sender.tag] as! NSDictionary
        arrSelectedMaterial.remove(dict)
        tblMaterial.reloadData()
        self.tblMaterialHeightConst.constant = tblMaterial.contentSize.height
    }
    
    func callApiGetDependentQuestion(_ ansVal: String, index:Int) {
        let dictParam = [
            "action": Action.dependentQue,
            "lId": UserData.shared.getLanguage,
            "service_id": subCat_id,
            "ansVal": ansVal,
            "lat": latitude,
            "long": longitude
            ] as [String : Any]
        ApiCaller.shared.requestService(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            var data = [QuestionList]()
            data = ResponseKey.fatchDataAsArray(res: dict, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            print(data)
//            for (elimantQ,d) in self.questionListNew.enumerated(){
//                for (elimantD,d) in data.enumerated(){
//                    for (elimantF,f) in self.questionListNew[elimantQ].arrFormData.enumerated(){
//                        for (elimantDF,f) in data[elimantD].arrFormData.enumerated(){
//                            if self.questionListNew[elimantQ].subCategoryName == data[elimantQ].subCategoryName{
////                                 if self.questionListNew[elimantQ].arrFormData[elimantF].form_element_type == data[elimantD].arrFormData[l].form_element_type{
//
//                            }
//                        }
//                    }
//                }
//            }
            
          
            if data.count == 0 {
                for i in 0..<self.questionListNew.count{
                    if self.indexOld == index && self.indexOld != -1{
                        self.indexOld = index
                        self.questionListNew[i].arrFormData.remove(at: self.indexOld+1)
                    }else{
                        self.indexOld = index
                    }
                }
            }else{
            for i in 0..<self.questionListNew.count{
                for j in 0..<data.count{
                    if self.questionListNew[i].subCategoryName == data[j].subCategoryName{
//                        for k in 0..<self.questionListNew[i].arrFormData.count{
//                            for l in 0..<data[j].arrFormData.count{
                                //if self.questionListNew[i].arrFormData[k].form_element_type == data[j].arrFormData[l].form_element_type{
                                    var addData = [FormsData]()
                                    addData  = data[j].arrFormData
                                    //addData.append(self.questionListNew[i].arrFormData[k])
                                    //addData.reverse()
                                    //self.questionListNew[i].arrFormData.remove(at: k)
                        
//                        if self.indexOld != index && self.indexOld != -1{
//                                    self.indexOld = index
//                            self.questionListNew[i].arrFormData.remove(at: self.indexOld+1)
//                        }else{
//                            self.indexOld = index
//                        }
                                    self.questionListNew[i].arrFormData.insert(contentsOf: addData, at: index+1)
                                    //self.questionListNew[i].arrFormData = self.questionListNew[i].arrFormData.uniq()
                                    print("InsertAT:\(index)")
                                    break
                                //}//if
//
                           // }//inner most

                        //}

                    }

                }
            }
            }
            self.tblQuestions.reloadData()
            
        }
    }
    
    func callApiPostService() {
        
        var dictParam = [
            "action": Action.postService,
            "lId": "1",
            "serviceId": subCat_id,
            "service_title":txtServiceTitle.text! ,
            "user_id": UserData.shared.getUser()!.user_id,
            "budget": txtBudget.text!,
            "service_date": txtServiceDate.text!,
            "service_time": "",
            "service_hour": "",
            "req_desc":txtServiceDesc.text!,
            "address": txtAddress.text!,
            "pincode": pincode,
            "addressLat": latitude,
            "addressLng": longitude,
            ] as [String : Any]
        for i in 0..<ansQuestionList.arrAns.count {
            if ansQuestionList.arrAns[i].isTemplateValue == "y" {
                dictParam[ansQuestionList.arrAns[i].strKeyData] = ansQuestionList.arrAns[i].strKeyAnsData
            }
        }
        for i in 0..<questionListNew.count{
            let strKey = "form_id[\(i)]"
            dictParam[strKey] = questionListNew[i].form_id
        }
        for i in 0..<arrSelectedMaterial.count{
            var dict = NSDictionary()
            dict = arrSelectedMaterial[i] as! NSDictionary
            var strKey:String = "material[\(i)][material_id]"
            if dict.value(forKey: "material_id") as! String != ""{
             dictParam[strKey] = dict.value(forKey: "material_id")
            }else{
                dictParam[strKey] = dict.value(forKey: "material_name")
            }
            strKey = "material[\(i)][material_unit_id]"
            dictParam[strKey] = dict["material_unit_id"]
            strKey = "material[\(i)][quantity]"
            dictParam[strKey] = dict.value(forKey: "qty")as? String
        }
        
        ApiCaller.shared.postRequestService(vc: self, param: dictParam, withFileData: self.fileData, withFileName: fileName!, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.shoWMessage(dict["message"] as? String ?? "")
        }
    }
    
    func shoWMessage(_ message: String) {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: message, preferredStyle: .alert)
        //  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "Ok"), style: .default, handler: { _ in
            if self.navigationController!.viewControllers.count > 1 {
                let vc = self.navigationController!.viewControllers[1]
                appDelegate?.isLoadMyRequestView = "1"
                _ =  self.navigationController!.popToViewController(vc, animated: false)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblMaterial{
            return 1
        }
        if tableView == tblSelectMaterial{
            return 1
        }
        else if tableView == tblError{
            if let data = self.dictValidation["dataError"] as? [String:[FormsData]]{
                return data.keys.count
            }else{
                return 0
            }
        }else{
            return questionListNew.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMaterial{
            return arrSelectedMaterial.count
        }
        else if tableView == tblError{
            if let formdata = self.dictValidation["dataError"] as? [String:[FormsData]]{
                
            
                return formdata[array[section]]?.count ?? 0
//                for (key,value) in formdata{
//                    print("row count")
//                    print(key)
//
//                    print("***************")
//                      print(value.count)
//                    return value.count
////                    for i in value{
////                        print(i.label)
////                    }
//                }
                
//                for (key, _) in formdata{
//                    if let returnValue = formdata[key]{
//                        return returnValue.count
//                    }else{
//                        return 0
//                    }
//                }
            }else{
                return 0
            }
            
        }
        else if tableView == tblSelectMaterial{
            return materialData.count
        }
        else{
            return questionListNew[section].arrFormData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSelectMaterial{
            selectedMaterial = materialData[indexPath.row]
            txtSelectMaterial.text = materialData[indexPath.row].material_name
        }
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: Indellf\exPath) {
    //        if arrSelectedServiceList.count != 0{
    //        arrSelectedServiceList.remove(at: indexPath.row)
    //        arrServiceList[indexPath.row].isChecked = false
    //        }
    //        tblCategory.reloadData()
    //    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblMaterial{
            tblMaterialHeightConst.constant = tblMaterial.contentSize.height
        }
        else if tableView == tblSelectMaterial{
            tblMaterialHeightConst.constant = tblMaterial.contentSize.height
        }
        else if tableView == tblError{
            tblErrorHeight.constant = self.tblError.contentSize.height
        }
        else{
            tblHeightConst.constant = self.tblQuestions.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblMaterial{
            return ""
        }
        if tableView == tblSelectMaterial{
            return ""
        }
        else if tableView == tblError{
            
            if (self.dictValidation["dataError"] as? [String:[FormsData]]) != nil{
                return array[section]
//                for (key,value) in data{
//                    print("Header \n \(key)")
//
//                    print("***************")
//                    print(value.count)
//                    return key
//                                        for i in value{
//                                            print(i.label)
//                                        }
//                }
//                
//                for (key,_) in data{
//                    return key
//                }
            }else{
                return ""
            }
        }else{
            return  questionListNew[section].subCategoryName
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblMaterial{
            return nil
        }
        if tableView == tblSelectMaterial{
            return nil
        }
        else if tableView == tblError{
            let vw:UIView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
                view.backgroundColor = .white
                return view
            }()
            
            let label:UILabel = {
                let lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.textAlignment = .center
                lbl.font = MuliFont.light(with: 16.0)
                if (self.dictValidation["dataError"] as? [String:[FormsData]]) != nil{
                    lbl.text = array[section]
//                    for (key,value) in data{
//                        print("Headerview \n \(key)")
//
//                        print("***************")
//                        print(value.count)
//                        lbl.text = key
//
//                    }
//
////                    for (key,_) in data{
////                        lbl.text = key
////                    }
               }
                return lbl
            }()
            
            let bottomView:UIView = {
                let view = UIView()
                view.backgroundColor = Color.Custom.mainColor
                view.layer.cornerRadius = 3.0
                view.layer.masksToBounds = true
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: 4).isActive = true
                return view
            }()
            
            
            let stackView:UIStackView = {
                let stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.axis = .vertical
                stack.spacing = 0
                stack.alignment = .center
                return stack
            }()
            
            
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(bottomView)
            
            
            vw.addSubview(stackView)
            NSLayoutConstraint.activate([
                
                bottomView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                
                stackView.topAnchor.constraint(equalTo: vw.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: vw.bottomAnchor,constant: 8),
                stackView.trailingAnchor.constraint(equalTo: vw.trailingAnchor,constant: 8),
                stackView.leadingAnchor.constraint(equalTo: vw.leadingAnchor,constant: 8),
                ])
            
            
            
            //        let label = UILabel()
            //        label.frame(forAlignmentRect: CGRect(x: self.view.bounds.size.width/2, y: 0, width: vw.frame.size.width, height: 30))
            //        label.textAlignment = .center
            //        label.text = questionList[section].subCategoryName
            //        label.textColor = Color.Custom.blackColor
            //        vw.addSubview(label)
            //        let view = UIView()
            //        view.frame(forAlignmentRect: CGRect(x: label.frame.origin.x, y: label.frame.origin.y + label.frame.size.height + 3, width: label.frame.size.width, height: 3.0))
            //        view.backgroundColor = Color.Custom.mainColor
            //        view.layer.cornerRadius = 3.0
            //        view.layer.masksToBounds = true
            //        vw.addSubview(view)
            return vw
        }else{
            let vw:UIView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
                view.backgroundColor = .white
                return view
            }()
            
            let label:UILabel = {
                let lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.textAlignment = .center
                lbl.font = MuliFont.light(with: 18.0)
                lbl.text = questionListNew[section].subCategoryName
                return lbl
            }()
            
            let bottomView:UIView = {
                let view = UIView()
                view.backgroundColor = Color.Custom.mainColor
                view.layer.cornerRadius = 3.0
                view.layer.masksToBounds = true
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: 4).isActive = true
                return view
            }()
            
            
            let stackView:UIStackView = {
                let stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.axis = .vertical
                stack.spacing = 0
                stack.alignment = .center
                return stack
            }()
            
            
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(bottomView)
            
            
            vw.addSubview(stackView)
            NSLayoutConstraint.activate([
                
                bottomView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                
                stackView.topAnchor.constraint(equalTo: vw.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: vw.bottomAnchor,constant: 8),
                stackView.trailingAnchor.constraint(equalTo: vw.trailingAnchor,constant: 8),
                stackView.leadingAnchor.constraint(equalTo: vw.leadingAnchor,constant: 8),
                ])
            
            
            
            //        let label = UILabel()
            //        label.frame(forAlignmentRect: CGRect(x: self.view.bounds.size.width/2, y: 0, width: vw.frame.size.width, height: 30))
            //        label.textAlignment = .center
            //        label.text = questionList[section].subCategoryName
            //        label.textColor = Color.Custom.blackColor
            //        vw.addSubview(label)
            //        let view = UIView()
            //        view.frame(forAlignmentRect: CGRect(x: label.frame.origin.x, y: label.frame.origin.y + label.frame.size.height + 3, width: label.frame.size.width, height: 3.0))
            //        view.backgroundColor = Color.Custom.mainColor
            //        view.layer.cornerRadius = 3.0
            //        view.layer.masksToBounds = true
            //        vw.addSubview(view)
            return vw
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblMaterial{
            return 0
        }
        if tableView == tblSelectMaterial{
            return 0
        }
        else if tableView == tblError{
            return 30
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblQuestions{
            let vw:UIView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 6))
                view.backgroundColor = Color.Custom.mainColor
                return view
            }()

            return vw
        }else{
            return nil
        }
    }
    
    
}
// MARK: - CLLocationManagerDelegate
extension ServiceTitleVC: CLLocationManagerDelegate {
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
extension ServiceTitleVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        setPinOnMapview(coordinate)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let coordinate = mapView.myLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        setPinOnMapview(coordinate)
       
        return true
    }
}
extension ServiceTitleVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place addressComponents: \(String(describing: place.addressComponents))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
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
                    locationDetails = LocationDetails(lattitude: (place.coordinate.latitude as? String ?? ""), longitude: (place.coordinate.longitude as? String ?? ""), postalCode: field.name, address: txtAddress.text!)
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
        latitude = "\(place.coordinate.latitude)"
        longitude = "\(place.coordinate.longitude)"
        
        txtPostalCode.text = pincode
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
extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}
extension ServiceTitleVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == pickerMaterial{
//            return materialData.count
//        }else{
            return materialUnitData.count
        //}
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        if pickerView == pickerMaterial{
//            var label: UILabel
//            if let view = view as? UILabel { label = view }
//            else { label = UILabel() }
//            label.textAlignment = .center
//            label.adjustsFontSizeToFitWidth = true
//            label.minimumScaleFactor = 0.5
//            var name = String()
//            name = materialData[row].material_name
//            let str = name
//            label.text = str
//
//            return label
//        }else{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            var name = String()
            name = materialUnitData[row].material_unit_name
            let str = name
            label.text = str
            
            return label
       // }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == pickerMaterial{
//            selectedMaterial = materialData[row]
//            txtSelectMaterial.text = materialData[row].material_name
//        }else{
            selectedMaterialUnit = materialUnitData[row]
            txtUnit.text = materialUnitData[row].material_unit_name
       // }
        
    }
    
}
