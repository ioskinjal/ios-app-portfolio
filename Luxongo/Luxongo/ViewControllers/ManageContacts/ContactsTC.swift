//
//  ContactsTC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ContactsTC: UITableViewCell {
    
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblNumOfCon: LabelRegular!
    @IBOutlet weak var lblDate: LabelRegular!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }
    
    
    var cellData:MyContactCls.List?{
        didSet{
            showData()
        }
    }
    
    func showData(){
        lblTittle.text = cellData?.contact_list_name
        lblNumOfCon.text = "\(String(describing: cellData?.detailList.count ?? 0) ) Contacts"
       // let array = cellData?.created_at.components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: cellData?.created_at ?? "")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        lblDate.text = "Created on \(dateFormatter.string(from: date ?? Date()))"
    }
    
    @IBAction func onClickMore(_ sender: UIButton) {
        if let parentVC = self.viewController as? ManageContactsVC {
            let alert = UIAlertController(title: "Manage contact", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Edit Contact", style: .default , handler:{ (UIAlertAction)in
                self.editContact()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Delete Contact", style: .default , handler:{ (UIAlertAction)in
                self.deleteConatct()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            parentVC.present(alert, animated: true, completion: {
                
            })
        }
        
    }
    
    func editContact(){
        if let parentVC = self.viewController as? ManageContactsVC {
            displayAlret { (contact) in
                
                let param:dictionary = ["userid": UserData.shared.getUser()!.userid,"contact_list_name":contact,
                                        "contact_id":self.cellData?.id ?? ""]
                API.shared.call(with: .editContactListName, viewController: parentVC, param: param, success: { (response) in
                    let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                    UIApplication.alert(title: "", message: message)
                    parentVC.contactList = [MyContactCls.List]()
                    parentVC.contactObj = nil
                    parentVC.getContacts()
                })
            }
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        if let parentVC = self.viewController as? ManageContactsVC {
            let alertController = UIAlertController(title: "Edit Contact List name".localized, message: "Enter name".localized, preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Edit Contact List Name".localized, style: .default, handler: {
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
                textField.text = self.cellData?.contact_list_name
            }
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            parentVC.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    func deleteConatct(){
        if let parentVC = self.viewController as? ManageContactsVC {
            let alert = UIAlertController(title: "Remove Flyers", message: "Are You sure you want to remove this contact list ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                
                
                let param = ["userid":UserData.shared.getUser()!.userid,
                             "contact_id":self.cellData!.id] as [String : Any]
                
                API.shared.call(with: .deleteContactListName, viewController: parentVC, param: param) { (response) in
                    parentVC.contactList = [MyContactCls.List]()
                    parentVC.contactObj = nil
                    parentVC.getContacts()
                    parentVC.tableView.reloadData()
                }
                
                
            }))
            alert.addAction(UIAlertAction(title: "No",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            
            }))
            parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
