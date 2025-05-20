//
//  MessageListVC.swift
//  XPhorm
//
//  Created by admin on 6/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MessageListVC: BaseViewController {
    
    static var storyboardInstance:MessageListVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: MessageListVC.identifier) as? MessageListVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.border(side: .all, color: #colorLiteral(red: 0.9137254902, green: 0.9176470588, blue: 0.9019607843, alpha: 1), borderWidth: 1.0)
            searchBar.setRadius(8.0)
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var viewTrash: UIView!
    @IBOutlet weak var viewInbox: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var tblTrash: UITableView!{
        didSet{
            tblTrash.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.identifier)
            tblTrash.dataSource = self
            tblTrash.delegate = self
            tblTrash.tableFooterView = UIView()
            tblTrash.separatorStyle = .singleLine
        }
    }
    @IBOutlet weak var tblInbox: UITableView!{
        didSet{
            tblInbox.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.identifier)
            tblInbox.dataSource = self
            tblInbox.delegate = self
            tblInbox.tableFooterView = UIView()
            tblInbox.separatorStyle = .singleLine
        }
    }
    
    @IBOutlet weak var btnUnread: UIButton!
    @IBOutlet weak var btnTrash: UIButton!
    @IBOutlet weak var btnInbox: UIButton!
    
    
    @IBOutlet weak var tblUnread: UITableView!{
        didSet{
            tblUnread.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.identifier)
            tblUnread.dataSource = self
            tblUnread.delegate = self
            tblUnread.tableFooterView = UIView()
            tblUnread.separatorStyle = .singleLine
        }
    }
    @IBOutlet weak var viewUnread: UIView!
    var totalWidth:Float = 0.0
    var inboxList = [InboxList]()
    var trashList = [InboxList]()
    var UnreadList = [InboxList]()
    
    var strType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationBar.lblTitle.text = "Messaage List Service"
        totalWidth = Float(self.viewInbox.frame.size.width*3)
         self.getTrashList(searchText: self.searchBar.text ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        onClickInbox(btnInbox)
        inboxList = [InboxList]()
        getInboxList(searchText:searchBar.text ?? "")
        
    }
    //UserData.shared.getUser()!.id
    func getInboxList(searchText:String){
        self.inboxList = [InboxList]()
        self.tblInbox.reloadData()
        let param = ["action":"getUsers",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "tabType":"i",
                     "searchName":searchBar.text ?? ""]
        
        Modal.shared.getMessages(vc: nil, param: param) { (dic) in
            self.inboxList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({InboxList(dic: $0 as! [String:Any])})
            self.tblInbox.reloadData()
            
           
        }
    }
    func getTrashList(searchText:String){
         self.trashList = [InboxList]()
        self.tblTrash.reloadData()
        let param = ["action":"getUsers",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "tabType":"t",
                     "searchName":searchBar.text ?? ""]
        
        Modal.shared.getMessages(vc: nil, param: param) { (dic) in
            self.trashList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({InboxList(dic: $0 as! [String:Any])})
            self.tblTrash.reloadData()
        }
    }
    
    func getUnreadList(searchText:String){
         self.UnreadList = [InboxList]()
        self.tblUnread.reloadData()
        let param = ["action":"getUsers",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "tabType":"u",
                     "searchName":searchBar.text ?? ""]
        
        Modal.shared.getMessages(vc: nil, param: param) { (dic) in
            self.UnreadList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({InboxList(dic: $0 as! [String:Any])})
            self.tblUnread.reloadData()
        }
    }
    
    @IBAction func onClickUnread(_ sender: UIButton) {
        strType = "unread"
        self.scrollView.setContentOffset(CGPoint(x: viewUnread.frame.origin.x, y: 0), animated: true)
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        isFromEdit = false
        if sender.tag == 2{
            if UserData.shared.getUser()?.isCertificate == 0{
                self.alert(title: "", message: "please upload certificates in your profile to add service".localized)
            }else if UserData.shared.getUser()?.insta_verify == "n" {
                self.alert(title: "", message: "please verify your instagram account".localized)
            }else{
                self.tabBarController?.selectedIndex = sender.tag
            }
        }else{
            self.tabBarController?.selectedIndex = sender.tag
        }
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    @IBAction func onClickTrash(_ sender: UIButton) {
        strType = "trash"
        self.scrollView.setContentOffset(CGPoint(x: viewTrash.frame.origin.x, y: 0), animated: true)
    }
    @IBAction func onClickInbox(_ sender: UIButton) {
        strType = "inbox"
        self.scrollView.setContentOffset(CGPoint(x: viewInbox.frame.origin.x, y: 0), animated: true)
        btnInbox.setTitleColor(UIColor.black, for: .normal)
        
        btnTrash.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
        btnInbox.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
        btnTrash.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
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
extension MessageListVC:UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == viewInbox.frame.origin.x {
            btnInbox.setTitleColor(#colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), for: .normal)
            
            btnTrash.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            btnUnread.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            btnInbox.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
            btnTrash.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            btnUnread.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            
        }
        else if scrollView.contentOffset.x == viewTrash.frame.origin.x {
            btnTrash.setTitleColor(#colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), for: .normal)
            btnInbox.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            btnTrash.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
            btnInbox.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            btnUnread.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            btnUnread.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            
        }else if scrollView.contentOffset.x == viewUnread.frame.origin.x {
            btnUnread.setTitleColor(#colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), for: .normal)
            btnUnread.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
            btnTrash.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            btnInbox.setTitleColor(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1), for: .normal)
            
            btnTrash.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            btnInbox.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            
        }
    }
    
    
}
extension MessageListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblInbox{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier) as? MessageCell else {
                fatalError("Cell can't be dequeue")
            }
            let data:InboxList?
            data = inboxList[indexPath.row]
            cell.imageView?.downLoadImage(url: data?.userPhoto ?? "")
            cell.lblName.text = data?.fullName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.msgDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy HH:mm"
            cell.lblTime.text = dateformat.string(from: date ?? Date())
            cell.lblMessage.text = data?.lastMsg
            cell.imgView.setRadius()
            cell.btnDelete.tag = indexPath.row
            cell.selectionStyle = .none
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
            return cell
        }else if tableView == tblTrash{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier) as? MessageCell else {
                fatalError("Cell can't be dequeue")
            }
            let data:InboxList?
            data = trashList[indexPath.row]
            cell.imageView?.downLoadImage(url: data?.userPhoto ?? "")
            cell.lblName.text = data?.fullName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.msgDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy HH:mm"
            cell.lblTime.text = dateformat.string(from: date ?? Date())
            cell.lblMessage.text = data?.lastMsg
            cell.selectionStyle = .none
            cell.btnDelete.isHidden = true
            cell.imgView.setRadius()
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier) as? MessageCell else {
                fatalError("Cell can't be dequeue")
            }
            let data:InboxList?
            data = UnreadList[indexPath.row]
            cell.imageView?.downLoadImage(url: data?.userPhoto ?? "")
            cell.lblName.text = data?.fullName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.msgDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy HH:mm"
            cell.lblTime.text = dateformat.string(from: date ?? Date())
            cell.lblMessage.text = data?.lastMsg
            cell.btnDelete.tag = indexPath.row
            cell.selectionStyle = .none
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete1(_:)), for: .touchUpInside)
            cell.imgView.setRadius()
            return cell
        }
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        let param = ["action":"deleteMessage",
                     "userId":UserData.shared.getUser()!.id,
                     "receiverId":inboxList[sender.tag].userId,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.getInboxList(searchText: self.searchBar.text ?? "")
            })
            
        }
    }
    
    @objc func onClickDelete1(_ sender:UIButton){
        let param = ["action":"deleteMessage",
                     "userId":UserData.shared.getUser()!.id,
                     "receiverId":UnreadList[sender.tag].userId,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.getMessages(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.getUnreadList(searchText: self.searchBar.text ?? "")
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return paymentHistoryList.count
        if tableView == tblInbox{
            return inboxList.count
        }else if tableView == tblTrash{
            return trashList.count
        }else{
            return UnreadList.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblInbox{
            let nextVC = ChatVC.storyboardInstance!
            nextVC.receiver_id = inboxList[indexPath.row].userId
        nextVC.navTitle = inboxList[indexPath.row].fullName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if tableView == tblTrash{
            let nextVC = ChatVC.storyboardInstance!
            nextVC.receiver_id = trashList[indexPath.row].userId
            nextVC.navTitle = trashList[indexPath.row].fullName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let nextVC = ChatVC.storyboardInstance!
            nextVC.receiver_id = UnreadList[indexPath.row].userId
            nextVC.navTitle = UnreadList[indexPath.row].fullName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        //        if paymentHistoryList.count - 1 == indexPath.row &&
        //            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
        //            self.paymentHistoryAPI()
        //        }
    }
}
extension MessageListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if strType == "inbox"{
            getInboxList(searchText: searchBar.text ?? "")
        }else if strType == "trash"{
            getTrashList(searchText: searchBar.text ?? "")
        }else{
            getUnreadList(searchText: searchBar.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
    }
    
   
}
