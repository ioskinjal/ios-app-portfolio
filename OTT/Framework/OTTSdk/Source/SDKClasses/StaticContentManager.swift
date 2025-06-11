//
//  StaticContentManager.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 15/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StaticContentManager: NSObject {
    internal override init() {
        super.init()
    }
    
    /**
     Countries List
     - Parameters:
         - onSuccess: Countries List
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func countriesList(onSuccess : @escaping ([Country])-> Void, onFailure : @escaping(APIError) -> Void){
  
        API.instance.baseRequest(baseUrl: API.url.countryList, parameters: "", methodType: .get, info: nil, logString: "CountriesList") { (data, response, error) in
            if error != nil {
                onFailure(APIError.init(withMessage: (error?.localizedDescription)!))
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : Any]]
                    onSuccess(Country.countriesList(json: jsonResult))
                } catch let error as NSError {
                    onFailure(APIError.init(withMessage: error.localizedDescription))
                }
            }
            else{
                onFailure(APIError.defaultError())
            }
        }
    }
    
    /**
     Languages List
     - Parameters:
         - onSuccess: Language List
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func languagesList(onSuccess : @escaping ([Language])-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.baseRequest(baseUrl: API.url.languagesList, parameters: "", methodType: .get, info: nil, logString: "LanguagesList") { (data, response, error) in
            if error != nil {
                onFailure(APIError.init(withMessage: (error?.localizedDescription)!))
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    if jsonResult["languages"] is [[String : Any]]{
                        onSuccess(Language.languagesList(json: jsonResult["languages"]))
                        return
                    }
                    else{
                        onFailure(APIError.defaultError())
                    }
                } catch let error as NSError {
                    onFailure(APIError.init(withMessage: error.localizedDescription))
                }
            }
            else{
                onFailure(APIError.defaultError())
            }
        }
    }
    
    /**
     About US
     - Parameters:
         - onSuccess: AboutUs object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func aboutUs(onSuccess : @escaping (AboutUs)-> Void, onFailure : @escaping(APIError) -> Void){
        let param = "country=" + YuppTVSDK.preferenceManager.countryCode
        API.instance.baseRequest(baseUrl: API.url.aboutUs, parameters: param, methodType: .get, info: nil, logString: "AboutUs") { (data, response, error) in
            if error != nil {
                onFailure(APIError.init(withMessage: (error?.localizedDescription)!))
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    onSuccess(AboutUs.init(withJson: jsonResult))
                } catch let error as NSError {
                    onFailure(APIError.init(withMessage: error.localizedDescription))
                }
            }
            else{
                onFailure(APIError.defaultError())
            }
        }
    }
}
