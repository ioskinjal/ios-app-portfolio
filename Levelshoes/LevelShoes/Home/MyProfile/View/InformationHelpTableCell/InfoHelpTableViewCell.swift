//
//  InfoHelpTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 20/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class InfoHelpTableViewCell: UITableViewCell {
    @IBOutlet weak var lblInfoHeader: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblInfoHeader.font = UIFont(name: "Cairo-SemiBold", size: lblInfoHeader.font.pointSize)
            }
            lblInfoHeader.text = "accountInfoHelp".localized
        }
    }
    @IBOutlet weak var infoHelpTableView: UITableView!
    var parentController : UIViewController?
    
    //    var array = ["Contact us","FAQs","Services","About us","Privacy & Cookies","Terms & Conditions"]
    var array = [validationMessage.accountFAQ.localized, validationMessage.aacountService.localized,validationMessage.accountAbout.localized,validationMessage.accountPrivacy.localized,validationMessage.accountTermCondition.localized]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            [InfoHelpTableCell.className]
        infoHelpTableView.register(cells)
    }
}

extension InfoHelpTableViewCell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoHelpTableCell", for: indexPath) as? InfoHelpTableCell else{return UITableViewCell()}
        cell._lblInfoName.text = array[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.parentController?.navigationController?.pushViewController(MyOrdersVC.storyboardMyOrderInstance!, animated: true)
        if indexPath.row == 0{
            let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
                       let changeVC = storyboards.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
                       self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
            
        }else
            
            if indexPath.row == 1{

            let storyboard = UIStoryboard(name: "appServices", bundle: Bundle.main)
                    let servicesVC: appServicesVC! = storyboard.instantiateViewController(withIdentifier: "appServicesVC") as? appServicesVC
            self.parentController?.navigationController?.pushViewController(servicesVC, animated: true)
            

        }else if indexPath.row == 2{
            let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
            let changeVC = storyboards.instantiateViewController(withIdentifier: "AboutUSViewController") as? AboutUSViewController
            self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
        }else if indexPath.row == 3{
            let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
            let changeVC = storyboards.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
            changeVC!.screenType = "PrivacyPolicy"
            self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
        }else if indexPath.row == 4{
            let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
            let changeVC = storyboards.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
             changeVC!.screenType = "TermsAndCondition"
            self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
        }
        
    }
    
}
