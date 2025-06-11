//
//  returnDetailVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class returnDetailVC: UIViewController {
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var returnHeader: UIView!
    @IBOutlet weak var stickyFooter: UIView!
    @IBOutlet weak var lblPlaceRefund: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblPlaceRefund.addTextSpacing(spacing: 1.43)
            }
        }
    }
    @IBOutlet weak var lblVatInclusive: UILabel!
    @IBOutlet weak var lblTotalRefundValue: UILabel!
    @IBOutlet weak var lblSelectItem: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblReturn: UILabel!
    @IBOutlet weak var lblItemsReturn: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRefundDetails: UILabel!
    
    @IBOutlet weak var lblPaymentMode: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblPaymentMode.addTextSpacing(spacing: 0.5)
            }
        }
    }
    @IBOutlet weak var lblPaymentModeDesc: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var lblRepackProduct: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblRepackProduct.addTextSpacing(spacing: 0.5)
            }
        }
    }
    @IBOutlet weak var lblRepackDesc: UILabel!
    @IBOutlet weak var lblCourierCollection: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblCourierCollection.addTextSpacing(spacing: 0.5)
            }
        }
    }
    @IBOutlet weak var courierCollectionDesc: UILabel!
    @IBOutlet weak var lblRefundSummary: UILabel!
    @IBOutlet weak var lblnoofItemsReturn: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubtotalValue: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblVatValue: UILabel!
    @IBOutlet weak var lblTotalRefundTittle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    
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
    
    @IBAction func buttonSelector(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "homeDelivery", bundle: Bundle.main)
        let faqServiceVC: homeDeliveryVC! = storyboard.instantiateViewController(withIdentifier: "homeDeliveryVC") as? homeDeliveryVC
        self.navigationController?.pushViewController(faqServiceVC, animated: true)
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
extension returnDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        //result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
        if indexPath.row == 1 {
            cell.customLine.isHidden = true
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected IN Return Details \(indexPath.row)")
//                let storyboard = UIStoryboard(name: "orderReturn", bundle: Bundle.main)
//                let returnOrderVC: ReturnOrderVC! = storyboard.instantiateViewController(withIdentifier: "ReturnOrderVC") as? ReturnOrderVC
//        self.navigationController?.pushViewController(returnOrderVC, animated: true)
        
        

    }
}
