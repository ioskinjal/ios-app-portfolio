//
//  MessagesVC.swift
//  Talabtech
//
//  Created by NCT 24 on 23/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class MessagesVC: BaseViewController {

    //MARK: Properties

    static var storyboardInstance:MessagesVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MessagesVC.identifier) as? MessagesVC
    }
    
    @IBOutlet weak var lblNoData: UILabel!
    
   
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(MessagesCell.nib, forCellReuseIdentifier: MessagesCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            //tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 65
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorInset = UIEdgeInsetsMake(0, UIScreen.main.bounds.width*0.2, 0, 0)
        }
    }
    
    var messageList = [MessageCls.MessagesList]()
     var msgObj: MessageCls?
    
    deinit{
        print("MessagesVC is Distroy")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageSend(notification:)), name: .sendMessgae, object: nil)
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageList = [MessageCls.MessagesList]()
        msgObj = nil
        callMsgList()
    }
    
    
}

//MARK: Custom function
extension MessagesVC {
    
    @objc func messageSend(notification: Notification) {
        if (notification.object as! [String: Any])["sendMessgae"] as? Bool ?? false{
            print("catch notification")
            callMsgList()
        }
    }
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle:"Messages", action: #selector(onClickMenu(_:)))
        let user = UserData.shared.getUser()
        if user?.user_type == "1" {
           setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Messages", action: #selector(onClickMenu(_:)))
        }
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func callMsgList() {
        let nextPage = (msgObj?.pagination?.current_page ?? 0 ) + 1
        Modal.shared.getMessages(vc: self, param: ["user_id":UserData.shared.getUser()!.user_id,"action":"messages","page":nextPage]) { (dic) in
            print(dic)
            self.msgObj = MessageCls(dictionary: dic)
            if self.messageList.count > 0{
                self.messageList += self.msgObj!.msgList
            }
            else{
                self.messageList = self.msgObj!.msgList
            }
            if self.messageList.count != 0{
                self.tableView.reloadData()
            }else{
                self.lblNoData.isHidden = false
            }
        }
        
    }
    
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesCell.identifier) as? MessagesCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = messageList[indexPath.row]
        cell._containerView.layer.cornerRadius = 10.0
        cell._containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell._containerView.layer.shadowColor = UIColor.black.cgColor
        cell._containerView.layer.shadowRadius = 10
        
        cell._containerView.layer.shadowOpacity = 0.40
        cell._containerView.layer.masksToBounds = false;
        cell._containerView.clipsToBounds = false;
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = messageList[indexPath.row]
        if UserData.shared.getUser()!.user_id != data.user_id {
        
        let dic:[String:Any] = ["action":"conversation",
                                "user_id":UserData.shared.getUser()!.user_id,
                                "receiver_id":data.user_id!
        ]
        let nextVC = ChatVC.storyboardInstance!
        nextVC.param = dic
        self.navigationController?.pushViewController(nextVC, animated: true)
   }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFromSubCat == false{
            reloadMoreData(indexPath: indexPath)
        }
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if messageList.count - 1 == indexPath.row &&
            (msgObj!.pagination!.current_page > msgObj!.pagination!.total_pages) {
            self.callMsgList()
        }
    }
}
