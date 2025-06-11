//
//  SearchWordKlevuMeta.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuMeta : NSObject, NSCoding{

    var layoutId : String!
    var layoutType : String!
    var noOfResults : Int!
    var notificationCode : Int!
    var paginationStartFrom : Int!
    var powerdByLogo : String!
    var storeBaseCurrency : String!
    var term : String!
    var totalResultsFound : Int!
    var typeOfQuery : String!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        layoutId = dictionary["layoutId"] as? String
        layoutType = dictionary["layoutType"] as? String
        noOfResults = dictionary["noOfResults"] as? Int
        notificationCode = dictionary["notificationCode"] as? Int
        paginationStartFrom = dictionary["paginationStartFrom"] as? Int
        powerdByLogo = dictionary["powerdByLogo"] as? String
        storeBaseCurrency = dictionary["storeBaseCurrency"] as? String
        term = dictionary["term"] as? String
        totalResultsFound = dictionary["totalResultsFound"] as? Int
        typeOfQuery = dictionary["typeOfQuery"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if layoutId != nil{
            dictionary["layoutId"] = layoutId
        }
        if layoutType != nil{
            dictionary["layoutType"] = layoutType
        }
        if noOfResults != nil{
            dictionary["noOfResults"] = noOfResults
        }
        if notificationCode != nil{
            dictionary["notificationCode"] = notificationCode
        }
        if paginationStartFrom != nil{
            dictionary["paginationStartFrom"] = paginationStartFrom
        }
        if powerdByLogo != nil{
            dictionary["powerdByLogo"] = powerdByLogo
        }
        if storeBaseCurrency != nil{
            dictionary["storeBaseCurrency"] = storeBaseCurrency
        }
        if term != nil{
            dictionary["term"] = term
        }
        if totalResultsFound != nil{
            dictionary["totalResultsFound"] = totalResultsFound
        }
        if typeOfQuery != nil{
            dictionary["typeOfQuery"] = typeOfQuery
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        layoutId = aDecoder.decodeObject(forKey: "layoutId") as? String
        layoutType = aDecoder.decodeObject(forKey: "layoutType") as? String
        noOfResults = aDecoder.decodeObject(forKey: "noOfResults") as? Int
        notificationCode = aDecoder.decodeObject(forKey: "notificationCode") as? Int
        paginationStartFrom = aDecoder.decodeObject(forKey: "paginationStartFrom") as? Int
        powerdByLogo = aDecoder.decodeObject(forKey: "powerdByLogo") as? String
        storeBaseCurrency = aDecoder.decodeObject(forKey: "storeBaseCurrency") as? String
        term = aDecoder.decodeObject(forKey: "term") as? String
        totalResultsFound = aDecoder.decodeObject(forKey: "totalResultsFound") as? Int
        typeOfQuery = aDecoder.decodeObject(forKey: "typeOfQuery") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if layoutId != nil{
            aCoder.encode(layoutId, forKey: "layoutId")
        }
        if layoutType != nil{
            aCoder.encode(layoutType, forKey: "layoutType")
        }
        if noOfResults != nil{
            aCoder.encode(noOfResults, forKey: "noOfResults")
        }
        if notificationCode != nil{
            aCoder.encode(notificationCode, forKey: "notificationCode")
        }
        if paginationStartFrom != nil{
            aCoder.encode(paginationStartFrom, forKey: "paginationStartFrom")
        }
        if powerdByLogo != nil{
            aCoder.encode(powerdByLogo, forKey: "powerdByLogo")
        }
        if storeBaseCurrency != nil{
            aCoder.encode(storeBaseCurrency, forKey: "storeBaseCurrency")
        }
        if term != nil{
            aCoder.encode(term, forKey: "term")
        }
        if totalResultsFound != nil{
            aCoder.encode(totalResultsFound, forKey: "totalResultsFound")
        }
        if typeOfQuery != nil{
            aCoder.encode(typeOfQuery, forKey: "typeOfQuery")
        }
    }
}
