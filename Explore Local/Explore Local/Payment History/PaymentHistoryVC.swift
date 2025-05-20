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
        return StoryBoard.main.instantiateViewController(withIdentifier: PaymentHistoryVC.identifier) as? PaymentHistoryVC
    }
    
    
    @IBOutlet weak var lblNoData: UILabel!
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
          let nextPage = (favouriteObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"payments",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page":nextPage] as [String : Any]
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
            }else{
                self.lblNoData.isHidden = false
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
        cell.lblDateAns.text = paymentHistoryList[indexPath.row].payment_date
        cell.lblAmount.text = paymentHistoryList[indexPath.row].price
        cell.lblAmountAns.text = paymentHistoryList[indexPath.row].plan_name
        cell.lblId.text = paymentHistoryList[indexPath.row].txn_id
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return paymentHistoryList.count
        return paymentHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
        
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if paymentHistoryList.count - 1 == indexPath.row &&
            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
            self.paymentHistoryAPI()
        }
    }
}
