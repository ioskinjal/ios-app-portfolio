//
//  SearchCategoryRootClass.swift
//  Created on June 29, 2020

import Foundation


class SearchCategoryRootClass : NSObject, NSCoding{
    var sourceChildren = SearchCategoryChildrenDatum()
    var hitsData = SearchCategoryHit()
    var mainSource = [[SearchCategorySource]]()
    var shards : SearchCategoryShard!
    var hits : SearchCategoryHit!
    var timedOut : Bool!
    var took : Int!


    override init() {
        
        super.init()
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        timedOut = dictionary["timed_out"] as? Bool
        took = dictionary["took"] as? Int
        if let shardsData = dictionary["_shards"] as? [String:Any]{
            shards = SearchCategoryShard(fromDictionary: shardsData)
        }
        if let hitsData = dictionary["hits"] as? [String:Any]{
            hits = SearchCategoryHit(fromDictionary: hitsData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if timedOut != nil{
            dictionary["timed_out"] = timedOut
        }
        if took != nil{
            dictionary["took"] = took
        }
        if shards != nil{
            dictionary["shards"] = shards.toDictionary()
        }
        if hits != nil{
            dictionary["hits"] = hits.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        shards = aDecoder.decodeObject(forKey: "_shards") as? SearchCategoryShard
        hits = aDecoder.decodeObject(forKey: "hits") as? SearchCategoryHit
        timedOut = aDecoder.decodeObject(forKey: "timed_out") as? Bool
        took = aDecoder.decodeObject(forKey: "took") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if shards != nil{
            aCoder.encode(shards, forKey: "_shards")
        }
        if hits != nil{
            aCoder.encode(hits, forKey: "hits")
        }
        if timedOut != nil{
            aCoder.encode(timedOut, forKey: "timed_out")
        }
        if took != nil{
            aCoder.encode(took, forKey: "took")
        }
    }
}
