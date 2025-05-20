//
//  InviteFriendVC.swift
//  Talabtech
//
//  Created by NCT 24 on 19/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class InviteFriendVC: BaseViewController {

    //MARK: Properties

    static var storyboardInstance:InviteFriendVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: InviteFriendVC.identifier) as? InviteFriendVC
    }
    
    
   // var inviteFriendsList:[InviteFriends] = []
    
   override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //callInviteFriendListAPI()
    }
    
    @IBOutlet weak var txtMessage: UITextView!{
        didSet{
            txtMessage.placeholder = "Message"
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func onClickInviteFriend(_ sender: UIButton) {
        if isValidated(){
            inviteFriends()
        }
    }
    
    func inviteFriends() {
        let param = ["action":"InviteFriend",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "iEmail":txtEmail.text!,
                     "iMessage":txtMessage.text!]
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
               self.txtEmail.text = ""
                self.txtMessage.text = ""
            })
        }
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email address"
        } else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Please enter a valid email id"
        }else if (txtMessage.text?.isEmpty)! {
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
extension InviteFriendVC{
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Invite Friends", action: #selector(onClickMenu(_:)))
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
