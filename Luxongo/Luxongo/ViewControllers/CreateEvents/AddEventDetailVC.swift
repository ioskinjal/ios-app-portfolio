//
//  AddEventDetailVC.swift
//  Luxongo
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DocumentPicker{
    var image:UIImage?
    var name:String
    var url:URL?
    var id:Int?
    
    init(url:URL) {
        self.url = url
        self.name = url.absoluteString.components(separatedBy: "/").last ?? ""
        self.image = #imageLiteral(resourceName: "plus")
         
    }
    
    init(name:String,image:UIImage,id:Int) {
        self.name = name
        self.image = image
        self.id = id
    }
}

class AddEventDetailVC: BaseViewController {
    
    //MARK: Variables
    var selectedInvitee:[FollowList]?
     var arrFiles = [DocumentPicker]()
    var selectedImage:UIImage?
    var selectedImageNm:String?
    var selectedCategoryId:String?
    var selectedSubCategoryId:String?
    var selectedEventTypeId:String?
    
    var listOfCategory:[Category] = []
    var listOfSubcategory:[SubCategory] = []
    var listOfEventType:[EventType] = []
    
    var userList = [FollowList](){
        didSet{
            self.tblEmail.reloadData()
        }
    }
    
    //MARK: Properties
    static var storyboardInstance:AddEventDetailVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: AddEventDetailVC.identifier) as! AddEventDetailVC
    }
    
    @IBOutlet weak var consTblEmailHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewImgPick: GreyView!
//    @IBOutlet weak var imgUser: UIImageView!{
//        didSet{
//            self.imgUser.isHidden = true
//            self.imgUser.setRadius(withRatio: 12.0)
//
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMethod(_:)))
//            self.imgUser.isUserInteractionEnabled = true
//            self.imgUser.addGestureRecognizer(tapGesture)
//        }
//    }
    
    
    @IBOutlet weak var btnYes: UIButton!{
        didSet{
            self.btnYes.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            self.btnYes.tag = 1
        }
    }
    @IBOutlet weak var btnNo: UIButton!{
        didSet{
            self.btnNo.tag = 2
        }
    }
    @IBOutlet weak var btnPublic: UIButton!{
        didSet{
            self.btnPublic.tag = 3
            self.btnPrivate.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }
    }
    @IBOutlet weak var btnPrivate: UIButton!{
        didSet{
            self.btnPrivate.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            self.btnPrivate.tag = 4
        }
    }
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!{
        didSet{
            self.imageCollectionView.delegate = self
            self.imageCollectionView.dataSource = self
            self.imageCollectionView.showsHorizontalScrollIndicator = false
            self.imageCollectionView.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var btnContinue: BlackBgButton!
    @IBOutlet weak var lblEventTittle: LabelSemiBold!
    @IBOutlet weak var lblEventPhoto: LabelSemiBold!
    @IBOutlet weak var lblEventType: LabelSemiBold!
    @IBOutlet weak var lblEventCategory: LabelSemiBold!
    @IBOutlet weak var lblSubCategory: LabelSemiBold!
    @IBOutlet weak var lblDescription: LabelSemiBold!
    @IBOutlet weak var lblOnlineEvent: LabelSemiBold!
    @IBOutlet weak var lblListing: LabelSemiBold!
    @IBOutlet weak var lblWebsite: LabelSemiBold!
    
    @IBOutlet weak var tfEventTittle: TextField!
    @IBOutlet weak var tfEventType: TextField!{
        didSet{
            tfEventType.isPreventCaret = true
            tfEventType.delegate = self
            tfEventType.addDropDownArrow()
        }
    }
    @IBOutlet weak var tfCategory: TextField!{
        didSet{
            tfCategory.isPreventCaret = true
            tfCategory.delegate = self
            tfCategory.addDropDownArrow()
        }
    }
    @IBOutlet weak var tfSubCategory: TextField!{
        didSet{
            tfSubCategory.isPreventCaret = true
            tfSubCategory.delegate = self
            tfSubCategory.addDropDownArrow()
        }
    }
    @IBOutlet weak var tfWebsite: TextField!
    
    @IBOutlet weak var textViewMsg: UITextView!{
        didSet{
            textViewMsg.placeholder = "Enter event description"
            textViewMsg.setPlaceHolderFontColor(font: Font.SourceSerifProRegular.size(17.0), color: Color.grey.textPlaceHolder)
        }
    }
    
    @IBOutlet weak var tblEmail: UITableView!{
        didSet{
            tblEmail.register(EmailTC.nib, forCellReuseIdentifier: EmailTC.identifier)
            tblEmail.dataSource = self
            tblEmail.delegate = self
            tblEmail.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var websiteView: GreyView!
    
    @IBOutlet weak var emailView: UIView!{
        didSet{
            //self.emailView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreLoadData()
        AttachmentHandler.shared.imagePickedBlock = { [weak self] (img,imgName) in
            guard let self = self else { return }
            let param:dictionary = [
                "userid":UserData.shared.getUser()?.userid ?? "",
            ]
            API.shared.attachFile(self, param: param, isLoader: false, isUploadImage: true, imageName: imgName, image: img,fileData: nil, fileName: nil ,failer: { (message) in
                print(message)
            }, success: { (messae) in
               
                let dict:[String:Any] = messae["data"] as! [String : Any]
                self.arrFiles.insert(DocumentPicker(name: imgName, image: img,id: dict["id"] as! Int), at: 0)
                self.imageCollectionView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getAttachment()
    }
    
    @IBAction func onClickAddEmail(_ sender: Any) {
        //FIXME: Open contact list for selection
        //pushViewController(SelectInviteeVC.storyboardInstance, animated: true)
        let nextVC = SelectInviteeVC.storyboardInstance
        nextVC.delegateInvitee = self
        if let selectedInvitee = selectedInvitee{
            nextVC.selectedInvitee = selectedInvitee
        }
        present(nextVC, animated: true)
    }
    
    @IBAction func onClickPicImage(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption: .images)
    }
    
    @IBAction func onClickRadioButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            setOnlineType(isYes: true)
        case 2:
            setOnlineType(isYes: false)
        case 3:
            setPrivacyType(isPublic: true)
        case 4:
            setPrivacyType(isPublic: false)
        default:
            break
        }
    }
    
}

//MARK: API Methods
extension AddEventDetailVC{
    func callCategory() {
        API.shared.call(with: .getCategories, viewController: self, param: [:], failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.listOfCategory = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({Category(dictionary: $0 as! [String : Any])})
            if self.listOfCategory.count < 1 {
                self.tfCategory.resignFirstResponder()
            }else{
                //OnClick textField automatically open picker (Only when data came from API)
                self.openCateogoryPickerView()
            }
        }
    }
    
    func callSubCategory() {
        if let selectedCategoryId = self.selectedCategoryId{
            let param = ["category_id":selectedCategoryId]
            API.shared.call(with: .getSubCategories, viewController: self, param: param, failer: { (errStr) in
                print(errStr)
            }) { (response) in
                self.listOfSubcategory = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({SubCategory(dictionary: $0 as! [String : Any])})
                if self.listOfSubcategory.count < 1 {
                    self.tfSubCategory.resignFirstResponder()
                }else{
                    //OnClick textField automatically open picker (Only when data came from API)
                    self.openSubCateogoryPickerView()
                }
            }
        }else{
            
        }
    }
    
    func callEventType() {
        API.shared.call(with: .getEventTypes, viewController: self, param: [:], failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.listOfEventType = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({EventType(dictionary: $0 as! [String : Any])})
            if self.listOfEventType.count < 1 {
                self.tfEventType.resignFirstResponder()
            }else{
                //OnClick textField automatically open picker (Only when data came from API)
                self.openCreateEventPickerView()
            }
        }
    }
    
    
    
}

//MARK: Custom functions
extension AddEventDetailVC{
    
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.consTblEmailHeight.constant = self.tblEmail.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tappedMethod(_ sender:AnyObject){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, attachmentOption:
            .images)
    }
    
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if tfEventTittle.isEmpty {
            ErrorMsg = "Please enter Event tittle"
        }
        else if selectedImage == nil && !((self.parent as? CreateEventsVC)?.isEditMode ?? false){
            ErrorMsg = "Please choose event image"
        }
        else if tfEventType.isEmpty || selectedEventTypeId == nil{
            ErrorMsg = "Please enter event type"
        }
        else if tfCategory.isEmpty || selectedCategoryId == nil{
            ErrorMsg = "Please select category"
        }
        else if tfSubCategory.isEmpty || selectedCategoryId == nil{
            ErrorMsg = "Please select sub-category"
        }
        else if textViewMsg.isEmpty {
            ErrorMsg = "Please enter description"
        }
            //else if ( btnYes.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "y" : "n" ) == "y"{
        else if !websiteView.isHidden && !tfWebsite.text!.isValidURL{
            ErrorMsg = "Please enter valid website URL"
        }
            //else if (btnPublic.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "Public" : "Private" ) == "Private" &&  selectedInvitee == nil{
        else if !emailView.isHidden &&  selectedInvitee == nil{
            ErrorMsg = "Please select at list one email of invitee"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func saveDataWithOutValidate() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            eventData.userid = "\(UserData.shared.getUser()!.userid)"
            eventData.website = ""
            eventData.event_title = tfEventTittle._text
            eventData.event_type_id = selectedSubCategoryId ?? ""
            eventData.category_id = selectedCategoryId ?? ""
            eventData.sub_cat_id = selectedSubCategoryId ?? ""
            eventData.event_desc = textViewMsg._text
            eventData.is_online = ( btnYes.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "y" : "n" )
            eventData.event_privacy = ( btnPublic.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "Public" : "Private" )
            
            eventData.event_type = tfEventType._text
            eventData.category = tfCategory._text
            eventData.sub_cat = tfSubCategory._text
            eventData.event_logo = selectedImage ?? nil
            eventData.event_logo_name = selectedImageNm ?? ""
        }
    }
    
    private func saveData() -> dictionary {
        //        let param:dictionary = [
        //            "userid":UserData.shared.getUser()!.userid,
        //            "website":"https:://www.gogolewd.com",
        //            "event_addr_1":"Ncryped tech. PVT LTD",
        //            "event_addr_2":"",
        //            "event_country_id":"1",
        //            "event_state_id":"2175",
        //            "event_city_id":"16377",
        //            "event_pincode":"360002",
        //            "ticket_ids":"1,2,3",
        //            "organizer_ids":"12,17",
        //            "event_lat":"9494.5464",
        //            "event_long":"5484.548484",
        //        ]
        
        var dic: [String:Any] = [
            "userid": UserData.shared.getUser()!.userid,
            //"website":"",
            "event_title": tfEventTittle._text,
            "event_type_id": selectedEventTypeId!,
            "category_id": selectedCategoryId!,
            "sub_cat_id": selectedSubCategoryId!,
            "event_desc": textViewMsg._text,
            "is_online": ( btnYes.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "y" : "n" ),
            "event_privacy": ( btnPublic.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "Public" : "Private" ),
            
            "event_type": tfEventType._text,
            "category": tfCategory._text,
            "sub_cat": tfSubCategory._text,
        ];
        if let selectedImage = selectedImage{
            dic["event_logo"] = selectedImage
            dic["event_logo_name"] = selectedImageNm ?? "image.jpg"
        }
        
        //if (btnPublic.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "Public" : "Private" ) == "Private", let selectedInvitee = self.selectedInvitee{
        if !emailView.isHidden, let selectedInvitee = self.selectedInvitee{
            let selectedEmails = (selectedInvitee.filter({ $0.isSelected == true })).map({String($0.email)}).joined(separator: ",")
            dic["invite_user_emails"] = selectedEmails
        }
        
        if (btnYes.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "y" : "n" ) == "y"{
            dic["website"] = tfWebsite.text
        }
        
        return dic
    }
    
    func setDataForEvent( eventData: inout CreateEvent ) ->(image: UIImage?, iamgeName: String?) {
        let dic = saveData()
        eventData.userid = dic["userid",""]
        eventData.website = dic["website",""]
        eventData.event_title = dic["event_title",""]
        eventData.event_type_id = dic["event_type_id",""]
        eventData.category_id = dic["category_id",""]
        eventData.sub_cat_id = dic["sub_cat_id",""]
        eventData.event_desc = dic["event_desc",""]
        eventData.is_online = dic["is_online",""]
        eventData.event_privacy = dic["event_privacy",""]
        
        eventData.event_type = dic["event_type",""]
        eventData.category = dic["category",""]
        eventData.sub_cat = dic["sub_cat",""]
        eventData.event_logo = dic["event_logo"] as? UIImage ?? nil
        eventData.event_logo_name = dic["event_logo_name","image.jpg"]
        
        eventData.invite_user_emails = dic["invite_user_emails",""]
        
        return (selectedImage,selectedImageNm)
    }
    
    func setUpPreLoadData() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            tfEventTittle.text = eventData.event_title
            tfEventType.text = eventData.event_type
            tfCategory.text = eventData.category
            tfSubCategory.text = eventData.sub_cat
            selectedEventTypeId = eventData.event_type_id.isBlank ? nil : eventData.event_type_id
            selectedCategoryId = eventData.category_id.isBlank ? nil : eventData.category_id
            selectedSubCategoryId = eventData.sub_cat_id.isBlank ? nil : eventData.sub_cat_id
            textViewMsg.text = eventData.event_desc
            
            if eventData.is_online == "y"{
                btnYes.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                btnNo.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
                websiteView.isHidden = false
                tfWebsite.text = eventData.website
            }else if eventData.is_online == "n"{
                btnYes.setImage( #imageLiteral(resourceName: "radioNormal"), for: .normal)
                btnNo.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                websiteView.isHidden = true
            }else{
                btnYes.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            }
            if eventData.event_privacy == "Public"{
                btnPublic.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                btnPrivate.setImage( #imageLiteral(resourceName: "radioNormal"), for: .normal)
                emailView.isHidden = true
            }else if eventData.event_privacy == "Private"{
                btnPublic.setImage( #imageLiteral(resourceName: "radioNormal"), for: .normal)
                btnPrivate.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                emailView.isHidden = false
            }else{
                btnPrivate.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            }
            
            
            setPreSelectedEmails(emails: eventData.invite_user_emails)
            
            if let eImg = eventData.event_logo{
                self.selectedImage = eImg
               // self.imgUser.image = eImg
                self.selectedImageNm = eventData.event_logo_name
                self.viewImgPick.isHidden = true
               // self.imgUser.isHidden = false
            }else{
                if !eventData.logo.isEmpty && !eventData.logo.contains(string: "no_image"){
                   // self.imgUser.downLoadImage(url: eventData.logo)
                    self.viewImgPick.isHidden = true
                   // self.imgUser.isHidden = false
                }
            }
            
        }
    }
    
    func setPreSelectedEmails(emails: String) {
        if emails.isBlank {return}
        let email = emails.components(separatedBy: ",")
        if email.count > 0{
            selectedInvitee = []
            for _email in email{
                let follow = FollowList(dictionary: ["email": _email])
                follow.isSelected = true
                selectedInvitee?.append(follow)
            }
            tblEmail.reloadData()
        }
    }
    
//    func getAttachment() {
//        AttachmentHandler.shared.imagePickedBlock = { [weak self]  (image, imageName) in
//            guard let self = self else{ return }
//            self.selectedImage = image
//            self.selectedImageNm = imageName
//
//            if let selectedImages = self.selectedImage {
//                let imageCropper = ImageCropper.storyboardInstance
//                imageCropper.cropWidth = 4
//                imageCropper.cropHeight = 3
//                //imageCropper.delegate = self
//                imageCropper.image = selectedImages
//                self.present(imageCropper, animated: false, completion: nil)
//            }
//        }
//    }
    
    func setOnlineType(isYes : Bool) {
        self.btnYes.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        self.btnNo.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        if(isYes) {
            self.btnYes.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        } else {
            self.btnNo.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
        websiteView.isHidden = !isYes
    }
    
    func setPrivacyType(isPublic : Bool) {
        self.btnPublic.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        self.btnPrivate.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        if(isPublic) {
            self.btnPublic.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        } else {
            self.btnPrivate.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
        emailView.isHidden = isPublic
    }
    
    func openCateogoryPickerView() {
        if self.listOfCategory.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfCategory)
            PickerVC.UIDisplayData.title = "Select Category"
            //TODO: Selected Language
            nextVC.selectedLanguage = PickerData(id: "", title: tfCategory._text, value: "")
            nextVC.listOfDataSource = self.listOfCategory.map({ PickerData(id: String($0.id), title: $0.category_name, value: $0.category_desc) })
            present(asPopUpView: nextVC)
        }else{
            callCategory()
        }
    }
    
    func openSubCateogoryPickerView() {
        if self.listOfSubcategory.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfSubCategory)
            PickerVC.UIDisplayData.title = "Select Sub-Category"
            //TODO: Selected Language
            nextVC.selectedLanguage = PickerData(id: "", title: tfSubCategory._text, value: "")
            nextVC.listOfDataSource = self.listOfSubcategory.map({ PickerData(id: String($0.id), title: $0.sub_category_name, value: $0.sub_category_desc) })
            present(asPopUpView: nextVC)
        }else{
            callSubCategory()
        }
    }
    
    func openCreateEventPickerView() {
        if self.listOfEventType.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfEventType)
            PickerVC.UIDisplayData.title = "Select Event type"
            //TODO: Selected Language
            nextVC.selectedLanguage = PickerData(id: "", title: tfEventType._text, value: "")
            nextVC.listOfDataSource = self.listOfEventType.map({ PickerData(id: String($0.id), title: $0.type_name, value: $0.type_desc) })
            present(asPopUpView: nextVC)
        }else{
            callEventType()
        }
    }
    
    
}

//MARK: ImageCropper Class
//extension AddEventDetailVC: ImageCropperDelegate{
//
//    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
//        self.selectedImage = cropImage
//     //   self.imgUser.image = cropImage
//        self.viewImgPick.isHidden = true
//      //  self.imgUser.isHidden = false
//    }
//
//    func didCancel() {
//        print("Cancel Crop Image")
//    }
//
//}



extension AddEventDetailVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === tfEventType{
            openCreateEventPickerView()
            return false
        }else if textField === tfCategory{
            openCateogoryPickerView()
            return false
        }else if textField == tfSubCategory{
            openSubCateogoryPickerView()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfEventType || textField == tfCategory || textField == tfSubCategory{
            return false
        }
        else {
            return true
        }
    }
}


//MARK: PickerView delegate
extension AddEventDetailVC: pickerViewData{
    func fatchData(element: PickerData, textField: UITextField) {
        if textField == tfCategory{
            tfCategory.text = element.title
            //Fatch Id to send to the server
            selectedCategoryId = element.id
            //TODO: reset subcategory
            if !self.tfSubCategory.isEmpty{
                self.selectedSubCategoryId = nil
                self.tfSubCategory.text = nil
                self.listOfSubcategory.removeAll()
            }
            //callSubCategory()
        }else if textField == tfSubCategory{
            tfSubCategory.text = element.title
            //Fatch Id to send to the server
            selectedSubCategoryId = element.id
        }else if textField == tfEventType{
            tfEventType.text = element.title
            //Fatch Id to send to the server
            selectedEventTypeId = element.id
        }
    }
}


extension AddEventDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmailTC.identifier) as? EmailTC else {
            fatalError("Cell can't be dequeue")
        }
        if let selectedInvitee = selectedInvitee{
            cell.cellData = selectedInvitee[indexPath.row]
            cell.indexPath = indexPath
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedInvitee?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        autoDynamicHeight()
    }
    
}

extension AddEventDetailVC: SelectedInvitee{
    func listOfSelectedMails(emails: [FollowList]) {
        print(emails.count)
        selectedInvitee = emails
        if emails.count > 0{
            self.consTblEmailHeight.constant = 10.0
        }
        tblEmail.reloadData()
    }
    
    
}
extension AddEventDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFiles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 26) / 3
        return CGSize(width:width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachedFileCollectionViewCell.identifier, for: indexPath) as? AttachedFileCollectionViewCell else { return UICollectionViewCell() }
        
      //  cell.lblName.isHidden = indexPath.row == self.arrFiles.count
        cell.imgDelete.isHidden = indexPath.row == self.arrFiles.count
        
        if indexPath.row == self.arrFiles.count{
            cell.imgAttachedFile.image = #imageLiteral(resourceName: "imageUpload")
        }else{
            cell.data = arrFiles[indexPath.row]
        }
        
        
        cell.clickImgAttached = { [weak self] in
            guard let self = self else { return }
            if indexPath.row == self.arrFiles.count  {
                AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
            }
        }
        
        
        cell.clickImgDelete = { [weak self] in
            guard let self = self else { return }
            let param:[String:Any] = [
                "userid":UserData.shared.getUser()!.userid,
                "id":self.arrFiles[indexPath.row].id ?? "",
            ]
            API.shared.call(with: .deleteBackImage, viewController: self, param: param, failer: { (error) in
                self.arrFiles.remove(at: indexPath.row)
                self.imageCollectionView.reloadData()
            }, success: { (response) in
                self.arrFiles.remove(at: indexPath.row)
                self.imageCollectionView.reloadData()
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != self.arrFiles.count {
            if let url = arrFiles[indexPath.row].url{
                let webView = WebViewController(url: url.absoluteString,isNavBar:true)
                self.present(UINavigationController(rootViewController: webView), animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionViewHeight.constant = imageCollectionView.contentSize.height
    }
}
