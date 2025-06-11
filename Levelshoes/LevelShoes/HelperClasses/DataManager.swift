//
//  DataManager.swift
//  Talabtech
//
//  Created by NCT 24 on 19/05/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit


class onBoardingData {
    var _index = ""
    var _type = ""
    var _id = ""
    var _version = 0
    var found = false
    var _source : Source?
    
    required init(dictionary: [String:Any]) {
        _index = dictionary["_index"] as? String ?? ""
        _type = dictionary["_type"] as? String ?? ""
        _id = dictionary["_id"] as? String ?? ""
        _source = Source(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: ._source)))
        _version = dictionary["_version"] as? Int ?? 0
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self._index, forKey: "_index")
        dictionary.setValue(self._type, forKey: "_type")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self._version, forKey: "_version")
        dictionary.setValue(self.found, forKey: "found")
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
}


class Source {
    var version : String = ""
    var module_name : String = ""
    var date_updated : String = ""
    var introList: [IntroList] = [IntroList]()
    var onBoardingList: [IntroList] = [IntroList]()
    var countryList: [CountryList] = [CountryList]()
    var languageList: [CountryList] = [CountryList]()
    var category : Category?
    var ios : Ios?
    var filter_en : FilterEn?
     var filter_ar : FilterEn?
    var title = ""
    var identifier = ""
    var content = ""
    var version_no = ""
    var store_view_id = ""
    var id = 0
    var active = false
    var tsk = ""
    
    var introImage: String? {
        if introList.count > 1 {
            return introList[1].url
        } else if introList.count == 0 {
            return introList[0].url
        }
        return nil
    }
    
    var onboardingImage: String? {
        if onBoardingList.count > 1 {
            return onBoardingList[1].url
        } else if onBoardingList.count == 0 {
            return onBoardingList[0].url
        }
        return nil
    }
    
    required init(dictionary: [String:Any]) {
        version = dictionary["version"] as? String ?? ""
        module_name = dictionary["module_name"] as? String ?? ""
        date_updated = dictionary["date_updated"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        identifier = dictionary["identifier"] as? String ?? ""
        version_no = dictionary["version_no"] as? String ?? ""
        store_view_id = dictionary["store_view_id"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        active = dictionary["active"] as? Bool ?? false
        tsk = dictionary["tsk"] as? String ?? ""
        content = dictionary["content"] as? String ?? ""
        introList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .intro) ).map({IntroList(dic: $0 as? [String:Any] ?? [String:Any]())})
        countryList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .country) ).map({CountryList(dic: $0 as? [String:Any] ?? [String:Any]())})
        languageList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .language) ).map({CountryList(dic: $0 as? [String:Any] ?? [String:Any]())})
        onBoardingList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .onboarding) ).map({IntroList(dic: $0 as? [String:Any] ?? [String:Any]())})
        category = Category(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .categories)))
        ios = Ios(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .ios)))
        filter_en = FilterEn(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .filter_en)))
         filter_ar = FilterEn(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .filter_ar)))
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.version, forKey: "version")
        dictionary.setValue(self.module_name, forKey: "module_name")
        dictionary.setValue(self.date_updated, forKey: "date_updated")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.identifier, forKey: "identifier")
        dictionary.setValue(self.version_no, forKey: "version_no")
        dictionary.setValue(self.store_view_id, forKey: "store_view_id")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.active, forKey: "active")
        dictionary.setValue(self.active, forKey: "tsk")
        dictionary.setValue(self.content, forKey: "content")
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
    class IntroList
    {
        var type = ""
        var url = ""
        var status = "1"
        var updated = ""
        var logoUrl = ""
        var hexaColorCode = ""
        
        
        required init(dic: [String:Any]) {
            self.type = dic["type"] as? String ?? ""
            self.url = dic["url"] as? String ?? ""
            self.status = dic["status"] as? String ?? "1"
            self.updated = dic["updated"] as? String ?? ""
            self.logoUrl = dic["logo-url"] as? String ?? ""
            self.hexaColorCode = dic["foreground-color"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.type, forKey: "type")
            dictionary.setValue(self.url, forKey: "url")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.updated, forKey: "updated")
            dictionary.setValue(self.logoUrl, forKey: "logo-url")
            dictionary.setValue(self.hexaColorCode, forKey: "foreground-color")
            
            return dictionary as? [String:Any] ?? [String:Any]()
        }
    }
    
    class CountryList
    {
        var name = ""
        var storecode = ""
        var flag = ""
        var currency = ""
        
        required init(dic: [String:Any]) {
            self.name = dic["name"] as? String ?? ""
            self.storecode = dic["storecode"] as? String ?? ""
            self.flag = dic["flag"] as? String ?? ""
            self.currency = dic["currency"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.name, forKey: "name")
            dictionary.setValue(self.storecode, forKey: "storecode")
            dictionary.setValue(self.flag, forKey: "flag")
             dictionary.setValue(self.currency, forKey: "currency")
            return dictionary as? [String:Any] ?? [String:Any]()
            
        }
    }
    
}

//
//class AboutUsData{
//    
//    var module_name = ""
//    var title = ""
//    var subject = ""
//    var description = ""
//    var needhelp = ""
//    var storehours = ""
//    var storehourstime = ""
//    var address = ""
//    var guestservicehour = ""
//    var tollfree = ""
//    var image = ""
//    
//    
//    required init(dictionary: [String:Any]) {
//              
//        aws = Aws(dic: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .aws)))
//        }
//              
//          
//          
//          func dictionaryRepresentation() -> [String:Any] {
//             let dictionary = NSMutableDictionary()
//            
//              return dictionary as? [String:Any] ?? [String:Any]()
//          }
//}

class Ios{
    
    var aws : Aws?
    
    required init(dictionary: [String:Any]) {
              
        aws = Aws(dic: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .aws)))
        }
              
          
          
          func dictionaryRepresentation() -> [String:Any] {
             let dictionary = NSMutableDictionary()
            
              return dictionary as? [String:Any] ?? [String:Any]()
          }
}

class FilterEn{
    
   var data: [DataList] = [DataList]()
    var module_name = ""
    
    required init(dictionary: [String:Any]) {
              
        data = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({DataList(dic: $0 as? [String:Any] ?? [String:Any]())})
        self.module_name = dictionary["module_name"] as? String ?? ""
        }
              
          
          
          func dictionaryRepresentation() -> [String:Any] {
             let dictionary = NSMutableDictionary()
            dictionary.setValue(self.module_name, forKey: "module_name")
              return dictionary as? [String:Any] ?? [String:Any]()
          }
    
    class DataList
    {
       var sortby: [SortBy] = [SortBy]()
       var filterby: [SortBy] = [SortBy]()
        
        required init(dic: [String:Any]) {
            
           sortby = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .sortby) ).map({SortBy(dic: $0 as? [String:Any] ?? [String:Any]())})
            filterby = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .filterby) ).map({SortBy(dic: $0 as? [String:Any] ?? [String:Any]())})
                   }
        
        
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
          
            return dictionary as? [String:Any] ?? [String:Any]()
            
        }
        
        class SortBy{
            
            var label = ""
             var value = ""
             var sort = ""
             var sort_order = 0
            var attribute_code = ""
            var isSelected = false
            
             required init(dic: [String:Any]) {
                       self.label = dic["label"] as? String ?? ""
                       self.value = dic["value"] as? String ?? ""
                 self.sort = dic["sort"] as? String ?? ""
                self.isSelected = dic["sort"] as? Bool ?? false
                 self.sort_order = dic["sort_order"] as? Int ?? 0
                 self.attribute_code = dic["attribute_code"] as? String ?? ""
                   }
                   
                   func dictionaryRepresentation() -> [String:Any] {
                       let dictionary = NSMutableDictionary()
                       
                    dictionary.setValue(self.label, forKey: "label")
                    dictionary.setValue(self.isSelected, forKey: "isSelected")
                    dictionary.setValue(self.value, forKey: "value")
                    dictionary.setValue(self.sort, forKey: "sort")
                    dictionary.setValue(self.sort_order, forKey: "sort_order")
                    dictionary.setValue(self.attribute_code, forKey: "attribute_code")
                       return dictionary as? [String:Any] ?? [String:Any]()
                       
                   }
        }
    }
}

class Aws{
    
    var apikey = ""
    
     required init(dic: [String:Any]) {
               self.apikey = dic["apikey"] as? String ?? ""
              
           }
           
           func dictionaryRepresentation() -> [String:Any] {
               let dictionary = NSMutableDictionary()
               
               dictionary.setValue(self.apikey, forKey: "apikey")
               
               return dictionary as? [String:Any] ?? [String:Any]()
               
           }
}

class Category {
    var data: [DataList] = [DataList]()
    var name: [DataList] = [DataList]()
    
    required init(dictionary: [String:Any]) {
        data = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({DataList(dic: $0 as? [String:Any] ?? [String:Any]())})
        name = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .names) ).map({DataList(dic: $0 as? [String:Any] ?? [String:Any]())})
        
    }
    
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
    class DataList
    {
        var type = ""
        var image_url = ""
        var status = "1"
        var updated = ""
        var logoUrl = ""
        var label_color = ""
        var name = ""
        
        required init(dic: [String:Any]) {
            self.type = dic["type"] as? String ?? ""
            self.image_url = dic["image_url"] as? String ?? ""
            self.status = dic["status"] as? String ?? "1"
            self.updated = dic["updated"] as? String ?? ""
            self.logoUrl = dic["logo-url"] as? String ?? ""
            self.label_color = dic["lable-color"] as? String ?? ""
            self.name = dic["name"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.type, forKey: "type")
            dictionary.setValue(self.image_url, forKey: "image_url")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.updated, forKey: "updated")
            dictionary.setValue(self.logoUrl, forKey: "logo-url")
            dictionary.setValue(self.label_color, forKey: "label_color")
            dictionary.setValue(self.name, forKey: "name")
            return dictionary as? [String:Any] ?? [String:Any]()
        }
    }
    
}

class LandingPageData {
    var title = ""
    var identifier = false
    var id = ""
    var version = "0"
    var _sourceLanding : SourceLanding?
    
    
    required init(dictionary: [String:Any]) {
        title = dictionary["title"] as? String ?? ""
        identifier = dictionary["identifier"] as? Bool ?? false
        id = dictionary["id"] as? String ?? ""
        version = dictionary["version_no"] as? String ?? "0"
        //convert to json
        var jsonObj = [String:Any]()
        jsonObj["data"] = convertToDictionary(text: dictionary["content"] as? String ?? "")
       // jsonObj["data"] = convertToDictionary(text: dictionary["content"] as! String)
        _sourceLanding = SourceLanding(dictionary: (ResponseKey.fatchDataAsDictionary(res: jsonObj, valueOf: .data )))
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.identifier, forKey: "identifier")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.version, forKey: "version_no")
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
}


class Exclusives {
    var title : String = ""
    var subtitle : String = ""
    var category_ids : [Int]
    var product_ids : [Int]
    
    
    required init(dictionary: [String:Any]) {
        title = dictionary["title"] as? String ?? ""
        subtitle = dictionary["subtitle"] as? String ?? ""
        category_ids = dictionary["category_ids"] as? [Int] ?? [Int]()
        product_ids = dictionary["product_ids"] as? [Int] ?? [Int]()
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.subtitle, forKey: "subtitle")
        dictionary.setValue(self.category_ids, forKey: "category_ids")
        dictionary.setValue(self.product_ids, forKey: "product_ids")
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
    class CategoryList
    {
        var type = ""
        var image = ""
        var lab = ""
        var pos = 0
        
        
        required init(dic: [String:Any]) {
            self.type = dic["type"] as? String ?? ""
            self.image = dic["image"] as? String ?? ""
            self.lab = dic["lab"] as? String ?? ""
            self.pos = dic["pos"] as? Int ?? 0
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.type, forKey: "type")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.lab, forKey: "lab")
            dictionary.setValue(self.pos, forKey: "pos")
            
            return dictionary as? [String:Any] ?? [String:Any]()
        }
    }
}

class SourceLanding {
    var module : String = ""
    var dataList : [DataList] = [DataList]()
    
    required init(dictionary: [String:Any]) {
        module = dictionary["module"] as? String ?? ""
        
        dataList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({DataList(dic: $0 as! [String:Any])})
        
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.module, forKey: "module")
        
        return dictionary as! [String:Any]
    }
    
    class DataList
        
    {
        var box_type = ""
        var sort_order = ""
        var title = ""
        var subtitle = ""
        var category_id = 0
        var products : Products?
        var arraydata : [ArrayData] = [ArrayData]()
        
        required init(dic: [String:Any]) {
            self.box_type = dic["box_type"] as? String ?? ""
            self.sort_order = dic["sort_order"] as? String ?? ""
            self.title = dic["title"] as? String ?? ""
            self.subtitle = dic["subtitle"] as? String ?? ""
            self.category_id = dic["category_id"] as? Int ?? 14
            products = Products(dic: (ResponseKey.fatchDataAsDictionary(res: dic, valueOf: .products)))
            arraydata = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .data) ).map({ArrayData(dic: $0 as! [String:Any])})
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.box_type, forKey: "box_type")
            dictionary.setValue(self.sort_order, forKey: "sort_order")
            dictionary.setValue(self.title, forKey: "title")
            
            return dictionary as! [String:Any]
        }
        
        class ArrayData
            
        {
            var type = ""
            var url = ""
            var status = "1"
            var updated = ""
            var elements: [ElementList] = [ElementList]()
            
            required init(dic: [String:Any]) {
                self.type = dic["type"] as? String ?? ""
                self.url = dic["url"] as? String ?? ""
                self.status = dic["status"] as? String ?? "1"
                self.updated = dic["updated"] as? String ?? ""
                elements = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .elements) ).map({ElementList(dic: $0 as! [String:Any])})
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.type, forKey: "type")
                dictionary.setValue(self.url, forKey: "url")
                dictionary.setValue(self.status, forKey: "status")
                dictionary.setValue(self.updated, forKey: "updated")
                return dictionary as! [String:Any]
            }
            
            class ElementList
            {
                var type = ""
                var content = ""
                var background_color = ""
                var foreground_color = ""
                var background_image = ""
                var link = ""
                var category_id = 3
                
                
                required init(dic: [String:Any]) {
                    self.type = dic["type"] as? String ?? ""
                    self.content = dic["content"] as? String ?? ""
                    self.background_color = dic["background-color"] as? String ?? ""
                    self.foreground_color = dic["foreground-color"] as? String ?? ""
                    self.background_image = dic["background-image"] as? String ?? ""
                    self.link = dic["link"] as? String ?? ""
                   self.category_id = dic["category_id"] as? Int ?? 14
                 
                    
                }
                
                func dictionaryRepresentation() -> [String:Any] {
                    let dictionary = NSMutableDictionary()
                    
                    dictionary.setValue(self.type, forKey: "type")
                    dictionary.setValue(self.content, forKey: "content")
                    dictionary.setValue(self.background_color, forKey: "background-color")
                    dictionary.setValue(self.foreground_color, forKey: "foreground-color")
                    dictionary.setValue(self.background_image, forKey: "background-image")
                    dictionary.setValue(self.link, forKey: "link")
                    dictionary.setValue(self.category_id, forKey: "category_id")
                    return dictionary as! [String:Any]
                }
            }
            
        }
    }
    
    
    
    
    
}

class Products {
    var primary_vpn = [String]()
    
    required init(dic: [String:Any]) {
        self.primary_vpn = dic["primary_vpn"] as? [String] ?? [String]()
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.primary_vpn, forKey: "primary_vpn")
        return dictionary as! [String:Any]
    }
}



class NewInData {
    var took = 0
    var timed_out = false
    var _shards : Shards?
    var hits : Hits?
    var aggregations : Aggregations?
    
    init(dictionary: [String:Any]) {
        took = dictionary["total"] as? Int ?? 0
        timed_out = dictionary["timed_out"] as? Bool ?? false
        _shards = Shards(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: ._shards)))
        hits = Hits(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .hits)))
        aggregations = Aggregations(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .aggregations)))
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.took, forKey: "took")
        dictionary.setValue(self.timed_out, forKey: "timed_out")
        
        return dictionary as! [String:Any]
    }
    
}

class Aggregations {

var colorFilter : ColorFilter?
    var min_price : ColorFilter?
    var max_price : ColorFilter?
 var designerFilter : ColorFilter?
  var genderFilter : ColorFilter?
var categoryFilter : ColorFilter?
 var sizeFilter : ColorFilter?
 
 required init(dictionary: [String:Any]) {
     colorFilter = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .ColorFilter)))
     categoryFilter = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .CategoryFilter)))
    max_price = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .max_price)))
    min_price = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .min_price)))
     designerFilter = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .DesignerFilter)))
     sizeFilter = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .SizeFilter)))
      genderFilter = ColorFilter(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .GenderFilter)))
 }
 
 func dictionaryRepresentation() -> [String:Any] {
     let dictionary = NSMutableDictionary()
    
     return dictionary as! [String:Any]
 }
}


class ColorFilter {
 
     var buckets: [BucketsList] = [BucketsList]()
    var value : Double?
    
    required init(dictionary: [String:Any]) {
        value = dictionary["value"] as? Double ?? 0.0
         buckets = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .buckets)
            ).map({BucketsList(dic: $0 as! [String:Any])})
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.value, forKey: "value")
        return dictionary as! [String:Any]
    }
    
    class BucketsList
    {
        var key = 0
        var doc_count = 0
        
        
        
        required init(dic: [String:Any]) {
            self.key = dic["key"] as? Int ?? 0
            self.doc_count = dic["doc_count"] as? Int ?? 0
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.key, forKey: "key")
            dictionary.setValue(self.doc_count, forKey: "doc_count")
            
            return dictionary as! [String:Any]
        }
    }
    
}

class Shards {
    var total : Int = 0
    var successful : Int = 0
    var skipped : Int = 0
    var failed : Int = 0
    
    
    required init(dictionary: [String:Any]) {
        total = dictionary["total"] as? Int ?? 0
        successful = dictionary["successful"] as? Int ?? 0
        skipped = dictionary["skipped"] as? Int ?? 0
        failed = dictionary["failed"] as? Int ?? 0
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.total, forKey: "total")
        dictionary.setValue(self.successful, forKey: "successful")
        dictionary.setValue(self.skipped, forKey: "skipped")
        dictionary.setValue(self.failed, forKey: "failed")
        return dictionary as! [String:Any]
    }
    
}

class Hits {
    var total : Int = 0
    var max_score : Float = 0.0
    var hitsList: [HitsList] = [HitsList]()
    
    required init(dictionary: [String:Any]) {
        total = dictionary["total"] as? Int ?? 0
        max_score = dictionary["max_score"] as? Float ?? 0.0
        hitsList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .hits) ).map({HitsList(dic: $0 as! [String:Any])})
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.total, forKey: "total")
        dictionary.setValue(self.max_score, forKey: "max_score")
        
        return dictionary as! [String:Any]
    }
    
    class HitsList
    {
        var _index = ""
        var _type = ""
        var _id = ""
        var _score = 0.0
        var _source : Source?
        
        
        required init(dic: [String:Any]) {
            self._index = dic["_index"] as? String ?? ""
            self._type = dic["_type"] as? String ?? ""
            self._id = dic["_id"] as? String ?? ""
            self._score = dic["_score"] as? Double ?? 0.0
            _source = Source(dictionary: (ResponseKey.fatchDataAsDictionary(res: dic, valueOf: ._source)))
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self._index, forKey: "_index")
            dictionary.setValue(self._type, forKey: "_type")
            dictionary.setValue(self._id, forKey: "_id")
            dictionary.setValue(self._score, forKey: "_score")
            return dictionary as! [String:Any]
        }
    }
    
    
    
    class Source {
        var version : String = ""
        var module_name : String = ""
        var date_updated : String = ""
        var introList: [IntroList] = [IntroList]()
        var onBoardingList: [IntroList] = [IntroList]()
        var countryList: [CountryList] = [CountryList]()
        var languageList: [CountryList] = [CountryList]()
        var category : Category?
        var image = ""
        var attribute_code = ""
        var special_from_date = ""
        var special_to_date = ""
        var regular_price = 0.0
        var final_price = 0.0
        var final_price_string: String {
            return String(format: "%.0f", final_price)
        }
        var size = 0
        var price = 0.0
        var name = ""
        var id = 0
        var optionsList: [OptionsList] = [OptionsList]()
        var attribute_set_id = 0
        var type_id = ""
        var media_gallery : [MediaList] = [MediaList]()
        var isSelected = false
        var status = 0
        var rw_shoppingfeeds_skip_submit = 0
        var consignmentflag = 0
        var gender = 0
        var material = 0
        var subcategory = 0
        var manufacturer = 0
        var usagespecificity = 0
        var color = 0
        var zone = 0
        var lvl_category = 0
        var concessiontype = 0
        var visibility = 0
        var voucher = 0
        var lvl_concession_type = 0
        var meta_description = ""
        var meta_title = ""
        var small_image = ""
        var thumbnail = ""
        var image_label = ""
        var small_image_label = ""
        var thumbnail_label = ""
        var country_of_manufacture = ""
        var url_key = ""
        var gift_message_available = false
        var gift_wrapping_available = false
        var is_returnable = false
        var corename = ""
        var hscode = ""
        var primaryvpn = ""
        var styleoraclenumber = ""
        var weight = 0.0
        var description = ""
        var special_price = 0.0
        var short_description = ""
        var slug = ""
        var categoryList : [CategoryList] = [CategoryList]()
        var stock : Stock?
        var configurable_children : Array<Any>
        var configurable_childrenModel : [ConfigurableList] =  [ConfigurableList]()
        let configurableOptions: Array<Any>
        var sizeData :Array<Any>
        var tags : String = ""
        var sku : String = ""
        var title = ""
                  var identifier = ""
                  var content = ""
                  var version_no = ""
                  var store_view_id = ""
                  var active = false
                  var tsk = ""
        
        required init(dictionary: [String:Any]) {
            title = dictionary["title"] as? String ?? ""
            size = dictionary["size"] as? Int ?? 0
                       identifier = dictionary["identifier"] as? String ?? ""
                       version_no = dictionary["version_no"] as? String ?? ""
                       store_view_id = dictionary["store_view_id"] as? String ?? ""
                       id = dictionary["id"] as? Int ?? 0
                       active = dictionary["active"] as? Bool ?? false
                       tsk = dictionary["tsk"] as? String ?? ""
                       special_from_date = dictionary["special_from_date"] as? String ?? ""
                        special_to_date = dictionary["special_to_date"] as? String ?? ""
                        content = dictionary["content"] as? String ?? ""
            isSelected = dictionary["isSelected"] as? Bool ?? false
            status = dictionary["status"] as? Int ?? 0
            special_price = dictionary["special_price"] as? Double ?? 0.0
            configurable_children = dictionary["configurable_children"] as? Array ?? Array()
            configurable_childrenModel = dictionary["configurable_children"] as? Array ?? Array()
            configurableOptions = dictionary["configurable_options"] as? Array<Any> ?? Array<Any>()
            sizeData = dictionary["size_options"] as? Array ?? Array()
            tags = dictionary["badge_name"] as? String ?? ""
            rw_shoppingfeeds_skip_submit = dictionary["rw_shoppingfeeds_skip_submit"] as? Int ?? 0
            consignmentflag = dictionary["consignmentflag"] as? Int ?? 0
            gender = dictionary["gender"] as? Int ?? 0
            material = dictionary["material"] as? Int ?? 0
            subcategory = dictionary["subcategory"] as? Int ?? 0
            manufacturer = dictionary["manufacturer"] as? Int ?? 0
            usagespecificity = dictionary["usagespecificity"] as? Int ?? 0
            color = dictionary["color"] as? Int ?? 0
            zone = dictionary["zone"] as? Int ?? 0
            lvl_category = dictionary["lvl_category"] as? Int ?? 0
            concessiontype = dictionary["concessiontype"] as? Int ?? 0
            visibility = dictionary["visibility"] as? Int ?? 0
            lvl_concession_type = dictionary["lvl_concession_type"] as? Int ?? 0
            meta_title = dictionary["meta_title"] as? String ?? ""
            sku = dictionary["sku"] as? String ?? ""
            meta_description = dictionary["meta_description"] as? String ?? ""
            thumbnail = dictionary["thumbnail"] as? String ?? ""
            attribute_code = dictionary["attribute_code"] as? String ?? ""
            small_image = dictionary["small_image"] as? String ?? ""
            image_label = dictionary["image_label"] as? String ?? ""
            
            small_image_label = dictionary["small_image_label"] as? String ?? ""
            thumbnail_label = dictionary["thumbnail_label"] as? String ?? ""
            country_of_manufacture = dictionary["country_of_manufacture"] as? String ?? ""
            gift_message_available = dictionary["gift_message_available"] as? Bool ?? false
            gift_wrapping_available = dictionary["gift_wrapping_available"] as? Bool ?? false
            url_key = dictionary["url_key"] as? String ?? ""
            is_returnable = dictionary["meta_description"] as? Bool ?? false
            corename = dictionary["corename"] as? String ?? ""
            hscode = dictionary["hscode"] as? String ?? ""
            primaryvpn = dictionary["primaryvpn"] as? String ?? ""
            styleoraclenumber = dictionary["styleoraclenumber"] as? String ?? ""
            weight = dictionary["weight"] as? Double ?? 0.0
            description = dictionary["description"] as? String ?? ""
            short_description = dictionary["short_description"] as? String ?? ""
            url_key = dictionary["url_key"] as? String ?? ""
            version = dictionary["version"] as? String ?? ""
            module_name = dictionary["module_name"] as? String ?? ""
            date_updated = dictionary["date_updated"] as? String ?? ""
            introList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .intro) ).map({IntroList(dic: $0 as! [String:Any])})
            countryList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .country) ).map({CountryList(dic: $0 as? [String:Any] ?? [String:Any]())})
            languageList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .language) ).map({CountryList(dic: $0 as? [String:Any] ?? [String:Any]())})
            onBoardingList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .onboarding) ).map({IntroList(dic: $0 as? [String:Any] ?? [String:Any]())})
            category = Category(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .categories)))
            image = dictionary["image"] as? String ?? ""
            regular_price = dictionary["regular_price"] as? Double ?? 0.0
            final_price = Double(dictionary["final_price"] as? Double ?? 0.0)
            price = Double(dictionary["price"] as? Double ?? 0.0)
            name = dictionary["name"] as? String ?? ""
            id = dictionary["id"] as? Int ?? 0
            attribute_set_id = dictionary["attribute_set_id"] as? Int ?? 0
            type_id = dictionary["type_id"] as? String ?? ""
            optionsList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .options) ).map({OptionsList(dic: $0 as? [String:Any] ?? [String:Any]())})
            media_gallery = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .media_gallery) ).map({MediaList(dic: $0 as? [String:Any] ?? [String:Any]())})
            categoryList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .category) ).map({CategoryList(dic: $0 as? [String:Any] ?? [String:Any]())})
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.special_from_date, forKey: "special_from_date")
            dictionary.setValue(self.special_to_date, forKey: "special_to_date")
            dictionary.setValue(self.version, forKey: "version")
            dictionary.setValue(self.sizeData, forKey: "size_options")
            dictionary.setValue(self.tags, forKey: "badge_name")
            dictionary.setValue(self.sku, forKey: "sku")
            dictionary.setValue(self.configurable_children, forKey: "configurable_children")
            dictionary.setValue(self.module_name, forKey: "module_name")
            dictionary.setValue(self.attribute_code, forKey: "attribute_code")
            dictionary.setValue(self.date_updated, forKey: "date_updated")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.regular_price, forKey: "regular_price")
            dictionary.setValue(self.final_price, forKey: "final_price")
            dictionary.setValue(self.special_price, forKey: "special_price")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(self.size, forKey: "size")
            dictionary.setValue(self.name, forKey: "name")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.attribute_set_id, forKey: "attribute_set_id")
            dictionary.setValue(self.type_id, forKey: "type_id")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.rw_shoppingfeeds_skip_submit, forKey: "rw_shoppingfeeds_skip_submit")
            dictionary.setValue(self.consignmentflag, forKey: "consignmentflag")
            dictionary.setValue(self.gender, forKey: "gender")
            dictionary.setValue(self.material, forKey: "material")
            dictionary.setValue(self.subcategory, forKey: "subcategory")
            dictionary.setValue(self.manufacturer, forKey: "manufacturer")
            dictionary.setValue(self.usagespecificity, forKey: "usagespecificity")
            dictionary.setValue(self.color, forKey: "color")
            dictionary.setValue(self.zone, forKey: "zone")
            dictionary.setValue(self.lvl_category, forKey: "lvl_category")
            dictionary.setValue(self.concessiontype, forKey: "concessiontype")
            dictionary.setValue(self.visibility, forKey: "visibility")
            dictionary.setValue(self.lvl_concession_type, forKey: "lvl_concession_type")
            dictionary.setValue(self.meta_title, forKey: "meta_title")
            dictionary.setValue(self.meta_description, forKey: "meta_description")
            dictionary.setValue(self.thumbnail, forKey: "thumbnail")
            dictionary.setValue(self.small_image, forKey: "small_image")
            dictionary.setValue(self.image_label, forKey: "image_label")
            dictionary.setValue(self.thumbnail_label, forKey: "thumbnail_label")
            dictionary.setValue(self.url_key, forKey: "url_key")
            dictionary.setValue(self.small_image_label, forKey: "small_image_label")
            dictionary.setValue(self.gift_message_available, forKey: "gift_message_available")
            dictionary.setValue(self.gift_wrapping_available, forKey: "gift_wrapping_available")
            dictionary.setValue(self.country_of_manufacture, forKey: "country_of_manufacture")
            dictionary.setValue(self.is_returnable, forKey: "is_returnable")
            dictionary.setValue(self.corename, forKey: "corename")
            dictionary.setValue(self.hscode, forKey: "hscode")
            dictionary.setValue(self.primaryvpn, forKey: "primaryvpn")
            dictionary.setValue(self.styleoraclenumber, forKey: "styleoraclenumber")
            dictionary.setValue(self.weight, forKey: "weight")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.short_description, forKey: "short_description")
            dictionary.setValue(self.title, forKey: "title")
                       dictionary.setValue(self.identifier, forKey: "identifier")
                       dictionary.setValue(self.version_no, forKey: "version_no")
                       dictionary.setValue(self.store_view_id, forKey: "store_view_id")
                       dictionary.setValue(self.id, forKey: "id")
                       dictionary.setValue(self.active, forKey: "active")
                       dictionary.setValue(self.active, forKey: "tsk")
                       dictionary.setValue(self.content, forKey: "content")
            return dictionary as? [String:Any] ?? [String:Any]()
        }
       class ConfigurableList
        {
            var sku =  ""
            var final_price = 0.0
            var regular_price = 0.0
            var status = 0
            var in_html_sitemap = 0
            var use_in_crosslinking = 0
            var in_xml_sitemap = 0
            var rw_shoppingfeeds_skip_submit = 0
            var consignmentflag = 0
            var division = 0
        var manufacturer = 0
            var seasondesc = 513
            var color = 0
            var gender = 0
            var material = 0
            var usagespecificity = 0
            var visibility = 0
            var zone = 0
            var lvl_category = 0
            var size = 0
            var concessiontype = 0
            var lvl_concession_type = 0
            var tax_class_id = 0
            var meta_title = ""
            var meta_description =  ""
            var url_key = ""
            var msrp_display_actual_price_type = ""
            var gift_wrapping_available = false
            var is_returnable = false
            var hscode = ""
            var primaryvpn = ""
            var name = ""
            var styleoraclenumber = ""
            var country_of_manufacture = ""
            var gift_message_available = false
            var corename = ""
            var price = ""
            var special_price = 0.0
            var weight = 0.0
            var special_from_date = ""
            var description = ""
            var short_description = ""
            var is_free_product = false
            var tier_prices = [Float]()
            var id = 0
           
            required init(dic: [String:Any]) {
                self.sku = dic["sku"] as? String ?? ""
                self.final_price = Double(dic["final_price"] as? Double ?? 0.0)
                self.regular_price = Double(dic["regular_price"] as? Double ?? 0.0)
                
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.sku, forKey: "sku")
                dictionary.setValue(self.final_price, forKey: "final_price")
                dictionary.setValue(self.regular_price, forKey: "regular_price")
               
                
                
                return dictionary as? [String:Any] ?? [String:Any]()
            }
        }
        
        class CategoryList
        {
            var category_id = ""
            var name = ""
            var position = 0
            
            required init(dic: [String:Any]) {
                self.category_id = dic["category_id"] as? String ?? ""
                self.name = dic["name"] as? String ?? ""
                self.position = dic["lab"] as? Int ?? 0
                
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.category_id, forKey: "category_id")
                dictionary.setValue(self.name, forKey: "name")
                dictionary.setValue(self.position, forKey: "position")
                
                
                return dictionary as? [String:Any] ?? [String:Any]()
            }
        }
        
        class MediaList
        {
            var type = ""
            var image = ""
            var lab = ""
            var pos = 0
            
            
            required init(dic: [String:Any]) {
                self.type = dic["type"] as? String ?? ""
                self.image = dic["image"] as? String ?? ""
                self.lab = dic["lab"] as? String ?? ""
                self.pos = dic["pos"] as? Int ?? 0
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.type, forKey: "type")
                dictionary.setValue(self.image, forKey: "image")
                dictionary.setValue(self.lab, forKey: "lab")
                dictionary.setValue(self.pos, forKey: "pos")
                
                return dictionary as? [String:Any] ?? [String:Any]()
            }
        }
        
        class IntroList
        {
            var type = ""
            var url = ""
            var status = ""
            var updated = ""
            var logoUrl = ""
            var hexaColorCode = ""
            
            
            required init(dic: [String:Any]) {
                self.type = dic["type"] as? String ?? ""
                self.url = dic["url"] as? String ?? ""
                self.status = dic["status"] as? String ?? "1"
            
                self.updated = dic["updated"] as? String ?? ""
                self.logoUrl = dic["logo-url"] as? String ?? ""
                self.hexaColorCode = dic["foreground-color"] as? String ?? ""
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.type, forKey: "type")
                dictionary.setValue(self.url, forKey: "url")
                dictionary.setValue(self.status, forKey: "status")
                dictionary.setValue(self.updated, forKey: "updated")
                dictionary.setValue(self.logoUrl, forKey: "logo-url")
                dictionary.setValue(self.hexaColorCode, forKey: "foreground-color")
                
                return dictionary as? [String:Any]  ?? [String:Any]()
            }
        }
        
        class CountryList
        {
            var name = ""
            var storecode = ""
            
            
            required init(dic: [String:Any]) {
                self.name = dic["name"] as? String ?? ""
                self.storecode = dic["storecode"] as? String ?? ""
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.name, forKey: "name")
                dictionary.setValue(self.storecode, forKey: "storecode")
                return dictionary as! [String:Any] ?? [String:Any]()
            }
        }
        
    }
        
        class MediaList
        {
            var type = ""
            var image = ""
            var lab = ""
            var pos = 0
            
            
            required init(dic: [String:Any]) {
                self.type = dic["type"] as? String ?? ""
                self.image = dic["image"] as? String ?? ""
                self.lab = dic["lab"] as? String ?? ""
                self.pos = dic["pos"] as? Int ?? 0
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.type, forKey: "type")
                dictionary.setValue(self.image, forKey: "image")
                dictionary.setValue(self.lab, forKey: "lab")
                dictionary.setValue(self.pos, forKey: "pos")
                
                return dictionary as? [String:Any] ?? [String:Any]()
            }
        }
        
        class IntroList
        {
            var type = ""
            var url = ""
            var status = ""
            var updated = ""
            var logoUrl = ""
            var hexaColorCode = ""
            
            
            required init(dic: [String:Any]) {
                self.type = dic["type"] as? String ?? ""
                self.url = dic["url"] as? String ?? ""
                self.status = dic["status"] as? String ?? "1"
            
                self.updated = dic["updated"] as? String ?? ""
                self.logoUrl = dic["logo-url"] as? String ?? ""
                self.hexaColorCode = dic["foreground-color"] as? String ?? ""
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.type, forKey: "type")
                dictionary.setValue(self.url, forKey: "url")
                dictionary.setValue(self.status, forKey: "status")
                dictionary.setValue(self.updated, forKey: "updated")
                dictionary.setValue(self.logoUrl, forKey: "logo-url")
                dictionary.setValue(self.hexaColorCode, forKey: "foreground-color")
                
                return dictionary as? [String:Any]  ?? [String:Any]()
            }
        }
        
        class CountryList
        {
            var name = ""
            var storecode = ""
            
            
            required init(dic: [String:Any]) {
                self.name = dic["name"] as? String ?? ""
                self.storecode = dic["storecode"] as? String ?? ""
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(self.name, forKey: "name")
                dictionary.setValue(self.storecode, forKey: "storecode")
                return dictionary as! [String:Any] ?? [String:Any]()
            }
        }
        
    }


class OptionsList: NSObject, NSCoding
{


var swatch : Swatch?
var label = ""
var value = ""
var sort_order = 0
var isSelected = false

required init(dic: [String:Any]) {
    self.label = dic["label"] as? String ?? ""
    self.value = dic["value"] as? String ?? ""
    
     self.isSelected = dic["isSelected"] as? Bool ?? false
    
    self.sort_order = dic["sort_order"] as? Int ?? 0
    swatch = Swatch(dictionary: (ResponseKey.fatchDataAsDictionary(res: dic, valueOf: .swatch)))
    
}
init(ilabel: String, ivalue: String, isort_order: Int, iiselected:  Bool,iswatch: Swatch?){
    label = ilabel
    value = ivalue
    sort_order = isort_order
    isSelected = iiselected
    swatch = iswatch
    
   // print("------------------\(swatch)")
}
func encode(with coder: NSCoder) {
   coder.encode(self.label,forKey: "label")
   coder.encode(self.value,forKey: "value")
   coder.encode(self.sort_order,forKey: "sort_order")
  // coder.encode(self.swatch,forKey: "swatch")
  }
required convenience init?(coder: NSCoder) {
     let label = coder.decodeObject(forKey: "label") as? String ?? ""
    let value = coder.decodeObject(forKey: "value") as? String ?? ""
    let sort_order = coder.decodeObject(forKey: "sort_order") as? Int ?? 0
    
    let swatch =  coder.decodeObject(forKey: "swatch")
    self.init(ilabel: label,ivalue: value,isort_order: sort_order, iiselected: false,iswatch: swatch as? Swatch)
    
   }
func dictionaryRepresentation(with coder: NSCoder) -> [String:Any] {
    let dictionary = NSMutableDictionary()
     
    dictionary.setValue(self.label, forKey: "label")
     dictionary.setValue(self.isSelected, forKey: "isSelected")
    dictionary.setValue(self.value, forKey: "value")
    dictionary.setValue(self.sort_order, forKey: "sort_order")
    return dictionary as? [String:Any] ?? [String:Any]()
}
}


class Stock {
    var product_id = 0
    var item_id = 0
    var stock_id = 0
    var qty = 0.0
    var is_in_stock = false
    var is_qty_decimal = false
    var use_config_min_qty = false
    var min_qty = 0.0
    var use_config_min_sale_qty = false
    var min_sale_qty = 0.0
    var use_config_max_sale_qty = false
    var max_sale_qty = 0.0
    var use_config_notify_stock_qty = false
    var notify_stock_qty = 0.0
    var use_config_qty_increments = false
    var backorders = false
    var use_config_backorders = false
    var qty_increments = 0.0
    var use_config_enable_qty_inc = false
    var enable_qty_increments = false
    var use_config_manage_stock = false
    var manage_stock = false
    var stock_status = 0
    
    
    
    required init(dictionary: [String:Any]) {
        product_id = dictionary["product_id"] as? Int ?? 0
        item_id = dictionary["item_id"] as? Int ?? 0
        stock_id = dictionary["stock_id"] as? Int ?? 0
        qty = dictionary["qty"] as? Double ?? 0.0
        min_qty = dictionary["min_qty"] as? Double ?? 0.0
        min_sale_qty = dictionary["min_sale_qty"] as? Double ?? 0.0
        max_sale_qty = dictionary["max_sale_qty"] as? Double ?? 0.0
        notify_stock_qty = dictionary["notify_stock_qty"] as? Double ?? 0.0
        qty_increments = dictionary["qty_increments"] as? Double ?? 0.0
        stock_status = dictionary["stock_status"] as? Int ?? 0
        is_in_stock = dictionary["is_in_stock"] as? Bool ?? false
        is_qty_decimal = dictionary["is_qty_decimal"] as? Bool ?? false
        use_config_min_qty = dictionary["use_config_min_qty"] as? Bool ?? false
        use_config_max_sale_qty = dictionary["use_config_max_sale_qty"] as? Bool ?? false
        use_config_notify_stock_qty = dictionary["use_config_notify_stock_qty"] as? Bool ?? false
        use_config_qty_increments = dictionary["use_config_qty_increments"] as? Bool ?? false
        use_config_backorders = dictionary["use_config_backorders"] as? Bool ?? false
        backorders = dictionary["backorders"] as? Bool ?? false
        use_config_enable_qty_inc = dictionary["use_config_enable_qty_inc"] as? Bool ?? false
        enable_qty_increments = dictionary["enable_qty_increments"] as? Bool ?? false
        use_config_manage_stock = dictionary["use_config_manage_stock"] as? Bool ?? false
        manage_stock = dictionary["manage_stock"] as? Bool ?? false
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.item_id, forKey: "item_id")
        dictionary.setValue(self.stock_id, forKey: "stock_id")
        dictionary.setValue(self.qty, forKey: "qty")
        dictionary.setValue(self.min_qty, forKey: "min_qty")
        dictionary.setValue(self.min_sale_qty, forKey: "min_sale_qty")
        dictionary.setValue(self.max_sale_qty, forKey: "max_sale_qty")
        dictionary.setValue(self.notify_stock_qty, forKey: "notify_stock_qty")
        dictionary.setValue(self.qty_increments, forKey: "qty_increments")
        dictionary.setValue(self.stock_status, forKey: "stock_status")
        dictionary.setValue(self.is_in_stock, forKey: "is_in_stock")
        dictionary.setValue(self.is_qty_decimal, forKey: "is_qty_decimal")
        dictionary.setValue(self.use_config_min_qty, forKey: "use_config_min_qty")
        dictionary.setValue(self.use_config_max_sale_qty, forKey: "use_config_max_sale_qty")
        dictionary.setValue(self.use_config_notify_stock_qty, forKey: "use_config_notify_stock_qty")
        dictionary.setValue(self.use_config_qty_increments, forKey: "use_config_qty_increments")
        dictionary.setValue(self.use_config_backorders, forKey: "use_config_backorders")
        dictionary.setValue(self.backorders, forKey: "backorders")
        dictionary.setValue(self.use_config_enable_qty_inc, forKey: "use_config_enable_qty_inc")
        dictionary.setValue(self.enable_qty_increments, forKey: "enable_qty_increments")
        dictionary.setValue(self.use_config_manage_stock, forKey: "use_config_manage_stock")
        dictionary.setValue(self.manage_stock, forKey: "manage_stock")
        
        return dictionary as! [String:Any] ?? [String:Any]()
    }
    
}
class Swatch: NSCoding {

var type = 0
var value = ""



required init(dictionary: [String:Any]) {
    //print("===============\(dictionary)")
    type = dictionary["type"] as? Int ?? 0
    self.value = dictionary["value"] as? String ?? ""
    }
   
    

func dictionaryRepresentation() -> [String:Any] {
    let dictionary = NSMutableDictionary()
    dictionary.setValue(self.type, forKey: "type")
    dictionary.setValue(self.value, forKey: "value")
    return dictionary as? [String:Any] ?? [String:Any]()
}
init(itype: Int, ivalue: String) {

       type = itype
       value = ivalue
       
   }
required convenience init?(coder: NSCoder) {
         let type = coder.decodeObject(forKey: "type") as! Int
         let value = coder.decodeObject(forKey: "value") as! String
    self.init(itype: type, ivalue:value)
        
   }
   func encode(with coder: NSCoder) {
       coder.encode(type, forKey: "type")
       coder.encode(value, forKey: "value")
      
   }
}
class SearchData{
    var meta : Meta?
    var result: [ResultList] = [ResultList]()
    
    required init(dictionary: [String:Any]) {
        meta = Meta(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .meta)))
        result = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .result) ).map({ResultList(dic: $0 as? [String:Any] ?? [String:Any]())})
        
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
    
    
    class ResultList
    {
        var color = ""
        var gender = ""
        var lvl_category = ""
        var rating = ""
        var discount = ""
        var color_swatches = ""
        var hideGroupPrices = ""
        var itemGroupId = ""
        var lcManufacturer = ""
        var manufacturer = ""
        var freeShipping = ""
        var storeBaseCurrency = ""
        var price = ""
        var toPrice = ""
        var imageUrl = ""
        var inStock = ""
        var currency = ""
        var id = ""
        var imageHover = ""
        var sku = ""
        var startPrice = ""
        var image = ""
        var deliveryInfo = ""
        var hideAddToCart = ""
        var salePrice = ""
        var oldPrice = ""
        var swatches: Swatches?
        var weight = ""
        var klevu_category = ""
        var totalVariants = ""
        var groupPrices = ""
        var url = ""
        var size = ""
        var name = ""
        var shortDesc = ""
        var category = ""
        var typeOfRecord = ""
        
        required init(dic: [String:Any]) {
            self.color = dic["color"] as? String ?? ""
            if color == nil{
                color = ""
            }
            self.gender = dic["gender"] as? String ?? ""
            self.lvl_category = dic["lvl_category"] as? String ?? ""
            self.rating = dic["rating"] as? String ?? ""
            self.discount = dic["discount"] as? String ?? ""
            self.color_swatches = dic["color_swatches"] as? String ?? ""
            self.hideGroupPrices = dic["hideGroupPrices"] as? String ?? ""
            self.itemGroupId = dic["itemGroupId"] as? String ?? ""
            self.lcManufacturer = dic["lcManufacturer"] as? String ?? ""
            self.manufacturer = dic["manufacturer"] as? String ?? ""
            self.freeShipping = dic["freeShipping"] as? String ?? ""
            self.storeBaseCurrency = dic["storeBaseCurrency"] as? String ?? ""
            self.price = dic["price"] as? String ?? ""
            self.toPrice = dic["toPrice"] as? String ?? ""
            self.imageUrl = dic["imageUrl"] as? String ?? ""
            self.inStock = dic["inStock"] as? String ?? ""
            self.currency = dic["currency"] as? String ?? ""
            self.id = dic["id"] as? String ?? ""
            self.imageHover = dic["imageHover"] as? String ?? ""
            self.sku = dic["sku"] as? String ?? ""
            self.startPrice = dic["startPrice"] as? String ?? ""
            self.image = dic["image"] as? String ?? ""
            self.deliveryInfo = dic["deliveryInfo"] as?String ?? ""
            
            self.hideAddToCart = dic["hideAddToCart"] as? String ?? ""
            self.salePrice = dic["salePrice"] as? String ?? ""
            self.oldPrice = dic["oldPrice"] as? String ?? ""
            
            self.weight = dic["weight"] as? String ?? ""
            self.klevu_category = dic["klevu_category"] as? String ?? ""
            self.totalVariants = dic["totalVariants"] as? String ?? ""
            self.groupPrices = dic["groupPrices"] as? String ?? ""
            self.url = dic["url"] as? String ?? ""
            self.size = dic["size"] as? String ?? ""
            self.name = dic["name"] as?String ?? ""
            
            self.shortDesc = dic["shortDesc"] as? String ?? ""
            self.category = dic["category"] as? String ?? ""
            self.typeOfRecord = dic["typeOfRecord"] as? String ?? ""
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.color, forKey: "color")
            dictionary.setValue(self.gender, forKey: "gender")
            dictionary.setValue(self.lvl_category, forKey: "lvl_category")
            dictionary.setValue(self.rating, forKey: "rating")
            dictionary.setValue(self.discount, forKey: "discount")
            dictionary.setValue(self.color_swatches, forKey: "color_swatches")
            dictionary.setValue(self.hideGroupPrices, forKey: "hideGroupPrices")
            dictionary.setValue(self.itemGroupId, forKey: "itemGroupId")
            dictionary.setValue(self.lcManufacturer, forKey: "lcManufacturer")
            dictionary.setValue(self.manufacturer, forKey: "manufacturer")
            dictionary.setValue(self.freeShipping, forKey: "freeShipping")
            dictionary.setValue(self.storeBaseCurrency, forKey: "storeBaseCurrency")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(self.toPrice, forKey: "toPrice")
            dictionary.setValue(self.imageUrl, forKey: "imageUrl")
            dictionary.setValue(self.inStock, forKey: "inStock")
            dictionary.setValue(self.currency, forKey: "currency")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.imageHover, forKey: "imageHover")
            dictionary.setValue(self.sku, forKey: "sku")
            dictionary.setValue(self.startPrice, forKey: "startPrice")
            dictionary.setValue(self.oldPrice, forKey: "oldPrice")
            
            dictionary.setValue(self.weight, forKey: "weight")
            dictionary.setValue(self.klevu_category, forKey: "klevu_category")
            dictionary.setValue(self.totalVariants, forKey: "totalVariants")
            dictionary.setValue(self.groupPrices, forKey: "groupPrices")
            dictionary.setValue(self.url, forKey: "url")
            dictionary.setValue(self.size, forKey: "size")
            dictionary.setValue(self.name, forKey: "name")
            dictionary.setValue(self.shortDesc, forKey: "shortDesc")
            dictionary.setValue(self.category, forKey: "category")
            dictionary.setValue(self.typeOfRecord, forKey: "typeOfRecord")
            
            return dictionary as? [String:Any] ?? [String:Any]()
        }
    }
}




class Meta {
    var layoutId = ""
    var layoutType = ""
    var noOfResults = 0
    var paginationStartFrom = 0
    var powerdByLogo = ""
    var totalResultsFound = 0
    var typeOfQuery = ""
    var storeBaseCurrency = ""
    var notificationCode = 0
    
    
    required init(dictionary: [String:Any]) {
        layoutId = dictionary["layoutId"] as? String ?? ""
        layoutType = dictionary["layoutType"] as? String ?? ""
        noOfResults = dictionary["noOfResults"] as? Int ?? 0
        paginationStartFrom = dictionary["paginationStartFrom"] as? Int ?? 0
        powerdByLogo = dictionary["powerdByLogo"] as? String ?? ""
        totalResultsFound = dictionary["totalResultsFound"] as? Int ?? 0
        typeOfQuery = dictionary["typeOfQuery"] as? String ?? ""
        storeBaseCurrency = dictionary["storeBaseCurrency"] as? String ?? ""
        notificationCode = dictionary["notificationCode"] as? Int ?? 0
    }
    
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.layoutId, forKey: "layoutId")
        dictionary.setValue(self.noOfResults, forKey: "noOfResults")
        dictionary.setValue(self.noOfResults, forKey: "noOfResults")
        dictionary.setValue(self.paginationStartFrom, forKey: "paginationStartFrom")
        dictionary.setValue(self.powerdByLogo, forKey: "total")
        dictionary.setValue(self.totalResultsFound, forKey: "totalResultsFound")
        dictionary.setValue(self.typeOfQuery, forKey: "typeOfQuery")
        dictionary.setValue(self.storeBaseCurrency, forKey: "storeBaseCurrency")
        dictionary.setValue(self.notificationCode, forKey: "notificationCode")
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
}

class Swatches {
    //var result: [SwatchList] = [SwatchList]()
    var lowestPrice = ""
    var numberOfAdditionalVariants = ""
    
    required init(dictionary: [String:Any]) {
        lowestPrice = dictionary["lowestPrice"] as? String ?? ""
        numberOfAdditionalVariants = dictionary["numberOfAdditionalVariants"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.lowestPrice, forKey: "lowestPrice")
        dictionary.setValue(self.numberOfAdditionalVariants, forKey: "numberOfAdditionalVariants")
        
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
}





class ColorData {
    var took = 0
    var timed_out = false
    var _shards : Shards?
    var hits : Hits?
    
    required init(dictionary: [String:Any]) {
        took = dictionary["total"] as? Int ?? 0
        timed_out = dictionary["timed_out"] as? Bool ?? false
        _shards = Shards(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: ._shards)))
        hits = Hits(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .hits)))
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.took, forKey: "took")
        dictionary.setValue(self.timed_out, forKey: "timed_out")
        
        return dictionary as? [String:Any] ?? [String:Any]()
    }
    
}

class FilterData{

var _index = ""
   var _type = ""
   var _id = ""
   var _version = 0
   var found = false
   var _source : Source?

required init(dictionary: [String:Any]) {
       _index = dictionary["_index"] as? String ?? ""
       _type = dictionary["_type"] as? String ?? ""
       _id = dictionary["_id"] as? String ?? ""
       _source = Source(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: ._source)))
       _version = dictionary["_version"] as? Int ?? 0
       
   }
   
   func dictionaryRepresentation() -> [String:Any] {
       let dictionary = NSMutableDictionary()
       dictionary.setValue(self._index, forKey: "_index")
       dictionary.setValue(self._type, forKey: "_type")
       dictionary.setValue(self._id, forKey: "_id")
       dictionary.setValue(self._version, forKey: "_version")
       dictionary.setValue(self.found, forKey: "found")
       return dictionary as? [String:Any] ?? [String:Any]()
   }
}



class GiftWrapParam{
    var from = ""
       var to = ""
       var message = ""
        
     

    required init(dictionary: [String:Any]) {
           from = dictionary["from"] as? String ?? ""
           to = dictionary["to"] as? String ?? ""
           message = dictionary["message"] as? String ?? ""
          
           
       }
       
       func dictionaryRepresentation() -> [String:Any] {
           let dictionary = NSMutableDictionary()
           dictionary.setValue(self.from, forKey: "from")
           dictionary.setValue(self.to, forKey: "to")
           dictionary.setValue(self.message, forKey: "message")
         
           return dictionary as? [String:Any] ?? [String:Any]()
       }
}
