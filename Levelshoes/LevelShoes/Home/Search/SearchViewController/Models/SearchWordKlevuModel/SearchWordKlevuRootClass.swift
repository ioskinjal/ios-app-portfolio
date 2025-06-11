//
//  SearchWordKlevuRootClass.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuRootClass : NSObject, NSCoding{

    var autoComplete : [AnyObject]!
    var categories : [AnyObject]!
    var error : SearchWordKlevuError!
    var filters : [SearchWordKlevuFilter]!
    var meta : SearchWordKlevuMeta!
    var pages : [AnyObject]!
    var popularProducts : [AnyObject]!
    var popularTerm : [AnyObject]!
    var price : SearchWordKlevuPrice!
    var ranges : [AnyObject]!
    var recentlyViewedProducts : [AnyObject]!
    var result : [SearchWordKlevuResult]!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let errorData = dictionary["error"] as? [String:Any]{
            error = SearchWordKlevuError(fromDictionary: errorData)
        }
        if let metaData = dictionary["meta"] as? [String:Any]{
            meta = SearchWordKlevuMeta(fromDictionary: metaData)
        }
        if let priceData = dictionary["price"] as? [String:Any]{
            price = SearchWordKlevuPrice(fromDictionary: priceData)
        }
        filters = [SearchWordKlevuFilter]()
        if let filtersArray = dictionary["filters"] as? [[String:Any]]{
            for dic in filtersArray{
                let value = SearchWordKlevuFilter(fromDictionary: dic)
                filters.append(value)
            }
        }
        result = [SearchWordKlevuResult]()
        if let resultArray = dictionary["result"] as? [[String:Any]]{
            for dic in resultArray{
                let value = SearchWordKlevuResult(fromDictionary: dic)
                result.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if error != nil{
            dictionary["error"] = error.toDictionary()
        }
        if meta != nil{
            dictionary["meta"] = meta.toDictionary()
        }
        if price != nil{
            dictionary["price"] = price.toDictionary()
        }
        if filters != nil{
            var dictionaryElements = [[String:Any]]()
            for filtersElement in filters {
                dictionaryElements.append(filtersElement.toDictionary())
            }
            dictionary["filters"] = dictionaryElements
        }
        if result != nil{
            var dictionaryElements = [[String:Any]]()
            for resultElement in result {
                dictionaryElements.append(resultElement.toDictionary())
            }
            dictionary["result"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        autoComplete = aDecoder.decodeObject(forKey: "autoComplete") as? [AnyObject]
        categories = aDecoder.decodeObject(forKey: "categories") as? [AnyObject]
        error = aDecoder.decodeObject(forKey: "error") as? SearchWordKlevuError
        filters = aDecoder.decodeObject(forKey: "filters") as? [SearchWordKlevuFilter]
        meta = aDecoder.decodeObject(forKey: "meta") as? SearchWordKlevuMeta
        pages = aDecoder.decodeObject(forKey: "pages") as? [AnyObject]
        popularProducts = aDecoder.decodeObject(forKey: "popularProducts") as? [AnyObject]
        popularTerm = aDecoder.decodeObject(forKey: "popularTerm") as? [AnyObject]
        price = aDecoder.decodeObject(forKey: "price") as? SearchWordKlevuPrice
        ranges = aDecoder.decodeObject(forKey: "ranges") as? [AnyObject]
        recentlyViewedProducts = aDecoder.decodeObject(forKey: "recentlyViewedProducts") as? [AnyObject]
        result = aDecoder.decodeObject(forKey: "result") as? [SearchWordKlevuResult]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if autoComplete != nil{
            aCoder.encode(autoComplete, forKey: "autoComplete")
        }
        if categories != nil{
            aCoder.encode(categories, forKey: "categories")
        }
        if error != nil{
            aCoder.encode(error, forKey: "error")
        }
        if filters != nil{
            aCoder.encode(filters, forKey: "filters")
        }
        if meta != nil{
            aCoder.encode(meta, forKey: "meta")
        }
        if pages != nil{
            aCoder.encode(pages, forKey: "pages")
        }
        if popularProducts != nil{
            aCoder.encode(popularProducts, forKey: "popularProducts")
        }
        if popularTerm != nil{
            aCoder.encode(popularTerm, forKey: "popularTerm")
        }
        if price != nil{
            aCoder.encode(price, forKey: "price")
        }
        if ranges != nil{
            aCoder.encode(ranges, forKey: "ranges")
        }
        if recentlyViewedProducts != nil{
            aCoder.encode(recentlyViewedProducts, forKey: "recentlyViewedProducts")
        }
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }
    }
}
