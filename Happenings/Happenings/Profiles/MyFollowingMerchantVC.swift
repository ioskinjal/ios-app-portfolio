//
//  MyFollowingMerchantVC.swift
//  Happenings
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyFollowingMerchantVC: BaseViewController {

    static var storyboardInstance: MyFollowingMerchantVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: MyFollowingMerchantVC.identifier) as? MyFollowingMerchantVC
    }
    
    @IBOutlet weak var collectionViewMerchant: UICollectionView!{
        didSet{
            collectionViewMerchant.delegate = self
            collectionViewMerchant.dataSource = self
            collectionViewMerchant.register(FollwingMerchantCell.nib, forCellWithReuseIdentifier: FollwingMerchantCell.identifier)
        }
    }
    
    var merchantList = [FolowMechantCls.MerchantList]()
    var merchantObj: FolowMechantCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Following Merchant", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        callGetFollowingMerchant()
    }
    
    func callGetFollowingMerchant(){
        
         let nextPage = (merchantObj?.currentPage ?? 0 ) + 1
        
        let param = ["action":"merchant-follow-list",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.getFollowingMerchant(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.collectionViewMerchant.backgroundView = bgImage
        }) { (dic) in
            self.merchantObj = FolowMechantCls(dictionary: dic)
            if self.merchantList.count > 0{
                self.merchantList += self.merchantObj!.merchantList
            }
            else{
                self.merchantList = self.merchantObj!.merchantList
            }
            if self.merchantList.count != 0 {
                self.collectionViewMerchant.reloadData()
                
            }
        }
       
    }

    @objc func onClickMenu(_ sender: UIButton){
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
extension MyFollowingMerchantVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchantList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollwingMerchantCell.identifier, for: indexPath) as? FollwingMerchantCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
       cell.btnUnfollow.layer.borderColor = UIColor(hexString: "E0171E").cgColor
        cell.lblMerchantName.text = merchantList[indexPath.row].merchantName
        if merchantList[indexPath.row].receive_notification == "y"{
            cell.btnNotify.setImage(#imageLiteral(resourceName: "red-radio"), for: .normal)
        }else{
            cell.btnNotify.setImage(#imageLiteral(resourceName: "gray-radio"), for: .normal)
        }
        cell.imgMerchant.downLoadImage(url: merchantList[indexPath.row].merchantImage!)
        cell.btnUnfollow.tag = indexPath.row
        cell.btnUnfollow.addTarget(self, action: #selector(onClickUnfollow(_:)), for: .touchUpInside)
        cell.btnNotify.tag = indexPath.row
        cell.btnNotify.addTarget(self, action: #selector(onClickNotify), for: .touchUpInside)
        return cell
        
    }
    
    @objc func onClickNotify(_ sender:UIButton){
        var param = ["following_id":merchantList[sender.tag].following_id!,
                     "user_id":UserData.shared.getUser()!.user_id,
                     "action":"change-following-notification"]
        if sender.currentImage == #imageLiteral(resourceName: "red-radio") {
            param["receive_notification"] = "n"
            sender.setImage(#imageLiteral(resourceName: "Grey"), for: .normal)
        }else{
            param["receive_notification"] = "y"
            sender.setImage(#imageLiteral(resourceName: "red-radio"), for: .normal)
        }
        
        Modal.shared.changeFollowingNotification(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.merchantList = [FolowMechantCls.MerchantList]()
                self.callGetFollowingMerchant()
            })
        }
        
    }
    
    @objc func onClickUnfollow(_ sender:UIButton) {
        let param = ["action":"follow-unfollow",
                     "customer_id":"205",
                     "merchant_id":merchantList[sender.tag].merchant_id!,
                     "actionType":"unfollow"]
       
        Modal.shared.getFollowUnfollow(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.merchantList = [FolowMechantCls.MerchantList]()
                self.callGetFollowingMerchant()
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = FollowMerchantProfileVC.storyboardInstance!
        nextVC.strId = merchantList[indexPath.row].merchant_id!
        nextVC.merchantData = merchantList[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 282)
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
            if merchantList.count - 1 == indexPath.row &&
                (merchantObj!.currentPage > merchantObj!.TotalPages) {
                self.callGetFollowingMerchant()
            }
        }
}
