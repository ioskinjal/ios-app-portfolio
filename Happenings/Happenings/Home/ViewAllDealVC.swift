//
//  ViewAllDealVC.swift
//  Happenings
//
//  Created by admin on 2/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ViewAllDealVC: BaseViewController {

    static var storyboardInstance: ViewAllDealVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ViewAllDealVC.identifier) as? ViewAllDealVC
    }
    
    @IBOutlet weak var collectionViewDeal: UICollectionView!{
        didSet{
            collectionViewDeal.delegate = self
            collectionViewDeal.dataSource = self
            collectionViewDeal.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
     var isLatestDeal:Bool = true
    var latestDealList = [LatestDealList]()
    var nearDealList = [NearByDealCls.NearDealList]()
    var dealObj:NearByDealCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Near By Deals", action: #selector(onClickMenu(_:)))
        if isLatestDeal == true{
        callLatestDeals()
        }else{
            callNearByRadius()
        }
    }
    
    func callNearByRadius(){
        let nextPage = (dealObj?.pagination?.currentPage ?? 0 ) + 1
        
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "cur_lat":22.3039,
                     "cur_long":70.8022,
                     "radius":5,
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.searchNearByDeals(vc: self, param: param) { (dic) in
            self.dealObj = NearByDealCls(dictionary: dic)
            if self.nearDealList.count > 0{
                self.nearDealList += self.dealObj!.dealList
            }
            else{
                self.nearDealList = self.dealObj!.dealList
            }
            
            if self.nearDealList.count != 0{
                self.collectionViewDeal.reloadData()
            }
        }
    }
        
    
    func callLatestDeals(){
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "action":"latest-deals"]
        Modal.shared.getLatestDeals(vc: self, param: param) { (dic) in
            self.latestDealList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({LatestDealList(dictionary: $0 as! [String:Any])})
            
            if self.latestDealList.count != 0 {
                self.collectionViewDeal.reloadData()
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
extension ViewAllDealVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLatestDeal == true{
            return latestDealList.count
        }else{
            return nearDealList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if isLatestDeal == true{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
                fatalError("Cell can't be dequeue")
            }
            
            cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            cell.lblDistance2.isHidden = true
            cell.viewRound2.isHidden = true
            cell.btnFavorite.isHidden = true
            let data:LatestDealList?
            data = latestDealList[indexPath.row]
            cell.imgDeal.downLoadImage(url: (data?.deal_image)!)
            cell.lblCategory.text = (data?.deal_category)! + " & " + (data?.deal_subcategory)!
            cell.lblDealName.text = data?.deal_title
            return cell
         }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
                fatalError("Cell can't be dequeue")
            }
            
            cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            cell.lblDistance2.isHidden = true
            cell.viewRound2.isHidden = true
            cell.btnFavorite.isHidden = true
            let data:NearByDealCls.NearDealList?
            data = nearDealList[indexPath.row]
            cell.imgDeal.downLoadImage(url: (data?.dealImages)!)
            cell.lblCategory.text = (data?.categoryName)! + " & " + (data?.subcategoryName)!
            cell.lblDealName.text = data?.deal_title
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 204)
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
            if isLatestDeal == true{
            reloadMoreData(indexPath: indexPath)
            }
        }
    
    
        func reloadMoreData(indexPath: IndexPath) {
            
            if nearDealList.count - 1 == indexPath.row &&
                (dealObj!.pagination!.currentPage > dealObj!.pagination!.TotalPages) {
                self.callNearByRadius()
            }
        }
}
