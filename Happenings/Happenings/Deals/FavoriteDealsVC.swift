//
//  FavoriteDealsVC.swift
//  Happenings
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import ImageSlideshow

class FavoriteDealsVC: BaseViewController {

    
    static var storyboardInstance:FavoriteDealsVC? {
        return StoryBoard.deals.instantiateViewController(withIdentifier: FavoriteDealsVC.identifier) as? FavoriteDealsVC
    }
    
    @IBOutlet weak var btnRemoveAll: UIButton!
    @IBOutlet weak var collectionViewDeal: UICollectionView!{
        didSet{
            collectionViewDeal.delegate = self
            collectionViewDeal.dataSource = self
            collectionViewDeal.register(FavoriteDealCell.nib, forCellWithReuseIdentifier: FavoriteDealCell.identifier)
        }
    }
    
    //var dealList = [FavoriteDealCls]()
    var favObj: FavoriteDealCls?
  //  var arrImages = [FavoriteDealCls.FavDealList.DealImages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpUI()
        callgetFavoriteDeals()
    }
    
    func callgetFavoriteDeals(){
        
        let nextPage = (favObj?.currentPage ?? 0 ) + 1
        
        let param = ["action":"list-favorite-deals",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.getFavoriteDeals(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            self.btnRemoveAll.isHidden = true
            
            self.collectionViewDeal.backgroundView = bgImage
        }) { (dic) in
            self.favObj = FavoriteDealCls(dictionary: dic)
            self.collectionViewDeal.reloadData()
        }
        
    }

    @IBAction func oncLickRemoveALL(_ sender: UIButton) {
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "action":"action:remove-deal-from-favorite",
                     "remove":"all"]
        
        Modal.shared.removeToFavorite(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
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

//MARK: Custom function

extension FavoriteDealsVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Favorite Deals", action: #selector(onClickMenu(_:)))
        
        
    }
   
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
  
    
}

extension FavoriteDealsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favObj?.dealList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteDealCell.identifier, for: indexPath) as? FavoriteDealCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickAddToFav(_:)), for: .touchUpInside)
        cell.lblMerchantName.text = favObj?.dealList[indexPath.row].MerchantName
        cell.lblCat.text =  (favObj?.dealList[indexPath.row].categoryName)! + "&" + (favObj?.dealList[indexPath.row].subcategoryName)!
        cell.lblDeal.text = favObj?.dealList[indexPath.row].deal_title
        cell.imgDeal.downLoadImage(url: (favObj?.dealList[indexPath.row].dealImages)!)
        if favObj?.dealList[indexPath.row].MerchantName == "Admin"{
            cell.imgAdmin.isHidden = false
        }else{
            cell.imgAdmin.isHidden = true
        }
        return cell
        
    }
    
    @objc func onClickAddToFav(_ sender:UIButton)
    {
        let param = ["action":"remove-deal-from-favorite",
                     "user_id":"205",
                     "favorite_id":favObj!.dealList[sender.tag].favorite_id!]
        
        Modal.shared.removeToFavorite(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callgetFavoriteDeals()
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        if (favObj?.dealList.count)! - 1 == indexPath.row &&
            (favObj!.currentPage > favObj!.TotalPages) {
            self.callgetFavoriteDeals()
        }
    }
}
