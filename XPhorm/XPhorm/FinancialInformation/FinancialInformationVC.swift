//
//  FinancialInformationVC.swift
//  XPhorm
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FinancialInformationVC: BaseViewController {
    
    static var storyboardInstance:FinancialInformationVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: FinancialInformationVC.identifier) as? FinancialInformationVC
    }
    @IBOutlet weak var btnCustomer: UIButton!
    @IBOutlet weak var btnTrainer: UIButton!
    @IBOutlet weak var scrollViewCustomer: UIScrollView!
    @IBOutlet weak var ScrollViewTrainer: UIScrollView!
    @IBOutlet weak var lblFinancialHistory: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    
    @IBOutlet weak var viewCommission: UIView!{
        didSet{
            viewCommission.setRadius(10.0)
            viewCommission.setGradientBackground(colorTop: #colorLiteral(red: 0.9098039216, green: 0.8980392157, blue: 0.6980392157, alpha: 1), colorBottom: #colorLiteral(red: 0.7333333333, green: 0.8784313725, blue: 0.7490196078, alpha: 1))
        }
    }
    @IBOutlet weak var viewEarnedDedction: UIView!{
        didSet{
            viewEarnedDedction.setRadius(10.0)
            viewEarnedDedction.setGradientBackground(colorTop: #colorLiteral(red: 0.968627451, green: 0.6588235294, blue: 0.3921568627, alpha: 1), colorBottom: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.7215686275, alpha: 1))
        }
    }
    @IBOutlet weak var viewCompletedService: UIView!{
        didSet{
            viewCompletedService.setRadius(10.0)
            viewCompletedService.setGradientBackground(colorTop: #colorLiteral(red: 0.9960784314, green: 0.831372549, blue: 0.7764705882, alpha: 1), colorBottom: #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.7529411765, alpha: 1))
        }
    }
    @IBOutlet weak var viewTotalEarned: UIView!{
        didSet{
            viewTotalEarned.setRadius(10.0)
            viewTotalEarned.setGradientBackground(colorTop: #colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5098039216, alpha: 1), colorBottom: #colorLiteral(red: 0.5843137255, green: 0.8862745098, blue: 0.7450980392, alpha: 1))
        }
    }
    
    @IBOutlet weak var tblHistory: UITableView!{
        didSet{
            tblHistory.dataSource = self
            tblHistory.delegate = self
            tblHistory.tableFooterView = UIView()
            tblHistory.setRadius(10.0)
            tblHistory.separatorStyle = .none
            tblHistory.register(FinancialInformationCell.nib, forCellReuseIdentifier: FinancialInformationCell.identifier)
            
        }
    }
    @IBOutlet weak var lblCommision: UILabel!
    @IBOutlet weak var lblEarnedDeduction: UILabel!
    @IBOutlet weak var lblCompletedService: UILabel!
    @IBOutlet weak var lblTotalearned: UILabel!
    @IBOutlet weak var lblCommisionHead: UILabel!
    @IBOutlet weak var lblTotalEarnedHead: UILabel!
    
    @IBOutlet weak var lblEarnedDeductionHead: UILabel!
    
    @IBOutlet weak var lblCompletedServiceHead: UILabel!

    @IBOutlet weak var lblCommissionCust: UILabel!
    @IBOutlet weak var lblTotalPaid: UILabel!
    
    @IBOutlet weak var lblPaidAfterCommission: UILabel!
    @IBOutlet weak var viewCompletedServiceCust: UIView!{
        didSet{
            viewCompletedServiceCust.setRadius(10.0)
            viewCompletedServiceCust.setGradientBackground(colorTop: #colorLiteral(red: 0.9960784314, green: 0.831372549, blue: 0.7764705882, alpha: 1), colorBottom: #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.7529411765, alpha: 1))
        }
    }
    @IBOutlet weak var viewPaidAfterCommission: UIView!{
        didSet{
            viewPaidAfterCommission.setRadius(10.0)
            viewPaidAfterCommission.setGradientBackground(colorTop: #colorLiteral(red: 0.968627451, green: 0.6588235294, blue: 0.3921568627, alpha: 1), colorBottom: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.7215686275, alpha: 1))
        }
    }
    
    @IBOutlet weak var viewTotalPaid: UIView!{
        didSet{
            viewTotalPaid.setRadius(10.0)
            viewTotalPaid.setGradientBackground(colorTop: #colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5098039216, alpha: 1), colorBottom: #colorLiteral(red: 0.5843137255, green: 0.8862745098, blue: 0.7450980392, alpha: 1))
        }
    }
    @IBOutlet weak var lblCompletedServiceCust: UILabel!
    @IBOutlet weak var tblHistoryCust: UITableView!{
        didSet{
            tblHistoryCust.dataSource = self
            tblHistoryCust.delegate = self
            tblHistoryCust.tableFooterView = UIView()
            tblHistoryCust.setRadius(10.0)
            tblHistoryCust.separatorStyle = .none
            tblHistoryCust.register(FinancialInformationCell.nib, forCellReuseIdentifier: FinancialInformationCell.identifier)
            
        }
    }
    @IBOutlet weak var viewCommissionCust: UIView!{
        didSet{
            viewCommissionCust.setRadius(10.0)
            viewCommissionCust.setGradientBackground(colorTop: #colorLiteral(red: 0.9098039216, green: 0.8980392157, blue: 0.6980392157, alpha: 1), colorBottom: #colorLiteral(red: 0.7333333333, green: 0.8784313725, blue: 0.7490196078, alpha: 1))
        }
    }
    @IBOutlet weak var custHistoryConst: NSLayoutConstraint!
    
    @IBOutlet weak var historyConst: NSLayoutConstraint!
    
    var financialObj:FinancialInfoCls?
    var infoList = [FinancialInfoCls.InfoList]()
    var financialCustObj:FinancialInfoCls?
    var infoListCust = [FinancialInfoCls.InfoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Financial Information".localized, action: #selector(onClickBack(_:)))
        
        getFinancialInfo()
      
        onClickTrainer(btnTrainer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblCommisionHead.text = "Commission".localized
        lblTotalEarnedHead.text = "Total Earned".localized
        lblEarnedDeductionHead.text = "Earned After Deduction".localized
        lblCompletedServiceHead.text = "Completed Service".localized
        lblSummary.text = "Summary".localized
        lblFinancialHistory.text = "Financial History".localized
         self.getFinancialInfoCustomer()
        
    }
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getFinancialInfoCustomer(){
        
        let nextPage = (Int(financialCustObj?.pagination?.page ?? "") ?? 0 ) + 1
        
        let param = ["action":"getCustomerFinancialInfo",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getFinancialInfo(vc: self, param: param) { (dic) in
            self.financialCustObj = FinancialInfoCls(dictionary: dic)
            if self.infoListCust.count > 0{
                self.infoListCust += self.financialCustObj!.infoList
            }
            else{
                self.infoListCust = self.financialCustObj!.infoList
            }
            self.tblHistoryCust.reloadData()
            self.custHistoryConst.constant = self.tblHistoryCust.contentSize.height
            self.displayDataCust(data:self.financialCustObj!)
        }
        
    }
    
    
    func getFinancialInfo(){
        
        let nextPage = (Int(financialObj?.pagination?.page ?? "") ?? 0 ) + 1
        
        let param = ["action":"getFinancialInfo",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getFinancialInfo(vc: self, param: param) { (dic) in
            self.financialObj = FinancialInfoCls(dictionary: dic)
            if self.infoList.count > 0{
                self.infoList += self.financialObj!.infoList
            }
            else{
                self.infoList = self.financialObj!.infoList
            }
            self.tblHistory.reloadData()
            self.historyConst.constant = self.tblHistory.contentSize.height
            self.displayData(data:self.financialObj!)
            
        }
       
        
        
    }
    
    func displayDataCust(data:FinancialInfoCls){
        lblTotalPaid.text = currency + data.summary!.customer!.totalPaid
        lblCompletedServiceCust.text = data.summary!.customer!.totalCustCompletedService
        lblPaidAfterCommission.text = "\(currency)\(data.summary!.customer!.totalNetPaid)"
        lblCommissionCust.text = currency + data.summary!.customer!.totalCustomerCommission
    }
    
    func displayData(data:FinancialInfoCls){
        lblTotalearned.text = currency + data.summary!.trainer!.totalEarned
        lblCompletedService.text = data.summary!.trainer!.totalCompletedService
        lblEarnedDeduction.text = "\(currency)\(data.summary!.trainer!.totalNetEarned)"
        lblCommision.text = currency + data.summary!.trainer!.totalCommission
    }
    
    @IBAction func onClickTrainer(_ sender: UIButton) {
        ScrollViewTrainer.isHidden = false
        scrollViewCustomer.isHidden = true
        btnTrainer.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
        btnCustomer.addBorder(side: .bottom, color:#colorLiteral(red: 0.7128818631, green: 0.72026366, blue: 0.7337059379, alpha: 1), width: 2)
    }
    
    @IBAction func onClickCustomer(_ sender: UIButton) {
        ScrollViewTrainer.isHidden = true
        scrollViewCustomer.isHidden = false
        btnCustomer.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
        btnTrainer.addBorder(side: .bottom, color:#colorLiteral(red: 0.7128818631, green: 0.72026366, blue: 0.7337059379, alpha: 1), width: 2)
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
extension FinancialInformationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblHistory {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FinancialInformationCell.identifier) as? FinancialInformationCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
        cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
        cell.viewContainer.setRadius(8.0)
        let data:FinancialInfoCls.InfoList?
        data = infoList[indexPath.row]
        cell.lblName.text = data!.firstName  + " " + data!.lastName
       
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: data?.endDate ?? "")
            dateFormatter.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateFormatter.string(from: date!)
        cell.lblTransactionId.text = data?.transactionId
        cell.lblLocation.text = data?.location
        cell.lblPrice.text = currency + data!.totalAmount
            
            if data?.status == "c" {
                cell.lblStatus.text = "Completed"
            }else  if data?.status == "r"{
                cell.lblStatus.text = "Rejected"
            }else  if data?.status == "cds" || data?.status == "cdo"{
                cell.lblStatus.text = "Cancelled"
            }
         cell.lblCategory.text = data?.categoryName
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FinancialInformationCell.identifier) as? FinancialInformationCell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.selectionStyle = .none
            cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            cell.viewContainer.setRadius(8.0)
            let data:FinancialInfoCls.InfoList?
            data = infoListCust[indexPath.row]
            cell.lblName.text = data!.firstName  + " " + data!.lastName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: data?.endDate ?? "")
            dateFormatter.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateFormatter.string(from: date!)
            cell.lblTransactionId.text = data?.transactionId
            cell.lblLocation.text = data?.location
            cell.lblPrice.text = currency + data!.totalAmount
            if data?.status == "c"{
                cell.lblStatus.text = "Completed"
            }else  if data?.status == "r"{
                cell.lblStatus.text = "Rejected"
            }else  if data?.status == "cds"  || data?.status == "cdo"{
                cell.lblStatus.text = "Cancelled"
            }
            cell.lblCategory.text = data?.categoryName
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblHistory {
        return infoList.count
        }else{
            return infoListCust.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblHistory {
            self.historyConst.constant = self.tblHistory.contentSize.height
            if infoList.count - 1 == indexPath.row &&
                (Int(financialObj!.pagination!.page) ?? 0 < financialObj!.pagination!.numPages) {
               self.getFinancialInfo()
            }
        }else if tableView == tblHistoryCust {
            self.custHistoryConst.constant = self.tblHistoryCust.contentSize.height
            if infoListCust.count - 1 == indexPath.row &&
                (Int(financialCustObj!.pagination!.page) ?? 0 < financialCustObj!.pagination!.numPages) {
                self.getFinancialInfoCustomer()
            }
        }
        
    }
    
}
