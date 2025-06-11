//
//  Constants.swift
//  OTT
//
//  Created by Muzaffar on 20/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class Constants: NSObject {
    struct OTTUrls {
        static let aboutUsUrl = AppDelegate.getDelegate().configs?.aboutUsPageUrl
        static let termsUrl = AppDelegate.getDelegate().configs?.termsConditionsPageUrl
        static let contactUsUrl = AppDelegate.getDelegate().configs?.contactUsPageUrl
        static let privacyPolicyUrl = AppDelegate.getDelegate().configs?.privacyPolicyPageUrl
        static let faqsUrl = AppDelegate.getDelegate().configs?.faqPageUrl
        static let helpPageUrl = AppDelegate.getDelegate().configs?.helpPageUrl
        static let cookiesPageUrl = AppDelegate.getDelegate().configs?.cookiePolicyPageUrl

        #warning("appstore link")
        static var appStoreLink : String {
            get {
                switch appContants.appName {
                case .firstshows:
                    return "itms-apps://itunes.apple.com/app/1546724274?mt=8"
                case .reeldrama:
                    return "itms-apps://itunes.apple.com/app/1545887975?mt=8"

                case .tsat:
                    return "itms-apps://itunes.apple.com/app/id1281968183?mt=8"
                case .aastha:
                    return "itms-apps://itunes.apple.com/app/id1475090689?mt=8"
                case .gotv:
                    return "itms-apps://itunes.apple.com/app/id1475090689?mt=8"
                case .yvs:
                    return "itms-apps://itunes.apple.com/app/id1475090689?mt=8"
                case .supposetv:
                    return "itms-apps://itunes.apple.com/app/id6443846621?mt=8"
                case .mobitel:
                    return "itms-apps://itunes.apple.com/app/id1617811699?mt=8"
                case .pbns:
                    #warning("T##message##")
                    return "itms-apps://itunes.apple.com/app/id1617811699?mt=8"
                case .gac:
                    return "itms-apps://itunes.apple.com/app/id1643879437?mt=8"
                case .airtelSL:
                    #warning("T##message##")
                    return "itms-apps://itunes.apple.com/app/id1617811699?mt=8"
                default:
                    return "itms-apps://itunes.apple.com/app/1504380245?mt=8"
                }
            }
        }
        static var appStoreLinkWithHttp : String {
            get {
                switch appContants.appName {
                case .firstshows:
                    return "https://apps.apple.com/app/id1546724274"
                case .reeldrama:
                    return "https://apps.apple.com/app/id1545887975"
                case .tsat:
                    return "https://apps.apple.com/app/id1281968183"
                case .aastha:
                    return "https://apps.apple.com/app/id1475090689"
                case .gotv:
                    return "https://apps.apple.com/app/id1475090689"
                case .yvs:
                    return "https://apps.apple.com/app/id1475090689"
                case .supposetv:
                    return "https://apps.apple.com/app/id6443846621"
                case .mobitel:
                    return "https://apps.apple.com/app/id1617811699"
                case .pbns:
                    #warning("T##message##")
                    return "https://apps.apple.com/app/id1617811699"
                case .gac:
                    return "https://apps.apple.com/app/id1643879437"
                case .airtelSL:
                    #warning("T##message##")
                    return "https://apps.apple.com/app/id1617811699"
                default:
                    return "https://apps.apple.com/app/id1546724274"
                }
            }
        }
        #warning("GoogleCast Key")
        static var googleChromeCastId : String {
            get {
                switch appContants.appName {
                case .firstshows:
                    if appContants.serviceType == .live {
                        return "7618DAB2"
                    }
                    else {
                        return "7618DAB2"
                    }
                case .reeldrama:
                    if appContants.serviceType == .live {
                        return "DB962380"
                    }
                    else {
                        return "DB962380"
                    }
                case .tsat:
                    if appContants.serviceType == .live {
                        return "DBCFC433"
                    }
                    else {
                        return "DBCFC433"
                    }
                case .aastha:
                    if appContants.serviceType == .live {
                        return "45758530"
                    }
                    else {
                        return "45758530"
                    }
                case .gotv:
                    if appContants.serviceType == .live {
                        return "B468E700"
                    }
                    else {
                        return "B468E700"
                    }
                case .yvs:
                    if appContants.serviceType == .live {
                        return "6AC157B3"
                    }
                    else {
                        return "6AC157B3"
                    }
                case .supposetv:
                    if appContants.serviceType == .live {
                        return "3A22D432"
                    }
                    else {
                        return "3A22D432"
                    }
                case .mobitel:
                    if appContants.serviceType == .live {
                        return "7D842F07"
                    }
                    else {
                        return "7D842F07"
                    }
                case .pbns:
                    if appContants.serviceType == .live {
                        return "6AC157B3"
                    }
                    else {
                        return "6AC157B3"
                    }
                case .gac: 
                    if appContants.serviceType == .live {
                        return "CA562632"
                    }
                    else {
                        return "CA562632"
                    }
                case .airtelSL:
                    #warning("check the hard coded text")
                    if appContants.serviceType == .live {
                        return "6AC157B3"
                    }
                    else {
                        return "6AC157B3"
                    }
                }
            }
        }
        #warning("CleverTap Id and Token")
        static var cleverTapIdAndToken : (id : String, token : String) {
            get {
                switch appContants.appName {
                case .firstshows:
                    if appContants.serviceType == .live {
                        return ("6R4-K66-RW6Z", "663-426")
                    }
                    else {
                        return ("TEST-7R4-K66-RW6Z", "TEST-663-42a")
                    }
                case .reeldrama:
                    if appContants.serviceType == .live {
                        return ("4R4-K66-RW6Z", "663-424")
                    }
                    else {
                        return ("TEST-5R4-K66-RW6Z", "TEST-663-425")
                    }
                case .tsat:
                    if appContants.serviceType == .live {
                        return ("6ZR-7Z8-755Z", "b1a-216")
                    }
                    else {
                        return ("TEST-7ZR-7Z8-755Z", "TEST-b1a-21a")
                    }
                case .aastha:
                    if appContants.serviceType == .live {
                        return ("8WR-RR4-555Z", "422-20b")
                    }
                    else {
                        #warning("need to update keys")
                        return ("TEST-9WR-RR4-555Z", "TEST-422-20c")
                    }
                case .gotv:
                    if appContants.serviceType == .live {
                        return ("8WR-RR4-555Z", "422-20b")
                    }
                    else {
                        #warning("need to update keys")
                        return ("TEST-9WR-RR4-555Z", "TEST-422-20c")
                    }
                case .yvs:
                    if appContants.serviceType == .live {
                        return ("8WR-RR4-555Z", "422-20b")
                    }
                    else {
                        #warning("need to update keys")
                        return ("TEST-9WR-RR4-555Z", "TEST-422-20c")
                    }
                case .supposetv:
                    if appContants.serviceType == .live {
                        return ("", "")
                    }
                    else {
                        return ("", "")
                    }
                case .mobitel:
                    //not required for mobitel
                     if appContants.serviceType == .live {
                        return ("", "")
                    }
                    else {
                         return ("", "")
                    }
                case .pbns:
                    //not required for pbns
                     if appContants.serviceType == .live {
                        return ("", "")
                    }
                    else {
                         return ("", "")
                    }
                case .gac:
                    //not required for pbns
                     if appContants.serviceType == .live {
                        return ("", "")
                    }
                    else {
                         return ("", "")
                    }
                case .airtelSL:
                    //not required for pbns
                     if appContants.serviceType == .live {
                        return ("", "")
                    }
                    else {
                         return ("", "")
                    }
                }
            }
        }
        #warning("AnalyticsKey")
        static let Analyticskey: String = {
            switch appContants.appName {
            case .firstshows:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "074851e6c79ddc7a9988a4a3cb95c251"
                }else {
                    return "074851e6c79ddc7a9988a4a3cb95c251"
                }
            case .reeldrama:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "2181d5925b285dc9741cc66a34a719a7"
                }else {
                    return "2181d5925b285dc9741cc66a34a719a7"
                }
            case .tsat:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "efce63488b621a3ea0bbdc19f42a5ff6"
                }else {
                    return "efce63488b621a3ea0bbdc19f42a5ff6"
                }
            case .aastha:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "bc06c22496264d62447604a9f52ae0d9"
                }else {
                    return "bc06c22496264d62447604a9f52ae0d9"
                }
            case .gac: 
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "a83a7068ee33bf431566a2dc04731e90"
                }else {
                    return "a83a7068ee33bf431566a2dc04731e90"
                }
            case .gotv:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "4df84aed32532df34fd9a8bacdc5ae4b"
                }else {
                    return "4df84aed32532df34fd9a8bacdc5ae4b"
                }
            case .yvs:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }else {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }
            case .supposetv:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "4ecfc2c826dfe4e0d0a3e5934934c9d0"
                }else {
                    return "4ecfc2c826dfe4e0d0a3e5934934c9d0"
                }
            case .mobitel:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "131cc3c56b2b01e8b3e5560554acc1a2"
                }else {
                    return "131cc3c56b2b01e8b3e5560554acc1a2"
                }
            case .pbns:
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }else {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }
            case .airtelSL:
                #warning("check with hard coded text")
                if appContants.serviceType == PreferenceManager.SerViceType.live {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }else {
                    return "5969378c6fc4d08aa1a47149020c2cd2"
                }
            }
        }()
        #warning("Google Sdk key")
        static let googleSDKKey : String = {
            switch appContants.appName {
            case .firstshows: return "685816069664-k0s00equijka57fo0ovi9a4nbtco93ta.apps.googleusercontent.com"
            case .reeldrama: return "945925342452-ljt986ema2fl6hl0k7okc258fma7e88g.apps.googleusercontent.com"
            case .tsat: return "285659389658-4s6o4jeod7k5bfo2csfr2orgd420su28.apps.googleusercontent.com"
            case .aastha: return "1057165244751-947bunhoss6klmj2guc5gmrc1oovbi31.apps.googleusercontent.com"
            case .gotv: return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .yvs: return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .supposetv:
                #warning("T##message##")
                return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .mobitel:
                #warning("T##message##")
                return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .pbns:
                #warning("T##message##")
                return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .gac:
                #warning("T##message##")
                return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            case .airtelSL:
                #warning("T##message##")
                return "167853369191-hhol9abhu890daen2oqpbaibimj7s9aq.apps.googleusercontent.com"
            }
        }()
    }
    
    static let displayLanguages = [ Language(["code" : "POT", "name" : "Portuguese"]),
                                    Language(["code" : "ENG", "name" : "English"])]
    static let defaultDisplayLanguage = ["ENG"]
    
    static let actionFileTypeHeading = "Add a File"
    static let actionFileTypeDescription = "Choose a filetype to add..."
    static let camera = "Camera"
    static let phoneLibrary = "Phone Library"
    static let video = "Video"
    static let file = "File"
    
    
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    
    static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    
    
    static let settingsBtnTitle = "Settings"
    static let cancelBtnTitle = "Cancel"

}

