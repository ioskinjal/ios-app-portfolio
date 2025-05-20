//
//  ManageDealOrderVC.swift
//  Happenings
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageDealOrderVC: BaseViewController {

    static var storyboardInstance:ManageDealOrderVC? {
        return StoryBoard.dealOrder.instantiateViewController(withIdentifier: ManageDealOrderVC.identifier) as? ManageDealOrderVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tblOrders: UITableView!{
        didSet{
            tblOrders.register(DealOrderCell.nib, forCellReuseIdentifier: DealOrderCell.identifier)
            tblOrders.dataSource = self
            tblOrders.delegate = self
            tblOrders.tableFooterView = UIView()
            tblOrders.separatorStyle = .none
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
    
    var orderList = [OrderCls.OrderList]()
    var orderObj: OrderCls?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        callDealOrders()
        strFilterType = "category"
        callGetCategory()
    }
    

    func callDealOrders(){
        let nextPage = (orderObj?.current_page ?? 0 ) + 1
        
        let param = ["page_no":nextPage,
                     "search_keyword":strKeyword,
                     "cat_id":strCatId,
                     "subcat_id":strCatSubId,
                     "user_id":"200"] as [String : Any]
        
        Modal.shared.getdealOrders(vc: self, param: param) { (dic) in
            self.orderObj = OrderCls(dictionary: dic)
            if self.orderList.count > 0{
                self.orderList += self.orderObj!.orderList
            }
            else{
                self.orderList = self.orderObj!.orderList
            }
            if self.orderList.count != 0{
                self.tblOrders.reloadData()
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
        orderList = [OrderCls.OrderList]()
        orderObj =  nil
        callDealOrders()
        filterView.isHidden = true
    }
    @IBAction func onClickClearAll(_ sender: UIButton) {
        selectedFilterIndex = -1
        selectedRowCategory = -1
        selectedRowSubCategory = -1
        strKeyword = ""
        searchBar.text = ""
        strCatSubId = ""
        strCatId = ""
        orderList = [OrderCls.OrderList]()
        orderObj =  nil
        callDealOrders()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ManageDealOrderVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Manage Deal Orders", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension ManageDealOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblOrders{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DealOrderCell.identifier) as? DealOrderCell else {
            fatalError("Cell can't be dequeue")
        }
            cell.selectionStyle = .none
        cell.viewContainer.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.viewContainer.layer.borderWidth = 1.0
        cell.viewContainer.layer.cornerRadius = 2.0
        cell.viewContainer.layer.masksToBounds = true
        let data:OrderCls.OrderList?
        data = orderList[indexPath.row]
        cell.imgdeal.downLoadImage(url: (data?.dealImages)!)
        //cell.imgMerchant.downLoadImage(url: data.)
        cell.lblDealTitle.text = data?.deal_title
        cell.lblUserName.text = (data?.customerFirstName)! + " " + (data?.customerlastName)!
        cell.lblUserEmail.text = data?.customerEmail
        cell.lblDate.text = data?.purchased_date
        cell.lblCategory.text = data?.categoryName
        cell.lblSubCategory.text = data?.subcategoryName
            cell.lblPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,(data?.deal_discount_price)!)
        cell.lblOldPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,(data?.deal_price)!)
        cell.lblDesc.text = data?.description
       
            if data?.payment_status == "Paid"{
                cell.lblPaid.isHidden = false
                cell.btnReceivedPayment.isHidden = true
                cell.btnPDF.tag = indexPath.row
                cell.btnPDF.isHidden = false
                cell.btnPDF.addTarget(self, action: #selector(onClickPDF), for:.touchUpInside)
            }else{
                cell.btnPDF.isHidden = true
                cell.lblPaid.isHidden = true
                cell.btnReceivedPayment.isHidden = false
                cell.btnReceivedPayment.tag = indexPath.row
                cell.btnReceivedPayment.addTarget(self, action: #selector(onClickReceivedPayment), for:.touchUpInside)
                
            }
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
    
    @objc func onClickReceivedPayment(_ sender:UIButton){
        let param = ["user_id":"200",
                     "deal_order_id":orderList[sender.tag].deal_order_id!]
        
        Modal.shared.receivePayment(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.orderList = [OrderCls.OrderList]()
                self.orderObj = nil
                self.callDealOrders()
                
            })
        }
    }
    
     @objc func onClickPDF(_ sender:UIButton){
        let url = orderList[sender.tag].payment_receipt_path
        if !url!.isBlank{
            Downloader.loadFileAsync(url: URL(string: url! )!) { (str, err) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                if err == nil, str != nil{
                    CloudDataManager.sharedInstance.copyFileToCloud()
                    
                    let ac = UIAlertController(title: "Saved!", message: "Documents is saved.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.viewController?.present(ac, animated: true, completion: nil)
                }
                else{
                    let ac = UIAlertController(title: "Save error", message: err?.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.viewController?.present(ac, animated: true, completion: nil)
                    print("Error in Save Document")
                }
            }
        }
        else{
            print("No URL found")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == tblOrders {
            return orderList.count
         }else if strFilterType == "category" && tableView == tblCategory{
            return arrCategoryList.count
        }else if strFilterType == "subcategory" && tableView == tblCategory{
            return arrSubCategoryList.count
        }else{
            return filterList.count
        }
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if tableView == tblOrders {
            reloadMoreData(indexPath: indexPath)
            }
    
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
            
        }else if tblFilter == tableView {
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
        }
    }
    
    
        func reloadMoreData(indexPath: IndexPath) {
            if orderList.count - 1 == indexPath.row &&
                (orderObj!.current_page > orderObj!.total_page) {
                self.callDealOrders()
            }
        }
}
extension ManageDealOrderVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        //  strKeyword = searchText
        // self.callSearchBusiness()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        strKeyword = searchBar.text!
        orderList = [OrderCls.OrderList]()
        orderObj =  nil
        callDealOrders()
        
    }
}
