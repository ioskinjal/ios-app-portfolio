////
////  SendInviteVC.swift
////  Talabtech
////
////  Created by NCT 24 on 20/04/18.
////  Copyright © 2018 NCT 24. All rights reserved.
////
//

import UIKit

//import HTagView
//import SkyFloatingLabelTextField
//

class SendInviteVC: BaseViewController{
//
//    //MARK: Properties
//
    static var storyboardInstance:SendInviteVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SendInviteVC.identifier) as? SendInviteVC
    }

    @IBOutlet weak var txtAddEmail: UITextField!
    @IBOutlet weak var txtMsg: UITextView!{
        didSet{
        txtMsg.placeholder = "Message*"
        }
    }

    var strbus_id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


    

    @IBAction func onClickSend(_ sender: UIButton){
        if isValidated() {
            sendToFriend()
        }
    }

    func sendToFriend(){
        let param = ["action":"send_friend",
                     "business_id":strbus_id,
            "user_id":UserData.shared.getUser()?.user_id ?? "",
            "email":txtAddEmail.text!,
            "message":txtMsg.text!]
        
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion:{
                self.navigationController?.popViewController(animated: true)
                })
            }
        }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtAddEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email"
        }
        else if !(txtAddEmail.text?.isValidEmailId)!{
            ErrorMsg = "Please enter valid email"
        }
        else if (txtMsg.text?.isEmpty)! {
            ErrorMsg = "Please enter message"
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }


}
}
//
////MARK: Custom function
extension SendInviteVC {

    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Send To Friend", action: #selector(onClickMenu(_:)))

      

    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    func callSendInvitesAPI() {
//        var para = ["user_id":UserData.shared.getUser()!.user_id, "email":tagView1_data.joined(separator: ","),]
//        if !(txtMsg.text?.isEmpty)!{
//            para["message"] = txtMsg.text!
//        }
//        Modal.shared.inviteFriends(vc: self, param: para) { (dic) in
//            print(dic)
//            self.navigationController?.popViewController(animated: true)
//        }
//    }

}
}


