//
//  QuotePlacedVC.swift
//  ThumbPin
//
//  Created by NCT109 on 10/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class QuotePlacedVC: BaseViewController {

    @IBOutlet weak var labelQuotePlaced: UILabel!
    @IBOutlet weak var tblvwQuote: UITableView!{
        didSet{
            tblvwQuote.delegate = self
            tblvwQuote.dataSource = self
            tblvwQuote.register(QuotePlacedCell.nib, forCellReuseIdentifier: QuotePlacedCell.identifier)
            tblvwQuote.rowHeight  = UITableViewAutomaticDimension
            tblvwQuote.estimatedRowHeight = 260
            tblvwQuote.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:QuotePlacedVC? {
        return StoryBoard.serviceNotifications.instantiateViewController(withIdentifier: QuotePlacedVC.identifier) as? QuotePlacedVC
    }
    var pageNo = 1
    var quotePlaced = QuotePlacedList()
    var arrQuoted = [QuotePlacedList.QuitaPlaced]()
    var selectedStatus = ""
    var deleteQuoteID : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            pageNo = 1
            callApiGetQuotePlaced(selectedStatus)
        }else {
            print("No! internet is available.")
            pageNo = 1
            let dict = retrieveFromJsonFile()
            self.arrQuoted = ResponseKey.fatchData(res: dict, valueOf: .service_notification).ary.map({QuotePlacedList.QuitaPlaced(dic: $0 as! [String:Any])})
            self.tblvwQuote.reloadData()
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetQuotePlaced(_ status: String) {
        let dictParam = [
            "action": Action.getQuotePlaced,
            "lId": UserData.shared.getLanguage,
            "status": status,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getQuoetdPlaced(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.quotePlaced = QuotePlacedList(dic: dict)
            if self.pageNo > 1 {
                self.arrQuoted.append(contentsOf: self.quotePlaced.arrQuotePlaced)
            }else {
                self.arrQuoted.removeAll()
                self.arrQuoted = self.quotePlaced.arrQuotePlaced
            }
            if self.arrQuoted.count == 0{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.tblvwQuote.backgroundView = bgImage
            }
            self.tblvwQuote.reloadData()
        }
    }
    func callApiDeleteQuoted(_ quotesId: String) {
        let dictParam = [
            "action": Action.deleteQuote,
            "lId": UserData.shared.getLanguage,
            "quotes_id": quotesId,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getServiceNotifications(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.arrQuoted.remove(at: self.deleteQuoteID)
            self.tblvwQuote.reloadData()
        }
    }
    func setUpLang() {
        labelQuotePlaced.text = localizedString(key: "Quote Placed")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func pressButtonDeleteQuoted(_ sender: UIButton) {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: localizedString(key: "Are you sure you want to delete quote?"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localizedString(key: "NO"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "YES"), style: .default, handler: { _ in
            self.deleteQuoteID = sender.tag
            self.callApiDeleteQuoted(self.arrQuoted[sender.tag].quotes_id)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func pressButtonMessage(_ sender: UIButton) {
        let vc = ChatVC.storyboardInstance!
        vc.quotesId = arrQuoted[sender.tag].quotes_id
        vc.serviceID = Int(arrQuoted[sender.tag].service_id) ?? 0
        vc.customerId = arrQuoted[sender.tag].customer_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapToShowProfile(sender:UITapGestureRecognizer) {
        let point = sender.view
        let mainCell = point?.superview
        let main = mainCell?.superview
        let stack = main?.superview
        let stack1 = stack?.superview
        let cell: QuotePlacedCell = stack1 as! QuotePlacedCell
        let indexPath = tblvwQuote.indexPath(for: cell)
        let index = indexPath?.row ?? 0
        print(index)
        let vc = ProfileVC.storyboardInstance!
        vc.userIdFromProvider = arrQuoted[index].customer_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Button Action
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOpenAction(_ sender: UIButton) {
        selectedStatus = "open"
        pageNo = 1
        callApiGetQuotePlaced(selectedStatus)
    }
    @IBAction func btnHiredAction(_ sender: UIButton) {
        selectedStatus = "hired"
        pageNo = 1
        callApiGetQuotePlaced(selectedStatus)
    }
    
}
extension QuotePlacedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuotePlacedCell.identifier) as? QuotePlacedCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelServiceName.text = arrQuoted[indexPath.row].service_name
        cell.labelBudget.text = arrQuoted[indexPath.row].service_budget
        cell.labelCustomername.text = arrQuoted[indexPath.row].customer_name
        cell.labelLocation.text = arrQuoted[indexPath.row].service_location
        cell.labelCategory.text = arrQuoted[indexPath.row].service_category
        cell.labelSubCategory.text = arrQuoted[indexPath.row].service_sub_category
        cell.labelTime.text = arrQuoted[indexPath.row].service_posted_time
        cell.btnStatus.setTitle("  \(arrQuoted[indexPath.row].service_status)  ", for: .normal)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.pressButtonDeleteQuoted(_:)), for: .touchUpInside)
        cell.btnMessage.tag = indexPath.row
        cell.btnMessage.addTarget(self, action: #selector(self.pressButtonMessage(_:)), for: .touchUpInside)
        cell.tap = UITapGestureRecognizer(target: self, action: #selector(QuotePlacedVC.tapToShowProfile))
        cell.labelCustomername.isUserInteractionEnabled = true
        cell.labelCustomername.addGestureRecognizer(cell.tap)
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        for i in 0..<arrQuoted[indexPath.row].material.count{
            if cell.lblMaterialName.text == ""{
                cell.lblMaterialName.text = arrQuoted[indexPath.row].material[i].material_name
            }else{
                cell.lblMaterialName.text = cell.lblMaterialName.text ?? "" + "," + arrQuoted[indexPath.row].material[i].material_name
            }
        }
        cell.lblDeliveryDays.text = arrQuoted[indexPath.row].delivery_days
        cell.lbluotesAmount.text = arrQuoted[indexPath.row].amount
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuoted.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestDetailVC.storyboardInstance!
        vc.serviceId = arrQuoted[indexPath.row].service_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrQuoted.count - 1
        let page = quotePlaced.pagination.current_page
        let numPages = quotePlaced.pagination.total_pages
        let totalRecords = quotePlaced.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiGetQuotePlaced(selectedStatus)
        }
    }
}
