//
//  ProfileUserVC.swift
//  Happenings
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ProfileUserVC: BaseViewController {

    
    static var storyboardInstance: ProfileUserVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: ProfileUserVC.identifier) as? ProfileUserVC
    }
    @IBOutlet weak var btnAddNew: UIButton!{
        didSet{
            btnAddNew.layer.borderColor = UIColor.init(hexString: "D22428").cgColor
        }
    }
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstCollectionView: NSLayoutConstraint!
    @IBOutlet weak var tblReviews: UITableView!{
        didSet{
            tblReviews.register(ReviewProfileCell.nib, forCellReuseIdentifier: ReviewProfileCell.identifier)
            tblReviews.dataSource = self
            tblReviews.delegate = self
            tblReviews.tableFooterView = UIView()
            tblReviews.separatorStyle = .none
        }
    }
    @IBOutlet weak var dealCollectionView: UICollectionView!{
        didSet{
            dealCollectionView.delegate = self
            dealCollectionView.dataSource = self
            dealCollectionView.register(PreferenceDealCell.nib, forCellWithReuseIdentifier: PreferenceDealCell.identifier)
        }
    }
    
    @IBOutlet weak var lblRadius: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewAddNew: UIView!
    
    let categoryPickerView = UIPickerView()
    @IBOutlet weak var txtCategory: UITextField!{
        didSet{
            categoryPickerView.delegate = self
            txtCategory.inputView = categoryPickerView
            txtCategory.delegate = self
            txtCategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
            
        }
    }
     let subCategoryPickerView = UIPickerView()
    @IBOutlet weak var txtSubategory: UITextField!{
        didSet{
            subCategoryPickerView.delegate = self
            txtSubategory.inputView = subCategoryPickerView
            txtSubategory.delegate = self
            txtSubategory.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "DownArrow"))
            
        }
    }
    
    var categoryListMain = [AnyObject]()
    var reviewList = [AnyObject]()
    
    var subCategoryList = [AnyObject]()
    var strCatId:String = ""
    var strCatSubId:String = ""
    var selectedCategory: String?
    var selectedSubCategory: String?
    
    
    @IBOutlet weak var viewcategory: UIView!{
        didSet{
            viewcategory.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var viewSubCat: UIView!{
        didSet{
            viewSubCat.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    
    var categoryList = [SubscibedCategoryCls.CategoryList]()
    var catObj: SubscibedCategoryCls?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            setUpUI()
        
        setAutoHeight()
        callUserProfile()
         callGetCategory()
        
    }
    
    func callGetCategory() {
        let param = ["action":"categorylist"]
        Modal.shared.getCategory(vc: self, param: param) { (dic) in
            print(dic)
            
            self.categoryListMain = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //            let dict = NSDictionary()
            //            dict = self.arrCategoryList[0] as! NSDictionary
            //            self.strCatId = dict.value(forKey: "id")
            if self.categoryListMain.count != 0 {
                self.categoryPickerView.reloadAllComponents()
            }
        }
    }
    
    func callGetSubCategory(){
        let param = ["action":"subcategorylist",
                     "categoryId":strCatId]
        Modal.shared.getSubCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.subCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //                let dict = NSDictionary()
            //                dict = self.arrSubCategoryList[0] as! NSDictionary
            //                self.strCatSubId = dict.value(forKey: "id")
            if self.subCategoryList.count != 0 {
                self.subCategoryPickerView.reloadAllComponents()
            }
        }
    }
    
    func callUserProfile(){
        let param = ["action":"user-profile",
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getProfile(vc: self, param: param) { (dic) in  
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            self.lblName.text = UserData.shared.getUser()?.username
            self.imgProfile.downLoadImage(url: (UserData.shared.getUser()?.userProfileImage)!)
            self.lblLocation.text = UserData.shared.getUser()?.address
            self.lblRadius.text = UserData.shared.getUser()?.selected_radius
            self.lblContactNumber.text = UserData.shared.getUser()?.contact_no
            self.callgetSubscibedList()
            self.reviewList = data["reviews"] as! [AnyObject]
            if self.reviewList.count != 0{
                self.tblReviews.reloadData()
                self.setAutoHeighttbl()
            }
        }
    }
    
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtCategory.text?.isEmpty)! {
            ErrorMsg = "Please select category to subscribe"
        }
        else if (txtSubategory.text?.isEmpty)! {
            ErrorMsg = "Please select sub category to subscribe"
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    func openSettingForGivePermissionCamera() {
        self.alert(title: "", message: "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                self.open(scheme:UIApplication.openSettingsURLString)
            }
            else{//Cancel
            }
        })
    }
    
    
    func callgetSubscibedList(){
        let nextPage = (catObj?.currentPage ?? 0 ) + 1
        let param = ["action":"subscribed-category-list",
                     "user_id":"205",
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.subscribedCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.catObj = SubscibedCategoryCls(dictionary: dic)
            if self.categoryList.count > 0{
                self.categoryList += self.catObj!.dealList
            }
            else{
                self.categoryList = self.catObj!.dealList
            }
            if self.categoryList.count != 0{
                self.dealCollectionView.reloadData()
            }
        }
    }
    @IBAction func onClickAddNewView(_ sender: UIButton) {
        if isValidated(){
            callAddCatToSubscribe()
        }
    }
    
    func callAddCatToSubscribe(){
        let param = ["action":"subscribe-deal-category",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "category_id":strCatId,
                     "subcategory_id":strCatSubId]
        
        Modal.shared.subscribedCategory(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.categoryList = [SubscibedCategoryCls.CategoryList]()
                self.viewAddNew.isHidden = true
                self.navigationBar.isHidden = false
                self.callgetSubscibedList()
                
                
            })
        }
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewAddNew.isHidden = true
    }
    @IBAction func pnClickEditProfile(_ sender: UIButton) {
        self.navigationController?.pushViewController(EditProfileUserVC.storyboardInstance!, animated: true)
    }
    
    @IBAction func onClickAddNew(_ sender: UIButton) {
        viewAddNew.isHidden = false
        self.navigationBar.isHidden = true
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
extension ProfileUserVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Profile", action: #selector(onClickMenu(_:)))
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension ProfileUserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferenceDealCell.identifier, for: indexPath) as? PreferenceDealCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.layer.borderColor = UIColor.init(hexString: "E6E6E6").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        let data:SubscibedCategoryCls.CategoryList?
        data = categoryList[indexPath.row]
        cell.lblCategory.text = data?.categoryName
        cell.lblsubCategory.text = data?.subcategoryName
        cell.btnUnsubscribe.tag = indexPath.row
        cell.btnUnsubscribe.addTarget(self, action: #selector(onClickUnsubscribe(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func onClickUnsubscribe(_ sender:UIButton){
       
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.heightConstCollectionView.constant = self.dealCollectionView.contentSize.height
            self.dealCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 140)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    //        return imageSize
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
        private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
    
        }
    
    
        func reloadMoreData(indexPath: IndexPath) {
            if categoryList.count - 1 == indexPath.row &&
                (catObj!.currentPage > catObj!.TotalPages) {
                self.callgetSubscibedList()
            }
        }
}
extension ProfileUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewProfileCell.identifier) as? ReviewProfileCell else {
            fatalError("Cell can't be dequeue")
        }
        var dict = NSDictionary()
        dict = reviewList[indexPath.row] as! NSDictionary
        cell.lblUserName.text = dict.value(forKey: "MerchantName")as? String
        cell.lblReview.text = dict.value(forKey: "review_description")as? String
        cell.imgUser.downLoadImage(url: dict.value(forKey: "merchant_profile")as? String ?? "")
        cell.lblDate.text = dict.value(forKey: "reviewPostedOn")as? String
         return cell
    }
    
    func setAutoHeighttbl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.tblHeightConst.constant = self.tblReviews.contentSize.height
            self.tblReviews.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //reloadMoreData(indexPath: indexPath)
        self.tblHeightConst.constant = self.tblReviews.contentSize.height
        self.tblReviews.layoutIfNeeded()
        
    }
//
//
//    func reloadMoreData(indexPath: IndexPath) {
//        if reviewList.count - 1 == indexPath.row &&
//            (reviewObj!.currentPage > reviewObj!.TotalPages) {
//            self.callReviewsAPI()
//        }
//    }
}
extension ProfileUserVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView{
            return categoryListMain.count
        }
        else{
            return subCategoryList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView{
            if categoryList.count > 0{
                var dict = NSDictionary()
                dict = categoryListMain[row] as! NSDictionary
                selectedCategory = dict.value(forKey: "categoryName") as? String
                let str = dict.value(forKey: "categoryName")
                txtCategory.text = str as? String
                strCatId = (dict.value(forKey: "id") as? String)!
                callGetSubCategory()
            }
        }
        else if pickerView == subCategoryPickerView{
            if subCategoryList.count > 0{
                var dict = NSDictionary()
                dict = subCategoryList[row] as! NSDictionary
                selectedSubCategory = dict.value(forKey: "subcategoryName") as? String
                let str = dict.value(forKey: "subcategoryName")
                txtSubategory.text = str as? String
                strCatSubId = (dict.value(forKey: "id") as? String)!
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        if pickerView == categoryPickerView{
            var dict = NSDictionary()
            dict = categoryListMain[row] as! NSDictionary
            let str = dict.value(forKey: "categoryName")
            label.text = str as? String
        }
        else{
            var dict = NSDictionary()
            dict = subCategoryList[row] as! NSDictionary
            let str = dict.value(forKey: "subcategoryName") as? String
            label.text = str
        }
        return label
    }
}
extension ProfileUserVC: UITextFieldDelegate {
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == txtCategory || textField == txtSubategory {
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCategory {
            callGetSubCategory()
        }
    }
    
}
