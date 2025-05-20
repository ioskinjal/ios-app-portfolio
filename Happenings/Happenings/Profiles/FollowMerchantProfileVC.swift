//
//  FollowMerchantProfileVC.swift
//  Happenings
//
//  Created by admin on 3/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FollowMerchantProfileVC: BaseViewController {

    static var storyboardInstance: FollowMerchantProfileVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: FollowMerchantProfileVC.identifier) as? FollowMerchantProfileVC
    }
    
    @IBOutlet weak var imgMerchant: UIImageView!{
        didSet{
            imgMerchant.setRadius()
        }
    }
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var DealsCollectionView: UICollectionView!{
        didSet{
            DealsCollectionView.delegate = self
            DealsCollectionView.dataSource = self
            DealsCollectionView.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    var merchantData:FolowMechantCls.MerchantList?
    
    var dealList = [MerchantDealClass.MyDealList]()
    var dealObj: MerchantDealClass?
    var strId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Merchant Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
        setAutoHeight()
        imgMerchant.downLoadImage(url: (merchantData?.merchantImage)!)
        lblMerchantName.text = merchantData?.merchantName
        callGetMerchantProfile()
    }
    
    
    func callGetMerchantProfile(){
         let nextPage = (dealObj?.currentPage ?? 0 ) + 1
            let param = ["action": "merchant-profile-page",
                         "profile":merchantData!.merchant_id!,
                         "page":nextPage] as [String : Any]
        
        Modal.shared.getMerchantProfilePage(vc: self, param: param) { (dic) in
            self.dealObj = MerchantDealClass(dictionary: dic)
            if self.dealList.count > 0{
                self.dealList += self.dealObj!.dealList
            }
            else{
                self.dealList = self.dealObj!.dealList
            }
            if self.dealList.count != 0{
                self.DealsCollectionView.reloadData()
            }
            
        }
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func onClickFollow(_ sender: UIButton) {
        let param:[String:Any] = ["action":"follow-unfollow",
                     "customer_id":UserData.shared.getUser()!.user_id,
                     "merchant_id":merchantData!.merchant_id!,
                     "actionType":"follow"]
        
        Modal.shared.getFollowUnfollow(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.callGetMerchantProfile()
                
            })
        }
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
extension FollowMerchantProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.lblDistance.isHidden = true
        cell.viewRound.isHidden = true
        cell.viewRound2.isHidden = true
        cell.lblDistance2.isHidden = true
        cell.btnFavorite.isHidden = true
        let data:MerchantDealClass.MyDealList?
        data = dealList[indexPath.row]
        cell.lblLocation.text = data?.deal_location
        cell.lblRealPrice.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,(data?.option_price)!)
        cell.lblPriceDiscount.text = String(format: "%@%@", (UserData.shared.getUser()?.currency)!,(data?.discount_price)!)
        cell.lblCategory.text = (data?.categoryName)! + " & " + (data?.subcategoryName)!
        cell.lblDealName.text = data?.deal_title
        cell.imgDeal.downLoadImage(url: (data?.image_name)!)
        cell.stackViewRate.isHidden = true
        cell.stackViewLocation.isHidden = false
        cell.satckViewPrice.isHidden = false
        return cell
        
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collectionViewHeightConst.constant = self.DealsCollectionView.contentSize.height
            self.DealsCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 273)
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
            if dealList.count - 1 == indexPath.row &&
                (dealObj!.currentPage > dealObj!.TotalPages) {
                self.callGetMerchantProfile()
            }
        }
}
