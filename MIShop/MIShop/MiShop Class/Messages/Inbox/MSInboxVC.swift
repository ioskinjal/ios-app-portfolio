//
//  MSInboxVC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSInboxVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tableInboxMessage: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    func getInboxDetail()
    {
//        ModelClass.sharedManager.getMessageUserList(vc: self, messageType: "i") { (success) in
//            self.inboxMessageUserList = success
//            print(self.inboxMessageUserList)
//            self.tableViewInbox.reloadData()
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"MSInboxTC",for: indexPath) as! MSInboxTC
//        cell.data = inboxMessageUserList[indexPath.row]
//        cell.btnDeleteMessageUser.tag = indexPath.row
//        cell.btnDeleteMessageUser.addTarget(self, action:#selector(btnDeleteMessageUserClick), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        print(indexPath.row)
//
//
//        var vc = UIViewController();
//
//        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
//        {
//            vc = UIStoryboard(name:"iPadStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "LGChatVC") as! LGChatVC
//        }
//        else
//        {
//            vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LGChatVC") as! LGChatVC
//        }
//        chatReceiverId = inboxMessageUserList[indexPath.row].userId
//        chatUserName = inboxMessageUserList[indexPath.row].fullName
//        chatType = "i"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btnDeleteMessageUserClick(btn:UIButton)
    {
//        ModelClass.sharedManager.removeUserFromInboxList(vc: self, receiverId: inboxMessageUserList[btn.tag].userId) { (success) in
//            if success
//            {
//                self.getInboxDetail()
//            }
//        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
