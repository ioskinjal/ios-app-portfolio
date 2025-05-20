//
//  ChatVC.swift
//  ThumbPin
//
//  Created by NCT109 on 19/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import ReverseExtension
import MobileCoreServices
import Photos

class ChatVC: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var lblDeliveryDays: UILabel!
    @IBOutlet weak var lblMaterials: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnAttachement: UIButton!
    @IBOutlet weak var tblvwChat: UITableView!{
        didSet{
            tblvwChat.delegate = self
            tblvwChat.dataSource = self
            tblvwChat.register(SenderChatCell.nib, forCellReuseIdentifier: SenderChatCell.identifier)
            tblvwChat.register(ReceiverChatCell.nib, forCellReuseIdentifier: ReceiverChatCell.identifier)
            tblvwChat.rowHeight  = UITableViewAutomaticDimension
            tblvwChat.estimatedRowHeight = 60
            tblvwChat.tableFooterView = UIView()
            tblvwChat.separatorStyle = .none
        }
    }
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewProvider: UIView!
    @IBOutlet weak var labelPriceProvider: UILabel!
    @IBOutlet weak var labelNameProvider: UILabel!
    @IBOutlet weak var viewCustomerDetails: UIView!
    @IBOutlet weak var btnLeaveReviewCustomer: UIButton!
    @IBOutlet weak var btnHireCustomer: UIButton!
    @IBOutlet weak var labelPriceCustomer: UILabel!
    @IBOutlet weak var labelNameCustomer: UILabel!
    
    static var storyboardInstance:ChatVC? {
        return StoryBoard.chat.instantiateViewController(withIdentifier: ChatVC.identifier) as? ChatVC
    }
    
    var provider_id = ""
    var quotesId = ""
    var serviceID = 0
    var allMsgList = AllMessageList()
    var customerId = ""
    var providerDetails = ProviderDetailsChat()
    var customerDetails = CustomerDetails()
    var arrMessages = [Messages]()
    var placeholderLabel : UILabel!
    var pageNo = 1
    var sendMsgReturnData = SendMsgReturnData()
    var fileData = Data()
    var fileName = ""
    var imagePicker = UIImagePickerController()
    var imageName = ""
    var downloadFiletag = Int()
    var mesageList = [ChatCls.MessageList]()
    var msgObj: ChatCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomerDetails.isHidden = true
        viewDescription.isHidden = true
        viewProvider.isHidden = true
        btnLeaveReviewCustomer.isHidden = true
        btnLeaveReviewCustomer.setTitle(localizedString(key: "Leave Review"), for: .normal)
        setUpPlaceHolderLabel()
        setUPTableView()
        if isFromMessages{
            callGetAllMessages()
        }else{
            pageNo = 1
            callApiGetAllMessages()
        }
        txtMessage.delegate = self
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.tapToShowProfile))
        labelNameCustomer.isUserInteractionEnabled = true
        labelNameCustomer.addGestureRecognizer(tap)
        let tapPro = UITapGestureRecognizer(target: self, action: #selector(ChatVC.tapToShowProfileProvider))
        labelNameProvider.isUserInteractionEnabled = true
        labelNameProvider.addGestureRecognizer(tapPro)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatReloadNotification(notification:)), name: .chatReloadNotifi, object: nil)
        if !isFromMessages{
        if UserData.shared.getUser()!.user_type == "1" {
            callApiProviderDetails()
        }else {
            callApiCustomerDetail()
        }
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func chatReloadNotification(notification: Notification) {
        if isFromMessages{
            callGetAllMessages()
        }else{
        pageNo = 1
        callApiGetAllMessages()
        }
    }
    
    func callGetAllMessages(){
        let param:[String:Any] = ["user_id":UserData.shared.getUser()!.user_id,
                                  "provider_id":provider_id,
                                  "action":"getAllMessage"]
        
        ApiCaller.shared.getAllMessagesList(vc: self, param: param) { (dic) in
            print(dic)
            self.msgObj = ChatCls(dictionary: dic)
            if self.mesageList.count > 0{
                self.mesageList += self.msgObj!.notificationList
            }
            else{
                self.mesageList = self.msgObj!.notificationList
            }
            if self.mesageList.count != 0 {
                self.tblvwChat.reloadData()
            }else{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.tblvwChat.backgroundView = bgImage
            }
        }
    }
    
    func setUpPlaceHolderLabel() {
        txtMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 2
        // placeholderLabel.text = "Enter Some Dscription about yourself"
        placeholderLabel.text = localizedString(key: "Type your message...")
        placeholderLabel.font = UIFont(name:"Muli",size:15)        //UIFont.italicSystemFont(ofSize: (textViewSendMsg.font?.pointSize)!)
        
        txtMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMessage.font?.pointSize)! / 2)
        placeholderLabel.frame.size.width = txtMessage.frame.width - 5
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtMessage.text.isEmpty
    }
    // MARK: - TextView Change
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtMessage {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtMessage {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            if numberOfChars > 0 {
                btnSend.isHidden = false
            }else {
                btnSend.isHidden = true
            }
        }
        return true
    }

    func setUPTableView() {
        tblvwChat.re.delegate = self
        
        tblvwChat.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
            //self.loadMoreData()
        }
        tblvwChat.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
    }
    func callApiGetAllMessages() {
        let dictParam = [
            "action": Action.getAllMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "quotes_id": quotesId,
            "service_id": serviceID,
            "page": pageNo,
        ] as [String : Any]
        ApiCaller.shared.getAllMessages(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.allMsgList = AllMessageList(dic: dict)
            if self.pageNo > 1 {
                self.arrMessages.append(contentsOf: self.allMsgList.arrMessages)
            }else {
                self.arrMessages.removeAll()
                self.arrMessages = self.allMsgList.arrMessages
            }
            self.tblvwChat.reloadData()
        }
    }
    func callApiCustomerDetail() {
        let dictParam = [
            "action": Action.getCustomerDetails,
            "lId": UserData.shared.getLanguage,
            "service_id": serviceID,
            "customer_id": customerId
        ] as [String : Any]
        ApiCaller.shared.getCustomerDetail(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.customerDetails = CustomerDetails(dic: dict["customer_details"] as? [String : Any] ?? [String:Any]())
            self.showCustomerDetails()
        }
    }
    func callApiProviderDetails() {
        let dictParam = [
            "action": Action.getProviderDetails,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "quotes_id": quotesId,
            "service_id": serviceID,
            "provider_id": customerId
            ] as [String : Any]
        ApiCaller.shared.getProviderDetail(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            //self.allMsgList = AllMessageList(dic: dict)
            self.providerDetails = ProviderDetailsChat(dic: dict)
            self.showProviderDetails()
        }
    }
    func callApiSendMessage() {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "quotes_id": quotesId,
            "rmessage": txtMessage.text!,
            "service_id": serviceID,
        ] as [String : Any]
        ApiCaller.shared.getAllMessages(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.txtMessage.text = ""
            self.sendMsgReturnData = SendMsgReturnData(dic: dict)
            print(self.sendMsgReturnData.message)
            self.arrMessages.insert(self.sendMsgReturnData.retuMessages, at: 0)
            self.tblvwChat.reloadData()
        }
    }
    
    func callSendMessage() {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "receiverid": provider_id,
            "rmessage": txtMessage.text!,
            "mtype": "m",
            ] as [String : Any]
        ApiCaller.shared.getAllMessagesList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.txtMessage.text = ""
            self.mesageList = [ChatCls.MessageList]()
            self.msgObj = nil
            self.callGetAllMessages()
           // let sendData = ChatCls.MessageList(dictionary: dict)
           // self.mesageList.insert(sendData, at: 0)
           // self.tblvwChat.reloadData()
        }
    }
    
    func callSendMessageAttachementImage(attachMent: UIImage,fileName: String) {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "receiverid": provider_id,
            "rmessage": txtMessage.text!,
            "mtype": "f",
            ] as [String : Any]
        ApiCaller.shared.uploadDocumentImage1(vc: self, param: dictParam, withPostImage: attachMent, withPostImageName: fileName, withParamName: "fileUpd", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.mesageList = [ChatCls.MessageList]()
            self.msgObj = nil
             self.callGetAllMessages()
        }
    }
    
    func callApiSendMessageAttachementImage(attachMent: UIImage,fileName: String) {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "quotes_id": quotesId,
            "rmessage": txtMessage.text!,
            "service_id": serviceID
        ] as [String : Any]
        ApiCaller.shared.uploadDocumentImage(vc: self, param: dictParam, withPostImage: attachMent, withPostImageName: fileName, withParamName: "fileUpd", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.txtMessage.text = ""
            self.sendMsgReturnData = SendMsgReturnData(dic: dict)
            print(self.sendMsgReturnData.message)
            self.arrMessages.insert(self.sendMsgReturnData.retuMessages, at: 0)
            self.tblvwChat.reloadData()
        }
    }
    
    func callSendMessageAttachementFile(attachMent: Data,fileName: String) {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "receiverid": provider_id,
            "rmessage": txtMessage.text!,
            "mtype": "f",
            ] as [String : Any]
        ApiCaller.shared.uploadDocumentFile1(vc: self, param: dictParam, fileData: attachMent, withPostImageName: fileName, withParamName: "fileUpd", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.txtMessage.text = ""
          //  let sendData = ChatCls.MessageList(dictionary: dict)
            //self.mesageList.insert(sendData, at: 0)
            self.mesageList = [ChatCls.MessageList]()
            self.msgObj = nil
            self.callGetAllMessages()
            //self.tblvwChat.reloadData()
        }
    }
    
    
    func callApiSendMessageAttachementFile(attachMent: Data,fileName: String) {
        let dictParam = [
            "action": Action.sendMessage,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "userType": UserData.shared.getUser()!.user_type,
            "quotes_id": quotesId,
            "rmessage": txtMessage.text!,
            "service_id": serviceID
        ] as [String : Any]
        ApiCaller.shared.uploadDocumentFile(vc: self, param: dictParam, fileData: attachMent, withPostImageName: fileName, withParamName: "fileUpd", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.txtMessage.text = ""
            self.sendMsgReturnData = SendMsgReturnData(dic: dict)
            print(self.sendMsgReturnData.message)
            self.arrMessages.insert(self.sendMsgReturnData.retuMessages, at: 0)
            self.tblvwChat.reloadData()
        }
    }
    func callApiHireProvider() {
        let dictParam = [
            "action": Action.hireProvider,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "quotes_id": quotesId,
            "service_id": serviceID,
            "provider_id": customerId
            ] as [String : Any]
        ApiCaller.shared.getProviderDetail(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.btnHireCustomer.setTitle(localizedString(key: "Hired"), for: .normal)
            self.btnHireCustomer.backgroundColor = Color.Custom.lightGrayColor
            self.providerDetails.providerDetails.isHired = "y"
            self.btnLeaveReviewCustomer.isHidden = false
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
        }
    }
    func downloadFile(_ strUrl: String) {
        guard let url = URL(string: strUrl) else { return }
        AppHelper.showLoadingView()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                AppHelper.hideLoadingView()
            }
            guard let data = data, error == nil else { return }
            
            let fileManager = FileManager.default
            do {
                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let fileURL = documentDirectory.appendingPathComponent(self.arrMessages[self.downloadFiletag].msg)
                try data.write(to: fileURL)
                self.copyFileToCloud()
            } catch {
                print(error)
            }
    
        }.resume()
    }
    func showProviderDetails() {
        viewProvider.isHidden = true
        viewCustomerDetails.isHidden = false
        viewDescription.isHidden = true
        labelNameCustomer.text = providerDetails.providerDetails.provider_name
        labelPriceCustomer.text = providerDetails.providerDetails.service_budget
        lblAvgRating.text = String(format: "%.1f",(providerDetails.providerDetails.avg_star_rating as NSString).floatValue)
        if providerDetails.providerDetails.isHired == "y" {
            btnHireCustomer.isHidden = false
            btnHireCustomer.setTitle(localizedString(key: "Hired"), for: .normal)
            btnHireCustomer.backgroundColor = Color.Custom.lightGrayColor
            
            if providerDetails.is_review == "n" {
                btnLeaveReviewCustomer.isHidden = false
            }else {
                btnLeaveReviewCustomer.isHidden = true
            }
        }else {
            if providerDetails.providerDetails.service_status == "y" {
                btnHireCustomer.isHidden = true
                btnLeaveReviewCustomer.isHidden = true
            }else {
                btnHireCustomer.isHidden = false
                btnHireCustomer.setTitle(localizedString(key: "Hire"), for: .normal)
                btnHireCustomer.backgroundColor = Color.Custom.mainColor
            }
        }
    }
    func showCustomerDetails() {
        viewProvider.isHidden = false
        viewCustomerDetails.isHidden = true
        viewDescription.isHidden = false
        labelNameProvider.text = customerDetails.customer_name
        labelPriceProvider.text = customerDetails.budget
        labelDescription.text = customerDetails.service_title
        
        for i in 0..<customerDetails.material.count{
            if lblMaterials.text == ""{
                lblMaterials.text = "\(customerDetails.material[i].material_name)(\(customerDetails.material[i].quantity) kg)"
            }else{
                lblMaterials.text = lblMaterials.text! + "," + "\(customerDetails.material[i].material_name)(\(customerDetails.material[i].quantity) kg)"
            }
            lblDeliveryDays.text = customerDetails.delivery_days
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Chat")
    }
    // MARK: - Profile Navigation
    @objc func tapToShowProfile(sender:UITapGestureRecognizer) {
        print("tap working")
        let vc = MyProfileVC.storyboardInstance!
        vc.userIdFromCustomer = customerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapToShowProfileProvider(sender:UITapGestureRecognizer) {
        let vc = ProfileVC.storyboardInstance!
        vc.userIdFromProvider = customerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - CopyToiCloud
    func copyFileToCloud() {
        if isCloudEnabled() {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            // deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear all files in iCloud Doc Dir
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                do {
                    if fileManager.isUbiquitousItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)) {
                        try fileManager.removeItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    }
                    try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    //try fileManager.setUbiquitous(true, itemAt: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), destinationURL: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    /* if !fileManager.isUbiquitousItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)) {
                     
                     }*/
                    DispatchQueue.main.async {
                        AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.downloadFile)
                    }
                    clearAllFile()
                    print("Copied to iCloud")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    // Return true if iCloud is enabled
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    func clearAllFile() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openFileManager() {
        let documentType: NSArray = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
        let importMenu = UIDocumentMenuViewController(documentTypes: documentType as! [String], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    // MARK: - Open Gallery
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func pressButtonDownloadFile(_ sender: UIButton) {
        if arrMessages[sender.tag].mtype == "f" {
            downloadFiletag = sender.tag
            downloadFile(arrMessages[sender.tag].url)
        }
    }

    // MARK: - Button Action
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
        if txtMessage.text.isEmpty {
            return
        }
        if isFromMessages{
            callSendMessage()
        }else{
        callApiSendMessage()
        }
    }
    @IBAction func btnAttachementAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: StringConstants.alert, message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Open Files", style: .default , handler:{ (UIAlertAction)in
            self.openFileManager()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    @IBAction func btnHireAction(_ sender: UIButton) {
        if providerDetails.providerDetails.isHired == "n" {
           // callApiHireProvider()
            callApiPaymentURL()
        }
    }
    @IBAction func btnLeaveReviewAction(_ sender: UIButton) {
        let vc = GiveReviewVC.storyboardInstance!
        vc.providerId = customerId
        vc.serviceID = serviceID
        self.navigationController?.pushViewController(vc, animated: true)        
    }
    
    func callApiPaymentURL() {
        let array = providerDetails.providerDetails.service_budget.components(separatedBy: "$")
        let amount = array[1]
        let dictParam = [
            "action": Action.pre_paypal,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "requestid":providerDetails.providerDetails.request_id,
            "amount":amount,
            "qid":quotesId,
            "providerid":customerId
            ] as [String : Any]
        ApiCaller.shared.getPrePaymentUrl(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            let paypalUrl = GetPrePaypalURL(dic: dict["data"] as? [String : Any] ?? [String:Any]())
            if !paypalUrl.paypal_url.isEmpty {
                let vc = PaypalPaymentVC.storyboardInstance!
                isfromChat = true
                vc.papal_url = paypalUrl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if isFromMessages{
            if mesageList[indexPath.row].sender_id == UserData.shared.getUser()!.user_id {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatCell.identifier) as? SenderChatCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.labelTime.text = String.getFormattedDate(string: mesageList[indexPath.row].time ?? "", formatterPass: "yyyy-MM-dd HH:mm:ss", formatterGet: "hh:mm a")
                cell.labelMessage.text = mesageList[indexPath.row].msg
                if mesageList[indexPath.row].mtype == "m" {
                    cell.imgvwAttachement.isHidden = true
                    cell.conLabelMessageLeading.constant = 0
                    cell.btnDownLoadFile.isHidden = true
                }else if mesageList[indexPath.row].mtype == "pm" {
                    cell.imgvwAttachement.isHidden = true
                    cell.conLabelMessageLeading.constant = 0
                    cell.btnDownLoadFile.isHidden = true
                }
                else {
                    cell.imgvwAttachement.isHidden = false
                    cell.conLabelMessageLeading.constant = 8
                    cell.labelMessage.text = "Download File"
                    cell.btnDownLoadFile.isHidden = false
                    cell.btnDownLoadFile.tag = indexPath.row
                    cell.btnDownLoadFile.addTarget(self, action: #selector(self.pressButtonDownloadFile(_:)), for: .touchUpInside)
                }
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.updateConstraints()
                cell.updateFocusIfNeeded()
                cell.layoutIfNeeded()
                return cell
            }else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverChatCell.identifier) as? ReceiverChatCell else {
                    fatalError("Cell can't be dequeue")
                }
                cell.labelTime.text = String.getFormattedDate(string: mesageList[indexPath.row].time ?? "", formatterPass: "yyyy-MM-dd HH:mm:ss", formatterGet: "hh:mm a")
                cell.labelMessage.text = mesageList[indexPath.row].msg
                if mesageList[indexPath.row].mtype == "m" {
                    cell.imgvwAttachement.isHidden = true
                    cell.conLabelMessageLeading.constant = 0
                    //cell.btnDownloadFile.isHidden = true
                }else if mesageList[indexPath.row].mtype == "pm" {
                    cell.imgvwAttachement.isHidden = true
                    cell.conLabelMessageLeading.constant = 0
                    //cell.btnDownloadFile.isHidden = true
                }
                else {
                    cell.imgvwAttachement.isHidden = false
                    cell.conLabelMessageLeading.constant = 8
                    cell.labelMessage.text = "Download File"
                    // cell.btnDownloadFile.isHidden = false
                    // cell.btnDownloadFile.tag = indexPath.row
                    // cell.btnDownloadFile.addTarget(self, action: #selector(self.pressButtonDownloadFile(_:)), for: .touchUpInside)
                }
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.updateConstraints()
                cell.updateFocusIfNeeded()
                cell.layoutIfNeeded()
                return cell
         }
         }
            else{
        if arrMessages[indexPath.row].sender_id == UserData.shared.getUser()!.user_id {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatCell.identifier) as? SenderChatCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelTime.text = String.getFormattedDate(string: arrMessages[indexPath.row].time, formatterPass: "yyyy-MM-dd HH:mm:ss", formatterGet: "hh:mm a")
            cell.labelMessage.text = arrMessages[indexPath.row].msg
            if arrMessages[indexPath.row].mtype == "m" {
                cell.imgvwAttachement.isHidden = true
                cell.conLabelMessageLeading.constant = 0
                cell.btnDownLoadFile.isHidden = true
            }else if arrMessages[indexPath.row].mtype == "pm" {
                cell.imgvwAttachement.isHidden = true
                cell.conLabelMessageLeading.constant = 0
                cell.btnDownLoadFile.isHidden = true
            }
            else {
                cell.imgvwAttachement.isHidden = false
                cell.conLabelMessageLeading.constant = 8
                cell.labelMessage.text = "Download File"
                cell.btnDownLoadFile.isHidden = false
                cell.btnDownLoadFile.tag = indexPath.row
                cell.btnDownLoadFile.addTarget(self, action: #selector(self.pressButtonDownloadFile(_:)), for: .touchUpInside)
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            cell.updateConstraints()
            cell.updateFocusIfNeeded()
            cell.layoutIfNeeded()
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverChatCell.identifier) as? ReceiverChatCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelTime.text = String.getFormattedDate(string: arrMessages[indexPath.row].time, formatterPass: "yyyy-MM-dd HH:mm:ss", formatterGet: "hh:mm a")
            cell.labelMessage.text = arrMessages[indexPath.row].msg
            if arrMessages[indexPath.row].mtype == "m" {
                cell.imgvwAttachement.isHidden = true
                cell.conLabelMessageLeading.constant = 0
                //cell.btnDownloadFile.isHidden = true
            }else if arrMessages[indexPath.row].mtype == "pm" {
                cell.imgvwAttachement.isHidden = true
                cell.conLabelMessageLeading.constant = 0
                //cell.btnDownloadFile.isHidden = true
            }
            else {
                cell.imgvwAttachement.isHidden = false
                cell.conLabelMessageLeading.constant = 8
                cell.labelMessage.text = "Download File"
               // cell.btnDownloadFile.isHidden = false
               // cell.btnDownloadFile.tag = indexPath.row
               // cell.btnDownloadFile.addTarget(self, action: #selector(self.pressButtonDownloadFile(_:)), for: .touchUpInside)
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            cell.updateConstraints()
            cell.updateFocusIfNeeded()
            cell.layoutIfNeeded()
            return cell
        }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromMessages{
            return mesageList.count
        }else{
        return arrMessages.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isFromMessages{
        let lastElement = arrMessages.count - 1
        let page = allMsgList.pagination.current_page
        let numPages = allMsgList.pagination.total_pages
        let totalRecords = allMsgList.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiGetAllMessages()
        }
        }else{
            if mesageList.count - 1 == indexPath.row &&
                (msgObj!.pagination!.current_page > msgObj!.pagination!.total_pages) {
                self.callGetAllMessages()
            }
        }
    }
}
extension ChatVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        do {
            let data = try Data(contentsOf: myURL)
            print("data=\(data)")
            fileData = data
            fileName = myURL.lastPathComponent
            //let pickedData = data
            print(fileName)
            if isFromMessages{
                 callSendMessageAttachementFile(attachMent: fileData, fileName: fileName)
            }else{
            callApiSendMessageAttachementFile(attachMent: fileData, fileName: fileName)
            }
        }
        catch {/* error handling here */}
        
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
extension ChatVC: UIImagePickerControllerDelegate {
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let asset = result.firstObject
                imageName = asset?.value(forKey: "filename") as? String ?? ""
                print(imageName)
                if isFromMessages{
                    callSendMessageAttachementImage(attachMent: pickedImage, fileName: imageName)
                }else{
                callApiSendMessageAttachementImage(attachMent: pickedImage, fileName: imageName)
                }
            }
        }
        dismiss(animated: true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
