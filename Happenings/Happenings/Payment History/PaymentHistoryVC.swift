//
//  PaymentHistoryVC.swift
//  Talabtech
//
//  Created by NCT 24 on 27/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class PaymentHistoryVC: BaseViewController {

    //MARK: Properties

    static var storyboardInstance:PaymentHistoryVC? {
        return StoryBoard.accountsettings.instantiateViewController(withIdentifier: PaymentHistoryVC.identifier) as? PaymentHistoryVC
    }
    
    @IBOutlet weak var imgNoRecords: UIImageView!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(MyWalletCell.nib, forCellReuseIdentifier: MyWalletCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    
    @IBOutlet weak var constraintTabliViewHeight: NSLayoutConstraint!
   
    
    var paymentHistoryList = [PaymentHistoryCls.PaymentList]()
 var favouriteObj: PaymentHistoryCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        paymentHistoryAPI()
    }
    
    
    func paymentHistoryAPI(){
          let nextPage = (favouriteObj?.currentPage ?? 0 ) + 1
        let param = ["action":"payment-history",
                     "user_id":"203",
                     "page_no":nextPage] as [String : Any]
        Modal.shared.getPaymentHistory(vc: self, param: param) { (dic) in
            self.favouriteObj = PaymentHistoryCls(dictionary: dic)
            if self.paymentHistoryList.count > 0{
                self.paymentHistoryList += self.favouriteObj!.payments
            }
            else{
                self.paymentHistoryList = self.favouriteObj!.payments
            }
            if self.paymentHistoryList.count != 0{
                self.tableView.reloadData()
            }
        }

}
}

//MARK: Custom function
extension PaymentHistoryVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Payment History", action: #selector(onClickMenu(_:)))
       
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.constraintTabliViewHeight.constant = self.tableView.contentSize.height
            //self.view.layoutIfNeeded()
        }
    }
    
}

extension PaymentHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyWalletCell.identifier) as? MyWalletCell else {
            fatalError("Cell can't be dequeue")
        }
        var strDate:String = paymentHistoryList[indexPath.row].payment_date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        strDate = dateFormatter.string(from: date!)
        cell.lblDate.text = strDate
        cell.lblAmmount.text = String(format: "%@%@",(UserData.shared.getUser()?.currency)!, paymentHistoryList[indexPath.row].payment_amount!)
        cell.lblCat.text = paymentHistoryList[indexPath.row].categoryName! + "& " + paymentHistoryList[indexPath.row].subcategoryName!
        cell.lblMerchantName.text = paymentHistoryList[indexPath.row].merchantName
       
        cell.lblDealName.text = paymentHistoryList[indexPath.row].deal_title
        cell.lbltransactionId.text  = paymentHistoryList[indexPath.row].transaction_id
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)


    }

    
    func reloadMoreData(indexPath: IndexPath) {
        if paymentHistoryList.count - 1 == indexPath.row &&
            (favouriteObj!.currentPage > favouriteObj!.TotalPages) {
            self.paymentHistoryAPI()
        }
    }
}
