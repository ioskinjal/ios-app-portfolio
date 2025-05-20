//
//  ChatVC.swift
//  Talabtech
//
//  Created by NCT 24 on 25/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit
import Photos

extension Notification.Name {
    static let sendMessgae = Notification.Name("sendMessgae")
}

class ChatVC: BaseViewController {

    //MARK: Properties

    static var storyboardInstance:ChatVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ChatVC.identifier) as? ChatVC
    }
    
    var msgList = [MessageCls.MessagesList]()
    var msgObj: MessageCls?
    var param: [String:Any]?
    
    var selectedUserImage:UIImage?
    var pickedImageName:String?
    
    var picker:UIImagePickerController!{
        didSet{
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
        }
    }
    @IBOutlet weak var imgNoRecords: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ChatCell.nib, forCellReuseIdentifier: ChatCell.identifier)
            tableView.register(ChatReceiveCell.nib, forCellReuseIdentifier: ChatReceiveCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.placeholder =  "Type message here..."
           
        }
    }
    @IBOutlet weak var btnAttachement: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callLoadConversationAPI()
    }
    
    @IBAction func onClickAttachements(_ sender: UIButton) {
        checkPhotoLibraryPermission()
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        if !(textView.text.isBlank){
            callsendMsgAPI()
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please enter message or attach files", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}

//MARK: Custom function
extension ChatVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Messages", action: #selector(onClickMenu(_:)))
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func callLoadConversationAPI() {
        if var param = self.param{
            let nextPage = (msgObj?.pagination?.current_page ?? 0 ) + 1
            param["page"] = nextPage
            Modal.shared.getMessages(vc: self, param: param) { (dic) in
                print(dic)
                self.msgObj = MessageCls(dictionary: dic)
                if self.msgList.count > 0{
                    self.msgList += self.msgObj!.msgList
                }
                else{
                    self.msgList = self.msgObj!.msgList
                }
                if self.msgList.count != 0{
                    self.tableView.reloadData()
                }
            }

        }
    }
    
    func scrollToLastRow() {
        if msgList.count > 0 {
        let indexPath = IndexPath(row: self.msgList.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func callsendMsgAPI() {
        var param = [String:String]()
        //let fatchedParam = self.param
        if msgList.count > 0{
            param = [
                "action":"send_message",
                "user_id":UserData.shared.getUser()!.user_id,
                "receiver_id":self.param!["receiver_id"]as! String,
                "message":textView.text!
               ]
        }
        else if let fatchedParam = self.param{
            param = [
                "action":"send_message",
                "user_id":UserData.shared.getUser()!.user_id,
                "receiver_id":fatchedParam["receiver_id"] as! String,
                "message":textView.text!
               ]
        }
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            print(dic)
            self.msgList = [MessageCls.MessagesList]()
            self.textView.text = nil
            self.textView.placeholder = "Type a message here"
            self.callLoadConversationAPI()
            self.textView.isUserInteractionEnabled = true
            //TODO: Add notification
            NotificationCenter.default.post(name: .sendMessgae, object: ["sendMessgae":true] as [String:Any])
        }
    }
    
    
    func checkPhotoLibraryPermission(){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Access has been granted.
            self.openGallary()
        case .denied, .restricted :
            // Access has been denied.
            // Restricted access - normally won't happen.
            openSettingForGivePermissionPhotos()
        case .notDetermined:
            // ask for permissions
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.openGallary()
                }
                else {
                    self.openSettingForGivePermissionPhotos()
                }
            })
        }
        
    }
    
    func openGallary(){
        picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
    }
    
    func openSettingForGivePermissionPhotos() {
        self.alert(title: "", message: "Photo Access Prohibited", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                self.open(scheme:UIApplicationOpenSettingsURLString)
            }
            else{//Cancel
            }
        })
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if msgList[indexPath.row].user_id == UserData.shared.getUser()!.user_id {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatReceiveCell.identifier) as? ChatReceiveCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.chatCellData = msgList[indexPath.row]
//            cell.btnDelete.tag = indexPath.row
//            cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier) as? ChatCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.chatCellData = msgList[indexPath.row]
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    @objc func onClickDelete(_ sender:UIButton){
         if msgList[sender.tag].id != UserData.shared.getUser()!.user_id {
        let param = ["action":"delete",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "id":msgList[sender.tag].id!]
        
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
            self.alert(title: "", message: data, completion: {
                self.msgList = [MessageCls.MessagesList]()
                self.callLoadConversationAPI()
            })

            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if msgList.count - 1 == indexPath.row &&
            (msgObj!.pagination!.current_page > msgObj!.pagination!.total_pages) {
            self.callLoadConversationAPI()
        }
    }
}

extension ChatVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        //2
        if let _ = selectedImage {
            pickedImageName = picker.getPickedFileName(info: info)
            textView.isUserInteractionEnabled = false
            textView.text = ""
            textView.text = pickedImageName
            textView.resetPlaceHolder()
            self.selectedUserImage = selectedImage
        }
        else{
            print("Something went wrong")
        }
        //3
        //dismiss(animated: true, completion: nil)
        dismiss(animated: false) {
            //            if let selectedImages = selectedImage {
            //                let imageCropper = ImageCropper.storyboardInstance
            //                imageCropper.delegate = self
            //                imageCropper.image = selectedImages
            //                self.present(imageCropper, animated: false, completion: nil)
            //            }
        }
        
    }
    
    
}

//MARK: ImageCropper Class
extension ChatVC: ImageCropperDelegate{
    
    func didCropImage(originalImage: UIImage, cropImage: UIImage) {
        self.selectedUserImage = cropImage
    }
    
    func didCancel() {
        print("Cancel Crop Image")
    }
    
}
