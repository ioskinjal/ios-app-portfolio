//
//  SearchHit.swift
//  Created on June 29, 2020

import Foundation


class SearchHit : NSObject, NSCoding{

    var id : String!
    var index : String!
    var score : Int!
    var source : SearchSource!
    var type : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    
    override init() {
           
           super.init()
       }
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        index = dictionary["_index"] as? String
        score = dictionary["_score"] as? Int
        type = dictionary["_type"] as? String
        if let sourceData = dictionary["_source"] as? [String:Any]{
            source = SearchSource(fromDictionary: sourceData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if index != nil{
            dictionary["_index"] = index
        }
        if score != nil{
            dictionary["_score"] = score
        }
        if type != nil{
            dictionary["_type"] = type
        }
        if source != nil{
            dictionary["source"] = source.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "_id") as? String
        index = aDecoder.decodeObject(forKey: "_index") as? String
        score = aDecoder.decodeObject(forKey: "_score") as? Int
        source = aDecoder.decodeObject(forKey: "_source") as? SearchSource
        type = aDecoder.decodeObject(forKey: "_type") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if index != nil{
            aCoder.encode(index, forKey: "_index")
        }
        if score != nil{
            aCoder.encode(score, forKey: "_score")
        }
        if source != nil{
            aCoder.encode(source, forKey: "_source")
        }
        if type != nil{
            aCoder.encode(type, forKey: "_type")
        }
    }
}
