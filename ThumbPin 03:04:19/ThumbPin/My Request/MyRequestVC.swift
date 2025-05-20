//
//  MyRequestVC.swift
//  ThumbPin
//
//  Created by NCT109 on 21/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import SDWebImage

class MyRequestVC: BaseViewController {
    
    @IBOutlet weak var btnRequestNewService: UIButton!{
        didSet {
            btnRequestNewService.createCorenerRadiusButton()
        }
    }
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tblvwRequest: UITableView!{
        didSet{
            tblvwRequest.delegate = self
            tblvwRequest.dataSource = self
            tblvwRequest.register(MyRequestCell.nib, forCellReuseIdentifier: MyRequestCell.identifier)
            tblvwRequest.rowHeight  = UITableViewAutomaticDimension
            tblvwRequest.estimatedRowHeight = 123
            tblvwRequest.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:MyRequestVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: MyRequestVC.identifier) as? MyRequestVC
    }
    var myRequest = MyRequest()
    var arrMyrequest = [MyRequest.MyRequestData]()
    var pageNo = 0
    var serviceId = Int()
    var isPush = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        if isPush == "1" {
            let vc = RequestDetailVC.storyboardInstance!
            vc.serviceId = "\(serviceId)"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            if isPush == "0" {
                pageNo = 1
                self.myRequest = MyRequest()
                self.arrMyrequest = [MyRequest.MyRequestData]()
                callApiMyServiceList()
            }
            isPush = "0"
        }else {
            print("No! internet is available.")
            pageNo = 1
            let dict = retrieveFromJsonFile()
            self.arrMyrequest = ResponseKey.fatchData(res: dict, valueOf: .my_request).ary.map({MyRequest.MyRequestData(dic: $0 as! [String:Any])})
            self.tblvwRequest.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "My Request")
    }
    
    func callApiMyServiceList() {
        let dictParam = [
            "action": Action.getProject,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getMyServiceList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            
            self.myRequest = MyRequest(dic: dict)
            if self.arrMyrequest.count > 0 {
                self.arrMyrequest.append(contentsOf: self.myRequest.arrMyRequest)
            }else {
                self.arrMyrequest.removeAll()
                self.arrMyrequest = self.myRequest.arrMyRequest
            }
            self.tblvwRequest.reloadData()
        }
    }
    func callApiReopenService(_ service_id: String) {
        let dictParam = [
            "action": Action.reponeService,
            "user_id": UserData.shared.getUser()!.user_id,
            "lId": UserData.shared.getLanguage,
            "service_id": service_id,
        ] as [String : Any]
        ApiCaller.shared.getMyServiceList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.pageNo = 1
            self.myRequest = MyRequest()
            self.arrMyrequest = [MyRequest.MyRequestData]()
            self.callApiMyServiceList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @objc func pressButtonReOpen(_ sender: UIButton) {
        callApiReopenService(arrMyrequest[sender.tag].service_id)
    }
    @objc func pressButtonUpdate(_ sender: UIButton) {
        let vc = UpdateRequestVC.storyboardInstance!
        vc.serviceId = arrMyrequest[sender.tag].service_id
        vc.serviceName = arrMyrequest[sender.tag].service_name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRequestNewServiceAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ExploreCategoryVC.storyboardInstance!, animated: true)
    }
}
extension MyRequestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRequestCell.identifier) as? MyRequestCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelname.text = "\(arrMyrequest[indexPath.row].service_name)"
        if !arrMyrequest[indexPath.row].disp_text.isEmpty {
            cell.labelname.text = "\(arrMyrequest[indexPath.row].service_name)(\(arrMyrequest[indexPath.row].disp_text))"
        }
        cell.labelDate.text = arrMyrequest[indexPath.row].project_date
        cell.labelServiceStatus.text = arrMyrequest[indexPath.row].service_status
        cell.labelDescription.text = arrMyrequest[indexPath.row].project_desc
        cell.btnUpdate.isHidden = true
        if arrMyrequest[indexPath.row].is_updatable == "y" {
            cell.btnUpdate.isHidden = false
        }
        cell.btnReOpen.isHidden = true
        if arrMyrequest[indexPath.row].service_status_code == 2 {
            cell.btnReOpen.isHidden = false
        }
        if arrMyrequest[indexPath.row].arrProviderList.count == 0 {
            cell.collViewProviderList.isHidden = true
        }else {
            cell.collViewProviderList.isHidden = false
            cell.setColleViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        }
        cell.btnReOpen.tag = indexPath.row
        cell.btnReOpen.addTarget(self, action: #selector(self.pressButtonReOpen(_:)), for: .touchUpInside)
        cell.btnUpdate.tag = indexPath.row
        cell.btnUpdate.addTarget(self, action: #selector(self.pressButtonUpdate(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnPDF.isHidden = true
        cell.lblCategory.text = ""
        for i in arrMyrequest[indexPath.row].categoryList{
            if cell.lblCategory.text == ""{
                cell.lblCategory.text = i.category_name
            }else{
                cell.lblCategory.text = cell.lblCategory.text! + "," + i.category_name
            }
        }
        cell.lblSubCategory.text = ""
        for i in arrMyrequest[indexPath.row].subCategoryList{
            if cell.lblSubCategory.text == ""{
                cell.lblSubCategory.text = i.subcategory_name
            }else{
                cell.lblSubCategory.text = cell.lblSubCategory.text! + "," + i.subcategory_name
            }
        }
        cell.llbMetrialName.text = ""
        for i in arrMyrequest[indexPath.row].materialName{
            if cell.llbMetrialName.text == ""{
                cell.llbMetrialName.text = i.material_name
            }else{
                cell.llbMetrialName.text = cell.llbMetrialName.text! + "," + i.material_name
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyrequest.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestDetailVC.storyboardInstance!
        vc.serviceId = arrMyrequest[indexPath.row].service_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if arrMyrequest.count - 1 == indexPath.row &&
            (myRequest.pagination.current_page > myRequest.pagination.total_pages) {
            self.callApiMyServiceList()
        }
    }
}
extension MyRequestVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMyrequest[collectionView.tag].arrProviderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProviderListCell.identifier, for: indexPath) as? ProviderListCell else {
            fatalError("Cell can't be dequeue")
        }
        if let strUrl = arrMyrequest[collectionView.tag].arrProviderList[indexPath.row].provider_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            cell.imgvwProvider.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            cell.imgvwProvider.sd_setShowActivityIndicatorView(true)
            cell.imgvwProvider.sd_setIndicatorStyle(.gray)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatVC.storyboardInstance!
        vc.quotesId = arrMyrequest[collectionView.tag].arrProviderList[indexPath.row].quotes_id
        vc.serviceID = Int(arrMyrequest[collectionView.tag].arrProviderList[indexPath.row].service_id) ?? 0
        vc.customerId = arrMyrequest[collectionView.tag].arrProviderList[indexPath.row].provider_id
        isFromMessages = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.0, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}
