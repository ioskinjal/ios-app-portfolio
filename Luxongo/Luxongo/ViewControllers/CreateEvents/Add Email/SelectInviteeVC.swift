//
//  SelectContactListVC.swift
//  Luxongo
//
//  Created by admin on 8/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol SelectedInvitee {
    func listOfSelectedMails(emails: [FollowList])
}

protocol SelectedInviteSingle {
    func selectedContact(_ contact:MyContactCls.List)
}

class SelectInviteeVC: BaseViewController {
    
    //MARK: Variables
    var selectedInvitee:[FollowList]?
    var listOfInvitee = [FollowList](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var userObj: FollowersCls?
    var isFromManageEvents = false
    var delegateInvitee: SelectedInvitee?
    var delegateContact: SelectedInviteSingle?
    
    //MARK: Properties
    static var storyboardInstance:SelectInviteeVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: SelectInviteeVC.identifier) as! SelectInviteeVC
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            self.bottomView.shadow(Offset:  CGSize(width: 0, height: -5), redius: 5, opacity: 0.1, color: UIColor.gray)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            if isFromManageEvents{
                tableView.register(InviteTC.nib, forCellReuseIdentifier: InviteTC.identifier)
            }else{
                tableView.register(InviteeTC.nib, forCellReuseIdentifier: InviteeTC.identifier)
            }
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var contactList = [MyContactCls.List]()
    var contactObj: MyContactCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromManageEvents{
            getContacts()
        }else{
            getFollowers()
        }
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func onClickAdd(_ sender: UIButton) {
        if isFromManageEvents{
            if let delegate = self.delegateContact{
                if let selectedContact = contactList.filter({ $0.isSelected == true }).first {
                delegate.selectedContact(selectedContact)
            }
        }
    }else{
    if let delegate = self.delegateInvitee{
    //let selectedEmails = (listOfInvitee.filter({ $0.isSelected == true })).map({String($0.email)}).joined(separator: ",")
    let selectedEmails = listOfInvitee.filter({ $0.isSelected == true })
    delegate.listOfSelectedMails(emails: selectedEmails)
    }
    
    }
    dismiss(animated: true)
}

}

//MARK: API methods
extension SelectInviteeVC{
    
    func getFollowers(){
        
        let nextPage = (userObj?.page ?? 0 ) + 1
        
        let param:dictionary = ["userid": UserData.shared.getUser()!.userid,
                                "page":nextPage,
                                "limit":10]
        
        API.shared.call(with: .followers, viewController: self, param: param) { (response) in
            self.userObj = FollowersCls(dictionary: response)
            if self.listOfInvitee.count > 0{
                self.listOfInvitee += self.userObj!.list
            }
            else{
                self.listOfInvitee = self.userObj!.list
            }
            if let selectedInvitee = self.selectedInvitee{
                let selectedEmails = (selectedInvitee.filter({ $0.isSelected == true })).map({String($0.email)})
                for (i,ele) in self.listOfInvitee.enumerated(){
                    if selectedEmails.contains(ele.email){
                        self.listOfInvitee[i].isSelected = true
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func getContacts(){
        let nextPage = (contactObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "search_title":""] as [String : Any]
        
        API.shared.call(with: .myContactList, viewController: self, param: param) { (response) in
            self.contactObj = MyContactCls(dictionary: response)
            if self.contactList.count > 0{
                self.contactList += self.contactObj!.list
            }
            else{
                self.contactList = self.contactObj!.list
            }
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
}

//MARK: UITableViewDelegates
extension SelectInviteeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFromManageEvents{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteTC.identifier) as? InviteTC else {
                fatalError("Cell can't be dequeue")
            }
            cell.btnRadio.tag = indexPath.row
            cell.btnRadio.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
            cell.cellData = contactList[indexPath.row]
            if contactList[indexPath.row].isSelected{
                cell.btnRadio.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            }else{
                cell.btnRadio.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteeTC.identifier) as? InviteeTC else {
                fatalError("Cell can't be dequeue")
            }
            cell.cellData = listOfInvitee[indexPath.row]
            cell.indexPath = indexPath
            return cell
        }
    }
    
    @objc func onClickCheck(_ sender:UIButton){
        for i in contactList{
            i.isSelected = false
        }
        contactList[sender.tag].isSelected = true
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromManageEvents{
            return contactList.count
        }else{
            return listOfInvitee.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFromManageEvents{
            reloadMoreData(indexPath: indexPath)
        }
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if contactList.count - 1 == indexPath.row &&
            (Int(contactObj!.page) < contactObj!.lastPage) {
            getContacts()
            
        }
    }
    
}
