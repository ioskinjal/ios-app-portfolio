//
//  ManageContactsVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageContactsVC: BaseViewController {
    
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:ManageContactsVC {
        return StoryBoard.manageContacts.instantiateViewController(withIdentifier: ManageContactsVC.identifier) as! ManageContactsVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.delegate = self
        }
    }
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ContactsTC.nib, forCellReuseIdentifier: ContactsTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var contactList = [MyContactCls.List]()
    var contactObj: MyContactCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getContacts(){
        let nextPage = (contactObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "search_title":searchBar.text ?? ""] as [String : Any]
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.addRightView(icon: #imageLiteral(resourceName: "ic_filter"), selector: #selector(didTapBtnFilter(_:)))
        contactList = [MyContactCls.List]()
        contactObj = nil
        getContacts()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    @IBAction func onClickMore(_ sender: UIButton) {
        let alert = UIAlertController(title: "Manage contact", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add New Contact List", style: .default , handler:{ (UIAlertAction)in
            self.addNewConatct()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    func addNewConatct(){
        displayAlret { (contact) in
            let param:dictionary = ["userid": UserData.shared.getUser()!.userid,"contact_list_name":contact]
            API.shared.call(with: .createConatctListName, viewController: self, param: param, success: { (response) in
                //let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                //UIApplication.alert(title: "", message: message)
                self.contactList = [MyContactCls.List]()
                self.contactObj = nil
                self.getContacts()
            })
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Add New Contact".localized, message: "Enter name".localized, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add Contact".localized, style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if !(firstTextField.text ?? "").isBlank {
                callback(firstTextField.text!)
            }
            else {
                UIApplication.alert(title: "Error", message: "Please enter contact list name")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Conatct List Name".localized
            textField.keyboardType = .default
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapBtnFilter(_ sender:UIButton){
        if let _ = sender.superview as? UITextField{
            print("Click Filter")
        }
    }
}

extension ManageContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTC.identifier) as? ContactsTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = contactList[indexPath.row]
        cell.selectionStyle = .none
        cell.btnArrow.tag = indexPath.row
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let nextVC = ContactDetailsVC.storyboardInstance
        nextVC.detailData = contactList[indexPath.row]
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if contactList.count - 1 == indexPath.row &&
            (Int(contactObj!.page) < contactObj!.lastPage) {
            
            getContacts()
            
        }
    }
    
}

extension ManageContactsVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        searchBar.resignFirstResponder()
        contactList = [MyContactCls.List]()
        contactObj = nil
        getContacts()
        
    }
    
}
