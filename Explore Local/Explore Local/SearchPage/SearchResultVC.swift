//
//  SearchResultVC.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import GooglePlaces

var isFromViewAll = false
class SearchResultVC: BaseViewController {

    static var storyboardInstance: SearchResultVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SearchResultVC.identifier) as? SearchResultVC
    }
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var tblFilterData: UITableView!{
        didSet{
            tblFilterData.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblFilterData.dataSource = self
            tblFilterData.delegate = self
            tblFilterData.tableFooterView = UIView()
            tblFilterData.separatorStyle = .singleLine
        }
    }
    
    
    @IBOutlet weak var btnFacelity: UIButton!
    @IBOutlet weak var viewFacelityPoint: UIView!
    @IBOutlet weak var viewFacelityfilter: UIView!
    @IBOutlet weak var txtFacelity: UITextField!
    @IBOutlet weak var viewFacelity: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewLocationPoint: UIView!
    @IBOutlet weak var viewSubCategoryPoint: UIView!
    @IBOutlet weak var viewCategoryPoint: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewSubCategory: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tblResult: UITableView!{
        didSet{
            tblResult.register(SeachBusinessCell.nib, forCellReuseIdentifier: SeachBusinessCell.identifier)
            tblResult.dataSource = self
            tblResult.delegate = self
            tblResult.tableFooterView = UIView()
            tblResult.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var stackViewSorting: UIStackView!
    @IBOutlet weak var viewMostReview: UIView!{
        didSet{
            viewMostReview.border(side: .all, color: UIColor.init(hexString: "6367F9"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewBusinessReview: UIView!{
        didSet{
            viewBusinessReview.border(side: .all, color: UIColor.init(hexString: "6367F9"), borderWidth: 1.0)
        }
    }
    
    var strKeyword:String = ""
    var strSort:String = ""
    var strLocation:String = ""
    var arrCategoryList = [AnyObject]()
    var strCatId:String = ""
     var strCatSubId:String = ""
    var arrSubCategoryList = [AnyObject]()
    var strFilterType:String = ""
    var selectedRowCategory:Int = -1
    var selectedRowSubCategory:Int = -1
    var businessList = [SearchBusinessCls.SearchBusinessList]()
    var searchObj: SearchBusinessCls?
    var business_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Search Businessess", action: #selector(onClickMenu(_:)))
        let button = UIButton()
        
        onClickCategory(button)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        businessList = [SearchBusinessCls.SearchBusinessList]()
        searchObj = nil
        callSearchBusiness()
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
   
    func callSearchBusiness(){
        let nextPage = (searchObj?.pagination?.current_page ?? 0 ) + 1
        
        let param = ["action":"search",
                     "cat":strCatId,
                     "sub":strCatSubId,
                     "location":strLocation,
                     "sort":strSort,
                     "keyword":strKeyword,
                     "page":nextPage,
                     "fc":txtFacelity.text!
            ] as [String : Any]
        
        Modal.shared.searchBusiness(vc: self, param: param) { (dic) in
            print(dic)
            self.viewResult.isHidden = false
            self.searchObj = SearchBusinessCls(dictionary: dic)
            if self.businessList.count > 0{
                self.businessList += self.searchObj!.businessList
            }
            else{
                self.businessList = self.searchObj!.businessList
            }
            if self.businessList.count != 0{
                self.tblResult.reloadData()
                self.lblNoData.isHidden = true
                self.stackViewSorting.isHidden = false
            }else{
              self.tblResult.reloadData()
                self.lblNoData.isHidden = false
                self.stackViewSorting.isHidden = true
            }
            
        }
    }
    
        func callGetSubCategory(){
            let param = ["action":"subcategory",
                         "category_id":strCatId]
            Modal.shared.home(vc: self, param: param) { (dic) in
                print(dic)
                self.arrSubCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .subcategory) as [AnyObject]
//                let dict = NSDictionary()
//                dict = self.arrSubCategoryList[0] as! NSDictionary
//                self.strCatSubId = dict.value(forKey: "id")
                if self.arrSubCategoryList.count != 0 {
                   
                }
            }
        }
    func callGetCategory() {
        let param = ["action":"category",
                     "type":"full"]
        Modal.shared.home(vc: self, param: param) { (dic) in
            print(dic)
            
            self.arrCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .category) as [AnyObject]
//            let dict = NSDictionary()
//            dict = self.arrCategoryList[0] as! NSDictionary
//            self.strCatId = dict.value(forKey: "id")
            if self.arrCategoryList.count != 0 {
            self.tblFilterData.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickBusinessReview(_ sender: UIButton) {
        strSort = "hr"
        self.businessList = [SearchBusinessCls.SearchBusinessList]()
        self.searchObj = nil
        callSearchBusiness()
    }
    @IBAction func onClickMostReview(_ sender: UIButton) {
        strSort = "mr"
        self.businessList = [SearchBusinessCls.SearchBusinessList]()
        self.searchObj = nil
        callSearchBusiness()
    }
    @IBAction func onClickFilter(_ sender: UIButton) {
        lblNoData.isHidden = true
        viewFilter.isHidden = false
        self.navigationBar.isHidden = true
    }
    
    @IBAction func onClickCategory(_ sender: UIButton) {
        viewFacelity.isHidden = true
        lblNoData.isHidden = true
        tblFilterData.isHidden = false
        lblLocation.isHidden = true
        strFilterType = "category"
        viewCategoryPoint.isHidden = false
        viewCategory.backgroundColor = UIColor.white
        viewSubCategoryPoint.isHidden = true
        viewSubCategory.backgroundColor = UIColor.clear
        viewLocationPoint.isHidden = true
        viewFacelityPoint.isHidden = true
        viewFacelityfilter.backgroundColor = UIColor.clear
        viewLocation.backgroundColor = UIColor.clear
        btnCategory.setTitleColor(UIColor.init(hexString: "6367F9"), for: .normal)
        btnSubCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnLocation.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        self.callGetCategory()
    }
    
    @IBAction func onClickSubCategory(_ sender: UIButton) {
         viewFacelity.isHidden = true
        lblNoData.isHidden = true
        tblFilterData.isHidden = false
        lblLocation.isHidden = true
        strFilterType = "subcategory"
        viewCategoryPoint.isHidden = true
        viewCategory.backgroundColor = UIColor.clear
        viewSubCategoryPoint.isHidden = false
        viewSubCategory.backgroundColor = UIColor.white
        viewLocationPoint.isHidden = true
        viewFacelityPoint.isHidden = true
        viewFacelityfilter.backgroundColor = UIColor.clear
        viewLocation.backgroundColor = UIColor.clear
        btnCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnSubCategory.setTitleColor(UIColor.init(hexString: "6367F9"), for: .normal)
        btnLocation.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        self.tblFilterData.reloadData()
    }
    
    @IBAction func onClickFacelity(_ sender: Any) {
        lblNoData.isHidden = true
        viewFacelity.isHidden = false
        tblFilterData.isHidden = true
        lblLocation.isHidden = true
        strFilterType = "facelity"
        viewCategoryPoint.isHidden = true
        viewCategory.backgroundColor = UIColor.clear
        viewSubCategoryPoint.isHidden = true
        viewSubCategory.backgroundColor = UIColor.clear
        viewLocationPoint.isHidden = true
        viewLocation.backgroundColor = UIColor.clear
        
        viewFacelityPoint.isHidden = false
        viewFacelityfilter.backgroundColor = UIColor.white
        btnCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnSubCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        
        btnLocation.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnFacelity.setTitleColor(UIColor.init(hexString: "6367F9"), for: .normal)
        
    }
    
    @IBAction func onClickLocation(_ sender: UIButton) {
        lblNoData.isHidden = true
        viewFacelity.isHidden = true
        tblFilterData.isHidden = true
        lblLocation.isHidden = false
        strFilterType = "location"
        viewCategoryPoint.isHidden = true
        viewCategory.backgroundColor = UIColor.clear
        viewSubCategoryPoint.isHidden = true
        viewSubCategory.backgroundColor = UIColor.clear
        viewLocationPoint.isHidden = false
        viewFacelityPoint.isHidden = true
        viewFacelityfilter.backgroundColor = UIColor.clear
        viewLocation.backgroundColor = UIColor.white
        btnCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnSubCategory.setTitleColor(UIColor.init(hexString: "333333"), for: .normal)
        btnLocation.setTitleColor(UIColor.init(hexString: "6367F9"), for: .normal)
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func onClickClearAll(_ sender: UIButton) {
        lblNoData.isHidden = true
        viewFilter.isHidden = true
        self.navigationBar.isHidden = false
        strCatId = ""
        strCatSubId = ""
        selectedRowCategory = -1
         selectedRowSubCategory = -1
        strLocation = ""
        searchBar.text = ""
        txtFacelity.text = ""
        strKeyword = ""
        strSort = ""
        self.tblFilterData.reloadData()
        self.businessList = [SearchBusinessCls.SearchBusinessList]()
        self.searchObj = nil
        callSearchBusiness()
    }
    
    @IBAction func onClickApplyfilter(_ sender: UIButton) {
        lblNoData.isHidden = true
        self.businessList = [SearchBusinessCls.SearchBusinessList]()
        self.searchObj = nil
         self.callSearchBusiness()
        viewFilter.isHidden = true
        self.navigationBar.isHidden = false
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
extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if strFilterType == "category" && tableView == tblFilterData{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            if selectedRowCategory == indexPath.row{
                cell.viewPoint.isHidden = false
            }else{
                cell.viewPoint.isHidden = true
            }
            var dict = NSDictionary()
            
        dict = arrCategoryList[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "name") as? String
        
            return cell
       }else if strFilterType == "subcategory" && tableView == tblFilterData{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
        if selectedRowSubCategory == indexPath.row{
            cell.viewPoint.isHidden = false
        }else{
            cell.viewPoint.isHidden = true
        }
        var dict = NSDictionary()
        dict = arrSubCategoryList[indexPath.row] as! NSDictionary
        cell.lblName.text = dict.value(forKey: "name") as? String
        
        return cell
        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeachBusinessCell.identifier) as? SeachBusinessCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.selectionStyle = .none
        var data:SearchBusinessCls.SearchBusinessList?
        data = businessList[indexPath.row]
        cell.lblItemName.text = data?.business_name
        cell.lblRate.text = data?.average_rating
        cell.lblrateCount.text = data?.total_reviews
        cell.lblLocation.text = data?.location
            cell.btncategory.setTitle(data?.category, for: .normal)
            cell.btnSubCategory.setTitle(data?.subcategory, for: .normal)
            cell.btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.btncategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
            cell.lblDiscount.isHidden = true
            cell.imgRound.isHidden = true
        cell.lblDesc.text = data?.desc
        cell.imgView.downLoadImage(url: (data?.image)!)
//        if UserData.shared.getUser()?.user_type == "1"{
            cell.btnEdit.isHidden = true
            cell.btnDelete.isHidden = true
//        }else{
//            cell.btnEdit.isHidden = false
//            cell.btnDelete.isHidden = false
//        cell.btnEdit.tag = indexPath.row
//        cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
//        cell.btnDelete.tag = indexPath.row
//        cell.btnDelete.addTarget(self, action: #selector(onclickDelete(_:)), for: .touchUpInside)
        //}
        return cell
        }
    }
    
    
    @objc func onClickEdit(_ sender:UIButton){
        
        isFromEdit = true
        let nextVC = AddNewBusinessVC.storyboardInstance!
        nextVC.strBusinessId = businessList[sender.tag].business_id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onclickDelete(_ sender:UIButton){
        let param = ["action":"delete_business",
                     "business_id":businessList[sender.tag].business_id!,
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.getEditBusiness(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.businessList = [SearchBusinessCls.SearchBusinessList]()
                self.searchObj = nil
                self.callSearchBusiness()
                
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if strFilterType == "category" && tableView == tblFilterData{
            return arrCategoryList.count
        }else  if strFilterType == "subcategory" && tableView == tblFilterData{
            return arrSubCategoryList.count
        }else{
            return businessList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if tableView == tblFilterData{
        var dict=NSDictionary()
            if strFilterType == "category"{
                 selectedRowCategory = indexPath.row
            dict = arrCategoryList[indexPath.row] as! NSDictionary
            strCatId = dict.value(forKey: "id") as! String
                 self.callGetSubCategory()
            }else  if strFilterType == "subcategory"{
                selectedRowSubCategory = indexPath.row
                dict = arrSubCategoryList[indexPath.row] as! NSDictionary
                strCatSubId = dict.value(forKey: "id") as! String
            }
            tblFilterData.reloadData()
            
         }else{
        let nextVC = BuisnessDetailVC.storyboardInstance!
            
            nextVC.strBus_id = businessList[indexPath.row].business_id!
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
        
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if businessList.count - 1 == indexPath.row &&
            (searchObj!.pagination!.current_page > searchObj!.pagination!.total_pages) {
            self.callSearchBusiness()
        }
    }
    
}
extension SearchResultVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
      //  strKeyword = searchText
       // self.callSearchBusiness()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        strKeyword = searchBar.text!
        self.businessList = [SearchBusinessCls.SearchBusinessList]()
        self.searchObj = nil
        self.callSearchBusiness()
        searchBar.resignFirstResponder()
    }
    
   
    
}
extension SearchResultVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place coordinate latitude: \(place.coordinate.latitude)")
        print("Place coordinate longitude: \(place.coordinate.longitude)")
        //latitude = String(place.coordinate.latitude)
        //longitude = String(place.coordinate.longitude)
        
       // latitude = place.coordinate.latitude
        //longitude = place.coordinate.longitude
        
        strLocation = place.formattedAddress!
        lblLocation.text = strLocation
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
