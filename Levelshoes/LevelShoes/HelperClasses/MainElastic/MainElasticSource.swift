//
//  MainElasticSource.swift
//  Created on June 27, 2020

import Foundation


class MainElasticSource : NSObject, NSCoding{
    
   
    var active : Bool!
    var content : String!
    var id : Int!
    var identifier : String!
    var title : String!
    var tsk : Int!
    
    override init() {
         super.init()
    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        active = dictionary["active"] as? Bool
        content = dictionary["content"] as? String
        id = dictionary["id"] as? Int
        identifier = dictionary["identifier"] as? String
        title = dictionary["title"] as? String
        tsk = dictionary["tsk"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if active != nil{
            dictionary["active"] = active
        }
        if content != nil{
            dictionary["content"] = content
        }
        if id != nil{
            dictionary["id"] = id
        }
        if identifier != nil{
            dictionary["identifier"] = identifier
        }
        if title != nil{
            dictionary["title"] = title
        }
        if tsk != nil{
            dictionary["tsk"] = tsk
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        active = aDecoder.decodeObject(forKey: "active") as? Bool
        content = aDecoder.decodeObject(forKey: "content") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        identifier = aDecoder.decodeObject(forKey: "identifier") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        tsk = aDecoder.decodeObject(forKey: "tsk") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if active != nil{
            aCoder.encode(active, forKey: "active")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if identifier != nil{
            aCoder.encode(identifier, forKey: "identifier")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if tsk != nil{
            aCoder.encode(tsk, forKey: "tsk")
        }
    }
}
