//
//  RecentViewedVC.swift
//  Happenings
//
//  Created by admin on 2/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RecentViewedVC: BaseViewController {

    static var storyboardInstance: RecentViewedVC? {
        return StoryBoard.search.instantiateViewController(withIdentifier: RecentViewedVC.identifier) as? RecentViewedVC
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(FavoriteDealCell.nib, forCellWithReuseIdentifier: FavoriteDealCell.identifier)
        }
    }
    
   
    var recentObj: FavoriteDealCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Recently View Deals", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        callRecentlyViewDeals()
    }
    
    func callRecentlyViewDeals(){
        let nextPage = (recentObj?.currentPage ?? 0 ) + 1
        let param = ["action":"recently-viewed-deal",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.getRecentlyViewDeals(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.collectionView.backgroundView = bgImage
        }) { (dic) in
            self.recentObj = FavoriteDealCls(dictionary: dic)
            self.collectionView.reloadData()
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
extension RecentViewedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentObj?.dealList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteDealCell.identifier, for: indexPath) as? FavoriteDealCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.lblCat.text =  (recentObj?.dealList[indexPath.row].categoryName)! + "&" + (recentObj?.dealList[indexPath.row].subcategoryName)!
        cell.lblDeal.text = recentObj?.dealList[indexPath.row].deal_title
        cell.imgDeal.downLoadImage(url: (recentObj?.dealList[indexPath.row].dealImages)!)
        cell.lblMerchantName.text = recentObj?.dealList[indexPath.row].MerchantName
        cell.btnDelete.isHidden = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 245)
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
    
    //    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
    //        reloadMoreData(indexPath: indexPath)
    //
    //    }
    
    
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if businessListRelated.count - 1 == indexPath.row &&
    //            (relatedObj!.pagination!.current_page > relatedObj!.pagination!.total_pages) {
    //            self.callRelatedBusiness()
    //        }
    //    }
}
