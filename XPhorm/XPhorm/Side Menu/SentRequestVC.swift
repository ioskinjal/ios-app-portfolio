//
//  SentRequestVC.swift
//  XPhorm
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class SentRequestVC: BaseViewController {

    static var storyboardInstance:SentRequestVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: SentRequestVC.identifier) as? SentRequestVC
    }
    
    @IBOutlet weak var btnAddrEviewCancel: UIButton!
    @IBOutlet weak var btnAddReviewSave: SignInButton!
    @IBOutlet weak var lblAddReviewRate: CosmosView!
    @IBOutlet weak var txtAddReviewDesc: UITextView!{
        didSet{
            txtAddReviewDesc.border(side: .all, color: #colorLiteral(red: 0.9137254902, green: 0.9176470588, blue: 0.9019607843, alpha: 1), borderWidth: 1.0)
            txtAddReviewDesc.setRadius(8.0)
        }
    }
    @IBOutlet weak var lblAddReview: UILabel!
    @IBOutlet weak var viewAddReview: UIView!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
            searchBar.setRadius(8.0)
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tblRequest: UITableView!{
        didSet{
            tblRequest.dataSource = self
            tblRequest.delegate = self
            tblRequest.tableFooterView = UIView()
            tblRequest.separatorStyle = .none
            
        }
    }
   
    var selectedRequest_id = ""
    var toUser_id = ""
    var service_id = ""
    var requestList = [SentRequestCls.RequestList]()
    var requestObj: SentRequestCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sent Service Request".localized, action: #selector(onClickMenu(_:)))
        getSentService(searchText:searchBar.text ?? "")

    }
    override func viewWillAppear(_ animated: Bool) {
       // AppHelper.hideLoadingView()
        requestList = [SentRequestCls.RequestList]()
        requestObj = nil
        getSentService(searchText: searchBar.text ?? "")
        self.lblAddReview.text = "Add Review".localized
        self.txtAddReviewDesc.placeholder = "Descprition".localized
        self.btnAddReviewSave.setTitle("SAVE".localized, for: .normal)
        self.btnAddrEviewCancel.setTitle("CANCEL".localized, for: .normal)
    }
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    
    func getSentService(searchText:String){
        
        let nextPage = (requestObj?.pagination?.page ?? 0 ) + 1
        
        
        let param = ["action":"getSentServiceRequest",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "pageNo":nextPage] as [String : Any]
        
        Modal.shared.sentRequest(vc: self, param: param) { (dic) in
            self.requestObj = SentRequestCls(dictionary: dic)
            if self.requestList.count > 0{
                self.requestList += self.requestObj!.requestList
            }
            else{
                self.requestList = self.requestObj!.requestList
            }
            self.tblRequest.reloadData()
        }
    }

    @IBAction func onClickSaveAddReview(_ sender: Any) {
        if lblAddReviewRate.rating == 0.0{
            self.alert(title: "", message: "please select review".localized)
        }else if txtAddReviewDesc.text.isEmpty{
            self.alert(title: "", message: "please enter review description".localized)
        }else{
            let param = ["action":"addReview",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "score":Int(lblAddReviewRate.rating),
            "description":txtAddReviewDesc.text!,
            "toUserId":toUser_id,
            "serviceId":service_id,
            "requestId":selectedRequest_id] as [String : Any]
            
            Modal.shared.sentRequest(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.requestList = [SentRequestCls.RequestList]()
                    self.requestObj = nil
                    self.getSentService(searchText: self.searchBar.text ?? "")
                })
            }
        }
        self.viewAddReview.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickCancelAddReview(_ sender: Any) {
        self.viewAddReview.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickCloseAddReview(_ sender: Any) {
        self.viewAddReview.isHidden = true
        self.navigationBar.isHidden = false
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
extension SentRequestVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedReqCell.identifier) as? ReceivedReqCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
        cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
        cell.viewContainer.setRadius(10.0)
        let data:SentRequestCls.RequestList?
        data = requestList[indexPath.row]
        cell.lblName.text = data?.categoryName
        cell.lblPrice.text = currency + data!.totalAmount
        //cell.lblAdditionalInfo.text = currency + data!.additionalDogRate
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
        
        if data?.extraStatus == "cancelled"{
            cell.btnView.isHidden = true
        }else{
            cell.btnView.isHidden = false
        }
        if data?.extraStatus == "running"{
            cell.btnComplete.isHidden = false
            cell.btnComplete.tag = indexPath.row
            cell.btnComplete.setTitle("COMPLETE".localized, for: .normal)
            cell.btnComplete.addTarget(self, action: #selector(onClickComplete(_:)), for: .touchUpInside)
        }else if data?.isReview == "n" && data?.extraStatus == "completed"{
            cell.btnComplete.isHidden = false
            cell.btnComplete.tag = indexPath.row
            cell.btnComplete.setTitle("Add Review".localized, for: .normal)
            cell.btnComplete.addTarget(self, action: #selector(onClickComplete(_:)), for: .touchUpInside)
        }else{
            cell.btnComplete.isHidden = true
        }
        if data?.isPaid == "n" && data?.extraStatus == "accepted"{
            cell.btnPaynow.isHidden = false
            cell.btnPaynow.tag = indexPath.row
            cell.btnPaynow.addTarget(self, action: #selector(onClickPayNow(_:)), for: .touchUpInside)
        }else if data?.isPaid == "y" && data?.extraStatus == "booked"{
           cell.btnPaynow.setTitle("Cancel Request".localized, for: .normal)
            cell.btnPaynow.tag = indexPath.row
            cell.btnPaynow.addTarget(self, action: #selector(onClickPayNow(_:)), for: .touchUpInside)
        }else{
             cell.btnPaynow.isHidden = true
        }
        
        cell.btnView.addTarget(self, action: #selector(onclickDownload(_:)), for: .touchUpInside)
        cell.lblUsername.text = data?.firstName
        cell.btnMsg.tag = indexPath.row
        cell.btnMsg.addTarget(self, action: #selector(onClickSend(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func onClickComplete(_ sender:UIButton){
        if sender.titleLabel?.text == "Add Review"{
            self.viewAddReview.isHidden = false
            self.navigationBar.isHidden = true
        self.selectedRequest_id = requestList[sender.tag].requestId
        self.toUser_id = requestList[sender.tag].userId
        self.service_id = requestList[sender.tag].id
        }else{
        let param = ["action":"updateServiceAction",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "serviceaction":"complete",
        "id":requestList[sender.tag].requestId]
        
        Modal.shared.sentRequest(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.requestList = [SentRequestCls.RequestList]()
                self.requestObj = nil
                self.getSentService(searchText: self.searchBar.text ?? "")
            })
        }
        }
    }
    
    @objc func onclickDownload(_ sender:UIButton){
        
        let param = ["action":"downloadInvoice",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "id":requestList[sender.tag].requestId]
        
        Modal.shared.sentRequest(vc: self, param: param) { (dic) in
            let data = ResponseKey.fatchDataAsDictionary(res: dic, valueOf: .data)
            let url = data["fileName"] as? String ?? ""
            if !url.isBlank{
                        if let url = URL(string: url) {
                            Downloader.loadFileAsync(url: url) { (downloadedURL, error) in
                                if error == nil {
                                    print("message : \((downloadedURL ?? ""))")
                                } else {
                                    print("error : \((error?.localizedDescription ?? ""))")
                                }
                            }
                        }
                }
            else{
                print("No URL found")
            }
            
        }
    }
    
    @objc func onClickPayNow(_ sender:UIButton){
        if sender.titleLabel?.text == "Cancel Request".localized{
            let param = ["action":"updateServiceAction",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "serviceaction":"cancel",
            "id":requestList[sender.tag].requestId]
            
            Modal.shared.sentRequest(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.requestList = [SentRequestCls.RequestList]()
                    self.requestObj = nil
                    self.getSentService(searchText: self.searchBar.text ?? "")
                })
            }
        }else{
        let vc = PaypalPaymentVC.storyboardInstance!
        vc.paypalUrl = requestList[sender.tag].paymentURL
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onClickSend(_ sender:UIButton){
        let nextVC = ChatVC.storyboardInstance!
        nextVC.receiver_id = requestList[sender.tag].userId
        nextVC.navTitle = requestList[sender.tag].firstName
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return requestList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ServiceDetailVC.storyboardInstance!
        nextVC.service_id = requestList[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
                if requestList.count - 1 == indexPath.row &&
                    (requestObj!.pagination!.page > requestObj!.pagination!.numPages) {
                    self.getSentService(searchText: searchBar.text ?? "")
                }
    }
}
extension SentRequestVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.requestList = [SentRequestCls.RequestList]()
        self.requestObj = nil
        getSentService(searchText: searchBar.text ?? "")
    }
}
