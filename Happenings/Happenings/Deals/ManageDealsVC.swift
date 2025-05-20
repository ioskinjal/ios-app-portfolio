//
//  ManageDealsVC.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageDealsVC: BaseViewController {

    
    static var storyboardInstance:ManageDealsVC? {
        return StoryBoard.deals.instantiateViewController(withIdentifier: ManageDealsVC.identifier) as? ManageDealsVC
    }
    @IBOutlet weak var tblDeals: UITableView!{
        didSet{
            tblDeals.register(ManageDealCell.nib, forCellReuseIdentifier: ManageDealCell.identifier)
            tblDeals.dataSource = self
            tblDeals.delegate = self
            tblDeals.tableFooterView = UIView()
            tblDeals.separatorStyle = .none
        }
    }
    var dealList = [MyDealClass.MyDealList]()
    var dealObj: MyDealClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        callMyDealsAPI()
    }
    
    func callMyDealsAPI(){
        let nextPage = (dealObj?.current_page ?? 0 ) + 1
        
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "page_no":nextPage,
                     "per_page":10] as [String : Any]
        
        Modal.shared.getMerchantDeals(vc: self, param: param) { (dic) in
            self.dealObj = MyDealClass(dictionary: dic)
            if self.dealList.count > 0{
                self.dealList += self.dealObj!.dealList
            }
            else{
                self.dealList = self.dealObj!.dealList
            }
            if self.dealList.count != 0{
                self.tblDeals.reloadData()
            }
        }
        
    }
    
    @IBAction func onClickAddnewDeal(_ sender: UIButton) {
        let nextVC = PostNewDealVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
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
extension ManageDealsVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Manage Deals", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension ManageDealsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageDealCell.identifier) as? ManageDealCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.viewContainer.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.viewContainer.layer.borderWidth = 1.0
        cell.viewContainer.layer.cornerRadius = 2.0
        cell.viewContainer.layer.masksToBounds = true
        let data:MyDealClass.MyDealList?
        data = dealList[indexPath.row]
        cell.lblCat.text = data?.categoryName
        cell.lblSubCat.text = data?.subcategoryName
        cell.lblDealTitle.text = data?.deal_title
        cell.lblDesc.text = data?.desc
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(onClickViewDetail), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onClickEdit), for: .touchUpInside)
        cell.lblDate.text = data?.endDate
        cell.lblTime.text = data?.endTime
        return cell
    }
    
    @objc func onClickEdit(_ sender:UIButton){
        let nextVC = PostNewDealVC.storyboardInstance!
        nextVC.strDealId = dealList[sender.tag].deal_id!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        let param = ["deal_id":dealList[sender.tag].deal_id!,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.deleteMyDeal(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.dealList = [MyDealClass.MyDealList]()
                self.dealObj = nil
                self.callMyDealsAPI()
                
            })
        }
    }
    
    @objc func onClickViewDetail(_ sender:UIButton){
        let nextVC = DealDetailVC.storyboardInstance!
        nextVC.strId = dealList[sender.tag].deal_id!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealList.count
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
    
    
        }
    
    
        func reloadMoreData(indexPath: IndexPath) {
            if dealList.count - 1 == indexPath.row &&
                (dealObj!.current_page > dealObj!.total_page) {
                self.callMyDealsAPI()
            }
        }
}
