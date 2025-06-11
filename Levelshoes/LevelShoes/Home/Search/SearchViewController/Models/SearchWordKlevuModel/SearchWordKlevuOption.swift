//
//  SearchWordKlevuOption.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuOption : NSObject, NSCoding{

    var count : Int!
    var isSelected : Bool!
    var name : String!
    var value : String!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        count = dictionary["count"] as? Int
        isSelected = dictionary["isSelected"] as? Bool
        name = dictionary["name"] as? String
        value = dictionary["value"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if count != nil{
            dictionary["count"] = count
        }
        if isSelected != nil{
            dictionary["isSelected"] = isSelected
        }
        if name != nil{
            dictionary["name"] = name
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        count = aDecoder.decodeObject(forKey: "count") as? Int
        isSelected = aDecoder.decodeObject(forKey: "isSelected") as? Bool
        name = aDecoder.decodeObject(forKey: "name") as? String
        value = aDecoder.decodeObject(forKey: "value") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if count != nil{
            aCoder.encode(count, forKey: "count")
        }
        if isSelected != nil{
            aCoder.encode(isSelected, forKey: "isSelected")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
    }
}
