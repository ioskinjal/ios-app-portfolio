//
//  FacebookSignInManager.swift
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

/**
 Usage of FacebookSignInManager
 //You may refer this link for more detail and understing how facebook login perform
 //https://medium.com/@joshgare/how-to-integrate-the-ios-facebook-sdk-in-swift-4-9c0192ce7dbf
 
 //Create your project on facebook
 //https://developers.facebook.com/apps/
 //https://developers.facebook.com/apps/876153579407397/fb-login/quickstart/
 
 //Put this code into Info.plist
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb{your-app-id}</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>{your-app-id}</string>
<key>FacebookDisplayName</key>
<string>{your-app-name}</string>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbapi</string>
    <string>fb-messenger-share-api</string>
    <string>fbauth2</string>
    <string>fbshareextension</string>
</array>
 
 
 //Finally you will need to replace {your-app-id} and {your-app-name} with your App ID and App Name from the Facebook Apps Dashboard.
 
 //Add below code into AppDelegate.swift
 
 //Step 1:
 import FBSDKLoginKit
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
 
    //facebook sign initialize
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

    return true
 }
 
 //Step 2:
 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let appId: String = Settings.appId
    if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    return false
 }
 
 //IF GOOGLE AND FACEBOOK LOGIN PUT BELOW CODE
 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     print("appdelegate open url  call")
        let appId: String = Settings.appID //FacebookAppID
        let facebookHandler = (url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" ? ApplicationDelegate.shared.application(app, open: url, options: options) : false)
 
     if(facebookHandler) {
        return facebookHandler
     }
     return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
 }

 
 //Add below code into ViewController.swift
 //Step 1
 @IBAction func facebookLogin(_ sender: Any) {
     FacebookSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo,errStr)  in
        if let errStr = errStr{
            print(errStr)
        }else{
            print(userInfo.firstName)
        }
     }
 }
 
 //Step 2
 @IBAction func logout(_ sender: Any) {
    FacebookSignInManager.shared.logoutFromFacebook()
 }
 
 */


class FacebookSignInManager: NSObject {
    
    static var shared = FacebookSignInManager()
    
    typealias basicInfo = (socialId:String, firstName:String, lastName:String, email:String, profileUrl:String)
    typealias fbBasicInfo =  (basicInfo,_ error:String?) -> Void
    
    typealias fbLoginData =  (_ userInfo: [String:Any]?, _ error: String?) -> Void
    
    
    private let permissionDictionary = [
        "fields" : "id,name,first_name,last_name,email,picture.type(large)",
        //"locale" : "en_US"
        //"fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"
    ]
    
    func basicDataWithCompletionHandler(fromViewController vc:UIViewController, completion: @escaping fbLoginData){
        self.fbLogin(fromViewController: vc, completion: completion)
    }
    
    /**
     This function return in basic information of login user in block with same sequence of (socialId, firstName, lastName, email, profileUrl, error)
     */
    func basicInfoWithCompletionHandler(fromViewController vc:UIViewController, completion: @escaping fbBasicInfo){
        self.fbLogin(fromViewController: vc) { (userInfo, errStr) in
            if errStr != nil{
                completion(basicInfo("","","","",""),errStr)
            }else{
                if let userInfo = userInfo{
                    let socialId = userInfo["id"] as? String ?? ""
                    let fnm = userInfo["first_name"] as? String ?? ""
                    let lnm = userInfo["last_name"] as? String ?? ""
                    let email = userInfo["email"] as? String ?? ""
                    var profileUrl:String = ""
                    if let picture = userInfo["picture"] as? [String: Any],
                        let pictureData = picture["data"] as? [String : Any],
                        let url = pictureData["url"] as? String {
                        profileUrl = url
                    }
                    completion(basicInfo(socialId,fnm,lnm,email,profileUrl),nil)
                }
            }
        }
    }
    
    private func fbLogin(fromViewController vc:UIViewController, completion: @escaping fbLoginData){
        if AccessToken.current != nil{
            //import FBSDKLoginKit used for this function
            GraphRequest(graphPath: "/me", parameters: permissionDictionary).start(completionHandler: { (connection, result, error) in
                if error == nil {
                    completion(result as? [String:Any],nil)
                } else {
                    completion(nil, error?.localizedDescription)
                }
            })
        }else{
            //import FacebookLogin used for this function
            LoginManager().logIn(permissions: [.email,.publicProfile], viewController: vc) { (result) in
                switch result{
                case .success(_,_,let token):
                    let pictureRequest = GraphRequest(graphPath: "me", parameters: self.permissionDictionary,tokenString:token.tokenString,version: nil,httpMethod:HTTPMethod.post)
                    let _ = pictureRequest.start(completionHandler: { (connection, result, error) -> Void in
                        if error == nil {
                            completion(result as? [String:Any],nil)
                        } else {
                            completion(nil, error?.localizedDescription)
                        }
                    })
                case .cancelled:
                    completion(nil,"Cancel FBLogin")
                    print("Cancel FBLogin")
                case .failed(let error):
                    completion(nil,error.localizedDescription)
                }
                
            }
        }
    }
    
    func logoutFromFacebook() {
        print("Facebook Logout")
        LoginManager().logOut()
    }
}
