//
//  FavouriteBusinessVC.swift
//  Explore Local
//
//  Created by NCrypted on 08/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
//import CHTCollectionViewWaterfallLayout


class FavouriteBusinessVC: BaseViewController {

    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.borderColor = UIColor.init(hexString: "6367F9").cgColor
        }
    }
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var collectionViewConst: NSLayoutConstraint!
    @IBOutlet weak var tblFavorite: UITableView!{
        didSet{
            tblFavorite.delegate = self
            tblFavorite.dataSource = self
           tblFavorite.register(SeachBusinessCell.nib, forCellReuseIdentifier: SeachBusinessCell.identifier)
           
        }
    }
    
//    @IBOutlet weak var collectionViewFavourite: UICollectionView!{
//        didSet{
//            collectionViewFavourite.delegate = self
//            collectionViewFavourite.dataSource = self
//            collectionViewFavourite.register(FavouriteBusinessCell.nib, forCellWithReuseIdentifier: FavouriteBusinessCell.identifier)
//
//            if let layout = collectionViewFavourite.collectionViewLayout as? PinterestLayout {
//                layout.delegate = self
//            }
//            collectionViewFavourite.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//          //  layout.minimumColumnSpacing = 1.0
//           // layout.minimumInteritemSpacing = 1.0
//            self.collectionViewFavourite.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
//            self.collectionViewFavourite.alwaysBounceVertical = true
//           // self.collectionViewFavourite.collectionViewLayout = layout
//        }
//    }
    
    static var storyboardInstance:FavouriteBusinessVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: FavouriteBusinessVC.identifier) as? FavouriteBusinessVC
    }
    
    var businessList = [FavouriteBusinessCls.BusinessList]()
    var favouriteObj: FavouriteBusinessCls?
    var heightData: [CGFloat] = [200.0, 150.0, 250.0, 100.0, 225.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Favorite Business", action: #selector(onClickMenu(_:)))
       
        callGetFavouriteBusiness()
        
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    func callGetFavouriteBusiness(){
        let nextPage = (favouriteObj?.pagination?.current_page ?? 0 ) + 1
            let param = ["action":"favorite",
                         "user_id":UserData.shared.getUser()!.user_id,
                         "page":nextPage] as [String : Any]
        Modal.shared.account(vc: self, param: param) { (dic) in
            self.favouriteObj = FavouriteBusinessCls(dictionary: dic)
            if self.businessList.count > 0{
                self.businessList += self.favouriteObj!.businessList
            }
            else{
                self.businessList = self.favouriteObj!.businessList
            }
            if self.businessList.count != 0 {
            
            self.btnCancel.isHidden = false
            }else{
                self.btnCancel.isHidden = true
                self.lblNoData.isHidden = false
            }
            self.tblFavorite.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onClickRemoveAll(_ sender: UIButton) {
        let param = ["action":"remove_all_favorite",
                     "user_id":UserData.shared.getUser()!.user_id
                     ]
        Modal.shared.account(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.businessList = [FavouriteBusinessCls.BusinessList]()
                self.favouriteObj = nil
                self.callGetFavouriteBusiness()
            })
        }
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
//extension FavouriteBusinessVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return businessList.count
//        return businessList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteBusinessCell.identifier, for: indexPath) as? FavouriteBusinessCell else {
//            fatalError("Cell can't be dequeue")
//        }
//        cell.imgView.downLoadImage(url: businessList[indexPath.row].image!)
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.cornerRadius = 5.0
//        cell.layer.masksToBounds = true
//        cell.viewSubCat.layer.borderColor = UIColor.white.cgColor
//        cell.viewCat.layer.borderColor = UIColor.white.cgColor
//        cell.lblCat.text =  businessList[indexPath.row].category
//        cell.lblSubCat.text = businessList[indexPath.row].subcategory
//        cell.lblName.text = businessList[indexPath.row].business_name
//       // cell.lblRate.text = String(format: "%d", businessList[indexPath.row].average_rating!)
//        cell.lblTotal.text = "(" +  businessList[indexPath.row].total_reviews! + ")"
//        if indexPath.row%2 == 0 {
//            cell.imgView.backgroundColor = UIColor.yellow
//        }else {
//            cell.imgView.backgroundColor = UIColor.blue
//        }
//        cell.btnRemove.tag = indexPath.row
//        cell.btnRemove.addTarget(self, action: #selector(onClickUnFav(_:)), for: .touchUpInside)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let nextVC = BuisnessDetailVC.storyboardInstance!
//        nextVC.strBus_id = businessList[indexPath.row].business_id!
//        self.navigationController?.pushViewController(nextVC, animated: true)
//    }
//
//
//
//    //MARK: UICollectionViewDelegateFlowLayout Methods
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        // create a cell size from the image size, and return the size
////
////
////
////        return imageSize
////    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        // create a cell size from the image size, and return the size
////
////        var height:Int = Int(collectionView.frame.size.width/2)
////        height = (businessList[indexPath.row].height! * businessList[indexPath.row].width!)/height
////
////        return CGSize(width: collectionView.frame.size.width/2, height:CGFloat(height))
////    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
////    }
//}
// MARK: - Flow layout delegate

//extension FavouriteBusinessVC: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//
//        //let height = CGFloat(businessList[indexPath.row].height!/4)
//        let height:Int = Int(collectionView.frame.size.width/2)
//        let newHeight = (height * businessList[indexPath.row].width!)/businessList[indexPath.row].height!
//        // let newHeight = (height * businessList[indexPath.row].height!)/businessList[indexPath.row].width!
//
//        return CGFloat(newHeight)
//    }
//}
extension FavouriteBusinessVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeachBusinessCell.identifier) as? SeachBusinessCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
        cell.imgView.downLoadImage(url: businessList[indexPath.row].image!)
        //cell.layer.borderWidth = 1.0
        //cell.layer.borderColor = UIColor.lightGray.cgColor
        //cell.layer.cornerRadius = 5.0
        //cell.layer.masksToBounds = true
       // cell.btncategory.setTitle(businessList[indexPath.row].category, for: .normal)
        //cell.btnSubCategory.setTitle(businessList[indexPath.row].subcategory, for: .normal)
        //cell.btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        //cell.btncategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        cell.lblItemName.text = businessList[indexPath.row].business_name
        // cell.lblRate.text = String(format: "%d", businessList[indexPath.row].average_rating!)
        cell.lblrateCount.text = "(" +  businessList[indexPath.row].total_reviews! + ")"
        cell.lblRate.text = businessList[indexPath.row].average_rating ?? "0.0"
        cell.lblDiscount.isHidden = true
        cell.imgRound.isHidden = true
        cell.btnEdit.isHidden = true
        
        cell.btnDelete.isHidden = true
        cell.btnRemove.isHidden = false
        cell.lblLocation.text = businessList[indexPath.row].location
        cell.lblDesc.text = businessList[indexPath.row].description
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(onClickUnFav(_:)), for: .touchUpInside)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = BuisnessDetailVC.storyboardInstance!
        nextVC.strBus_id = businessList[indexPath.row].business_id!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickUnFav(_ sender:UIButton){
                let param = ["action":"favorite",
                             "user_id":UserData.shared.getUser()!.user_id,
                             "business_id":businessList[sender.tag].business_id!]
        
                Modal.shared.favUnfav(vc: self, param: param) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.businessList = [FavouriteBusinessCls.BusinessList]()
                        self.favouriteObj = nil
                        self.callGetFavouriteBusiness()
                    })
                }
        
            }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return businessList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if businessList.count - 1 == indexPath.row &&
            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
            self.callGetFavouriteBusiness()
        }
    }
    
}
