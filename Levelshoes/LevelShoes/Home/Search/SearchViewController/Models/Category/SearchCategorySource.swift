//
//  SearchCategorySource.swift
//  Created on June 29, 2020

import Foundation


class SearchCategorySource : NSObject, NSCoding{
    var dataChildren = SearchCategoryChildrenDatum()
    var childrenData : [SearchCategoryChildrenDatum]!
    var name : String!

    override init() {
        
        super.init()
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        childrenData = [SearchCategoryChildrenDatum]()
        if let childrenDataArray = dictionary["children_data"] as? [[String:Any]]{
            for dic in childrenDataArray{
                let value = SearchCategoryChildrenDatum(fromDictionary: dic)
                childrenData.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if childrenData != nil{
            var dictionaryElements = [[String:Any]]()
            for childrenDataElement in childrenData {
                dictionaryElements.append(childrenDataElement.toDictionary())
            }
            dictionary["childrenData"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        childrenData = aDecoder.decodeObject(forKey: "children_data") as? [SearchCategoryChildrenDatum]
        name = aDecoder.decodeObject(forKey: "name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if childrenData != nil{
            aCoder.encode(childrenData, forKey: "children_data")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
    }
}
