

//
//  NewInVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 19/05/20.
//  Reviewed by Nitikesh Pattanayak on 12/06/2020

import UIKit
import SDWebImage
import CoreData
import MBProgressHUD

var filterGotChanged = false
var globalParam = [String:Any]()
var dictMatch = [String:Any]()
var dictSort = [String:Any]()
var dictParam = [String:Any]()
var arrMust = [[String:Any]]()
var plpGlobalData:NewInData?
var arrFilter = [NSManagedObject]()


class NewInVC: UIViewController, NewInCellDelegate {
    
    //var isProductsReceived = false
    var isProductsReceived = true
    @IBOutlet weak var navigationContainer: UIView!
    var  isLoginForAddWishList = false
    var isCommingFromA2Z: Bool = false
    var isComingFromFliter: Bool = false
    var isComingFromPDP: Bool = false
    var hasFilterChanged: Bool = false
    var instanceIndexPath = 0
    var objattrList = [String]()
    var applyFilter = ""
    var designDetail = [OptionsList]()
    var objList = [String]()
    var designData: [NSManagedObject] = []
    var stopPagination = 0
    var parentCategoryName = ""
    var categoryName = ""
    var isKlevuApiCalled = false // This has been added as KLevu api was called twice @@@Nitikesh
    
    static var storyboardInstance:NewInVC? {
        return StoryBoard.plp.instantiateViewController(withIdentifier: NewInVC.identifier) as? NewInVC
        
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNewIn: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en" {
                lblNewIn.addTextSpacing(spacing: 1.5)
            }else{
                lblNewIn.font = UIFont(name: "Cairo-SemiBold", size: lblNewIn.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblCount: UILabel!{
        
        didSet{
            self.lblCount.frame.size.width=60
            self.lblCount.frame.size.height=60
            self.lblCount.layer.cornerRadius = self.lblCount.bounds.width/2
            lblCount.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblNumber: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        
    }
    
    /*
     Variable Initialization
     cat_id: Category Id of the product <Int>
     strGen: <String>
     newInData: Product Response data for NewIn Category <Obj>
     refreshCount: Pagination Product Count <Int>
     headlingLbl: <String>
     */
    let coverableCellsIds = [NewInCell.identifier, NewInCell.identifier, NewInCell.identifier, NewInCell.identifier, NewInCell.identifier]
    var designId = ""
    var isFirstTime = false
    var cat_id = 0
    var strGen = ""
    var newInData : NewInData?
    var refreshCount = 10
    var sizeES = 0
    var prevRefreshCount = 0
    var headlingLbl = ""
    var klevuProductIds : Array = [Int]()
    var klevuCategory = "KLEVU_PRODUCT"
    var klevuGender = ""
    var klevuFilters = false
    var klevuSortOrder = "rel"
    override func viewDidLoad() {
        
         fetchAttributeeData()
        


        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
        super.viewDidLoad()
        
        fetchAttributeeData()
       
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            
            Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
        }
        else{
            
            Common.sharedInstance.rotateButton(aBtn: btnBack)
            
        }

        lblNewIn.text = headlingLbl.uppercased()
        //collectionView.isSkeletonable = true
        
        //collectionView.prepareSkeleton(completion: { done in
          //  self.collectionView.showAnimatedSkeleton()
       // })
       // view.showAnimatedSkeleton(usingColor:.white, transition: .crossDissolve(0.20))
        if isFirstTime{
            
            setFilter()
            klevuIDSearchApi()
        
        }
        collectionView.contentInset.top = 40
               collectionView.contentInset.bottom = 40
        if self.collectionView.numberOfItems(inSection: 0) > 0 {
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                              animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationContainer.addBottomShadow()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isKlevuApiCalled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isKlevuApiCalled = false
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
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
        }
        if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
        }
        if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
        }
        klevuCategory = "KLEVU_PRODUCT"
        stopPagination = 0
        let previousFilterCount = Int(lblCount.text ?? "0") ?? 0
        let currentFilterCount = UserDefaults.standard.value(forKey: "filtercount") as? Int ?? 0
        let sortChanged =  UserDefaults.standard.value(forKey: "sortCount") as? Bool ?? false
        var filterChanged = false
        if (previousFilterCount != currentFilterCount || sortChanged) {
            filterChanged = true
            UserDefaults.standard.set(false, forKey: "sortCount")
        }
        if ((((UserDefaults.standard.value(forKey: "filtercount")as? Int != 0 ||  UserDefaults.standard.value(forKey: "filtercount") != nil) && filterChanged)) || !isComingFromFliter ) && !self.isComingFromPDP {
            
                self.newInData = nil
                refreshCount = 10
                sizeES = 10
                prevRefreshCount = 0
                setFilter()
                klevuIDSearchApi()
        }else{
            if(filterGotChanged == true){
                
                
                self.newInData = nil
                refreshCount = 10
                sizeES = 10
                prevRefreshCount = 0
                setFilter()
                klevuIDSearchApi()
            }
        }
        filterGotChanged = false
        
       self.isComingFromPDP = false
        if UserDefaults.standard.value(forKey: "filtercount")as? Int == 0 ||  UserDefaults.standard.value(forKey: "filtercount") == nil{
            lblCount.isHidden = true
            lblNumber.isHidden = true
        }else{
             
            lblCount.isHidden = false
            lblNumber.isHidden = false
            animateFilterLabel()
            lblNumber.text = "\(UserDefaults.standard.value(forKey: "filtercount") ?? 0)"
            lblCount.text = "\(UserDefaults.standard.value(forKey: "filtercount") ?? 0)"
        }
    }
    
    func checkCaching(){
        
    }
    func setFilter(){
        if strGen == "61"  {
            
            if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                self.applyFilter = "gender:للنساء"
                self.klevuGender = "للنساء"
            }
            else {
                self.applyFilter = "gender:Women"
                self.klevuGender = "Women"
            }
        } else if strGen == "39"  {
            
            if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                self.applyFilter = "gender:للرجال"
                self.klevuGender = "للرجال"
            }
            else {
                self.applyFilter = "gender:Men"
                self.klevuGender = "Men"
            }
        } else if strGen == "1610"  {
            
            if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                self.applyFilter = "gender:للأطفال الرضع;;gender:للجنسين;;gender:للبنات"
                self.klevuGender = "Kids"
            }
            else {
                self.applyFilter = "gender:Baby;;gender:Boy;;gender:Girl"
                self.klevuGender = "للأطفال";
            }
        }
        self.setFilters()
    }
    
    func setFilters(){
        
        if designId == ""{
          
            if(self.categoryName != ""){
                
                if(strGen == "1610"){
                    self.klevuGender = "Kids"
                    
                    if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                        self.klevuGender = "للأطفال";
                    }
                    //klevuCategory = "KLEVU_PRODUCT" + " " + kids  + ";" + self.parentCategoryName.capitalized + ";" + self.categoryName
                    klevuCategory =  klevuCategory + " "  + self.klevuGender + ";" + self.parentCategoryName.capitalized + ";" + self.categoryName.lowercased()
                }else{
                    klevuCategory =  klevuCategory + " "  + self.klevuGender  + ";" + self.categoryName.lowercased()
                }
                
                    
                    if(self.parentCategoryName.lowercased() == "designers"){
                        self.klevuFilters = true
                        klevuCategory = "KLEVU_PRODUCT"
                    }
                    else if(self.categoryName.lowercased().contains("all")  || self.categoryName.lowercased().contains("الكل") || self.categoryName.lowercased().contains("عرض")){
                        klevuCategory = "KLEVU_PRODUCT" + " "  + self.klevuGender + ";" + self.parentCategoryName.capitalized
                    }
                }
            
            else{
                klevuCategory = "KLEVU_PRODUCT" + " "  + self.klevuGender
            }
            
        }else{
            //dictParam = ["configurable_children.manufacturer":designId]
            //let dict = ["match" : dictParam]
            //arrMust.append(dict)
            //self.applyFilter = self.applyFilter + ";;" + "designers:" + getBrandName(id: designId).lowercased()
            klevuCategory = klevuCategory + " " + "designers;" + getBrandName(id: designId).lowercased()
        }
        
    }
    
    func klevuIDSearchApi(){
        if isKlevuApiCalled {
            isKlevuApiCalled = false
        }
        else{
            isKlevuApiCalled = true
            if !isComingFromFliter{
                UserDefaults.standard.set(nil, forKey: "sortby")
            }
            else if UserDefaults.standard.value(forKey: "sortby") as? String == "Newest First"{
                klevuSortOrder = "NEW_ARRIVAL_DESC"
            }
            /*else if UserDefaults.standard.value(forKey: "sortby") as? String == "Highest Price"{
             klevuSortOrder = "htl"
             }
             else if UserDefaults.standard.value(forKey: "sortby") as? String == "Lowest Price"{
             klevuSortOrder = "lth"
             }*/
            var param = [
                //  validationMessage.ticket:"klevu-158358783414411589",
                validationMessage.ticket:getSkuCode(),
                validationMessage.term: "*" ,
                validationMessage.paginationStartsFrom: 0,
                validationMessage.noOfResults:10000,
                validationMessage.showOutOfStockProducts:"false",
                // validationMessage.fetchMinMaxPrice:"true",
                validationMessage.enableMultiSelectFilters:"true",
                validationMessage.sortOrder: klevuSortOrder,
                validationMessage.enableFilters:"true",
                //validationMessage.applyResults:"",
                validationMessage.visibility:"search",
                validationMessage.category: klevuCategory,
                //validationMessage.klevu_filterLimit:"50",
                //validationMessage.sv:"2219",
                //validationMessage.lsqt:"",
                validationMessage.responseType:"json",
                validationMessage.resultForZero:"1",
                "isCategoryNavigationRequest":"true"
                //validationMessage.applyFilters: self.applyFilter
            ] as [String : Any]
            //            arrSearchWord // badge_name
            if(self.klevuFilters){
                self.klevuFilters = false
                param[validationMessage.applyFilters] = self.applyFilter
            }
            let url = CommonUsed.globalUsed.KlevuMain + CommonUsed.globalUsed.kleviCloud + CommonUsed.globalUsed.klevuIDSearch
            //print("paginationStartsFrom :", fromIndex)
            //print("Simlar Pro URL \(url)")
            
            ApiManager.apiGet(url: url, params: param) {(response, error:Error? ) in
                if let error = error {
                    print(error)
                    if error.localizedDescription.contains(s: "offline") {
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    
                    return
                }
                if response != nil{
                    
                    let dict = response?.dictionaryObject
                    // print("Print RESULT DATA \(dict)")
                    _ =   SearchWordKlevuRootClass.init(fromDictionary: (response?.dictionaryObject)!)
                    // let meta = dict?["meta"] as? [String : Any]
                    let Product = dict?["result"] as? [[String : Any]]
                    //self.arrSimilarProduct = []
                    //self.arrSimilarProduct.append(contentsOf: Product!)
                    for i in 0..<(Product!.count) {
                        //print(Product![i]["id"])
                        self.klevuProductIds.append(Int(Product![i]["itemGroupId"] as? String ?? "") ?? 0)
                    }
                    DispatchQueue.main.async(execute: {
                        //self.collectionView.reloadData()
                        self.callPLP()
                    })
                    
                    //print("SIMILAR DATA \(self.arrSimilarProduct)")
                    
                }
            }
        }
    }
    
    func animateFilterLabel(){
        //Label Background Animation
        
        //Set the original Frame width as pr the designs
        self.lblCount.frame.size.width=14
        self.lblCount.frame.size.height=14
        
        //Animate it now
        UIView.animate(withDuration: 0.7, delay: 0, options: [.allowAnimatedContent],
                       animations: {
                        self.lblCount.layer.cornerRadius = self.lblCount.bounds.width/2
        }, completion: nil)
        //Label Content Animation
        UIView.animate(withDuration: 1.4, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.lblNumber.center.y -= self.lblNumber.center.y + 0.1
        }, completion: nil)
    }
    
    func requestPayload(){
        
        if !isComingFromFliter{
            //For Price VC
            selectedMinValue = 0.0
            selectedMaxValue = 1.0
            totalMaxPrice = 0.0
            //END PriceVC
            
            plpGlobalData = nil
            UserDefaults.standard.set(nil, forKey: "priceNm")
            UserDefaults.standard.set(nil, forKey: "colorNm")
            UserDefaults.standard.set(nil, forKey: "categoryNm")
            UserDefaults.standard.set(nil, forKey: "designNm")
            UserDefaults.standard.set(nil, forKey: "genderNm")
            UserDefaults.standard.set(nil, forKey: "sizeNm")
            UserDefaults.standard.set(nil, forKey: "sortby")
            UserDefaults.standard.setValue(0, forKey: "filtercount")
            UserDefaults.standard.set( false , forKey: "sortCount")
            arrMust.removeAll()
            arrMust = []
            if designId != ""{
                dictParam = ["configurable_children.manufacturer":designId]
                let dict = ["match" : dictParam]
                arrMust.append(dict)
            }
        }
        
       
        if designId == ""{
            dictParam = ["category_ids":cat_id]
            dictMatch["match"] = dictParam
            
            arrMust.append(dictMatch)
        }else{
            dictParam = ["configurable_children.manufacturer":designId]
            let dict = ["match" : dictParam]
            arrMust.append(dict)
        }
        if !isCommingFromA2Z{
            if(strGen != "1610"){
                dictParam = ["configurable_children.gender":strGen]
                dictMatch["match"] = dictParam
                arrMust.append(dictMatch)
            }else{
               
                    //Leave as it is for kids or put ids
                   
                arrMust.append(["terms": ["gender":[1610,88,109,1430]]])
                
            }
        }
        
        dictParam = ["type_id":"configurable"]
        dictMatch["match"] = dictParam
        arrMust.append(dictMatch)
       
        //dictParam = ["visibility": [2,4]]
        //dictMatch["terms"] = dictParam
        arrMust.append(["terms": ["visibility": [2,4]]])
        //arrMust.append(["terms": ["id": klevuProductIds]])
        dictParam = ["configurable_children.stock.is_in_stock":true]
        dictMatch["match"] = dictParam
        arrMust.append(dictMatch)
        
        dictParam = ["configurable_children.status":1]
        dictMatch["match"] = dictParam
        arrMust.append(dictMatch)
        
        let gte = ["gte":1]
        dictParam = ["configurable_children.stock.qty":gte]
        var rangeDict = [String:Any]()
        rangeDict["range"] = dictParam
        arrMust.append(rangeDict)
        
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
       
        
        
        if CoreDataManager.sharedManager.fetchFilterData() != nil{
            
            arrFilter = CoreDataManager.sharedManager.fetchFilterData() ?? []
            print("filterArray", arrFilter.count)
        }
        
        var dictaggs = Dictionary<String,Any>()
        
        for i in 0..<arrFilter.count{
            if arrFilter[i].value(forKey: "attribute_code")as? String != "price_view"{
                let strConfig = "configurable_children."
                let attr = arrFilter[i].value(forKey: "attribute_code")as? String ?? ""
                let dictField = ["field":strConfig+attr,"size":100000] as [String : Any]
                var dictTerms = [String:Any]()
                dictTerms["terms"] = dictField
                var dictFilter = [String:Any]()
                let key = attr + "Filter"
                dictFilter[key] = dictTerms
                dictaggs.add(dictFilter)
            }
        }
        
        
        var dictField = ["field":"final_price"]
        var dictTerms = [String:Any]()
        dictTerms["max"] = dictField
        var dictPricemax = [String:Any]()
        dictPricemax["max_price"] = dictTerms
        
        dictField = ["field":"final_price"]
        dictTerms = [String:Any]()
        dictTerms["min"] = dictField
        var dictPricemin = [String:Any]()
        dictPricemin["min_price"] = dictTerms
        
        dictaggs.add(dictPricemin)
        dictaggs.add(dictPricemax)
        
        
        //if(self.klevuProductIds.count != 0){
            /*let sortStr1 = """
                    {"_script" : {"type" : "number","script": {"inline" : "params.sortOrder.indexOf((int)doc['id'].value)","params": {"sortOrder":
                    """
                   
            let sortStr2 =
                """
                    }},"order" : "asc"}}
                """
            let sortStr = String(sortStr1) + "[" + self.klevuProductIds.joined(separator: ",")  + "]"
            let sort = convertToDictionary(text: (sortStr + String(sortStr2)))*/
        //}
        self.klevuProductIds.reverse()
        let sortOrder = ["sortOrder": self.klevuProductIds]
        self.klevuProductIds.reverse()
        let script = ["inline": "params.sortOrder.indexOf((int)doc['id'].value);", "params": sortOrder] as [String : Any]
        let inlineScript = ["script": script]
        let queryParam = ["query": dictBool, "script_score": inlineScript]

        let functionScore = ["function_score": queryParam] as [String : Any]
        
        globalParam = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","size","description","meta_description","image","manufacturer","color","configurable_children.sku","configurable_options","material","media_gallery","lvl_category","lvl_concession_type","sku", "stock", "country_of_manufacture","id","badge_name","special_to_date","special_from_date"],
                       "from":prevRefreshCount,
                       "size":sizeES,
                       "query":functionScore,
                       "aggs":dictaggs
                       
            ] as [String : Any]
       
        if UserDefaults.standard.value(forKey: "sortby") as? String == "Relevance"  {
                   dictSort = ["order":"asc"]
                   var dictName = [String:Any]()
                   dictName["_id"] = dictSort
                   //globalParam["sort"] = dictName
               }
        if UserDefaults.standard.value(forKey: "sortby") as? String == "Newest First".localized{
            dictSort = ["order":"desc"]
            var dictName = [String:Any]()
            dictName["updated_at"] = dictSort
            //globalParam["sort"] = dictName
            
            
        }else if UserDefaults.standard.value(forKey: "sortby") as? String == "Highest Price"{
            dictSort = ["order":"desc"]
            var dictName = [String:Any]()
            dictName["final_price"] = dictSort
            globalParam["sort"] = dictName
            
        }else if UserDefaults.standard.value(forKey: "sortby") as? String == "Lowest Price"{
            dictSort = ["order":"asc"]
            var dictName = [String:Any]()
            dictName["final_price"] = dictSort
            globalParam["sort"] = dictName
            
        }else{
         
         dictSort = ["order":"asc"]
         var dictName = [String:Any]()
         dictName["id"] = dictSort
         //globalParam["sort"] = dictName
         }

        let jsonData = try! JSONSerialization.data(withJSONObject: globalParam)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
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
                DispatchQueue.main.async {
                    if error.localizedDescription.contains(s: "offline"){
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                        self.present(nextVC, animated: true, completion: nil)
                        
                    }
                    self.sharedAppdelegate.stoapLoader()
                }
                
                return
            }
            
            // try! realm.add(response)
            
            //            if response != nil{
            //                var dict = [String:Any]()
            //                dict["data"] = response?.dictionaryObject
            //                //print("Response Data \(dict)")
            //                if self.refreshCount == 10{
            //                    self.newInData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
            //                    //print(self.newInData ?? default value)
            //                }else{
            //                    let data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
            //                    for i in 0..<(data.hits?.hitsList.count)!{
            //                        self.newInData?.hits?.hitsList.append((data.hits?.hitsList[i])!)
            //                    }
            //                }
            //
            //
            //
            //                DispatchQueue.main.async {
            //                    self.collectionView.reloadData()
            //                }
            //                let user = UserData.shared.getDataFilter()
            //                if  user == nil{
            //                    self.getFilter()
            //                }
            //            }
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                if self.refreshCount == 10{
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.isProductsReceived = true
                        self.newInData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic); self.collectionView.reloadData()
                        let user = UserData.shared.getDataFilter()
                        if  user == nil{
                            self.getFilter()
                        }
                    }
                    
                    
                    //print(self.newInData ?? default value)
                }else{
                    let data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                    for i in 0..<(data.hits?.hitsList.count)!{
                        
                        self.newInData?.hits?.hitsList.append((data.hits?.hitsList[i])!)
              
                        self.collectionView.reloadData()
                        let user = UserData.shared.getDataFilter()
                        if  user == nil{
                            self.getFilter()
                        }
                    }
                }
                
                
                
                
                
            }
        }
    }
    
    /*
     PLP Page is being called here
     */
    func callPLP(){
        
        //Filter lable Animation called here! *Added by Nitikesh
        
        
        //Create request Payload for Products
        self.requestPayload()
        
        //Create url with the storecode for the products
        let url = getProductUrl()
        
        //Get all the products related to the Category and show them
        self.getProductApi(url:url,param:globalParam )
    }
    
    @IBAction func onClickFilter(_ sender: Any) {
        let nextVC = FilterVC.storyboardInstance!
        if plpGlobalData == nil{
            plpGlobalData = self.newInData
        }
        self.isComingFromFliter = true
        
        nextVC.isComingFromFliter = self.isComingFromFliter
        nextVC.plpData = plpGlobalData
        nextVC.strGen = strGen
        nextVC.cat_id = cat_id
        nextVC.designId = designId
        nextVC.isCommingFromA2Z = isCommingFromA2Z
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func getFilter(){
        let url = CommonUsed.globalUsed.filter
        
        ApiManager.apiGet(url: url, params: [:] as! [String : Any]) { (response, error) in
            
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                
                return
            }
            
            // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                let user = UserData.shared.getDataFilter()
                if  user == nil{
                    _ =  UserData.shared.setDataFilter(dic: dict)
                    
                    
                }
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
    func moveToLoginScreen(){
        let loginVC = LoginViewController.storyboardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
}
extension NewInVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func updateWishListProduct(newInCell:NewInCell){
        let indexPath = self.collectionView.indexPath(for: newInCell)
        if isWishListProduct(productId: String((newInData?.hits?.hitsList[indexPath!.row]._source!.sku)! )){
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else{
                var params:[String:Any] = [:]
                params["product_id"] = self.newInData?.hits?.hitsList[indexPath!.row]._source!.id
                params["sku"] = self.newInData?.hits?.hitsList[indexPath!.row]._source!.sku
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.removeWishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        newInCell.btnBookMark.set_image(UIImage(named: "Default")!, animated: true)
                    }
                }) {
                    
                }
            }
        } else {
            
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else{
                var params:[String:Any] = [:]
                params["product_id"] = self.newInData?.hits?.hitsList[indexPath!.row]._source!.id
                params["sku"] = self.newInData?.hits?.hitsList[indexPath!.row]._source!.sku
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.addTowishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        newInCell.btnBookMark.set_image(UIImage(named: "Selected")!, animated: true)
                    }
                }) {
                    
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
          if isProductsReceived{
              return newInData?.hits?.hitsList.count ?? 0
          }
          else{ return 4 }
          
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
          if isProductsReceived{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewInCell.identifier, for: indexPath) as? NewInCell else {
            return UICollectionViewCell()
        }
        
        guard let source = newInData?.hits?.hitsList[indexPath.row]._source else { return UICollectionViewCell() }
        cell.lblBrand.text = getBrandName(id: String(source.manufacturer))
        //cell.isSkeletonable = true
        let tagsArray = source.tags.components(separatedBy: ",")
        if tagsArray.count > 0 {
            let badge = "\(tagsArray[0])".uppercased()
            if badge.count > 1 {
                cell.lblTag.isHidden = false
                cell.lblTag.text = badge
            }
        }
        else{
             print("HIDE  TAG LABEL \(indexPath.row)")
            cell.lblTag.isHidden = true
        }
        
        if tagsArray.count > 1 {
            cell.lblTag2.isHidden = false
            cell.lblTag2.text = "\(tagsArray[1])".uppercased()
        }
        else{
            cell.lblTag2.isHidden = true
        }
        cell.newInCellDelegate = self
        cell.viewShadow.backgroundColor = .white
        
        cell.viewShadow.layer.shadowRadius = 7
        cell.viewShadow.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        cell.viewShadow.layer.shadowOpacity = 0.05
        cell.viewShadow.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        
        DispatchQueue.global().async {
            let str = CommonUsed.globalUsed.kimageUrl
            let imageStr = source.image
            let finalStr = str + imageStr

            cell.imgProduct.downloadSdImage(url: finalStr)
        }
        
        if UserDefaults.standard.value(forKey: "language")as? String == "ar" {
            cell.lblProductNm.textAlignment = .right
        } else {
            cell.lblProductNm.textAlignment = .left
        }
        cell.lblProductNm.text = source.name.uppercased()
        let regularPrice = source.regular_price
        let finalPrice = source.final_price
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentDateTime = Date()
        if (regularPrice != finalPrice){
            cell.lblOldPrice.isHidden = false
            cell.lblPrice.textColor = .red
            cell.lblPrice.textAlignment = .left
        } else {
            cell.lblOldPrice.isHidden = true
            cell.lblPrice.textColor = .black
            cell.lblPrice.textAlignment = .left
        }
            // print("Print Regular VAL  - (\(source.final_price)")
            var intFinalPrice = Double(source.final_price).clean
            var intRegularPrice = Double(source.regular_price).clean
            if let currencyVal = UserDefaults.standard.string(forKey: "currency") {
                cell.lblPrice.text = "\(intFinalPrice)  \(currencyVal.localized)"
                cell.lblOldPrice.attributedText = NSAttributedString.init(string: "\(intRegularPrice)  \(currencyVal.localized)").string.strikeThrough()
            }
            else{
                cell.lblPrice.text = "\(intFinalPrice) \("AED".localized)"
                cell.lblOldPrice.attributedText = NSAttributedString.init(string: "\(intRegularPrice)  \("AED".localized)").string.strikeThrough()
            }
            
           
        
        cell.btnBookMark.setImage(UIImage(named: "Default"), for: .normal)
        cell.btnBookMark.tag = indexPath.row
        
        if isWishListProduct(productId: String(source.sku)) {
            cell.btnBookMark.setImage(UIImage(named: "Selected"), for: .normal)
        } else {
            cell.btnBookMark.setImage(UIImage(named: "Default"), for: .normal)
        }
        cell.viewOverlay.isHidden = source.isSelected == false
        return cell
        }
          else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewInCell2", for: indexPath) as? NewInCell else {
                                 fatalError("Cell can't be dequeue")
                             }
                      ABLoader().startShining(cell.lblBrand)
                      ABLoader().startShining(cell.lblProductNm)
                      ABLoader().startShining(cell.imgProduct)
                      ABLoader().startShining(cell.lblPrice)
                      ABLoader().startShining(cell.lblTag)
                       return cell
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<((newInData?.hits?.hitsList.count ?? 0)) {
            newInData?.hits?.hitsList[i]._source?.isSelected = false
        }
        
        newInData?.hits?.hitsList[indexPath.row]._source?.isSelected = true
        
        DispatchQueue.main.async {
            
            collectionView.reloadData()
        }
       // DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.1) {
            self.isComingFromPDP = true
            
            let nextVC = ProductDetailVC.storyboardInstance!
            nextVC.selectedProduct = indexPath.row
            nextVC.detailData = self.newInData
            nextVC.strGen = self.strGen
            nextVC.isComingFromPDP = self.isComingFromPDP
            self.openPDP(nextVC: nextVC)
            //self.navigationController?.pushViewController(nextVC, animated: true)
       // }
    }
    func openPDP(nextVC: Any) {
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFade
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(nextVC as! UIViewController, animated: false)
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width - 15) / 2, height:335)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 15
//    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       if(indexPath.row == refreshCount-2 && stopPagination == 0){
            instanceIndexPath = indexPath.row
            reloadMoreData(indexPath: indexPath)
        }
    }
    
    func reloadMoreData(indexPath: IndexPath) {
//        if newInData?.hits?.total ?? 0 <= 10{
//            refreshCount = newInData?.hits?.total ?? 0
//            sizeES = newInData?.hits?.total ?? 0
//            stopPagination = 1
//        }
        if refreshCount < newInData?.hits?.total  ?? 0 {
//            prevRefreshCount = refreshCount
//            if(prevRefreshCount == 0){
//                refreshCount = refreshCount + 10
//                stopPagination = 0
//                self.callPLP()
//            }
//            else if(((newInData?.hits?.total ?? 0) - (refreshCount)) <= 10){
//
//                refreshCount = ((newInData?.hits?.total ?? 0) - refreshCount) + refreshCount
//
//                sizeES = (newInData?.hits?.total ?? 0) - refreshCount
//                stopPagination = 1
//                self.callPLP()
//            }else{
                prevRefreshCount = refreshCount
                refreshCount = refreshCount + 10
                sizeES = 10
                stopPagination = 0
                self.callPLP()
            
//            }
            
        }
    }
    
    
}
extension NewInVC:NoInternetDelgate{
    func didCancel() {
        self.setFilter()
        self.klevuIDSearchApi()
    }
}
extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.09
        self.layer.backgroundColor = UIColor.white.cgColor
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+5)
        }
        if (!right) {
            viewWidth-=(shadowRadius+25)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}
extension Int {
    func withCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter()
         numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


class InsetLabel: UILabel {
    let topInset = CGFloat(3), bottomInset = CGFloat(3), leftInset = CGFloat(4), rightInset = CGFloat(4)
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
