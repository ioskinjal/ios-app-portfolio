//
//  MyServiceVC.swift
//  XPhorm
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var currency = "$"
class MyServiceVC: BaseViewController {

    static var storyboardInstance:MyServiceVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: MyServiceVC.identifier) as? MyServiceVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
            searchBar.setRadius(8.0)
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tblMyservice: UITableView!{
        didSet{
            tblMyservice.dataSource = self
            tblMyservice.delegate = self
            tblMyservice.tableFooterView = UIView()
            tblMyservice.separatorStyle = .none
            
        }
    }
    
    var serviceList = [MyServiceCls.ServiceList]()
    var serviceObj: MyServiceCls?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Services".localized, action: #selector(onClickBack(_:)))
        getMyService(searchText: searchBar.text ?? "")
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMyService(searchText:String){
        let nextPage = (serviceObj?.pagination?.page ?? 0 ) + 1
        
        let param = ["action":"getMyService",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage,
                     "keyword":searchBar.text ?? ""] as [String : Any]
        
        Modal.shared.getMyService(vc: self, param: param) { (dic) in
            self.serviceObj = MyServiceCls(dictionary: dic)
            if self.serviceList.count > 0{
                self.serviceList += self.serviceObj!.serviceList
            }
            else{
                self.serviceList = self.serviceObj!.serviceList
            }
            self.tblMyservice.reloadData()
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
extension MyServiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyServiceCell.identifier) as? MyServiceCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
        cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
        cell.viewContainer.setRadius(10.0)
        let data:MyServiceCls.ServiceList?
        data = serviceList[indexPath.row]
        cell.imgservice.downLoadImage(url: data?.serviceImagePath ?? "")
        cell.lblCategory.text = data?.categoryName
        cell.lblDuration.text = data?.duration
       // cell.lblAdditional.text = data?.additionalRate
        cell.lblLocation.text = data?.location
        cell.lblPrice.text = currency + data!.price
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.lblDurationHead.text = "Duration (Hour)".localized
       // cell.lblAdditionalHead.text = "Additional Rate".localized
        return cell
        
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        
        self.alert(title: "", message: "Are you sure you want to  remove this service ?".localized, actions: ["Yes".localized,"No".localized]) { (btnNo) in
            if btnNo == 0 {
        let param = ["action":"deleteService",
        "lId":UserData.shared.getLanguage,
        "userId":UserData.shared.getUser()!.id,
        "id":self.serviceList[sender.tag].id]
        
        Modal.shared.getMyService(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.serviceList = [MyServiceCls.ServiceList]()
                self.serviceObj = nil
                self.getMyService(searchText:self.searchBar.text ?? "")
            })

        }
            }else{
                
            }
        }
    }
    
    @objc func onClickEdit(_ sender:UIButton){
        let nextVC = AddServiceStep1VC.storyboardInstance!
        nextVC.service_id = serviceList[sender.tag].id
        isFromEdit = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ServiceDetailVC.storyboardInstance!
        nextVC.service_id = serviceList[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if serviceList.count - 1 == indexPath.row &&
            (Int(serviceObj!.pagination!.page) > serviceObj!.pagination!.numPages) {
            getMyService(searchText: searchBar.text ?? "")
        }
    }
}
extension MyServiceVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.serviceList = [MyServiceCls.ServiceList]()
        self.serviceObj = nil
        getMyService(searchText: searchBar.text ?? "")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
    }
}
