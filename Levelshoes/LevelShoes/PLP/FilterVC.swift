//
//  FilterVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 20/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData


var strSelectedFilter = ""
class FilterVC: UIViewController {
    var isComingFromFliter : Bool = false
    var isCommingFromA2Z : Bool = false
    static var storyboardInstance:FilterVC? {
        return StoryBoard.plp.instantiateViewController(withIdentifier: FilterVC.identifier) as? FilterVC
        
    }
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: backBtn)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: backBtn)
            }
        }
    }
    @IBOutlet weak var viewActiveFilters: UIView!
    
    @IBOutlet weak var lblFilter: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFilter.font = UIFont(name: "Cairo-SemiBold", size: lblFilter.font.pointSize)

            }
            lblFilter.text = "filters".localized
            lblFilter.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var btnClear: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnClear.titleLabel?.font = UIFont(name: "Cairo-Light", size: 16)

            }
            btnClear.setTitle("clear_search".localized, for: .normal)
            btnClear.underline()
        }
    }
    @IBOutlet weak var lblActivefilters: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblActivefilters.font = UIFont(name: "Cairo-SemiBold", size: lblActivefilters.font.pointSize)

            }
            lblActivefilters.text = "active_filters".localized
        }
    }
    @IBOutlet weak var sortby: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                sortby.font = UIFont(name: "Cairo-SemiBold", size: sortby.font.pointSize)

            }
            sortby.text = "sortBy".localized
            
        }
    }
    @IBOutlet weak var lblFilterby: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFilterby.font = UIFont(name: "Cairo-SemiBold", size: lblFilterby.font.pointSize)

            }
            lblFilterby.text = "filterBy".localized
        }
    }
    
    @IBOutlet weak var btnShow: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                
                btnShow.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 15)
                

            }
        }
    }
    
    @IBOutlet weak var lblFilterCount: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFilterCount.font = UIFont(name: "Cairo-Light", size: lblFilterCount.font.pointSize)

            }
        }
    }
    @IBOutlet weak var constTblFilter: NSLayoutConstraint!
    @IBOutlet weak var constTblSort: NSLayoutConstraint!
    @IBOutlet weak var tblFilterBy: UITableView!{
        didSet{
            tblFilterBy.delegate = self
            tblFilterBy.dataSource = self
        }
    }
    @IBOutlet weak var tblSortBy: UITableView!{
        didSet{
            tblSortBy.delegate = self
            tblSortBy.dataSource = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var designId = ""
    var cat_id = 0
    var strGen = ""
    var plpData : NewInData?
    var arrDataSort = [[String:Any]]()
    var arrDataFilter = [[String:Any]]()
    var selectedData = [String]()
    var filterArray = [NSManagedObject]()
    var sortArray = [NSManagedObject]()
    var arrayColor = [String]()
    var arrarDesign =  [String]()
    var arrayDesign = [String]()
    var arrayCategory = [String]()
    var arraySize = [String]()
    var arrayGender = [String]()
    var arrayPrice = [String]()
    var filtersCunt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersCunt = "filterCount".localized
        lblFilterCount.text = "\(UserDefaults.standard.value(forKey: "filtercount") ?? 0) \(filtersCunt)"
        showOrHideActiveFilters(aVal: UserDefaults.standard.value(forKey: "filtercount") as! Int)
        let show = "show".localized
        let results = "result".localized
        self.btnShow.setTitle("\(show) \(plpData?.hits?.total ?? 0) \(results)", for: .normal)
        
        let filter = UserData.shared.getDataFilter()
        if filter != nil{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callPLP()
        
        selectedData = [String]()
        
        arrayColor = UserDefaults.standard.value(forKey: "colorNm") as? [String] ?? [String]()
        arrayGender = UserDefaults.standard.value(forKey: "genderNm") as? [String] ?? [String]()
        arraySize = UserDefaults.standard.value(forKey: "sizeNm") as? [String] ?? [String]()
        arrayDesign = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
        arrayCategory = UserDefaults.standard.value(forKey: "categoryNm") as? [String] ?? [String]()
        arrayPrice = UserDefaults.standard.value(forKey: "priceNm") as? [String] ?? [String]()
        if arrayCategory.count > 0{
                   selectedData.append("Category")
               }
        if arraySize.count > 0{
            selectedData.append("Size")
        }
        if UserDefaults.standard.value(forKey: "priceNm") != nil{
            selectedData.append("Price")
        }
        if arrayColor.count > 0 {
          selectedData.append("Color")
        }
        if arrayGender.count > 0{
            selectedData.append("Gender")
        }

        if arrayDesign.count > 0{
            selectedData.append("Designer")
        }

       /*
            if self.arrayColor.count != 0 {
            var tempData = selectedData
            if self.selectedData.count != 0{
                var i = 0
                var totalCount = self.selectedData.count
                while(i<totalCount){
                    if tempData[i] != "Color"{
                        tempData.append("Color")
                        totalCount += 1
                    }else{
                        tempData.remove(object: "Color")
                        totalCount -= 1
                    }
                    i += 1
                }
                tempData.append("Color")
                
                selectedData = tempData
            }else{
                selectedData.append("Color")
            }
        }
        
        if self.arrayGender.count != 0 {
            var tempData = selectedData
            if self.selectedData.count != 0{
                var i = 0
                var totalCount = self.selectedData.count
                while(i<totalCount){
                    if tempData[i] != "Gender"{
                        tempData.append("Gender")
                        totalCount += 1
                    }else{
                        tempData.remove(object: "Gender")
                        totalCount -= 1
                    }
                    i += 1
                }
                tempData.append("Gender")
                
                selectedData = tempData
            }else{
                selectedData.append("Gender")
            }
        }
        
        if self.arraySize.count != 0 {
            var tempData = selectedData
            if self.selectedData.count != 0{
                var i = 0
                var totalCount = self.selectedData.count
                while(i<totalCount){
                    if tempData[i] != "Size"{
                        tempData.append("Size")
                        totalCount += 1
                    }else{
                        tempData.remove(object: "Size")
                        totalCount -= 1
                    }
                    i += 1
                }
                tempData.append("Size")
                
                selectedData = tempData
            }else{
                selectedData.append("Size")
            }
        }
        
        if self.arrayCategory.count != 0 {
            var tempData = selectedData
            if self.selectedData.count != 0{
                var i = 0
                var totalCount = self.selectedData.count
                while(i<totalCount){
                    if tempData[i] != "Category"{
                        tempData.append("Category")
                        totalCount += 1
                    }else{
                        tempData.remove(object: "Category")
                        totalCount -= 1
                    }
                    i += 1
                }
                tempData.append("Category")
                
                selectedData = tempData
            }else{
                selectedData.append("Category")
            }
        }
        
        arrayDesign = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
        
        
        if self.arrayDesign.count != 0 {
            if self.selectedData.count != 0{
                var i = 0
                var totalCount = self.selectedData.count
                while(i<totalCount){
                    if selectedData[i] != "Designer"{
                        selectedData.append("Designer")
                        totalCount += 1
                    }else{
                        selectedData.remove(object: "Designer")
                        totalCount -= 1
                    }
                    i += 1
                }
            }else{
                selectedData.append("Designer")
            }
            
        }*/
        selectedData = selectedData.uniques
        if selectedData.count != 0{
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            lblFilterCount.text = "\(selectedData.count) \(filtersCunt)"
            showOrHideActiveFilters(aVal: selectedData.count)
            UserDefaults.standard.set(selectedData.count, forKey: "filtercount")
            btnClear.isUserInteractionEnabled = true
            btnClear.alpha = 1.0
        }else{
            btnClear.isUserInteractionEnabled = false
            btnClear.alpha = 0.5
            showOrHideActiveFilters(aVal: selectedData.count)
            self.collectionView.isHidden = true
        }
        
        arrDataFilter = [[String:Any]]()
        fetchFilterData()
        arrDataSort = [[String:Any]]()
        self.fetchSortrData()
        
    }
    private func showOrHideActiveFilters(aVal : Int) {
        print("OOOOOŒ")
        viewActiveFilters.isHidden = aVal > 0 ? false : true
    }
    func fetchSortrData() {
        sortArray = [NSManagedObject]()
        if CoreDataManager.sharedManager.fetchSortByData() != nil{
            
            sortArray = CoreDataManager.sharedManager.fetchSortByData() ?? []
            
            print("sortArray", sortArray.count)
            for i in 0..<sortArray.count{
                var dict = [String:Any]()
                dict = ["label":sortArray[i].value(forKey: "label") ?? "",
                        "value":sortArray[i].value(forKey: "value") ?? "",
                        "sort_order":sortArray[i].value(forKey: "sort_order") ?? "",
                        "isSeleced":false
                    
                ]
                arrDataSort.append(dict)
                
            }
        }
        if UserDefaults.standard.value(forKey: "sortby") != nil {
            for i in 0..<arrDataSort.count {
                if arrDataSort[i]["label"] as? String == UserDefaults.standard.value(forKey: "sortby") as? String{
                    arrDataSort[i]["isSelected"] = true
                }
            }
            tblSortBy.reloadData()
        }else{
            arrDataSort[0]["isSelected"] = true
        }
        for j in 0..<arrDataSort.count{
            for i in 0..<selectedData.count{
                if arrDataSort[j]["label"]as? String == selectedData[i]{
                    arrDataSort[j]["isSelected"] = true
                }
            }
        }
    }
    
    func fetchFilterData() {
        filterArray = [NSManagedObject]()
        if CoreDataManager.sharedManager.fetchFilterData() != nil{
            
            filterArray = CoreDataManager.sharedManager.fetchFilterData() ?? []
            print("filterArray", filterArray.count)
        }
        for i in 0..<filterArray.count{
            var dict = [String:Any]()
            dict = ["label":filterArray[i].value(forKey: "label") ?? "",
                    "attribute_code":filterArray[i].value(forKey: "attribute_code") ?? "",
                    "sort_order":filterArray[i].value(forKey: "sort_order") ?? "",
                    "isSeleced":false
                
            ]
            arrDataFilter.append(dict)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
            
            
            self.tblFilterBy.reloadData()
            //  self.constTblFilter.constant = self.tblFilterBy.contentSize.height
        })
    }
    
    func requestPayload(){
          
         if !isComingFromFliter{
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
         
         //dictParam = ["visibility":4]
         //dictMatch["match"] = dictParam
         //arrMust.append(dictMatch)
        arrMust.append(["terms": ["visibility": [2,4]]])
        
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
         
         globalParam = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","size","description","meta_description","image","manufacturer","color","configurable_children.sku","configurable_options","media_gallery","lvl_category","lvl_concession_type","sku", "stock", "country_of_manufacture","id","badge_name","special_to_date","special_from_date"],
                   
                        "query":dictBool,
                        "aggs":dictaggs
             ] as [String : Any]
         if UserDefaults.standard.value(forKey: "sortby") as? String == "Relevance"  {
                    dictSort = ["order":"asc"]
                    var dictName = [String:Any]()
                    dictName["_id"] = dictSort
                    globalParam["sort"] = dictName
                }
        if UserDefaults.standard.value(forKey: "sortby") as? String == "Newest First".localized{
             dictSort = ["order":"asc"]
             var dictName = [String:Any]()
             dictName["updated_at"] = dictSort
             globalParam["sort"] = dictName
             
             
        }else if UserDefaults.standard.value(forKey: "sortby") as? String == "Highest Price".localized{
             dictSort = ["order":"desc"]
             var dictName = [String:Any]()
             dictName["final_price"] = dictSort
             globalParam["sort"] = dictName
             
        }else if UserDefaults.standard.value(forKey: "sortby") as? String == "Lowest Price".localized{
             dictSort = ["order":"asc"]
             var dictName = [String:Any]()
             dictName["final_price"] = dictSort
             globalParam["sort"] = dictName
             
         }else{
          
          dictSort = ["order":"asc"]
          var dictName = [String:Any]()
          dictName["id"] = dictSort
          globalParam["sort"] = dictName
          }
         
         
         let jsonData = try! JSONSerialization.data(withJSONObject: globalParam)
         let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
         
    }
    
    func callPLP(){
        
        //Filter lable Animation called here! *Added by Nitikesh
        
        
        //Create request Payload for Products
        self.requestPayload()
        
        //Create url with the storecode for the products
        let url = getProductUrl()
        
        //Get all the products related to the Category and show them
        self.getProductApi(url:url,param:globalParam )
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
                    
                    
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            
            // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                let data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                 // plpGlobalData = data
                
                switch strSelectedFilter {

                    case "color":
                        
                        plpGlobalData?.aggregations?.designerFilter?.buckets = data.aggregations?.designerFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                        plpGlobalData?.aggregations?.sizeFilter?.buckets = data.aggregations?.sizeFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                        plpGlobalData?.aggregations?.categoryFilter?.buckets = data.aggregations?.categoryFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                        plpGlobalData?.aggregations?.genderFilter?.buckets = data.aggregations?.genderFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                        plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                    
                    plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                    
                case "designer":
                   
                        
                     
                     plpGlobalData?.aggregations?.colorFilter?.buckets = data.aggregations?.colorFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                     plpGlobalData?.aggregations?.sizeFilter?.buckets = data.aggregations?.sizeFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                      plpGlobalData?.aggregations?.categoryFilter?.buckets = data.aggregations?.categoryFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                    plpGlobalData?.aggregations?.genderFilter?.buckets = data.aggregations?.genderFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                     plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                                       
                     plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                   
                    
                    case "size":
                     plpGlobalData?.aggregations?.designerFilter?.buckets = data.aggregations?.designerFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.colorFilter?.buckets = data.aggregations?.colorFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.categoryFilter?.buckets = data.aggregations?.categoryFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.genderFilter?.buckets = data.aggregations?.genderFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                   plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                                       
                                       plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                    
                    case "category":
                     plpGlobalData?.aggregations?.designerFilter?.buckets = data.aggregations?.designerFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.sizeFilter?.buckets = data.aggregations?.sizeFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.colorFilter?.buckets = data.aggregations?.colorFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.genderFilter?.buckets = data.aggregations?.genderFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                    plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                                       
                                       plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                    
                    case "gender":
                    plpGlobalData?.aggregations?.designerFilter?.buckets = data.aggregations?.designerFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.sizeFilter?.buckets = data.aggregations?.sizeFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.categoryFilter?.buckets = data.aggregations?.categoryFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.colorFilter?.buckets = data.aggregations?.colorFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                     plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                                       
                                       plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                default:
                    
                     plpGlobalData?.aggregations?.colorFilter?.buckets = data.aggregations?.colorFilter?.buckets ?? [ColorFilter.BucketsList]()
                     plpGlobalData?.aggregations?.designerFilter?.buckets = data.aggregations?.designerFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.sizeFilter?.buckets = data.aggregations?.sizeFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.categoryFilter?.buckets = data.aggregations?.categoryFilter?.buckets ?? [ColorFilter.BucketsList]()
                                       
                                           plpGlobalData?.aggregations?.genderFilter?.buckets = data.aggregations?.genderFilter?.buckets ?? [ColorFilter.BucketsList]()
                    
                   plpGlobalData?.aggregations?.max_price?.value = data.aggregations?.max_price?.value
                                       
                                       plpGlobalData?.aggregations?.min_price?.value = data.aggregations?.min_price?.value
                }
                DispatchQueue.main.async {
                    let show = "show".localized
                    let results = "result".localized
                    self.btnShow.setTitle("\(show) \(data.hits?.total ?? 0) \(results)", for: .normal)
                }
                //print(self.newInData ?? default value)
                //              if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                //                self.btnShow.addTextSpacing(spacing: 1.5, color: "ffffff")
                //              }
                
            }
            
        }
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickClear(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "priceNm")
        UserDefaults.standard.set(nil, forKey: "colorNm")
        UserDefaults.standard.set(nil, forKey: "categoryNm")
        UserDefaults.standard.set(nil, forKey: "designNm")
        UserDefaults.standard.set(nil, forKey: "genderNm")
        UserDefaults.standard.set(nil, forKey: "sizeNm")
       // UserDefaults.standard.set(nil, forKey: "sortby")
        UserDefaults.standard.setValue(0, forKey: "filtercount")
         UserDefaults.standard.set( false , forKey: "sortCount")
        lblFilterCount.text = "\(UserDefaults.standard.value(forKey: "filtercount") ?? 0) \(filtersCunt)"
        showOrHideActiveFilters(aVal: 0)
        arrayColor.removeAll()
        arraySize.removeAll()
        arrayGender.removeAll()
        arrayCategory.removeAll()
        arrayDesign.removeAll()
        selectedData.removeAll()
        collectionView.isHidden = true
        collectionView.reloadData()
        btnClear.isUserInteractionEnabled = false
        btnClear.alpha = 0.5
        
        arrMust.removeAll()
//        for i in 0..<arrDataSort.count{
//            arrDataSort[i]["isSelected"] = false
//        }
        for j in 0..<arrDataFilter.count{
            arrDataFilter[j]["isSelected"] = false
        }
        tblSortBy.reloadData()
        tblFilterBy.reloadData()
       // strSelectedFilter = ""
        callPLP()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func onClickShow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblFilterBy{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterByCell.identifier) as? FilterByCell else {
                fatalError("Cell can't be dequeue")
            }
            var seprator = ""
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                seprator = ","
                cell.lbType.textAlignment = .right
            }
            else{
                seprator = "،"
                cell.lbType.textAlignment = .left
            }
            cell.lbType.text = ""
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                cell.lbType.font = UIFont(name: "Cairo-Light", size: cell.lbType.font.pointSize)

            }
            
            if arrDataFilter[indexPath.row]["label"] as? String ==
                "Color"{
                if arrayColor.count != 0{
                    var stringColors = ""
                    for i in 0..<arrayColor.count{

                        stringColors += "\(arrayColor[i])\(seprator)"
                        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                            cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                        }else{
                            cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                        }
                        

                    }
                    var str:String = " (\(arrayColor.count)) \(stringColors)"
                    str.remove(at: str.index(before: str.endIndex))
                    cell.lbType.text = str
                    
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = Common.sharedInstance.brandonLight(asize: 18)
                    }
                    
                }
                
                
                
            }else  if arrDataFilter[indexPath.row]["label"] as? String ==
                "Size"{
                if arraySize.count != 0{
                    var stringSize = ""
                    for i in 0..<arraySize.count{

                        stringSize += "\(arraySize[i])\(seprator)"
                       // cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)//BrandenFont.bold(with: 18.0)

                    }
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                    }else{
                        cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                    }
                     var str:String = " (\(arraySize.count)) \(stringSize)"
                                       str.remove(at: str.index(before: str.endIndex))
                                       cell.lbType.text = str
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                    }
                    
                }
                
            }else  if arrDataFilter[indexPath.row]["label"] as? String ==
                "Gender"{
                var stringGender = ""
                if arrayGender.count != 0{
                    for i in 0..<arrayGender.count{
                      stringGender += "\(arrayGender[i])\(seprator)"
                        //cell.lblFilter.font = Common.sharedInstance.brandonMedium(asize: 18)//BrandenFont.bold(with: 18.0)
                    }
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                    }else{
                        cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                    }
                    var str:String = " (\(arrayGender.count)) \(stringGender)"
                    str.remove(at: str.index(before: str.endIndex))
                    cell.lbType.text = str
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                    }
                    
                }
                
            }else  if arrDataFilter[indexPath.row]["label"] as? String ==
                "Designer"{
                var stringDesigner = ""
                if arrayDesign.count != 0{
                    for i in 0..<arrayDesign.count{

                        stringDesigner +=  "\(arrayDesign[i])\(seprator)"
                        //cell.lblFilter.font = Common.sharedInstance.brandonMedium(asize: 18)// BrandenFont.bold(with: 18.0)
                        

                    }
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                    }else{
                        cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                    }
                    var str:String = " (\(arrayDesign.count)) \(stringDesigner)"
                                       str.remove(at: str.index(before: str.endIndex))
                                       cell.lbType.text = str
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                    }
                    
                }
                
            }else  if arrDataFilter[indexPath.row]["label"] as? String ==
                "Category"{
                var stringCategory = ""
                if arrayCategory.count != 0{
                    for i in 0..<arrayCategory.count{

                        stringCategory +=  "\(arrayCategory[i])\(seprator)"
                        //cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)//BrandenFont.bold(with: 18.0)
                        

                    }
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                    }else{
                        cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                    }
                     var str:String = " (\(arrayCategory.count)) \(stringCategory)"
                                        str.remove(at: str.index(before: str.endIndex))
                                        cell.lbType.text = str
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                    }
                    
                }
                
            }else  if arrDataFilter[indexPath.row]["label"] as? String ==
                "Price"{
                if UserDefaults.standard.value(forKey: "priceNm") != nil{
                    
                    cell.lbType.text = "\(UserDefaults.standard.value(forKey: "priceNm") ?? "")"
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font =  UIFont(name: "Cairo-Bold", size: cell.lbType.font.pointSize)
                    }else{
                        cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)
                    }
                    //cell.lblFilter.font =  Common.sharedInstance.brandonMedium(asize: 18)//BrandenFont.bold(with: 18.0)
                }else{
                    if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                        cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                    }else{
                        cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                    }
                    
                }
                
            }
            else{
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    cell.lblFilter.font = UIFont(name: "Cairo-Light", size: cell.lblFilter.font.pointSize)

                }else{
                    cell.lblFilter.font = BrandenFont.thin(with: 18.0)
                }
                
            }
            if indexPath.row == arrDataFilter.count - 1 {
                cell.viewSeprator.isHidden = true
            }
            //cell.selectionStyle = .none
            let filterText = arrDataFilter[indexPath.row]["label"] as! String
            cell.lblFilter.text = filterText.localized
            let backgroundView = UIView()
            backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier) as? SortByCell else {
                fatalError("Cell can't be dequeue")
            }
            
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                cell.lblSort.font = UIFont(name: "Cairo-Light", size: cell.lblSort.font.pointSize)

            }
            
            //cell.selectionStyle = .none
            let sortbyName = arrDataSort[indexPath.row]["label"] as! String
            cell.lblSort.text = "\(sortbyName)".localized
            cell.btnClick.addTarget(self, action: #selector(onClickRadio(_:)), for: .touchUpInside)
            cell.btnClick.tag = indexPath.row
            
            if arrDataSort[indexPath.row]["isSelected"] as? Bool == true {
                UIView.transition(with: cell.btnRadio, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    cell.btnRadio.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
                    cell.lblSort.font = UIFont(name:"BrandonGrotesque-Medium", size: 18)
                    //cell.lblSort.font = BrandenFont.medium(with: 18.0)
                })
            }else{
                
                cell.btnRadio.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
                cell.lblSort.font =  UIFont(name:"BrandonGrotesque-Light", size: 18)
                //cell.lblSort.font = BrandenFont.thin(with: 18.0)
            }
            if indexPath.row == arrDataSort.count - 1 {
                cell.viewSeprator.isHidden = true
            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    
    
    @objc func onClickRadio(_ sender:UIButton){
        
        for i in 0..<arrDataSort.count{
            arrDataSort[i]["isSelected"] = false
        }
        arrDataSort[sender.tag]["isSelected"] = true
        
        dictSort = [String:Any]()
        UserDefaults.standard.set(arrDataSort[sender.tag]["label"], forKey: "sortby")
        UserDefaults.standard.set( true , forKey: "sortCount")
        callPLP()
        tblSortBy.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblFilterBy{
            return arrDataFilter.count
        }else{
            return  arrDataSort.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            
            self.constTblFilter.constant = self.tblFilterBy.contentSize.height
            self.tblFilterBy.layoutSubviews()
            self.constTblSort.constant = self.tblSortBy.contentSize.height
            self.tblSortBy.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSortBy{
            
        }else{
            if arrDataFilter[indexPath.row]["attribute_code"] as? String == "manufacturer"{
                var designArray = [[String:Any]]()
                let nextVC = DesignVC.storyboardInstance!
                
                
                if arrDataFilter[indexPath.row]["label"] as? String == ""{
                    for i in 0..<arrDataFilter.count{
                        if arrDataFilter[i]["attribute_code"]as? String == "manufacturer"{
                            designArray.append(arrDataFilter[i])
                        }
                    }
                }
                
                
                //  nextVC.designArray = designArray
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            else if arrDataFilter[indexPath.row]["attribute_code"] as? String == "price_view"{
                
                let nextVC = PriceVC.storyboardInstance!
                
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
                
            else if arrDataFilter[indexPath.row]["attribute_code"]as? String == "color"{
                var colorArray = [[String:Any]]()
                let nextVC = ColorsVC.storyboardInstance!
                
                if arrDataFilter[indexPath.row]["label"] as? String == "color"{
                    for i in 0..<arrDataFilter.count{
                        if arrDataFilter[i]["attribute_code"]as? String == "Size"{
                            colorArray.append(arrDataFilter[i])
                        }
                    }
                }
                
                nextVC.colorData = colorArray
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            else {
                
                let nextVC = SizeVC.storyboardInstance!
                
                nextVC.strgen = strGen
                nextVC.isCommingFromA2Z = isCommingFromA2Z
                nextVC.attribute_code = arrDataFilter[indexPath.row]["attribute_code"] as? String ?? ""
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
}

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        reloadMoreData(indexPath: indexPath)
//    }
//
//
//    func reloadMoreData(indexPath: IndexPath) {
//        if notificationList.count - 1 == indexPath.row &&
//            (Int(notificationObj!.pagination!.page) < notificationObj!.pagination!.numPages) {
//            self.getNotifications()
//        }
//    }




extension FilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveFilterCell.identifier, for: indexPath) as? ActiveFilterCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.btnClose.addTarget(self, action: #selector(onClickClose(_:)), for: .touchUpInside)
        cell.btnClose.tag = indexPath.row
        cell.lblFilter.text = selectedData[indexPath.row].localized
        
        return cell
        
    }
    
    @objc func onClickClose(_ sender:UIButton){
        if selectedData[sender.tag] == "Category"{
            UserDefaults.standard.set(nil, forKey: "categoryNm")
            arrayCategory.removeAll()
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.lvl_category"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
        }else if selectedData[sender.tag] == "Designer"{
            UserDefaults.standard.set(nil, forKey: "designNm")
            arrayDesign.removeAll()
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.manufacturer"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
        }else if selectedData[sender.tag] == "Gender"{
            UserDefaults.standard.set(nil, forKey: "genderNm")
            arrayGender.removeAll()
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.gender"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
        }else if selectedData[sender.tag] == "Size"{
            UserDefaults.standard.set(nil, forKey: "sizeNm")
            arraySize.removeAll()
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.size"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
        }else if selectedData[sender.tag] == "Color"{
            UserDefaults.standard.set(nil, forKey: "colorNm")
            arrayColor.removeAll()
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.color"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
        }
        else if selectedData[sender.tag] == "Price"{
            UserDefaults.standard.set(nil, forKey: "priceNm")
            arrayPrice.removeAll()
           
        }
        self.tblFilterBy.reloadData()
        selectedData.remove(at: sender.tag)
        UserDefaults.standard.setValue(selectedData.count, forKey: "filtercount")
        lblFilterCount.text = "\(UserDefaults.standard.value(forKey: "filtercount") ?? 0) \(filtersCunt)"
        if lblFilterCount.text == "1 Filters"{
         lblFilterCount.text = "1 Filter"
        }
        collectionView.reloadData()
        if selectedData.count == 0{
            self.collectionView.isHidden = true
        }
        showOrHideActiveFilters(aVal: selectedData.count)
        callPLP()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = selectedData[indexPath.row]
        let width = self.estimatedFrame(text: text, font: BrandenFont.regular(with: 17.0)).width
        return CGSize(width: width + 68, height: 45)
        //return CGSize(width: text.width(withConstrainedHeight: 45.0, font: UIFont(name: "BrandonGrotesque-Regular", size: 17.0)!) + 68, height: 45)
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedStringKey.font: font],
                                                   context: nil)
    }
    
    
    
}
extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
