//
//  API.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class API: NSObject {
    
    struct ErrorCode {
        static let Success = 200
        static let Unauthorized = 401
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
    static var domain : String{
        if PreferenceManager.isLive{
            return ""
        }
        else{
            return "http://54.145.173.246:80/"
        }
    }
    
    internal struct baseUrl {
        static let authPathV1 = domain + "auth/api/v1/"
        static let authPathV2 = domain + "auth/api/v2/"
        static let dataPath = domain + "yupptv/api/v2/"
        static let testYuppflix = "http://test.yuppflix.com:8080"
        
     //   static let testYuppflix = "http://54.145.173.246:80"
    }
    
    internal struct url {
        static let getToken = baseUrl.authPathV1 + "get/token"
        static let signUp = baseUrl.authPathV2 + "signup"
        static let signIn = baseUrl.authPathV2 + "signin"
        static let signInWithOTP = baseUrl.authPathV2 + "signin/otp"
        static let getOTP = baseUrl.authPathV2 + "get/otp"
        static let verifyMobile = baseUrl.authPathV2 + "verify/mobile"
        static let verifyEmail = baseUrl.authPathV2 + "verify/email"
        static let forgotPassword = baseUrl.authPathV2 + "forgot/password"
        static let freetrialList = baseUrl.authPathV2 + "freetrials/list"
        static let activateFreeTrial = baseUrl.authPathV2 + "activate/freetrial"
        static let delinkDevice = baseUrl.authPathV2 + "delink/device"
        static let sectionMetadataList = baseUrl.dataPath + "section/metadata/list"
        static let sectionData = baseUrl.dataPath + "section/data"
        static let channelDetails = baseUrl.dataPath + "channel/details"
        static let channelMovies = baseUrl.dataPath + "channel/movies"
        static let channelShows = baseUrl.dataPath + "channel/shows"
        static let channelOneOffs = baseUrl.dataPath + "channel/oneoffs"
        static let stream = baseUrl.dataPath + "epg/stream"
        static let epgGuide = baseUrl.dataPath + "channel/guide"
        static let channelDetailsMenu = baseUrl.dataPath + "channel/programs"
        static let suggestedChannels = baseUrl.dataPath + "suggested/channels"
        static let userInfo = baseUrl.authPathV2 + "user/info"
        static let logOut = baseUrl.authPathV2 + "logout"
        static let userPreferences = baseUrl.dataPath + "user/preferences"
        static let preferencesUpdate = baseUrl.authPathV1 + "viewer/preferences/update"
        static let passwordUpdate = baseUrl.authPathV1 + "password/update"
        static let mobileUpdate = baseUrl.authPathV1 + "mobile/update"
        static let sectionDetails = baseUrl.dataPath + "section/details"
        static let addressUpdate = baseUrl.authPathV1 + "address/update"
        static let cardUpdate = baseUrl.authPathV1 + "card/update"
        static let userAccountDetails = baseUrl.dataPath + "user/account/details"
        static let linkedDevices = baseUrl.dataPath + "user/devices"
        static let transactions = baseUrl.dataPath + "user/purchase/history"
        static let banners = baseUrl.dataPath + "banner/list"
        
        //Premiers
        /// Premium Movies List API
        static let premiumMoviesList = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movies/list"
        /// Single Movie detail page API 
        static let movieDetails = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/details"
        /// Zip code Validation API
        static let zipCodeValidation = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/geo/availability"
        /// Get Stream Key/Send Verification Link API
        static let sendVerificationLink = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/play"
        /// Get Stream Key/Send Verification Link API : Encryption
        static let sendVerificationLinkWithEncryption = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/poll"
        /// Resend Verification Link API
        static let resendVerificationLink = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/geoauth/url/resend"
        /// Movie Stream request API
        static let movieStream = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/stream/request"
        /// Stream status/Ping API
        static let streamStatus = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/stream/status"
        /// In App(roku/apple) Product ID Details API
        static let productDetails = baseUrl.testYuppflix + "/yupptv/api/v1/premium/payment/apple/product/details"
        /// In App receipt Submit API
        static let validateReceipt = baseUrl.testYuppflix + "/yupptv/api/v1/premium/payment/validate/apple/receipt"
        /// Terms Accept API
        static let termsAccept = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/movie/terms/accept"
        /// Get info by Access Code API
        static let accessKeyInfo = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/access/key/info"
        /// URL validation API
        static let keyValidate = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/premium/access/key/validate"
        
        //TVShows
        /// TV Shows Sections list API
        static let sectionsList = baseUrl.testYuppflix + "/yupptv/api/v2/section/metadata/list"
        /// TV Shows Sections data API
        static let sectionsData = baseUrl.testYuppflix + "/yupptv/api/v2/section/data"
        /// TV Show details API
        static let tvShowDetails = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v2/tvshows/tvshow/details"
        /// TV Show Season episodes API
        static let tvShowSeasonEpisodes = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v2/tvshows/tvshow/episodes"
        /// Episode Stream API
        static let episodeStream = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v2/tvshows/episode/stream"
        
        //Static
        ///country List API
        //TODO: Verify countries url
        static let countryList = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/static/content/countries/info"
        
        ///Languages List API
        //TODO: Verify Languages url
        static let languagesList = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/static/content/languages"

        ///AboutUs API
        //TODO: Verify AboutUs url
        static let aboutUs = baseUrl.testYuppflix + "/yupptv/yuppflix/api/v1/static/content/about/page"
        
        
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
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    if jsonResult["status"] as? Int == 0{
                        if let errorDic = jsonResult["error"]  as? [String : Any]{
                            onFailure(APIError(withResponse: errorDic))
                            return
                        }
                        else{
                            onFailure(APIError.defaultError())
                            return
                        }
                    }
                    else{
                        guard let _response = jsonResult["response"] else {
                            onFailure(APIError.defaultError())
                            return
                        }
                        onSuccess(_response)
                        return
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
        }
        else if methodType == .post{
            request = URLRequest(url: URL(string:baseUrl)!)
            request!.httpMethod = "POST"
            if let parameterDictionary = info?["DICTIONARY"] as? [String : Any]{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: .prettyPrinted)
                    request?.httpBody = jsonData
                    request?.setValue("application/json", forHTTPHeaderField: "Content-Type")

                    
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
        
        request!.timeoutInterval = PreferenceManager.requestTimeout
        request!.setValue(PreferenceManager.sessionId, forHTTPHeaderField: "session-id")
        request!.setValue(YuppTVSDK.preferenceManager.boxId, forHTTPHeaderField: "box-id")
      
        if PreferenceManager.logType != .none{
            let type = (methodType == .get) ? "GET" : "POST"
            let _params = parameters.characters.count > 0 ? ( (methodType == .post) ? "\nParams : \(parameters)" : "" ): ""
            
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
                
                if (response as! HTTPURLResponse).statusCode == ErrorCode.Unauthorized{
                    self.getToken(completionBlock: { (_isSuccess, message) in
                        if _isSuccess{
                            self.baseRequest(baseUrl: baseUrl, parameters: parameters, methodType: methodType, info: info, logString: "GetToken " + logString, completionHandler: { (_data, _response, _error) in
                                completionHandler(_data, _response, _error)
                            })
                        }
                        else{
                            // Unauthorized : Should not reach to this point as pseudoLogin never returns Unauthorized
                            let userInfo: [String : String] =
                                [
                                    NSLocalizedDescriptionKey :  "Section Expired. Please try again.",
                                    NSLocalizedFailureReasonErrorKey : "section key expired"
                            ]
                            let err = NSError(domain: "HttpResponseErrorDomain", code: ErrorCode.Unauthorized, userInfo: userInfo)
                            completionHandler(nil, nil, err)
                        }
                    })
                }
                else{
                    if PreferenceManager.logType != .none{
                        if data != nil{
                            do {
                                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                let res = "\n\(logString) Response : \(String(describing: jsonResult))"
                                APILog.printMessage(message: res, logType: .response)
                                
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
                    }
                    completionHandler(data, response, error)
                }
            }
        })
        task.resume()
    }
    
   
    
    /**
    This function is to get the session-id, which is to be sent in all other APIs as headerfield.
    
    - Parameters:
        - completionBlock:
            - Bool: success or failure
            - String: error Message.
    - Returns: void
    */
    
    //#warning : must set internal.
    public func getToken(completionBlock : @escaping (Bool, String) -> Void) {
        
        let params = "source=Yupptv&device_type="+PreferenceManager.deviceType+"&box_id="+YuppTVSDK.preferenceManager.boxId
        YuppTVSDK.preferenceManager.user = nil
        baseRequest(baseUrl: url.getToken, parameters: params, methodType: .post, info: nil, logString: "Get Token") {
            (data, response, error) in
            
            if error != nil {
                completionBlock(false,(error?.localizedDescription)!)
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    if jsonResult["status"] as? Int == 0{
                        var errorMessage = "Unable to get token."
                        if let errorDic = jsonResult["error"]  as? [String : Any]{
                            if let errorMsg = errorDic["message"] as? String{
                                errorMessage = errorMsg
                            }
                        }
                        completionBlock(false,errorMessage)
                    }
                    else{
                        guard let session = jsonResult["sessionId"] as? String else {
                            completionBlock(false,"Unable to get token...")
                            return
                        }
                        PreferenceManager.sessionId = session
                        if let _countryCode = jsonResult["countryCode"] as? String  {
                            YuppTVSDK.preferenceManager.countryCode = _countryCode
                        }

                        completionBlock(true,"")
                    }
                    
                } catch let error as NSError {
                    completionBlock(false,error.localizedDescription)
                }
            }
            else{
                    completionBlock(false,"Unable to get token..")
            }
            
        }
    }
}
