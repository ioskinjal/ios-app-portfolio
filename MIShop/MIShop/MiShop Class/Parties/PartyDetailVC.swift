//
//  PartyDetailVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class PartyDetailVC: BaseViewController {

    @IBOutlet weak var imgParty: UIImageView!
    @IBOutlet weak var lblPartyName: UILabel!
    @IBOutlet weak var lblProductDetails: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblHostedBy: UILabel!
    @IBOutlet weak var imgHostedBy: UIImageView!
    @IBOutlet weak var btnAddProducts: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Party Detail", action: #selector(btnSideMenuOpen))
        imgHostedBy.setRadius()
        btnAddProducts.layer.borderWidth = 1.0
        btnAddProducts.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK-: UIButton Click Events
    
    @IBAction func onClickInviteHost(_ sender: Any) {
        let nextVC = InviteHostVC.instantiate(appStorybord: .Parties)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickAddProducts(_ sender: Any) {
        let nextVC = AddPartyProductVC.instantiate(appStorybord: .Parties)
        self.navigationController?.pushViewController(nextVC, animated: true)
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
