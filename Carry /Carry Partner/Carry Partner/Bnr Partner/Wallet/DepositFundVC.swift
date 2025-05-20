//
//  DepositFundVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class DepositFundVC: BaseVC {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var depositView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
    }
    @IBAction func btnPayPalClicked(_ sender: Any) {
        
    }
   

}
