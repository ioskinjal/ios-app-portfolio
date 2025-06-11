//
//  ReadOnlyCustomAttribute.swift
//  Created on June 19, 2020

import Foundation


class ReadOnlyCustomAttribute : NSObject, NSCoding{
    
    var attributeCode : String!
    var value : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attributeCode = dictionary["attribute_code"] as? String
        value = dictionary["value"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if attributeCode != nil{
            dictionary["attribute_code"] = attributeCode
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
        attributeCode = aDecoder.decodeObject(forKey: "attribute_code") as? String
        value = aDecoder.decodeObject(forKey: "value") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if attributeCode != nil{
            aCoder.encode(attributeCode, forKey: "attribute_code")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
    }
}
