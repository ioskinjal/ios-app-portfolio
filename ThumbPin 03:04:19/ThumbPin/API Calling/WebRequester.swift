
//
//  WebRequester.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias dictionary = [String:Any]

class WebRequester {
    static let shared = WebRequester()
    var dataRequest:DataRequest!
    
    func requests(url:String, method:HTTPMethod = .post, parameter:dictionary = dictionary(), isLoader:Bool = true, completion:@escaping(Result<Any>)->Void){
        print("**********************")
        print("URL: \(url)")
        //print("Parameters: \(parameter)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************")
        //let bundleId = Bundle.main.bundleIdentifier ?? "com.test.api"
        //let queue = DispatchQueue(label: bundleId, qos: qos, attributes: .concurrent)
//        if isLoader {
//            Modal.sharedAppdelegate.startLoader()
//        }
        AppHelper.showLoadingView()
        if  parameter.isEmpty{
        dataRequest = request(url, method: method, encoding: URLEncoding.default).validate().responseJSON { (respones) in
                switch respones.result{
                case .success(let value):
                    //print("Respones: \(value)")
                    completion(Result.success(value))
                case.failure(let error):
                    completion(Result.failure(error))
                }
            }
        }else{
        dataRequest = request(url, method: method, parameters: parameter, encoding: URLEncoding.default).validate().responseJSON { (respones) in
                print(respones)
                switch respones.result {
                case .success(let value):
                 //   print("Respones: \(value)")
                    completion(Result.success(value))
                case.failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    func requestsOffline(url:String, method:HTTPMethod = .post, parameter:dictionary = dictionary(), isLoader:Bool = true, completion:@escaping(Result<Any>)->Void){
        print("**********************")
        print("URL: \(url)")
//        print("Parameters: \(parameter)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************")
        //let bundleId = Bundle.main.bundleIdentifier ?? "com.test.api"
        //let queue = DispatchQueue(label: bundleId, qos: qos, attributes: .concurrent)
        //        if isLoader {
        //            Modal.sharedAppdelegate.startLoader()
        //        }
        //AppHelper.showLoadingView()
        if  parameter.isEmpty{
            dataRequest = request(url, method: method, encoding: URLEncoding.default).validate().responseJSON { (respones) in
                switch respones.result{
                case .success(let value):
                    //print("Respones: \(value)")
                    completion(Result.success(value))
                case.failure(let error):
                    completion(Result.failure(error))
                }
            }
        }else{
            dataRequest = request(url, method: method, parameters: parameter, encoding: URLEncoding.default).validate().responseJSON { (respones) in
                print(respones)
                switch respones.result {
                case .success(let value):
                    //   print("Respones: \(value)")
                    completion(Result.success(value))
                case.failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }

    func requestsWithImage(url:String, parameter:dictionary = dictionary(), withPostImage postImgs:UIImage?, withPostImageName imgName:String?, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), withParamName:String, completion:@escaping(Result<Any>)->Void){
    //    Modal.sharedAppdelegate.startLoader()
        AppHelper.showLoadingView()
        var imgNm = "image.jpeg"
        if imgName != nil{
            imgNm = imgName!
        }
        
        print("**********************")
        print("URL: \(url)")
//        print("Parameters: \(parameter)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let postImg = postImgs{
                    let imgData:Data = WebRequester.getDataFromImage(imageName: imgNm, postImage: postImg)
                    multipartFormData.append(imgData,
                                             withName: withParamName, fileName: imgNm,
                                             mimeType: WebRequester.getMimeType(imageName: imgNm))
                    print("[\(withParamName)]: \(imgNm) => \(String(describing: postImg))")
                    print("**********************")
                }
                else if postImgsAry.count > 0{
                    //Multiple image upload
                    for (i,img) in postImgsAry.enumerated() {
                        multipartFormData.append(WebRequester.getDataFromImage(imageName: imgNameAry[i], postImage: img), withName: "\(withParamName)[\(i)]", fileName: imgNameAry[i], mimeType: WebRequester.getMimeType(imageName: imgNameAry[i]))
                        print("\(withParamName)[\(i)]: \(imgNameAry[i]) => \(String(describing: img))")
                    }
                    print("**********************")
                }
                
                
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                
                //add ertra arguments
                //This is only use for editProfile API
//                if let str = parameter["avl_dat"] as? String{
//                    let strAry = str.components(separatedBy: ",")
//                    for value in strAry{
//                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "avl_dat[]")
//                    }
//                }
          
        },
            usingThreshold: UInt64.init(),//this new line added
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print("Respones: \(value)")
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
        })
        
    }
    // MARK:- requestMultipartFormDataWithImageAndVideo
    
    func requestMultipartFormDataWithImageAndVideo(_ url : String ,dicsParams : dictionary = dictionary(),_ imageName : String,completion:@escaping(Result<Any>)->Void)
    {
        
        let username = ""
        let password = ""
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        _ = ["Authorization": "Basic \(base64Credentials)"]
        
//        let formate = DateFormatter()
//        formate.dateFormat = "dd-MM-yyyyHH:mm:ss"
//        let date = formate.string(from: Date())
//        let fileName = "\(date).jpeg"
//        let videoName = "\(date).mp4"
        
        AppHelper.showLoadingView()
        
        print(dicsParams)
        //        let manager = Alamofire.Manager.sharedInstance
        //        let urlString = try! URLRequest(url: url, method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in dicsParams {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            
            for (key, value) in dicsParams
            {
                if value is UIImage
                {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.5)
                    {
                        //"file.jpeg"
                        multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                        break
                    }
                }
            }
            for (key, value) in dicsParams
            {
                if value is Data
                {
                    //"video.mp4"
                    if let dataget = value as? Data {
                        multipartFormData.append(dataget, withName: key, fileName: "video.mp4", mimeType: "video/mp4")
                    }
                }
            }
            
            for (key, value) in dicsParams
            {
                if value is NSArray
                {
                    for (image) in value as! NSArray
                    {
                        if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 1)
                        {
                            multipartFormData.append(imageData, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                        }
                    }
                }
            }
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result{
                    case .success(let value):
                        //print("Respones: \(value)")
                        completion(Result.success(value))
                    case.failure(let error):
                        completion(Result.failure(error))
                    }
                }
                break
            case .failure(let encodingError):
                //Uploading time error
                completion(Result.failure(encodingError))
                break
            }
        }
    }
    func requestMultipartFormDataWithImageAndDocument(_ url : String ,dicsParams : dictionary = dictionary(),_ imageName : String,completion:@escaping(Result<Any>)->Void)
    {
        var imgNm = "image.jpeg"
        if !imageName.isEmpty{
            imgNm = imageName
        }
        let username = ""
        let password = ""
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        _ = ["Authorization": "Basic \(base64Credentials)"]
        
        //        let formate = DateFormatter()
        //        formate.dateFormat = "dd-MM-yyyyHH:mm:ss"
        //        let date = formate.string(from: Date())
        //        let fileName = "\(date).jpeg"
        //        let videoName = "\(date).mp4"
        
        AppHelper.showLoadingView()
        print(url)
        print(dicsParams)
        //        let manager = Alamofire.Manager.sharedInstance
        //        let urlString = try! URLRequest(url: url, method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in dicsParams {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            
            for (key, value) in dicsParams
            {
                if value is UIImage
                {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.5)
                    {
                        //"file.jpeg"
                        multipartFormData.append(imageData, withName: key, fileName: imgNm, mimeType: "image/jpeg")
                        break
                    }
                }
            }
            for (key, value) in dicsParams
            {
                if value is Data
                {
                    //"video.mp4"
                    if let dataget = value as? Data {
                        multipartFormData.append(dataget, withName: key, fileName: "homesafety.pdf", mimeType: "application/pdf")
                    }
                }
            }
            
        /*    for (key, value) in dicsParams
            {
                if value is NSArray
                {
                    for (image) in value as! NSArray
                    {
                        if  let imageData = UIImageJPEGRepresentation(image as! UIImage, 1)
                        {
                            multipartFormData.append(imageData, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                        }
                    }
                }
            }   */
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    switch response.result{
                    case .success(let value):
                        print("Respones: \(value)")
                        completion(Result.success(value))
                    case.failure(let error):
                        completion(Result.failure(error))
                    }
                }
                break
            case .failure(let encodingError):
                //Uploading time error
                completion(Result.failure(encodingError))
                break
            }
        }
    }
    func requestsWithFile(url:String, parameter:dictionary = dictionary(), withFileData fileData:Data?, withPostImageName imgName:String?, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), withParamName:String, completion:@escaping(Result<Any>)->Void){
        //    Modal.sharedAppdelegate.startLoader()
        AppHelper.showLoadingView()
        var imgNm = "image.jpeg"
        if imgName != nil{
            imgNm = imgName!
        }
        
        print("**********************")
        print("URL: \(url)")
//        print("Parameters: \(parameter)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let data = fileData {
                    multipartFormData.append(data,withName: withParamName, fileName: imgNm,mimeType: "application/pdf")
                }
                
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                
                //add ertra arguments
                //This is only use for editProfile API
                //                if let str = parameter["avl_dat"] as? String{
                //                    let strAry = str.components(separatedBy: ",")
                //                    for value in strAry{
                //                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "avl_dat[]")
                //                    }
                //                }
                
        },
            usingThreshold: UInt64.init(),//this new line added
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print("Respones: \(value)")
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
        })
        
    }
    
    func requestsWithFileData(url:String, parameter:dictionary = dictionary(), withFileData file:Data?, withFileName fileName:String, withFileAry filesAry:[Data] = [Data](), withFileNameAry fileNameAry:[String] = [String](), withParamName:String, completion:@escaping(Result<Any>)->Void){
//        Modal.sharedAppdelegate.startLoader()
        AppHelper.showLoadingView()
        print("**********************")
        print("URL: \(url)")
        //print("Parameters: \(parameter)")
        print("Parameters:")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let postFile = file{
                    //Single image upload
                    //let imgData:Data = WebRequester.getDataFromImage(imageName: imgNm, postImage: postFile)
                    multipartFormData.append(postFile,
                                             withName: withParamName, fileName: fileName,
                                             mimeType: "")
                    print("[\(withParamName)]: \(fileName) => \(String(describing: postFile))")
                    print("**********************")
                }
                else if filesAry.count > 0{
                    //Multiple image upload
                    for (i,file) in filesAry.enumerated() {
                        multipartFormData.append(file, withName: "\(withParamName)[\(i)]", fileName: fileNameAry[i], mimeType: "")
                        print("\(withParamName)[\(i)]: \(fileNameAry[i]) => \(String(describing: file))")
                    }
                    print("**********************")
                }
                
                //params added
                for (key, value) in parameter {
                    //multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                
        },
            usingThreshold: UInt64.init(),//this new line added
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            //print("Respones: \(value)")
                            completion(Result.success(value))
                        case.failure(let error):
                            completion(Result.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    completion(Result.failure(error))
                    break
                }
        })
        
    }

}


extension WebRequester {
    func cancelAllReuest() {
        //https://stackoverflow.com/questions/41478122/cancel-a-request-alamofire
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func cancelCurrentRequest() {
        dataRequest.cancel()
    }
    
    fileprivate static func getDataFromImage(imageName imgNm: String, postImage img:UIImage) -> Data {
        if (imgNm.fileExtensionOnly().localizedCaseInsensitiveContains("png")){
            return UIImagePNGRepresentation(img)!
        }
        else {
            return UIImageJPEGRepresentation(img, 1.0)!
        }
    }
    
    fileprivate static func getMimeType(imageName imgNm:String ) -> String{
        return (WebRequester.acceptableImageContentTypes.contains("image/\(imgNm.fileExtensionOnly())")
            ? "image/\(imgNm.fileExtensionOnly())" : "")
    }
    
    private static var acceptableImageContentTypes: Set<String> = [
        "image/tiff",
        "image/jpeg",
        "image/jpg",
        "image/gif",
        "image/png",
        "image/ico",
        "image/x-icon",
        "image/bmp",
        "image/x-bmp",
        "image/x-xbitmap",
        "image/x-ms-bmp",
        "image/x-win-bitmap"
    ]
    
}

extension UIImageView{
    
    func downLoadImage(url: String, placeHolderImage img: UIImage = #imageLiteral(resourceName: "Blackdot")) {
        let indicator:UIActivityIndicatorView = {
            let activityInd = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityInd.translatesAutoresizingMaskIntoConstraints = false
            activityInd.color = .lightGray
            activityInd.startAnimating()
            activityInd.hidesWhenStopped = true
            return activityInd
        }()
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.image = img
        if !(url.isEmpty) {
            Alamofire.request(url).responseImage { (response) in
                if let image = response.result.value {
                    self.image = image
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }else{
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}
