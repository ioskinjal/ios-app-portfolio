//
//  ConfigResponse.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ConfigResponse: YuppModel {
    
    public var clientConfigs = ClientConfig()
    public var languageSelectionAttributes = LanguageSelectinoAttributes()
    public var displayLanguages = [Language]()
    public var configs = Config()
    public var contentLanguages = [Language]()
    public var resourceProfiles = [ResourceProfile]()
    public var menus = [Menu]()
    public var rawData = [String : Any]()
    
    
    public struct StoredConfig {
        public static var lastUpdated : Date?
        public static var response : ConfigResponse?
        internal static func getConfigResponse(currentDate : Date!) -> ConfigResponse? {
            guard let oldDate = lastUpdated else {
                response = nil
                lastUpdated = nil
                return nil
            }
            return StoredConfig.response
            /*let secondsBetween = abs(Int(currentDate.timeIntervalSince(oldDate)))
            let secondsInHour = 3600
            
            let hours =  secondsBetween / secondsInHour
            if hours <= 1{
                return StoredConfig.response
            }
            return nil*/
            
            /*
            let date1StartOfTheDay = NSCalendar.current.startOfDay(for: oldDate)
            let date2StartOfTheDay = NSCalendar.current.startOfDay(for: currentDate)
            if date1StartOfTheDay.compare(date2StartOfTheDay) == .orderedSame
            {
                return StoredConfig.response
            }
            return nil
             */
        }
    }
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _clientConfigs = json["clientConfigs"] as? [String : Any]{
            clientConfigs = ClientConfig.init(_clientConfigs)
        }
        if let _langSelectionAttributes = json["langSelectionAttributes"] as? [String : Any]{
            languageSelectionAttributes = LanguageSelectinoAttributes.init(_langSelectionAttributes)
        }
        displayLanguages = Language.array(json: json["displayLanguages"])
        if let _configs = json["configs"] as? [String : Any]{
            configs = Config.init(_configs)
        }
        contentLanguages = Language.array(json: json["contentLanguages"])
        resourceProfiles = ResourceProfile.resourceProfiles(json: json["resourceProfiles"])
        menus = Menu.menus(json: json["menus"])
        rawData = json
    }
    
    public static func menus(json : Any) -> [Menu]{
        var list = [Menu]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Menu(obj))
            }
        }
        return list
    }
}

public class Config: YuppModel {
    public var isOTPSupported = false
    public var isSocialMediaSharingSupported = false
    public var supportChromecast = false
    public var isFacebookLoginSupported = false
    public var siteURL = ""
    public var maxOTPLength = 0
    public var primaryTimeZone = ""
    public var primaryTimeZoneOffset = ""
    public var callingNumber = ""
    public var isCallSupported = false
    public var supportGoogleLogin = false
    public var supportAppleLogin = false
    public var iosAllowSignup = false
    public var buttonRecord = ""
    public var buttonStopRecord = ""
    public var recordStatusRecorded = ""
    public var recordStatusRecording = ""
    public var recordStatusScheduled = ""
    public var enableNdvr = false
    public var supportVideoAds = false
    public var supportBannerAds = false
    public var supportInterstitialAds = false
    public var supportNativeAds = false
    public var BannerAdUnitIdIos = ""
    public var BannerAdUnitIdPlayerIos = ""
    public var NativeAdUnitId = ""
    public var validMobileRegex = ""
    public var supportLocalytics = false
    public var supportFirebase = false
    public var supportCleverTap = false
    public var lmsEntryUrl = ""
    public var nextVideoDisplayPercentage  = 99;
    public var nextVideoDisplaySeconds = 30;
    public var nextVideoDisplayType = "P";
    public var aboutUsPageUrl = ""
    public var contactUsPageUrl = ""
    public var faqPageUrl = ""
    public var privacyPolicyPageUrl = ""
    public var termsConditionsPageUrl = ""
    public var helpPageUrl = ""
    public var resSErrorNeedPaymentIos = ""
    public var resSErrorNotLoggedInIos = ""
    public var signinTitle = ""
    public var signupTitle = ""
    public var activeScreensTitleFromPlayer = ""
    public var activeScreensTitleFromSettings = ""
    public var webPaymentUpgradeMessage = ""
    public var amazonPaymentUpgradeMessage = ""
    public var rokuPaymentUpgradeMessage = ""
    public var allowedCountriesList = ""
    public var iosBuyMessage = ""
    public var helpJsonString = ""
    public var megaMenuSections = ""
    public var noPlanButtonText = ""
    public var noPlanMessageText = ""
    public var noPlanMessageDescription = ""
    public var basicPlanButtonText = ""
    public var basicPlanMessageText = ""
    public var basicPlanMessageDescription = ""
    public var playLastChannelOnLaunch = false
    public var maxdvrtime : Int = 0
    public var maxDvrDisplayText = ""
    public var startOverTextMessage = ""
    public var showStreamBitRate = false
    public var tvshowPlayerRecommendationText = ""
    public var tvshowDetailsRecommendationText = ""
    public var movieDetailsRecommendationText = ""
    public var moviePlayerRecommendationText = ""
    public var channelRecommendationText = ""
    public var favouritesTargetPath = ""
    public var myPurchasesTargetPathMobiles = ""
    public var videoQualitySettings = ""
    public var offlineDownloadExpiryDays = -1
    public var offlineDownloadsLimit = -1
    public var offlineContentExpiryTagInHours = -1
    public var cookiePolicyPageUrl = ""
    public var viewAllText = ">"
    public var parentalControlPinLength = 0
    public var parentalControlPopupMessage = ""
    public var grievanceRedressalUrl = ""
    public var complianceReport = ""
    public var maxBitRate = -1
    public var interstitialStaticPopup = ""
    public var previewMessageIos = ""
    public var showIosPackageVersion = ""
    public var showIosPackages = false
    public var themeColoursList = ""
    public var forgotPasswordViaWebportal = false
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        isOTPSupported = (getString(value: json["isOTPSupported"]) != "false")
        isSocialMediaSharingSupported = (getString(value: json["isSocialMediaSharingSupported"]) != "false")
        supportChromecast = ((getString(value: json["supportChromecast"]) != "false") && !(getString(value: json["supportChromecast"]) .isEmpty))
        isFacebookLoginSupported = getBool(value: json["isFacebookLoginSupported"])
        supportGoogleLogin = getBool(value: json["supportGoogleLogin"])
        supportAppleLogin = getBool(value: json["supportAppleLogin"])
        isCallSupported = (getString(value: json["isCallSupported"]) != "false")

        siteURL = getString(value: json["siteURL"])
        if let max = Int(getString(value: json["maxOTPLength"])) {
            maxOTPLength = max
        }
        primaryTimeZone = getString(value: json["primaryTimeZone"])
        primaryTimeZoneOffset = getString(value: json["primaryTimeZoneOffset"])
        callingNumber = getString(value: json["callingNumber"])
        iosAllowSignup = getBool(value: json["iosAllowSignup"])
        buttonRecord = getString(value: json["buttonRecord"])
        buttonStopRecord = getString(value: json["buttonStopRecord"])
        recordStatusRecorded = getString(value: json["recordStatusRecorded"])
        recordStatusRecording = getString(value: json["recordStatusRecording"])
        recordStatusScheduled = getString(value: json["recordStatusScheduled"])
        enableNdvr = (getString(value: json["enableNdvr"]) != "false")
        supportVideoAds = getBool(value: json["supportVideoAds"])
        supportBannerAds = getBool(value: json["supportBannerAds"])
        supportInterstitialAds = getBool(value: json["supportInterstitialAds"])
        supportNativeAds = getBool(value: json["supportNativeAds"])

        BannerAdUnitIdIos = getString(value: json["bannerAdUnitIdIos"])
        BannerAdUnitIdPlayerIos = getString(value: json["bannerAdUnitIdPlayerIos"])
        NativeAdUnitId = getString(value: json["BannerAdUnitId"])
        supportFirebase = (getString(value: json["supportFirebase"]) != "false")
        supportLocalytics = (getString(value: json["supportLocalytics"]) != "false")
        supportCleverTap = (getString(value: json["supportCleverTap"]) != "false")
        lmsEntryUrl = getString(value: json["lmsEntryUrl"])
        validMobileRegex = getString(value: json["validMobileRegex"])

        

        
        nextVideoDisplayPercentage = getInt(value: json["nextVideoDisplayPercentage"])
        nextVideoDisplaySeconds = getInt(value: json["nextVideoDisplaySeconds"])
        nextVideoDisplayType = getString(value: json["nextVideoDisplayType"])
        

        aboutUsPageUrl = getString(value: json["aboutUsPageUrl"])
        helpPageUrl = getString(value: json["helpPageUrl"])
        contactUsPageUrl = getString(value: json["contactUsPageUrl"])
        faqPageUrl = getString(value: json["faqPageUrl"])
        privacyPolicyPageUrl = getString(value: json["privacyPolicyPageUrl"])
        termsConditionsPageUrl = getString(value: json["termsConditionsPageUrl"])
        cookiePolicyPageUrl = getString(value: json["cookiePolicyPageUrl"])
        resSErrorNeedPaymentIos = getString(value: json["resSErrorNeedPaymentIos"])
        resSErrorNotLoggedInIos = getString(value: json["resSErrorNotLoggedInIos"])
        signinTitle = getString(value: json["signinTitle"])
        signupTitle = getString(value: json["signupTitle"])

        activeScreensTitleFromPlayer = getString(value: json["activeScreensTitleFromPlayer"])
        activeScreensTitleFromSettings = getString(value: json["activeScreensTitleFromSettings"])
        
        
        webPaymentUpgradeMessage = getString(value: json["webPaymentUpgradeMessage"])
        amazonPaymentUpgradeMessage = getString(value: json["amazonPaymentUpgradeMessage"])
        rokuPaymentUpgradeMessage = getString(value: json["rokuPaymentUpgradeMessage"])
        allowedCountriesList = getString(value: json["allowedCountriesList"])
        iosBuyMessage = getString(value: json["iosBuyMessage"])
        helpJsonString = getString(value: json["helpJsonString"])
        megaMenuSections = getString(value: json["megaMenuSections"])

 
        
        noPlanButtonText = getString(value: json["noPlanButtonText"])
        noPlanMessageText = getString(value: json["noPlanMessageText"])
        noPlanMessageDescription = getString(value: json["noPlanMessageDescription"])
        basicPlanButtonText = getString(value: json["basicPlanButtonText"])
        basicPlanMessageText = getString(value: json["basicPlanMessageText"])
        basicPlanMessageDescription = getString(value: json["basicPlanMessageDescription"])
        playLastChannelOnLaunch = getBool(value: json["playLastChannelOnLaunch"])
        maxdvrtime = getInt(value: json["maxdvrtime"])
        maxDvrDisplayText = getString(value: json["maxDvrDisplayText"])
        startOverTextMessage = getString(value: json["startOverTextMessage"])
        showStreamBitRate = getBool(value: json["showStreamBitRate"])
        
        tvshowPlayerRecommendationText = getString(value: json["tvshowPlayerRecommendationText"])
        tvshowDetailsRecommendationText = getString(value: json["tvshowDetailsRecommendationText"])
        movieDetailsRecommendationText = getString(value: json["movieDetailsRecommendationText"])
        moviePlayerRecommendationText = getString(value: json["moviePlayerRecommendationText"])
        channelRecommendationText = getString(value: json["channelRecommendationText"])
        if PreferenceManager.appName != .gac {
            favouritesTargetPath = getString(value: json["favouritesTargetPath"])
        }
        
        myPurchasesTargetPathMobiles = getString(value: json["myPurchasesTargetPathMobiles"])
        videoQualitySettings = getString(value: json["videoQualitySettingsIos"])
        
        if let expiry = Int(getString(value: json["offlineDownloadExpiryDays"])), expiry > 0 {
            offlineDownloadExpiryDays = expiry
        }
        if let limit = Int(getString(value: json["offlineDownloadsLimit"])), limit > 0 {
            offlineDownloadsLimit = limit
        }
        if let hours = Int(getString(value: json["offlineContentExpiryTagInHours"])), hours > 0 {
            offlineContentExpiryTagInHours = hours
        }
        parentalControlPinLength = getInt(value: json["parentalControlPinLength"])
        parentalControlPopupMessage = getString(value: json["parentalControlPopupMessage"])
        if getString(value: json["viewAllText"]).count > 0 {
            viewAllText = getString(value: json["viewAllText"])
        }else {
            viewAllText = ">"
        }
        supportCleverTap = (getString(value: json["supportCleverTap"]) != "false")
        lmsEntryUrl = getString(value: json["lmsEntryUrl"])
        validMobileRegex = getString(value: json["validMobileRegex"])
        grievanceRedressalUrl = getString(value: json["grievanceRedressalUrl"])
        if let _maxBitRate = json["maxBitRateIos"] {
            maxBitRate = getInt(value: _maxBitRate)
        }
    
        complianceReport = getString(value: json["complianceReport"])
        if let _ = json["interstitialStaticPopup"] {
            interstitialStaticPopup = getString(value: json["interstitialStaticPopup"])
        }
        previewMessageIos = getString(value: json["previewMessageIos"])
        showIosPackageVersion = getString(value: json["showIosPackageVersion"])
        showIosPackages = getBool(value: json["showIosPackages"])
        themeColoursList = getString(value: json["themeColoursList"])
        forgotPasswordViaWebportal = getBool(value: json["forgotPasswordViaWebportal"])
    }
}

public class ClientConfig: YuppModel {
    
    public var bannersPerPageMaxLimit = 0;
    public var catchupTvMaxDays = 0;
    public var contentLanguagesMaxLimit = 0;
    public var livetvChannelsMaxLimit = 0;
    public var primaryTimeZone = "";
    public var primaryTimeZoneOffset = "+03:00";
    public var siteUrl = "";
    public var supportFacebookLogin = "";
    public var supportOtp = "";
    public var supportSocialMediaSharing = "";
    public var welcomeVideoUrl = "";
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        if let max = Int(getString(value: json["bannersPerPageMaxLimit"])) {
            bannersPerPageMaxLimit = max
        }
        if let max = Int(getString(value: json["catchupTvMaxDays"])) {
            catchupTvMaxDays = max
        }
        if let max = Int(getString(value: json["contentLanguagesMaxLimit"])) {
            contentLanguagesMaxLimit = max
        }
        
        if let max = Int(getString(value: json["livetvChannelsMaxLimit"])) {
            livetvChannelsMaxLimit = max
        }

        primaryTimeZone = getString(value: json["primaryTimeZone"])
        primaryTimeZoneOffset = getString(value: json["primaryTimeZoneOffset"])
        siteUrl = getString(value: json["siteUrl"])
        supportFacebookLogin = getString(value: json["supportFacebookLogin"])
        supportOtp = getString(value: json["supportOtp"])
        supportSocialMediaSharing = getString(value: json["supportSocialMediaSharing"])
        welcomeVideoUrl = getString(value: json["welcomeVideoUrl"])
    }
}

public class SystemFeaturesModel : YuppModel {
    public var otpauthentication = OTPAuthenticationModel()
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _otpauthentication = json["otpauthentication"] as? [String : Any]{
            otpauthentication = OTPAuthenticationModel.init(_otpauthentication)
        }
    }
}
public class OTPAuthenticationModel : YuppModel {
    public var fields = FieldsModel()
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _fields = json["fields"] as? [String : Any]{
            fields = FieldsModel.init(_fields)
        }
    }
}
public class FieldsModel : YuppModel {
    public var verify_otp_for_email_update = false
    public var verify_otp_for_mobile_update = false
    public var otp_verification_order = ""
    public var otp_resend_time = ""
    public var otp_length = -1
    public var verification_type_for_mobile_update = ""
    public var forgot_password_identifier_type = ""
    public var verification_type_for_email_update = ""
    public var max_otp_resend_attempts = -1
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let max = Int(getString(value: json["otp_length"])) {
            otp_length = max
        }
        verify_otp_for_email_update = getBool(value: json["verify_otp_for_email_update"])
        verify_otp_for_mobile_update = getBool(value: json["verify_otp_for_mobile_update"])
        otp_verification_order = getString(value: json["otp_verification_order"])
        otp_resend_time = getString(value: json["otp_resend_time"])
        verification_type_for_mobile_update = getString(value: json["verification_type_for_mobile_update"])
        forgot_password_identifier_type = getString(value: json["forgot_password_identifier_type"])
        verification_type_for_email_update = getString(value: json["verification_type_for_email_update"])
        
        if let otpAttempts = Int(getString(value: json["max_otp_resend_attempts"])), otpAttempts > 0 {
            max_otp_resend_attempts = otpAttempts
        }
    }
}
