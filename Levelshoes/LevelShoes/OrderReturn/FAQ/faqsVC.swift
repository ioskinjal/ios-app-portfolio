//
//  faqsVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 07/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class faqsVC: UIViewController {
    @IBOutlet weak var header: headerView!
    
    let faqTitles  = ["Purchasing online","Product information","Payment","Shipping and delivery",
                    "Returns","Care and repair","Contact us",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderAction()
    }
    
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Pick Address")
        self.navigationController?.popViewController(animated: true)
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
extension faqsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqsCell", for: indexPath) as! faqsCell
        cell.lblTitle.text = faqTitles[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
        print("FAQ Selecton \(indexPath.row)")
        let storyboard = UIStoryboard(name: "appServices", bundle: Bundle.main)
                let servocesVC: appServicesVC! = storyboard.instantiateViewController(withIdentifier: "appServicesVC") as? appServicesVC
        self.navigationController?.pushViewController(servocesVC, animated: true)
        
    }
}
