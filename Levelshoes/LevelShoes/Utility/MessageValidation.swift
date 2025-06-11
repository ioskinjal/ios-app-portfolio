//
//  MessageValidation.swift
//  LevelShoes
//
//  Created by Maa on 14/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

struct colorNames {
    static let ErrorLineBGColor = UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    static let mobileTF_PlaceHolder_Active = UIColor.init(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    static let errorTextField = UIColor.init(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    static let textOuterView = UIColor.init(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    static let boxCheck = UIColor.init(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216 / 255.0, alpha: 0)
    static let placeHolderColor = UIColor.black
    static let c7C7  = UIColor.init(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
    static let c4747 = UIColor.init(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    static let cfafafa = UIColor.init(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    static let alertBackground = UIColor.init(red: 53.0 / 255.0, green: 53.0 / 255.0, blue: 53.0 / 255.0, alpha: 1)
}

struct colorHexaCode {
    static let btnFBHighlight = "264786"
    static let btnFBNormal = "34589D"
    static let  addTextSpacing = "ffffff"
    static let btnCreateHighlight = "424242"
    static let btnCreateNormal = "000000"
    static let txtFieldSearch = "0B0B0B"
       static let backgroundViewTable = "080808"
}
struct validationMessage {
    static let btnSignInWithFacebook = "registerBtnSignInFacebook"
    static let btnCreateAccount = "registerBtnCreateAccount"
    static let signInWithFacebook = "registerSignInWithFacebook"
    static let createAccount = "registerCreateAccount"
    static let aggremntForAccount = "registerAggremntForAccount"
    static let termConditionForAccount = "registerTermConditionForAccount"
    static let  signUpNewsAndPersonalised = "registerSignUpNewsAndPersonalised"
    static let or = "registerOr"
    static let languegeEng = "languegeEng"
    static let  starEmail = "registerStarEmail"
    static let starFirstName = "registerStarFirstName"
    static let starLastName = "registerStarLastName"
    static let  starMobileNum = "registerStarMobileNum"
    static let starPersonalId = "Personal ID Number"
    static let  starPassword = "registerStarPassword"
    static let starConfPassword = "registerStarConfPassword"
    static let btnRegister = "registerBtnRegister"
    static let  Salutation = "Salutation"
    static let  MR = "Mr"
    static let  Ms = "Ms"
    static let  Mrs = "Mrs"
    
    //MARK:- Json Key for Registration .
    static let keyFirstname = "firstname"
    static let keyLastname = "lastname"
    static let keyEmail = "email"
    static let keyCustomer = "customer"
    static let keyTelephone = "telephone"
    static let keyPassword = "password"
    static let keyStorecode = "storecode"
    static let custom_attributes = "custom_attributes"
    static let attribute_code = "attribute_code"
    static let value = "value"
    static let prefix = "prefix"
    static let providerId = "providerId"
    static let providerType = "providerType"
    static let customerId = "customerId"
    
    
    
    
    //MARK:- Registration Facebook
    static let fbPublic_profile = "public_profile"
    static let fbUser_birthday = "user_birthday"
    static let fbEmail = "email"
    static let customerEmail = "customerEmail"
    static let reqOrigin = "reqOrigin"
    static let website_id = "website_id"
    
    //MARk: - Salt Read Only
    static let salt = "df1d175cfdcf447f62d6af03417c7973"
    
    //MARK:- Module :- My Account By - Chandan
    static let accountSignOut = "accountSignOut"
    static let accountWishlist = "accountWishlist"
    static let aacountAccount = "aacountAccount"
    static let accountOrderReturn = "accountOrderReturn"
    static let accountNotifiation = "accountNotifiation"
    static let accountPersonalDetail = "accountPersonalDetail"
    static let accountPreference = "accountPreference"
    static let accountLocation = "accountLocation"
    static let accountChooseCountry = "accountChooseCountry"
    static let accountTxtCountry = "accountTxtCountry"
    static let accountLanguage = "accountLanguage"
    static let accountInfoHelp = "accountInfoHelp"
    static let accountContactUs = "accountContactUs"
    static let accountFAQ = "accountFAQ"
    static let accountAbout = "accountAbout"
    static let accountPrivacy = "accountPrivacy"
    static let accountTermCondition = "accountTermCondition"
    static let aacountService = "aacountService"
    static let slideContinue = "slideContinue"
   static let  slideWomen = "slideWomen";
    static let  slideMen = "slideMen";
    static let slidKids = "slidKids";
    
    
    static let registerlblNotification = "registerlblNotification"
    
    //MARK:- Search
       static let searchMenu = "searchMenu"
       static let searchResult = "searchResult"
       static let searchTxtPlaceholder = "searchTxtPlaceholder"
    static let RECENT_SEARCHES = "RECENT_SEARCHES"
     static let TRENDING_SEARCHES = "TRENDING_SEARCHES"
    
    
    //MARK:- Core Data Entity  Name
    static let Men = "Men"
    static let Kids = "Kids"
    static let Women = "Women"
    static let KidsChildrenBaby = "KidsChildrenBaby"
    static let KidsChildrenBoy =  "KidsChildrenBoy"
    static let KidsChildrenGirl = "KidsChildrenGirl"
    static let MenBags = "MenBags"
    static let MenBoots = "MenBoots"
    static let MenJewellery = "MenJewellery"
    static let MenLaceUps = "MenLaceUps"
    static let MenLoafersSlippers = "MenLoafersSlippers"
    static let MenOtherAccessories = "MenOtherAccessories"
    static let MenSlidesFlipFlops = "MenSlidesFlipFlops"
    static let MenSmallLeatherGoods = "MenSmallLeatherGoods"
    static let MenSneakers = "MenSneakers"
    static let MenSunglasses = "MenSunglasses"
    static let RecentSearch = "RecentSearch"
    static let TrandingNow = "TrandingNow"
    static let WomenBags = "WomenBags"
    static let WomenBoots = "WomenBoots"
    static let WomenEspadrilles = "WomenEspadrilles"
    static let WomenFlats = "WomenFlats"
    static let WomenFootShoeCare = "WomenFootShoeCare"
    static let WomenHeels = "WomenHeels"
    static let WomenJewellery = "WomenJewellery"
    static let WomenLoafersSlippers = "WomenLoafersSlippers"
    static let WomenMules = "WomenMules"
    static let WomenOtherAccessories = "WomenOtherAccessories"
    static let WomenPuma = "WomenPuma"
    static let WomenSandals = "WomenSandals"
    static let WomenSlidesFlipFlops = "WomenSlidesFlipFlops"
    static let WomenSmallLeatherGoods = "WomenSmallLeatherGoods"
    static let WomenSneakers = "WomenSneakers"
    static let WomenSunglasses = "WomenSunglasses"
    
    
    //MARK:- KLEVU Keys
    static let ticket = "ticket"
    static let term = "term"
    static let paginationStartsFrom = "paginationStartsFrom"
    static let noOfResults = "noOfResults"
    static let showOutOfStockProducts = "showOutOfStockProducts"
    static let fetchMinMaxPrice = "fetchMinMaxPrice"
    static let enableMultiSelectFilters = "enableMultiSelectFilters"
    static let sortOrder = "sortOrder"
    static let enableFilters = "enableFilters"
    static let applyResults = "applyResults"
    static let visibility = "visibility"
    static let category = "category"
    static let klevu_filterLimit = "klevu_filterLimit"
    static let sv = "sv"
    static let lsqt = "lsqt"
    static let responseType = "responseType"
    static let resultForZero = "resultForZero"
    static let youAreIn = "you_in"
    static let viewAllCollection = "viewAllCollection"
    static let applyFilters = "applyFilters"
    static let editorNote = "editorNote"

    static let aboutTheProduct = "aboutTheProduct"
    static let shippingReturn = "shippingReturn"
    static let similarProducts = "similarProducts"
    static let lblProductDetailsTop = "lblProductDetailsTop"
    
    //MARK:- Privacy
    static let privacyCapital = "privacyCapital"
    
    //MARK:- AboutUs
   static let aboutCapital = "aboutCapital"
    static let aboutLevelShoes = "aboutLevelShoes"
   static let  aboutContactNumber = "aboutContactNumber"
    static let aboutMoreDetal = "aboutMoreDetal"
    static let aboutVisitUs = "aboutVisitUs"
    static let aboutStoreHour = "aboutStoreHour"
    static let aboutWorkingDay = "aboutWorkingDay"
    static let aboutWorkingHour = "aboutWorkingHour"
    static let aboutPhoneNumber = "aboutPhoneNumber"
    static let aboutTollFree = "aboutTollFree"
    static let aboutGuestService = "aboutGuestService"
    static let aboutGuestHour = "aboutGuestHour"
    static let aboutAddress = "aboutAddress"
}

extension String {

    /// convert JsonString to Dictionary
    func convertJsonStringToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
        }

        return nil
    }
   
}
func convertToDictionary(text: String) -> [String: Any]? {
       if let data = text.data(using: .utf8) {
           do {
            
               return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
           } catch {
               print(error.localizedDescription)
           }
       }
       return nil
   }

func convertToArray(text: String) -> [[String: Any]]? {
    if let data = text.data(using: .utf8) {
        do {
         
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
         
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func convertToArrayString(text: String) -> [String] {
    if let data = text.data(using: .utf8) {
        do {
         
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String] ?? [String]()
         
        } catch {
            print(error.localizedDescription)
        }
    }
    return [String]()
}
