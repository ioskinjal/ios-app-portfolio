//
//  SearchShard.swift
//  Created on June 29, 2020

import Foundation


class SearchShard : NSObject, NSCoding{

    var failed : Int!
    var skipped : Int!
    var successful : Int!
    var total : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    override init() {
           
           super.init()
       }
    
    init(fromDictionary dictionary: [String:Any]){
        failed = dictionary["failed"] as? Int
        skipped = dictionary["skipped"] as? Int
        successful = dictionary["successful"] as? Int
        total = dictionary["total"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if failed != nil{
            dictionary["failed"] = failed
        }
        if skipped != nil{
            dictionary["skipped"] = skipped
        }
        if successful != nil{
            dictionary["successful"] = successful
        }
        if total != nil{
            dictionary["total"] = total
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        failed = aDecoder.decodeObject(forKey: "failed") as? Int
        skipped = aDecoder.decodeObject(forKey: "skipped") as? Int
        successful = aDecoder.decodeObject(forKey: "successful") as? Int
        total = aDecoder.decodeObject(forKey: "total") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if failed != nil{
            aCoder.encode(failed, forKey: "failed")
        }
        if skipped != nil{
            aCoder.encode(skipped, forKey: "skipped")
        }
        if successful != nil{
            aCoder.encode(successful, forKey: "successful")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
    }
}
