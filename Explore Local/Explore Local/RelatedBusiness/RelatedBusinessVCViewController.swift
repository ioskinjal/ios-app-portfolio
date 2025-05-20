//
//  RelatedBusinessVCViewController.swift
//  Explore Local
//
//  Created by admin on 1/21/19.
//  Copyright © 2019 NCrypted. All rights reserved.
//

import UIKit

class RelatedBusinessVCViewController: BaseViewController {

    static var storyboardInstance: RelatedBusinessVCViewController? {
        return StoryBoard.main.instantiateViewController(withIdentifier: RelatedBusinessVCViewController.identifier) as? RelatedBusinessVCViewController
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(FavouriteBusinessCell.nib, forCellWithReuseIdentifier: FavouriteBusinessCell.identifier)
        }
    }
    
     var business_id = String()
    var businessListRelated = [RelatedBusinessCls.RelatedBusinessList]()
 var relatedObj: RelatedBusinessCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Related Businessess", action: #selector(onClickMenu(_:)))
        
        callRelatedBusiness()
    }
    
    func callRelatedBusiness(){
        let nextPage = (relatedObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"related_business",
                     "business_id":business_id,
                     "page":nextPage] as [String : Any]
        
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            self.relatedObj = RelatedBusinessCls(dictionary: dic)
            if self.businessListRelated.count > 0{
                self.businessListRelated += self.relatedObj!.businessList
            }
            else{
                self.businessListRelated = self.relatedObj!.businessList
            }
            if self.businessListRelated.count != 0{
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RelatedBusinessVCViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessListRelated.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteBusinessCell.identifier, for: indexPath) as? FavouriteBusinessCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.lblName.text = businessListRelated[indexPath.row].business_name
        cell.lblCat.text = businessListRelated[indexPath.row].category
        cell.lblSubCat.text =  businessListRelated[indexPath.row].subcategory
        cell.imgView.downLoadImage(url:businessListRelated[indexPath.row].image!)
        cell.lblTotal.text = businessListRelated[indexPath.row].total_reviews
        cell.lblRate.text = businessListRelated[indexPath.row].average_rating
        cell.btnRemove.isHidden = true
        cell.viewCat.layer.borderColor = UIColor.white.cgColor
        cell.viewSubCat.layer.borderColor = UIColor.white.cgColor
        cell.contentView.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 241)
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
        if businessListRelated.count - 1 == indexPath.row &&
            (relatedObj!.pagination!.current_page > relatedObj!.pagination!.total_pages) {
            self.callRelatedBusiness()
        }
    }
}

