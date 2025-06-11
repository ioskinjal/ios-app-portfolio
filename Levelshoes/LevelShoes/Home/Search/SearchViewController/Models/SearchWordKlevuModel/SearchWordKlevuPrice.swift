//
//  SearchWordKlevuPrice.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuPrice : NSObject, NSCoding{

    var end : String!
    var max : String!
    var min : String!
    var start : String!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        end = dictionary["end"] as? String
        max = dictionary["max"] as? String
        min = dictionary["min"] as? String
        start = dictionary["start"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if end != nil{
            dictionary["end"] = end
        }
        if max != nil{
            dictionary["max"] = max
        }
        if min != nil{
            dictionary["min"] = min
        }
        if start != nil{
            dictionary["start"] = start
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        end = aDecoder.decodeObject(forKey: "end") as? String
        max = aDecoder.decodeObject(forKey: "max") as? String
        min = aDecoder.decodeObject(forKey: "min") as? String
        start = aDecoder.decodeObject(forKey: "start") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if end != nil{
            aCoder.encode(end, forKey: "end")
        }
        if max != nil{
            aCoder.encode(max, forKey: "max")
        }
        if min != nil{
            aCoder.encode(min, forKey: "min")
        }
        if start != nil{
            aCoder.encode(start, forKey: "start")
        }
    }
}
