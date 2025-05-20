//
//  GoogleSignInManager.swift
//

import UIKit
import GoogleSignIn

/**
 Usage of GoogleSignInManager
 
 
 - Step 1: Setup google sign in process following link
 
    [Click here for Reference](https://developers.google.com/identity/sign-in/ios/start?ver=swift)

 
 
 - Step 2: Put this code into Info.plist
 
       <key>CFBundleURLTypes</key>
       <array>
       <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string><#{REVERSED_CLIENT_ID}#></string>
            </array>
            </dict>
        </array>
 
 
 
 * Step 3: Add below code into AppDelegate.swift
 
         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
 
             //google sign initialize
             GIDSignIn.sharedInstance().clientID = "<CLIENT_ID>" //Refer GoogleService-Info.plist
 
            return true
         }
 
 - IF ONLY GOOGLE LOGIN PUT BELOW CODE
 
         func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
         }
 
 - IF GOOGLE AND FACEBOOK LOGIN PUT BELOW CODE
 
         func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
             print("appdelegate open url  call")
             let facebookHandler = SDKApplicationDelegate.shared.application(app, open: url, options: options)
 
             if(facebookHandler) {
                return facebookHandler
             }
             return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
         }

 
 * Step 4: Usage - Add below code into ViewController.swift
 
       fileprivate func googleLogin(){
           GoogleSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
              if let errStr = errStr{
                  print(errStr)
              }else{
                 print(userInfo.firstName)
                 print(userInfo.lastName)
                 print(userInfo.socialId)
                 print(userInfo.profileUrl)
                 print(userInfo.email)
 
                <#CALL_YOUR_SOCIAL_LOGIN_API#>
 
              }
          }
       }
 
 
       @IBAction func onClickGoogleLogin(_ sender: Any) {
            self.googleLogin()
       }
 
 
 */

class GoogleSignInManager: NSObject {

    static let shared = GoogleSignInManager()
    var currentVC : UIViewController?
    
    typealias basicInfo = (socialId:String, firstName:String, lastName:String, email:String, profileUrl:String)
    typealias googleBasicInfo =  (basicInfo,_ error:String?) -> Void
    
    typealias googleLoginData =  (_ userInfo: GIDGoogleUser?, _ error: String?) -> Void
    private var googleLoginDataBlock : ((_ userInfo: GIDGoogleUser?, _ error: Error?) -> Void)?
    
    
    func googleSignOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func basicInfoWithCompletionHandler(fromViewController vc:UIViewController, completion: @escaping googleBasicInfo){
        self.currentVC = vc
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
        self.googleLoginDataBlock = { (user, error) in
            if let user = user {
                // Perform any operations on signed in user here.
                let userId = user.userID ?? ""                 // For client-side use only!
                let socialId = user.authentication.idToken ?? ""// Safe to send to the server
                let fullName = user.profile.name ?? ""
                let fnm = user.profile.givenName ?? ""
                let lnm = user.profile.familyName ?? ""
                let email = user.profile.email ?? ""
                var profileUrl = ""
                if let url = user.profile.imageURL(withDimension: 300){
                    profileUrl = url.absoluteString
                }
                // ...
                print(userId, socialId, fullName, fnm, lnm, email)
//                print("==========================")
//                print("userId: \(userId)")
//                print("==========================")
//                print("idToken: \(socialId)")
//                print("==========================")
//                print("fullName: \(fullName)")
//                print("==========================")
//                print("givenName: \(fnm)")
//                print("==========================")
//                print("familyName: \(lnm)")
//                print("==========================")
//                print("email:\(email)")
//                print("==========================")
                completion(basicInfo(socialId,fnm,lnm,email,profileUrl),nil)
            }else{
                completion(basicInfo("","","","",""),error!.localizedDescription)
            }
        }
    }
    
    func basicDataWithCompletionHandler(fromViewController vc:UIViewController, completion: @escaping googleLoginData){
        self.currentVC = vc
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
        self.googleLoginDataBlock = { (user, error) in
            if (error == nil) {
                completion(user,nil)
            }else{
                completion(nil,error!.localizedDescription)
            }
        }
    }
    
}


extension GoogleSignInManager: GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: Google Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        currentVC?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.googleLoginDataBlock?(user, nil)
            //GIDSignIn.sharedInstance().signOut()
        } else {
            print("\(error.localizedDescription)")
            self.googleLoginDataBlock?(nil, error)
        }
    }
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("GoogleSignIn: User desconnects from app")
    }
    
}


//Usage
/*
fileprivate func googleLogin(){
    GoogleSignInManager.shared.basicInfoWithCompletionHandler(fromViewController: self) { (userInfo, errStr) in
        if let errStr = errStr{
            print(errStr)
        }else{
            print(userInfo.firstName)
        }
    }
    
    
    GoogleSignInManager.shared.basicDataWithCompletionHandler(fromViewController: self) { (user, errStr) in
        if let userInfo = user {
            print(userInfo)
        }else if let errStr = errStr{
            print(errStr)
        }
    }
    
}
*/
