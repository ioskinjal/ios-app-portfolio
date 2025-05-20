//
//  ReceivedRequestVC.swift
//  XPhorm
//
//  Created by admin on 6/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReceivedRequestVC: BaseViewController {
    
    static var storyboardInstance:ReceivedRequestVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ReceivedRequestVC.identifier) as? ReceivedRequestVC
    }
    @IBOutlet weak var viewReject: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
            searchBar.setRadius(8.0)
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var txtReason: UITextView!{
        didSet{
          txtReason.placeholder = "Reason"
            txtReason.border(side: .all, color: #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
        }
    }
    
    @IBOutlet weak var tblAns: UITableView!{
        didSet{
            tblAns.dataSource = self
            tblAns.delegate = self
            tblAns.tableFooterView = UIView()
            tblAns.separatorStyle = .none
            //tblQuestion.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
           
        }
    }
    @IBOutlet weak var viewAns: UIView!
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnCancelReject: SignInButton!
    @IBOutlet weak var lblRejectService: UILabel!
    @IBOutlet weak var tblRequest: UITableView!{
        didSet{
            tblRequest.dataSource = self
            tblRequest.delegate = self
            tblRequest.tableFooterView = UIView()
            tblRequest.separatorStyle = .none
            
        }
    }
    
    var receivedList = [SentRequestCls.RequestList]()
    var receiveObj: SentRequestCls?
    var selectedId = ""
    var ansList = [QuestionList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Received Service Request".localized, action: #selector(onClickMenu(_:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // AppHelper.hideLoadingView()
        receivedList = [SentRequestCls.RequestList]()
        receiveObj = nil
        getReceivedService(searchText: searchBar.text ?? "")
    }
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onclickCloseReject(_ sender: Any) {
        self.viewReject.isHidden = true
        self.navigationBar.isHidden = false
    }
    
    @IBAction func onClickCloseAns(_ sender: UIButton) {
        self.viewAns.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickReject(_ sender: Any) {
        if txtReason.text.isEmpty{
            self.alert(title: "", message: "please enter reason to reject service")
        }else{
        
        let param = ["action":"rejectRequest",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "reason":txtReason.text!,
                     "id":selectedId]
        
        Modal.shared.receivedRequest(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.receivedList = [SentRequestCls.RequestList]()
                self.receiveObj = nil;
                self.viewReject.isHidden = true
                self.navigationBar.isHidden = false
                self.getReceivedService(searchText: self.searchBar.text ?? "")
            })
        }
        }
        
    }
    @IBAction func onClickCancelreject(_ sender: Any) {
        self.viewReject.isHidden = true
        self.navigationBar.isHidden = false
    }
    @objc func onClickImage(_ sender:UIButton){
        
    }
    
    
    func getReceivedService(searchText:String){
        
        let nextPage = (receiveObj?.pagination?.page ?? 0 ) + 1
        
        
        let param = ["action":"getReceivedServiceList",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage,
                     "keyword":searchBar.text!] as [String : Any]
        
        Modal.shared.receivedRequest(vc: self, param: param) { (dic) in
            self.receiveObj = SentRequestCls(dictionary: dic)
            if self.receivedList.count > 0{
                self.receivedList += self.receiveObj!.requestList
            }
            else{
                self.receivedList = self.receiveObj!.requestList
            }
            self.tblRequest.reloadData()
        }
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
extension ReceivedRequestVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblAns{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayAnswCell.identifier) as? DisplayAnswCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.lblQuestion.text = ansList[indexPath.row].question
            cell.lblAns.text = ansList[indexPath.row].answer
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedReqCell.identifier) as? ReceivedReqCell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.selectionStyle = .none
            cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            cell.viewContainer.setRadius(10.0)
            let data:SentRequestCls.RequestList?
            data = receivedList[indexPath.row]
            cell.lblName.text = data?.categoryName
            cell.lblPrice.text = currency + data!.totalAmount
            cell.lblAdditionalInfo.text = currency + data!.additionalDogRate
            cell.lblLocation.text = data?.location
            cell.lblAdminFees.text = currency + data!.adminFee
            cell.lblServiceChanges.text = currency + data!.serviceCharge
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: data!.toDate)
            let dateFrom = dateFormatter.date(from: data!.fromDate)
             dateFormatter.dateFormat = "MM/dd/yyyy"
            cell.lblStartTime.text = dateFormatter.string(from: date!) + ", " + data!.fromTime
            cell.lblEndTime.text = dateFormatter.string(from: dateFrom!) + ", " + data!.toTime
            cell.imgRequest.downLoadImage(url: data!.userProfileImg)
            cell.lblRequestName.text = data?.firstName
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(onClickViewAns(_:)), for: .touchUpInside)
            if data?.extraStatus == "pending"{
                cell.lblStatus.text = "PENDING"
                cell.lblStatus.textColor = #colorLiteral(red: 0.8431372549, green: 0.5568627451, blue: 0.06274509804, alpha: 1)
            }else if data?.extraStatus == "accepted"{
                cell.lblStatus.text = "ACCEPTED"
                cell.lblStatus.textColor = #colorLiteral(red: 0.04963340216, green: 0.5568627451, blue: 0.06274509804, alpha: 1)
            }else if data?.extraStatus == "completed"{
                cell.lblStatus.text = "COMPLETED"
                cell.lblStatus.textColor = #colorLiteral(red: 0.04963340216, green: 0.5568627451, blue: 0.06274509804, alpha: 1)
            }else if data?.extraStatus == "rejected"{
                cell.lblStatus.text = "REJECTED"
                cell.lblStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }else if data?.extraStatus == "running"{
                cell.lblStatus.text = "Running"
                cell.lblStatus.textColor = #colorLiteral(red: 0.8431372549, green: 0.5568627451, blue: 0.06274509804, alpha: 1)
            }else if data?.extraStatus == "cancelled"{
                cell.lblStatus.text = "Cancelled"
                cell.lblStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }else if data?.extraStatus == "booked"{
                cell.lblStatus.text = "Booked"
                cell.lblStatus.textColor = #colorLiteral(red: 0.04963340216, green: 0.5568627451, blue: 0.06274509804, alpha: 1)
            }
            
            if data?.extraStatus == "pending"{
                cell.btnActive.isHidden = false
                cell.btnReject.isHidden = false
            }else{
                cell.btnActive.isHidden = true
                cell.btnReject.isHidden = true
            }
            
            if data?.isAnswers == "false"{
                cell.btnView.isHidden = true
            }else{
                cell.btnView.isHidden = false
            }
            
            if data?.extraStatus == "running"{
                cell.btnComplete.isHidden = false
                cell.btnComplete.tag = indexPath.row
                cell.btnComplete.addTarget(self, action: #selector(onClickComplete(_:)), for: .touchUpInside)
                
            }else{
                cell.btnComplete.isHidden = true
            }
            
            // cell.lblUsername.text = data?.firstName
            if data?.isPaid == "n"{
                cell.btnMsg.isHidden = true
            }else{
                cell.btnMsg.isHidden = false
                cell.btnMsg.tag = indexPath.row
                cell.btnMsg.addTarget(self, action: #selector(onClickSend(_:)), for: .touchUpInside)
            }
            cell.btnActive.tag = indexPath.row
            cell.btnActive.addTarget(self, action: #selector(onClickAccept(_:)), for: .touchUpInside)
            // cell.btnView.tag = indexPath.row
            // cell.btnView.addTarget(self, action: #selector(onClickView(_:)), for: .touchUpInside)
            cell.btnReject.tag = indexPath.row
            cell.btnReject.addTarget(self, action: #selector(onClickRejectFromCell(_:)), for: .touchUpInside)
            if data?.isPaid == "y" && data?.paymentURL != ""{
                cell.btnCancel.isHidden = false
                cell.btnCancel.tag = indexPath.row
                cell.btnCancel.addTarget(self, action: #selector(onClickCancel(_:)), for: .touchUpInside)
            }else{
                cell.btnCancel.isHidden = true
            }
            return cell
            
        }
    }
    
    @objc func onClickViewAns(_ sender:UIButton){
        let param = ["action":"getServiceAnswers",
        "requestId":receivedList[sender.tag].requestId,
        "serviceId":receivedList[sender.tag].id,
        "userId":receivedList[sender.tag].userId,
        "lId":UserData.shared.getLanguage]
        
        Modal.shared.receivedRequest(vc: self, param: param) { (dic) in
            self.ansList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            self.tblAns.reloadData()
            self.viewAns.isHidden = false
            self.tblAns.reloadData()
            self.navigationBar.isHidden = true
        }
    }
    
    @objc func onClickComplete(_ sender:UIButton){
        let param = ["action":"updateServiceAction",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "serviceaction":"complete",
        "id":receivedList[sender.tag].requestId]
        
        Modal.shared.receivedRequest(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.receivedList = [SentRequestCls.RequestList]()
                self.receiveObj = nil
                self.getReceivedService(searchText: "")
            })
        }
    }
    
    @objc func onClickCancel(_ sender:UIButton){
        let vc = PaypalPaymentVC.storyboardInstance!
        vc.paypalUrl = receivedList[sender.tag].paymentURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onClickView(_ sender:UIButton){
        let nextVC = ServiceDetailVC.storyboardInstance!
        nextVC.service_id = receivedList[sender.tag].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickAccept(_ sender:UIButton){
        let param = ["action":"updateServiceAction",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "serviceaction":"accept",
        "id":receivedList[sender.tag].requestId]
        
        Modal.shared.receivedRequest(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.receivedList = [SentRequestCls.RequestList]()
                self.receiveObj = nil;
                self.getReceivedService(searchText: self.searchBar.text ?? "")
            })
        }
    }
    
    @objc func onClickRejectFromCell(_ sender:UIButton){
        
        self.viewReject.isHidden = false
        self.navigationBar.isHidden = true
        selectedId = receivedList[sender.tag].requestId
        
    }
    
    @objc func onClickSend(_ sender:UIButton){
        let nextVC = ChatVC.storyboardInstance!
        nextVC.receiver_id = receivedList[sender.tag].userId
         nextVC.navTitle = receivedList[sender.tag].firstName
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAns{
         return ansList.count
        }else{
            return receivedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ServiceDetailVC.storyboardInstance!
        nextVC.service_id = receivedList[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
                if receivedList.count - 1 == indexPath.row &&
                    (receiveObj!.pagination!.page > receiveObj!.pagination!.numPages) {
                    self.getReceivedService(searchText: searchBar.text ?? "")
                }
    }
}

extension ReceivedRequestVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.receivedList = [SentRequestCls.RequestList]()
        self.receiveObj = nil
        getReceivedService(searchText: searchBar.text ?? "")
    }
}
