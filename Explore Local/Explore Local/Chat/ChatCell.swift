//
//  ChatCell.swift
//  Talabtech
//
//  Created by NCT 24 on 26/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit
class ChatCell: UITableViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewBack: UIView!{
        didSet{
            viewBack.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            viewBack.layer.borderWidth = 2.0
        }
    }
    //@IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
 //   @IBOutlet weak var btnViewAttach: UIButton!{
//        didSet{
//            btnViewAttach.underline()
//        }
//    }
    
   // @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.setRadius(color: Color.grey.lightDeviderColor)
        }
    }
    
    //@IBOutlet weak var btnAttachmentHeight: NSLayoutConstraint!
    
    //@IBOutlet weak var btnAttachmnetTop: NSLayoutConstraint!
   // @IBOutlet weak var btnAttachmnetBottom: NSLayoutConstraint!
    
    var indexPath: IndexPath!
    
//    var isReceiver : Bool = false {
//        didSet{
//            changeImage()
//        }
//    }
    
//    var cellData: DisputeMsg? {
//        didSet{
//            loadData()
//        }
//    }
//
    var chatCellData: MessageCls.MessagesList?{
        didSet{
            loadMsgs()
        }
    }
    
    func loadMsgs() {
        if let chatCellData = self.chatCellData{
            //sender
            if chatCellData.id == UserData.shared.getUser()!.user_id{
                imgUser.downLoadImage(url: chatCellData.user_image!)
               // lblProviderName.text = chatCellData.user_name
            }
            //receiver
            else{
                imgUser.downLoadImage(url: chatCellData.user_image!)
                //lblProviderName.text = chatCellData.user_name
            }
            lblMessage.text = chatCellData.message
            lblDate.text = chatCellData.date

            //View attachment
//            if chatCellData.appAttUrl.isEmpty{
//                btnAttachmnetTop.constant = 0.0
//                btnAttachmnetBottom.constant = 0.0
//                btnAttachmentHeight.constant = 0.0
//                btnViewAttach.isHidden = true
//            }
//            else{
//                btnAttachmnetTop.constant = 8.0
//                btnAttachmnetBottom.constant = 8.0
//                btnAttachmentHeight.constant = 20.0
//                btnViewAttach.isHidden = false
//            }
        }
        else{
            lblMessage.text = ""
            lblDate.text = ""
           // lblProviderName.text = ""
        }
    }
    
    
    func loadData() {
//        if let cellData = self.cellData{
//            if cellData.created_user_type == "c"{
//                imgUser.downLoadImage(url: cellData.customer_image)
//                lblProviderName.text = cellData.customer_firstname + " " + cellData.customer_lastname
//            }
//            else{
//                imgUser.downLoadImage(url: cellData.provider_image)
//                lblProviderName.text = cellData.provider_firstname + " " + cellData.provider_lastname
//            }
//            lblMessage.text = cellData.dispute_message
//            lblDate.text = cellData.createdDate
//
//            //View attachment
//            if cellData.downloadUrl.isEmpty{
//                btnAttachmnetTop.constant = 0.0
//                btnAttachmnetBottom.constant = 0.0
//                btnAttachmentHeight.constant = 0.0
//                btnViewAttach.isHidden = true
//            }
//            else{
//                btnAttachmnetTop.constant = 8.0
//                btnAttachmnetBottom.constant = 8.0
//                btnAttachmentHeight.constant = 20.0
//                btnViewAttach.isHidden = false
//            }
//        }
//        else{
//
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func changeImage() {
//        bubbleImageView.image = ( isReceiver ? #imageLiteral(resourceName: "ic_background_left") : #imageLiteral(resourceName: "ic_background_right"))
//            .resizableImage(withCapInsets:
//                UIEdgeInsetsMake(17, 21, 17, 21),
//                            resizingMode: .stretch)
//            .withRenderingMode(.alwaysTemplate)
//    }
    
    @IBAction func onClickAttachment(_ sender: UIButton) {
//        if let cellData = self.cellData{
//            if !(cellData.appAttUrl.isEmpty){
//                if cellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "png") ||
//                    cellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "jpg") ||
//                cellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "jpeg") {
//                    imgUser.downloadedFrom(link: cellData.appAttUrl)
//                }
//                else{
//                    Downloader.loadFileAsync(url: URL(string: cellData.appAttUrl)!) { (str, err) in
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        if err == nil, str != nil{
//                            print("Download: \(str!)")
//                            
//                            //https://medium.com/ios-os-x-development/icloud-drive-documents-1a46b5706fe1
//                            //TODO: Save file into iCloude
//                            CloudDataManager.sharedInstance.copyFileToCloud()
//                            
//                            let ac = UIAlertController(title: localizedString(key: "Saved!"), message: localizedString(key: "Documents is saved."), preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: localizedString(key: "OK"), style: .default, handler: nil))
//                            self.viewController?.present(ac, animated: true, completion: nil)
//                        }
//                        else{
//                            let ac = UIAlertController(title: localizedString(key: "Save error"), message: err?.localizedDescription, preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: localizedString(key:"OK"), style: .default, handler: nil))
//                            self.viewController?.present(ac, animated: true, completion: nil)
//                            print("Error in Save Document")
//                        }
//                    }
//                }
//            }
//        }
//        //For char messages attachments
//        else if let chatCellData = self.chatCellData{
//            if !(chatCellData.appAttUrl.isEmpty){
//                if chatCellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "png") ||
//                    chatCellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "jpg") ||
//                    chatCellData.appAttUrl.fileExtensionOnly().caseInsensitiveCompare(string: "jpeg") {
//                    imgUser.downloadedFrom(link: chatCellData.appAttUrl)
//                }
//                else{
//                    Downloader.loadFileAsync(url: URL(string: chatCellData.appAttUrl)!) { (str, err) in
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        if err == nil, str != nil{
//                            print("Download: \(str!)")
//                            
//                            //https://medium.com/ios-os-x-development/icloud-drive-documents-1a46b5706fe1
//                            //TODO: Save file into iCloude
//                            CloudDataManager.sharedInstance.copyFileToCloud()
//                            
//                            let ac = UIAlertController(title: localizedString(key:"Saved!"), message: localizedString(key:"Documents is saved."), preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: localizedString(key:"OK"), style: .default, handler: nil))
//                            self.viewController?.present(ac, animated: true, completion: nil)
//                        }
//                        else{
//                            let ac = UIAlertController(title: localizedString(key:"Save error"), message: err?.localizedDescription, preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: localizedString(key:"OK"), style: .default, handler: nil))
//                            self.viewController?.present(ac, animated: true, completion: nil)
//                            print("Error in Save Document")
//                        }
//                    }
//                }
//            }
//        }
    }
    
}
