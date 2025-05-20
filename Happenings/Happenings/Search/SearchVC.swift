//
//  SearchVC.swift
//  Happenings
//
//  Created by admin on 2/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import GooglePlaces
import MapKit

class SearchVC: BaseViewController {

    static var storyboardInstance: SearchVC? {
        return StoryBoard.search.instantiateViewController(withIdentifier: SearchVC.identifier) as? SearchVC
    }
    
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var viewFilterBy: UIView!
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            txtLocation.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Map"))
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var imgStar5: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    
    @IBOutlet weak var btnStar1: UIButton!
    @IBOutlet weak var viewStar5: UIView!{
        didSet{
            viewStar5.border(side: .bottom, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewStar4: UIView!{
        didSet{
            viewStar4.border(side: .bottom, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewStar3: UIView!{
        didSet{
            viewStar3.border(side: .bottom, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewStar2: UIView!{
        didSet{
            viewStar2.border(side: .bottom, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewStar1: UIView!{
        didSet{
            viewStar1.border(side: .bottom, color: UIColor.init(hexString: "E6E6E6"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var tblFilter: UITableView!{
        didSet{
            tblFilter.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblFilter.dataSource = self
            tblFilter.delegate = self
            tblFilter.tableFooterView = UIView()
            tblFilter.separatorStyle = .none
        }
    }
    @IBOutlet weak var viewRatings: UIView!
    @IBOutlet weak var tblCategory: UITableView!{
        didSet{
            tblCategory.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblCategory.dataSource = self
            tblCategory.delegate = self
            tblCategory.tableFooterView = UIView()
            tblCategory.separatorStyle = .singleLine
        }
    }
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var viewRange: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var collectionViewMap: UICollectionView!{
        didSet{
            collectionViewMap.delegate = self
            collectionViewMap.dataSource = self
            collectionViewMap.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    @IBOutlet weak var lblLower: UILabel!
    
    @IBOutlet weak var lblUpper: UILabel!
    var strKeyword:String = ""
    var filterList = ["Category","Sub-Category","Location","Price Range","Radius","Star Ratings"]
    var arrCategoryList = [AnyObject]()
    var strCatId:String = ""
    var strCatSubId:String = ""
    var arrSubCategoryList = [AnyObject]()
    var strFilterType:String = ""
    var selectedRowCategory:Int = -1
    var selectedRowSubCategory:Int = -1
    var selectedFilterIndex:Int = 0
     var strLocation:String = ""
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var selectedRating:String = ""
    var locManager = CLLocationManager()
   var currentLocation: CLLocation?
     var arrRadius = [AnyObject]()
    var strSelectedRadius:String = ""
    var searchResultList = [SearchResultCls.SearchList]()
    var mapList = [SearchResultCls.SearchList.DealLocationList]()
    var searchObj: SearchResultCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Search Deals", action: #selector(onClickMenu(_:)), isRightBtn: false)
        strFilterType = "category"
        callGetCategory()
        tblFilter.reloadData()
         locManager.requestWhenInUseAuthorization()
        
        
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
           // currentLocation = locManager.location
          
            
        }
        determineMyCurrentLocation()
        callRadisAPI()
        callSearchAPI()
        
        let button = UIButton()
        onClickGrid(btnGrid)
    }
    
    func callRadisAPI(){
        let param = ["action":"radiuslist"]
        
        Modal.shared.getRadiusList(vc: self, param: param) { (dic) in
            print(dic)
            self.arrRadius = dic["date"] as! [AnyObject]
            if self.arrRadius.count != 0{
                self.tblCategory.reloadData()
            }
        }
    }
    
    
    func determineMyCurrentLocation() {
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
            filterList = ["Category","Sub-Category","Location","Price Range","Radius","Star Ratings"]
           
        }else{
            filterList = ["Category","Sub-Category","Location","Price Range","Star Ratings"]
        }
    }
    
    func callSearchAPI(){
        
         let nextPage = (searchObj?.currentPage ?? 0 ) + 1
        
        var param = ["latitude":currentLocation?.coordinate.latitude ?? "",
                     "longitude":currentLocation?.coordinate.longitude ?? "",
                     "search_keyword":strKeyword,
                     "cat_id":strCatId,
                     "subcat_id":strCatSubId,
                     "min_price":lblLower.text!,
                     "max_price":lblUpper.text!,
                     "radius":strSelectedRadius,
                     "ratings":selectedRating,
                     "loc_lat":latitude ?? "",
                     "loc_lon":longitude ?? "",
                     "page_no":nextPage] as [String : Any]
        
         let user = UserData.shared.getUser()
        
        if user != nil {
            param["user_id"] = UserData.shared.getUser()!.user_id
            param["user_type"] = UserData.shared.getUser()!.user_type
        }
        Modal.shared.getSearchResult(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            self.viewFilterBy.isHidden = true
            self.navigationBar.isHidden = false
            self.collectionView.reloadData()
            self.collectionView.backgroundView = bgImage
            self.collectionViewMap.reloadData()
            self.collectionViewMap.backgroundView = bgImage
        }) { (dic) in
            self.searchObj = SearchResultCls(dictionary: dic)
            if self.searchResultList.count > 0{
                self.searchResultList += self.searchObj!.searchList
            }
            else{
                self.searchResultList = self.searchObj!.searchList
            }
            if self.searchResultList.count != 0{
                self.collectionView.reloadData()
                self.collectionView.backgroundView = nil
                self.collectionViewMap.reloadData()
                for i in 0..<self.searchResultList.count{
                    self.mapList.append(contentsOf: self.searchResultList[i].locList)
                    
                }
                if self.mapList.count != 0{
                    
                }
            }else{
                let bgImage = UIImageView();
                bgImage.image = UIImage(named: "no_data_found");
                bgImage.contentMode = .scaleAspectFit
                bgImage.clipsToBounds = true
                self.collectionView.backgroundView = bgImage
            }
            
            self.viewFilterBy.isHidden = true
            self.navigationBar.isHidden = false
            
            
        }
        
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickMap(_ sender: UIButton) {
        btnGrid.setImage(#imageLiteral(resourceName: "Grid-white"), for: .normal)
        btnMap.setImage(#imageLiteral(resourceName: "Map-red"), for: .normal)
        self.collectionView.isHidden = true
        self.collectionViewMap.isHidden = false
    }
    @IBAction func onClickGrid(_ sender: UIButton) {
        btnGrid.setImage(#imageLiteral(resourceName: "Grid-red"), for: .normal)
        btnMap.setImage(#imageLiteral(resourceName: "Location"), for: .normal)
        
        self.collectionView.isHidden = false
        self.collectionViewMap.isHidden = true
    }
    @IBAction func onClickFilter(_ sender: Any) {
        viewFilterBy.isHidden = false
        self.navigationBar.isHidden = true
    }
    @IBAction func onClickRatings(_ sender: UIButton) {
        if sender.tag == 0{
            selectedRating = "1"
            imgStar1.isHidden = false
            imgStar2.isHidden = true
            imgStar3.isHidden = true
            imgStar4.isHidden = true
            imgStar5.isHidden = true
        }else if sender.tag == 1{
            selectedRating = "2"
            imgStar1.isHidden = true
            imgStar2.isHidden = false
            imgStar3.isHidden = true
            imgStar4.isHidden = true
            imgStar5.isHidden = true
        }else if sender.tag == 2{
            selectedRating = "3"
            imgStar1.isHidden = true
            imgStar2.isHidden = true
            imgStar3.isHidden = false
            imgStar4.isHidden = true
            imgStar5.isHidden = true
        }else if sender.tag == 3{
            selectedRating = "4"
            imgStar1.isHidden = true
            imgStar2.isHidden = true
            imgStar3.isHidden = true
            imgStar4.isHidden = false
            imgStar5.isHidden = true
        }else{
            selectedRating = "5"
            imgStar1.isHidden = true
            imgStar2.isHidden = true
            imgStar3.isHidden = true
            imgStar4.isHidden = true
            imgStar5.isHidden = false
        }
    }
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
        print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
        lblLower.text = String(Int(rangeSlider.lowerValue))
        lblUpper.text = String(Int(rangeSlider.upperValue))
    }
    
    @IBAction func onClickClearAll(_ sender: UIButton) {
        strCatId = ""
        strCatSubId = ""
        lblLower.text = "0"
        lblUpper.text = ""
        txtLocation.text = ""
        latitude = 0.0
        longitude = 0.0
        selectedRating = ""
        
        searchResultList = [SearchResultCls.SearchList]()
        searchObj = nil
        
        callSearchAPI()
    }
    
    @IBAction func onClickApplyFilter(_ sender: UIButton) {
        searchResultList = [SearchResultCls.SearchList]()
       searchObj = nil
        
        callSearchAPI()
    }
    
    func callGetCategory() {
        let param = ["action":"categorylist"]
        Modal.shared.getCategory(vc: self, param: param) { (dic) in
            print(dic)
            
            self.arrCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //            let dict = NSDictionary()
            //            dict = self.arrCategoryList[0] as! NSDictionary
            //            self.strCatId = dict.value(forKey: "id")
            if self.arrCategoryList.count != 0 {
                self.tblCategory.reloadData()
            }
        }
    }
    
    func callGetSubCategory(){
        let param = ["action":"subcategorylist",
                     "categoryId":strCatId]
        Modal.shared.getSubCategory(vc: self, param: param) { (dic) in
            print(dic)
            self.arrSubCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) as [AnyObject]
            //                let dict = NSDictionary()
            //                dict = self.arrSubCategoryList[0] as! NSDictionary
            //                self.strCatSubId = dict.value(forKey: "id")
            if self.arrSubCategoryList.count != 0 {
                self.tblCategory.reloadData()
            }
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
extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtLocation == textField {
            txtLocation.text = nil
            //https://developers.google.com/places/ios-api/
            //TODO: Display google place picker
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtLocation == textField{
           
            return false
        }
        else {
            return true
        }
    }
    
    
    
}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMap{
          return searchResultList.count
        }else{
        return searchResultList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewMap{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.identifier, for: indexPath) as? MapCell else {
                fatalError("Cell can't be dequeue")
            }
            
           // let pointAnnotation = MKPointAnnotation()
            
            
             for dealLocation in searchResultList[indexPath.row].locList{
                if let latitude = Double(dealLocation.latitude ?? ""),let logitude = Double(dealLocation.logitude ?? ""){
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude:logitude)
                    annotation.coordinate = centerCoordinate
                    annotation.title = searchResultList[indexPath.row].deal_title
                    annotation.subtitle = dealLocation.deal_location
                
                    cell.mapView.addAnnotation(annotation)
                    cell.mapView.delegate = self
                    
                }
            }
            
            var zoomRect: MKMapRect = MKMapRect.null
            for annotation: MKAnnotation in cell.mapView.annotations {
                let annotationPoint: MKMapPoint = MKMapPoint(annotation.coordinate)
                let pointRect: MKMapRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                zoomRect = zoomRect.union(pointRect)
            }
            
            cell.mapView.setVisibleMapRect(zoomRect, animated: true)
            cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            
            return cell
        }else{
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.lblDistance.isHidden = true
        cell.viewRound.isHidden = true
        let data:SearchResultCls.SearchList?
        data = searchResultList[indexPath.row]
        cell.lblCategory.text = (data?.categoryName)! + " & " + (data?.subcategoryName)!
        cell.lblDealName.text = data?.deal_title
        cell.lblRate.text = "\(data?.deal_avg_rating ?? 0)"
        cell.stackViewRate.isHidden = false
        cell.imgDeal.downLoadImage(url: (data?.dealImages)!)
        if data?.isFavorite == "y" {
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "heart_fill"), for: .normal)
        }else{
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(onClickAddToFav(_:)), for: .touchUpInside)
        cell.stackViewRate.isHidden = false
        cell.lblDistance.text = data?.deal_distance
        return cell
    }
        
    }
    
    
    
    @objc func onClickAddToFav(_ sender:UIButton)
    {
        if sender.currentImage == #imageLiteral(resourceName: "heart_fill") {
            let param = ["action":"remove-deal-from-favorite",
                         "user_id":UserData.shared.getUser()!.user_id,
                         "favorite_id":searchResultList[sender.tag].deal_id!]
            
            Modal.shared.removeToFavorite(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.searchResultList = [SearchResultCls.SearchList]()
                    self.searchObj = nil
                    self.callSearchAPI()
                })
            }
        }else{
            let param = ["action":"add-deal-as-favorite",
                         "user_id":UserData.shared.getUser()!.user_id,
                         "deal_id":searchResultList[sender.tag].deal_id!]
            
            Modal.shared.addDealToFavorite(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.searchResultList = [SearchResultCls.SearchList]()
                    self.searchObj = nil
                    self.callSearchAPI()
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if self.collectionViewMap == collectionView{
            
        }else{
        
        let nextVC = DealDetailVC.storyboardInstance!
        nextVC.strId = searchResultList[indexPath.row].deal_id!
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 255)
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
            if searchResultList.count - 1 == indexPath.row &&
                (searchObj!.currentPage > searchObj!.TotalPages) {
                self.callSearchAPI()
            }
        }
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if strFilterType == "radius" && tableView == tblCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            cell.viewPoint.isHidden = true
            if selectedRowCategory == indexPath.row{
                cell.imgRight.isHidden = false
                cell.lblName.textColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.imgRight.isHidden = true
                cell.lblName.textColor = UIColor.darkGray
            }
            var dict = NSDictionary()
            
            dict = arrRadius[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "radius") as? String
            
            return cell
        }
       else if strFilterType == "category" && tableView == tblCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
             cell.viewPoint.isHidden = true
            if selectedRowCategory == indexPath.row{
                 cell.imgRight.isHidden = false
                 cell.lblName.textColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.imgRight.isHidden = true
                cell.lblName.textColor = UIColor.darkGray
            }
            var dict = NSDictionary()
            
            dict = arrCategoryList[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "categoryName") as? String
            
            return cell
        }else if strFilterType == "subcategory" && tableView == tblCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewPoint.isHidden = true
            cell.selectionStyle = .none
            if selectedRowSubCategory == indexPath.row{
                 cell.lblName.textColor = UIColor.init(hexString: "E0171E")
                cell.imgRight.isHidden = false
            }else{
                cell.imgRight.isHidden = true
                cell.lblName.textColor = UIColor.darkGray
            }
            var dict = NSDictionary()
            dict = arrSubCategoryList[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.value(forKey: "subcategoryName") as? String
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.viewPoint.isHidden = true
//            if strCatId != "" && indexPath.row == 0 {
//                cell.viewPoint.isHidden = false
//            }else{
//                cell.viewPoint.isHidden = true
//
//            }
//
//            if strCatSubId != "" && indexPath.row == 1 {
//                cell.viewPoint.isHidden = false
//            }else{
//                cell.viewPoint.isHidden = true
//            }
//
//            if txtLocation.text != "" && indexPath.row == 2{
//                cell.viewPoint.isHidden = false
//            }else{
//                cell.viewPoint.isHidden = true
//            }
//
//            if lblUpper.text != "" && lblLower.text != "" && indexPath.row == 3{
//                cell.viewPoint.isHidden = false
//            }else{
//                cell.viewPoint.isHidden = true
//            }
            
            
            
            cell.imgRight.isHidden = true
           cell.lblName.text = filterList[indexPath.row]
            if selectedFilterIndex == indexPath.row{
                cell.backgroundColor = UIColor.white
                cell.lblName.textColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.lblName.textColor = UIColor.darkGray
                cell.backgroundColor = UIColor.init(hexString: "E6E6E6")
            }
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if strFilterType == "category" && tableView == tblCategory{
            return arrCategoryList.count
        }else  if strFilterType == "subcategory" && tableView == tblCategory{
            return arrSubCategoryList.count
        }else  if strFilterType == "radius" && tableView == tblCategory{
            return arrRadius.count
        }
        else{
            return filterList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCategory{
             if CLLocationManager.locationServicesEnabled() {
            var dict=NSDictionary()
            if strFilterType == "category"{
                selectedRowCategory = indexPath.row
                dict = arrCategoryList[indexPath.row] as! NSDictionary
                strCatId = dict.value(forKey: "id") as! String
                self.callGetSubCategory()
            }else  if strFilterType == "subcategory"{
                selectedRowSubCategory = indexPath.row
                dict = arrSubCategoryList[indexPath.row] as! NSDictionary
                strCatSubId = dict.value(forKey: "id") as! String
                
            }else  if strFilterType == "radius"{
                dict = arrRadius[indexPath.row] as! NSDictionary
                strSelectedRadius = dict.value(forKey: "id") as! String
                
            }
             }else{
                var dict=NSDictionary()
                if strFilterType == "category"{
                    selectedRowCategory = indexPath.row
                    dict = arrCategoryList[indexPath.row] as! NSDictionary
                    strCatId = dict.value(forKey: "id") as! String
                    self.callGetSubCategory()
                }else  if strFilterType == "subcategory"{
                    selectedRowSubCategory = indexPath.row
                    dict = arrSubCategoryList[indexPath.row] as! NSDictionary
                    strCatSubId = dict.value(forKey: "id") as! String
                    
                }
            }
            tblCategory.reloadData()
            
        }else{
            selectedFilterIndex = indexPath.row
            if indexPath.row == 0 {
                strFilterType = "category"
                viewLocation.isHidden = true
                viewRange.isHidden = true
                viewRatings.isHidden = true
                tblCategory.isHidden = false
                callGetCategory()
            }else if indexPath.row == 1{
                strFilterType = "subcategory"
                viewLocation.isHidden = true
                viewRange.isHidden = true
                viewRatings.isHidden = true
                tblCategory.isHidden = false
                callGetSubCategory()
                
            }else if indexPath.row == 2{
                viewLocation.isHidden = false
                viewRange.isHidden = true
                viewRatings.isHidden = true
                tblCategory.isHidden = true
            }else if indexPath.row == 3{
                viewLocation.isHidden = true
                viewRange.isHidden = false
                viewRatings.isHidden = true
                tblCategory.isHidden = true
                
            }else if indexPath.row == 4{
                 strFilterType = "radius"
                viewLocation.isHidden = true
                viewRange.isHidden = true
                viewRatings.isHidden = true
                tblCategory.isHidden = false
                callRadisAPI()
            }else{
                viewLocation.isHidden = true
                viewRange.isHidden = true
                viewRatings.isHidden = false
                tblCategory.isHidden = true
            }
            tblFilter.reloadData()
        }
    }
    
}
extension SearchVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        //  strKeyword = searchText
        // self.callSearchBusiness()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        strKeyword = searchBar.text!
        searchResultList = [SearchResultCls.SearchList]()
        searchObj = nil
        callSearchAPI()
    }
}
extension SearchVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place coordinate latitude: \(place.coordinate.latitude)")
        print("Place coordinate longitude: \(place.coordinate.longitude)")
        //latitude = String(place.coordinate.latitude)
        //longitude = String(place.coordinate.longitude)
        
         latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        strLocation = place.formattedAddress!
        txtLocation.text = strLocation
        filterList = ["Category","Sub-Category","Location","Price Range","Star Ratings"]
        currentLocation = nil
        tblFilter.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        if txtLocation.text!.isEmpty{
            filterList = ["Category","Sub-Category","Location","Price Range","Radius","Star Ratings"]
            tblFilter.reloadData()
            strLocation = ""
        }else{
            txtLocation.text = strLocation
        }
        dismiss(animated: true, completion: nil)
    }
}
extension SearchVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        //currentLocation = locations[0]
        //searchResultList = [SearchResultCls.SearchList]()
        //searchObj = nil
         //callSearchAPI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension SearchVC:MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
//        let nextVC = DealDetailVC.storyboardInstance!
//        nextVC.strId = searchResultList[view.tag].deal_id!
//        self.navigationController?.pushViewController(nextVC, animated: true)
//    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        //if let annotationTitle = view.annotation?.title
        //{
            let nextVC = DealDetailVC.storyboardInstance!
            nextVC.strId = searchResultList[view.tag].deal_id!
            self.navigationController?.pushViewController(nextVC, animated: true)
       // }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        //let customPointAnnotation = annotation
//        return annotationView
//    }
}
