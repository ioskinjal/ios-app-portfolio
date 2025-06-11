//
//  TransactionDetailsViewController.swift
//  OTT
//
//  Created by Chandoo on 17/02/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol TransctionDetailsDelegate {
    func didClosesPopup()
}

class TransactionDetailsViewController: UIViewController {
    
    @IBOutlet weak var packageHeaderLbl1: UILabel!
    @IBOutlet weak var packageHeaderLbl2: UILabel!
    @IBOutlet weak var packagePriceValueLbl: UILabel!
    @IBOutlet weak var taxPriceValueLabl: UILabel!
    @IBOutlet weak var totalPriceValueLbl: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate:TransctionDetailsDelegate! = nil

    var transactionObj:Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let transactionData = self.transactionObj {
            self.packageHeaderLbl1.text = "Purchased on - \((Date().getFullDate("\(transactionData.purchaseTime)", inFormat: "MM/dd/YYYY hh:mm a")))"
            self.packageHeaderLbl2.text = "Package Name - \(transactionData.packageName) Plan"
            self.packagePriceValueLbl.text = "\(transactionData.amount) INR"
            self.taxPriceValueLabl.text = "\(transactionData.tax) INR"
            self.totalPriceValueLbl.text = "\(transactionData.totalAmount) INR"
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.delegate?.didClosesPopup()
    }
    

}
