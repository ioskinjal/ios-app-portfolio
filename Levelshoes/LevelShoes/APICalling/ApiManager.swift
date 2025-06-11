//
//  ApiManager.swift
//  FingerPrint
//
//  Created by MobileCoderz5 on 1/11/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ApiManager: NSObject {
    static var sliderCache = [String: LandingPageData]()
    
    class func getStoreCode(for category: String) -> String {
        let storeCode = "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        return storeCode
    }
    
    class func getLandingPageData(url: String, category: String, completion:((_ data: LandingPageData?)-> Void)?) {
        let gender = getGenderMobile(for: category)
        let parameters = "{\"query\": {\"bool\": {\"must\": [{                \"match\": {\"identifier\": \"" + gender + "\"                   }}]}}}"
        let dic = convertToDictionary(text: parameters)
        let url = getCMSUrl(for: category)
        //print("getLandingPageData url \(url) category \(category)\nparams\n \(parameters)\n=======")
        
        DispatchQueue.global().async {
            ApiManager.apiPostWithHeaderCode(url: url, params: dic!) {(response:JSON?, error:Error?, statusCode: Int ) in
                if response != nil, statusCode == 200 {
                    let dict = response?.dictionaryObject
                    let hits = dict?["hits"] as! [String : AnyObject] as [String: AnyObject]
                    let innerHits = hits["hits"] as? [[String : Any]]
                    let _source = innerHits?.first?["_source"] as? [String: AnyObject]
                    var dictionary = [String:Any]()
                    dictionary["data"] = _source
                    completion?(LandingPageData(dictionary: ResponseKey.fatchData(res: dictionary, valueOf: .data).dic))
                }
            }
        }
    }
    
    class func getCMSUrl(for category: String) -> String {
        let storeCode = ApiManager.getStoreCode(for: category)
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_" + storeCode
        let url =  localizedUrl + "/" + CommonUsed.globalUsed.cmsBlockDoc + "/" + CommonUsed.globalUsed.ESSearchTag
        
        return url
    }
    class func versionCheckLanding(_ completion:(() -> Void)? = nil){
        DispatchQueue.global(qos: .background).async {
                   let array = ["women", "men", "kids"]
                   let group = DispatchGroup()
                   
                   for cat in array {
                       let url = Self.getCMSUrl(for: cat)
                      
                       group.enter()
                       Self.getLandingPageData(url: url, category: cat) { data in
                           guard let val = data else { completion?(); return }
                           
                           guard let dataList = val._sourceLanding?.dataList else { return }
                        
                           for data in dataList {
                               for d in data.arraydata {
                                   for val in d.elements {
                                       //print("title \(val.content)\ncategory_id \(val.category_id)")
                                   }
                               }
                           }
                        DispatchQueue.global().async {
                        
                        //print("Current: " + String(self.sliderCache[cat]!.version))
                        //print("Server: " + String(val.version))
                            if(self.sliderCache[cat]?.version ?? "0" != val.version){
                                UserDefaults.standard.set(true,forKey: "versionChanged")
                                return
                            }
                        group.leave()
                        }
                   }
                   UserDefaults.standard.set(false,forKey: "versionChanged")
                   group.wait()
                   DispatchQueue.main.async {
                       completion?()
                   }
               }
    }
    }
    class func cacheAllCategories(_ completion:(() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            let array = ["women", "men", "kids"]
            let group = DispatchGroup()
            
            for cat in array {
                let url = Self.getCMSUrl(for: cat)
                print("CACHING \(cat) \(url)")
                group.enter()
                Self.getLandingPageData(url: url, category: cat) { data in
                    guard let val = data else { completion?(); return }
                    
                    guard let dataList = val._sourceLanding?.dataList else { return }
                    print("========\ncategory \(cat)")
                    for data in dataList {
                        for d in data.arraydata {
                            for val in d.elements {
                                print("title \(val.content)\ncategory_id \(val.category_id)")
                            }
                        }
                    }
                    print("====end====")
                    Self.sliderCache[cat] = val
                    cacheImages(val: val)
                    DispatchQueue.global().async {
                        if let dataFirst = val._sourceLanding?.dataList.first, dataFirst.arraydata.count > 1, let url = URL(string: dataFirst.arraydata[1].url) {
                            let gifKey = "\(url.absoluteString)"
                            if let gifData = try? Data(contentsOf: url) {
                                UserDefaults.standard.setValue(gifData, forKey: gifKey)
                            }
                        }
                        group.leave()
                    }
                }
            }
            group.wait()
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    private class func cacheImages(val: LandingPageData) {
        guard let data = val._sourceLanding?.dataList[0].arraydata else { return }
        var url: URL?
        if data.count > 1 {
            url = URL(string: data[1].url)
        } else {
            url = URL(string: data[0].url)
        }
        UIImageView().sd_setImage(with: url)
    }
    private class func getGenderMobile(for category: String) -> String {
        let value: String
        if category == "women" {
            value = CommonUsed.globalUsed.landingWomen
        } else if category == "men" {
            value = CommonUsed.globalUsed.landingMen
        } else {
            value = CommonUsed.globalUsed.landingKids
        }
        return value
    }
    class  func apiPost(url: String, params: [String:Any], completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json, nil)
                } else {
                    completionHandler(nil, nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class func getHeaderContentType() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type":"text/html",
            "Accept": "text/html"
            
        ]
        return headers
    }
    
    //@"text/html"
    
    class  func apiPostWithType(url: String, params: [String:Any], completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.getHeaderContentType()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class  func apiPostWithHeader(url: String, params: [String:Any], completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    
    class  func apiPostWithHeaderCodeCheckout(url: String, params: [String:Any],headers:HTTPHeaders, completionHandler: @escaping (_ response:JSON?,_ error:Error? ,_ status: Int) -> ()) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    //                    if response.response!.statusCode == 401 {
                    //                        UserDefaults.standard.setValue(nil, forKey: "access_token")
                    //                        UserDefaults.standard.setValue(nil, forKey: "userId")
                    //                        UserDefaults.standard.set(nil, forKey: loginEmail)
                    //                        UserDefaults.standard.synchronize()
                    //                      //  QBHelper.sharedInstance.logout()
                    //                        kAppDelegate.setRoot()
                    //                    }
                    completionHandler(json,nil, response.response?.statusCode ?? 400)
                }
            case .failure(_):
                break
                //completionHandler(nil, response.result.error, response.response!.statusCode)
            }
        }
    }
    
    class  func apiPostWithHeaderCode(url: String, params: [String:Any], completionHandler: @escaping (_ response:JSON?,_ error:Error? ,_ status: Int) -> ()) { 
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    //                    if response.response!.statusCode == 401 {
                    //                        UserDefaults.standard.setValue(nil, forKey: "access_token")
                    //                        UserDefaults.standard.setValue(nil, forKey: "userId")
                    //                        UserDefaults.standard.set(nil, forKey: loginEmail)
                    //                        UserDefaults.standard.synchronize()
                    //                      //  QBHelper.sharedInstance.logout()
                    //                        kAppDelegate.setRoot()
                    //                    }
                    completionHandler(json,nil, response.response?.statusCode ?? 400)
                }
            case .failure(_):
                break
                //completionHandler(nil, response.result.error, response.response!.statusCode)
            }
        }
    }
    
    class  func apiPostWithCode(url: String, params: [String:Any], completionHandler: @escaping (_ response:JSON?,_ error:Error? ,_ status: Int) -> ()) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    //                    if response.response!.statusCode == 401 {
                    //                        UserDefaults.standard.setValue(nil, forKey: "access_token")
                    //                        UserDefaults.standard.setValue(nil, forKey: "userId")
                    //                        UserDefaults.standard.set(nil, forKey: loginEmail)
                    //                        UserDefaults.standard.synchronize()
                    //                        QBHelper.sharedInstance.logout()
                    //                        kAppDelegate.setRoot()
                    //                    }
                    
                    completionHandler(json,nil, response.response!.statusCode)
                }
            case .failure(_):
                //completionHandler(nil, response.result.error, 500)
                logoutUser()
            }
        }
    }
    
    
    
    @discardableResult
    class func apiGet(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) -> DataRequest {
        return Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class func apiGetWithHeader(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers:self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class func apiGetWithHeaderCode(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?,_ status:Int) -> ()) {
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers:nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    //                    if response.response!.statusCode == 401 {
                    //                        UserDefaults.standard.setValue(nil, forKey: "access_token")
                    //                        UserDefaults.standard.setValue(nil, forKey: "userId")
                    //                        UserDefaults.standard.set(nil, forKey: loginEmail)
                    //                        UserDefaults.standard.synchronize()
                    //                        QBHelper.sharedInstance.logout()
                    //                        kAppDelegate.setRoot()
                    //                    }
                    completionHandler(json,nil, response.response!.statusCode)
                }
            case .failure(_):
                completionHandler(nil, response.result.error!, 401)
            }
        }
    }
    
    
    class func apiGetWithSession(url :String, params: [String:String]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.SessionManager.default.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ApiManager.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
        
    }
    
    class func apiMultipart(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData:MultipartFormData) in
            for (key, value) in parameters! {
                if key == "uploaded_file" {
                    multipartFormData.append(
                        value as! Data,
                        withName: key,
                        fileName: "profileImage.jpg",
                        mimeType: "image/jpg"
                    )
                }
                else {
                    //multipartFormData
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 1, to: serviceName, method: .post, headers: nil) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.error != nil {
                        completionHandler(nil,response.result.error as NSError?)
                        return
                    }
                    if let data = response.result.value {
                        let json = JSON(data)
                        completionHandler(json,nil)
                    }
                }
                break
                
            case .failure(let encodingError):
                debugPrint(encodingError)
                completionHandler(nil,encodingError as NSError?)
                break
            }
        }
    }
    
    class  func apiDelete(url: String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class  func apiPut(url: String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
//                if(response.response?.statusCode == 200){
//                if let data = response.result.value {
//                    let json = JSON(data)
//                    completionHandler(json,nil)
//                    }
//                }
//                else if(response.response?.statusCode == 404){
//                    if let data = response.result.value {
//                        let json = JSON(data)
//                        completionHandler(json,response.result.error)
//                        }
//                    }
                if response.response != nil {
                    if let data = response.result.value {
                        let json = JSON(data)
                        completionHandler(json,nil)
                        }
                }
                else{
                     completionHandler(nil, response.result.error)
                }
               
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    class  func apiDeleteWithHeader(url: String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
    }
    
    
    
    class func apiGetWithHeaderDelete(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .delete, parameters: params, encoding: URLEncoding.default, headers:self.getHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
        
    }
    
    class func apiOmsGet(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers:self.getHeaderAuthenticate()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
        
    }
    class func apiOmsPost(url :String, params: [String:Any]?, completionHandler: @escaping (_ response:JSON?,_ error:Error?) -> ()) {
        print("Printitn Param \(params)")
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers:self.getHeaderAuthenticate()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.result.value {
                    let json = JSON(data)
                    completionHandler(json,nil)
                }
            case .failure(_):
                completionHandler(nil, response.result.error)
            }
        }
        
    }
    
    
    
    
    class func cancellAllSessionRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    enum MethodType: CGFloat {
        case get     = 0
        case post    = 1
        case put     = 2
        case delete  = 3
        case patch   = 4
    }
    
    class func methodName(_ method: MethodType)-> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        case .patch: return "PATCH"
            
        }
    }
    
    class func getHeader() -> HTTPHeaders {
        var  headers: HTTPHeaders
        
        //generate Header if user is not logged IN
        if(!M2_isUserLogin){
        headers = [
            
            "Authorization":  "No Auth",
            "Content-Type" : "application/json"
        ]
        }
        else{
        guard let token:String = UserDefaults.standard.value(forKey: string.userToken) as? String else {
                       return getHeader()
                   }
        //Generate Header with Token if user is logged in
        headers = [
                  "Content-Type" : "application/json",
                  "Authorization" : "Bearer \(token)"
              ]
       
        }
         return headers
    }
    class func getHeaderAuthenticate() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            
            "x-api-key":  CommonUsed.globalUsed.OMSAPIKey,
            "Content-Type" : "application/json",
            "Authorization" : CommonUsed.globalUsed.OMSAuthorization
        ]
        return headers
    }
    
    // MARK:- Checkout
    class func getHeaderWithAuth() -> HTTPHeaders {
        guard let token:String = UserDefaults.standard.value(forKey: string.userToken) as? String else {
            return getHeader()
        }
        let headers:HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        
        return headers
    }
   
    
    class func getQuoteID(params:[String:Any],success: @ escaping (String) -> () , failure:@escaping() -> ()){
        
        Alamofire.request(M2_generateQuateID, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp as? String ?? "")
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp as? String ?? "")
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    class func addItemInCart(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()){
        
        Alamofire.request(M2_addItemInCart, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                }else{
                     success(resp)
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    class func getCartItems(success: @ escaping (Data?) -> () , failure:@escaping() -> ()) {
        Alamofire.request(M2_getCartItems, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    success(response.data)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                }else if response.response?.statusCode == 404 {
                   
                    success(response.data)
                }
                else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    class func guestCartToLoggedUserCartConversionApiCall(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {

          Alamofire.request(M2_Guest_Cart_To_Logged_User_Cart_Conversion, method: .put, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
             
              switch response.result {
              case .success(let resp):
                  if response.response?.statusCode == 200 {
                      success(resp)
                  }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                  }else{
                      success(resp)
                  }
              case .failure:
                  failure()
              }
          }
      }
    
    // Cart Total
    class func getCheckoutTotal(success: @ escaping (Data?) -> () , failure:@escaping() -> ()) {
        Alamofire.request(M2_getCheckoutTotals, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    success(response.data)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    class func updateCartItem(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        guard let itemID = params["item_id"] else {
            failure()
            return
        }
       
        
        var paramData = ["cartItem" : params]
        let url:String = M2_updateCartItem + "/" + "\(itemID)"
        Alamofire.request(url, method: .put, parameters: paramData, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
           
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                }else{
                    success(resp)
                }
            case .failure:
                failure()
            }
        }
    }
    
    class func deleteCartItem(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        
        guard let itemID = params["itemId"] else {
            failure()
            return
        }
        let url:String = M2_deleteCartItem + "\(itemID)"
        
        Alamofire.request(url , method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                }else{
                    success(resp)
                }
            case .failure:
                failure()
            }
        }
    }
    
    
    class func addTowishList(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        
        guard let itemID = params["product_id"] else {
            failure()
            return
        }
        let url:String = M2_wishList + "\(itemID)"
        let paramDic = [
        "customer_id": UserDefaults.standard.value(forKey: "customerId")!
        ] as [String : Any]
        
        Alamofire.request(url , method: .post, parameters: paramDic, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp)
                     addWishListArray(productId: "\(params["sku"]!)")
                } else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                } else {
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    class func getWishList(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        
        guard let customer_id = params["customer_id"] else {
            failure()
            return
        }
        let url:String = M2_WishList_Get + "\(customer_id)"
        
        Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    class func removeWishList(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        
        guard let itemID = params["product_id"] else {
            failure()
            return
        }
        let url:String = M2_WishList_Remove + "\(itemID)"
        
        Alamofire.request(url , method: .post, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    removeWishListArray(productId: params["sku"] as! String)
                    success(resp)
                   
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    class func removeCoupons(params:[String:Any],success: @ escaping (Any) -> () , failure:@escaping() -> ()) {
        
       
        let url:String = M2_Coupon_Remove
        
        Alamofire.request(url , method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    
                    success(resp)
                   
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp)
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
  
    class func getCustomerInformation(success: @ escaping (Data?) -> () , failure:@escaping() -> ()) {
        Alamofire.request(M2_getCustomerInformation, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {

                    
                    success(response.data)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                    
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    class func getShippingInformation(success: @ escaping (Data?) -> () , failure:@escaping() -> ()) {
          Alamofire.request(M2_shippingAddress, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
              
              switch response.result {
              case .success:
                  if response.response?.statusCode == 200 {

                      
                      success(response.data)
                  }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                  }else{
                      failure()
                  }
              case .failure:
                  failure()
              }
          }
      }
    class func getBillingInformation(success: @ escaping (Data?) -> () , failure:@escaping() -> ()) {
             Alamofire.request(M2_billingAddress, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
                 
                 switch response.result {
                 case .success:
                     if response.response?.statusCode == 200 {

                         success(response.data)
                     }else if response.response?.statusCode == 401 {
                        logoutUser()
                        success(response.data)
                     }else{
                         failure()
                     }
                 case .failure:
                     failure()
                 }
             }
         }
    class func getShippingEstimatedMethod(params:[String:Any], success: @ escaping (Data?) -> () , failure:@escaping([String:Any]) -> ()) {
        Alamofire.request(M2_shippingMethod, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success (let resp):
                if response.response?.statusCode == 200 {
                    success(response.data)
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                }else{
                    failure(parseError(resp))
                }
            case .failure:
                failure(parseError(response))
            }
        }
    }
    class func setShippingInformation(params:[String:Any], success: @ escaping (Data?) -> () , failure:@escaping([String:Any]) -> ()) {
          Alamofire.request(M2_shippingInformation, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
              
              switch response.result {
              case .success (let resp):
                  if response.response?.statusCode == 200 {
                      success(response.data)
                  }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(response.data)
                  }else{
                      failure(parseError(resp))
                  }
              case .failure:
                  failure(parseError(response))
              }
          }
      }
    class func createorderThoughOMS(params: [String:Any], success: @ escaping (String) -> () , failure:@escaping([String:Any]) -> ()){
        let headers: HTTPHeaders = [
            "x-api-key" : CommonUsed.globalUsed.OMSAPIKey,
            "Authorization" : CommonUsed.globalUsed.OMSAuthorization
        ]
        Alamofire.request(OMS_OMSOrder, method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp as? String ?? "")
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    failure(parseError(resp))
                }else{
                    failure(parseError(resp))
                }
            case .failure:
                failure(parseError(response))
            }
        }
    }
    
    class func addAddress(params:[String:Any],success: @ escaping (Data) -> () , failure:@escaping([String:Any]) -> ()) {
        
        let url:String = M2_addNewAddress
        
        print(params)
        
        Alamofire.request(url , method: .put, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(response.data ?? Data())
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    failure(parseError(resp))
                }else{
                    failure(parseError(resp))
                }
            case .failure:
                failure(parseError(response))
            }
        }
    }
    
    class func saveChangePref(params:[String:Any],success: @ escaping (_ response:JSON?,_ error:Error?) -> () , failure:@escaping([String:Any]) -> ()) {
           
        
        print(params)
        
           let url:String = M2_getCustomerInformation
           
           Alamofire.request(url , method: .put, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
               
               switch response.result {
               case .success(let resp):
                   if response.response?.statusCode == 200 {
                    if let data = response.result.value {
                        let json = JSON(data)
                        success(json, nil)
                    } else {
                        success(nil, nil)
                    }
                     
                   }else if response.response?.statusCode == 401 {
                    logoutUser()
                    failure(parseError(resp))
                   }else{
                       failure(parseError(resp))
                   }
               case .failure:
                   failure(parseError(response))
               }
           }
       }
    
    
    // InActive cart
    class func cartInActiveByCustomerToken(params: [String: Any], success: @ escaping (String) -> () , failure:@escaping() -> ()){
        
        Alamofire.request(M2_inActiveCart, method: .put, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    
                   
                    success(resp as? String ?? "")
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp as? String ?? "")
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    // InActive cart - Blankcall to Billing Address # Temporary Solution
    class func billingAddressByCustomerToken(params: [String: Any], success: @ escaping (String) -> () , failure:@escaping() -> ()){
        
        Alamofire.request(M2_inActiveBilling, method: .get, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp as? String ?? "")
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp as? String ?? "")
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    class func generateQuateID(success: @ escaping (String) -> () , failure:@escaping() -> ()){
        
        Alamofire.request(M2_generateQuateID, method: .post, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 200 {
                    success(resp as? String ?? "")
                }else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp as? String ?? "")
                }else{
                    failure()
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    
    class func redeemGiftcardAfteruse(params: [String:Any], success: @ escaping (String) -> () , failure:@escaping() -> ()){
        Alamofire.request(M2_giftcardRedeem,method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaderWithAuth()).responseJSON { (response) in
             print(response.result)
            }
    }
    
    class func checkoutPaymentGateway(params: [String:Any], success: @ escaping ([String:Any]) -> () , failure:@escaping() -> ()){
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization" : getCheckoutSecretKey()
        ]
        Alamofire.request(CommonUsed.globalUsed.checkoutPaymentUrl, method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode == 201 {
                    success(resp as? [String:Any] ?? [String:Any]())
                }
                else if response.response?.statusCode == 202 {
                    success(resp as? [String:Any] ?? [String:Any]())
                }
                else if response.response?.statusCode == 401 {
                    logoutUser()
                    success(resp as? [String:Any] ?? [String:Any]())
                }else{
                    //success()
                }
            case .failure:
                failure()
            }
            
        }
    }
    
    class func parseError(_ errorResponse:Any) ->[String:Any]{
        let er:[String:Any] = [:]
        guard let dict:[String:Any] = errorResponse as? [String:Any] else{
            return er
        }
        guard let messages:[String:Any] = dict["messages"] as? [String:Any] else{
            return er
        }
        guard let error:[[String:Any]] = messages["error"] as? [[String:Any]] else{
            return er
        }
        return error[0]
    }
    
}
func logoutUser()  {

    UserDefaults.standard.removePersistentDomain(forName: "UserKey")

    UserDefaults.standard.removeObject(forKey: "UserKey")

     UserDefaults.standard.removeObject(forKey: "userToken")

    UserDefaults().synchronize()



    //User is Not Loggedin case Handle

    userLoginStatus(status: false)

    M2_isUserLogin = false

    getGuestQuoteId()

    let app = UIApplication.shared

    app.registerForRemoteNotifications()

    let alert = UIAlertController(title: "Level Shoes", message: "try_login".localized, preferredStyle: UIAlertController.Style.alert)

    // add an action (button)
    alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertAction.Style.default, handler: nil))

    // show the alert
   

    //...

    var rootViewController = UIApplication.shared.keyWindow?.rootViewController

    if let navigationController = rootViewController as? UINavigationController {

        rootViewController = navigationController.viewControllers.first

    }

    if let tabBarController = rootViewController as? UITabBarController {

        rootViewController = tabBarController.selectedViewController

    }

    //...

    rootViewController?.present(alert, animated: true, completion: nil)

    goToLogin()

}



func getGuestQuoteId(){


        ApiManager.getQuoteID(params: [:], success: { (resp) in



            UserDefaults.standard.set(resp, forKey: "guest_carts__item_quote_id")

            UserDefaults.standard.synchronize()

          userLoginStatus(status: false)

        })  {

            // quote failure

            // failure()

        }

    



}





func goToLogin(){

    let appdelegte = UIApplication.shared.delegate as! AppDelegate
    let nav = UINavigationController()
    nav.setNavigationBarHidden(true, animated: true)
    nav.pushViewController(LoginViewController.storyboardInstance!, animated: true)
    appdelegte.window?.rootViewController = nav
    appdelegte.window?.makeKeyAndVisible()





}
