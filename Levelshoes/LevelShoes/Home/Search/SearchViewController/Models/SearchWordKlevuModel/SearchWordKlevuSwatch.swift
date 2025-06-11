//
//  SearchWordKlevuSwatch.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuSwatch : NSObject, NSCoding{

    var lowestPrice : String!
    var numberOfAdditionalVariants : String!
    var swatch : [AnyObject]!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        lowestPrice = dictionary["lowestPrice"] as? String
        numberOfAdditionalVariants = dictionary["numberOfAdditionalVariants"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if lowestPrice != nil{
            dictionary["lowestPrice"] = lowestPrice
        }
        if numberOfAdditionalVariants != nil{
            dictionary["numberOfAdditionalVariants"] = numberOfAdditionalVariants
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        lowestPrice = aDecoder.decodeObject(forKey: "lowestPrice") as? String
        numberOfAdditionalVariants = aDecoder.decodeObject(forKey: "numberOfAdditionalVariants") as? String
        swatch = aDecoder.decodeObject(forKey: "swatch") as? [AnyObject]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if lowestPrice != nil{
            aCoder.encode(lowestPrice, forKey: "lowestPrice")
        }
        if numberOfAdditionalVariants != nil{
            aCoder.encode(numberOfAdditionalVariants, forKey: "numberOfAdditionalVariants")
        }
        if swatch != nil{
            aCoder.encode(swatch, forKey: "swatch")
        }
    }
}
