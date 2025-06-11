//
//  prefsNotifications.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 16/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class prefsNotifications: UIViewController {
    @IBOutlet weak var lblNotificationTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblNotificationTitle.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblEdit: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func backSelector(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editSelector(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            lblEdit.text = "Cancel"
        } else {
            lblEdit.text = "Edit"
        }
    }
    @IBAction func nexbtnSelector(_ sender: UIButton) {
        print("BUTTOn \(sender.tag)")
    }
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension prefsNotifications: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticiationCell", for: indexPath) as! noticiationCell
        cell.btnNext.tag = indexPath.row
        if indexPath.row == 0 {
            cell.viewBg.backgroundColor = .red
        }else{
  
            cell.viewBg.backgroundColor  = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SeleCt your reason \(indexPath.row)")
//        let storyboard = UIStoryboard(name: "pickupAddress", bundle: Bundle.main)
//                let returnReasonVC: pickupAddress! = storyboard.instantiateViewController(withIdentifier: "pickupAddress") as? pickupAddress
//        self.navigationController?.pushViewController(returnReasonVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style:.normal, title:nil) { (action, view, handler) in
            print("Delete Action Tapped")
        }
        deleteAction.backgroundColor = .black
        //deleteAction.title = " Delete"
        deleteAction.image = UIImage(named:"Remove")
        
        let markasRead = UIContextualAction(style:.normal, title:nil) { (action, view, handler) in
            print("Mark As Read Tapped")
        }
        markasRead.backgroundColor = .lightGray//UIColor(red: 250.0, green: 250.0, blue: 250.0, alpha: 1)
        //markasRead.title = "Mark As Read"
        
        markasRead.image = UIImage(named:"Remove")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction , markasRead])
        return configuration
    }
}
