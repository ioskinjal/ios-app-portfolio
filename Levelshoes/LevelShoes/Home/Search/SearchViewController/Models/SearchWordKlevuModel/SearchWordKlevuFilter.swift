//
//  SearchWordKlevuFilter.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuFilter : NSObject, NSCoding{

    var key : String!
    var label : String!
    var options : [SearchWordKlevuOption]!
    var type : String!
    
    override init() {
           
           super.init()
       }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        key = dictionary["key"] as? String
        label = dictionary["label"] as? String
        type = dictionary["type"] as? String
        options = [SearchWordKlevuOption]()
        if let optionsArray = dictionary["options"] as? [[String:Any]]{
            for dic in optionsArray{
                let value = SearchWordKlevuOption(fromDictionary: dic)
                options.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if key != nil{
            dictionary["key"] = key
        }
        if label != nil{
            dictionary["label"] = label
        }
        if type != nil{
            dictionary["type"] = type
        }
        if options != nil{
            var dictionaryElements = [[String:Any]]()
            for optionsElement in options {
                dictionaryElements.append(optionsElement.toDictionary())
            }
            dictionary["options"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        key = aDecoder.decodeObject(forKey: "key") as? String
        label = aDecoder.decodeObject(forKey: "label") as? String
        options = aDecoder.decodeObject(forKey: "options") as? [SearchWordKlevuOption]
        type = aDecoder.decodeObject(forKey: "type") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if key != nil{
            aCoder.encode(key, forKey: "key")
        }
        if label != nil{
            aCoder.encode(label, forKey: "label")
        }
        if options != nil{
            aCoder.encode(options, forKey: "options")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
    }
}
