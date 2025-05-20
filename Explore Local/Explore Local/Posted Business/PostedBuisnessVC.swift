//
//  PostedBuisnessVC.swift
//  Explore Local
//
//  Created by NCrypted on 25/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit


var isFromSubCat:Bool = false
class PostedBuisnessVC: BaseViewController {

    static var storyboardInstance: PostedBuisnessVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: PostedBuisnessVC.identifier) as? PostedBuisnessVC
    }
    
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var btnAddBuisness: UIButton!
    @IBOutlet weak var tblBusiness: UITableView!{
        didSet{
            tblBusiness.register(SeachBusinessCell.nib, forCellReuseIdentifier: SeachBusinessCell.identifier)
            tblBusiness.dataSource = self
            tblBusiness.delegate = self
            tblBusiness.tableFooterView = UIView()
            tblBusiness.separatorStyle = .none
        }
    }
    
    var businessList = [FavouriteBusinessCls.BusinessList]()
    var businessListSub = [AnyObject]()
    var favouriteObj: FavouriteBusinessCls?
    var strCatSubId:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFromSubCat == true {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Business List", action: #selector(onClickMenu(_:)))
        }else{
             setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Posted Business", action: #selector(onClickMenu(_:)))
        }
        self.btnAddBuisness.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        if isFromSubCat == true {
                callSearchBusiness()
        }else{
        callPostedBusiness()
        }
    }

    func callPostedBusiness() {
        let nextPage = (favouriteObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"business_list",
        "user_id":UserData.shared.getUser()!.user_id,
        "page": nextPage] as [String : Any]
        Modal.shared.postedBusiness(vc: self, param: param) { (dic) in
            self.favouriteObj = FavouriteBusinessCls(dictionary: dic)
            if self.businessList.count > 0{
                self.businessList += self.favouriteObj!.businessList
            }
            else{
                self.businessList = self.favouriteObj!.businessList
            }
            if self.businessList.count != 0{
            self.tblBusiness.reloadData()
            }else{
                self.lblNodata.isHidden = false
            }
        }
        
    }
    
    func callSearchBusiness(){
        btnAddBuisness.isHidden = true
        let param = ["action":"search",
                     "sub":strCatSubId!
                     
        ]
        Modal.shared.searchBusiness(vc: self, param: param) { (dic) in
            print(dic)
            self.businessListSub = ResponseKey.fatchDataAsArray(res: dic, valueOf: .business) as [AnyObject]
           if self.businessListSub.count != 0 {
            self.tblBusiness.reloadData()
            }
        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickAddBusiness(_ sender: UIButton) {
        isFromEdit = false
     self.navigationController?.pushViewController(AddNewBusinessVC.storyboardInstance!, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PostedBuisnessVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if isFromSubCat == true {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeachBusinessCell.identifier) as? SeachBusinessCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            var dict = NSDictionary()
            dict = businessListSub[indexPath.row] as! NSDictionary
            cell.lblItemName.text = dict.value(forKey: "business_name") as? String
            //cell.lblRate.text =  String(format: "%.1f",(dict.value(forKey: "average_rating") as? Float)!)
            cell.stackViewCat.isHidden = true
            cell.lblrateCount.text = dict.value(forKey: "total_reviews") as? String
            cell.lblLocation.text = dict.value(forKey: "location")as? String
            cell.btncategory.setTitle(dict.value(forKey: "category")as? String, for: .normal)
            cell.btnSubCategory.setTitle(dict.value(forKey: "subcategory")as? String, for: .normal)
            cell.btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.btncategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.lblDiscount.isHidden = true
            cell.imgRound.isHidden = true
            let user = UserData.shared.getUser()
            if UserData.shared.getUser()?.user_type == "1" || user == nil {
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
            }else{
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onclickDelete(_:)), for: .touchUpInside)
        
            }
            cell.imgView.downLoadImage(url: dict.value(forKey: "image") as! String)
            cell.lblDesc.text = dict.value(forKey: "description") as? String
            return cell
         }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeachBusinessCell.identifier) as? SeachBusinessCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
             cell.stackViewCat.isHidden = true
            cell.lblItemName.text = businessList[indexPath.row].business_name
            cell.lblRate.text = String(format: "%.1f",businessList[indexPath.row].average_rating ?? 0.0)
            cell.lblrateCount.text = "(" + businessList[indexPath.row].total_reviews! + ")"
            cell.lblLocation.text = businessList[indexPath.row].location
            cell.btncategory.setTitle(businessList[indexPath.row].category, for: .normal)
            cell.btnSubCategory.setTitle(businessList[indexPath.row].subcategory, for: .normal)
            cell.btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.btncategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.lblDiscount.isHidden = true
            cell.imgRound.isHidden = true
            if UserData.shared.getUser()?.user_type == "1"{
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
            }else{
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(onClickEdit1(_:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onclickDelete1(_:)), for: .touchUpInside)
            }
            
            cell.imgView.downLoadImage(url: businessList[indexPath.row].image!)
            cell.lblDesc.text = businessList[indexPath.row].description
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let nextVC = BuisnessDetailVC.storyboardInstance!
        if isFromSubCat == true {
            var dict = NSDictionary()
            dict = businessListSub[indexPath.row] as! NSDictionary
            nextVC.strBus_id = dict.value(forKey: "business_id") as! String
        }else{
        nextVC.strBus_id = businessList[indexPath.row].business_id!
        
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickEdit(_ sender:UIButton){
        var dict = NSDictionary()
        dict = businessListSub[sender.tag] as! NSDictionary
        isFromEdit = true
        let nextVC = AddNewBusinessVC.storyboardInstance!
        nextVC.strBusinessId = dict.value(forKey: "business_id") as? String
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickEdit1(_ sender:UIButton){
        isFromEdit = true
        let nextVC = AddNewBusinessVC.storyboardInstance!
        nextVC.strBusinessId = businessList[sender.tag].business_id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onclickDelete(_ sender:UIButton){
        var dict = NSDictionary()
        dict = businessListSub[sender.tag] as! NSDictionary
        let param = ["action":"delete_business",
                     "business_id":dict.value(forKey: "business_id") as! String,
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.getEditBusiness(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callSearchBusiness()
                
            })
        }
        
    }
    
    @objc func onclickDelete1(_ sender:UIButton){
        let param = ["action":"delete_business",
                     "business_id":businessList[sender.tag].business_id!,
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.getEditBusiness(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callPostedBusiness()
                
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromSubCat == true {
                return businessListSub.count
        }else{
        return businessList.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFromSubCat == false{
        reloadMoreData(indexPath: indexPath)
        }
    }
        
    
    func reloadMoreData(indexPath: IndexPath) {
        if businessList.count - 1 == indexPath.row &&
            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
            self.callPostedBusiness()
        }
    }
    
}
