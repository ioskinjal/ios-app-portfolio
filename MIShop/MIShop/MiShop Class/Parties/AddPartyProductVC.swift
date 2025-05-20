//
//  AddPartyProductVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class AddPartyProductVC: BaseViewController {

    @IBOutlet weak var tblProduct: UITableView!{
        didSet{
            tblProduct.register(AddPartyProductCell.nib, forCellReuseIdentifier: AddPartyProductCell.identifier)
            tblProduct.dataSource = self
            tblProduct.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Party Product", action: #selector(btnSideMenuOpen))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddPartyProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddPartyProductCell.identifier) as? AddPartyProductCell else {
            fatalError("Cell can't be dequeue")
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
        
        
    }
    
}
