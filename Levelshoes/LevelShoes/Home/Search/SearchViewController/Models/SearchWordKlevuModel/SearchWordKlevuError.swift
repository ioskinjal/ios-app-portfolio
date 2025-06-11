//
//  SearchWordKlevuError.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuError : NSObject, NSCoding{

    var errorMessage : String!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        errorMessage = dictionary["errorMessage"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if errorMessage != nil{
            dictionary["errorMessage"] = errorMessage
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        errorMessage = aDecoder.decodeObject(forKey: "errorMessage") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if errorMessage != nil{
            aCoder.encode(errorMessage, forKey: "errorMessage")
        }
    }
}
