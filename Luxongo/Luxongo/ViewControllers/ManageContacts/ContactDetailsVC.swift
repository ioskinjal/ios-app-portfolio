//
//  ContactDetailsVC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ContactDetailsVC: BaseViewController {
    
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:ContactDetailsVC {
        return StoryBoard.manageContacts.instantiateViewController(withIdentifier: ContactDetailsVC.identifier) as! ContactDetailsVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
        }
    }
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblNumOfCon: LabelRegular!
    @IBOutlet weak var lblDate: LabelRegular!
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ContactDetailsTC.nib, forCellReuseIdentifier: ContactDetailsTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    var detailData:MyContactCls.List?
    var contactList = [ContactDetailList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTittle.text = detailData?.contact_list_name
        
        let array = detailData?.created_at.components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: array?[0] ?? "")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        lblDate.text = "Created on \(dateFormatter.string(from: date ?? Date()))"
        getConatcts()
        
    }
    
    func getConatcts(){
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "contact_id":detailData!.id] as [String : Any]
        
        API.shared.call(with: .getContactListName, viewController: self, param: param) { (response) in
            self.contactList = Response.fatchDataAsArray(res: response, valueOf: .data).map({ContactDetailList(dictionary: $0 as! [String:Any])})
            self.lblNumOfCon.text = "\(String(describing: self.contactList.count ) ) Contacts"
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickMore(_ sender: UIButton) {
        let alert = UIAlertController(title: "Manage contact Detail", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add New Contact", style: .default , handler:{ (UIAlertAction)in
            self.addNewConatct()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    func addNewConatct(){
        
        displayAlret { (email,name) in
            
            
            
            let param:dictionary = ["userid": UserData.shared.getUser()!.userid,"contact_list_name":self.detailData?.contact_list_name ?? "","contact_id":self.detailData?.id ?? "","upload_type":"manual","contact_name":name,"contact_email":email]
            API.shared.call(with: .AddContactListEmail, viewController: self, param: param, success: { (response) in
              
                self.getConatcts()
            })
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String,_ txtStr2:String) -> Void ) {
        let alertController = UIAlertController(title: "Add New Contact".localized, message: "Enter name".localized, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add Contact".localized, style: .default, handler: {
            alert -> Void in
            var email = ""
            var name = ""
            let firstTextField2 = alertController.textFields![1] as UITextField
            let firstTextField = alertController.textFields![0] as UITextField
            if !firstTextField._text.isBlank && firstTextField._text.isValidEmailId && !firstTextField2._text.isBlank{
                name = firstTextField2._text
                email = firstTextField._text
                callback(email, name)
            }
            else {
                if firstTextField._text.isBlank || !firstTextField._text.isValidEmailId{
                    UIApplication.alert(title: "Error", message: "Please enter valid email id")
                }else if firstTextField2._text.isBlank{
                    UIApplication.alert(title: "Error", message: "Please enter contact name")
                }else{
                    UIApplication.alert(title: "Error", message: "Please enter correct information")
                }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Conatct Email".localized
            textField.keyboardType = .emailAddress
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Conatct Name".localized
            textField.keyboardType = .default
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ContactDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailsTC.identifier) as? ContactDetailsTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = contactList[indexPath.row]
        cell.selectionStyle = .none
        cell.btnMore.tag = indexPath.row
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
