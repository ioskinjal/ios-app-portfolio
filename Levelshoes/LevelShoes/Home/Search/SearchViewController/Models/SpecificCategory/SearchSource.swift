//
//  SearchSource.swift
//  Created on June 29, 2020

import Foundation


class SearchSource : NSObject, NSCoding{

    var childrenData : [SearchChildrenDatum]!
    var id : Int!
    var name : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    override init() {
           
           super.init()
       }
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        childrenData = [SearchChildrenDatum]()
        if let childrenDataArray = dictionary["children_data"] as? [[String:Any]]{
            for dic in childrenDataArray{
                let value = SearchChildrenDatum(fromDictionary: dic)
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
        if id != nil{
            dictionary["id"] = id
        }
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
        childrenData = aDecoder.decodeObject(forKey: "children_data") as? [SearchChildrenDatum]
        id = aDecoder.decodeObject(forKey: "id") as? Int
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
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
    }
}
