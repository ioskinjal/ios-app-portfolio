//
//  AppManager.swift
//  OTTSdk
//
//  Created by Muzaffar on 29/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class AppManager: NSObject {
    
    public class var instance : AppManager {
        struct Singleton {
            static let obj = AppManager()
        }
        return Singleton.obj
    }
    
    
    
    
    /**
     This function to know whether this app should be blocked or not
     
     - Parameters:
         - isSupported: Bool
             * true : allow
             * false : block
     - Returns: Void
     
     */
    public func initiateSdk( isSupported :  @escaping (Bool, APIError?) -> Void){
        
        print("Preference Manager Value is : \(PreferenceManager.serviceType)")

        API.instance.baseRequest(baseUrl: API.Requests.appInitialRequest, parameters: "", methodType: .get, info: nil, logString: "InitialRequest") { (data, response, error) in
            if error != nil {
                isSupported(false, APIError.init(withError: error!))
                return
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    
                    
                    if let value = jsonResult["api"] as? String{
                        API.Requests.api = value
                    }
                    if let value = jsonResult["heURL"] as? String{
                        API.Requests.heURL = value
                    }
                    if let value = jsonResult["pgURL"] as? String{
                        API.Requests.pgURL = value
                    }
                    if let value = jsonResult["api"] as? String{
                        API.Requests.api = value
                    }
                    
                    if let tempOtpURL = jsonResult["otpURL"] as? String{
                        API.Requests.otpURL = tempOtpURL
                    }
                    else{
                        API.Requests.otpURL = jsonResult["api"] as! String
                    }
                    
                    
                    if let value = jsonResult["location"] as? String{
                        API.Requests.location = value
                    }
                    if let value = jsonResult["search"] as? String{
                        API.Requests.search = value
                    }
                    if let value = jsonResult["product"] as? String{
                        OTTSdk.preferenceManager.product = value
                    }
                    if let value = jsonResult["tenantCode"] as? String{
                        OTTSdk.preferenceManager.tenantCode = value
                    }
                    LocationinfoResponse.StoredLocationinfo.response = nil
                    OTTSdk.appManager.updateLocation(onSuccess: { (response) in }) { (error) in }
                    
                    if let value = jsonResult["isSupported"] as? Bool{
                        API.isSupported = value
                    }
                    isSupported(API.isSupported, API.isSupported ? APIError.init(withMessage: "Unsupported api request") : nil)
                    
                }catch let _error{
                    isSupported(false, APIError.init(withError: _error))
                }
            }
            else{
                isSupported(false, APIError.init(withMessage: "Data is nill for initial request."))
            }
        }
    }
    
    //location
    //TODO: create models for response
    
    
    /**
    UpdateLocation of the User
     - Parameters:
         - onSuccess: LocationinfoResponse response
         - onFailure: APIError object
     - Returns: Void
     
     */
    public func updateLocation( onSuccess : @escaping (LocationinfoResponse)-> Void, onFailure : @escaping(APIError) -> Void){
     
        let storedInfo = LocationinfoResponse.StoredLocationinfo.getLocationinfoResponse()
        if storedInfo != nil{
            APILog.printMessage(message:"\nStored-LocationinfoResponse : \n\(storedInfo!.rawData)", logType: APILog.LogType.response)
            onSuccess(storedInfo!)
            return
        }
        
        let params = "tenant_code=" + OTTSdk.preferenceManager.tenantCode + "&product=" + OTTSdk.preferenceManager.product + "&client=" + OTTSdk.preferenceManager.client
        
        API.instance.baseRequest(baseUrl: API.url.locationinfo , parameters: params, methodType: .get, info: nil, logString: "Location") { (data, response, error) in
            
            if error != nil {
                let _error = APIError.init(withError: error!)
                onFailure(_error)
                return
            }
            
            if data != nil{
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
                        onSuccess(LocationinfoResponse(jsonResult))
                        return
//                        DispatchQueue.main.async(execute: {
//                            onSuccess(jsonResult)
//                        })
                    }
                    else{
                        onFailure(APIError.defaultError())
                        return
                    }
                } catch let _error as NSError {
                    onFailure(APIError(withMessage: _error.localizedDescription))
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
     New Acces token
     
     - Parameters:
         - onSuccess: new Token
         - onFailure: APIError object
     - Returns: Void
     
     */
    public func getToken( onSuccess : @escaping ()-> Void, onFailure : @escaping(APIError) -> Void){
        
        var params = "tenant_code=" + OTTSdk.preferenceManager.tenantCode + "&box_id=" +  PreferenceManager.boxId + "&device_id=" +
        PreferenceManager.deviceType + "&device_sub_type=" + PreferenceManager.deviceSubType + "&product=" + OTTSdk.preferenceManager.product
        
        params = params + "&timezone=" + TimeZone.current.identifier
        params = params + "&client_app_version=" + PreferenceManager.clientAppVersion
        
        if let dispLang = OTTSdk.preferenceManager.selectedDisplayLanguage{
            params = params + "&display_lang_code=" + dispLang
        }
        
        API.instance.request(baseUrl: API.url.getToken, parameters: params, methodType: .get, info: nil, logString: "Token", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            PreferenceManager.sessionId = _response["sessionId"] as! String
            onSuccess()
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     configuration : for Tabs and Assests path
     
     - Parameters:
         - onSuccess: new Token
         - onFailure: APIError object
     - Returns: Void
     
     */
    public func configuration( onSuccess : @escaping (ConfigResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        //Check for availability
        if let response = ConfigResponse.StoredConfig.getConfigResponse(currentDate: Date()){
            APILog.printMessage(message:"\nStored Config : \n\(response.rawData)", logType: APILog.LogType.response)
            onSuccess(response)
            return
        }
        
//        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        
        API.instance.request(baseUrl: API.url.config, parameters: "", methodType: .get, info: nil, logString: "Configuration", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let config = ConfigResponse(_response)
            ConfigResponse.StoredConfig.lastUpdated = Date()
            ConfigResponse.StoredConfig.response = config
            onSuccess(config)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     OTP Features
     
     - Parameters:
         - onSuccess: new Token
         - onFailure: APIError object
     - Returns: Void
     
     */
    public func otpFeaturesAPI( onSuccess : @escaping (SystemFeaturesModel)-> Void, onFailure : @escaping(APIError) -> Void){
        
        
//        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        
        API.instance.request(baseUrl: API.url.otpFeatures, parameters: "", methodType: .get, info: nil, logString: "System Features", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            guard let _systemFeatures = _response["systemFeatures"] as? [String : Any] else {
                onFailure(APIError.defaultError()); return
            }
            let systemFeatures = SystemFeaturesModel(_systemFeatures)
            let featuresResponse = FeatureResponse(_response)
            OTTSdk.preferenceManager.featuresResponse = featuresResponse
            onSuccess(systemFeatures)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Get countries
     
     - Parameters:
         - onSuccess: Success
         - countries: countries array
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func getCountries(onSuccess : @escaping (_ countries : [Country])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.url.countries, parameters: "", methodType: .get, info: nil, logString: "Countries", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else {
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Country.array(json: _response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get current date
     
     - Parameters:
     - onSuccess: Success
     - countries: date obj
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getCurrentDate(onSuccess : @escaping (_ currentDate : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.url.currentDate, parameters: "", methodType: .get, info: nil, logString: "CurrentDate", onSuccess: { (response) in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.allHeaderFields["Date"] as? String) != nil {
                    onSuccess(httpResponse.allHeaderFields["Date"] as! String)
                    return
                }
            }
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get Header Enrichment Number
     
     - Parameters:
     - onSuccess: Success
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getHeaderEnrichmentNumber(onSuccess : @escaping (_ currentDate : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.Requests.heURL, parameters: "", methodType: .get, info: nil, logString: "HeaderEnrichment", onSuccess: { (response) in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.allHeaderFields["x-up-calling-line-id"] as? String) != nil {
                    onSuccess(httpResponse.allHeaderFields["x-up-calling-line-id"] as! String)
                    return
                } else {
                    onSuccess("")
                    return
                }
            }
        }) { (error) in
            onFailure(error)
            return
        }
    }

}
