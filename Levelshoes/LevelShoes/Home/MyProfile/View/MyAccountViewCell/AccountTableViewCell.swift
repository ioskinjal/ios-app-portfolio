//
//  AccountTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 20/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol AccountTableViewCellDelegate: class {
    func didSelectedRowWith(indexPath: IndexPath)
}
class AccountTableViewCell: UITableViewCell {
    let Orders_Returnscell = "Orders_Returns"
     let Notificationscell = "Notifications"
     let Personal_Details = "Personal_Details"
     let Preferencescell = "Preferences"
    
    weak var delegates: AccountTableViewCellDelegate?
    var parentController : UIViewController?
    var userData: AddressInformation?
    var addressArray : [Addresses] = [Addresses]()
    
    var notificationsCount = 0

    @IBOutlet weak var lblMyaccountHeader: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMyaccountHeader.font = UIFont(name: "Cairo-SemiBold", size: lblMyaccountHeader.font.pointSize)
            }
            lblMyaccountHeader.text = "aacountAccount".localized
        }
    }
    @IBOutlet weak var accountTableView: UITableView!
    
       var cellArray = ["Orders_Returns","Notifications","Personal_Details","Preferences"]
       var array = [validationMessage.accountOrderReturn.localized,validationMessage.accountNotifiation.localized,validationMessage.accountPersonalDetail.localized,validationMessage.accountPreference.localized]
//    var cellArray = ["Orders_Returns","Personal_Details","Preferences"]
//    var array = [validationMessage.accountOrderReturn.localized,validationMessage.accountPersonalDetail.localized,validationMessage.accountPreference.localized]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        
    }
    
    func setup(){
        let cells =
            [MyAccountTableCell.className]
        accountTableView.register(cells)
    }
}

extension AccountTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableCell", for: indexPath) as? MyAccountTableCell else{return UITableViewCell()}
        cell._lblName.text = array[indexPath.row]
        
        if indexPath.item == 1{
            if notificationsCount > 0 {
                cell._lblName.text! +=  " " +  "(" + "\(notificationsCount)" +  ")"
            }
            else{
                cell._lblName.text! +=  " "
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cellString = cellArray[indexPath.row]
        
        switch cellString
        {
        case Orders_Returnscell:
            let storyboards = UIStoryboard(name: "MyOrders", bundle: Bundle.main)
            let changeVC = storyboards.instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC
            self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
        case Notificationscell:
            //NotificationTableViewController
            let storyboard = UIStoryboard(name: "PersonalDetailStoryBord", bundle: Bundle.main)
            let returnOrderVC: NotificationTableViewController! = storyboard.instantiateViewController(withIdentifier: "NotificationTableViewController") as? NotificationTableViewController
            self.parentController?.navigationController?.pushViewController(returnOrderVC!, animated: true)
        case Personal_Details:
            let storyboard = UIStoryboard(name: "PersonalDetailStoryBord", bundle: Bundle.main)
            let returnOrderVC: PersonalDetailViewController! = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as? PersonalDetailViewController
            returnOrderVC.userData = self.userData
            returnOrderVC.addressArray = self.addressArray
            
            self.parentController?.navigationController?.pushViewController(returnOrderVC!, animated: true)
        case Preferencescell:
            let storyboard = UIStoryboard(name: "prefs", bundle: Bundle.main)
            let prefsVC: prefsVC! = storyboard.instantiateViewController(withIdentifier: "prefsVC") as? prefsVC
            
            prefsVC.userData = self.userData
            self.parentController?.navigationController?.pushViewController(prefsVC!, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "faqs", bundle: Bundle.main)
            let returnOrderVC: faqsVC! = storyboard.instantiateViewController(withIdentifier: "faqsVC") as? faqsVC
            self.parentController?.navigationController?.pushViewController(returnOrderVC!, animated: true)
        }
                    
//        if indexPath.row == 0 {
//            let storyboards = UIStoryboard(name: "MyOrders", bundle: Bundle.main)
//            let changeVC = storyboards.instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC
//            self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
//        }
//        else if indexPath.row == 1 {
//                let storyboard = UIStoryboard(name: "faqs", bundle: Bundle.main)
//                let returnOrderVC: faqsVC! = storyboard.instantiateViewController(withIdentifier: "faqsVC") as? faqsVC
//                self.parentController?.navigationController?.pushViewController(returnOrderVC!, animated: true)
//            }
//        else{
//            let storyboard = UIStoryboard(name: "prefs", bundle: Bundle.main)
//            let prefsVC: prefsVC! = storyboard.instantiateViewController(withIdentifier: "prefsVC") as? prefsVC
//            self.parentController?.navigationController?.pushViewController(prefsVC!, animated: true)
//
//
//        }


//        if indexPath.row == 0{
//        if let safeDelegate = self.delegates {
//           safeDelegate.didSelectedRowWith(indexPath: indexPath)
//        }
//        }
    }
}
