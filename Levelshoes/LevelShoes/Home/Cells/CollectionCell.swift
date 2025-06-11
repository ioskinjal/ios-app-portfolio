//
//  CollectionCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 02/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

protocol CollectionCellDelegate: class {
    func moveToLoginScreen()
}
enum LastScrollDirection {
    case reverse
    case forward
}

class CollectionCell: UITableViewCell {
    
    var objattrList = [String]()
       var designDetail = [OptionsList]()
       var objList = [String]()
      var designData: [NSManagedObject] = []
      
    var currentIndexPath: IndexPath?
    var lastDirection: LastScrollDirection = .reverse
    var collectionCelldelegate: CollectionCellDelegate?
    var contentOffsetKey = "" //category_section_item
        {
        didSet {
            collectionView.contentOffset.x = Self.contentOffsetDictionary[contentOffsetKey] ?? 0.0
        }
    }
    @IBOutlet weak var slidingIndicator: SlidingIndicator!
    @IBOutlet weak var lblSubTitle: UILabel!
    var isArabic : Bool = false
    var firstTime = true
  
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblTitle.addTextSpacing(spacing: 1.5)
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "ar" == "ar" {
              self.isArabic = true
                lblTitle.textAlignment = .right
                lblSubTitle.textAlignment = .right
              }
        }
    }
    @IBOutlet weak var constVertical: NSLayoutConstraint!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    var parentVC = LatestHomeViewController()
    var selectedIndex = -1
    var strgen = ""
    var genderStr: String?
    var productData : NewInData? {
        didSet {
             
            print("didSet \(productData)")
            guard let hits = productData?.hits, hits.hitsList.count != 0 else {
                DispatchQueue.main.async {
                    self.slidingIndicator.numberOfItems = 1
                    self.collectionView.reloadData()
                }
                return }
            DispatchQueue.main.async {
                self.slidingIndicator.numberOfItems = hits.hitsList.count + 1
                self.fetchAttributeeData()
                self.collectionView.reloadData()
            }
        }
    }

    var senderTag = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: "ViewAllProCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllProCell")
        collectionView.register(UINib(nibName: "ProductCVCell", bundle: nil), forCellWithReuseIdentifier: "ProductCVCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
     
    
    func getProducts(category_id: Int, product_id: [String], gender: String) {
//        if let data = parentVC.cachedCollectionCell[key] {
//            productData = data
//            return
//        }
        var searchType = "must"
        var productImages = Array<String>()
        var counter = 0
        var total : Int = 5
        var ids = [String]()
        var arrMust = [[String:Any]]()
        let defaults = UserDefaults.standard
        let imgKey = "ProductLifestyleImages"
        if product_id.count > 0 {
            total = product_id.count
            searchType = "must"
            for i in product_id {
                if i.components(separatedBy: "|").count == 2 {
                    let id = i.components(separatedBy: "|")[0]
                    let image = i.components(separatedBy: "|")[1]
                    productImages.append(image)
                    ids.append("\(id)")
                    counter += 1
                }
                else if(i.components(separatedBy: "|").count == 1){
                    ids.append("\(i.trimmingCharacters(in: .whitespaces))")
                    counter += 1
                }
                else {
                    continue
                }
                 
            }
            arrMust.append(["terms": ["sku":ids]])
            defaults.set(productImages, forKey: imgKey)
        } else {
            total = 5
            searchType = "must"
            arrMust.append(["match": ["category_ids":category_id]])
             defaults.set([], forKey: imgKey)
        }
        if counter == 0 {
            total = 5
            searchType = "must"
            arrMust.append(["match": ["category_ids":category_id]])
        }
        arrMust.append(["match": ["type_id":"configurable"]])
        if(gender == "1610" && ids.count > 0){
            //Leave as it is for kids or put ids
             arrMust.append(["terms": ["gender":[1610,88,109,1430]]])
        }
        else{
        arrMust.append(["match": ["gender":gender]])
        }
        let dictMust = [searchType:arrMust]
        let dictBool = ["bool":dictMust]
        let sortStr1 = """
                {"_script" : {"type" : "number","script": {"inline" : "params.sortOrder.indexOf(doc['sku'].value)","params": {"sortOrder":
                """
               
           let sortStr2 =
            """
                }},"order" : "asc"}}
"""
        let sortStr = String(sortStr1) + "[\"" + ids.joined(separator: "\",\"")  + "\"]" + String(sortStr2)
        let sort = convertToDictionary(text: sortStr)
        let param = [
            "_source": ["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id","badge_name"],
                     "from":0,
                     "size": total,
                     "sort": sort,
                     "query":dictBool
            ] as [String : Any]
        
        let strCode = "\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        NSLog("getProducts \(url)")
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            if let error = error {
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil {
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                self.productData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
            }
        }
    }
    
    static var contentOffsetDictionary = [String: CGFloat]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Self.contentOffsetDictionary[contentOffsetKey] = collectionView.contentOffset.x
    }
    func moveToLoginScreen(){
      //  self.collectionCelldelegate?.moveToLoginScreen()
       
        let loginVC = LoginViewController.storyboardInstance!
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.parentVC.present(navigationController, animated: true, completion: nil)
    }
}

extension CollectionCell: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == parentVC.tblHome {
            var constant = constVertical.constant
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            
            if translation.y > 0 {
                constant += 0.25
                if 20.0 < constant {
                    constant = 20.0
                }
            } else {
                constant -= 0.25
                if -1 * 20.0 > constant {
                    constant = -1 * 20.0
                }
            }
            
            constVertical.constant = constant;
        } else if scrollView == self.collectionView {
            let xVelocity = scrollView.panGestureRecognizer.velocity(in: self).x
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                if xVelocity > 0 {
                    lastDirection = .forward
                } else {
                    lastDirection = .reverse
                }
            } else {
                if xVelocity < 0 {
                    lastDirection = .forward
                } else {
                    lastDirection = .reverse
                }
            }

            var count = 0
            let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
                count = visibleIndexPath.row
                slidingIndicator.selectedItem = count
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            currentIndexPath = self.collectionView.indexPathForItem(at: visiblePoint)
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if var path = currentIndexPath {
                if lastDirection == .reverse, path.item > 0 {
                    path.item -= 1
                } else if lastDirection == .forward, (path.item + 1) < ((productData?.hits?.hitsList.count ?? 0) + 1) {
                    path.item += 1
                }
                DispatchQueue.main.async {
//                    print("scroll to \(path)")
                    self.collectionView.scrollToItem(at: path, at: .left, animated: true)
                }
            }
        }
    }
}
extension CollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ProductCVCellDelegate {
    
  
    func updateWishListProduct(productCVCell: ProductCVCell) {
        let indexPath = self.collectionView.indexPath(for: productCVCell)
        if isWishListProduct(productId: String((productData?.hits?.hitsList[indexPath!.row]._source!.sku)! )){
            productCVCell.btnMark.setImage(UIImage(named: "Selected"), for: .normal)
            
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            } else {
                var params:[String:Any] = [:]
                params["product_id"] = self.productData?.hits?.hitsList[indexPath!.row]._source!.id
                params["sku"] = self.productData?.hits?.hitsList[indexPath!.row]._source!.sku
                
                MBProgressHUD.showAdded(to: self, animated: true)
                ApiManager.removeWishList(params: params, success: { (response) in
                    MBProgressHUD.hide(for: self, animated: true)
                    DispatchQueue.main.async {
                        productCVCell.setBookmark(selected: false)
                    }
                }) {
                    
                }
            }
        } else {
            
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            } else {
                var params:[String:Any] = [:]
                params["product_id"] = self.productData?.hits?.hitsList[indexPath!.row]._source!.id
                params["sku"] = self.productData?.hits?.hitsList[indexPath!.row]._source!.sku
                MBProgressHUD.showAdded(to: self, animated: true)
                ApiManager.addTowishList(params: params, success: { (response) in
                    MBProgressHUD.hide(for: self, animated: true)
                    DispatchQueue.main.async {
                        productCVCell.setBookmark(selected: true)
                    }
                }) {
                    MBProgressHUD.hide(for: self, animated: true)
                }
            }
        }
    }
    


         
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (productData?.hits?.hitsList.count ?? 0) + 1
        print("number of cells \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isArabic == true && self.firstTime == true && indexPath.row == 4 {
            self.collectionView.scrollToItem(at: [0,0], at: .left, animated: true)
            self.firstTime = false
        }
        if indexPath.row == productData?.hits?.hitsList.count ?? -1 + 1{
            let cell:ViewAllProCell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewAllProCell.identifier, for: indexPath) as! ViewAllProCell
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en" {
                Common.sharedInstance.backtoOriginalImage(aimg: cell.imgArrow)
                cell.customizeForEn()
            }
            else{
                cell.lblViewAll.font = UIFont(name: "Cairo-SemiBold", size: 14)
                Common.sharedInstance.rotateImage(aimg: cell.imgArrow)
            }
            
            return cell
        }
        
        guard let source = productData?.hits?.hitsList[indexPath.row]._source else {
            print("problem")
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
        }

        let cell:ProductCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
        cell.scrollView = collectionView
        if let hitsList = productData?.hits?.hitsList, hitsList.count > indexPath.row {
            cell.lblBrand.text =
                getBrandName(id: "\(source.manufacturer)")
        }
        cell.productCVCellDelegate = self
        
        let tagsArray = source.tags.components(separatedBy: ",")
//        print("PRINTING BADGES \(tagsArray)")
        if tagsArray.count > 0 {
            cell.lblTag.text = " \(tagsArray[0]) ".uppercased()
        }
        else{
            cell.lblTag.isHidden = true
        }
        if tagsArray.count > 1 {
            cell.lblTag2.isHidden = false
            cell.lblTag2.text = " \(tagsArray[1]) ".uppercased()
        }
        else{
            cell.lblTag2.isHidden = true
        }
        let str = CommonUsed.globalUsed.kimageUrl
        let imageStr = source.image
        let finalStr = str + imageStr
        let imgKey = "ProductLifestyleImages"
        if let imagesList = UserDefaults.standard.array(forKey: imgKey), imagesList.count > 0 {
           // print("FIRST!!!")
            cell.imgProduct.downloadSdImage(url: imagesList[indexPath.row] as! String)
        }
        else{
            //print("SECOND!!!")
             cell.imgProduct.downloadSdImage(url: finalStr)
        }
        cell.lblProductNm.text = source.name.uppercased()
        var price = (Double(source.final_price_string)  ?? 0).clean
        let currencyStr = (UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
        cell.lblPrice.text =  "\(price) " + "\((currencyStr))".localized
       // cell.lblPrice.text = "\(source.final_price_string) \(UserDefaults.standard.value(forKey: string.currency) ?? "\(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")"
        
         
        if isWishListProduct(productId: String(source.sku)) {
            cell.btnMark.setImage(UIImage(named: "Selected"), for: .normal)
        } else {
            cell.btnMark.setImage(UIImage(named: "Default"), for: .normal)
        }
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            cell.lblBrand.font = UIFont(name: "Cairo-SemiBold", size: 14)
            cell.lblProductNm.font = UIFont(name: "Cairo-Light", size: 16)
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductCVCell {
            cell.isVisible = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductCVCell {
            cell.isVisible = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == productData?.hits?.hitsList.count ?? -1 + 1{
            let nextVC = NewInVC.storyboardInstance!
            nextVC.strGen = parentVC.strgen
            nextVC.headlingLbl = parentVC.landingData?._sourceLanding?.dataList[senderTag].title.uppercased() ?? ""
            nextVC.cat_id = parentVC.landingData?._sourceLanding?.dataList[senderTag].category_id ?? 0
            parentVC.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            selectedIndex = indexPath.row
            let nextVC = ProductDetailVC.storyboardInstance!
            nextVC.selectedProduct = indexPath.row
            nextVC.detailData = productData
            
            openPDP(nextVC:nextVC)
            self.slidingIndicator.numberOfItems = (self.productData?.hits?.hitsList.count ?? 0) + 1
            self.collectionView.reloadItems(at: [indexPath])
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = (UIApplication.shared.keyWindow ?? collectionView).frame.width - 21 - 44
        let h: CGFloat = 404
        return CGSize(width: w, height: h)
    }
    
    func openPDP(nextVC: Any) {
        parentVC.navigationController?.delegate = self
        
        parentVC.navigationController?.pushViewController(nextVC as! UIViewController, animated: true)
    }
    
    func fetchAttributeeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("colorArray", designData.count)
        }
        
        
         for j in 0..<designData.count{
             let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
             
             designDetail.append(array[k])
             }
         }
    
        let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
              designDetail = sorteddesignDetail
        
        let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
        for i in 0..<designDetail.count{
            for j in arrColorNm{
                if designDetail[i].label == j{
                    designDetail[i].isSelected = true
                }
            }
        }
        
        for i in 0..<designDetail.count{
            objList.append(designDetail[i].label)
        }
        objattrList = objList
       
    }
    
    func getBrandName(id:String) -> String{
        var strBrand = ""
        for i in 0..<(designDetail.count){
           if id == "\(designDetail[i].value)"{
            strBrand = designDetail[i].label
           }
        }
        return strBrand.uppercased()
    }
    
}


extension CollectionCell: NoInternetDelgate {
    func didCancel() {
        
    }
}

extension UICollectionViewFlowLayout {
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}

extension CollectionCell: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) ->  UIViewControllerAnimatedTransitioning? {
        guard
            let selectedCellIndexPath = collectionView.indexPathsForSelectedItems?.first,
            let selectedCell = collectionView.cellForItem(at: selectedCellIndexPath) as? ProductCVCell else { return nil }
        let originFrame = selectedCell.convert(selectedCell.imgProduct.frame, to: nil)
        return CustomTransitionAnimationController(originFrame: originFrame, selectedProduct: selectedIndex, detailData: productData)
    }
}
