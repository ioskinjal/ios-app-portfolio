//
//  ChatVC.swift
//  XPhorm
//
//  Created by admin on 6/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ChatVC: BaseViewController {

    static var storyboardInstance:ChatVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ChatVC.identifier) as? ChatVC
    }
    
    @IBOutlet weak var tblChat: UITableView!{
    didSet{
    tblChat.dataSource = self
    tblChat.delegate = self
    tblChat.tableFooterView = UIView()
    tblChat.separatorStyle = .none
    
    }
}
    @IBOutlet weak var txtMsg: UITextView!{
        didSet{
            txtMsg.placeholder = "Enter message here..."
        }
    }
    
    var chatList = [InboxConversationCls.ChatList]()
    var chatObj: InboxConversationCls?
    var receiver_id:String = ""
    var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: navTitle, action: #selector(onClickMenu(_:)))
        getConversations()
    }
    
    func getConversations(){
        
        let nextPage = (chatObj?.pagination?.page ?? 0 ) + 1
        //UserData.shared.getUser()!.id
        let param = ["action":"getMessages",
        "userId":UserData.shared.getUser()!.id,
        "receiverId":receiver_id,
        "lId":UserData.shared.getLanguage,
        "page":nextPage] as [String : Any]
        
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            self.chatObj = InboxConversationCls(dictionary: dic)
            if self.chatList.count > 0{
                self.chatList += self.chatObj!.chatList
            }
            else{
                self.chatList = self.chatObj!.chatList
            }
        
            self.tblChat.reloadData()
        }
    }
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        if txtMsg.text.isEmpty{
            self.alert(title: "", message: "please enter message".localized)
        }else{
            sendMessage()
        }
    }
    //UserData.shared.getUser()!.id
    func sendMessage(){
        let param = ["action":"sendMessage",
        "userId":UserData.shared.getUser()!.id,
        "receiverId":receiver_id,
        "message":txtMsg.text!,
        "lId":UserData.shared.getLanguage]
        
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            self.chatObj = nil
            self.chatList = [InboxConversationCls.ChatList]()
            self.getConversations()
            self.txtMsg.text = ""
            self.txtMsg.endEditing(true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatList[indexPath.row].isSender == "n"{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatReceiveCell.identifier) as? ChatReceiveCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.viewMsg.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
            cell.viewMsg.setRadius(10.0)
            let data:InboxConversationCls.ChatList?
            data = chatList[indexPath.row]
            cell.imgProfile.downLoadImage(url: data?.receiverInfo?.profileImg ?? "")
            cell.lblUserName.text = data?.receiverInfo?.fullName
            cell.lblMsg.text = data?.message
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.msgDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy HH:mm"
            cell.lblTime.text = dateformat.string(from: date ?? Date())
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatSendCell.identifier) as? ChatSendCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewMsg.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
            cell.viewMsg.setRadius(10.0)
            let data:InboxConversationCls.ChatList?
            data = chatList[indexPath.row]
            cell.imgProfile.downLoadImage(url: data?.senderInfo?.profileImg ?? "")
            cell.lblName.text = data?.senderInfo?.fullName
            cell.lblMsg.text = data?.message
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.msgDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy HH:mm"
            cell.lblTime.text = dateformat.string(from: date ?? Date())
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    
}
