//
//  ContactDetailsTC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ContactDetailsTC: UITableViewCell {
    
    @IBOutlet weak var lblEmail: LabelRegular!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblChar: LabelBold!
    @IBOutlet weak var viewColor: UIView!{
        didSet{
            self.viewColor.setRadius(radius: nil)
        }
    }
    @IBOutlet weak var btnMore: UIButton!
    
    var cellData:ContactDetailList?{
        didSet{
            showData()
        }
    }
    
    func showData(){
        lblTittle.text = cellData?.contact_name
        
        if let character = cellData?.contact_name.character(at: 0) {
            lblChar.text = String(character).capitalizingFirstLetter()
        }
        lblEmail.text = cellData?.contact_email
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }
    @IBAction func onClickMore(_ sender: UIButton) {
        if let parentVC = self.viewController as? ContactDetailsVC {
            let alert = UIAlertController(title: "Manage contact", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            
            alert.addAction(UIAlertAction(title: "Delete Contact", style: .default , handler:{ (UIAlertAction)in
                self.deleteConatct()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            parentVC.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    
    
    func deleteConatct(){
        if let parentVC = self.viewController as? ContactDetailsVC {
            let alert = UIAlertController(title: "Remove Contact", message: "Are You sure you want to remove this contact ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                
                
                let param = ["userid":UserData.shared.getUser()!.userid,
                             "contact_id":self.cellData!.contact_id,
                             "contact_list_id":self.cellData!.id] as [String : Any]
                
                API.shared.call(with: .DeleteContactListEmail, viewController: parentVC, param: param) { (response) in
                   
                    parentVC.getConatcts()
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
