//
//  LatestHomeViewController.swift
//  Level Shoes
//
//  Created by Zing Mobile on 07/04/20.
//  Copyright © 2020 IDSLogic. All rights reserved.
//

import UIKit
//import PKHUD
import Alamofire
import SwiftyJSON
import AVFoundation
import CoreLocation
import CoreData
import MBProgressHUD
import MarketingCloudSDK
import FirebaseDatabase

var plpDesignData : NewInData?
var  globalDic = [String : Any]()
var globalSearchBool: Bool = false
var collectionView1: Bool = false
var collectionView2: Bool = false
var globalCategoryName = ""
class LatestHomeViewController: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
     var shopBagCountLabel = UILabel()
     var notificationCountLabel = UILabel()
    var firstTime = true
    lazy var indexCat: [Int: String] = {
        if isRTL() {
            return [0: "kids", 1: "men", 2: "women"]
        }
        return [0: "women", 1: "men", 2: "kids"]
    }()
    
    lazy var catIndex: [String: Int] = {
        if isRTL() {
            return ["kids": 0, "men": 1, "women": 2]
        }
        return ["women": 0, "men": 1, "kids": 2]
    }()

    var currentIndex = 0
    var signInViewHidden = false
    var ref: DatabaseReference!
    var currentAppVersion = ""
    
    static var storyboardInstance:LatestHomeViewController? {
        return StoryBoard.home.instantiateViewController(withIdentifier: LatestHomeViewController.identifier) as? LatestHomeViewController
        
    }
    @IBOutlet weak var tblHome: UITableView!{
        didSet {
            tblHome.dataSource = self
            tblHome.delegate = self
            tblHome.register(UINib(nibName: SliderCell.identifier, bundle: nil), forCellReuseIdentifier: SliderCell.identifier)
            tblHome.register(UINib(nibName: CollectionCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionCell.identifier)
            tblHome.register(UINib(nibName: ImageCell.identifier, bundle: nil), forCellReuseIdentifier: ImageCell.identifier)
            tblHome.register(UINib(nibName: ScrollViewCell.identifier, bundle: nil), forCellReuseIdentifier: ScrollViewCell.identifier)
            tblHome.register(UINib(nibName: MostWantedTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MostWantedTableViewCell.identifier)
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnDesigner: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    
    var attributeData : ColorData?
    var filterData : FilterData?
    var filter: [NSManagedObject] = []
    var attribute: [NSManagedObject] = []
    var filterArray: [NSManagedObject] = []
    private var viewHeight: CGFloat = 0
    private let minimumConstraint: CGFloat = 10
    private let constraintRange: CGFloat = 50
    let testreuseidentifer = "latestcell"
    var genderStr: String?
    let testreuseidentiferone = "latestcellnew"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var selectedIndex = -1
    var landingData: LandingPageData? {
        didSet {
            guard let dataList = landingData?._sourceLanding?.dataList else { return }
            DispatchQueue.global().async {
                let group = DispatchGroup()
                var i = 0
                for value in dataList {
                    if value.box_type == "additionalproduct_view" {
                        group.enter()
                        self.scrollViewData = [Int: NewInData]()
                        self.getScrollViewProducts(category_id: value.category_id,
                                                   product_id: value.products?.primary_vpn ?? [String](),
                                                   gender: self.strgen,
                                                   completion: { data in
                                                    self.scrollViewData[i] = data
                                                    group.leave()
                        })
                        group.wait()
                    }
                    i += 1
                }
                DispatchQueue.main.async {
                    self.tblHome.reloadData()
                }
            }
        }
    }
    var scrollViewData = [Int: NewInData]()
    var SelectedCat = "" {
        didSet {
            if oldValue != SelectedCat {
                CollectionCell.contentOffsetDictionary.removeAll()
            }
            if SelectedCat == "women" {
                UserDefaults.standard.set("Women",forKey: "genderNm")
                currentIndex = 0
                strgen = "61"
                landingGender = CommonUsed.globalUsed.landingWomen
            } else if SelectedCat == "men" {
                UserDefaults.standard.set("Men",forKey: "genderNm")
                currentIndex = 1
                strgen = "39"
                landingGender = CommonUsed.globalUsed.landingMen
            } else if SelectedCat == "kids" {
                UserDefaults.standard.set("Kids",forKey: "genderNm")
                currentIndex = 2
                strgen = "1610"
                landingGender = CommonUsed.globalUsed.landingKids
            }
            //print("category selected \(SelectedCat)")
            if (oldValue != SelectedCat && ApiManager.sliderCache[SelectedCat] == nil) || isLanguageCodeChanged || isCountryCodeChanged {

                HomeApi()
            } else if oldValue != SelectedCat {
                landingData = ApiManager.sliderCache[SelectedCat]
            }
            callPLP()
        }
    }
    var previousSelectCat = ""
    var player: AVPlayer?
    var exclusiveData : NewInData?
    var strgen = ""
    var landingGender = ""
    var categoryGender = ""

    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var lastContentOffset = CGPoint.zero
    var currentCountry = ""
    var mens: [NSManagedObject] = []
    var sharedManger =  CoreDataManager.sharedManager
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentNavCtrl = self.navigationController
        
        if((UserDefaults.standard.string(forKey: "storecode") == "" || UserDefaults.standard.string(forKey: "storecode") == nil) && selectedStoreCode != ""){
                    UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
        }
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        }
        if((UserDefaults.standard.string(forKey: "currency") == "" || UserDefaults.standard.string(forKey: "currency") == nil) && selectedCurrency != ""){
            UserDefaults.standard.setValue(selectedCurrency.localized, forKey: "currency")
        }
        UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "country"), forKey: "countryName")
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
        }
        if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
        }
        if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
        }
        globalCategoryName = ""
        self.tblHome.isHidden = false

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ShowProductPageForDeepLinking), name: Notification.Name("showProductLink"), object: nil)
        nc.addObserver(self, selector: #selector(ShowProductDetailPageForDeepLinking), name: Notification.Name("ProductDetail"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabBar), name: Notification.Name(notificationName.changeTabBar), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCategory), name: Notification.Name(notificationName.changeCategory), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeShopBagCount), name: Notification.Name(notificationName.CHANGE_SHOP_BAG_COUNT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotificationCount), name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: nil)
        //
        
        UserDefaults.standard.set(nil,forKey: "genderNm")
        ApiManager.cacheAllCategories()
        callSearchCache()
        let select = UserDefaults.standard.value(forKey: "category")
        SelectedCat =  select as? String ?? ""
        //previousSelectCat = SelectedCat
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        tblHome.rowHeight = UITableViewAutomaticDimension
        tblHome.estimatedRowHeight = 700
        
        let searchBool: Bool = (UserDefaults.standard.value(forKey: "globalSearchBool") != nil)
        if( globalSearchBool == true && searchBool == true ){
            //        getSearchScreenData()
            
        }
       
        marketingCloudDetails()
    }

    func marketingCloudDetails(){
        var sdkStateJSON = MarketingCloudSDK.sharedInstance().sfmc_getSDKState() ?? "{}"
               guard let data = sdkStateJSON.data(using: .utf8) else {
                   return
               }
               do {
                   guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] else {
                       return
                   }
                   guard let general = json["MarketingCloudSDK General Information"] else {
                       return
                   }
                   guard let registration = general["Registration Details"] else {
                       return
                   }
                   guard let registrationData = try? JSONSerialization.data(withJSONObject: registration!, options: .prettyPrinted) else {
                       return
                   }
                let _ = MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Country", value: UserDefaults.standard.string(forKey: "countryName") ?? "UAE")
                let _ = MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Language", value: UserDefaults.standard.string(forKey: "userLanguage") ?? "EN")
                var genderToPush = ""
                if(strgen == "61"){ genderToPush = "Women" }
                else if(strgen == "39"){ genderToPush = "Men" }
                else if(strgen == "1610"){ genderToPush = "Kids" }
                let _ = MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Gender", value: genderToPush)
                if(M2_isUserLogin){
                    let _ = MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Email", value: UserDefaults.standard.string(forKey: "userEmail") ?? "")
                    
                }
                   sdkStateJSON = String(data: registrationData, encoding: .utf8) ?? "No Registration Data"
                   print(sdkStateJSON)
               } catch {
                   print("Something went wrong")
               }
               
    }
    
    func callSearchCache(){
               CoreDataManager.sharedManager.deleteAllRecords(strEntity: "ProductList")
           newElasticSearchProductAPi(search: CommonUsed.globalUsed.genderKids)
               newElasticSearchProductAPi(search: CommonUsed.globalUsed.genderMen)
               newElasticSearchProductAPi(search: CommonUsed.globalUsed.genderWomen)
               
       }
   
    @objc func changeTabBar(_ notification:Notification){
        
        guard let selectedTab:Int = notification.object as? Int else {
            return
        }
        self.tabBarController?.selectedIndex = selectedTab
        self.tabBarController?.selectedIndex
    }
     @objc func changeCategory(_ notification:Notification){
       print("changeCategory===========")
    }
   @objc func changeShopBagCount(_ notification:Notification){
       print("changeCategory===========")
    DispatchQueue.main.async {
        self.addShopBagItemCount()

    }

    
    }
    @objc func changeNotificationCount(_ notification:Notification){
        print("changeCategory===========")
     DispatchQueue.main.async {
         self.addNotificationItemCount()

     }
    }
    @objc func ShowProductPageForDeepLinking(notification: NSNotification){
           
           if let isPLPLoaded = UserDefaults.standard.value(forKey: "isPLPLoadedForDeepLinking") as? Bool{
               if isPLPLoaded{
                   
               }
               else{
                   if #available(iOS 13.0, *) {
                       
                       UserDefaults.standard.setValue(true, forKey: "isPLPLoadedForDeepLinking")
                       
                       let storyBoardPLP : UIStoryboard = UIStoryboard(name: "PLP", bundle:nil)
                       if let nextVC = storyBoardPLP.instantiateViewController(identifier: NewInVC.identifier) as? NewInVC {
                           
                           
                           nextVC.headlingLbl = notification.userInfo?["title"] as? String ?? ""
                           nextVC.strGen = notification.userInfo?["gender"] as? String ?? ""
                           nextVC.cat_id = Int(notification.userInfo?["categoryId"] as? String ?? "") ?? 0
                           nextVC.isFirstTime = true
                           let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_"
                           let storeCode = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
                           let url =  localizedUrl + storeCode + "/category/" + String(nextVC.cat_id)
                           
                           ApiManager.apiGet(url: url, params: [:]) {(response:JSON?, error:Error? ) in
                               if response != nil {
                                   let delayTime = DispatchTime.now() + 1.0
                                   DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                                       let dict = response?.dictionaryObject
                                       if dict?["_source"] != nil{
                                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                           let hits = dict?["_source"] as! [String : AnyObject] as [String: AnyObject]
                                           let categoryName = hits["name"] as? String
                                           globalCategoryName = categoryName?.lowercased() ?? ""
                                           nextVC.categoryName = categoryName?.lowercased() ?? ""
                                           appDelegate.currentNavCtrl?.pushViewController(nextVC, animated: true)
                                           UserDefaults.standard.setValue(false, forKey: "isPLPLoadedForDeepLinking")
                                       }
                                   })
                               }
                           }
                       }
                       
                   } else {
                       // Fallback on earlier versions
                   }
                   
               }
           }
           else{
               UserDefaults.standard.setValue(false, forKey: "isPLPLoadedForDeepLinking")
           }
           
           //self.navigationController?.pushViewController(nextVC, animated: true)
       }
       @objc func ShowProductDetailPageForDeepLinking(notification: NSNotification){
           if let isPLPLoaded = UserDefaults.standard.value(forKey: "isPDPLoadedForDeepLinking") as? Bool{
               if isPLPLoaded{
                   
               }
               else{
                   if #available(iOS 13.0, *) {
                       
                       UserDefaults.standard.setValue(true, forKey: "isPDPLoadedForDeepLinking")
                       
                       let skuVal = notification.userInfo?["sku"] as? String ?? ""
                       klevuProductSearchApi(skutext: skuVal)
                   }
               }
           }
           else{
               UserDefaults.standard.setValue(false, forKey: "isPDPLoadedForDeepLinking")
           }
       }

       func klevuProductSearchApi(skutext: String){
               let delimiter = ";"
               let tempSkuArray = skutext.components(separatedBy: delimiter)
               let skuId = tempSkuArray[0]
               var arrMust = [[String:Any]]()
               
               arrMust.append(["match": ["sku":skuId]])
               let dictMust = ["must":arrMust]
               let dictBool = ["bool":dictMust]
               
               var dictSort = [String:Any]()
               dictSort = ["updated_at":"desc"]
               let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id"],
                            "from":0,
                            "size": 5,
                            "sort" : dictSort,
                            "query": dictBool
                   ] as [String : Any]
               
               let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
               let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
              // MBProgressHUD.showAdded(to: self.view, animated: true)
               ApiManager.apiPost(url: url, params: param) { (response, error) in
                  // MBProgressHUD.hide(for: self.view, animated: true)
                   
                   if let error = error {
                       if error.localizedDescription.contains(s: "offline") {
                           let nextVC = NoInternetVC.storyboardInstance!
                           nextVC.modalPresentationStyle = .fullScreen
                       }
                       
                       return
                   }
                   var data: NewInData?
                   if response != nil{
                       if let responseVal = response?.dictionaryObject{
                           
                           if let hits = responseVal["hits"] as? [String:AnyObject]{
                               let total = hits["total"]
                               print("total =\(String(describing: total))")
                               
                               if total as! Int > 0 {
                                   let dict = ["data": responseVal]
                                   print("dict = \(dict)")
                                   
                                   data = NewInData(dictionary: ResponseKey.fatchData(res: dict as dictionary, valueOf: .data).dic)
                                   let delayTime = DispatchTime.now() + 1.0
                                   DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                                       let storyBoardPLP : UIStoryboard = UIStoryboard(name: "PDP", bundle:nil)
                                       if #available(iOS 13.0, *) {
                                           if let nextVC = storyBoardPLP.instantiateViewController(identifier: ProductDetailVC.identifier) as? ProductDetailVC {
   //                                            let nextVC = ProductDetailVC.storyboardInstance!
                                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                               // nextVC.selectedProduct = ip.row
                                               nextVC.isCommingFromWishList = true
                                               nextVC.detailData = data
                                               // applyTransitionAnimation(nextVC: nextVC)
                                               appDelegate.currentNavCtrl?.pushViewController(nextVC, animated: true)
                                               UserDefaults.standard.setValue(false, forKey: "isPDPLoadedForDeepLinking")
                                           }
                                       } else {
                                           // Fallback on earlier versions
                                       }
                                   }
                                       )
                               }
                           }
                       }
                   }
               }
           }
    func callPLP(){
           var arrMust = [[String:Any]]()
         let dictParam = ["gender":strgen]
           var dictMatch = [String:Any]()
         dictMatch["match"] = dictParam
           arrMust.append(dictMatch)
                  var dictaggs = Dictionary<String,Any>()
        let dictField = ["field":"configurable_children.manufacturer", "size":10000]
            as [String : Any]
             var dictTerms = [String:Any]()
        dictTerms["terms"] = dictField
            var dictDesign = [String:Any]()
           dictDesign["manufacturerFilter"] = dictTerms
        
           dictaggs.add(dictDesign)
                  let dictMust = ["must":arrMust]
                  let dictBool = ["bool":dictMust]
           let  param = ["_source":["name","id"],
                         "size":10000,
                                 "query":dictBool,
                                 "aggs":dictaggs
                      ] as [String : Any]
           
         
           let url = getProductUrl()
           
           
           self.getProductApi(url:url,param:param)
           
       }
       func getStoreCode()->String{
              let storeCode="\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
              return storeCode
          }
       func getProductUrl() -> String{
           let strCode = self.getStoreCode()
           let url = CommonUsed.globalUsed.productEndPoint + "/"  + strCode + CommonUsed.globalUsed.productList
           return url
       }
       func getProductApi(url:String,param : Any){
           ApiManager.apiPost(url: url, params: param as! [String : Any]) { (response, error) in
               
               if let error = error{
                   //print(error)
                   if error.localizedDescription.contains(s: "offline"){
                       let nextVC = NoInternetVC.storyboardInstance!
                       nextVC.modalPresentationStyle = .fullScreen
                       nextVC.delegate = self
                       self.present(nextVC, animated: true, completion: nil)
                       
                   }
                   self.sharedAppdelegate.stoapLoader()
                   return
               }
               
               // try! realm.add(response)
               
               if response != nil{
                   var dict = [String:Any]()
                   dict["data"] = response?.dictionaryObject
                  
                   plpDesignData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                   UserDefaults.standard.set(self.strgen, forKey: "gender")
                   
               }
           }
       }
       
       

    
    func startShimmering(){}
    
    func stopShimmering(){}

    //get url by storecode for products
    func getProductUrl(for category: String) -> String {
        let storeCode = ApiManager.getStoreCode(for: category)
        let url = CommonUsed.globalUsed.main + "/" + storeCode  + CommonUsed.globalUsed.home + strgen
        return url
    }
    
    func getCategorySearchUrl( category: String) -> String{
        let storeCode = ApiManager.getStoreCode(for: category)
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_" + storeCode
        let url =  localizedUrl + "/" + CommonUsed.globalUsed.categorySearch
        return url
    }
    
    //get products using elastic search url for the selected storecode
    func getProductsApi(url: String, completion:((_ data: LandingPageData?)-> Void)?)  {
        //print("get products for \(SelectedCat)")
        ApiManager.apiGet(url: url, params: [:]) { (response, error) in
            if let error = error {
                ////print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                    self.present(nextVC, animated: true) {}
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil {
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                completion?(LandingPageData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic))
                return
            }
            completion?(nil)
        }
    }
    
    //MARK:- Search Api Integration
       func newElasticSearchProductAPi(search: String){
          
           var parameters = ""
           if search == CommonUsed.globalUsed.genderKids {
                parameters = "{\"_source\":[\"name\",\"column_breakpoint\",\"id\",\"menu_item_type\",\"menu_item_link\",\"position\",\"children_data\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"209\"}},{ \"match\": { \"is_active\": true}},{ \"match\": { \"include_in_menu\": 1}}]}}}"
           } else if search == CommonUsed.globalUsed.genderMen {
                 parameters = "{\"_source\":[\"name\",\"column_breakpoint\",\"id\",\"menu_item_type\",\"menu_item_link\",\"position\",\"children_data\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"122\"}},{ \"match\": { \"is_active\": true}},{ \"match\": { \"include_in_menu\": 1}}]}}}"
           } else if search == CommonUsed.globalUsed.genderWomen {
                 parameters = "{\"_source\":[\"name\",\"column_breakpoint\",\"id\",\"menu_item_type\",\"menu_item_link\",\"position\",\"children_data\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"3\"}},{ \"match\": { \"is_active\": true}},{ \"match\": { \"include_in_menu\": 1}}]}}}"
           } else {
               return
           }
               let dic = convertToDictionary(text: parameters)
               let url = getCategorySearchUrl(category: SelectedCat)
                   print("New Elastic Search Api url", url)
                    DispatchQueue.main.async {
                       ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                           if let error = error{
                               print(error)
                               if error.localizedDescription.contains(s: "offline"){
                                   let nextVC = NoInternetVC.storyboardInstance!
                                   nextVC.modalPresentationStyle = .fullScreen
                                   nextVC.delegate = self
                               }
                               return
                           }
                           if response != nil{
                               if statusCode == 200  {
                                   self.fillProductListDataInDataBase(response: response, searchType: search)                                /*
                                    let dict = response?.dictionaryObject
                                   let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                                   let innerHits = hits["hits"] as? [[String : Any]]
                                   guard let values = innerHits else { return }
                                   var array = [[String :Any]]()
           //                        var subcategoryArray = [String]()
                                   var subcategoryArray = [[String: Any]]()
                                   var tempParent = ""
                                   var tempID = ""
                                   var dic = [String : Any]()
                                   var counter = 0
                                   let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

                                   if values.count > 0 {
                                       for data in 0...values.count - 1 {
                                           let _source = values[data]["_source"] as? [String: Any]
                                           let menu = _source?["menu_item_type"] as? String
                                           let id = _source?["id"] as? Int64
                                           
                                           counter += 1
                                           if menu == "title" {
                                               if(tempParent != ""){
                                                   dic = ["name" : tempParent, "id" : tempID,"children": subcategoryArray]
                                                   array.append(dic)
                                               }
                                               tempParent = (_source?["name"] as? String)!
                                               tempID = String(describing: (_source?["id"] as? Int64)! )
                                               
                                               subcategoryArray = []
                                           }else{
                                               let SubID = String(describing: (_source?["id"] as? Int64)! )
                                               let subName = (_source?["name"] as? String)!
                                               var dictionarMain = ["name": subName, "id" : SubID] as [String : Any]
                                               subcategoryArray.append(dictionarMain)
                                               dictionarMain = ["children": subcategoryArray]
                                               if(counter == values.count - 1){
                                                   dictionarMain = ["name":tempParent,"id":tempID,"children": subcategoryArray]
                                                   array.append(dictionarMain )
                                                  
                                               }
                                           }
                                       }
                                       /*
                                   for data in 0...values.count - 1 {
                                       let _source = values[data]["_source"] as? [String: Any]
                                       let menu = _source?["menu_item_type"] as? String
                                       counter += 1
                                       if menu == "title" {
                                           if(tempParent != ""){
                                               array.append([tempParent : subcategoryArray])
                                           }
                                           tempParent = (_source?["name"] as? String)!+";;"+String(describing: (_source?["id"] as? Int64)! )
                                           subcategoryArray = []
                                       }else{
                                           subcategoryArray.append((_source?["name"] as? String)!+";;"+String(describing: (_source?["id"] as? Int64)! ))
                                           if(counter == values.count - 1){
                                              array.append([tempParent : subcategoryArray])
                                           }
                                       }
                                      
                                   }*/
                               }
           //                         print("Women",array)
                                                 for item in array {
                                                    
                                                     let dataItem = item as? [String: Any]
                                                     let name = dataItem?["name"] as? String
                                                     let id = dataItem?["id"] as? String
                                                     let category = WomenData(context: managedContext)
                                                     category.id = id
                                                     category.name = name
                                                     let child = dataItem?["children"] as? [[String: Any]]
                                                     guard let values = child else { return }

                                                     for childItem in values {
                                                       let womenChild = WomenChildData(context : managedContext)

                                                         let name = childItem["name"] as? String
                                                         let id = childItem["id"] as? String
                                                         womenChild.id = id
                                                         womenChild.name = name
                                                         category.addToWomens(womenChild)
                                                     }
                                                 }
                                                 CoreDataManager.sharedManager.saveContext()
                                       */
                               }
                           }
                       }
                   }
               }
           
       func fillProductListDataInDataBase(response:JSON? , searchType:String){
           let dict = response?.dictionaryObject
           let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
           let innerHits = hits["hits"] as? [[String : Any]]
           guard let values = innerHits else { return }
           var array = [[String :Any]]()
          
           var subcategoryArray = [[String: Any]]()
           var tempParent = ""
           var tempID = ""
           var dic = [String : Any]()
           var counter = 0
           let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
           var titleFound = false
           var breakpointReached = false
           if values.count > 0 {
                   for data in 0...values.count - 1 {
                       let _source = values[data]["_source"] as? [String: Any]
                       let menu = _source?["menu_item_type"] as? String
                        let menuLink = _source?["menu_item_link"] as? String
                        let columnBreakpoint = _source?["column_breakpoint"] as? Int
                        var dupBreakpointFound = false
                       let id = _source?["id"] as? Int64
                       
                       counter += 1
                    //print("**************************************")
                    //print(_source?["name"])
                    //print(breakpointReached)
                     //print("**************************************")
                    if(breakpointReached == true && columnBreakpoint == 1){
                        dupBreakpointFound = true
                    }
                    if(menu == "title"){titleFound = true}
                    if (menu == "title" || (breakpointReached == true && titleFound == false) || dupBreakpointFound == true) {
                        if(breakpointReached && menu != "title" ){
                            tempParent = (_source?["name"] as? String)!
                            tempID = String(describing: (_source?["id"] as? Int64)! )
                      
                            let children = _source?["children_data"] as? [[String : Any]]
                                                         var i = 0
                                                         //Condition Before title is found
                                         if(children?.count ?? 0 > 0){
                                               subcategoryArray = []
                                               while(i < children?.count ?? 0 ){
                                                    let ids = String(describing: ( children?[i]["id"] as? Int64)! )
                                                    let names = children?[i]["name"] as! String
                                                   let cType = children?[i]["menu_item_type"] as! String
                                                   let cLink = children?[i]["menu_item_link"] as? String
                                                   let included = children?[i]["include_in_menu"] as? Int ?? 0
                                                   let dictionarMain = ["name": names, "id" : ids, "type": cType, "link":cLink] as [String : Any]
                                                    if(included == 1){
                                                        subcategoryArray.append(dictionarMain)
                                                    }
                                                    i += 1
                                                }
                            }
                        }
                           if(tempParent != ""){
                            dic = ["name" : tempParent,"type": menu,"link":menuLink, "id" : tempID,"children": subcategoryArray]
                               array.append(dic)
                           }
                           
                           tempParent = (_source?["name"] as? String)!
                           tempID = String(describing: (_source?["id"] as? Int64)! )
                           breakpointReached = false
                           dupBreakpointFound = false
                           subcategoryArray = []
                
                       }else{
                        
                            if(titleFound == false){
                              let children = _source?["children_data"] as? [[String : Any]]
                              var i = 0
                              //Condition Before title is found
                              if(children?.count ?? 0 > 0){
                                    subcategoryArray = []
                                    while(i < children?.count ?? 0 ){
                                         let ids = String(describing: ( children?[i]["id"] as? Int64)! )
                                         let names = children?[i]["name"] as! String
                                        let cType = children?[i]["menu_item_type"] as! String
                                        let cLink = children?[i]["menu_item_link"] as? String
                                        let included = children?[i]["include_in_menu"] as? Int ?? 0
                                        let dictionarMain = ["name": names, "id" : ids, "type": cType, "link":cLink] as [String : Any]
                                        if(included == 1){
                                            subcategoryArray.append(dictionarMain)
                                        }
                                         i += 1
                                     }
                                    let ids = String(describing: (_source?["id"] as? Int64)! )
                                    let names = _source?["name"] as! String
                                    var dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                    dictionarMain = ["name": names, "id" : ids,"type": menu,"link":menuLink,"children": subcategoryArray]
                                    array.append(dictionarMain)
                           
                                }
                               else{
                                    let ids = String(describing: (_source?["id"] as? Int64)! )
                                    let names = _source?["name"] as! String
                                    var dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                    
                                    dictionarMain = ["name": names, "id" : ids,"type": menu,"link":menuLink]
                                    array.append(dictionarMain)
                              
                                }
                            }
                        if(columnBreakpoint == 1){
                            
                            breakpointReached = true;
                        }
                           let SubID = String(describing: (_source?["id"] as? Int64)! )
                           let subName = (_source?["name"] as? String)!
                           var dictionarMain = ["name": subName, "id" : SubID, "type": menu,"link":menuLink] as [String : Any]
                           subcategoryArray.append(dictionarMain)
                           dictionarMain = ["children": subcategoryArray]
                           if(counter == values.count - 1){
                               dictionarMain = ["name":tempParent,"id":tempID,"type": menu,"link":menuLink,"children": subcategoryArray]
                               array.append(dictionarMain)
                               
                           }
                       }
                   }
 
           }
        for item in array {
            
            let dataItem = item as? [String: Any]
            let name = dataItem?["name"] as? String
            let id = dataItem?["id"] as? String
            let parentlinkType = dataItem?["type"] as? String
            let parentlink = dataItem?["link"] as? String
            let category = ProductList(context: managedContext)
            
            category.genderID = searchType
            category.parentCatId = "0"
            category.parentCatName = " "
            
            category.categoryId = id
            category.catName = name
            
            category.linkType = parentlinkType
            category.linkCatIds = parentlink
            let parentcategoryID =  id
            let parentcatName =  name
            //               print("===========>",name)
            CoreDataManager.sharedManager.insertProDuctListData(productList: category)
            let child = dataItem?["children"] as? [[String: Any]]
            guard let values = child else { continue }
            
            for childItem in values {
                
                
                let productChild = ProductList(context : managedContext)
                let childName = childItem["name"] as? String
                let childId = childItem["id"] as? String
                let childlinkType = childItem["type"] as? String
                let childlink = childItem["link"] as? String
                productChild.genderID = searchType
                //                        print("===========>",childName)
                //kk need to find how to get gender id
                //  category.genderID = id!
                productChild.parentCatId =  parentcategoryID
                productChild.categoryId = childId
                productChild.catName = childName
                productChild.parentCatName = parentcatName
                 productChild.linkType = childlinkType
                 productChild.linkCatIds = childlink
              
                
                CoreDataManager.sharedManager.insertProDuctListData(productList: productChild)
                
                
            }
            
            
            
        }
           //CoreDataManager.sharedManager.saveContext()
           
       
           
       }
    func  newElasticSearchWomenAPi(){
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "WomenData")
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "WomenChildData")
        let parameters = "{\"_source\":[\"name\",\"id\",\"menu_item_type\",\"position\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"3\"}},{ \"match\": { \"include_in_menu\": \"1\"}}]}}}"
    let dic = convertToDictionary(text: parameters)
    let url = getCategorySearchUrl(category: SelectedCat)
        //print("New Elastic Search Api url", url)
         DispatchQueue.main.async {
            ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                if let error = error{
                    print(error)
                    if error.localizedDescription.contains(s: "offline"){
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                if response != nil{
                    if statusCode == 200  {
                         let dict = response?.dictionaryObject
                        let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                        let innerHits = hits["hits"] as? [[String : Any]]
                        guard let values = innerHits else { return }
                        var array = [[String :Any]]()
//                        var subcategoryArray = [String]()
                        var subcategoryArray = [[String: Any]]()
                        var tempParent = ""
                        var tempID = ""
                        var dic = [String : Any]()
                        var counter = 0
                        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

                        if values.count > 0 {
                            for data in 0...values.count - 1 {
                                let _source = values[data]["_source"] as? [String: Any]
                                let menu = _source?["menu_item_type"] as? String
                                let id = _source?["id"] as? Int64
                                
                                counter += 1
                                if menu == "title" {
                                    if(tempParent != ""){
                                        dic = ["name" : tempParent, "id" : tempID,"children": subcategoryArray]
                                        array.append(dic)
                                    }
                                    tempParent = (_source?["name"] as? String)!
                                    tempID = String(describing: (_source?["id"] as? Int64)! )
                                    
                                    subcategoryArray = []
                                }else{
                                    let SubID = String(describing: (_source?["id"] as? Int64)! )
                                    let subName = (_source?["name"] as? String)!
                                    var dictionarMain = ["name": subName, "id" : SubID] as [String : Any]
                                    subcategoryArray.append(dictionarMain)
                                    dictionarMain = ["children": subcategoryArray]
                                    if(counter == values.count - 1){
                                        dictionarMain = ["name":tempParent,"id":tempID,"children": subcategoryArray]
                                        array.append(dictionarMain )
                                       
                                    }
                                }
                            }
                            /*
                        for data in 0...values.count - 1 {
                            let _source = values[data]["_source"] as? [String: Any]
                            let menu = _source?["menu_item_type"] as? String
                            counter += 1
                            if menu == "title" {
                                if(tempParent != ""){
                                    array.append([tempParent : subcategoryArray])
                                }
                                tempParent = (_source?["name"] as? String)!+";;"+String(describing: (_source?["id"] as? Int64)! )
                                subcategoryArray = []
                            }else{
                                subcategoryArray.append((_source?["name"] as? String)!+";;"+String(describing: (_source?["id"] as? Int64)! ))
                                if(counter == values.count - 1){
                                   array.append([tempParent : subcategoryArray])
                                }
                            }
                           
                        }*/
                    }
//                         print("Women",array)
                                      for item in array {
                                         
                                          let dataItem = item as? [String: Any]
                                          let name = dataItem?["name"] as? String
                                          let id = dataItem?["id"] as? String
                                          let category = WomenData(context: managedContext)
                                          category.id = id
                                          category.name = name
                                          let child = dataItem?["children"] as? [[String: Any]]
                                          guard let values = child else { return }

                                          for childItem in values {
                                            let womenChild = WomenChildData(context : managedContext)

                                              let name = childItem["name"] as? String
                                              let id = childItem["id"] as? String
                                              womenChild.id = id
                                              womenChild.name = name
                                              category.addToWomens(womenChild)
                                          }
                                      }
                                      CoreDataManager.sharedManager.saveContext()

                    }
                }
            }
        }
    }
    func  newElasticSearchMenAPi(){
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "MenData")
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "MenChildData")

        let parameters = "{\"_source\":[\"name\",\"id\",\"menu_item_type\",\"position\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"122\"}},{ \"match\": { \"include_in_menu\": \"1\"}}]}}}"
    let dic = convertToDictionary(text: parameters)
    let url = getCategorySearchUrl(category: SelectedCat)
        print("New Elastic Search Api url", url)
         DispatchQueue.main.async {
            ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                if let error = error{
                    print(error)
                    if error.localizedDescription.contains(s: "offline"){
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                if response != nil{
                    if statusCode == 200  {
                         let dict = response?.dictionaryObject
                        let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                        let innerHits = hits["hits"] as? [[String : Any]]
                        guard let values = innerHits else { return }
                        var array = [[String :Any]]()
                        var subcategoryArray = [[String: Any]]()
                        var tempParent = ""
                        var tempID = ""
                        var dic = [String : Any]()
                        var counter = 0
                        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
                        var breakpointReached = false
                        
                        if values.count > 0 {

                        for data in 0...values.count - 1 {
                            let _source = values[data]["_source"] as? [String: Any]
                            let menu = _source?["menu_item_type"] as? String
                            let columnBreakpoint = _source?["column_breakpoint"] as? Int
                            print("**************************************")
                            print(_source?["name"])
                            print(breakpointReached)
                            print("**************************************")
                            counter += 1
                            if menu == "title" || breakpointReached {
                                if(tempParent != ""){
                                    dic = ["name" : tempParent, "id" : tempID,"children": subcategoryArray]
                                    array.append(dic)
                                }
                                 breakpointReached = false
                                tempParent = (_source?["name"] as? String)!
                                tempID = String(describing: (_source?["id"] as? Int64)! )
                                
                                subcategoryArray = []
                            }else{
                                let SubID = String(describing: (_source?["id"] as? Int64)! )
                                let subName = (_source?["name"] as? String)!
                                var dictionarMain = ["name": subName, "id" : SubID] as [String : Any]
                                subcategoryArray.append(dictionarMain)
                                dictionarMain = ["children": subcategoryArray]
                                if(counter == values.count - 1){
                                    dictionarMain = ["name":tempParent,"id":tempID,"children": subcategoryArray]
                                    array.append(dictionarMain )
//
                                }
                                if(columnBreakpoint == 1){
                                    breakpointReached = true
                                }
                            }
                           
                        }
                        }
                        // print("Men",array)
                        for item in array {
                           
                            let dataItem = item as? [String: Any]
                            let name = dataItem?["name"] as? String
                            let id = dataItem?["id"] as? String
                            let category = MenData(context: managedContext)
                            category.id = id
                            category.name = name
                            let child = dataItem?["children"] as? [[String: Any]]
                            guard let values = child else { return }

                            for childItem in values {
                                let menChild = MenChildData(context : managedContext)
                                let name = childItem["name"] as? String
                                let id = childItem["id"] as? String
                                menChild.id = id
                                menChild.name = name
                                category.addToMens(menChild)
                            }
//                             print(child)
                        }
                        CoreDataManager.sharedManager.saveContext()
                    }
                }
            }
        }
    }
    
    func newElasticSearchKidsAPi(){
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "KidsData")
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "KidsChildData")
        
        let parameters = "{\"_source\":[\"name\",\"id\",\"menu_item_type\",\"position\",\"children_data.name\",\"children_data.id\"],\"sort\":[{\"position\":{\"order\":\"asc\"}}],\"size\":500,\"query\": {\"bool\": {\"must\": [{\"match\": {\"level\": \"3\" }},{ \"match\": { \"parent_id\": \"209\"}},{ \"match\": { \"include_in_menu\": \"1\"}}]}}}"
        let dic = convertToDictionary(text: parameters)
        let url = getCategorySearchUrl(category: SelectedCat)
        //print("New Elastic Search Api url", url)
        DispatchQueue.main.async {
            ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                if let error = error{
                    print(error)
                    if error.localizedDescription.contains(s: "offline"){
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                if response != nil{
                    if statusCode == 200 {
                        let dict = response?.dictionaryObject
                        let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                        let innerHits = hits["hits"] as? [[String : Any]]
                        guard let values = innerHits else { return }
                        var array = [[String :Any]]()
                        // var subcategoryArray = [String]()
                        var subcategoryArray = [[String: Any]]()
                        var tempParent = ""
                        var tempID = ""
                        var dic = [String : Any]()
                        var counter = 0
                        var titleFound = false
                        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

                        if values.count > 0 {
                            
                            for data in 0...values.count - 1 {
                                let _source = values[data]["_source"] as? [String: Any]
                                let menu = _source?["menu_item_type"] as? String
                                counter += 1
                                
                                if menu == "title" {
                                    titleFound = true
                                    
                                    if(tempParent != ""){
                                        dic = ["name" : tempParent, "id" : tempID,"children": subcategoryArray]
                                        array.append(dic)
                                    }
                                    tempParent = (_source?["name"] as? String)!
                                    tempID = String(describing: (_source?["id"] as? Int64)! )
                                    
                                    subcategoryArray = []
                                }else{
                                    
                                    var i=0
                                    let children = _source?["children_data"] as? [[String : Any]]
                                    //Condition Before title is found
                                    if(titleFound == false && children?.count ?? 0 > 0){
                                        
                                        while(i < children?.count ?? 0 ){
                                            let ids = children?[i]["id"] as! Int64
                                            let names = children?[i]["name"] as! String
                                            let dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                            subcategoryArray.append(dictionarMain)
                                           
                                            i += 1
                                        }
                                        let ids = String(describing: (_source?["id"] as? Int64)! )
                                        let names = _source?["name"] as! String
                                        var dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                        dictionarMain = ["name": names, "id" : ids,"children": subcategoryArray]
                                        array.append(dictionarMain)
                                    }
                                    else if(titleFound == false){
                                        let ids = String(describing: (_source?["id"] as? Int64)! )
                                        let names = _source?["name"] as! String
                                        var dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                     
                                        dictionarMain = ["name": names, "id" : ids]
                                        array.append(dictionarMain)
                                    }
                                        
                                    else{
                                        let ids = String(describing: (_source?["id"] as? Int64)! )
                                        let names = _source?["name"] as! String
                                        let dictionarMain = ["name": names, "id" : ids] as [String : Any]
                                        subcategoryArray.append(dictionarMain)
                                    }
                                    //Condition for last Category Title
                                    if(counter == values.count - 1){
                                        let  dictionaryCollection = ["name":tempParent,"id":tempID,"children": subcategoryArray] as [String : Any]

                                        array.append(dictionaryCollection)
                                    }
                                }
                            }
                        }
                        //print("Kids",array)
                                                for item in array {
                                                   
                                                    let dataItem = item as? [String: Any]
                                                    let name = dataItem?["name"] as? String
                                                    let id = dataItem?["id"] as? String
                                                    let category = KidsData(context: managedContext)
                                                    category.id = id
                                                    category.name = name
                                                    let child = dataItem?["children"] as? [[String: Any]]
//
                                                    if child?.count != nil{
                                                    guard let values = child else { return }
                                                    for childItem in values {
                                                        let kidChild = KidsChildData(context : managedContext)

                                                        let name = childItem["name"] as? String
                                                        let id = childItem["id"] as? String
                                                        kidChild.id = id
                                                        kidChild.name = name
                                                        category.addToKids(kidChild)
                                                    }
                                                    }
                                                }
                                                CoreDataManager.sharedManager.saveContext()

                    }
                }
            }
        }
    }
    
    func getSearchScreenData(){
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "Men")
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "Women")
        CoreDataManager.sharedManager.deleteAllRecords(strEntity: "Kids")
        erresAllSearchData()
        let parameters = "{\"_source\":[\"children_data.name\",\"id\",\"children_data.id\",\"name\",\"children_data.children_data.name\",\"children_data.children_data.id\"],\"query\": {    \"bool\": {       \"must\": [{\"terms\": { \"id\": [122,209,3]}},{ \"match\": { \"level\": \"2\" } },{ \"match\": { \"include_in_menu\": \"1\"}}] }}}"
        let dic = convertToDictionary(text: parameters)
        let url = getCategorySearchUrl(category: SelectedCat)
        DispatchQueue.main.async {
            ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                if let error = error{
                    print(error)
                    if error.localizedDescription.contains(s: "offline"){
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                if response != nil{
                    if statusCode == 200  {
                        let dict = response?.dictionaryObject
                        let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                        let innerHits = hits["hits"] as? [[String : Any]]
                        guard let values = innerHits else { return }
                        for data in values {
                            let Sourcedata = data as NSDictionary
                            let _source = Sourcedata["_source"] as! [String : Any]
                            let Cat_Name = _source["name"] as? String
                            if Cat_Name == "Kids"{
                                let children_data = _source["children_data"] as! [Dictionary<String, Any>]
                                for dataChildren in children_data {
                                    let title = dataChildren["name"] as! String
                                    let id = dataChildren["id"] as! Int64
                                    //print(title, id)
                                    let Inner_Children_data = dataChildren["children_data"] as? [Dictionary<String, Any>] ?? []
                                    if Inner_Children_data.count > 0 {
                                        if title == "Boy"{
                                            for innerChild in Inner_Children_data{
                                                self.saveKidsChildrenBoy(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Girl"{
                                            for innerChild in Inner_Children_data{
                                                self.saveKidsChildrenGirl(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Baby"{
                                            for innerChild in Inner_Children_data{
                                                self.saveKidsChildrenBaby(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                    }
                                    self.saveKids(name: title, id: id)
                                    
                                }
                            }
                            if Cat_Name == "Men"{
                                let children_data = _source["children_data"] as! [Dictionary<String, Any>]
                                for dataChildren in children_data {
                                    let title = dataChildren["name"] as! String
                                    let id = dataChildren["id"] as! Int64
                                    let Inner_Children_data = dataChildren["children_data"] as? [Dictionary<String, Any>] ?? []
                                    if Inner_Children_data.count > 0 {
                                        if title == "Boots"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenBoot(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Lace Ups"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenLaceUps(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Loafers & Slippers"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenLoafersSlippers(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Sneakers"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenSneakers(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Sunglasses"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenSunglasses(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Slides & Flip Flops"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenSlidesFlipFlops(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Bags"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenMenBags(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Jewellery"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenJewellery(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Small Leather Goods"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenSmallLeatherGoods(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Other Accessories"{
                                            for innerChild in Inner_Children_data{
                                                self.saveMenOtherAccessories(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                    }
                                    //print(title, id)
                                    self.saveMen(name: title, id: id)
                                }
                            }
                            if Cat_Name == "Women"{
                                let children_data = _source["children_data"] as! [Dictionary<String, Any>]
                                for dataChildren in children_data {
                                    let title = dataChildren["name"] as! String
                                    let id = dataChildren["id"] as! Int64
                                    let Inner_Children_data = dataChildren["children_data"] as? [Dictionary<String, Any>] ?? []
                                    if Inner_Children_data.count > 0 {
                                        if title == "Espadrilles"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenEspadrilles(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Loafers & Slippers"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenLoafersSlippers(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Pumps"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenPuma(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Sandals"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenSandals(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Sneakers"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenSneakers(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Heels"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenHeels(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Bags"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenBags(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        
                                        if title == "Mules"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenMules(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Jewellery"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenJewellery(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        
                                        if title == "Small Leather Goods"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenSmallLeatherGoods(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        
                                        if title == "Sunglasses"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenSunglasses(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        
                                        if title == "Other Accessories"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenOtherAccessories(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        
                                        if title == "Foot & Shoe Care"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenFootShoeCare(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Slides & Flip Flops"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenSlidesFlipFlops(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Flats"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenFlats(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                        if title == "Boots"{
                                            for innerChild in Inner_Children_data{
                                                self.saveWomenBoots(name: innerChild["name"] as! String, id : innerChild["id"] as! Int64)
                                            }
                                        }
                                    }
                                    //print(title, id)
                                    self.saveWomen(name: title, id: id)
                                }
                            }
                        }
                        
                        let search =   SearchCategoryRootClass.init(fromDictionary: (response?.dictionaryObject)!)
                        //print(search)
                        
                    }
                }
            }
        }
    }
    
    func erresAllSearchData(){
        sharedManger.deleteAllRecords(strEntity: "ProductList")

        sharedManger.deleteAllRecords(strEntity: "Men")
        sharedManger.deleteAllRecords(strEntity: "Kids")
        sharedManger.deleteAllRecords(strEntity: "Women")
        sharedManger.deleteAllRecords(strEntity: "KidsChildrenBaby")
        sharedManger.deleteAllRecords(strEntity: "KidsChildrenBoy")
        sharedManger.deleteAllRecords(strEntity: "KidsChildrenGirl")
        sharedManger.deleteAllRecords(strEntity: "MenBags")
        sharedManger.deleteAllRecords(strEntity: "MenBoots")
        sharedManger.deleteAllRecords(strEntity: "MenJewellery")
        sharedManger.deleteAllRecords(strEntity: "MenLaceUps")
        sharedManger.deleteAllRecords(strEntity: "MenLoafersSlippers")
        sharedManger.deleteAllRecords(strEntity: "MenOtherAccessories")
        sharedManger.deleteAllRecords(strEntity: "MenSlidesFlipFlops")
        sharedManger.deleteAllRecords(strEntity: "MenSmallLeatherGoods")
        sharedManger.deleteAllRecords(strEntity: "MenSneakers")
        sharedManger.deleteAllRecords(strEntity: "MenSunglasses")
        sharedManger.deleteAllRecords(strEntity: "RecentSearch")
        sharedManger.deleteAllRecords(strEntity: "TrandingNow")
        sharedManger.deleteAllRecords(strEntity: "WomenBags")
        sharedManger.deleteAllRecords(strEntity: "WomenBoots")
        sharedManger.deleteAllRecords(strEntity: "WomenEspadrilles")
        sharedManger.deleteAllRecords(strEntity: "WomenFlats")
        sharedManger.deleteAllRecords(strEntity: "WomenFootShoeCare")
        sharedManger.deleteAllRecords(strEntity: "WomenHeels")
        sharedManger.deleteAllRecords(strEntity: "WomenJewellery")
        sharedManger.deleteAllRecords(strEntity: "WomenLoafersSlippers")
        sharedManger.deleteAllRecords(strEntity: "WomenMules")
        sharedManger.deleteAllRecords(strEntity: "WomenOtherAccessories")
        sharedManger.deleteAllRecords(strEntity: "WomenPuma")
        sharedManger.deleteAllRecords(strEntity: "WomenSandals")
        sharedManger.deleteAllRecords(strEntity: "WomenSlidesFlipFlops")
        sharedManger.deleteAllRecords(strEntity: "WomenSmallLeatherGoods")
        sharedManger.deleteAllRecords(strEntity: "WomenSneakers")
        sharedManger.deleteAllRecords(strEntity: "WomenSunglasses")
    }
    
    func HomeApi() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.async {
            let url = ApiManager.getCMSUrl(for: self.SelectedCat)
            let category = self.SelectedCat
            ApiManager.getLandingPageData(url: url, category: category) { [weak self] data in
                guard let `self` = self else { return proceed() }
                self.landingData = data
                proceed()
            }
            func proceed() {
                if let val = self.landingData {
                    guard let dataList = val._sourceLanding?.dataList else { return }
                    print("LH========\ncategory \(self.SelectedCat)")
                    for data in dataList {
                        for d in data.arraydata {
                            for val in d.elements {
                                print("title \(val.content)\ncategory_id \(val.category_id)")
                            }
                        }
                    }
                    print("LH====end====")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    ApiManager.sliderCache[self.SelectedCat] = val
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if((UserDefaults.standard.string(forKey: "storecode") == "" || UserDefaults.standard.string(forKey: "storecode") == nil) && selectedStoreCode != ""){
                    UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
        }
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        }
        if((UserDefaults.standard.string(forKey: "currency") == "" || UserDefaults.standard.string(forKey: "currency") == nil) && selectedCurrency != ""){
            UserDefaults.standard.setValue(selectedCurrency.localized, forKey: "currency")
        }
        UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "country"), forKey: "countryName")
        if((UserDefaults.standard.string(forKey: "countryName") == "" || UserDefaults.standard.string(forKey: "countryName") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
        }
        if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
        }
        if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
        }
        isLandingPageLoaded = true
        viewHeight = view.bounds.height
        newElasticSearchKidsAPi()
        addShopBagItemCount()
        addNotificationItemCount()
        newElasticSearchWomenAPi()
        newElasticSearchMenAPi()
        callApi()
    
         self.tblHome.reloadData()
        if UserDefaults.standard.value(forKey: string.language
        )as? String == string.en {
            switchViewControllers(isArabic: false)
            self.tabBarController?.switchViewControllersTab(isArabic: false)
        }else{
            switchViewControllers(isArabic: true)
            self.tabBarController?.switchViewControllersTab(isArabic:true)
        }
       
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom, bottomPadding > 0 {
                bottomConstraint.constant = 34 - bottomPadding
            } else {
                bottomConstraint.constant = 0
            }
        } else {
            bottomConstraint.constant = 0
        }
        //UserDefaults.standard.set(getWebsiteCurrency(),forKey: "currency")
        if isLanguageCodeChanged || isCountryCodeChanged{
        
        //UserDefaults.standard.set(getWebsiteCurrency(),forKey: "currency")
        if((UserDefaults.standard.string(forKey: "currency")) == "KDE"){
            UserDefaults.standard.setValue("KWD", forKey: "currency")
        }
        DispatchQueue.main.async {
            if((UserDefaults.standard.string(forKey: "storecode") == "" || UserDefaults.standard.string(forKey: "storecode") == nil) && selectedStoreCode != ""){
                        UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
            }
            if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
                UserDefaults.standard.setValue(selectedCountry, forKey: "country")
            }
            if((UserDefaults.standard.string(forKey: "currency") == "" || UserDefaults.standard.string(forKey: "currency") == nil) && selectedCurrency != ""){
                UserDefaults.standard.setValue(selectedCurrency.localized, forKey: "currency")
            }
            if((UserDefaults.standard.string(forKey: "countryName") == "" || UserDefaults.standard.string(forKey: "countryName") == nil) && selectedCountry != ""){
                UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
            }
            if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
                UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
            }
            if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
                UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
            }
            isLanguageCodeChanged = false
            isCountryCodeChanged = false
            self.getFilter()
            self.fecthMessagesCount()
        }
        }
    }

    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

       // let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    func getFilter(){
        let url = CommonUsed.globalUsed.filter
        
        resetAllRecords(in: "Filter")
        resetAllRecords(in: "SortBy")
        ApiManager.apiGet(url: url, params: [:] as! [String : Any]) { (response, error) in

               if let error = error{
                       //print(error)
                       if error.localizedDescription.contains(s: "offline"){

               }
              
               return
               }
         
           // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                self.filterData = FilterData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                
                DispatchQueue.main.async {
                    self.fetchFilterData()
                }
            }
        }
    }
    
    
    func saveFilterData() {
        
        for i in 0..<(filterData?._source?.filter_en?.data[0].filterby.count)!{
            let flt = CoreDataManager.sharedManager.insertFilterData(label: filterData?._source?.filter_en?.data[0].filterby[i].label ?? "", attribute_code: filterData?._source?.filter_en?.data[0].filterby[i].attribute_code ?? "", sort_order: Int16(filterData?._source?.filter_en?.data[0].filterby[i].sort_order ?? 0))
          if flt != nil {
              filter.append(flt!)
          }
       }
        
        DispatchQueue.main.async {
            self.saveSortByData()
        }
      }
    
    
    
    func setFilterAttributeCache(filterCache:[NSManagedObject]){
       
        resetAllRecords(in: "Attributes")
        var arrShould = [[String:Any]]()
        for i in 0..<filterCache.count{
           let attributeCode = filterCache[i].value(forKey: "attribute_code")as! String
           var matchParam = [String:Any]()
            let dict = ["attribute_code":attributeCode]
            
            matchParam["match"] = dict
            arrShould.append(matchParam)
        }
         
        var matchParam = [String:Any]()
        var dict = ["attribute_code":"material"]
                   
                   matchParam["match"] = dict
                   arrShould.append(matchParam)
        
        matchParam = [String:Any]()
        dict = ["attribute_code":"country_of_manufacture"]
                   
                   matchParam["match"] = dict
                   arrShould.append(matchParam)
        
            let dictShould = ["should":arrShould]
       
            let dictBool = ["bool":dictShould]
        
        var paramattr = [String:Any]()
       
            
            paramattr = ["_source":["attribute_code","id","options"],
                         "query":dictBool]
        
        
            self.getAttributeValues(param: paramattr)
        
    }
    
    func getAttributeValues(param:[String:Any]){
           let storeCode = CommonUsed.globalUsed.productIndexName
                  + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")/"
                 let url = CommonUsed.globalUsed.main  + "/" + storeCode + CommonUsed.globalUsed.attributeSearch
                  ApiManager.apiPost(url: url, params: param) { (response, error) in
                      
                      if let error = error{
                          print(error)
                          if error.localizedDescription.contains(s: "offline"){
                          }
                        
                          return
                      }
                
                    
                      if response != nil{
                          var dict = [String:Any]()
                          dict["data"] = response?.dictionaryObject
                        self.attributeData = ColorData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                        
                        DispatchQueue.main.async {
                            self.saveAttributeData()
                        }
                    }
        }
    }
    
    func saveAttributeData(){
        for i in 0..<(attributeData?.hits?.hitsList.count)!{
            let attr = CoreDataManager.sharedManager.insertAttribData(attribute_code: attributeData?.hits?.hitsList[i]._source?.attribute_code ?? "", options: attributeData?.hits?.hitsList[i]._source?.optionsList as? NSObject ?? NSObject())
           if attr != nil {
               attribute.append(attr!)
           }
        }
       
    }
    
    func saveSortByData() {
        for i in 0..<(filterData?._source?.filter_en?.data[0].sortby.count)!{
            let flt = CoreDataManager.sharedManager.insertSortByData(label: filterData?._source?.filter_en?.data[0].sortby[i].label ?? "", value: filterData?._source?.filter_en?.data[0].sortby[i].value ?? "", sort_order: Int16(filterData?._source?.filter_en?.data[0].sortby[i].sort_order ?? 0))
          if flt != nil {
              filter.append(flt!)
          }
       }
        DispatchQueue.main.async {
            self.fetchFilterData()
        }
    
      }
    
    func fetchFilterData() {
           filterArray = [NSManagedObject]()
           if CoreDataManager.sharedManager.fetchFilterData() != nil{
               
               filterArray = CoreDataManager.sharedManager.fetchFilterData() ?? []
               print("filterArray", filterArray.count)
           }
        DispatchQueue.main.async {
            if self.filterArray.count == 0{
                self.saveFilterData()
            }else{
                
                self.setFilterAttributeCache(filterCache: self.filterArray)
            }
        }
       }
    
    
    func callApi(){
        let strCode = "\(UserDefaults.standard.value(forKey: string.language) ?? string.en)"
        let url = CommonUsed.globalUsed.configEndPoint   + strCode + CommonUsed.globalUsed.onBoarding
        ApiManager.apiGet(url: url, params: [:]) { (response, error) in
            
            if let error = error{
                print(error)
                return
            }
            if response != nil{
                var dict = [String:Any]()
                dict[string.data] = response?.dictionaryObject
                let user = UserData.shared.getData()
                _ =  UserData.shared.setData(dic: dict)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
     
      updateVisibleLabelPositions()
        DispatchQueue.main.async {
            self.addShopBagItemCount()
            self.addNotificationItemCount()
        }
       
    }
    
    @IBAction func payment(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle.main)
        let changeVC: ChekOutVC!
        changeVC = storyboard.instantiateViewController(withIdentifier: "ChekOutVC") as? ChekOutVC
        self.navigationController?.pushViewController(changeVC, animated: true)
        
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        
        switch sender.tag {
            case 0:
                print("")
        case 1:
            print("")
        case 2:
            
            self.tabBarController?.selectedIndex = 2
        case 3:
            print("")
        case 4:
            self.tabBarController?.selectedIndex = 4
        default:
            return
        }
    }
    
    func DisableMenu(){
        btnHome.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        btnDesigner.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        btnSearch.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        btnProfile.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        btnCart.tintColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
    }
    
    func addShopBagItemCount(){
        if shopBagCountLabel != nil {
            shopBagCountLabel.removeFromSuperview()
            
        }
        if self.tabBarController != nil {
        var tabItem :[UIView] =    (self.tabBarController?.orderedTabBarItemViews())!
        shopBagCountLabel = UILabel()
      
         if UserDefaults.standard.value(forKey: string.language
         )as? String == string.ar {
            shopBagCountLabel.frame = CGRect(x: (tabItem[0].frame.width/2) , y: (tabItem[0].frame.height/2) - 20, width: 18, height: 18)
             tabItem[0].layer.insertSublayer(shopBagCountLabel.layer, at: 0)
         }else{
            shopBagCountLabel.frame = CGRect(x: (tabItem[4].frame.width/2) , y: (tabItem[4].frame.height/2) - 20, width: 18, height: 18)
            tabItem[4].layer.insertSublayer(shopBagCountLabel.layer, at: 0)
         }
         
         shopBagCountLabel.layer.cornerRadius = shopBagCountLabel.bounds.width/2
         shopBagCountLabel.font = BrandenFont.medium(with: 14.0)
         shopBagCountLabel.layer.borderWidth = 1
         shopBagCountLabel.layer.backgroundColor = UIColor.white.cgColor
          shopBagCountLabel.textColor = UIColor.black
         shopBagCountLabel.textAlignment = .center
        if UserDefaults.standard.integer(forKey: string.shopBagItemCount) > 0 {
            shopBagCountLabel.isHidden = false
            shopBagCountLabel.text = "\( UserDefaults.standard.integer(forKey: string.shopBagItemCount))"
        }else{
            shopBagCountLabel.isHidden = true
            }
        }
        // viewDemo.backgroundColor = UIColor.red
        
    }
    func addNotificationItemCount(){
        if notificationCountLabel != nil {
            notificationCountLabel.removeFromSuperview()
            
        }
        if self.tabBarController != nil {
        var tabItem :[UIView] =    (self.tabBarController?.orderedTabBarItemViews())!
            notificationCountLabel = UILabel()
      
         if UserDefaults.standard.value(forKey: string.language
         )as? String == string.ar {
            notificationCountLabel.frame = CGRect(x: (tabItem[1].frame.width/2) , y: (tabItem[1].frame.height/2) - 20, width: 18, height: 18)
             tabItem[1].layer.insertSublayer(notificationCountLabel.layer, at: 0)
         }else{
            notificationCountLabel.frame = CGRect(x: (tabItem[3].frame.width/2) , y: (tabItem[3].frame.height/2) - 20, width: 18, height: 18)
            tabItem[3].layer.insertSublayer(notificationCountLabel.layer, at: 0)
         }
         
            notificationCountLabel.layer.cornerRadius = notificationCountLabel.bounds.width/2
            notificationCountLabel.font = BrandenFont.medium(with: 14.0)
            notificationCountLabel.layer.borderWidth = 1
            notificationCountLabel.layer.backgroundColor = UIColor.white.cgColor
            notificationCountLabel.textColor = UIColor.black
            notificationCountLabel.textAlignment = .center
        if UserDefaults.standard.integer(forKey: string.notificationItemCount) > 0 {
            notificationCountLabel.isHidden = false
            notificationCountLabel.text = "\( UserDefaults.standard.integer(forKey: string.notificationItemCount))"
        }else{
            notificationCountLabel.isHidden = true
            }
        }
        // viewDemo.backgroundColor = UIColor.red
        
    }
    func fecthMessagesCount() {
        
        if UserDefaults.standard.value(forKey: "userToken") != nil {
            if MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount() != nil{
                let unreadCount = MarketingCloudSDK.sharedInstance().sfmc_getUnreadMessagesCount()
                UserDefaults.standard.set(unreadCount, forKey: string.notificationItemCount)
                NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
            }
        }
    }
}

extension LatestHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("willDisplay cell \(cell.self)")
        if let cell = cell as? ImageCell {
            cell.isVisible = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageCell {
            cell.isVisible = false
        }
    }
    private func getHeaderCell(_ tableView:UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScrollViewCell.identifier) as? ScrollViewCell else { return UITableViewCell() }
        cell.source = source
        cell.btnArrow.tag = indexPath.section
        cell.btnArrow.addTarget(self, action: #selector(onClickArrow(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnArrow)
            cell.lblTitle.textAlignment = .left
            cell.lblSubTitle.textAlignment = .left
            //cell.lblTitle.font = Common.
        }
        else{
           Common.sharedInstance.rotateButton(aBtn: cell.btnArrow)
            cell.lblTitle.textAlignment = .right
            cell.lblSubTitle.textAlignment = .right //Cairo-SemiBold
            cell.lblTitle.font =  UIFont(name: "Cairo-SemiBold", size: 20)
            cell.lblSubTitle.font =  UIFont(name: "Cairo-Light", size: 12)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return UITableViewCell() }
        if((UserDefaults.standard.string(forKey: "storecode") == "" || UserDefaults.standard.string(forKey: "storecode") == nil) && selectedStoreCode != ""){
                    UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
        }
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        }
        if((UserDefaults.standard.string(forKey: "currency") == "" || UserDefaults.standard.string(forKey: "currency") == nil) && selectedCurrency != ""){
            UserDefaults.standard.setValue(selectedCurrency.localized, forKey: "currency")
        }
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
        }
        if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
        }
        if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
        }
        if source.box_type == "box_view" {
            return getImageCell(tableView: tableView, indexPath: indexPath)
        } else if source.box_type == "product_view" {
            if indexPath.row == 0 {
                return getHeaderCell(tableView, indexPath: indexPath)
            }
            return getCollectionCell(tableView: tableView, indexPath: indexPath)
        } else if source.box_type == "additionalproduct_view" {
            if indexPath.row == 0 {
                return getHeaderCell(tableView, indexPath: indexPath)
            }
            return getMostWantedTableViewCell(tableView: tableView, indexPath: indexPath)
        } else if source.box_type == "slider_view" { //
            let cell:SliderCell = getSliderCell(tableView: tableView, indexPath: indexPath) as! SliderCell
            cell.navController = self.navigationController
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    @objc func onClickArrow(_ sender:UIButton){
        let nextVC = NewInVC.storyboardInstance!
        nextVC.isFirstTime = true
        nextVC.strGen = strgen
        let data = landingData?._sourceLanding?.dataList[sender.tag]
        nextVC.isFirstTime = true
        nextVC.headlingLbl = data!.title.uppercased()
        nextVC.cat_id = data!.category_id
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_"
        let storeCode = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url =  localizedUrl + storeCode + "/" + "category" + "/" + String(data!.category_id)
       
        ApiManager.apiGet(url: url, params: [:]) {(response:JSON?, error:Error? ) in
            if response != nil {
                let dict = response?.dictionaryObject
                let hits = dict?["_source"] as! [String : AnyObject] as [String: AnyObject]
                let categoryName = hits["name"] as? String
                globalCategoryName = categoryName?.lowercased() ?? ""
                nextVC.categoryName = categoryName?.lowercased() ?? ""
                self.navigationController?.pushViewController(nextVC, animated: true)
                //completion?(LandingPageData(dictionary: ResponseKey.fatchData(res: dictionary, valueOf: .data).dic))
            }
        }
        
    }
    
    @objc func onClickGo(_sender:UIButton){
        openLoginGo()
        //self.navigationController?.pushViewController(LoginViewController.storyboardInstance!, animated: true)
    }
    func openLoginGo() {
        let loginVC = LoginViewController.storyboardInstance!
        let navigationController = UINavigationController(rootViewController: loginVC)
         loginVC.isCommingFromHomeScreen = true
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
   
   
    @objc func onClickbtnSlider(_ sender:UIButton){
        let nextVC = NewInVC.storyboardInstance!
       nextVC.isFirstTime = true
        nextVC.strGen = strgen
        guard let source = landingData?._sourceLanding?.dataList[sender.tag].arraydata else { return }
        for i in 0..<source.count {
            for j in 0..<source[i].elements.count {
                if source[i].elements[j].type == "heading" {
                    let text = source[i].elements[j].content.uppercased()
                    nextVC.headlingLbl = text
                }
                if source[i].elements[j].type == "button" {
                    let catId = source[i].elements[j].category_id
                    nextVC.cat_id = catId
                }
            }
        }
        nextVC.isFirstTime = true
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_"
        let storeCode = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url =  localizedUrl + storeCode + "/" + "category" + "/" + String(nextVC.cat_id) as? String ?? ""
       
        ApiManager.apiGet(url: url, params: [:]) {(response:JSON?, error:Error? ) in
            if response != nil {
                let dict = response?.dictionaryObject
               //@@narayan
                if let hits = dict?["_source"] as? [String: AnyObject]{
                    let categoryName = hits["name"] as? String
                    globalCategoryName = categoryName?.lowercased() ?? ""
                    nextVC.categoryName = categoryName?.lowercased() ?? ""
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                //completion?(LandingPageData(dictionary: ResponseKey.fatchData(res: dictionary, valueOf: .data).dic))
            }
        }
    }
    
    @objc func onClickbtnBox(_ sender:UIButton) {
        sender.animateTap()
        let nextVC = NewInVC.storyboardInstance!
       nextVC.isFirstTime = true
        nextVC.strGen = strgen
        let imageCells = tblHome.visibleCells.filter({
            $0 is ImageCell
        })
        for cell in imageCells {
            guard let cell = cell as? ImageCell else { return }
            cell.isVisible = false
        }
        
        guard let data = landingData?._sourceLanding?.dataList[sender.tag] else { return }
        for i in 0..<data.arraydata.count {
            for j in 0..<data.arraydata[i].elements.count {
                if data.arraydata[i].elements[j].type == "heading"{
                    nextVC.headlingLbl = data.arraydata[i].elements[j].content.uppercased()
                }
                if data.arraydata[i].elements[j].type == "button"{
                    nextVC.cat_id = data.arraydata[i].elements[j].category_id
                }
            }
        }
        
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_"
        let storeCode = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url =  localizedUrl + storeCode + "/" + "category" + "/" + String(nextVC.cat_id) as? String ?? ""
       
        ApiManager.apiGet(url: url, params: [:]) {(response:JSON?, error:Error? ) in
            if response != nil && response?.dictionaryObject?["found"] as? Bool ?? false != false {
                let dict = response?.dictionaryObject
                let hits = dict?["_source"] as! [String : AnyObject] as [String: AnyObject]
                let categoryName = hits["name"] as? String
                globalCategoryName = categoryName?.lowercased() ?? ""
                nextVC.categoryName = categoryName?.lowercased() ?? ""
                self.navigationController?.pushViewController(nextVC, animated: true)
                //completion?(LandingPageData(dictionary: ResponseKey.fatchData(res: dictionary, valueOf: .data).dic))
            }
            else {
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let source = landingData?._sourceLanding?.dataList[section] else { return 0 }
        
        if source.box_type == "product_view" {
            return 2
        }

        if source.box_type == "additionalproduct_view" {
            if let hitsListCount = scrollViewData[section]?.hits?.hitsList.count {
                return hitsListCount + 1
            }
            return 0
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsCount = landingData?._sourceLanding?.dataList.count ?? 0
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return }
        if source.box_type == "additionalproduct_view" && indexPath.row != 0 {
            var ip = indexPath
            ip.row -= 1
            tableView.reloadRows(at: [indexPath], with: .none)
            let nextVC = ProductDetailVC.storyboardInstance!
            nextVC.selectedProduct = ip.row
            nextVC.detailData = scrollViewData[indexPath.section]
            applyTransitionAnimation(nextVC: nextVC)
            navigationController?.pushViewController(nextVC, animated: true)
        } else if let cell = tableView.cellForRow(at: indexPath) as? ImageCell {
            onClickbtnBox(cell.btn)
        }
    }
    
    private func applyTransitionAnimation(nextVC: Any) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFade
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }

    
}


extension LatestHomeViewController {
private func updateVisibleLabelPositions() {
  guard let cells = tblHome.visibleCells as? [ImageCell] else { return }
  for cell in cells {
   // updateLabelPosition(cell)
  }
}
private func updateLabelPosition(_ cell: ImageCell) {
//    let point = view.convert(cell.imgMain.frame.origin, from: cell.contentView)
//  let ratio = point.y / viewHeight
//
//  let updatedConstraint = (ratio * constraintRange) + minimumConstraint
  //cell.topConstraint.constant = updatedConstraint
}

}
extension LatestHomeViewController:NoInternetDelgate{
    func didCancel() {
       // self.HomeApi()
    }
}

extension LatestHomeViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }

        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            //print(currentLocPlacemark.country ?? "No country found")
            self.currentCountry = currentLocPlacemark.country ?? ""
            //print(currentLocPlacemark.isoCountryCode ?? "No country code found")
        }
    }
}
extension LatestHomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblHome {
            let topOffset = scrollView.contentOffset
            if topOffset.y <= 0 {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
}

extension UITabBarController {
    func orderedTabBarItemViews() -> [UIView] {
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
    return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
    }
}

class CustomTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var _size = super.sizeThatFits(size)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            _size.height = 85
        } else {
            _size.height = 60
        }
        return _size
    }
}

