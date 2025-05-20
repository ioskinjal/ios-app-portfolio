//
//  InstaViewController.swift
//  XPhorm
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

var instaParamDict = [String:Any]()
var isBackFromInsta = false
var isemail = ""
struct API {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "3ecb229d2f7a467a82967aeb1e902a64"
    
    static let INSTAGRAM_CLIENTSERCRET = "ccf4791bb1a9454db9c80312237d600b"
    
    static let INSTAGRAM_REDIRECT_URI = "https://www.xphorm.com/"
    
    static var INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "basic"
    
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
}

class InstaViewController: UIViewController {
    
    static var storyboardInstance:InstaViewController? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: InstaViewController.identifier) as? InstaViewController
    }

    @IBOutlet weak var webView: UIWebView!{
        didSet{
            webView.delegate = self
        }
    }
    var parentVC = LoginVC()
    var isFromLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.domain.contains(".instagram.com") {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
        
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
    }
    
    func getUserInfo(completion: @escaping ((_ data: Bool) -> Void)){
        let url = String(format: "%@%@", arguments: [API.INSTAGRAM_USER_INFO,API.INSTAGRAM_ACCESS_TOKEN])
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                completion(false)
                //failure
                return
            }
            print(data!)
            // make sure we got data
            guard let responseData = data else {
                completion(false)
                //Error: did not receive data
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject]) != nil else {
                        completion(false)
                        //Error: did not receive data
                        return
                }
                completion(true)
                let data = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject]
                print(data!)
                let dict:[String:Any] = data?["data"] as! [String : Any]
                print(dict)
                let str:String = dict["full_name"] as! String
                let array:NSArray = str.components(separatedBy: " ") as NSArray
                 var fnm = ""
                var lnm = "Instagram"
                if array.count != 0{
                 fnm = array[0] as? String ?? ""
                     if array.count > 1{
                 lnm = array[1] as? String ?? ""
                    }
                }
                if self.isFromLogin{
                    self.checkInstagram(fNm: fnm , lNm:lnm , loginType: "instagram", socialId: dict["id"] as? String ?? "", email: "", profile_pic: dict["profile_picture"] as? String ?? "")
                    
                }else{
                self.socilaLogin(fNm: fnm , lNm:lnm, loginType: "instagram", socialId: dict["id"] as? String ?? "", email: "", profile_pic: dict["profile_picture"] as? String ?? "")
                }
                // success (dataResponse) dataResponse: contains the Instagram data
            } catch let err {
                print(err)
                completion(false)
                
                //failure
            }
        })
        task.resume()
    }
    
    func checkInstagram(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String){
        let dictparam = ["action":"checkInstagram",
                         "socialId":socialId,
                         "lId":UserData.shared.getLanguage]
        
        Modal.shared.signUp(vc: self, param: dictparam) { (dic) in
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            instaParamDict = ["first_name":fNm,
                            "last_name": lNm,
                            "provider": loginType,
                            "email": email,
                            "thumbnail":profile_pic,
                            "deviceId":UserData.shared.deviceToken,//UserData.shared.deviceToken,
                "action":"submitSocial",
                "deviceType":"i",
                "lId":UserData.shared.getLanguage,
                "id":socialId
            ]
            isBackFromInsta = true
            isemail = data["email"] as! String 
          self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        API.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        getUserInfo(){(data) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        let dicParam = ["provider": loginType,
                        "email": email,
                        "action":"socialVerify",
                        "lId":UserData.shared.getLanguage,
                        "userId":UserData.shared.getUser()?.id ?? ""
        ]
        
        Modal.shared.signUp(vc: self, param: dicParam) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InstaViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
extension InstaViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
}
