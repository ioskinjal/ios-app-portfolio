
//
//  WebRequester.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NMS. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WebRequester {
    private init(){}
    static let shared = WebRequester()
    var dataRequest:DataRequest!
    private var timeOutCounter = 0
    
    private func printSendData(url:String, param parameter:dictionary){
        print("\n**********************")
        print("URL: \(url)")
        print("Parameters:\n")
        for val in parameter.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
        print("**********************\n")
    }
    
    private func manageFailure(error:Error, isLoader:Bool = true, isRapidCall:Bool, isRetry:Bool, rapidCall: @escaping ()->Void, completion:@escaping(APIResult<Any>)->Void) {
        if isRapidCall{
            if error.code == NSURLErrorNotConnectedToInternet {
                self.timeOutCounter = 0
                completion(APIResult.failure(error))
                return
            }else if (error.code == NSURLErrorCancelled || error.code == NSURLErrorNetworkConnectionLost){
                print("NSURLErrorCancelled || NSURLErrorNetworkConnectionLost")
                //rapidCall()
                completion(APIResult.failure(error))
                return
            }else if error.code == NSURLErrorTimedOut {
                print("NSURLErrorTimedOut")
                if self.timeOutCounter < 2{
                    self.timeOutCounter = self.timeOutCounter + 1
                    rapidCall()
                }else{
                    //API.sharedAppdelegate.stoapLoader()
                    self.timeOutCounter = 0
                    if isRetry{
                        UIApplication.alert(title: "", message: error.localizedDescription, actions: ["Retry".localized, "Cancel".localized], style: [.default, .cancel], completion: { (flag) in
                            if flag == 0{ //Retry
                                rapidCall()
                            }else{ //Cancel
                                print("Cancel request")
                            }
                        })
                    }
                }
                return
            }
        }
        self.timeOutCounter = 0
        completion(APIResult.failure(error))
    }
    
    func requests(url:String, method:HTTPMethod = .post, timeInterval interval: TimeInterval = 60, parameter:dictionary = dictionary(), isLoader:Bool = true, isRapidCall:Bool = true, isRetry:Bool = true, completion:@escaping(APIResult<Any>)->Void){

        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        // add your custom header
        headers["Auth-API-Token"] = UserData.shared.accessToken
        print(headers)
        
        func rapidCall(){
            self.requests(url: url, method: method, timeInterval: interval, parameter: parameter, isLoader: isLoader, isRapidCall: isRapidCall, completion: completion)
        }
        if isLoader { API.sharedAppdelegate.startLoader() }
        printSendData(url: url, param: parameter)
        let manager = SessionManager.getConfigureManager(withTimeInterval: interval)//default 60
        if parameter.isEmpty {
            dataRequest = manager.request(url, method: method, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    //print("Respones: \(value)")
                    self.timeOutCounter = 0
                    completion(APIResult.success(value))
                case.failure(let error):
                    self.manageFailure(error: error, isLoader:isLoader, isRapidCall: isRapidCall, isRetry: isRetry, rapidCall: rapidCall, completion: completion)
                }
            }
        }else{
            dataRequest = manager.request(url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    //print("Respones: \(value)")
                    self.timeOutCounter = 0
                    completion(APIResult.success(value))
                case.failure(let error):
                    self.manageFailure(error: error, isLoader: isLoader, isRapidCall: isRapidCall, isRetry: isRetry, rapidCall: rapidCall, completion: completion)
                }
            }
        }
    }
    
    func requestsWithAttachments(url:String, method:HTTPMethod = .post, timeInterval interval: TimeInterval = 60,
                                 parameter:dictionary = dictionary(),
                                 withParamName:String, withParamNameAry:[String] = [String](),
                                 withPostImage postImg:UIImage? = nil, withPostImageName imgName:String? = nil ,
                                 withPostImageAry postImgsAry:[UIImage] = [UIImage](),
                                 withFileData file:Data? = nil, withFileName fileName:String? = nil,
                                 withFileAry filesAry:[Data] = [Data](),
                                 withFileNameAry fileNameAry:[String] = [String](),
                                 isLoader:Bool = true, isRapidCall:Bool = false, isRetry:Bool = true,
                                 completion:@escaping(APIResult<Any>)->Void){
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        // add your custom header
        headers["Auth-API-Token"] = UserData.shared.accessToken
        print(headers)
        
        func rapidCall(){
            requestsWithAttachments(url: url, timeInterval: interval,
                                    parameter:parameter,
                                    withParamName:withParamName, withParamNameAry:withParamNameAry,
                                    withPostImage:postImg, withPostImageName: imgName,
                                    withPostImageAry: postImgsAry,
                                    withFileData: file, withFileName: fileName,
                                    withFileAry: filesAry,
                                    withFileNameAry: fileNameAry,
                                    isLoader:isLoader,
                                    completion:completion)
        }
        if isLoader { API.sharedAppdelegate.startLoader() }
        self.printSendData(url: url, param: parameter)
        let manager = SessionManager.getConfigureManager(withTimeInterval: interval)//default 60
        manager.upload(
            multipartFormData: { multipartFormData in
                //image upload code execute
                if postImg != nil || postImgsAry.count > 0{
                    if postImgsAry.count > 0{
                        //Multiple image upload
                        for (i,img) in postImgsAry.enumerated() {
                            multipartFormData.append(WebRequester.getDataFromImage(imageName: fileNameAry[i], postImage: img), withName: "\(withParamName)[\(i)]", fileName: fileNameAry[i], mimeType: WebRequester.getMimeType(imageName: fileNameAry[i]))
                            print("\(withParamName)[\(i)]: \(fileNameAry[i]) => \(String(describing: img))")
                        }
                        print("**********************")
                    }else if let postImg = postImg{
                        //Single image upload
                        let imgNm = (imgName == nil ? "img_\(Date().millisecondsSince1970).jpeg" : imgName!)
                        let imgData:Data = WebRequester.getDataFromImage(imageName: imgNm, postImage: postImg)
                        multipartFormData.append(imgData,
                                                 withName: withParamName, fileName: imgNm,
                                                 mimeType: WebRequester.getMimeType(imageName: imgNm))
                        print("[\(withParamName)]: \(imgNm) => \(String(describing: postImg))")
                        print("**********************")
                    }
                }else{
                    //File upload code execute
                    if let postFile = file, let fileName = fileName{
                        //Single File upload
                        multipartFormData.append(postFile,
                                                 withName: withParamName, fileName: fileName,
                                                 mimeType: "")
                        print("[\(withParamName)]: \(fileName) => \(String(describing: postFile))")
                        print("**********************")
                    }
                    else if filesAry.count > 0{
                        //Multiple File upload
                        for (i,file) in filesAry.enumerated() {
                            multipartFormData.append(file, withName: "\(withParamName)[\(i)]", fileName: fileNameAry[i], mimeType: "")
                            print("\(withParamName)[\(i)]: \(fileNameAry[i]) => \(String(describing: file))")
                        }
                        print("**********************")
                    }
                }
                
                //Other params are added
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
        },
            usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, //UInt64.init(),//this new line added
            to: url,
            method: method,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        print("Uploaded \(progress.fractionCompleted.roundToDecimal(2))%")
                    }
                    upload.responseJSON { response in
                        switch response.result{
                        case .success(let value):
                            print("Respones: \(value)")
                            self.timeOutCounter = 0
                            completion(APIResult.success(value))
                        case.failure(let error):
                            print("ResponesError: \(error)")
                            completion(APIResult.failure(error))
                        }
                    }
                    break
                case .failure(let error):
                    //Uploading time error
                    self.manageFailure(error: error, isRapidCall: isRapidCall, isRetry: isRetry, rapidCall: rapidCall, completion: completion)
                    break
                }
        })
    }
}

class Networking {
    static let sharedInstance = Networking()
    static var appIdentifier:String {
        return Bundle.main.bundleIdentifier ?? "com.app.test"
    }
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: Networking.appIdentifier))
    }
    static func dispatch(withMode dispatchMode:DispatchMode = .default, timeInterval interval: TimeInterval) -> Alamofire.SessionManager {
        switch dispatchMode {
        case .default:
            let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
            
            manager.session.configuration.timeoutIntervalForRequest = interval
            return manager
        case .background:
            let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: Networking.appIdentifier))
            manager.session.configuration.timeoutIntervalForRequest = interval
            return manager
        }
    }
}


extension DispatchQueue{
    static var background:DispatchQueue {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier ?? "com.app.test", qos: .background, attributes: .concurrent)
        return queue
    }
    static var `default`:DispatchQueue {
        //let queue = DispatchQueue(label: Bundle.main.bundleIdentifier ?? "com.app.test", qos: .default, attributes: .concurrent)
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier ?? "com.app.test", qos: .default, attributes: .concurrent)
        return queue
    }
}

extension SessionManager{
    static func getConfigureManager(withTimeInterval interval: TimeInterval) -> SessionManager {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = interval //default 60
        return manager
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
        if (imgNm.fileExtensionOnly().caseInsensitiveCompare(string: "png")){
            return img.pngData()!
        }
        else {
            return img.jpegData(compressionQuality: 1.0)!//UIImageJPEGRepresentation(img, 1.0)!
        }
    }
    
    fileprivate static func getMimeType(imageName imgNm:String ) -> String{
        return (WebRequester.acceptableImageContentTypes.contains("image/\(imgNm.fileExtensionOnly().lowercased())")
            ? "image/\(imgNm.fileExtensionOnly().lowercased())" : "")
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
    func downLoadImage(url: String, placeHolderImage img: UIImage = #imageLiteral(resourceName: "small-Image-Place-Holder")) {
        let indicator:UIActivityIndicatorView = {
            let activityInd = UIActivityIndicatorView(style: .white)
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
        self.tag = 333
        if !(url.isEmpty) {
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let _url = URL(string: urlString){
                self.af_setImage(withURL: _url, placeholderImage: img) { (response) in
                    if let image = response.result.value {
                        self.image = image
                        self.tag = 0
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                    }
                }
            }
//            Alamofire.request(url).responseImage { (response) in
//                if let image = response.result.value {
//                    self.image = image
//                    indicator.stopAnimating()
//                    indicator.removeFromSuperview()
//                }
//            }
        }else{
            self.tag = 0
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}


extension Date {
    var millisecondsSince1970:String {
        return String(format: "%.0f", (self.timeIntervalSince1970 * 1000.0).rounded())
        //return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
}


//extension UIImage{
//    func getSizeInMB() -> Double {
//        //let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        let imgData = NSData(data: self.jpegData(compressionQuality: 1)!)
//        let bytes: Int = imgData.count
//
//        let kB = Double(bytes) / 1000.0 // Note the difference
//        let KB = Double(bytes) / 1024.0 // Note the difference
//        let MB = KB / 1024.0
//
//        print("size of image in kB: %f ", kB)
//        print("size of image in KB: %f ", KB)
//        print("size of image in MB: %f ", MB)
//
//        return MB
//    }
//}


extension String {
    func getNumbers() -> [NSNumber] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let charset = CharacterSet.init(charactersIn: " ,.")
        return matches(for: "[+-]?([0-9]+([., ][0-9]*)*|[.][0-9]+)").compactMap { string in
            return formatter.number(from: string.trimmingCharacters(in: charset))
        }
    }
    
    // https://stackoverflow.com/a/54900097/4488252
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
}

//https://stackoverflow.com/questions/34262791/how-to-get-image-file-size-in-swift
extension UIImage {
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB,
                         countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
        // https://developer.apple.com/documentation/foundation/bytecountformatter
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.countStyle = countStyle
        return getSizeInfo(formatter: formatter)
    }
    
    func getFileSize(allowedUnits: ByteCountFormatter.Units = .useMB,
                     countStyle: ByteCountFormatter.CountStyle = .memory) -> Double? {
        guard let num = getFileSizeInfo(allowedUnits: allowedUnits, countStyle: countStyle)?.getNumbers().first else { return nil }
        return Double(truncating: num)
    }
    
    func getSizeInfo(formatter: ByteCountFormatter, compressionQuality: CGFloat = 1.0) -> String? {
        guard let imageData = jpegData(compressionQuality: compressionQuality) else { return nil }
        return formatter.string(fromByteCount: Int64(imageData.count))
    }
}

/*
 guard let image = UIImage(named: "img") else { return }
 if let imageSizeInfo = image.getFileSizeInfo() {
 print("\(imageSizeInfo), \(type(of: imageSizeInfo))") // 51.9 MB, String
 }
 
 if let imageSizeInfo = image.getFileSizeInfo(allowedUnits: .useBytes, countStyle: .file) {
 print("\(imageSizeInfo), \(type(of: imageSizeInfo))") // 54,411,697 bytes, String
 }
 
 if let imageSizeInfo = image.getFileSizeInfo(allowedUnits: .useKB, countStyle: .decimal) {
 print("\(imageSizeInfo), \(type(of: imageSizeInfo))") // 54,412 KB, String
 }
 
 if let size = image.getFileSize() {
 print("\(size), \(type(of: size))") // 51.9, Double
 }
 */




extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

typealias dictionary = [String:Any]

enum DispatchMode{
    case background
    case `default`
    
    var type:DispatchQueue{
        switch self {
        case .background:
            return DispatchQueue.background
        case .default:
            return DispatchQueue.default
        }
    }
    
}
