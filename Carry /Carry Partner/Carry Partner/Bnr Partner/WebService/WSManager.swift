//
//  WSManager.swift
//  BooknRide
//
//  Created by NCrypted on 04/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WSManager: NSObject {
    
    static let sharedManager = WSManager()
    
    typealias SuccessBlock = (Dictionary<NSObject, AnyObject>?,DataResponse<Any>?) -> Void
    typealias FailureBlock = (Error) -> Void
    
    class func getResponseFrom(serviceUrl:String,parameters:Dictionary<String, Any>,successBlock:@escaping SuccessBlock,failureBlock:@escaping FailureBlock ) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60 //default 10
        manager.request(serviceUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch response.result {
            case .success(let value):
                // handle success here
                print(value)
                successBlock(value as? Dictionary<NSObject, AnyObject>, response)
            case .failure(let failValue):
                //if let statusCode = response.response?.statusCode {
                // if statusCode == 500 {
                // handle 500 specific error here, if you want
                print(failValue)
                failureBlock(response.error!)
                //}
                //}
            }
            
        }
        
    }
    
    
    class func getResponseFromMultiPart(serviceUrl:String,parameters:Dictionary<String, Any>,image:Image
        ,successBlock:@escaping SuccessBlock,failureBlock:@escaping FailureBlock ){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60 //default 10
        manager.upload(multipartFormData: { (multipartFormData:MultipartFormData)  in
            
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            multipartFormData.append(imageData!, withName: "userProfileImage", fileName: "profile.png", mimeType: "image/png")

            for (key,value) in parameters{
                
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue))!, withName: key)
            }
            
            
        }, to: URL(string: serviceUrl)!) { (result) -> Void  in
            
            switch result {
            case .success(let upload, _, _):
                do {
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success( _):
                        successBlock(response.result.value as? Dictionary<NSObject,AnyObject>, response)
                        case .failure(let failValue):
                        print(failValue)
                        failureBlock(response.error!)
                        }
                    }
                }
            case .failure(let encodingError):
                do {
                    
                    print(encodingError)
                    failureBlock(encodingError)
                    
                }
            }
        }
        
    }
    class func getResponseFromMultiPart(serviceUrl:String,parameters:Dictionary<String, Any>,fileName:[String],fileData:[Data],successBlock:@escaping SuccessBlock,failureBlock:@escaping FailureBlock ){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60 //default 10
        manager.upload(multipartFormData: { (multipartFormData:MultipartFormData)  in
            
//            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            if fileName.count > 0{
                for (i,value) in fileData.enumerated(){
                    multipartFormData.append(value, withName:"user_doc[\(i)]", fileName: fileName[i], mimeType: "")
                }
            }
            for (key,value) in parameters{
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue))!, withName: key)
            }
        }, to: URL(string: serviceUrl)!) { (result) -> Void  in
            
            switch result {
            case .success(let upload, _, _):
                do {
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success( _):
                            successBlock(response.result.value as? Dictionary<NSObject,AnyObject>, response)
                        case .failure(let failValue):
                            print(failValue)
                            failureBlock(response.error!)
                        }
                    }
                }
            case .failure(let encodingError):
                do {
                    
                    print(encodingError)
                    failureBlock(encodingError)
                    
                }
            }
        }
        
    }
    
    class func getResponseFromMultiPart(serviceUrl:String,parameters:Dictionary<String, Any>,fileName:[String],fileData:[Data], image:Image, successBlock:@escaping SuccessBlock,failureBlock:@escaping FailureBlock ){
        
        
      
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60 //default 10
        manager.upload(multipartFormData: { (multipartFormData:MultipartFormData)  in
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            multipartFormData.append(imageData!, withName: "profileImage", fileName: "selfie.png", mimeType: "image/png")
            
//            for (key,value) in parameters{
//
//
//                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue))!, withName: key)
//            }
            //            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            if fileName.count > 0{
                for (i,value) in fileData.enumerated(){
                    multipartFormData.append(value, withName:"user_doc[\(i)]", fileName: fileName[i], mimeType: "")
                }
            }
            for (key,value) in parameters{
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue))!, withName: key)
            }
        }, to: URL(string: serviceUrl)!) { (result) -> Void  in
            
            switch result {
            case .success(let upload, _, _):
                do {
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success( _):
                            successBlock(response.result.value as? Dictionary<NSObject,AnyObject>, response)
                        case .failure(let failValue):
                            print(failValue)
                            failureBlock(response.error!)
                        }
                    }
                }
            case .failure(let encodingError):
                do {
                    
                    print(encodingError)
                    failureBlock(encodingError)
                    
                }
            }
        }
        
    }
        
        
}
