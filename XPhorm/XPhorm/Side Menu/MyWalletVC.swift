//
//  MyWalletVC.swift
//  XPhorm
//
//  Created by admin on 6/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyWalletVC: BaseViewController {
    
    static var storyboardInstance:MyWalletVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: MyWalletVC.identifier) as? MyWalletVC
    }
    @IBOutlet weak var lblRedeemRequest: UILabel!
    @IBOutlet weak var lblRedeemptionHistory: UILabel!
    @IBOutlet weak var lblPaymentHistory: UILabel!
    @IBOutlet weak var redeemRequestPoint: UIView!
    @IBOutlet weak var paymentHistoryPoin: UIView!
    
    @IBOutlet weak var redemptionHistoryPoint: UIView!
    
    @IBOutlet weak var btnDepositeAmount: UIButton!
    
    @IBOutlet weak var lblOnHoldHead: UILabel!
    @IBOutlet weak var lblRedemptionAmountHead: UILabel!
    @IBOutlet weak var lblTotalAmountHead: UILabel!
    @IBOutlet weak var tblRedemptionHistory: UITableView!{
        didSet{
            tblRedemptionHistory.dataSource = self
            tblRedemptionHistory.delegate = self
            tblRedemptionHistory.tableFooterView = UIView()
            tblRedemptionHistory.setRadius(10.0)
            tblRedemptionHistory.separatorStyle = .none
            
        }
    }
    @IBOutlet weak var viewRedemptionHistory: UIView!
    @IBOutlet weak var viewPaymentHistory: UIView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            
        }
    }
    
    var totalWidth = 0.0
//    @IBOutlet weak var btnRedemptionHistory: UIButton!{
//        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.btnRedemptionHistory.addBorder(side: .bottom, color: #colorLiteral(red: 0.2352941176, green: 0.1568627451, blue: 0.3803921569, alpha: 1), width: 2)
//            }
//        }
//    }
//    @IBOutlet weak var btnPaymentHistory: UIButton!{
//        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.btnPaymentHistory.addBorder(side: .bottom, color: #colorLiteral(red: 0.2352941176, green: 0.1568627451, blue: 0.3803921569, alpha: 1), width: 2)
//            }
//        }
//    }
    @IBOutlet weak var lblRedemptionAmount: UILabel!
    
    @IBOutlet weak var tblPaymentHistory: UITableView!{
        didSet{
            tblPaymentHistory.dataSource = self
            tblPaymentHistory.delegate = self
            tblPaymentHistory.tableFooterView = UIView()
            tblPaymentHistory.setRadius(10.0)
            tblPaymentHistory.separatorStyle = .none
            
        }
    }
    
    
   
    var walletDetail:WalletCls?
    var redeemObj:RedeemHistoryCLS?
    var redeemList = [RedeemHistoryCLS.RedeemList]()
    var paymentObj:PaymentHistoryCLS?
    var paymentList = [PaymentHistoryCLS.PaymentList]()
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var viewReedemRequest: UIView!
    @IBOutlet weak var lblOnHoldBalance: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalWidth = Double(Float(UIScreen.main.bounds.size.width * 3))
        
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Wallet".localized, action: #selector(onClickMenu(_:)))
        
        
        getWalletDetails()
        paymentObj = nil
        paymentList = [PaymentHistoryCLS.PaymentList]()
        getPaymentHistory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let button = UIButton()
        onClickPaymentHistory(button)
        setLanguage()
    }
    
    func setLanguage(){
        lblPaymentHistory.text = "PAYMENT HISTORY".localized
        lblRedeemptionHistory.text = "REDEEMPTION HISTORY".localized
        lblRedeemRequest.text = "REDEEM REQUEST".localized
        btnSend.setTitle("SEND".localized, for: .normal)
        btnDepositeAmount.setTitle("DEPOSITE AMOUNT", for: .normal)
        lblTotalAmountHead.text = "Total Amount".localized
        lblRedemptionAmount.text = "Redeemption Amount".localized
        lblOnHoldHead.text = "On Hold Balance".localized
    }
    
    func getWalletDetails(){
        let param = ["action":"getWalletInfo",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.getWallet(vc: self, param: param) { (dic) in
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            self.walletDetail = WalletCls(dictionary: data)
            self.lblAmount.text = currency + self.walletDetail!.creditAmount
            self.lblOnHoldBalance.text = currency + self.walletDetail!.holdAmount
            self.lblRedemptionAmount.text = currency + self.walletDetail!.redeemAmount
            self.getRedeemRequest()
        }
    }
    
    func getRedeemRequest(){
        
        let nextPage = (redeemObj?.pagination?.page ?? 0 ) + 1
        //UserData.shared.getUser()!.id
        let param = ["action":"redeem_request",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "page":nextPage] as [String : Any]
        
        Modal.shared.getWallet(vc: self, param: param) { (dic) in
            self.redeemObj = RedeemHistoryCLS(dictionary: dic)
            if self.redeemList.count > 0{
                self.redeemList += self.redeemObj!.redeemList
            }
            else{
                self.redeemList = self.redeemObj!.redeemList
            }
            self.tblRedemptionHistory.reloadData()
            
        }
    }
    
    func getPaymentHistory(){
        
        let nextPage = (paymentObj?.pagination?.page ?? 0 ) + 1
        //UserData.shared.getUser()!.id
        let param = ["action":"payment_history",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "page":nextPage] as [String : Any]
        
        Modal.shared.getWallet(vc: self, param: param) { (dic) in
            self.paymentObj = PaymentHistoryCLS(dictionary: dic)
            if self.paymentList.count > 0{
                self.paymentList += self.paymentObj!.paymentList
            }
            else{
                self.paymentList = self.paymentObj!.paymentList
            }
            self.tblPaymentHistory.reloadData()
        }
    }
    
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    @IBAction func onClickSend(_ sender: UIButton) {
        if txtAmount.text!.isEmpty{
            self.alert(title: "", message: "please enter amount".localized)
        }else{
            callSendRedeemRequest()
        }
    }
    
    func callSendRedeemRequest(){
        let param = ["action":"redeemRequest",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "amount":txtAmount.text!]
        
        Modal.shared.getWallet(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.txtAmount.text = ""
            })
        }
    }
    
    @IBAction func onClickRedeemRequest(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: self.viewReedemRequest.frame.origin.x, y: 0)
            , animated: true)
    }
    @IBAction func onClickRedemptionHistory(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: self.viewRedemptionHistory.frame.origin.x, y: 0)
            , animated: true)
    }
    
    @IBAction func onClickPaymentHistory(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func onClickDepositeAmount(_ sender: UIButton) {
        
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
extension MyWalletVC:UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
        //        print(scrollView.contentOffset.x)
        if scrollView.contentOffset.x == viewPaymentHistory.frame.origin.x {
            //            print("left")
            //  self.isSelectedBasicInfo = true
            
            paymentHistoryPoin.isHidden = false
            redemptionHistoryPoint.isHidden = true
            redeemRequestPoint.isHidden = true
            lblPaymentHistory.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblRedeemptionHistory.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
            lblRedeemRequest.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
            
        } else if scrollView.contentOffset.x == viewRedemptionHistory.frame.origin.x {
            paymentHistoryPoin.isHidden = true
            redemptionHistoryPoint.isHidden = false
            redeemRequestPoint.isHidden = true
            lblPaymentHistory.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
            lblRedeemptionHistory.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblRedeemRequest.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
        } else if scrollView.contentOffset.x == viewReedemRequest.frame.origin.x{
            paymentHistoryPoin.isHidden = true
            redemptionHistoryPoint.isHidden = true
            redeemRequestPoint.isHidden = false
            lblPaymentHistory.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
            lblRedeemptionHistory.textColor = #colorLiteral(red: 0.7568627451, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
            lblRedeemRequest.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        }
    }
    
    
    
}
extension MyWalletVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblPaymentHistory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentHistoryCell.identifier) as? PaymentHistoryCell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.selectionStyle = .none
            cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            let data:PaymentHistoryCLS.PaymentList?
            data = paymentList[indexPath.row]
            cell.lblAdminFees.text = currency + data!.adminFee
            cell.lblTotalAmount.text = currency + data!.amount
            cell.lblTransactionId.text =  data!.transactionId
            cell.lblTransactionIdHead.text
            = "TransactionId".localized
            cell.lblPaymentDateHead.text = "Payment Date".localized
            cell.lblAdminFeesHead.text = "Admin Fees".localized
            cell.lblPaymentDateHead.text = "Payment Date".localized
            cell.lblTotalAmountHead.text = "Total Amount".localized
            let array = data?.createdDate.components(separatedBy: " ")
            let str = array![0]
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let date = dateFormat.date(from: str)
            dateFormat.dateFormat = "MM/dd/yyyy"
            cell.lblPaymentDate.text = dateFormat.string(from: date!)
            cell.setRadius(10.0)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RedeemptionHistoryell.identifier) as? RedeemptionHistoryell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.selectionStyle = .none
            cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            let data:RedeemHistoryCLS.RedeemList?
            data = redeemList[indexPath.row]
            cell.lblStatus.text = data?.status
            cell.lblAdminFees.text = currency + data!.adminFee
            cell.lblReedemedDate.text = data?.redeemDate
            cell.lblRedeemedAmount.text = "$" + data!.redeemAmount
            cell.lblRequestedAmount.text = "$" + data!.amount
            cell.lblRequestedDate.text = data?.createdDate
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPaymentHistory{
            return paymentList.count
        }else{
            return redeemList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblPaymentHistory{
            if redeemList.count - 1 == indexPath.row &&
                (redeemObj!.pagination!.page < redeemObj!.pagination!.numPages) {
                self.getRedeemRequest()
            }
        }else{
            if paymentList.count - 1 == indexPath.row &&
                (paymentObj!.pagination!.page < paymentObj!.pagination!.numPages) {
                self.getPaymentHistory()
            }
        }
        
        
    }
    
}
