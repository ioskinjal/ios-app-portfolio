//
//  RequestDetailVC.swift
//  ThumbPin
//
//  Created by NCT109 on 29/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class RequestDetailVC: BaseViewController,UITextViewDelegate {
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var tblMaterial: UITableView!{
        didSet{
            tblMaterial.delegate = self
            tblMaterial.dataSource = self
            tblMaterial.rowHeight  = UITableViewAutomaticDimension
            // tblvwProvider.estimatedRowHeight = 60
            tblMaterial.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var lblMaterialName: UILabel!
    @IBOutlet weak var btnPlaceQuote: UIButton!
    @IBOutlet weak var labelPlaceQuote: UILabel!
    @IBOutlet weak var labelWhenStatic: UILabel!
    @IBOutlet weak var labelRequiredAtStatic: UILabel!
    @IBOutlet weak var labelSubCategoryStatic: UILabel!
    @IBOutlet weak var labelCategoryStatic: UILabel!
    @IBOutlet weak var labelBudgetStatic: UILabel!
    @IBOutlet weak var labelServiceDescriptionStatic: UILabel!
    @IBOutlet weak var labelServceTitleStatic: UILabel!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var conTblvwProviderHeight: NSLayoutConstraint!
    @IBOutlet weak var tblvwProvider: UITableView!{
        didSet{
            tblvwProvider.delegate = self
            tblvwProvider.dataSource = self
            tblvwProvider.register(RequestDetailProviderCell.nib, forCellReuseIdentifier: RequestDetailProviderCell.identifier)
            tblvwProvider.rowHeight  = UITableViewAutomaticDimension
           // tblvwProvider.estimatedRowHeight = 60
            tblvwProvider.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var viewProvider: UIView!{
        didSet {
            viewProvider.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var labelCreditQuote: UILabel!
    @IBOutlet weak var txtMessageQuote: UITextView!{
        didSet {
            txtMessageQuote.layer.borderColor = Color.Custom.blackColor.cgColor
            txtMessageQuote.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var txtDeliveryDays: CustomTextField!
    @IBOutlet weak var viewPlaceQuote: UIView!{
        didSet {
            viewPlaceQuote.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var btnFlag: UIButton!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var labelWhen: UILabel!
    @IBOutlet weak var labelRequiredAt: UILabel!
    @IBOutlet weak var labelSubCategory: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelServiceTitle: UILabel!
    @IBOutlet weak var btnQuote: UIButton!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tblvwExtraFields: UITableView!{
        didSet{
            tblvwExtraFields.delegate = self
            tblvwExtraFields.dataSource = self
            tblvwExtraFields.register(TextDetailCell.nib, forCellReuseIdentifier: TextDetailCell.identifier)
            tblvwExtraFields.register(CheckBoxDetailCell.nib, forCellReuseIdentifier: CheckBoxDetailCell.identifier)
            tblvwExtraFields.register(ImageCheckBoxDetailCell.nib, forCellReuseIdentifier: ImageCheckBoxDetailCell.identifier)
            tblvwExtraFields.rowHeight  = UITableViewAutomaticDimension
            tblvwExtraFields.estimatedRowHeight = 44
            tblvwExtraFields.separatorStyle = .none
        }
    }
    @IBOutlet weak var conTblvwExtraHeight: NSLayoutConstraint!
    
    static var storyboardInstance:RequestDetailVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: RequestDetailVC.identifier) as? RequestDetailVC
    }
    var arrSum = [Int]()
    var serviceId = ""
    var requestDetails = RequestDetails()
    var arrExtraFields = [RequestDetails.ServiceDetails.ExtraFields]()
    var creditDetails = CreditDetails()
    var placeholderLabel : UILabel!
    var sum = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlaceHolderLabel()
        if UserData.shared.getUser()!.user_type == "2" {
            btnQuote.isHidden = true
            btnFlag.isHidden = false
        }else {
            btnQuote.isHidden = false
            btnFlag.isHidden = true
        }
        callApiRequesrDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRequestDetails(notification:)), name: .requestDetailReloadNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func onClickPdf(_ sender: UIButton) {
        DispatchQueue.main.async {
            let url = URL.init(fileURLWithPath: self.requestDetails.serviceDetails.pdf_file)
            let pdfData = try? Data.init(contentsOf: url)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "Thumbpin.pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                self.alert(title: "", message: "pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
                self.alert(title: "", message: "Pdf could not be saved")
            }
        }
        
    }
    @objc func handleRequestDetails(notification: Notification) {
        callApiRequesrDetails()
    }
    func setUpPlaceHolderLabel() {
        txtMessageQuote.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 2
        // placeholderLabel.text = "Enter Some Dscription about yourself"
        placeholderLabel.text = localizedString(key: "Message")
        placeholderLabel.font = UIFont(name:"Muli",size:15)        //UIFont.italicSystemFont(ofSize: (textViewSendMsg.font?.pointSize)!)
        
        txtMessageQuote.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMessageQuote.font?.pointSize)! / 2)
        placeholderLabel.frame.size.width = txtMessageQuote.frame.width - 15
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtMessageQuote.text.isEmpty
    }
    func callApiRequesrDetails() {
        let dictParam = [
            "action": Action.getDetails,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            "service_id": serviceId
        ] as [String : Any]
        ApiCaller.shared.requestDetails(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.requestDetails = RequestDetails(dic: dict)
            self.arrExtraFields = self.requestDetails.serviceDetails.arrExtraFields
            self.updateData()
            self.tblvwProvider.reloadData()
        }
    }
    func callApiFlagService(_ flagId: Int) {
        let dictParam = [
            "action": Action.setStatus,
            "lId": UserData.shared.getLanguage,
            "flag_type": "service",
            "user_id": UserData.shared.getUser()!.user_id,
            "flag_id": flagId,
            ] as [String : Any]
        ApiCaller.shared.setFlagStatus(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            if self.requestDetails.serviceDetails.flag_status == "y" {
                self.requestDetails.serviceDetails.flag_status = "n"
                self.btnFlag.setImage(#imageLiteral(resourceName: "Flag"), for: .normal)
            }else {
                self.requestDetails.serviceDetails.flag_status = "y"
                self.btnFlag.setImage(#imageLiteral(resourceName: "Flag-green"), for: .normal)
            }
        }
    }
    func callApiCreditDetails() {
        let dictParam = [
            "action": Action.serviceCreditDetails,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            "service_id": serviceId
            ] as [String : Any]
        ApiCaller.shared.requestDetails(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.creditDetails = CreditDetails(dic: dict["credit_detail"] as? [String : Any] ?? [String : Any]())
            if self.creditDetails.user_credit >= self.creditDetails.required_credit {
                self.viewPlaceQuote.isHidden = false
                self.viewBackGround.isHidden = false
                self.labelCreditQuote.text = "Required Credits: \(self.creditDetails.required_credit)"
            }else {
                self.showCreditAlert()
            }
        }
    }
    func callApiPostServiceQuote() {
        var dictParam = [
            "action": Action.postServiceQuote,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "service_id": serviceId,
            "message": txtMessageQuote.text!,
            "amount": lblTotalAmount.text!,
            "delivery_days":txtDeliveryDays.text!
        ] as [String : Any]
        for i in 0..<requestDetails.serviceDetails.material.count{
            var strKey = "material_id[\(i)]"
            dictParam[strKey] = requestDetails.serviceDetails.material[i].material_id
            strKey = "price[\(i)]"
            dictParam[strKey] = requestDetails.serviceDetails.material[i].price
        }
        ApiCaller.shared.requestDetails(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.viewBackGround.isHidden = true
            self.viewPlaceQuote.isHidden = true
            self.txtMessageQuote.text = ""
            self.lblTotalAmount.text = "0.0"
            self.callApiRequesrDetails()
        }
    }
    func updateData() {
        labelName.text = requestDetails.serviceDetails.name
        labelAddress.text = requestDetails.serviceDetails.service_address
        labelServiceTitle.text = requestDetails.serviceDetails.service_title
        labelDescription.text = requestDetails.serviceDetails.service_detail
        labelBudget.text = requestDetails.serviceDetails.service_budget
        labelCategory.text = requestDetails.serviceDetails.service_category
        labelSubCategory.text = requestDetails.serviceDetails.service_subcategory
        labelRequiredAt.text = requestDetails.serviceDetails.service_address
        labelWhen.text = "\(localizedString(key: "Date:")) \(requestDetails.serviceDetails.service_date)"
        btnStatus.setTitle(requestDetails.serviceDetails.service_status, for: .normal)
        labelTitle.text = requestDetails.serviceDetails.service_title
        for i in 0..<requestDetails.serviceDetails.material.count{
            if lblMaterialName.text == ""{
             lblMaterialName.text = requestDetails.serviceDetails.material[i].material_name
            }else{
                lblMaterialName.text = lblMaterialName.text! + "," + requestDetails.serviceDetails.material[i].material_name
            }
        }
        
        if let strUrl = requestDetails.serviceDetails.userimage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
        }
        if UserData.shared.getUser()!.user_type == "2" {
            btnQuote.isHidden = true
            btnFlag.isHidden = false
            if requestDetails.serviceDetails.showMessageOption == "y" {
                btnSendMessage.isHidden = false
            }else {
                btnSendMessage.isHidden = true
            }
            
            if requestDetails.serviceDetails.flag_status == "n" {
                btnFlag.setImage(#imageLiteral(resourceName: "Flag"), for: .normal)
            }else {
                btnFlag.setImage(#imageLiteral(resourceName: "Flag-green"), for: .normal)
            }
            
            if requestDetails.serviceDetails.service_status == "Open" {
                btnStatus.backgroundColor = Color.Custom.mainColor
                btnStatus.setTitle(localizedString(key: "Send Quote"), for: .normal)
            }else {
                btnStatus.backgroundColor = Color.Custom.darkGrayColor
            }
        }else {
            btnQuote.isHidden = false
            btnFlag.isHidden = true
            btnSendMessage.isHidden = true
            btnQuote.setTitle("+\(requestDetails.numQuote) \(localizedString(key: "Quote"))", for: .normal)
        }
        tblvwExtraFields.reloadData()
        tblMaterial.reloadData()
        self.conTblvwExtraHeight.constant = self.tblvwExtraFields.contentSize.height
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.conTblvwExtraHeight.constant = self.tblvwExtraFields.contentSize.height
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Request Detail")
        labelServceTitleStatic.text = localizedString(key: "Service Title")
        labelServiceDescriptionStatic.text = localizedString(key: "Service Description")
        labelBudgetStatic.text = localizedString(key: "Budget")
        labelCategoryStatic.text = localizedString(key: "Category")
        labelSubCategoryStatic.text = localizedString(key: "Sub Category")
        labelRequiredAtStatic.text = localizedString(key: "Required At")
        labelWhenStatic.text = localizedString(key: "When")
        btnSendMessage.setTitle(localizedString(key: "Send Message"), for: .normal)
        labelPlaceQuote.text = localizedString(key: "Place Quote")
        btnPlaceQuote.setTitle(localizedString(key: "Place Quote"), for: .normal)
        txtDeliveryDays.placeholder = localizedString(key: "Delivery Days*")
      
    }
    func showCreditAlert() {
        let alert = UIAlertController(title: StringConstants.alert, message: MessageConstants.requiredcredit, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.navigationController?.pushViewController(MembershipPlanInfoVC.storyboardInstance!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TextView Change
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtMessageQuote {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    @objc func pressButtonReply(_ sender: UIButton) {
        let vc = ChatVC.storyboardInstance!
        vc.quotesId = requestDetails.serviceDetails.arrProviderList[sender.tag].quotes_id
        vc.serviceID = requestDetails.serviceDetails.requestid
        vc.customerId = requestDetails.serviceDetails.arrProviderList[sender.tag].provider_id
        userIdCustomerBusiness = requestDetails.serviceDetails.arrProviderList[sender.tag].provider_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
        let vc = ChatVC.storyboardInstance!
        vc.quotesId = requestDetails.serviceDetails.user_quote_id
        vc.serviceID = requestDetails.serviceDetails.requestid
        vc.customerId = requestDetails.serviceDetails.userid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFlagAction(_ sender: UIButton) {
        callApiFlagService(requestDetails.serviceDetails.requestid)
    }
    @IBAction func btnStatusAction(_ sender: UIButton) {
        if UserData.shared.getUser()?.user_type == "2"{
        if requestDetails.serviceDetails.service_status == "Open" {
            callApiCreditDetails()
        }
    }
    }
    @IBAction func btnClosePlaceQuoteAction(_ sender: UIButton) {
        viewBackGround.isHidden = true
        viewPlaceQuote.isHidden = true
        lblTotalAmount.text = "0.0"
        txtMessageQuote.text = ""
    }
    @IBAction func btnPlaceQuoteAction(_ sender: UIButton) {
//        if (txtAmountQuote.text?.isEmpty)! {
//            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.budgetRequired)
//            return
//        }
        if txtMessageQuote.text == ""{
            self.alert(title: "", message: "please enter quote message")
        }else if txtDeliveryDays.text == ""{
            self.alert(title: "", message: "please enter delivery days")
        }else if lblTotalAmount.text == "0.0"{
            self.alert(title: "", message: "please enter material data")
        }else{
        callApiPostServiceQuote()
        }
    }
    @IBAction func btnCloseProviderViewAction(_ sender: UIButton) {
        viewProvider.isHidden = true
        viewBackGround.isHidden = true
    }
    @IBAction func btnQuoteAction(_ sender: UIButton) {
        if requestDetails.serviceDetails.arrProviderList.count > 0 {
            viewProvider.isHidden = false
            viewBackGround.isHidden = false
            //tblvwProvider.reloadData()
            self.conTblvwProviderHeight.constant = self.tblvwProvider.contentSize.height
        }
    }
    
}
extension RequestDetailVC: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblvwProvider {
        self.conTblvwProviderHeight.constant = self.tblvwProvider.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMaterial{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddMaterialCell.identifier) as? AddMaterialCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.lblMaterialName.text = requestDetails.serviceDetails.material[indexPath.row].material_name
            cell.lblQuantity.text = requestDetails.serviceDetails.material[indexPath.row].quantity
            cell.txtPrice.delegate = self
            cell.txtPrice.tag = indexPath.row
            cell.txtPrice.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtPrice.layer.borderWidth = 1.0
            cell.selectionStyle = .none
            //cell.txtPrice.addTarget(self, action: #selector(didChangetext(_:)), for: .valueChanged)
            return cell
        }

        else if tableView == tblvwProvider {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestDetailProviderCell.identifier) as? RequestDetailProviderCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelName.text = requestDetails.serviceDetails.arrProviderList[indexPath.row].name
            cell.btnReply.tag = indexPath.row
            cell.btnReply.addTarget(self, action: #selector(self.pressButtonReply(_:)), for: .touchUpInside)
            if let strUrl = requestDetails.serviceDetails.arrProviderList[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                cell.imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
                cell.imgvwProfile.sd_setShowActivityIndicatorView(true)
                cell.imgvwProfile.sd_setIndicatorStyle(.gray)
            }
            cell.selectionStyle = .none
            for i in 0..<requestDetails.serviceDetails.arrProviderList[indexPath.row].material.count{
                if cell.lblMaterials.text == ""{
                    cell.lblMaterials.text = requestDetails.serviceDetails.arrProviderList[indexPath.row].material[i].material_name + "($\(requestDetails.serviceDetails.arrProviderList[indexPath.row].material[i].price))"
                }else{
                    cell.lblMaterials.text = cell.lblMaterials.text! + "," + requestDetails.serviceDetails.arrProviderList[indexPath.row].material[i].material_name + "($\(requestDetails.serviceDetails.arrProviderList[indexPath.row].material[i].price))"
                }
            }
            cell.lblDeliveryDays.text = requestDetails.serviceDetails.arrProviderList[indexPath.row].delivery_days
            return cell
        }
        else if tableView == tblvwExtraFields {
             if arrExtraFields[indexPath.row].fieldName == QuesdtionType.checkboxType.rawValue {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxDetailCell.identifier) as? CheckBoxDetailCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.labelQuestion.text = arrExtraFields[indexPath.row].label
                cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.selectionStyle = .none
                return cell
            }
            else if arrExtraFields[indexPath.row].fieldName == QuesdtionType.imagecheckboxType.rawValue {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageCheckBoxDetailCell.identifier) as? ImageCheckBoxDetailCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.labelName.text = arrExtraFields[indexPath.row].label
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
                cell.selectionStyle = .none
                return cell
            }else  {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextDetailCell.identifier) as? TextDetailCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.labelQuestion.text = arrExtraFields[indexPath.row].label
                cell.labelValue.text = arrExtraFields[indexPath.row].values
                cell.selectionStyle = .none
                return cell
            }
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTypeCell.identifier) as? RadioTypeCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelName.text = arrExtraFields[tableView.tag].arrValueCheckBox[indexPath.row].element_value
            if arrExtraFields[tableView.tag].arrValueCheckBox[indexPath.row].isCheck == "y" {
                cell.imgvwRadio.image = #imageLiteral(resourceName: "Right")
            }else {
                cell.imgvwRadio.image = #imageLiteral(resourceName: "Cross")
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblvwProvider {
            return requestDetails.serviceDetails.arrProviderList.count
        }
        else if tableView == tblvwExtraFields {
            return arrExtraFields.count
        } else if tableView == tblMaterial {
            return requestDetails.serviceDetails.material.count
        }
        else {
            return arrExtraFields[tableView.tag].arrValueCheckBox.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension RequestDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrExtraFields[collectionView.tag].arrValueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCheckBoxColleCell.identifier, for: indexPath) as? ImageCheckBoxColleCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrExtraFields[collectionView.tag].arrValueList[indexPath.row].element_value
        if let strUrl = arrExtraFields[collectionView.tag].arrValueList[indexPath.row].element_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            cell.imgvw.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            cell.imgvw.sd_setShowActivityIndicatorView(true)
            cell.imgvw.sd_setIndicatorStyle(.gray)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}
extension RequestDetailVC:UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        return true
//      }
//
    func textFieldDidEndEditing(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tblMaterial)
        let textFieldIndexPath = self.tblMaterial.indexPathForRow(at: pointInTable)
         sum = Int()
        if textFieldIndexPath?.row == textField.tag{
            if textField.text != ""{
            arrSum.append(Int((textField.text! as NSString).intValue))
                requestDetails.serviceDetails.material[textField.tag].price = textField.text!
            
            }else{
                if arrSum.count > 1{
                for i in 0..<arrSum.count{
                    if textField.tag == i{
                        arrSum.remove(at: i)
                    }
                    
                }
                }else{
                    if arrSum.count != 0{
                    arrSum.removeLast()
                    lblTotalAmount.text = "0"
                    }
                }
            }
            for i in 0..<arrSum.count{
                sum = sum + arrSum[i]
                lblTotalAmount.text = String(sum)
            }
        }
    }
}
