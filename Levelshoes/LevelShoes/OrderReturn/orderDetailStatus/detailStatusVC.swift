//
//  detailStatusVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 13/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class detailStatusVC: UIViewController {
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var trackReturn: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                trackReturn.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblReturnTitleNo: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblReturnTitleNo.addTextSpacing(spacing: 1.0)
            }
        }
    }
    @IBOutlet weak var lblOrderNo: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblOrderNo.addTextSpacing(spacing: 1.0)
            }
        }
    }
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblYourItems: UILabel!
    @IBOutlet weak var lblItemsCount: UILabel!
    @IBOutlet weak var lblReturnRequest: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblReturnRequest.addTextSpacing(spacing: 1.0)
            }
        }
    }
    @IBOutlet weak var lblOrderSummary: UILabel!
    @IBOutlet weak var lblSummaryNoOfItems: UILabel!
    @IBOutlet weak var lblCartTotal: UILabel!
    @IBOutlet weak var lblCartTotalValue: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblShippingValue: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblVatValue: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblGrandTotalValue: UILabel!
    
    @IBOutlet weak var lblNeedHelp: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblNeedHelp.addTextSpacing(spacing: 1.5)
            }
        }
    }
    
    @IBOutlet weak var lblProcessing: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblProcessing.addTextSpacing(spacing: 1.0)
            }
        }
    }
    @IBOutlet weak var lblNewReturn: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblNewReturn.addTextSpacing(spacing: 1.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHeaderAction()
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
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
extension detailStatusVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! statusCell
        //result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
        if indexPath.row == 1 {
            cell.line.isHidden = true
            cell.lblPrice.isHidden = false
            cell.lblPrice.attributedText = "5,300 \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")".strikeThrough()
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("Selected Details \(indexPath.row)")
                let storyboard = UIStoryboard(name: "orderReturn", bundle: Bundle.main)
                let returnOrderVC: ReturnOrderVC! = storyboard.instantiateViewController(withIdentifier: "ReturnOrderVC") as? ReturnOrderVC
        self.navigationController?.pushViewController(returnOrderVC, animated: true)
        
        

    }
}

