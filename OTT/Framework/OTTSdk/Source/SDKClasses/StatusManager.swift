//
//  StatusManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StatusManager: NSObject {
    
    public enum PlayStatusCode : Int{
        case started = 1
        case ping = 2
        case ended = 3
        
        func value() -> String {
            switch self {
            case .started:
                return "1"
            case .ping:
                return "2"
            case .ended:
                return "3"
            }
        }
    }
    
    internal override init() {
        super.init()
    }

    /**
     Zip code Validation API
    
     - Parameters:
         - movieId: Movie id
         - zipCode: user entered Zip code
         - onSuccess: BaseResponse Object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func geoAvailablility(movieId : String ,zipCode : String ,onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "movie_id=" + movieId + "&zip_code=" + zipCode
        API.instance.request(baseUrl: API.url.zipCodeValidation, parameters: params, methodType: .get, info: nil, logString: "ZipCodeValidation", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(BaseResponse.init(withResponse: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Terms Accept API
     - Parameters:
         - movieId : movie ID
         - accept :
             - true  : Accepted
             - false : Not Accepted.
         - onSuccess: BaseResponse
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func acceptTerms(accept : Bool, movieId : String, onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "movie_id=" + movieId + "&accept=" + String(accept)
        API.instance.request(baseUrl: API.url.termsAccept, parameters: params, methodType: .post, info: nil, logString: "AcceptTerms", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(BaseResponse.init(withResponse: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    /**
     Stream status/Ping API
     - Parameters:
         - streamKey : get from MediaCatalogManager.getStreamKey API.
         - statusCode : PlayStatusCode
         - onSuccess: BaseResponse
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func streamStatus(streamKey : String, statusCode : PlayStatusCode, onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "stream_key=" + streamKey + "&status_code=" + statusCode.value()
        API.instance.request(baseUrl: API.url.streamStatus, parameters: params, methodType: .post, info: nil, logString: "StreamStatus:"+String(describing: statusCode), onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(BaseResponse.init(withResponse: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    
    /**
     Send Verification Link API
     
     - To start the Stream requires stream key.
     - To get the stream Key, user must verify his location. By this API a verification Link is sent to user
     registered Mobile number. If the user verifies his location, a stream Key will get in response.
     So this API does 2 functionalities
     + To sent verification Link to Mobile -> sendVerificationLink()
     + To get stream Key. -> getStreamKey()
     
     - Parameters:
         - movieId : Current Movie id
         - onSuccess : StreamKey object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func sendVerificationLink(movieId : String, onSuccess : @escaping (StreamKeyResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        sendVerificationLinkOrGetStreamKey(movieId: movieId, isVerify: "false", onSuccess: { (response) in
            onSuccess(response)
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Resend Verification Link API
     
     - To start the Stream requires stream key.
     - To get the stream Key, user must verify his location. By this API a verification Link is sent to user
     registered Mobile number. If the user verifies his location, a stream Key will get in response.
     
     - Parameters:
         - movieId : Current Movie id
         - mobileNo : User mobile number with country code (Ex: 9195645767687)
         - onSuccess : StreamKeyResponse object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func resendVerificationLink(movieId : String,mobileNo : String, onSuccess : @escaping (StreamKeyResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        
        var params = ""
        var requestPath = ""
        var info : [String : Any]?
        /*
         if PreferenceManager.isEncryptionEnabled{
         let paramsDic = ["movie_id" : movieId , "is_verify" : isVerify]
         if let args = Utility.getEncryptedArgumentFor(dataDictionary: paramsDic, requestType: "movie/play"){
         params = args
         }
         requestPath = API.url.sendVerificationLinkWithEncryption
         info = ["HEADERS":["Content-Type":"application/json"]]
         }
         else{*/
        params = "movie_id=" + movieId + "&mobile_no=" + mobileNo
        requestPath = API.url.resendVerificationLink
        info = nil
        //        }
        
        
        API.instance.request(baseUrl: requestPath, parameters: params, methodType: .post, info: info, logString: "ResendVerificationLink", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(StreamKeyResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    

    
    /**
     Get Stream Key/Send Verification Link API
     
     - To start the Stream requires stream key.
     - To get the stream Key, user must verify his location. By this API a verification Link is sent to user
     registered Mobile number. If the user verifies his location, a stream Key will get in response.
     So this API does 2 functionalities
     + To sent verification Link to Mobile
     + To get stream Key.
     
     - Parameters:
         - movieId : Current Movie id
         - isVerify :Movie code
         - onSuccess : MovieDetailsResponse object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    internal func sendVerificationLinkOrGetStreamKey(movieId : String,isVerify : String, onSuccess : @escaping (StreamKeyResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        
        var params = ""
        var requestPath = ""
        var info : [String : Any]?
        /*
         if PreferenceManager.isEncryptionEnabled{
         let paramsDic = ["movie_id" : movieId , "is_verify" : isVerify]
         if let args = Utility.getEncryptedArgumentFor(dataDictionary: paramsDic, requestType: "movie/play"){
         params = args
         }
         requestPath = API.url.sendVerificationLinkWithEncryption
         info = ["HEADERS":["Content-Type":"application/json"]]
         }
         else{*/
        params = "movie_id=" + movieId + "&is_verify=" + isVerify
        requestPath = API.url.sendVerificationLink
        info = nil
        //        }
        
        
        API.instance.request(baseUrl: requestPath, parameters: params, methodType: .post, info: info, logString: "SendVerificationLink", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(StreamKeyResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    }
