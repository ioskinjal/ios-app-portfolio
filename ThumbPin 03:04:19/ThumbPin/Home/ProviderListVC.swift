//
//  ProviderListVC.swift
//  ThumbPin
//
//  Created by admin on 4/24/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

var isFromProvider = false
class ProviderListVC: UIViewController {

    static var storyboardInstance:ProviderListVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: ProviderListVC.identifier) as? ProviderListVC
    }
    
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var tblProvider: UITableView!{
        didSet{
            tblProvider.dataSource = self
            tblProvider.delegate = self
            tblProvider.tableFooterView = UIView()
            tblProvider.separatorStyle = .singleLine
        }
    }
    
    var cat_id:String = ""
    var subCat_id:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var providerList = [SearchProviderClass.ProviderSearchList]()
    var searchProvider = SearchProviderClass()
    var subcategory_name:String = ""
    var postal_code:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPost.setTitle(localizedString(key: "Post Your Requirement"), for: .normal)
       callGetSupplier()
    }
    
    func callGetSupplier() {
        
        let dictParam = [
            "action": Action.getSupplier,
            "category": cat_id,
            "subcategory": subCat_id,
            "lat": latitude,
            "long": longitude,
            ] as [String : Any]
        
        ApiCaller.shared.getSuplier(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.searchProvider = SearchProviderClass(dic: dict)
            self.providerList = self.searchProvider.arrProvider
            self.tblProvider.reloadData()
        }
    }

    @IBAction func onclickContinue(_ sender: UIButton) {
        let nextVC = ServiceTitleVC.storyboardInstance!
        nextVC.cat_id = cat_id
        nextVC.subCat_id = subCat_id
        nextVC.subcategory_name = subcategory_name
        nextVC.latitude = latitude
        nextVC.longitude = longitude
        nextVC.postal_code = postal_code
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
extension ProviderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProviderFilterCell.identifier) as? ProviderFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .default
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
        var data:SearchProviderClass.ProviderSearchList?
        data = providerList[indexPath.row]
        cell.imgProvider.downLoadImage(url: (data?.supplier_img)!)
        cell.lblCategory.text = data?.category_name
        cell.lblName.text = data?.supplier_name
        cell.lblSubCategory.text = data?.subcategory_name
        
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return providerList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = MyProfileVC.storyboardInstance!
        nextVC.userIdFromCustomer = providerList[indexPath.row].supplier_id
        isFromProvider = true
       // nextVC.userType = UserData.shared.getUser()?.user_type ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        if arrSelectedServiceList.count != 0{
    //        arrSelectedServiceList.remove(at: indexPath.row)
    //        arrServiceList[indexPath.row].isChecked = false
    //        }
    //        tblCategory.reloadData()
    //    }
    
    
    
}
