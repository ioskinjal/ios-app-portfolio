//
//  ReadOnlyRootClass.swift
//  Created on June 19, 2020

import Foundation


class ReadOnlyRootClass : NSObject, NSCoding{
    
    var addresses : [AnyObject]!
    var createdAt : String!
    var createdIn : String!
    var customAttributes : [ReadOnlyCustomAttribute]!
    var disableAutoGroupChange : Int!
    var email : String!
    var firstname : String!
    var groupId : Int!
    var id : Int!
    var lastname : String!
    var storeId : Int!
    var updatedAt : String!
    var websiteId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        createdIn = dictionary["created_in"] as? String
        disableAutoGroupChange = dictionary["disable_auto_group_change"] as? Int
        email = dictionary["email"] as? String
        firstname = dictionary["firstname"] as? String
        groupId = dictionary["group_id"] as? Int
        id = dictionary["id"] as? Int
        lastname = dictionary["lastname"] as? String
        storeId = dictionary["store_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        websiteId = dictionary["website_id"] as? Int
        customAttributes = [ReadOnlyCustomAttribute]()
        if let customAttributesArray = dictionary["custom_attributes"] as? [[String:Any]]{
            for dic in customAttributesArray{
                let value = ReadOnlyCustomAttribute(fromDictionary: dic)
                customAttributes.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if createdIn != nil{
            dictionary["created_in"] = createdIn
        }
        if disableAutoGroupChange != nil{
            dictionary["disable_auto_group_change"] = disableAutoGroupChange
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstname != nil{
            dictionary["firstname"] = firstname
        }
        if groupId != nil{
            dictionary["group_id"] = groupId
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastname != nil{
            dictionary["lastname"] = lastname
        }
        if storeId != nil{
            dictionary["store_id"] = storeId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if websiteId != nil{
            dictionary["website_id"] = websiteId
        }
        if customAttributes != nil{
            var dictionaryElements = [[String:Any]]()
            for customAttributesElement in customAttributes {
                dictionaryElements.append(customAttributesElement.toDictionary())
            }
            dictionary["customAttributes"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        addresses = aDecoder.decodeObject(forKey: "addresses") as? [AnyObject]
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        createdIn = aDecoder.decodeObject(forKey: "created_in") as? String
        customAttributes = aDecoder.decodeObject(forKey: "custom_attributes") as? [ReadOnlyCustomAttribute]
        disableAutoGroupChange = aDecoder.decodeObject(forKey: "disable_auto_group_change") as? Int
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstname = aDecoder.decodeObject(forKey: "firstname") as? String
        groupId = aDecoder.decodeObject(forKey: "group_id") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastname = aDecoder.decodeObject(forKey: "lastname") as? String
        storeId = aDecoder.decodeObject(forKey: "store_id") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        websiteId = aDecoder.decodeObject(forKey: "website_id") as? Int
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if addresses != nil{
            aCoder.encode(addresses, forKey: "addresses")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if createdIn != nil{
            aCoder.encode(createdIn, forKey: "created_in")
        }
        if customAttributes != nil{
            aCoder.encode(customAttributes, forKey: "custom_attributes")
        }
        if disableAutoGroupChange != nil{
            aCoder.encode(disableAutoGroupChange, forKey: "disable_auto_group_change")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstname != nil{
            aCoder.encode(firstname, forKey: "firstname")
        }
        if groupId != nil{
            aCoder.encode(groupId, forKey: "group_id")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastname != nil{
            aCoder.encode(lastname, forKey: "lastname")
        }
        if storeId != nil{
            aCoder.encode(storeId, forKey: "store_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if websiteId != nil{
            aCoder.encode(websiteId, forKey: "website_id")
        }
    }
}
