//
//  PurchasedDealVC.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PurchasedDealVC: BaseViewController {
    
    static var storyboardInstance:PurchasedDealVC? {
        return StoryBoard.deals.instantiateViewController(withIdentifier: PurchasedDealVC.identifier) as? PurchasedDealVC
    }
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tblDeals: UITableView!{
        didSet{
            tblDeals.register(PurchesedDealCell.nib, forCellReuseIdentifier: PurchesedDealCell.identifier)
            tblDeals.dataSource = self
            tblDeals.delegate = self
            tblDeals.tableFooterView = UIView()
            tblDeals.separatorStyle = .none
        }
    }
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tblFilter: UITableView!{
        didSet{
            tblFilter.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblFilter.dataSource = self
            tblFilter.delegate = self
            tblFilter.tableFooterView = UIView()
            tblFilter.separatorStyle = .none
        }
    }
    @IBOutlet weak var tblCategory: UITableView!{
        didSet{
            tblCategory.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblCategory.dataSource = self
            tblCategory.delegate = self
            tblCategory.tableFooterView = UIView()
            tblCategory.separatorStyle = .singleLine
        }
    }
    
    @IBOutlet weak var dateView: UIView!
    
    
    @IBOutlet weak var startDate: UITextField!{
        didSet{
            startDate.setBorder(radius: 1, color: UIColor.init(hexString: "CBCBCB"))
            let pickerView =  UIDatePicker()
            pickerView.datePickerMode = .date
            let mydate = Date()
            pickerView.maximumDate = mydate
            pickerView.addTarget(self, action: #selector(startTime(_:)), for: UIControl.Event.valueChanged)
            startDate.inputView = pickerView
        }
    }
    
    @IBOutlet weak var txtendDate: UITextField!{
        didSet{
            txtendDate.setBorder(radius: 1, color: UIColor.init(hexString: "CBCBCB"))
            let pickerView =  UIDatePicker()
            pickerView.datePickerMode = .date
            let mydate = Date()
            pickerView.maximumDate = mydate
            pickerView.addTarget(self, action: #selector(endTime(_:)), for: UIControl.Event.valueChanged)
            txtendDate.inputView = pickerView
        }
    }
    
    
    
    var purchasedDealList = [PurchasedDealCls.DealList]()
    var purchasedObj: PurchasedDealCls?
    var filterList = ["Category","Sub-Category","Date"]
    var strFilterType:String = ""
    var arrCategoryList = [AnyObject]()
    var strCatId:String = ""
    var arrSubCategoryList = [AnyObject]()
    var selectedFilterIndex:Int = 0
    var selectedRowCategory:Int = -1
    var selectedRowSubCategory:Int = -1
    var strCatSubId:String = ""
    var startdate:String?
    var endDate:String?
    var strKeyword:String = ""
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strFilterType = "category"
        setUpUI()
        callPurchasedDealAPI()
        callGetCategory()
    }
    
    
    func callPurchasedDealAPI(){
        let nextPage = (purchasedObj?.currentPage ?? 0 ) + 1
        let param = ["action":"purchased-deals",
                     "user_id":"205",
                     "page_no":nextPage,
                     "keyword":strKeyword,
                     "category_id":strCatId,
                     "subcategory_id":strCatSubId,
                     "startdate":startDate.text!,
                     "enddate":txtendDate.text!] as [String : Any]
        
        Modal.shared.getPurchaseDeals(vc: self, param: param, failer: { (dic) in
            
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.tblDeals.backgroundView = bgImage
            self.btnFilter.isHidden = true
            self.searchBar.isHidden = true
            
        }) { (dic) in
            self.purchasedObj = PurchasedDealCls(dictionary: dic)
            if self.purchasedDealList.count > 0{
                self.purchasedDealList += self.purchasedObj!.dealList
            }
            else{
                self.purchasedDealList = self.purchasedObj!.dealList
            }
            if self.purchasedDealList.count != 0{
                self.tblDeals.reloadData()
            }
        }
        
    }
    
    func callGetCategory() {
        let param = ["action":"categorylist"]
        Modal.shared.getCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.arrCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //            let dict = NSDictionary()
            //            dict = self.arrCategoryList[0] as! NSDictionary
            //            self.strCatId = dict.value(forKey: "id")
            if self.arrCategoryList.count != 0 {
                self.tblCategory.reloadData()
            }
        }
    }
    func callGetSubCategory(){
        let param = ["action":"subcategorylist",
                     "categoryId":strCatId]
        Modal.shared.getSubCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.arrSubCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //                let dict = NSDictionary()
            //                dict = self.arrSubCategoryList[0] as! NSDictionary
            //                self.strCatSubId = dict.value(forKey: "id")
            if self.arrSubCategoryList.count != 0 {
                self.tblCategory.reloadData()
            }
        }
    }
    
    @IBAction func onclickApplyFilter(_ sender: UIButton) {
        purchasedDealList = [PurchasedDealCls.DealList]()
        purchasedObj =  nil
       callPurchasedDealAPI()
        filterView.isHidden = true
    }
    @IBAction func onClickClearAll(_ sender: UIButton) {
        selectedFilterIndex = -1
        selectedRowCategory = -1
        selectedRowSubCategory = -1
        strKeyword = ""
        searchBar.text = ""
        strCatSubId = ""
        purchasedDealList = [PurchasedDealCls.DealList]()
        purchasedObj =  nil
        callPurchasedDealAPI()
         filterView.isHidden = true
    }
    
    @IBAction func onClickFilter(_ sender: Any) {
        filterView.isHidden = false
    }
    @objc func startTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
       // formatter.dateStyle = .medium
        startDate.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"
        startdate = formatter2.string(from: sender.date)
        print(startdate!)
    }
    @objc func endTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
       // formatter.dateStyle = .medium
        txtendDate.text = formatter.string(from: sender.date)
        //timePicker.removeFromSuperview() // if you want to remove time picker
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"
        endDate = formatter2.string(from: sender.date)
        print(endDate!)
    }
    
}
extension PurchasedDealVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Purchased Deals", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension PurchasedDealVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblDeals{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchesedDealCell.identifier) as? PurchesedDealCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewContainer.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            cell.viewContainer.layer.cornerRadius = 2.0
            cell.viewContainer.layer.masksToBounds = true
            let data = purchasedDealList[indexPath.row]
            cell.lblDealName.text = data.deal_title
            cell.lblCategory.text = data.categoryName! + "&" + data.subcategoryName!
            cell.lblPriceReal.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,data.deal_discount_price!)
            cell.lblOldPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,data.deal_price!)
            cell.lblDate.text = data.purchased_date
            cell.lblMerchantName.text = data.MerchantName
            cell.lblMerchantEmail.text = data.merchantEmail
            cell.lblMerchantContact.text = data.merchantContact
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
            return cell
        }else if tableView == tblFilter{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewPoint.isHidden = true
            cell.imgRight.isHidden = true
            cell.lblName.text = filterList[indexPath.row]
            if selectedFilterIndex == indexPath.row{
                cell.backgroundColor = UIColor.white
                cell.lblName.textColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.lblName.textColor = UIColor.darkGray
                cell.backgroundColor = UIColor.init(hexString: "E6E6E6")
            }
            return cell
        }else if strFilterType == "category" && tableView == tblCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            cell.viewPoint.isHidden = true
            if selectedRowCategory == indexPath.row{
                cell.imgRight.isHidden = false
                cell.lblName.textColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.imgRight.isHidden = true
                cell.lblName.textColor = UIColor.darkGray
            }
            var dict = NSDictionary()
            
            dict = arrCategoryList[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "categoryName") as? String
            
            return cell
        }else if strFilterType == "subcategory" && tableView == tblCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewPoint.isHidden = true
            cell.selectionStyle = .none
            if selectedRowSubCategory == indexPath.row{
                cell.lblName.textColor = UIColor.init(hexString: "E0171E")
                cell.imgRight.isHidden = false
            }else{
                cell.imgRight.isHidden = true
                cell.lblName.textColor = UIColor.darkGray
            }
            var dict = NSDictionary()
            dict = arrSubCategoryList[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "subcategoryName") as? String
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblDeals{
            return purchasedDealList.count
        }else if strFilterType == "category" && tableView == tblCategory{
            return arrCategoryList.count
        }else if strFilterType == "subcategory" && tableView == tblCategory{
            return arrSubCategoryList.count
        }else if tableView == tblFilter{
            return filterList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCategory{
            var dict = NSDictionary()
            if strFilterType == "category"{
                selectedRowCategory = indexPath.row
                dict = arrCategoryList[indexPath.row] as! NSDictionary
                strCatId = dict.value(forKey: "id") as! String
                self.callGetSubCategory()
            }else if strFilterType == "subcategory"{
                selectedRowSubCategory = indexPath.row
                dict = arrSubCategoryList[indexPath.row] as! NSDictionary
                strCatSubId = dict.value(forKey: "id") as! String
                
            }
            tblCategory.reloadData()
            
        }else if tblFilter == tableView{
            selectedFilterIndex = indexPath.row
            if indexPath.row == 0 {
                strFilterType = "category"
                tblCategory.isHidden = false
                dateView.isHidden = true
                callGetCategory()
            }else if indexPath.row == 1{
                strFilterType = "subcategory"
                tblCategory.isHidden = false
                dateView.isHidden = true
                callGetSubCategory()
                
            }else if indexPath.row == 2{
                dateView.isHidden = false
                tblCategory.isHidden = true
            }
            tblFilter.reloadData()
        }else{
            let nextVC = DealDetailVC.storyboardInstance!
            nextVC.strId = purchasedDealList[indexPath.row].deal_id!
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        let param = ["action":"delete-purchased-deals",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "purchase_id":purchasedDealList[sender.tag].purchase_id!]
        
        Modal.shared.deletePurchasedDeal(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.purchasedDealList = [PurchasedDealCls.DealList]()
                self.callPurchasedDealAPI()
                
            })
        }
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if purchasedDealList.count - 1 == indexPath.row &&
            (purchasedObj!.currentPage > purchasedObj!.TotalPages) {
            self.callPurchasedDealAPI()
        }
    }
}
extension PurchasedDealVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        //  strKeyword = searchText
        // self.callSearchBusiness()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        strKeyword = searchBar.text!
        purchasedDealList = [PurchasedDealCls.DealList]()
        purchasedObj =  nil
        callPurchasedDealAPI()
        
    }
}
