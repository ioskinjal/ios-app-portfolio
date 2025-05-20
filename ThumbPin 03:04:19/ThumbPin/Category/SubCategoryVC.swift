//
//  SubCategoryVC.swift
//  ThumbPin
//
//  Created by NCT109 on 23/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

var arrSelectedSubCategory = [SubCategory.SubCategoryData]()

class SubCategoryVC: BaseViewController {

    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var tblvwSubCategory: UITableView!{
        didSet{
            tblvwSubCategory.delegate = self
            tblvwSubCategory.dataSource = self
            //tblvwSubCategory.register(CategoryCell.nib, forCellReuseIdentifier: CategoryCell.identifier)
            tblvwSubCategory.rowHeight  = UITableViewAutomaticDimension
            tblvwSubCategory.estimatedRowHeight = 60
            tblvwSubCategory.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:SubCategoryVC? {
        return StoryBoard.browsecategory.instantiateViewController(withIdentifier: SubCategoryVC.identifier) as? SubCategoryVC
    }
    var pageNo = 1
    var categoryId = ""
    var categoryName = ""
    var totalSubCat:Int = 0
    var subCategory = SubCategory()
    var arrSubCategory = [SubCategory.SubCategoryData]()
    var subCatId:String = ""
    var locationDetails = LocationDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageNo = 1
        callApiGetSubCategory()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetSubCategory() {
        let dictParam = [
            "action": Action.getSubCategory,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "category_id": categoryId,
            "user_id": UserData.shared.getUser()!.user_id,
            "keyword": ""
            ] as [String : Any]
        ApiCaller.shared.browseSubCategory(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.subCategory = SubCategory(dic: dict)
            if self.pageNo > 1 {
                self.arrSubCategory.append(contentsOf: self.subCategory.arrSubCategory)
            }else {
                self.arrSubCategory.removeAll()
                self.arrSubCategory = self.subCategory.arrSubCategory
            }
            for i in self.arrSubCategory{
                for j in arrSelectedSubCategory{
                    if j.subCategory.sub_category_name == i.subCategory.sub_category_name{
                        i.subCategory.isChecked = true
                    }
                }
            }
            self.labelCategoryName.text = "SubCategories (\(self.totalSubCat))"
            self.tblvwSubCategory.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func onClickSubmit(_ sender: UIButton) {
        var strSelectedCat:String = ""
        for i in arrSelectedSubCategory{
            if strSelectedCat == ""{
                strSelectedCat = i.subCategory.sub_category_name
                subCatId = i.subCategory.sub_category_id
            }else{
                strSelectedCat = strSelectedCat + "," + i.subCategory.sub_category_name
                subCatId = subCatId + "," + i.subCategory.sub_category_id
            }
        }

        print(strSelectedCat)
        let vc = ServiceTitleVC.storyboardInstance!
        
        vc.cat_id = categoryId
        vc.subCat_id = subCatId
        vc.subcategory_name = strSelectedCat
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SubCategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleCategoryCell.identifier) as? MultipleCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblCategory.text = arrSubCategory[indexPath.row].subCategory.sub_category_name
        cell.selectionStyle = .none
        if arrSubCategory[indexPath.row].subCategory.isChecked == true{
                cell.imgcheck.image = #imageLiteral(resourceName: "Checked-new")
            }else{
                cell.imgcheck.image = #imageLiteral(resourceName: "Unchecked")
            }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubCategory.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSubCategory[indexPath.row].subCategory.isParent == "y" {
            let vc = SubCategoryVC.storyboardInstance!
            vc.categoryId = arrSubCategory[indexPath.row].subCategory.sub_category_id
            vc.categoryName = categoryName
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
        else {
            if arrSubCategory[indexPath.row].subCategory.isChecked == false{
             arrSubCategory[indexPath.row].subCategory.isChecked = true
            arrSelectedSubCategory.append(arrSubCategory[indexPath.row])
            }else{
                arrSubCategory[indexPath.row].subCategory.isChecked = false
                for i in arrSelectedSubCategory{
                    if i.subCategory.sub_category_name == arrSubCategory[indexPath.row].subCategory.sub_category_name{
                        if arrSelectedSubCategory.count < indexPath.row{
                        arrSelectedSubCategory.remove(at: indexPath.row)
                        }
                    }
                }
            }
            tblvwSubCategory.reloadData()
//            let vc = RequestServiceVC.storyboardInstance!
//            vc.serviceId = arrSubCategory[indexPath.row].subCategory.sub_category_id
//            vc.serviceName = arrSubCategory[indexPath.row].subCategory.sub_category_name
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrSubCategory.count - 1
        let page = subCategory.pagination.current_page
        let numPages = subCategory.pagination.total_pages
        let totalRecords = subCategory.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiGetSubCategory()
        }
    }
}
