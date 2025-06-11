//
//  SearchChildrenDatum.swift
//  Created on June 29, 2020

import Foundation


class SearchChildrenDatum : NSObject, NSCoding{

    var automaticSorting : String!
    var breadcrumbsPriority : String!
    var categorySeoName : AnyObject!
    var childrenCount : Int!
    var childrenData : [AnyObject]!
    var columnBreakpoint : Int!
    var customApplyToProducts : Int!
    var customDesign : AnyObject!
    var customLayoutUpdate : AnyObject!
    var customUseParentSettings : Int!
    var descriptionField : AnyObject!
    var displayMode : String!
    var id : Int!
    var image : AnyObject!
    var inHtmlSitemap : Int!
    var inXmlSitemap : Int!
    var includeInMenu : Int!
    var isActive : Bool!
    var isAnchor : Bool!
    var isExcludeCat : Bool!
    var landingPage : AnyObject!
    var level : Int!
    var menuColor : AnyObject!
    var menuGroup : String!
    var menuHideChildren : Int!
    var menuImage : AnyObject!
    var menuItemCmsPage : String!
    var menuItemLink : AnyObject!
    var menuItemType : String!
    var metaDescription : String!
    var metaKeywords : AnyObject!
    var metaRobots : String!
    var metaTitle : String!
    var name : String!
    var pageLayout : AnyObject!
    var pageType : Int!
    var parentId : Int!
    var path : String!
    var position : Int!
    var productCount : Int!
    var redirectPriority : AnyObject!
    var slug : String!
    var suppressFilters : Int!
    var urlKey : String!
    var urlPath : String!
    var useInCrosslinking : Int!
    var useTransparentHeader : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    override init() {
           
           super.init()
       }
    
    init(fromDictionary dictionary: [String:Any]){
        automaticSorting = dictionary["automatic_sorting"] as? String
        breadcrumbsPriority = dictionary["breadcrumbs_priority"] as? String
        categorySeoName = dictionary["category_seo_name"] as? AnyObject
        childrenCount = dictionary["children_count"] as? Int
        columnBreakpoint = dictionary["column_breakpoint"] as? Int
        customApplyToProducts = dictionary["custom_apply_to_products"] as? Int
        customDesign = dictionary["custom_design"] as? AnyObject
        customLayoutUpdate = dictionary["custom_layout_update"] as? AnyObject
        customUseParentSettings = dictionary["custom_use_parent_settings"] as? Int
        descriptionField = dictionary["description"] as? AnyObject
        displayMode = dictionary["display_mode"] as? String
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? AnyObject
        inHtmlSitemap = dictionary["in_html_sitemap"] as? Int
        inXmlSitemap = dictionary["in_xml_sitemap"] as? Int
        includeInMenu = dictionary["include_in_menu"] as? Int
        isActive = dictionary["is_active"] as? Bool
        isAnchor = dictionary["is_anchor"] as? Bool
        isExcludeCat = dictionary["is_exclude_cat"] as? Bool
        landingPage = dictionary["landing_page"] as? AnyObject
        level = dictionary["level"] as? Int
        menuColor = dictionary["menu_color"] as? AnyObject
        menuGroup = dictionary["menu_group"] as? String
        menuHideChildren = dictionary["menu_hide_children"] as? Int
        menuImage = dictionary["menu_image"] as? AnyObject
        menuItemCmsPage = dictionary["menu_item_cms_page"] as? String
        menuItemLink = dictionary["menu_item_link"] as? AnyObject
        menuItemType = dictionary["menu_item_type"] as? String
        metaDescription = dictionary["meta_description"] as? String
        metaKeywords = dictionary["meta_keywords"] as? AnyObject
        metaRobots = dictionary["meta_robots"] as? String
        metaTitle = dictionary["meta_title"] as? String
        name = dictionary["name"] as? String
        pageLayout = dictionary["page_layout"] as? AnyObject
        pageType = dictionary["page_type"] as? Int
        parentId = dictionary["parent_id"] as? Int
        path = dictionary["path"] as? String
        position = dictionary["position"] as? Int
        productCount = dictionary["product_count"] as? Int
        redirectPriority = dictionary["redirect_priority"] as? AnyObject
        slug = dictionary["slug"] as? String
        suppressFilters = dictionary["suppress_filters"] as? Int
        urlKey = dictionary["url_key"] as? String
        urlPath = dictionary["url_path"] as? String
        useInCrosslinking = dictionary["use_in_crosslinking"] as? Int
        useTransparentHeader = dictionary["use_transparent_header"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if automaticSorting != nil{
            dictionary["automatic_sorting"] = automaticSorting
        }
        if breadcrumbsPriority != nil{
            dictionary["breadcrumbs_priority"] = breadcrumbsPriority
        }
        if categorySeoName != nil{
            dictionary["category_seo_name"] = categorySeoName
        }
        if childrenCount != nil{
            dictionary["children_count"] = childrenCount
        }
        if columnBreakpoint != nil{
            dictionary["column_breakpoint"] = columnBreakpoint
        }
        if customApplyToProducts != nil{
            dictionary["custom_apply_to_products"] = customApplyToProducts
        }
        if customDesign != nil{
            dictionary["custom_design"] = customDesign
        }
        if customLayoutUpdate != nil{
            dictionary["custom_layout_update"] = customLayoutUpdate
        }
        if customUseParentSettings != nil{
            dictionary["custom_use_parent_settings"] = customUseParentSettings
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if displayMode != nil{
            dictionary["display_mode"] = displayMode
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if inHtmlSitemap != nil{
            dictionary["in_html_sitemap"] = inHtmlSitemap
        }
        if inXmlSitemap != nil{
            dictionary["in_xml_sitemap"] = inXmlSitemap
        }
        if includeInMenu != nil{
            dictionary["include_in_menu"] = includeInMenu
        }
        if isActive != nil{
            dictionary["is_active"] = isActive
        }
        if isAnchor != nil{
            dictionary["is_anchor"] = isAnchor
        }
        if isExcludeCat != nil{
            dictionary["is_exclude_cat"] = isExcludeCat
        }
        if landingPage != nil{
            dictionary["landing_page"] = landingPage
        }
        if level != nil{
            dictionary["level"] = level
        }
        if menuColor != nil{
            dictionary["menu_color"] = menuColor
        }
        if menuGroup != nil{
            dictionary["menu_group"] = menuGroup
        }
        if menuHideChildren != nil{
            dictionary["menu_hide_children"] = menuHideChildren
        }
        if menuImage != nil{
            dictionary["menu_image"] = menuImage
        }
        if menuItemCmsPage != nil{
            dictionary["menu_item_cms_page"] = menuItemCmsPage
        }
        if menuItemLink != nil{
            dictionary["menu_item_link"] = menuItemLink
        }
        if menuItemType != nil{
            dictionary["menu_item_type"] = menuItemType
        }
        if metaDescription != nil{
            dictionary["meta_description"] = metaDescription
        }
        if metaKeywords != nil{
            dictionary["meta_keywords"] = metaKeywords
        }
        if metaRobots != nil{
            dictionary["meta_robots"] = metaRobots
        }
        if metaTitle != nil{
            dictionary["meta_title"] = metaTitle
        }
        if name != nil{
            dictionary["name"] = name
        }
        if pageLayout != nil{
            dictionary["page_layout"] = pageLayout
        }
        if pageType != nil{
            dictionary["page_type"] = pageType
        }
        if parentId != nil{
            dictionary["parent_id"] = parentId
        }
        if path != nil{
            dictionary["path"] = path
        }
        if position != nil{
            dictionary["position"] = position
        }
        if productCount != nil{
            dictionary["product_count"] = productCount
        }
        if redirectPriority != nil{
            dictionary["redirect_priority"] = redirectPriority
        }
        if slug != nil{
            dictionary["slug"] = slug
        }
        if suppressFilters != nil{
            dictionary["suppress_filters"] = suppressFilters
        }
        if urlKey != nil{
            dictionary["url_key"] = urlKey
        }
        if urlPath != nil{
            dictionary["url_path"] = urlPath
        }
        if useInCrosslinking != nil{
            dictionary["use_in_crosslinking"] = useInCrosslinking
        }
        if useTransparentHeader != nil{
            dictionary["use_transparent_header"] = useTransparentHeader
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        automaticSorting = aDecoder.decodeObject(forKey: "automatic_sorting") as? String
        breadcrumbsPriority = aDecoder.decodeObject(forKey: "breadcrumbs_priority") as? String
        categorySeoName = aDecoder.decodeObject(forKey: "category_seo_name") as? AnyObject
        childrenCount = aDecoder.decodeObject(forKey: "children_count") as? Int
        childrenData = aDecoder.decodeObject(forKey: "children_data") as? [AnyObject]
        columnBreakpoint = aDecoder.decodeObject(forKey: "column_breakpoint") as? Int
        customApplyToProducts = aDecoder.decodeObject(forKey: "custom_apply_to_products") as? Int
        customDesign = aDecoder.decodeObject(forKey: "custom_design") as? AnyObject
        customLayoutUpdate = aDecoder.decodeObject(forKey: "custom_layout_update") as? AnyObject
        customUseParentSettings = aDecoder.decodeObject(forKey: "custom_use_parent_settings") as? Int
        descriptionField = aDecoder.decodeObject(forKey: "description") as? AnyObject
        displayMode = aDecoder.decodeObject(forKey: "display_mode") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? AnyObject
        inHtmlSitemap = aDecoder.decodeObject(forKey: "in_html_sitemap") as? Int
        inXmlSitemap = aDecoder.decodeObject(forKey: "in_xml_sitemap") as? Int
        includeInMenu = aDecoder.decodeObject(forKey: "include_in_menu") as? Int
        isActive = aDecoder.decodeObject(forKey: "is_active") as? Bool
        isAnchor = aDecoder.decodeObject(forKey: "is_anchor") as? Bool
        isExcludeCat = aDecoder.decodeObject(forKey: "is_exclude_cat") as? Bool
        landingPage = aDecoder.decodeObject(forKey: "landing_page") as? AnyObject
        level = aDecoder.decodeObject(forKey: "level") as? Int
        menuColor = aDecoder.decodeObject(forKey: "menu_color") as? AnyObject
        menuGroup = aDecoder.decodeObject(forKey: "menu_group") as? String
        menuHideChildren = aDecoder.decodeObject(forKey: "menu_hide_children") as? Int
        menuImage = aDecoder.decodeObject(forKey: "menu_image") as? AnyObject
        menuItemCmsPage = aDecoder.decodeObject(forKey: "menu_item_cms_page") as? String
        menuItemLink = aDecoder.decodeObject(forKey: "menu_item_link") as? AnyObject
        menuItemType = aDecoder.decodeObject(forKey: "menu_item_type") as? String
        metaDescription = aDecoder.decodeObject(forKey: "meta_description") as? String
        metaKeywords = aDecoder.decodeObject(forKey: "meta_keywords") as? AnyObject
        metaRobots = aDecoder.decodeObject(forKey: "meta_robots") as? String
        metaTitle = aDecoder.decodeObject(forKey: "meta_title") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        pageLayout = aDecoder.decodeObject(forKey: "page_layout") as? AnyObject
        pageType = aDecoder.decodeObject(forKey: "page_type") as? Int
        parentId = aDecoder.decodeObject(forKey: "parent_id") as? Int
        path = aDecoder.decodeObject(forKey: "path") as? String
        position = aDecoder.decodeObject(forKey: "position") as? Int
        productCount = aDecoder.decodeObject(forKey: "product_count") as? Int
        redirectPriority = aDecoder.decodeObject(forKey: "redirect_priority") as? AnyObject
        slug = aDecoder.decodeObject(forKey: "slug") as? String
        suppressFilters = aDecoder.decodeObject(forKey: "suppress_filters") as? Int
        urlKey = aDecoder.decodeObject(forKey: "url_key") as? String
        urlPath = aDecoder.decodeObject(forKey: "url_path") as? String
        useInCrosslinking = aDecoder.decodeObject(forKey: "use_in_crosslinking") as? Int
        useTransparentHeader = aDecoder.decodeObject(forKey: "use_transparent_header") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if automaticSorting != nil{
            aCoder.encode(automaticSorting, forKey: "automatic_sorting")
        }
        if breadcrumbsPriority != nil{
            aCoder.encode(breadcrumbsPriority, forKey: "breadcrumbs_priority")
        }
        if categorySeoName != nil{
            aCoder.encode(categorySeoName, forKey: "category_seo_name")
        }
        if childrenCount != nil{
            aCoder.encode(childrenCount, forKey: "children_count")
        }
        if childrenData != nil{
            aCoder.encode(childrenData, forKey: "children_data")
        }
        if columnBreakpoint != nil{
            aCoder.encode(columnBreakpoint, forKey: "column_breakpoint")
        }
        if customApplyToProducts != nil{
            aCoder.encode(customApplyToProducts, forKey: "custom_apply_to_products")
        }
        if customDesign != nil{
            aCoder.encode(customDesign, forKey: "custom_design")
        }
        if customLayoutUpdate != nil{
            aCoder.encode(customLayoutUpdate, forKey: "custom_layout_update")
        }
        if customUseParentSettings != nil{
            aCoder.encode(customUseParentSettings, forKey: "custom_use_parent_settings")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if displayMode != nil{
            aCoder.encode(displayMode, forKey: "display_mode")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if inHtmlSitemap != nil{
            aCoder.encode(inHtmlSitemap, forKey: "in_html_sitemap")
        }
        if inXmlSitemap != nil{
            aCoder.encode(inXmlSitemap, forKey: "in_xml_sitemap")
        }
        if includeInMenu != nil{
            aCoder.encode(includeInMenu, forKey: "include_in_menu")
        }
        if isActive != nil{
            aCoder.encode(isActive, forKey: "is_active")
        }
        if isAnchor != nil{
            aCoder.encode(isAnchor, forKey: "is_anchor")
        }
        if isExcludeCat != nil{
            aCoder.encode(isExcludeCat, forKey: "is_exclude_cat")
        }
        if landingPage != nil{
            aCoder.encode(landingPage, forKey: "landing_page")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if menuColor != nil{
            aCoder.encode(menuColor, forKey: "menu_color")
        }
        if menuGroup != nil{
            aCoder.encode(menuGroup, forKey: "menu_group")
        }
        if menuHideChildren != nil{
            aCoder.encode(menuHideChildren, forKey: "menu_hide_children")
        }
        if menuImage != nil{
            aCoder.encode(menuImage, forKey: "menu_image")
        }
        if menuItemCmsPage != nil{
            aCoder.encode(menuItemCmsPage, forKey: "menu_item_cms_page")
        }
        if menuItemLink != nil{
            aCoder.encode(menuItemLink, forKey: "menu_item_link")
        }
        if menuItemType != nil{
            aCoder.encode(menuItemType, forKey: "menu_item_type")
        }
        if metaDescription != nil{
            aCoder.encode(metaDescription, forKey: "meta_description")
        }
        if metaKeywords != nil{
            aCoder.encode(metaKeywords, forKey: "meta_keywords")
        }
        if metaRobots != nil{
            aCoder.encode(metaRobots, forKey: "meta_robots")
        }
        if metaTitle != nil{
            aCoder.encode(metaTitle, forKey: "meta_title")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if pageLayout != nil{
            aCoder.encode(pageLayout, forKey: "page_layout")
        }
        if pageType != nil{
            aCoder.encode(pageType, forKey: "page_type")
        }
        if parentId != nil{
            aCoder.encode(parentId, forKey: "parent_id")
        }
        if path != nil{
            aCoder.encode(path, forKey: "path")
        }
        if position != nil{
            aCoder.encode(position, forKey: "position")
        }
        if productCount != nil{
            aCoder.encode(productCount, forKey: "product_count")
        }
        if redirectPriority != nil{
            aCoder.encode(redirectPriority, forKey: "redirect_priority")
        }
        if slug != nil{
            aCoder.encode(slug, forKey: "slug")
        }
        if suppressFilters != nil{
            aCoder.encode(suppressFilters, forKey: "suppress_filters")
        }
        if urlKey != nil{
            aCoder.encode(urlKey, forKey: "url_key")
        }
        if urlPath != nil{
            aCoder.encode(urlPath, forKey: "url_path")
        }
        if useInCrosslinking != nil{
            aCoder.encode(useInCrosslinking, forKey: "use_in_crosslinking")
        }
        if useTransparentHeader != nil{
            aCoder.encode(useTransparentHeader, forKey: "use_transparent_header")
        }
    }
}
