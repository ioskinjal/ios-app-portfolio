//
//  MessagesListVC.swift
//  ThumbPin
//
//  Created by admin on 5/13/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

var isFromMessages = false

class MessagesListVC: BaseViewController {
    
    static var storyboardInstance:MessagesListVC? {
        return StoryBoard.chat.instantiateViewController(withIdentifier: MessagesListVC.identifier) as? MessagesListVC
    }

    @IBOutlet weak var tblMessages: UITableView!{
        didSet{
            tblMessages.dataSource = self
            tblMessages.delegate = self
            tblMessages.tableFooterView = UIView()
            tblMessages.separatorStyle = .singleLine
        }
    }
    
    var mesageList = [MessageCls.MessageList]()
    var msgObj: MessageCls?
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllMessages()
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func getAllMessages(){
        let param:[String:Any] = ["action":Action.getAllMessageList,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        ApiCaller.shared.getAllMessagesList(vc: self, param: param) { (dic) in
            print(dic)
            self.msgObj = MessageCls(dictionary: dic)
            if self.mesageList.count > 0{
                self.mesageList += self.msgObj!.notificationList
            }
            else{
                self.mesageList = self.msgObj!.notificationList
            }
            if self.mesageList.count != 0 {
                self.tblMessages.reloadData()
            }else{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.tblMessages.backgroundView = bgImage
            }
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
extension MessagesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesListCell.identifier) as? MessagesListCell else {
            fatalError("Cell can't be dequeue")
        }
        let dict:MessageCls.MessageList?
        dict = mesageList[indexPath.row]
        cell.lblDate.text = dict?.time
        cell.lblMessage.text = dict?.name
        cell.imgProfile.downLoadImage(url: dict?.image ?? "")
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        if mesageList[indexPath.row].message_id == nil{
            cell.btnDelete.isHidden = true
        }else{
            cell.btnDelete.isHidden = false
        }
        return cell
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        self.alert(title: "Alert", message: "Are you sure you want to delete this message?", actions: ["Yes","No"]) { (btnNo) in
            if btnNo == 0 {
           
            var dictparam:[String:Any] = ["action":"deleteMessage"]
                if self.mesageList[sender.tag].receiver_id == UserData.shared.getUser()?.user_id{
                    dictparam["message_id"] = self.mesageList[sender.tag].sender_id
                    dictparam["user_id"] = self.mesageList[sender.tag].receiver_id
                }else{
                    dictparam["message_id"] = self.mesageList[sender.tag].receiver_id
                     dictparam["user_id"] = self.mesageList[sender.tag].sender_id
                }
                
            
            ApiCaller.shared.getAllMessagesList(vc: self, param: dictparam) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.msgObj = nil
                    self.mesageList = [MessageCls.MessageList]()
                    self.getAllMessages()
                })
            }
            }else{
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return paymentHistoryList.count
        return mesageList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if mesageList.count - 1 == indexPath.row &&
            (msgObj!.pagination!.current_page > msgObj!.pagination!.total_pages) {
            self.getAllMessages()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isFromMessages = true
        let nextVC = ChatVC.storyboardInstance!
        nextVC.provider_id = mesageList[indexPath.row].sender_id ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
