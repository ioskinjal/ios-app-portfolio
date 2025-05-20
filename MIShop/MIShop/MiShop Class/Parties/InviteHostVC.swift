//
//  InviteHostVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class InviteHostVC: BaseViewController {

    @IBOutlet weak var tblHostList: UITableView!{
        didSet{
            tblHostList.register(InviteHostCell.nib, forCellReuseIdentifier: InviteHostCell.identifier)
            tblHostList.dataSource = self
            tblHostList.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Invite Host", action: #selector(btnSideMenuOpen))
       
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
extension InviteHostVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteHostCell.identifier) as? InviteHostCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.imgUser.setRadius()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
        
        
    }
    
}
