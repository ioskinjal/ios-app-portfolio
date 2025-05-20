//
//  ProfileMerchantVC.swift
//  Happenings
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class ProfileMerchantVC: BaseViewController {
    
    static var storyboardInstance: ProfileMerchantVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: ProfileMerchantVC.identifier) as? ProfileMerchantVC
    }
    
    
    @IBOutlet weak var viewBankAddress: UIView!{
        didSet{
//            DispatchQueue.main.async {
                self.viewBankAddress.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewBankAddress.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewBankAddress.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewBankAddress.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
//            }
        }
    }
    @IBOutlet weak var lblBankAddress: UILabel!
    @IBOutlet weak var lblIfscCode: UILabel!
    @IBOutlet weak var viewIfscCode: UIView!{
        didSet{
//            DispatchQueue.main.async {
                self.viewIfscCode.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewIfscCode.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewIfscCode.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
                self.viewIfscCode.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
//            }
        }
    }
    @IBOutlet weak var lblbankName: UILabel!
    @IBOutlet weak var viewBank: UIView!{
        didSet{
//            DispatchQueue.main.async {
                self.viewBank.border(side: .left, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBank.border(side: .right, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBank.border(side: .top, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBank.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
//            }
        }
    }
    @IBOutlet weak var lblbankAccNumber: UILabel!
    @IBOutlet weak var viewAccNumber: UIView!{
        didSet{
//            DispatchQueue.main.async {
                self.viewAccNumber.border(side: .left, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewAccNumber.border(side: .right, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewAccNumber.border(side: .top, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewAccNumber.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
//            }
        }
    }
    @IBOutlet weak var viewBanklHolderName: UIView!{
        didSet{
//            DispatchQueue.main.async {
                self.viewBanklHolderName.border(side: .left, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBanklHolderName.border(side: .right, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBanklHolderName.border(side: .top, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
                self.viewBanklHolderName.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
//            }
        }
    }
    @IBOutlet weak var lblBankHolderName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!{
        didSet{
            categoryCollectionView.delegate = self
            categoryCollectionView.dataSource = self
            categoryCollectionView.register(ProfileCategoryCell.nib, forCellWithReuseIdentifier: ProfileCategoryCell.identifier)
        }
    }
    @IBOutlet weak var heightConstCollectionView: NSLayoutConstraint!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebURL: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var array = [AnyObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setAutoHeight()
       callgetProfile()
    }
    
    func callgetProfile(){
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getMerchantProfile(vc: self, param: param) { (dic) in
            print(dic)
            let data = ResponseKey.fatchData(res: dic["data"] as! dictionary, valueOf: .profile_data).dic
            _ = UserData.shared.setUser(dic: data)
            let user = UserData.shared.getUser()
            self.lblName.text = (user?.firstName)! + " " + (user?.lastName)!
            self.lblEmail.text = user?.email
            self.lblDesc.text = user?.desc
            self.lblWebURL.text = user?.website
            self.lblbankName.text = user?.bank_name
            self.lblIfscCode.text = user?.bank_ifsc_code
            self.lblLocation.text = user?.address
            self.lblBankAddress.text = user?.bank_address
            self.lblCompanyName.text = user?.store_name
            self.lblbankName.text = user?.bank_name
            self.lblProductCount.text = user?.no_of_product_sold
            self.lblbankAccNumber.text = user?.bank_acc_number
            self.lblContactNumber.text = user?.contact_no
            self.lblBankHolderName.text = user?.bank_acc_holder_name
            self.imgProfile.downLoadImage(url: (user?.profile_img_path)!)
            let dict:NSDictionary = dic["data"] as! NSDictionary
            self.array = (dict.value(forKey: "deal_cats") as AnyObject) as! [AnyObject]
            self.categoryCollectionView.reloadData()
            self.setAutoHeight()
        }
        
    }
    
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        let nextVC = EditProfileMerchantVC.storyboardInstance!
        nextVC.selectedCategoryList = array
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
extension ProfileMerchantVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Profile", action: #selector(onClickMenu(_:)))
        
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension ProfileMerchantVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCategoryCell.identifier, for: indexPath) as? ProfileCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        let dict:[String:String] = array[indexPath.row] as! [String : String]
        cell.lblName.text = dict["categoryName"]
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        return cell
        
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.heightConstCollectionView.constant = self.categoryCollectionView.contentSize.height
            self.categoryCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let dict:NSDictionary = array[indexPath.row] as! NSDictionary
        let text = dict.value(forKey: "categoryName")
        let titleFont = TitilliumWebFont.regular(with: 17.0)
        let width = UILabel.textWidth(font: titleFont, text: text! as! String)
        return CGSize(width: width + 10 + 10, height: 50)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    //        return imageSize
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //    }
    
    //    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
    //        reloadMoreData(indexPath: indexPath)
    //
    //    }
    //
    //
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if merchantList.count - 1 == indexPath.row &&
    //            (merchantObj!.currentPage > merchantObj!.TotalPages) {
    //            self.callGetFollowingMerchant()
    //        }
    //    }
}
extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
