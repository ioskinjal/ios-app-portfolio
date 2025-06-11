//
//  SearchWordKlevuResult.swift
//  Created on July 2, 2020

import Foundation


class SearchWordKlevuResult : NSObject, NSCoding{

    var category : String!
    var color : String!
    var colorSwatches : String!
    var currency : String!
    var deliveryInfo : String!
    var discount : String!
    var freeShipping : String!
    var gender : String!
    var groupPrices : String!
    var hideAddToCart : String!
    var hideGroupPrices : String!
    var id : String!
    var image : String!
    var imageHover : String!
    var imageUrl : String!
    var inStock : String!
    var itemGroupId : String!
    var klevuCategory : String!
    var lcManufacturer : String!
    var lvlCategory : String!
    var manufacturer : String!
    var name : String!
    var oldPrice : String!
    var price : String!
    var rating : String!
    var salePrice : String!
    var shortDesc : String!
    var size : String!
    var sku : String!
    var startPrice : String!
    var storeBaseCurrency : String!
    var swatches : SearchWordKlevuSwatch!
    var toPrice : String!
    var totalVariants : String!
    var typeOfRecord : String!
    var url : String!
    var weight : String!

    override init() {
           
           super.init()
       }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        category = dictionary["category"] as? String
        color = dictionary["color"] as? String
        colorSwatches = dictionary["color_swatches"] as? String
        currency = dictionary["currency"] as? String
        deliveryInfo = dictionary["deliveryInfo"] as? String
        discount = dictionary["discount"] as? String
        freeShipping = dictionary["freeShipping"] as? String
        gender = dictionary["gender"] as? String
        groupPrices = dictionary["groupPrices"] as? String
        hideAddToCart = dictionary["hideAddToCart"] as? String
        hideGroupPrices = dictionary["hideGroupPrices"] as? String
        id = dictionary["id"] as? String
        image = dictionary["image"] as? String
        imageHover = dictionary["imageHover"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        inStock = dictionary["inStock"] as? String
        itemGroupId = dictionary["itemGroupId"] as? String
        klevuCategory = dictionary["klevu_category"] as? String
        lcManufacturer = dictionary["lcManufacturer"] as? String
        lvlCategory = dictionary["lvl_category"] as? String
        manufacturer = dictionary["manufacturer"] as? String
        name = dictionary["name"] as? String
        oldPrice = dictionary["oldPrice"] as? String
        price = dictionary["price"] as? String
        rating = dictionary["rating"] as? String
        salePrice = dictionary["salePrice"] as? String
        shortDesc = dictionary["shortDesc"] as? String
        size = dictionary["size"] as? String
        sku = dictionary["sku"] as? String
        startPrice = dictionary["startPrice"] as? String
        storeBaseCurrency = dictionary["storeBaseCurrency"] as? String
        toPrice = dictionary["toPrice"] as? String
        totalVariants = dictionary["totalVariants"] as? String
        typeOfRecord = dictionary["typeOfRecord"] as? String
        url = dictionary["url"] as? String
        weight = dictionary["weight"] as? String
        if let swatchesData = dictionary["swatches"] as? [String:Any]{
            swatches = SearchWordKlevuSwatch(fromDictionary: swatchesData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if category != nil{
            dictionary["category"] = category
        }
        if color != nil{
            dictionary["color"] = color
        }
        if colorSwatches != nil{
            dictionary["color_swatches"] = colorSwatches
        }
        if currency != nil{
            dictionary["currency"] = currency
        }
        if deliveryInfo != nil{
            dictionary["deliveryInfo"] = deliveryInfo
        }
        if discount != nil{
            dictionary["discount"] = discount
        }
        if freeShipping != nil{
            dictionary["freeShipping"] = freeShipping
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if groupPrices != nil{
            dictionary["groupPrices"] = groupPrices
        }
        if hideAddToCart != nil{
            dictionary["hideAddToCart"] = hideAddToCart
        }
        if hideGroupPrices != nil{
            dictionary["hideGroupPrices"] = hideGroupPrices
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if imageHover != nil{
            dictionary["imageHover"] = imageHover
        }
        if imageUrl != nil{
            dictionary["imageUrl"] = imageUrl
        }
        if inStock != nil{
            dictionary["inStock"] = inStock
        }
        if itemGroupId != nil{
            dictionary["itemGroupId"] = itemGroupId
        }
        if klevuCategory != nil{
            dictionary["klevu_category"] = klevuCategory
        }
        if lcManufacturer != nil{
            dictionary["lcManufacturer"] = lcManufacturer
        }
        if lvlCategory != nil{
            dictionary["lvl_category"] = lvlCategory
        }
        if manufacturer != nil{
            dictionary["manufacturer"] = manufacturer
        }
        if name != nil{
            dictionary["name"] = name
        }
        if oldPrice != nil{
            dictionary["oldPrice"] = oldPrice
        }
        if price != nil{
            dictionary["price"] = price
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if salePrice != nil{
            dictionary["salePrice"] = salePrice
        }
        if shortDesc != nil{
            dictionary["shortDesc"] = shortDesc
        }
        if size != nil{
            dictionary["size"] = size
        }
        if sku != nil{
            dictionary["sku"] = sku
        }
        if startPrice != nil{
            dictionary["startPrice"] = startPrice
        }
        if storeBaseCurrency != nil{
            dictionary["storeBaseCurrency"] = storeBaseCurrency
        }
        if toPrice != nil{
            dictionary["toPrice"] = toPrice
        }
        if totalVariants != nil{
            dictionary["totalVariants"] = totalVariants
        }
        if typeOfRecord != nil{
            dictionary["typeOfRecord"] = typeOfRecord
        }
        if url != nil{
            dictionary["url"] = url
        }
        if weight != nil{
            dictionary["weight"] = weight
        }
        if swatches != nil{
            dictionary["swatches"] = swatches.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        category = aDecoder.decodeObject(forKey: "category") as? String
        color = aDecoder.decodeObject(forKey: "color") as? String
        colorSwatches = aDecoder.decodeObject(forKey: "color_swatches") as? String
        currency = aDecoder.decodeObject(forKey: "currency") as? String
        deliveryInfo = aDecoder.decodeObject(forKey: "deliveryInfo") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        freeShipping = aDecoder.decodeObject(forKey: "freeShipping") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        groupPrices = aDecoder.decodeObject(forKey: "groupPrices") as? String
        hideAddToCart = aDecoder.decodeObject(forKey: "hideAddToCart") as? String
        hideGroupPrices = aDecoder.decodeObject(forKey: "hideGroupPrices") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageHover = aDecoder.decodeObject(forKey: "imageHover") as? String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        inStock = aDecoder.decodeObject(forKey: "inStock") as? String
        itemGroupId = aDecoder.decodeObject(forKey: "itemGroupId") as? String
        klevuCategory = aDecoder.decodeObject(forKey: "klevu_category") as? String
        lcManufacturer = aDecoder.decodeObject(forKey: "lcManufacturer") as? String
        lvlCategory = aDecoder.decodeObject(forKey: "lvl_category") as? String
        manufacturer = aDecoder.decodeObject(forKey: "manufacturer") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        oldPrice = aDecoder.decodeObject(forKey: "oldPrice") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        salePrice = aDecoder.decodeObject(forKey: "salePrice") as? String
        shortDesc = aDecoder.decodeObject(forKey: "shortDesc") as? String
        size = aDecoder.decodeObject(forKey: "size") as? String
        sku = aDecoder.decodeObject(forKey: "sku") as? String
        startPrice = aDecoder.decodeObject(forKey: "startPrice") as? String
        storeBaseCurrency = aDecoder.decodeObject(forKey: "storeBaseCurrency") as? String
        swatches = aDecoder.decodeObject(forKey: "swatches") as? SearchWordKlevuSwatch
        toPrice = aDecoder.decodeObject(forKey: "toPrice") as? String
        totalVariants = aDecoder.decodeObject(forKey: "totalVariants") as? String
        typeOfRecord = aDecoder.decodeObject(forKey: "typeOfRecord") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        weight = aDecoder.decodeObject(forKey: "weight") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if color != nil{
            aCoder.encode(color, forKey: "color")
        }
        if colorSwatches != nil{
            aCoder.encode(colorSwatches, forKey: "color_swatches")
        }
        if currency != nil{
            aCoder.encode(currency, forKey: "currency")
        }
        if deliveryInfo != nil{
            aCoder.encode(deliveryInfo, forKey: "deliveryInfo")
        }
        if discount != nil{
            aCoder.encode(discount, forKey: "discount")
        }
        if freeShipping != nil{
            aCoder.encode(freeShipping, forKey: "freeShipping")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if groupPrices != nil{
            aCoder.encode(groupPrices, forKey: "groupPrices")
        }
        if hideAddToCart != nil{
            aCoder.encode(hideAddToCart, forKey: "hideAddToCart")
        }
        if hideGroupPrices != nil{
            aCoder.encode(hideGroupPrices, forKey: "hideGroupPrices")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if imageHover != nil{
            aCoder.encode(imageHover, forKey: "imageHover")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if inStock != nil{
            aCoder.encode(inStock, forKey: "inStock")
        }
        if itemGroupId != nil{
            aCoder.encode(itemGroupId, forKey: "itemGroupId")
        }
        if klevuCategory != nil{
            aCoder.encode(klevuCategory, forKey: "klevu_category")
        }
        if lcManufacturer != nil{
            aCoder.encode(lcManufacturer, forKey: "lcManufacturer")
        }
        if lvlCategory != nil{
            aCoder.encode(lvlCategory, forKey: "lvl_category")
        }
        if manufacturer != nil{
            aCoder.encode(manufacturer, forKey: "manufacturer")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if oldPrice != nil{
            aCoder.encode(oldPrice, forKey: "oldPrice")
        }
        if price != nil{
            aCoder.encode(price, forKey: "price")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if salePrice != nil{
            aCoder.encode(salePrice, forKey: "salePrice")
        }
        if shortDesc != nil{
            aCoder.encode(shortDesc, forKey: "shortDesc")
        }
        if size != nil{
            aCoder.encode(size, forKey: "size")
        }
        if sku != nil{
            aCoder.encode(sku, forKey: "sku")
        }
        if startPrice != nil{
            aCoder.encode(startPrice, forKey: "startPrice")
        }
        if storeBaseCurrency != nil{
            aCoder.encode(storeBaseCurrency, forKey: "storeBaseCurrency")
        }
        if swatches != nil{
            aCoder.encode(swatches, forKey: "swatches")
        }
        if toPrice != nil{
            aCoder.encode(toPrice, forKey: "toPrice")
        }
        if totalVariants != nil{
            aCoder.encode(totalVariants, forKey: "totalVariants")
        }
        if typeOfRecord != nil{
            aCoder.encode(typeOfRecord, forKey: "typeOfRecord")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "weight")
        }
    }
}
