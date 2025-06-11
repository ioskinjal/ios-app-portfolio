//
//  SceneDelegate.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import FirebaseDatabase
import SwiftyJSON

var isLandingPageLoaded = false

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var currentAppVersion = ""
    var ref: DatabaseReference!
   
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
       // let storyboard = UIStoryboard.init(name: "Loginregistration", bundle: nil)
       
//        if let userActivity = connectionOptions.userActivities.first {
//            self.scene(scene, continue: userActivity)
//        }
        guard let _ = (scene as? UIWindowScene) else { return }
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        
//        if(UserDefaults.standard.string(forKey: "storecode") != nil && (UserDefaults.standard.string(forKey: "userEmail") ?? "NA") != "NA"){
//        //check installation date and current date difference < 40
//        let urlToDocumentsFolder: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
//        let installDate = try? FileManager.default.attributesOfItem(atPath: (urlToDocumentsFolder?.path)!)[.creationDate] as? NSDate
//         //print("Install Date of app is \(installDate)")
//        //var dateDifference = (NSDate() as? NSDate)!.timeIntervalSinceReferenceDate - (installDate??.timeIntervalSinceReferenceDate)!
//            var dateDifference = Calendar.current.dateComponents([.day], from: installDate as! Date, to: NSDate() as Date).day!
//            dateDifference = (dateDifference - CommonUsed.globalUsed.threashold)
//        //print("Date Difference:  \(dateDifference)")
//            if((dateDifference % CommonUsed.globalUsed.sessionTime) == 0){
//            self.RecreateSession(emil: UserDefaults.standard.string(forKey: "userEmail") ?? "NA")
//       }
//        }
        
        if( UserDefaults.standard.value(forKey: string.userLanguage) == nil){
            let languageStr  = Locale.current.languageCode
            if languageStr != UserDefaults.standard.setValue(string.en, forKey: string.language)as? String{
                isLanguageCodeChanged = true
            }
            if languageStr == string.en {
                UserDefaults.standard.setValue(string.English, forKey: string.userLanguage)
                UserDefaults.standard.setValue(string.en, forKey: string.language)
              
            }
            else
            {
                UserDefaults.standard.setValue(string.Arabic, forKey: string.userLanguage)
                UserDefaults.standard.setValue(string.ar, forKey: string.language)
            }
        }
    }
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
    }
     func callApi(){
      let strCode = "\(UserDefaults.standard.value(forKey: string.language) ?? string.en)"
        let url = CommonUsed.globalUsed.configEndPoint + strCode + CommonUsed.globalUsed.onBoarding
       ApiManager.apiGet(url: url, params: [:]) { (response, error) in
                  
                  if let error = error{
                      print(error)
                      return
                  }
                  if response != nil{
                   var dict = [String:Any]()
                      dict[string.data] = response?.dictionaryObject
                   let user = UserData.shared.getData()
                  // if  user == nil{
                   _ =  UserData.shared.setData(dic: dict)
                  //}
                      if UserDefaults.standard.value(forKey: string.category) == nil && UserDefaults.standard.value(forKey: string.storecode) != nil || UserDefaults.standard.value(forKey: string.storecode) == nil{
//                          let viewController = SelectCategoryViewController.storyboardInstance!
//                          let nav = UINavigationController()
//                                                     nav.setNavigationBarHidden(true, animated: true)
//                                                     nav.pushViewController(viewController, animated: true)
//                                                     self.window?.rootViewController = nav
//                                                     self.window?.makeKeyAndVisible()
//                      }else{
                   let viewController = SkipIntroViewController.storyboardInstance!
                         
                          let nav = UINavigationController()
                          nav.setNavigationBarHidden(true, animated: true)
                          nav.pushViewController(viewController, animated: true)
                          self.window?.rootViewController = nav
                          self.window?.makeKeyAndVisible()
                          
                  }
          }
       }
   }

    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        print("userActivityType =\(userActivityType)")
    }
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
           // ******** Deep linking url should be as below format
           
   //        levelshoes://plist?cid=634&g=39&title=Winter-is-here
   //        levelshoes://pid?sku=240861-685034
          
           guard URLContexts.first != nil else { return }
           
           var urlString = ""
           var hostName = ""
           for context in URLContexts {
               print("url: \(context.url.absoluteURL)")
            urlString = context.url.absoluteURL.absoluteString.removingPercentEncoding ?? "levelshoes://"
               hostName = context.url.host ?? ""
           }
           
           var infoDict = [String: String]()
           let nc = NotificationCenter.default
           
           if hostName == "plist" {
               var productString = ""
               if urlString.contains("?") {
                   var categoryId = ""
                   var gender = ""
                   var title = ""
                   productString = urlString.components(separatedBy: "plist?")[1]
                   if productString.contains("&") {
                       let details = productString.components(separatedBy: "&")
                       for param in details {
                           if param.contains("=") {
                               let firstVal = param.components(separatedBy: "=")[0]
                               if firstVal == "cid" {
                                   categoryId = param.components(separatedBy: "=")[1]
                               }
                               if firstVal == "g" {
                                   gender = param.components(separatedBy: "=")[1]
                               }
                               if firstVal == "title" {
                                   title = param.components(separatedBy: "=")[1]
                               }
                           }
                       }
                   }
                   else if productString.contains("="){
                   
                     let firstVal = productString.components(separatedBy: "=")[0]
                     if firstVal == "cid" {
                         categoryId = productString.components(separatedBy: "=")[1]
                     }
                     if firstVal == "g" {
                         gender = productString.components(separatedBy: "=")[1]
                     }
                     if firstVal == "title" {
                         title = productString.components(separatedBy: "=")[1]
                     }
                   }
                   if categoryId != "" {
                     DispatchQueue.main.async {
                         let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                         
                         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                         nextViewController.selectedIndex = 0
                         let nav1 = UINavigationController()
                         nav1.setNavigationBarHidden(true, animated: false)
                         nav1.pushViewController(nextViewController, animated: false)
                         self.window?.rootViewController = nav1
                         self.window?.makeKeyAndVisible()
                         
                         infoDict["categoryId"] = categoryId
                         if gender == "" {
                             gender = "39"
                         }
                         infoDict["gender"] = gender
                         infoDict["title"] = title
                         
                         let delayTime = DispatchTime.now() + 1.0
                         DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                             nc.post(name: Notification.Name("showProductLink"), object: nil, userInfo: infoDict)
                         })
                     }
                   }
               }
           }
           if hostName == "pid" {
               var productDetailString = ""
               if urlString.contains("?") {
                   productDetailString = urlString.components(separatedBy: "pid?")[1]
                   if productDetailString.contains("=") {
                       let firstValue = productDetailString.components(separatedBy: "=")[0]
                       if firstValue == "sku" {
                         DispatchQueue.main.async {
                             let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                             
                             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                             nextViewController.selectedIndex = 0
                             let nav1 = UINavigationController()
                             nav1.setNavigationBarHidden(true, animated: false)
                             nav1.pushViewController(nextViewController, animated: false)
                             self.window?.rootViewController = nav1
                             self.window?.makeKeyAndVisible()
                             
                             let sku = productDetailString.components(separatedBy: "=")[1]
                             infoDict["sku"] = sku
                             
                             let delayTime = DispatchTime.now() + 1.0
                             DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                                 nc.post(name: Notification.Name("ProductDetail"), object: nil, userInfo: infoDict)
                             })
                         }
                       }
                   }
               }
           }
       }
      func klevuProductSearchApi(skutext: String){
          let delimiter = ";"
          let tempSkuArray = skutext.components(separatedBy: delimiter)
          let skuId = tempSkuArray[0]
          var arrMust = [[String:Any]]()
          
          arrMust.append(["match": ["sku":skuId]])
          let dictMust = ["must":arrMust]
          let dictBool = ["bool":dictMust]
          
          var dictSort = [String:Any]()
          dictSort = ["updated_at":"desc"]
          let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id"],
                       "from":0,
                       "size": 5,
                       "sort" : dictSort,
                       "query": dictBool
              ] as [String : Any]
          
          let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
          let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
         // MBProgressHUD.showAdded(to: self.view, animated: true)
          ApiManager.apiPost(url: url, params: param) { (response, error) in
             // MBProgressHUD.hide(for: self.view, animated: true)
              if let error = error {
                  if error.localizedDescription.contains(s: "offline") {
                      let nextVC = NoInternetVC.storyboardInstance!
                      nextVC.modalPresentationStyle = .fullScreen
                  }
                  
                  return
              }
              var data: NewInData?
              if response != nil{
                  let dict = ["data": response?.dictionaryObject]
                  data = NewInData(dictionary: ResponseKey.fatchData(res: dict as dictionary, valueOf: .data).dic)
                  DispatchQueue.main.async(execute: {
                      
                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      
                      
                      let nextVC = ProductDetailVC.storyboardInstance!
                      nextVC.isCommingFromWishList = true
                      nextVC.detailData = data
                      let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                      
                      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                      nextViewController.selectedIndex = 0
                      let nav1 = UINavigationController()
                      nav1.setNavigationBarHidden(true, animated: false)
                      nav1.pushViewController(nextViewController, animated: false)
                      self.window?.rootViewController = nav1
                      self.window?.makeKeyAndVisible()
                  })
              }
              
          }
      }
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        checkChangePasswordInWebsite()
        checkVersion()
    }
    func checkVersion() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        currentAppVersion = appVersion ?? "1.0.0"
        print("CURRENT VERSION",currentAppVersion)
        if(UserDefaults.standard.string(forKey: "storecode") != nil && (UserDefaults.standard.string(forKey: "userEmail") ?? "NA") != "NA"){
        //check installation date and current date difference < 40
        let urlToDocumentsFolder: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let installDate = try? FileManager.default.attributesOfItem(atPath: (urlToDocumentsFolder?.path)!)[.creationDate] as? NSDate
         //print("Install Date of app is \(installDate)")
        //var dateDifference = (NSDate() as? NSDate)!.timeIntervalSinceReferenceDate - (installDate??.timeIntervalSinceReferenceDate)!
            var dateDifference = Calendar.current.dateComponents([.day], from: installDate as! Date, to: NSDate() as Date).day!
            //dateDifference = (dateDifference - CommonUsed.globalUsed.threashold)
        //print("Date Difference:  \(dateDifference)")
            if((dateDifference % (CommonUsed.globalUsed.sessionTime - CommonUsed.globalUsed.threashold)) == 0){
            self.RecreateSession(emil: UserDefaults.standard.string(forKey: "userEmail") ?? "NA")
       }
        }
        ref = Database.database().reference()
        ref.child("forceUpdate").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let storeVersion = value?["appstoreVersion"] as? String ?? ""
            let maintenance = value?["maintenance"] as? Bool ?? false
            print("appVersion =\(storeVersion)")
            print("maintenance = \(maintenance)")
            if storeVersion.compare(self.currentAppVersion, options: .numeric) == .orderedDescending {
                print("store version is newer")
                let storyboard = UIStoryboard(name: "appAlert", bundle: Bundle.main)
                let servocesVC: appAlertVC! = storyboard.instantiateViewController(withIdentifier: "appAlertVC") as? appAlertVC
                UIApplication.shared.keyWindow?.rootViewController = servocesVC
            }
            else if maintenance {
                let storyboard = UIStoryboard(name: "appAlert", bundle: Bundle.main)
                let servocesVC: MaintenanceAlertVC! = storyboard.instantiateViewController(withIdentifier: "maintenance") as? MaintenanceAlertVC
                UIApplication.shared.keyWindow?.rootViewController = servocesVC
            }
            else{
                if UserDefaults.standard.bool(forKey: "isLoadingFirstTime") {
                    UserDefaults.standard.set(false, forKey: "isLoadingFirstTime")
                    
                    let userToken = UserDefaults.standard.value(forKey: "userToken") as? String
                    let storeCode = UserDefaults.standard.value(forKey: "storecode") as? String
                    if userToken == nil && storeCode == nil || UserDefaults.standard.value(forKey: "category") == nil {
                        self.callApi()
                    }
                    else{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                        self.window?.rootViewController = nextViewController
                        // nextViewController.tabBar.isHidden = true
                        
                        self.window?.makeKeyAndVisible()
                        
                        DispatchQueue.main.async {
                            self.changeTabBarForArebicSelection()
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func changeTabBarForArebicSelection() {
        if UserDefaults.standard.value(forKey: string.language
        )as? String == string.en {
            
        }else{
            if let wTB = ( self.window?.rootViewController as? UITabBarController ) {
                if let wVCs = wTB.viewControllers {
                    wTB.viewControllers = [ wVCs[ 4 ], wVCs[ 3 ], wVCs[ 2 ], wVCs[ 1 ], wVCs[ 0 ] ]
                }
            }
        }
    }
    func RecreateSession(emil:String ){
        
        let emailEncription = encryptIt(salt: validationMessage.salt, value: emil)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        let param = [
            validationMessage.keyEmail: emailEncription,
            validationMessage.website_id: getWebsiteId(),
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: 0,
            validationMessage.providerType: "web",
        ] as [String : Any]
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kReadOnly
        
        ApiManager.apiGet(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
            if let error = error {
                //MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if response != nil {
                let test = response?.description
                
                let responseDic = convertToDictionary(text: test ?? "")
                if responseDic!["token"] != nil {
                    
                    UserDefaults.standard.set(responseDic!["token"], forKey: "userToken")
                    UserDefaults.standard.set(true, forKey: string.isFBuserLogin)
                    M2_isUserLogin = true
                    userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                    //self.conversionLoginUserToGuestUser()
                    //Added by Nitikesh . Dt: 02-08-2020
                    ApiManager.getCustomerInformation(success: { (response) in
                        do {
                            guard let data = response else {
                                return
                            }
                            if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                                let customerId = address.id
                                let storeId = address.storeId
                                //self.checkMobileNumber(userData: address)
                                UserDefaults.standard.set(customerId, forKey:"customerId")
                                UserDefaults.standard.set(storeId, forKey:"storeId")
                                UserDefaults.standard.set(address.email, forKey: "userEmail")
                                addMyWishListInLocalDb()
                                
                                
                                
                            } else {}
                        } catch {}
                    }) {
                    }
                }
            }
        }
    }
    func checkChangePasswordInWebsite() {
        guard let emailID = UserDefaults.standard.value(forKey: "userEmail") as? String else{
            return
        }
        let urlString = CommonUsed.globalUsed.staggingUrl + CommonUsed.globalUsed.kPasswordchangecheck
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let email: String
            let website_id: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(email: emailID, website_id: "1")
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            if let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                print("Parsed JSON: \(jsonStr)")
                var responseStr = jsonStr as String
                if responseStr.hasPrefix("[") {
                    isUserChangedPasswordInWebsite = false
                    UserDefaults.standard.set(responseStr, forKey:"updatedAt")
                }
                else{
                    responseStr = responseStr.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                    
                    let updatedAt = UserDefaults.standard.value(forKey: "updatedAt") as? String ?? ""
                    if !responseStr.isEqual(updatedAt) && updatedAt.length > 0 {
                        print("not equal")
                        isUserChangedPasswordInWebsite = true
                        UserDefaults.standard.set(responseStr, forKey: "updatedAt")
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("UserLoggedOut"), object: nil)
                    }
                    else{
                        print("equal")
                        UserDefaults.standard.set(responseStr, forKey: "updatedAt")
                        isUserChangedPasswordInWebsite = false
                    }
                }
            }
            else{
                isUserChangedPasswordInWebsite = false
            }
            
        }.resume()
    }
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if(isLandingPageLoaded){
            ApiManager.versionCheckLanding()
        }
        if(UserDefaults.standard.bool(forKey: "versionChanged")){
                  UserDefaults.standard.set(false,forKey: "versionChanged")
                  ApiManager.sliderCache.removeAll()
                  exit(0)
            }
    }
    
}

