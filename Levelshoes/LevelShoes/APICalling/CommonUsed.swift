//
//  CommonUsed.swift
//  Level Shoes
//
//  Created by Zing Mobile on 04/04/20.
//  Copyright © 2020 IDSLogic. All rights reserved.
//

import UIKit



class CommonUsed: NSObject {
    
    struct globalUsed {
        
        //Loadbalancer Production Magento Urls
    
        /*static let aeenLoadBaseUrl = "https://www.levelshoes.com/"
        static let aearLoadBaseUrl = "https://www.levelshoes.com/ar"
        static let kwenLoadBaseUrl = "https://en-kuwait.levelshoes.com/"
        static let kwarLoadBaseUrl = "https://ar-kuwait.levelshoes.com/"
        static let saenLoadBaseUrl = "https://en-saudi.levelshoes.com/"
        static let saarLoadBaseUrl = "https://ar-saudi.levelshoes.com/"
        static let omenLoadBaseUrl = "https://en-oman.levelshoes.com/"
        static let omarLoadBaseUrl = "https://ar-oman.levelshoes.com/"
        static let bhenLoadBaseUrl = "https://en-bahrain.levelshoes.com/"
        static let bharLoadBaseUrl = "https://ar-bahrain.levelshoes.com/"*/
        
        //Loadbalancer Staging Magento Urls
        static let aeenLoadBaseUrl = "https://staging-levelshoes-m2.vaimo.net/"
        static let aearLoadBaseUrl = "https://staging-levelshoes-m2.vaimo.net/ar/"
        static let kwenLoadBaseUrl = "https://en-kuwait-staging-levelshoes-m2.vaimo.net/"
        static let kwarLoadBaseUrl = "https://ar-kuwait-staging-levelshoes-m2.vaimo.net/"
        static let saenLoadBaseUrl = "https://en-saudi-staging-levelshoes-m2.vaimo.net/"
        static let saarLoadBaseUrl = "https://ar-saudi-staging-levelshoes-m2.vaimo.net/"
        static let omenLoadBaseUrl = "https://en-oman-staging-levelshoes-m2.vaimo.net/"
        static let omarLoadBaseUrl = "https://ar-oman-staging-levelshoes-m2.vaimo.net/"
        static let bhenLoadBaseUrl = "https://en-bahrain-staging-levelshoes-m2.vaimo.net/"
        static let bharLoadBaseUrl = "https://ar-bahrain-staging-levelshoes-m2.vaimo.net/"
        
        // OMS Setting
        static let OMSAuthorization = "Basic Y2hhbGhvdWI6U3BlZWRidXMjKg=="
        static let OMSAPIKey = "YHet8GGHsi7WPaOQ1NYFG8BGNWpZ6ZeNsY2mTVb3"
        // Checkout Setting
         static let ordeDetail = "https://test.api.speedmule.com/orders/oms/order/"
        static let orderCreate = "https://test.api.speedmule.com/orders/oms/orderCreate"
        static let orderHistory = "https://test.api.speedmule.com/orders/oms/orderhistory/detail"
        //static let CheckoutSecrateKey = "sk_test_c53f28c7-9635-4304-844f-c92d742b5c50"
        //static let CheckoutPublicKey = "pk_test_3b1e178f-8873-45c6-9dd5-4934bbcaa4f4"
        static let checkoutPaymentUrl = "https://api.sandbox.checkout.com/payments"
        static let checkoutTokenUrl = "https://api.sandbox.checkout.com/tokens"
        static let authCapture = true
        static let customDutySku = "262513883290"
        
        static let filterColorAttributeImage = "https://dfgub4cuqcmv6.cloudfront.net/levelshoes/mobileapp/images/Media/colors/swatches/34x34/"
        static let filterAttributeImage = "https://www.levelshoes.com/media/attribute/swatch/swatch_image/34x34"
        static let kimageUrl = "https://www.levelshoes.com/media/catalog/product"
       // static let kbaseurl = "https://mobileapp-levelshoes-m2.vaimo.net/rest/" //Mobileapp Magento Dev Env
        static let kbaseurl = "https://staging-levelshoes-m2.vaimo.net/rest/"
        static let main = "https://staginges.levelshoes.com:9202"
        //static let main = "https://staginges.levelshoes.com:9202"
        //"https://3.120.192.80:9202" // mobileapp ES Dev Env
//        static let main = "http://elasticsearch.idslogic.net"
        static let configEndPoint = main + "/"
        static let productEndPoint = main
        static let productIndexName = "vue_storefront_magento"
        static let cmsBlockDoc = "cms_block"
        static let ESSearchTag = "_search"
        // Landing Page Men Women and Kids
        static let landingMen = "mobileapp_landing_men"
        static let landingWomen = "mobileapp_landing_women"
        static let landingKids = "mobileapp_landing_kids"
        static let genderMen = "men"
        static let genderWomen = "women"
        static let genderKids = "kids"
        static let genderMenId = "39"
        static let genderWomenId = "61"
        static let genderKidsId = "1610"
        
        //MyAccount Gender
        static let accntGenderMen = "Male"
        static let accntGenderWomen = "Female"
        static let accntGenderKids = "Not Specified"
        
        static let viewAllDesignersMenId = "1671"
        static let viewAllDesignersWomenId = "1655"
         static let viewAllDesignersKidId = "1684"
        
        //MARK:-Category Search
        static let categorySearch = "category/_search"
        static let categoryMen = "1705"
        static let categoryWomen = "1706"
        static let categoryKids = "209"
        
        //MARK: - Klevu
        static let KlevuMain = "https://eucs18.ksearchnet.com"
        static let kleviCloud  = "/cloud-search"
        
        static let klevuNSearch = "/n-search/search"
        static let klevuIDSearch = "/n-search/idsearch"
        static let environment = "sandbox"
        static let adjustToken = "3z3omirsh81s"
        
        //MARK - Payment Keys
        static let cardPaymentKey = "pk_test_3b1e178f-8873-45c6-9dd5-4934bbcaa4f4"
        static let zoneList = [262, 261]
        static let staggingUrl = kbaseurl   
        static let klevu = "https://eucs18.ksearchnet.com/"
       // static let baseUrl = "https://mobileapp-levelshoes-m2.vaimo.net/" //DEV
        static let baseUrl = "https://staging-levelshoes-m2.vaimo.net/" //Staging
        static let storeCodePrefix = "vue_storefront_magento" 
        static let cloudSearch = "https://eucs18.ksearchnet.com/"
        static let search1 = "cloud-search/n-search/search"
        static let productList   = "/product/_search"
        static let attributeSearch = "attribute/_search"
        static let local = "http://levelshoes.loc/"
        static let KUserregistration = "V1/customers/"
        static let home = "/landing/"
        static let filter = main + "/levelshoes/config/staging"
        static let search = "cs/v2/search"
        static let onBoarding = "/onboarding/staging"
        static let isEmailAvailable = "V1/customers/isEmailAvailable"
        static let changePasword = "V1/customers/resetPassword"
        static let updatePassword = "V1/customers/me/password"
        static let kUserLogin = "V1/integration/customer/token"
        static let kResetPasword = "V1/customers/passwordmobile"
        static let kReadOnly = "V1/customers/permissions/readonly"
        static let kSocialupdate = "V1/customers/socialupdate"
        static let kLinkcustomer = "V1/customers/linkcustomer"
        static let kPasswordchangecheck = "V1/customers/passwordchangecheck"
        
        static let kemailMessage = "Dear Customer email address can not be blank"
        static let kFirstName = "Dear Customer first name can not be blank"
        static let kLastName = "Dear Customer last name can not be blank"
        static let KPassword = "Dear Customer password can not be blank"
        static let KconfirmPassword = "Dear Customer confirmPassword can not be blank"
        static let KMatchPassword = "Dear Customer password and confirm does not match"
        static let KPasswordlength = "Dear Customer password must be of 6 character"
        static let KCurrentPassword = "Dear Customer Please enter your current password"
        static let KNewPassword = "Dear Customer Please enter your New password"
        static let KValidEmail = "Dear Customer Please enter valid email"
        static let KAlert = "Level Shoes"
        static let KCode = "Dear customer Please enter Code"
        static let KAlertBtn = "OK"
        static let guestVoucherMessage = "Please Login Before Applying Giftcard!"
        static let couponSuccessMessage = "Coupon Applied successful"
        static let voucherSuccessMessage = "Voucher Applied successful"
        
        
        //OMS Stock Check
        static let omsStockUrl = "https://acc-map-lvs.retailunity.com/api/soh/get_stock_level"
        static let omsATPApiKey = "6a97e22c-23db-4d72-a329-d081a43330ab"
        static let omsUserId = "acc-mobileapp"
        
        //Click And Collect Address
         static let ccFirstName = "Randa"
        static let ccLastName = "Aweidah"
        static let ccPhone = "+971505530519"
        static let ccLine1 = "Level Shoes Store"
        static let ccCountry = "United Arab Emirates"
        static let ccPostalCode = "000000"
         static let ccCity = "Dubai"
        static let ccCompany = "LevelShoes Dubai Mall (10000)"
       static let isGiftWrap = false
        
        static let sessionTime = 42 //in Days
        static let threashold = 5
        static let tokenTime = "04/12/2020"
        
        static let designArrayUAE = [704 , 724 , 733 , 767 , 1785 , 1810 , 1811 , 1812 , 1813 , 1814 , 1815 , 1965 , 1966 , 2073 , 1957 , 1958 , 2004 , 2005 , 785 , 952 , 782 , 1959 , 1960 , 1961 , 1962 , 1963 , 783 , 786 , 1733 , 1734 , 1817 , 1818 , 955 , 956 , 1780 , 1819 , 1967 , 1969 , 1974 , 1975 , 1971 , 1970 , 995 , 1001 , 1006 , 996 , 1000 , 1005 , 1821 , 1822 , 1944 , 1945 , 1946 , 1952 , 1953 , 1954 , 1955 , 1956 , 2006 , 2007 , 2007 , 1783 , 1002 , 1823, 2094 , 799]
        static let designArrayKSA = [693 , 1895 , 1944 , 1945 , 2004 , 2005 , 1952 , 2006 , 704 , 725 , 842 , 994 , 733 , 760 , 747 , 730 , 731 , 1012 , 960 , 1552 , 1627 , 855 , 1015 , 862 , 863 , 865 , 767 , 952 , 785 , 995 , 795 , 789 , 1630 , 1818 , 1819 , 1817 , 1733 , 804 , 921 , 926 , 1734 , 928 , 1603 , 930 , 931 , 932 , 818 , 1684 , 820 , 974 , 912 , 950 , 828 , 1966 , 830 , 1759 , 1780 , 1967 , 838 , 841 , 2007 , 2038 , 1971 , 1953 , 1766 , 1974 , 1821 , 1005 , 1001 , 1822 , 1970 , 1002 , 851 , 1006 , 1969 , 1820 , 2047 , 782 , 1954 , 783 , 2051 , 1823 , 1755 , 1752 , 2073 , 786 , 871 , 1025 , 875 , 955 , 956 , 996 , 1000 , 1811 , 1813 , 1783 , 1784 , 1785 , 1959 , 1812 , 1957 , 886 , 888 , 889 , 961 , 988 , 1955 , 1958 , 895 , 1956 , 897 , 1960 , 1961 , 902 , 1962 , 971 , 913 , 1814 , 1815 , 1963 , 1965, 2094, 799]
        static let designArrayKWT = [704 , 2051 , 725 , 1954 , 730 , 731 , 733 , 1811 , 1955 , 1812 , 1784 , 1956 , 1813 , 747 , 2073 , 1627 , 960 , 2004 , 760 , 1957 , 1958 , 767 , 1959 , 1734 , 1960 , 1961 , 782 , 783 , 785 , 786 , 1962 , 789 , 1814 , 795 , 1815 , 1963 , 804 , 1974 , 921 , 926 , 1817 , 928 , 1603 , 930 , 931 , 932 , 818 , 820 , 1818 , 828 , 1684 , 1965 , 830 , 1966 , 1759 , 950 , 952 , 1967 , 955 , 956 , 838 , 841 , 1952 , 842 , 1819 , 1953 , 1766 , 994 , 995 , 996 , 1000 , 1001 , 1002 , 1005 , 1006 , 851 , 1969 , 855 , 1012 , 1552 , 1015 , 1755 , 862 , 863 , 865 , 871 , 1785 , 1025 , 875 , 1970 , 2038 , 1821 , 886 , 1752 , 888 , 889 , 961 , 1971 , 988 , 1822 , 2005 , 895 , 2006 , 897 , 2007 , 902 , 971 , 913 , 974 , 1783 , 912 , 1823 , 1733, 2094, 799]
        static let designArrayOMR = [693 , 1895 , 1944 , 1945 , 2004 , 2005 , 1952 , 2006 , 704 , 725 , 842 , 994 , 733 , 760 , 747 , 730 , 731 , 1012 , 960 , 1552 , 1627 , 855 , 1015 , 862 , 863 , 865 , 767 , 952 , 785 , 995 , 795 , 789 , 1818 , 1819 , 1817 , 1733 , 804 , 921 , 926 , 1734 , 928 , 1603 , 930 , 931 , 932 , 818 , 1684 , 820 , 974 , 912 , 950 , 828 , 1966 , 1759 , 1780 , 1967 , 838 , 841 , 2007 , 2038 , 1971 , 1953 , 1766 , 1974 , 1821 , 1005 , 1001 , 1822 , 1970 , 1002 , 1006 , 1969 , 782 , 1954 , 783 , 1823 , 1755 , 1752 , 2073 , 786 , 871 , 1025 , 875 , 955 , 956 , 996 , 1000 , 1811 , 1810 , 1813 , 1783 , 1784 , 1785 , 1959 , 1812 , 1957 , 886 , 888 , 889 , 961 , 988 , 1955 , 1958 , 895 , 1956 , 897 , 1960 , 1961 , 902 , 1962 , 971 , 913 , 1814 , 1815 , 1963 , 1965, 2094, 799]
        static let designArrayBHD = [913, 971, 1783, 2094, 799]
        
        
        static let paymentArrayUAE = ["cod","apple","card"]
        static let paymentArrayKSA = ["cod","apple","card"]
        static let paymentArrayKWT = ["cod","apple","card"]
        static let paymentArrayOMR = ["cod","apple","card"]
        static let paymentArrayBHD = ["cod","apple","card"]
        
         static let homedeliveryCarrierCode = "matrixrate"
         static let clickandcollectCarrierCode = "clickandcollect"
     
        
    }
 
}

func getVatName() -> String{
    let storeCode = getM2StoreCode()
    var vatName = ""
    if(storeCode.lowercased() == "ae_en"){ vatName = "VAT".localized }
    if(storeCode.lowercased() == "sa_en"){ vatName = "VAT".localized}
    if(storeCode.lowercased() == "kw_en"){ vatName = "Duties".localized}
    if(storeCode.lowercased() == "om_en"){ vatName = "Duties".localized}
    if(storeCode.lowercased() == "bh_en"){ vatName = "Duties".localized}
    if(storeCode.lowercased() == "ae_ar"){ vatName = "VAT".localized}
    if(storeCode.lowercased() == "sa_ar"){ vatName = "VAT".localized}
    if(storeCode.lowercased() == "kw_ar"){ vatName = "Duties".localized }
    if(storeCode.lowercased() == "om_ar"){ vatName = "Duties".localized}
    if(storeCode.lowercased() == "bh_ar"){ vatName = "Duties".localized }
    return vatName
}

func getWebsiteBaseUrl(with: String) -> String{
    let storeCode = getM2StoreCode()
    var storeId = ""
    if(storeCode.lowercased() == "ae_en"){ storeId = CommonUsed.globalUsed.aeenLoadBaseUrl }
    if(storeCode.lowercased() == "sa_en"){ storeId = CommonUsed.globalUsed.saenLoadBaseUrl }
    if(storeCode.lowercased() == "kw_en"){ storeId = CommonUsed.globalUsed.kwenLoadBaseUrl }
    if(storeCode.lowercased() == "om_en"){ storeId = CommonUsed.globalUsed.omenLoadBaseUrl }
    if(storeCode.lowercased() == "bh_en"){ storeId = CommonUsed.globalUsed.bhenLoadBaseUrl }
    if(storeCode.lowercased() == "ae_ar"){ storeId = CommonUsed.globalUsed.aearLoadBaseUrl }
    if(storeCode.lowercased() == "sa_ar"){ storeId = CommonUsed.globalUsed.saarLoadBaseUrl }
    if(storeCode.lowercased() == "kw_ar"){ storeId = CommonUsed.globalUsed.kwarLoadBaseUrl }
    if(storeCode.lowercased() == "om_ar"){ storeId = CommonUsed.globalUsed.omarLoadBaseUrl }
    if(storeCode.lowercased() == "bh_ar"){ storeId = CommonUsed.globalUsed.bharLoadBaseUrl }
    if(with == "rest"){ storeId = storeId + "rest/" }
    return storeId
}
func getCheckoutSecretKey() -> String{
    let language = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
    let storeCode = UserDefaults.standard.value(forKey: "storecode") as? String!
    var CheckoutSecretKey = "sk_test_ea73eef5-b6d3-4638-8fdd-0ed7716aa386"

    if (language == "en" && storeCode == "ae"){
           CheckoutSecretKey = "sk_test_ea73eef5-b6d3-4638-8fdd-0ed7716aa386"
          
            
       }else if(language == "ar" && storeCode == "ae"){
            CheckoutSecretKey = "sk_test_d030aedb-035f-417c-b40f-07dcefc12ed7"

       }else if(language == "en" && storeCode == "sa"){
           CheckoutSecretKey = "sk_test_a80d43c3-2bb7-4c79-b20c-beeebba5b547"

       }else if(language == "ar" && storeCode == "sa"){
             CheckoutSecretKey = "sk_test_d8146082-1bf8-4ca4-b74d-6c6533bed915"

       }else if(language == "ar" && storeCode == "kw"){
             CheckoutSecretKey = "sk_test_5c0c2b7f-459b-4081-9e6a-ffaf99e80f56"
   
       }else if(language == "en" && storeCode == "kw"){
            CheckoutSecretKey = "sk_test_5e2a3a17-442f-4398-85cf-780d996fc85c"
           
           
       }else if(language == "en" && storeCode == "om"){
           CheckoutSecretKey = "sk_test_58fc5283-0357-44ef-afcb-117057aebc43"
          
          
       }else if(language == "ar" && storeCode == "om"){
           CheckoutSecretKey = "sk_test_28a0c265-9125-45da-9f22-e04b73438646"
            
           
       }else if(language == "en" && storeCode == "bh"){
            CheckoutSecretKey = "sk_test_ac01e8bb-1134-4904-b514-e0ebb7aff5d0"
         
           
       }else if(language == "ar" && storeCode == "bh"){
           CheckoutSecretKey = "sk_test_7a8ea9bb-179b-4f97-8e15-e7e5dd4fca64"
          
       }
    return CheckoutSecretKey
}

func getCheckoutPublicKey() -> String{
    let language = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
    let storeCode = UserDefaults.standard.value(forKey: "storecode") as? String!
   
    var CheckoutPublicKey = "pk_test_1f7e40f9-8974-45b0-ac33-a48c3405561d"
    if (language == "en" && storeCode == "ae"){
           
           CheckoutPublicKey = "pk_test_1f7e40f9-8974-45b0-ac33-a48c3405561d"
            
       }else if(language == "ar" && storeCode == "ae"){
           
           CheckoutPublicKey = "pk_test_ab0b80eb-41d2-4c6e-bde9-fc0c400a0e9a"
       }else if(language == "en" && storeCode == "sa"){
          
           CheckoutPublicKey = "pk_test_ceb56135-f0f4-468f-8ef3-2272313a42f0"
       }else if(language == "ar" && storeCode == "sa"){
           
            CheckoutPublicKey = "pk_test_91d7cd29-496e-42b3-aae6-a72bad20a1b2"
       }else if(language == "ar" && storeCode == "kw"){
            
            CheckoutPublicKey = "pk_test_e96bf720-f024-4928-ba8a-2a1b0c193b6f"
       }else if(language == "en" && storeCode == "kw"){
         
            CheckoutPublicKey = "pk_test_4bf680ff-873d-4fdb-a40e-f3279a2e0fc4"
           
       }else if(language == "en" && storeCode == "om"){
          
           CheckoutPublicKey = "pk_test_e8b39dd6-14c7-4ac7-b577-5cfb35bc10f4"
          
       }else if(language == "ar" && storeCode == "om"){
          
            CheckoutPublicKey = "pk_test_5f215130-b49d-4987-a667-f742dd3e60b9"
           
       }else if(language == "en" && storeCode == "bh"){
          
           CheckoutPublicKey = "pk_test_4422afc1-b773-4e50-901b-053587230f07"
           
       }else if(language == "ar" && storeCode == "bh"){
          
           CheckoutPublicKey = "pk_test_4f465478-4369-42e1-aa22-f4a9b14c687a"
       }
    return CheckoutPublicKey
}
func getSkuCode()->String{
    
   var skuCode = ""
    var language = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
    var storeCode = UserDefaults.standard.value(forKey: "storecode") as? String!
     skuCode = "klevu-158358783414411589"
    
    if (language == "en" && storeCode == "ae"){
        skuCode = "klevu-158358783414411589"
    }else if(language == "ar" && storeCode == "ae"){
        skuCode = "klevu-158358841607111589"
    }else if(language == "en" && storeCode == "sa"){
        skuCode = "klevu-158358926983111589"
    }else if(language == "ar" && storeCode == "sa"){
         skuCode = "klevu-158358934990911589"
    }else if(language == "ar" && storeCode == "kw"){
         skuCode = "klevu-158364133980711589"
    }else if(language == "en" && storeCode == "kw"){
         skuCode = "klevu-158358942027511589"
        
    }else if(language == "en" && storeCode == "om"){
        skuCode = "klevu-158364141744611589"
       
    }else if(language == "ar" && storeCode == "om"){
         skuCode = "klevu-158374818352011589"
        
    }else if(language == "en" && storeCode == "bh"){
        skuCode = "klevu-158374852940611589"
        
    }else if(language == "ar" && storeCode == "bh"){
        skuCode = "klevu-158375199266011589"
    }
   
    return skuCode
}

func getStoreCode()->String{
       let storeCode="\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
       return storeCode
   }
func getProductUrl() -> String{
    let strCode = getStoreCode()
    let url = CommonUsed.globalUsed.productEndPoint + "/"  + getStoreCode() + CommonUsed.globalUsed.productList
    return url
}
func getM2StoreCode()->String{
    let storeCode="\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
    return storeCode
}
func getWebsiteId() -> Int {
    let countryCode = UserDefaults.standard.string(forKey: "storecode")
    var websiteId = 0
    if(countryCode?.lowercased() == "ae"){ websiteId = 1 }
    if(countryCode?.lowercased() == "sa"){ websiteId = 2 }
    if(countryCode?.lowercased() == "kw"){ websiteId = 3 }
    if(countryCode?.lowercased() == "om"){ websiteId = 4 }
    if(countryCode?.lowercased() == "bh"){ websiteId = 5 }
    return websiteId
}
func getWebsiteCurrency() -> String {
    let countryCode = UserDefaults.standard.string(forKey: "storecode")
    var currency = ""
    if(countryCode?.lowercased() == "ae"){ currency = "AED" }
    if(countryCode?.lowercased() == "sa"){ currency = "SAR" }
    if(countryCode?.lowercased() == "kw"){ currency = "KWD" }
    if(countryCode?.lowercased() == "om"){ currency = "OMR" }
    if(countryCode?.lowercased() == "bh"){ currency = "BHD" }
    return currency
}

func getStoreId() -> Int {
    let storeCode = getM2StoreCode()
    var storeId = 0
    if(storeCode.lowercased() == "ae_en"){ storeId = 1 }
    if(storeCode.lowercased() == "sa_en"){ storeId = 3 }
    if(storeCode.lowercased() == "kw_en"){ storeId = 5 }
    if(storeCode.lowercased() == "om_en"){ storeId = 7 }
    if(storeCode.lowercased() == "bh_en"){ storeId = 9 }
    if(storeCode.lowercased() == "ae_ar"){ storeId = 2 }
    if(storeCode.lowercased() == "sa_ar"){ storeId = 4 }
    if(storeCode.lowercased() == "kw_ar"){ storeId = 6 }
    if(storeCode.lowercased() == "om_ar"){ storeId = 8 }
    if(storeCode.lowercased() == "bh_ar"){ storeId = 10 }
    return storeId
}
func getCountryList() -> [[String:Any]]{
       var countriesListData = [[String:Any]]()
       let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
          do {
              let jsonData = try Data(contentsOf: url)
              let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

              if let question1 = json["countries"] {
                  print( question1)
               countriesListData = json["countries"] as! [[String : Any]]
              }
          }
          catch {
              print(error)
          }

        return countriesListData
   }
func saveWishListArray(productIdArray: [String]){
     let preferences = UserDefaults.standard
     let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: productIdArray)
     preferences.set(encodedData, forKey:"WisListLocalDbKey" )
    
}
    
func getWishListArray() -> [String] {
    let preferences = UserDefaults.standard
    if preferences.object(forKey: "WisListLocalDbKey") != nil{
        let decoded = preferences.object(forKey: "WisListLocalDbKey")  as! Data
        let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [String]
        return decodedDict
    } else {
        let emptyDict = [String]()
        return emptyDict
    }
}
func addWishListArray(productId:String)  {
    var wishList = getWishListArray()
    wishList.append(productId)
    saveWishListArray(productIdArray: Array(Set(wishList)))
}
func removeWishListArray(productId:String)  {
    var wishList = getWishListArray()
    for item in wishList {
        if item == productId{
            wishList.remove(object: item)
            break
        }
    }
    saveWishListArray(productIdArray: wishList)
}
func removeAllWishListArray()  {
    UserDefaults.standard.removeObject(forKey: "WisListLocalDbKey")
}

func getSortedWishList(wishList:[WishlistModel]) -> [WishlistModel]{
    let myWishList : [WishlistModel] =  wishList.sorted(by: {$0.added_at > $1.added_at})
        removeAllWishListArray()
    for wisList in myWishList {
        addWishListArray(productId: wisList.product.sku)
    }
    return myWishList
}
func shouldHideVatinclusive() -> Bool {
    let country = UserDefaults.standard.value(forKey: "country") as! String
    if country == "UnitedArabEmirates" || country == "SaudiArabia"{
        return false
    }
    else{
        return true
    }
}

func isWishListProduct(productId:String) -> Bool  {
    var isWishList = false
    let wishList = getWishListArray()
    for item in wishList {
        if item == productId{
            isWishList = true
            break
        }
    }
    return isWishList
}
func addMyWishListInLocalDb()  {
       let param = [
           "customer_id": UserDefaults.standard.value(forKey: "customerId")!
           ] as [String : Any]
       removeAllWishListArray()
       ApiManager.getWishList(params: param, success: { (response ) in
           print(response)
           if response != nil{
              
               if let data = response  as? [AnyObject]{
                   for wislistitem in data{
                       var productModel = WishlistModel()
                       productModel = productModel.getWishlistModel(dict: wislistitem as! [String : AnyObject])
                       addWishListArray(productId:productModel.product.sku)
                      
                   }
               }
         
       }
       }) {
           
       }

   }
@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

