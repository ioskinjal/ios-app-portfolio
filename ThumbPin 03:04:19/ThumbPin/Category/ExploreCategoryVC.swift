//
//  ExploreCategoryVC.swift
//  ThumbPin
//
//  Created by NCT109 on 23/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

var isFromExplore:Bool = false
class ExploreCategoryVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tblvwCategory: UITableView!{
        didSet{
            tblvwCategory.delegate = self
            tblvwCategory.dataSource = self
            //tblvwCategory.rowHeight  = UITableViewAutomaticDimension
            //tblvwCategory.estimatedRowHeight = 60
            tblvwCategory.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:ExploreCategoryVC? {
        return StoryBoard.browsecategory.instantiateViewController(withIdentifier: ExploreCategoryVC.identifier) as? ExploreCategoryVC
    }
    var browseCategory = BrowseCategory()
    var arrCategory = [BrowseCategory.CategoryData]()
    var pageNo = 1
    var isLoadRequestView = ""
    
    
    override func viewDidLoad() {
      isFromExplore = true
        super.viewDidLoad()
        viewSearch.isHidden = true
        txtSearch.rightView = btnClearSearch
        txtSearch.rightViewMode = .always
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search...",
                                                             attributes: [NSAttributedStringKey.foregroundColor: Color.Custom.lightGrayColor])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pageNo = 1
        callApiGetCategory("")
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func callApiGetCategory(_ search: String) {
        let dictParam = [
            "action": Action.getCategory,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
            "keyword": search
        ] as [String : Any]
        ApiCaller.shared.browseCategory(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.browseCategory = BrowseCategory(dic: dict)
            if self.pageNo > 1 {
                self.arrCategory.append(contentsOf: self.browseCategory.arrCategory)
            }else {
                self.arrCategory.removeAll()
                self.arrCategory = self.browseCategory.arrCategory
            }
            self.tblvwCategory.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearch {
            if textField.returnKeyType == UIReturnKeyType.search {
                pageNo = 1
                callApiGetCategory(txtSearch.text!)
            }
        }
        return true
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Explore Category")
        //txtSearch.placeholder = localizedString(key: "Search...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func onClickSubmit(_ sender: UIButton) {
        arrSelectedSubCategory = [SubCategory.SubCategoryData]()
        var sum:Int = 0
        let vc = SubCategoryVC.storyboardInstance!
        for i in arrCategory{
            if i.isChecked == true{
                if vc.categoryId == ""{
                     vc.categoryId = i.category_id
                }else{
                   vc.categoryId = vc.categoryId + "," + i.category_id
                }
               if vc.categoryName == ""{
                vc.categoryName = i.category_name
               }else{
                vc.categoryName = vc.categoryName + "," + i.category_name
               
                }
                sum = sum + i.total_no_of_sub_category
                vc.totalSubCat = sum
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackSearchAction(_ sender: UIButton) {
        viewSearch.isHidden = true
        txtSearch.text = ""
        pageNo = 1
        callApiGetCategory(txtSearch.text!)
    }
    @IBAction func btnClearSearchAction(_ sender: UIButton) {
        if !(txtSearch.text?.isEmpty)! {
            txtSearch.text = ""
            pageNo = 1
            callApiGetCategory(txtSearch.text!)
        }        
    }
    @IBAction func btnShowSearchViewAction(_ sender: UIButton) {
        viewSearch.isHidden = false
    }
    
}
extension ExploreCategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleCategoryCell.identifier) as? MultipleCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblCategory.text = "\(arrCategory[indexPath.row].category_name) (\(arrCategory[indexPath.row].total_no_of_sub_category))"
        cell.selectionStyle = .none
        if arrCategory[indexPath.row].isChecked == true{
            cell.imgcheck.image = #imageLiteral(resourceName: "Checked-new")
        }else{
            cell.imgcheck.image = #imageLiteral(resourceName: "Unchecked")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrCategory[indexPath.row].isChecked == true{
            arrCategory[indexPath.row].isChecked = false
        }else{
           arrCategory[indexPath.row].isChecked = true
        }
       tblvwCategory.reloadData()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrCategory.count - 1
        let page = browseCategory.pagination.current_page
        let numPages = browseCategory.pagination.total_pages
        let totalRecords = browseCategory.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiGetCategory(txtSearch.text!)
        }
    }
}
extension ExploreCategoryVC: LoadRequestVC {
    func loadRequestVCMethod() {
        isLoadRequestView = "1"
    }
    
    
}
