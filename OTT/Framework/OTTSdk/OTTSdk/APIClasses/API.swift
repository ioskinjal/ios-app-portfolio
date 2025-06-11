//
//  API.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class API: NSObject {
    
    internal struct Requests{
        internal static var appInitialRequest : String {
            if PreferenceManager.appName == .reeldrama {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/test/reeldrama.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/test/reeldrama.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json";
                }
            }else if PreferenceManager.appName == .firstshows {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/firstshows/init/live/firstshows.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/firstshows/init/live/firstshows.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/firstshows/init/test/firstshows.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-firstshows.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/firstshows/init/test/firstshows.json";
                }
            }else if PreferenceManager.appName == .aastha {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/aastha/init/aastha-v1.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/aastha/init/aastha_fusion.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-aastha.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://d2k02uhj7uybok.cloudfront.net/init/dishtv/test/dishtv.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/aastha/init/aastha-v1.json";
                }
            }else if PreferenceManager.appName == .gac {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/gacmedia/live/gacmedia.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/gacmedia/uat/gacmedia-uat.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/gacmedia/beta/gacmedia-beta.json"
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/gacmedia/beta/gacmedia-beta.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/gacmedia/live/gacmedia.json"
                }
            }else if PreferenceManager.appName == .tsat {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/tsat/init/tsat-v1.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/tsat/init/tsat_fusion.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/tsat/init/tsat_fusion.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas.globaltakeoff.net/clients/beta1/manatv/init/tsat_dev.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/tsat/init/tsat-v1.json";
                }
            }
            else if PreferenceManager.appName == .gotv {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/gotv/init/live/gotv.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/gotv/init/uat/gotv.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/gotv/init/uat/gotv.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/gotv/init/uat/gotv.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/gotv/init/uat/gotv.json";
                }
            }
            else if PreferenceManager.appName == .yvs {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/yvs/init/live/yvs.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/yvs/init/live/yvs.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/yvs/init/live/yvs.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/yvs/init/live/yvs.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/yvs/init/live/yvs.json";
                }
            }
            else if PreferenceManager.appName == .supposetv {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/levelnews/init/live/levelnews.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/levelnews/init/uat/levelnews.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/levelnews/init/uat/levelnews.json"
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/levelnews/init/uat/levelnews.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/levelnews/init/live/levelnews.json"
                }
            }
            else if PreferenceManager.appName == .mobitel {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/slt/live/slt-live.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-mobitel.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-mobitel.json"
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-mobitel.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/slt/live/slt-live.json"
                }
            }
            else if PreferenceManager.appName == .pbns {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json";
                }
            }
            else if PreferenceManager.appName == .airtelSL {
                if  PreferenceManager.serviceType == .live {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/fusion/init/fusion-aastha.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/yvs/init/test/yvs-fusion.json";
                }
            }
            else {
                if  PreferenceManager.serviceType == .live {
                    return "https://https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json"
                }
                else if PreferenceManager.serviceType == .UAT {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json"
                }
                else if PreferenceManager.serviceType == .beta {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/test/reeldrama.json";
                }
                else if PreferenceManager.serviceType == .beta2 {
                    return "https://paas-init.revlet.net/clients/reeldrama/init/test/reeldrama.json"
                }
                else{
                    return "https://paas-init.revlet.net/clients/reeldrama/init/live/reeldrama.json";
                }
            }
        }
        internal static var api = ""
        internal static var location = ""
        internal static var search = ""
        internal static var heURL = ""
        internal static var pgURL = ""
        internal static var otpURL = ""
    }
    
    /**
     Block the user if isSupported is false. varies in intial request
     */
    internal static var isSupported = false
    
    struct ErrorCode {
        static let Success = 200
        static let Unauthorized = 401
        static let Forbidden = 403
        static let RequestResourceNotFound = 404
        static let BadRequest = 400
        static let MethodNotAllowed = 405
        
        /// some random number. apple's Error
        static let SystemError = -1123
        
        /// some random number. when unable to get error message
        static let DefaultError = -1124
        
         /// some random number. when unable to get error message
        static let ApiErrorInText = -1125
    }
    
    public class var instance: API {
        struct Singleton {
            static let obj = API()
        }
        return Singleton.obj
    }
    
    //MARK: - Url Formation
 /*   static var domain : String{
     
        if PreferenceManager.isLive{
            return ""
        }
        else{
            return "http://54.145.173.246:80/"
        }
    }*/
    
    internal struct baseUrl {
        static let version = "/v1"
        static let version2 = "/v2"

        static let api = Requests.api + "/service/api" + version
        static let dateApi = Requests.api + "/service/api"
        static let location = Requests.location + "/service/location/api" + version
        static let search = Requests.search + "/service/api" + version
        
        static let auth = Requests.api + "/service/api/auth"
        static let otpAuth = Requests.otpURL + "/service/api/auth"
        static let authVersion = Requests.api + "/service/api/auth" + version
        static let authVersion2 = Requests.api + "/service/api/auth" + version2
        static let paymentUnSubscribeURl = Requests.api + "/payment/api/v1/cancel/subscription"
    }
    
    internal struct url {
        
        // ---------------- Global ----------------
        
        /// Location service API:
        static let locationinfo = baseUrl.location + "/locationinfo"
        
        /// Token Generation API:
        static let getToken = baseUrl.api + "/get/token"
        
        /// App/Site configuration API: has menu, resource profiles and configs
        static let config = baseUrl.api + "/system/config"
        
        
        
        // ---------------- Media ----------------
        
        /// Media Catalog
        static let pageContent = baseUrl.api + "/page/content"
        
        
        /// Page Section Content
        static let sectionContent = baseUrl.api + "/section/data"
       
        /// Feedback
              static let contentFeedback = baseUrl.auth + "/content/feedback/submit"

        
        /// Next video Content
        static let nextVideoContent = baseUrl.api + "/next/videos"
        static let nextEpgContent = baseUrl.api + "/next/epgs"
        
        /// Page Section Content
        static let commonCards = baseUrl.api + "/common/cards"

        /// Stream
        static let stream = baseUrl.api + "/page/stream"
        
        /// TV GUIDE Content
        static let tvGuideContent = baseUrl.api + "/tv/guide"

        /// Get TV GUIDE Channels
        static let getTVGuideChannels = baseUrl.api + "/tvguide/channels"

        /// Get Programs For Channels
        static let getProgramForChannels = baseUrl.api + "/static/tvguide"

        /// Get Programs For Channels
        static let getUserDataForChannels = baseUrl.api + "/tvguide/user/data"

        /// TV GUIDE Template
        static let template = baseUrl.api + "/template"

        /// TV GUIDE Template Data
        static let templateData = baseUrl.api + "/template/data"

        /// TV GUIDE Template List
        static let templateList = baseUrl.api + "/templates"

        /// Current Date
        static let currentDate = baseUrl.dateApi + "/ping"

        /// Encrypted Stream
        static let encryptedStream = baseUrl.api + "/send"
        /// ContentDownloadRequest
        static let contentDownloadRequest = baseUrl.api + "/content/download/request"

        /// DeleteDownloadVideoRequest
        static let deleteDownloadVideoRequest = baseUrl.api + "/get/delete/videos"
        /// Countries
        static let countries = baseUrl.api + "/get/country"
        
        /// Stream Active Sessions
        static let streamActiveSessions = baseUrl.api + "/stream/active/sessions"
        
        /// Stream Poll
        static let streampoll = baseUrl.api + "/stream/poll"
        
        /// Stream Session End
        static let streamSessionEnd = baseUrl.api + "/stream/session/end"

        /// Get Recording Form
        static let getRecordingForm = baseUrl.api + "/form"

        /// Submit Recording Form
        static let submitRecordingForm = baseUrl.api + "/form/submit"

        /// Search suggestions
        static let searchSuggestions = baseUrl.search + "/search/suggestions"
        
        /// Search query
        static let searchQuery = baseUrl.search + "/get/search/query"
        
        /// Monthly Planner API
        static let monthlyPlanner = baseUrl.api + "/monthly/planner/data"
        
        /// List of Months API
        static let monthlyList = baseUrl.api + "/data/set/element"
      
        
        // ---------------- AUTH ----------------
        
        /// Record URL
        static let recordURL = baseUrl.auth + "/dvr/record"

        /// Submit Question
        static let submitQuestion = baseUrl.auth + "/add/question"

        /// Fetch Questions
        static let fetchQuestions = baseUrl.auth + "/get/user/questions"

        /// Get User Form Elements
        static let getUserFormElemets = baseUrl.api + "/get/field/configuration"

        /// SignIn
        static let signin = baseUrl.auth + "/signin"
        
        static let signin_v1 = baseUrl.authVersion + "/signin"
        /// SignInWithEncryption
        static let signInWithEncryption = baseUrl.api + "/send"
        
        /// SocialSignIn
        static let socialSignin = baseUrl.authVersion + "/signin"

        /// Name: Signup
        static let signup = baseUrl.auth + "/signup/validate"

        /// Name: Signup OTP Verificatiopn
        static let signupOTPVerification = baseUrl.auth + "/signup/complete"

        /// Name: SocialSignup
        static let socialSignup = baseUrl.authVersion2 + "/signup"

        /// signout
        static let signout = baseUrl.auth + "/signout"
        
        /// UserInfo
        static let userInfo = baseUrl.auth + "/user/info"
        
        /// UpdatePreference
        static let updatePreference = baseUrl.auth + "/update/preference"
       
        /// Get Otp
        static let getOtp = baseUrl.otpAuth + "/get/otp"
        
        /// User Get Otp
        static let userGetOtp = baseUrl.otpAuth + "/user/get/otp"
        
        /// Resend Otp
        static let resendOtp = baseUrl.otpAuth + "/resend/otp"
        
        /// Verify Email
        static let verifyEmail = baseUrl.auth + "/verify/email"
        
        /// Verify Mobile
        static let verifyMobile = baseUrl.auth + "/verify/mobile"

        /// Verify OTP
        static let verifyOTP = baseUrl.auth + "/verify/otp"

        /// Update Password
        static let updatePassword = baseUrl.auth + "/update/password"
        
        /// Update Mobile
        static let updateMobileNumber = baseUrl.auth + "/update/mobile"
        /// Update Email
        static let updateEmailId = baseUrl.auth + "/update/email"
        /// Change Password
        static let changePassword = baseUrl.auth + "/change/password"

        /// Linked Device List
        static let linkedDevicesList = baseUrl.auth + "/linked/devices/list"
        
        /// DeLink device
        static let delinkDevice = baseUrl.auth + "/delink/device"
        
        /// User Active Packages
        static let activePackages = baseUrl.auth + "/user/activepackages"
        
        /// Transaction history
        static let transactionHistory = baseUrl.auth + "/transaction/history"
        
        /// Session Preference
        static let sessionPreference = baseUrl.auth + "/update/session/preference"
        /// User Favourites List
        static let userFavourites = baseUrl.auth + "/user/favourites/list"
        
        /// Add or Delete User Favourite Item
        static let userFavouriteItem = baseUrl.auth + "/user/favourite/item"
        
        /// MyQuestions genres list
        static let myQuestionsGenresList = baseUrl.api + "/genres"
       
        /// MyQuestions genres content list
        static let myQuestionsGenresContentList = baseUrl.api + "/genres/content"
        
        /// MyQuestionsList
        static let myQuestionsList = baseUrl.api + "/my/questions"
        
        // Status for Request for Pivacy Policy & Cookie Policy
        static let userConsentRequest = baseUrl.auth + "/consent/request"

        /// Status for Pivacy Policy & Cookie Policy
        static let userConsentStatus = baseUrl.auth + "/consent/status"
        
        /// System Features API
        static let otpFeatures = baseUrl.api + "/system/feature"
        
        /// Create Parental control PIN Api
        static let createParentalPin = baseUrl.auth + "/create/user/profile/lock"
       
        /// UPdate Parental control PIN Api
        static let updateParentalPin = baseUrl.auth + "/update/user/profile/lock"
        
        /// Validate Parental control PIN Api
        static let validateParentalPin = baseUrl.auth + "/validate/pin"
        
        /// Forgot Pin Authentication
        static let authenticatePassword = baseUrl.auth + "/user/authentication"
    }
    
    //MARK: - Declarations
    internal enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
    }
    
    //MARK: - API Calls
    
    /**
     This function is the root request call for all APIs. Common Headers and exceptions will be handeled here.. if Session-id is not initiated or expired, will be fetched internally and recalls the request.
     
     - Parameters: 
         - baseUrl: Url Path without arguments
         - parameters: list of arguments
             *(EX: email=muzaffar.mtech@gmail.com&password=yuppTV)*
         - methodType: get or post
         - info: add additional headers with predefined key structure
         - logString: Prefix of the log to deferentiate all logs
         - completionHandler: returns data as (responseData, response, error)
             - Data: response data
             - URLResponse: response
             - Error: *Error* if any
     - Returns: void
     */
    
    internal func request(baseUrl : String, parameters : String, methodType : HTTPMethod, info : [String : Any]?,logString : String, onSuccess:@escaping (Any) -> Swift.Void, onFailure : @escaping(APIError) -> Swift.Void){
        baseRequest(baseUrl: baseUrl, parameters: parameters, methodType: methodType, info: info, logString: logString) { (data, response, error) in
            if error != nil {
                let _error = APIError.init(withError: error!)
                onFailure(_error)
                return
            }
            if data != nil{
                do {
                    if logString == "CurrentDate" || logString == "HeaderEnrichment" {
                        onSuccess(response)
                    }
                    else {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]{
                            if jsonResult["status"] as? Bool == true{
                                
                                guard let _response = jsonResult["response"] else {
                                    onFailure(APIError.defaultError())
                                    return
                                }
                                onSuccess(_response)
                                return
                            }
                            else{
                                if let errorDic = jsonResult["error"]  as? [String : Any]{
                                    onFailure(APIError(withResponse: errorDic))
                                    return
                                }
                                else{
                                    onFailure(APIError.defaultError())
                                    return
                                }
                            }
                        }
                        else{
                            print("Invalid Json. Expected [String : Any] type.")
                            onFailure(APIError.defaultError())
                        }
                    }
                } catch let error as NSError {
                    
                    guard let errorMessage = String(data: data!, encoding: .utf8) else {
                        onFailure(APIError(withError: error))
                        return
                    }
                    onFailure(APIError(withMessage:errorMessage))
                    return
                }
            }
            else{
                onFailure(APIError.defaultError())
                return
            }
        }
    }
    
    
    /**
     This function is the root request call for all APIs. Common Headers and exceptions will be handeled here.. if Session-id is not initiated or expired, will be fetched internally and recalls the request.
     
     - Parameters:
         - baseUrl: Url Path without arguments
         - parameters: list of arguments
             *(EX: email=muzaffar.mtech@gmail.com&password=yuppTV)*
         - methodType: get or post
         - info: add additional headers with predefined key structure
         - logString: Prefix of the log to deferentiate all logs
         - completionHandler: returns data as (responseData, response, error)
             - Data: response data
             - URLResponse: response
             - Error: *Error* if any
     - Returns: void
     */
    
    internal func baseRequest(baseUrl : String, parameters : String, methodType : HTTPMethod, info : [String : Any]?,logString : String, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Swift.Void){
        
        let allowedCharacters = NSCharacterSet.urlQueryAllowed
        guard let params = parameters.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else{
            completionHandler(nil, nil, nil)
            return
        }

        var request: URLRequest?
        if methodType == .get{
            let url = URL(string: baseUrl + "?" + params)!
            request = URLRequest(url: url)
            request?.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }
        else if methodType == .post{
            request = URLRequest(url: URL(string:baseUrl)!)
            request!.httpMethod = "POST"
            request?.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

            if let parameterDictionary = info?["DICTIONARY"] as? [String : Any]{
                do {
                    if logString == "Submit Question" {
                        var parameters = [[String : Any]]()
                        
                        if parameterDictionary["file_format"] != nil && parameterDictionary["attached-file"] != nil {
                            
                            let boundary = generateBoundaryString()

                            request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                            let imageData = parameterDictionary["attached-file"] as! Data

                            if(imageData==nil)  { return; }

                            request?.httpBody = createBodyWithParameters(parameters: parameterDictionary, filePathKey: "attached-file", imageDataKey: imageData as NSData, boundary: boundary) as Data
                            
                        }
                        else{
                            
                            parameters = [
                                [
                                    "key": "question",
                                    "value": parameterDictionary["question"] as! String,
                                    "type": "text"
                                ],
                                [
                                    "key": "path",
                                    "value": parameterDictionary["path"] as! String,
                                    "type": "text"
                                ],
                                [
                                    "key": "username",
                                    "value": parameterDictionary["username"] as! String,
                                    "type": "text"
                                ]] as [[String : Any]]
                            var body = ""
                            let boundary = "Boundary-\(UUID().uuidString)"
                            
                            
                            
                            for param in parameters {
                                if param["disabled"] == nil {
                                    let paramName = param["key"]!
                                    body += "--\(boundary)\r\n"
                                    body += "Content-Disposition:form-data; name=\"\(paramName)\""
                                    let paramType = param["type"] as! String
                                    if paramType == "text" {
                                        let paramValue = param["value"] as! String
                                        body += "\r\n\r\n\(paramValue)\r\n"
                                    } else {
                                        let paramSrc = param["src"] as! String
                                        let fileData = try parameterDictionary["attached-file"] as! Data
                                        let fileContent = String.init(data: fileData, encoding: .utf16)!
                                        //                              let fileContent = String(data: fileData, encoding: .utf8)!
                                        body += "; filename=\"\(paramSrc)\"\r\n"
                                            + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                                    }
                                }
                            }
                            body += "--\(boundary)--\r\n";
                            let postData = body.data(using: .utf8)
                            request?.httpBody = postData
                            request?.setValue("multipart/form-data; boundary=--------------------------321227926567292257005757", forHTTPHeaderField: "Content-Type")
                            request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                            
                        }
                    }else if baseUrl.contains(API.url.authenticatePassword) {
                        request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        var postData = ""
                        if let _password = parameterDictionary["password"] as? String {
                            postData = postData + "password=" + _password
                        }
                        if let _context = parameterDictionary["context"] as? String {
                            if postData.count > 0 {
                                postData = postData + "&"
                            }
                            postData = postData + "context=" + _context
                        }
                        let body = postData.data(using: .utf8)
                        request?.httpBody = body
                    }
                    else {
                        let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: .prettyPrinted)
                        request?.httpBody = jsonData
                        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }


                    
                } catch {
                    APILog.printMessage(message: "\n\(logString) : Unable to create JSON to form request", logType: .error)
                    completionHandler(nil, nil, nil)
                }
            }
            else{
                let postData = parameters.data(using: String.Encoding.utf8, allowLossyConversion: true)
                request!.httpBody = postData
                if postData != nil{
                    let postLength = String(describing: postData!.count)
                    request!.setValue(postLength, forHTTPHeaderField: "Content-Length")
                }
                request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }
        else{
            request = nil
            APILog.printMessage(message: "--------- Unable to form valid url for baseUrl : \(baseUrl) parameters : \(parameters)", logType: .error)
            completionHandler(nil, nil, nil)
        }
        
        if let headersDic = info?["HEADERS"] as? [String : String]{
                for key in headersDic.keys{
                    request?.setValue(headersDic[key], forHTTPHeaderField: key)
                }
        }
//        request!.setValue("46.38.243.211", forHTTPHeaderField: "True-Client-IP")x-up-calling-line-id
        request!.timeoutInterval = PreferenceManager.requestTimeout
        request!.setValue(PreferenceManager.sessionId, forHTTPHeaderField: "session-id")
        request!.setValue(PreferenceManager.boxId, forHTTPHeaderField: "box-id")
        request!.setValue(OTTSdk.preferenceManager.tenantCode, forHTTPHeaderField: "tenant-code")
        if logString == "HeaderEnrichment" {
            request!.setValue("940707878787", forHTTPHeaderField: "x-up-calling-line-id")
        }

        if PreferenceManager.logType != .none && logString != "Submit Question" {
            let type = (methodType == .get) ? "GET" : "POST"
            let _params = parameters.count > 0 ? ( (methodType == .post) ? "\nParams : \(parameters)" : "" ): ""
            
            let req = "\n\n\(logString) \(type) Request : \(request!)" + _params
            APILog.printMessage(message: req, logType: .request)
            if let parameterDictionary = info?["DICTIONARY"] as? [String : Any]{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: .prettyPrinted)
                    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
                    APILog.printMessage(message: "\n\(logString) : \(jsonString)", logType:.request)
                } catch {
                }
            }
            let head = "\n\(logString) Request Headers :\n" + (APILog.defaultHeaders() as String)
            APILog.printMessage(message: head, logType: .header)
            if (info?["DICTIONARY"] as? [String : Any]) != nil{
                let head = "\nContent-Type : application/json\n"
                APILog.printMessage(message: head, logType: .header)
            }
            
            if let headersDic = info?["HEADERS"] as? [String : String]{
                for key in headersDic.keys{
                    let head = "\n\(key) : \(headersDic[key]!)\n"
                    APILog.printMessage(message: head, logType: .header)
                }
            }
        }
        
        /*
        if let headers = info?["HEADERS"] as? [String : String]{
            for key in headers.keys{
                request!.setValue(headers[key], forHTTPHeaderField: key)
                if PreferenceManager.isLogEnabled{
                    print(key + " : " + headers[key]!)
                }
            }
        }
        */
        let task = URLSession.shared.dataTask(with: request!, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                if response == nil{
                    if let message = error?.localizedDescription{
                        APILog.printMessage(message:"\n\(logString) Response : \(message)", logType: .error)
                    }
                    else{
                        APILog.printMessage(message: "\n\(logString) Response : Response is nill", logType: .error)
                    }
                    
                    completionHandler(data, response, error)
                    return
                }
                
               
                    if data != nil{
                        do {
                            if logString == "CurrentDate" || logString == "HeaderEnrichment"  {
                                completionHandler(data, response, error)
                            }
                            else {
                                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                let res = "\n\(logString) Response : \(String(decoding: data ?? Data(), as: UTF8.self))"
                                APILog.printMessage(message: res, logType: .response)
                                
                                //                            check for Unauthorized case
                                if let res = jsonResult as? [String : Any]{
                                    if  (res["status"] as? Bool == false){
                                        let statusCode = ((jsonResult as? [String : Any])?["error"] as? [String : Any])?["code"] as? Int
                                        
                                        if (statusCode == ErrorCode.Unauthorized){
                                            
                                            OTTSdk.appManager.getToken(onSuccess: {
                                                OTTSdk.userManager.updatePreference(selectedLanguageCodes: OTTSdk.preferenceManager.selectedLanguages, sendEmailNotification: true, onSuccess: { (response) in
                                                    self.baseRequest(baseUrl: baseUrl, parameters: parameters, methodType: methodType, info: info, logString: "GetToken " + logString, completionHandler: { (_data, _response, _error) in
                                                        completionHandler(_data, _response, _error)
                                                    })
                                                    
                                                }, onFailure: { (error) in
                                                    self.baseRequest(baseUrl: baseUrl, parameters: parameters, methodType: methodType, info: info, logString: "GetToken " + logString, completionHandler: { (_data, _response, _error) in
                                                        completionHandler(_data, _response, _error)
                                                    })
                                                    
                                                })
                                                
                                            }, onFailure: { (error) in
                                                
                                                // Unauthorized : Should not reach to this point as pseudoLogin never fails
                                                let userInfo: [String : String] =
                                                    [
                                                        NSLocalizedDescriptionKey :  "Section Expired. Please try again.",
                                                        NSLocalizedFailureReasonErrorKey : "section key expired"
                                                ]
                                                let err = NSError(domain: "HttpResponseErrorDomain", code: ErrorCode.Unauthorized, userInfo: userInfo)
                                                completionHandler(nil, nil, err)
                                            })
                                            return;
                                        }
                                    }
                                }
                            }
                            
                            
                        } catch let error as NSError {
                            
                            if let returnData = String(data: data!, encoding: .utf8) {
                                
                                let res = "\(logString) Response : \(String(describing: returnData))"
                                APILog.printMessage(message: res, logType: .error)
                                
                            } else {
                                let res = "\(logString) Response : \(error.localizedDescription)"
                                APILog.printMessage(message: res, logType: .error)
                            }
                        }
                    }
                    else{
                        if let returnData = String(data: data!, encoding: .utf8) {
                            let res = "\n\(logString) Response : \(String(describing: returnData))"
                            APILog.printMessage(message: res, logType: .error)
                            
                        } else {
                            let res = "\n\(logString) Response : \(String(describing: error?.localizedDescription))"
                            APILog.printMessage(message: res, logType: .error)
                        }
                    }
                completionHandler(data, response, error)
            }
        })
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();

        if parameters != nil {
            for (key, value) in parameters! {
                if value is String {
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    body.append("\(value)\r\n".data(using: .utf8)!)
                }
            }
        }

        let filename = "user-profile.jpg"

        let mimetype = "image/jpg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageDataKey as Data)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    /**
     stream With Encryption
     - Parameters:
     - encryptedDictionary : Dictionary with data and metadata keys with encrypted values
     - onSuccess: successful
     - response : response dictionary
     - onFailure: failed
     - error: error object with code and message
     - Returns: void
     */
    
    internal func requestWithEncryption(dictionary : [String : Any], requestType : String, logString : String, onSuccess : @escaping (_ response : [String : Any])-> Void, onFailure : @escaping(_ error  :APIError) -> Void){
        
        let encryptedDictionary =  Utility.getEncryptedArgumentFor(dataDictionary: dictionary, requestType: requestType)
        
        API.instance.baseRequest(baseUrl: API.url.signInWithEncryption, parameters: "", methodType: .post, info: ["DICTIONARY":encryptedDictionary], logString: logString + "WithEncryption") { (data, response, error) in
            if error != nil {
                onFailure(APIError.init(withMessage: (error?.localizedDescription)!))
                return
            }
            if data != nil{
                do {
                    let encResponse =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    guard let encResponseData = encResponse?["data"] as? String else{
                        onFailure(APIError.defaultError())
                        return
                    }
                    
                    let decryptedString = try! Utility.aesDecrypt(encryptedMessage: encResponseData)
                    
                    var decryptedResponse = [String: Any]()
                    if let data = decryptedString.data(using: .utf8) {
                        do {
                            let temp =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            decryptedResponse = temp!
                            APILog.printMessage(message: decryptedResponse)
                        } catch {
                            onFailure(APIError.init(withMessage: error.localizedDescription))
                            return
                        }
                    }
                    else{
                        onFailure(APIError.defaultError())
                        return
                    }
                    
                    //Check success of failure
                    var successResponse = [String : Any]()
                    if decryptedResponse["status"] as? Int == 0{
                        if let errorDic = decryptedResponse["error"]  as? [String : Any]{
                            onFailure(APIError(withResponse: errorDic))
                            return
                        }
                        else{
                            onFailure(APIError.defaultError())
                            return
                        }
                    }
                    else{
                        guard let _response = decryptedResponse["response"] as? [String : Any] else {
                            onFailure(APIError.defaultError())
                            return
                        }
                        successResponse = _response
                    }
                    
                    APILog.printMessage(message: successResponse)
                    onSuccess(successResponse)
                    return
                    
                } catch {
                    onFailure(APIError.init(withMessage: error.localizedDescription))
                    return
                }
                
            }
            else{
                onFailure(APIError.defaultError())
                return
            }
        }
        
    }
   
}
