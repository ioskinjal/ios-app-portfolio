//
//  HomeVC.swift
//  Happenings
//
//  Created by admin on 2/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: BaseViewController {
    
    static var storyboardInstance: HomeVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: HomeVC.identifier) as? HomeVC
    }
    @IBOutlet weak var btnViewAllNearByRadius: UIButton!
    
    @IBOutlet weak var btnViewAllLatestDeals: UIButton!
    @IBOutlet weak var heightConstLatest: NSLayoutConstraint!
    @IBOutlet weak var heightConstNearBy: NSLayoutConstraint!
    @IBOutlet weak var collectionViewDeals: UICollectionView!{
        didSet{
            collectionViewDeals.delegate = self
            collectionViewDeals.dataSource = self
            collectionViewDeals.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    
    let user = UserData.shared.getUser()
    var currentLocation: CLLocation?
    var locManager = CLLocationManager()
    var nearDealList = [NearByDealCls.NearDealList]()
    var nearDealListDisplay = [NearByDealCls.NearDealList]()
    var dealObj: NearByDealCls?
    
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var collectionViewLatestDeal: UICollectionView!{
        didSet{
            collectionViewLatestDeal.delegate = self
            collectionViewLatestDeal.dataSource = self
            collectionViewLatestDeal.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    
    var latestDealList = [LatestDealList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callNearByRadius()
        setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "Home", action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickSearch(_:)), btnRightImg: #imageLiteral(resourceName: "search"))
        determineMyCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    //UserData.shared.getUser()!.selected_radius
    //currentLocation?.coordinate.latitude ?? ""
    //currentLocation?.coordinate.longitude ?? ""
    func callNearByRadius(){
    //    let nextPage = (dealObj?.pagination?.currentPage ?? 0 ) + 1
        
        var param = ["cur_lat":currentLocation?.coordinate.latitude  ?? 22.3039,
                     "cur_long":currentLocation?.coordinate.longitude ?? 70.8022,
                     "radius":5,
                     "page_no":1] as [String : Any]
        
        if UserData.shared.getUser() != nil{
            param["user_id"] = UserData.shared.getUser()!.user_id
        }else{
            param["user_id"] = ""
        }
        Modal.shared.searchNearByDeals(vc: self, param: param, failer: { (dic) in
            print("faile")
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            self.btnViewAllNearByRadius.isHidden = true
            
            self.collectionViewDeals.backgroundView = bgImage
        }) { (dic) in
            print("Success")
            self.dealObj = NearByDealCls(dictionary: dic)
            if self.nearDealList.count > 0{
                self.nearDealList += self.dealObj!.dealList
            }
            else{
                self.nearDealList = self.dealObj!.dealList
            }
            
            
            
            if self.nearDealList.count != 0{
                self.nearDealListDisplay = [NearByDealCls.NearDealList]()
                if self.nearDealList.count > 2{
                    self.nearDealListDisplay.append(self.nearDealList[0])
                    self.nearDealListDisplay.append(self.nearDealList[1])
                }else if self.nearDealList.count < 2{
                    self.nearDealListDisplay.append(self.nearDealList[0])
                    self.btnViewAllNearByRadius.isHidden = true
                }else if self.nearDealList.count == 2{
                    self.btnViewAllNearByRadius.isHidden = true
                }
                self.collectionViewDeals.reloadData()
            }
            self.callLatestDeals()
        }
        
        
        
    }
    
    func determineMyCurrentLocation() {
        locManager.requestWhenInUseAuthorization();
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }
    
    func callLatestDeals(){
        
        
        var param = ["action":"latest-deals"]
        
        if user != nil{
            param["user_id"] = UserData.shared.getUser()!.user_id
        }
        
        Modal.shared.getLatestDeals(vc: self, param: param) { (dic) in
            self.latestDealList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({LatestDealList(dictionary: $0 as! [String:Any])})
            
            if self.latestDealList.count > 2 {
                self.latestDealList.removeLast()
            }else if self.latestDealList.count < 2 || self.latestDealList.count == 2 {
                self.btnViewAllLatestDeals.isHidden = true
            }
            
            if self.latestDealList.count != 0{
                self.collectionViewLatestDeal.reloadData()
            }else{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                
                self.collectionViewLatestDeal.backgroundView = bgImage
            }
            //self.setAutoHeight()
            
        }
        callAdBanner()
        
        
    }
    
    func callAdBanner(){
        
        var param = ["action":"ad-banner"]
        
        if user != nil{
            param["user_id"] = UserData.shared.getUser()!.user_id
        }
        Modal.shared.getAdBanner(vc: self, param: param) { (dic) in
            print(dic)
            let dict:[String:String] = dic["data"] as! [String : String]
            self.imgAd.downLoadImage(url: dict["image_name"]!)
        }
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.heightConstLatest.constant = self.collectionViewLatestDeal.contentSize.height
            self.collectionViewLatestDeal.layoutIfNeeded()
            
            self.heightConstNearBy.constant = self.collectionViewDeals.contentSize.height
            self.collectionViewDeals.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    @objc func onClickMenu(_ sender: UIButton){
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @objc func onClickSearch(_ sender: UIButton){
        self.navigationController?.pushViewController(SearchVC.storyboardInstance!, animated: true)
    }
    
    
    @IBAction func onClickViewAllLatest(_ sender: UIButton) {
        let nextVC = ViewAllDealVC.storyboardInstance!
        nextVC.isLatestDeal = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickViewAllNearBy(_ sender: UIButton) {
        let nextVC = ViewAllDealVC.storyboardInstance!
        nextVC.isLatestDeal = false
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
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDeals{
            return nearDealListDisplay.count
        }else{
            return latestDealList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDeals{
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
            var data:NearByDealCls.NearDealList?
            data = nearDealListDisplay[indexPath.row]
            cell.lblCategory.text = (data?.categoryName)! + " & " + (data?.subcategoryName)!
            cell.lblDealName.text = data?.deal_title
            cell.imgDeal.downLoadImage(url: (data?.dealImages)!)
            cell.lblDistance.text = data?.deal_distance
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
                fatalError("Cell can't be .dequeue")
            }
            
            cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            cell.lblDistance2.isHidden = true
            cell.viewRound2.isHidden = true
            cell.btnFavorite.isHidden = true
            cell.lblDistance.isHidden = true
            cell.viewRound.isHidden = true
            let data:LatestDealList?
            data = latestDealList[indexPath.row]
            cell.imgDeal.downLoadImage(url: (data?.deal_image)!)
            cell.lblCategory.text = (data?.deal_category)! + " & " + (data?.deal_subcategory)!
            cell.lblDealName.text = data?.deal_title
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewLatestDeal {
            let nextVc = DealDetailVC.storyboardInstance!
            nextVc.strId = latestDealList[indexPath.row].deal_id ?? ""
            self.navigationController?.pushViewController(nextVc, animated: true)
        }else if collectionView == collectionViewDeals{
            let nextVc = DealDetailVC.storyboardInstance!
            nextVc.strId = nearDealList[indexPath.row].deal_id ?? ""
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewLatestDeal {
            return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 10 ), height: 230)
        }else{
            return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 10 ), height: 230)
        }
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
extension HomeVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        currentLocation = locations[0]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
