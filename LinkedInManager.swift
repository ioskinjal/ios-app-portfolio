//
//  LinkedInManager.swift
//

import UIKit
import LinkedinSwift

fileprivate struct LinkedIN {
    //Changable
    static let clientId = LinkedIn.clientId
    static let clientSecret = LinkedIn.clientSecret
    static let redirectURL = LinkedIn.redirectURL
    
    //Don't change below variable
    static let state = "DLKDJF45DIWOERCM" //May be it's unused
    static let permission = ["r_emailaddress", "r_liteprofile"]
    static let requestURL_MemberProfilePicture = "https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))"
    static let requestURL_MemberEmailAddress = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
    
    //static let requestURL_MemberProfiles = "https://api.linkedin.com/v2/me"
    //static let url = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))"
    
}

/**
 
    LinkedInManager class user for linkedIn login
 
    - **Step 1: Create App on LinkedIn developer account**
 
    [Create App click here](https://developer.linkedin.com/docs/ref/v2/media-migration)
 
    [LinkedIn integration reference](https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin)
 
 
 
    - **Step 2: Setup App on LinkedIn Developer Account**
 
        - Your App -> Setting Tab -> Additional settings -> Domains:
 
        - Your App -> Auth Tab -> OAuth 2.0 Setting -> RedirectURLs - for example -> "https://www.google.com/"
 
 

    - **Step 3 : Add below code into Info.plist file**
 
    This step is option if you don't want to open LinkedIn app then this step is not required.
 
 
     <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>linkedin</string>
         <string>linkedin-sdk2</string>
     </array>
 
 
 
    - **Step 4: Replace value of this variable as per app create on linkedIn developer portal**

          fileprivate struct LinkedIn {
              static let clientId = "<REPLACE_ME>"
              static let clientSecret = "<REPLACE_ME>"
              static let redirectURL = "<REPLACE_ME>"
          }
 
    - **Step 5: Usage**
 
 
          @IBAction func onClickLinkedLogin(_ sender: Any) {
               LinkedInManager.shared.loginWithLinked { (id, firstName, lastName, email, profileUrl) in
                  print(firstName, lastName, email, profileUrl)
               }
          }
 
 */

class LinkedInManager: NSObject {
    static let shared = LinkedInManager()

    //create LinkedInSwiftHelper request
    private let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: LinkedIN.clientId, clientSecret: LinkedIN.clientSecret, state: LinkedIN.state, permissions: LinkedIN.permission, redirectUrl: LinkedIN.redirectURL))
    
    //success block
    typealias successBlock = (_ id: String, _ firstName:String, _ lastName:String, _ email:String, _ proFileURL:String) -> ()
    
    //login function which is return success block
    func loginWithLinked(completion: @escaping successBlock) {

        //clear liinkedin cookies from browser
        clearCookieof(name: "linkedin")
        
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) in

            var id = ""
            var firstName = ""
            var lastName = ""
            var email = ""
            var profileURL = ""
            self.linkedinHelper.requestURL(LinkedIN.requestURL_MemberProfilePicture, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                print("Request success with response: \(response)")
                if response.statusCode == 200{
                    guard let obj = response.jsonObject else {return}
                    id = obj["id"] as? String ?? ""
                    firstName = obj["localizedFirstName"] as? String ?? ""
                    lastName = obj["localizedLastName"] as? String ?? ""
                    
                    if let profilePicture = obj["profilePicture"] as? [String:Any],
                    let displayImage = profilePicture["displayImage~"] as? [String:Any],
                    let elements = displayImage["elements"] as? [[String:Any]],
                    let elementLast = elements.last,
                    let identifiers = (elementLast["identifiers"] as? [[String:Any]])?.first,
                    let identifier = identifiers["identifier"] as? String{
                        profileURL = identifier
                    }
                    
                    self.fatcheEmail(email: { (emailId) in
                        email = emailId
                        completion(id, firstName, lastName, email, profileURL)
                        self.linkedinHelper.logout()
                    })
                }
                
            }) { [unowned self] (error) -> Void in
                self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
            }
            }, error: { [unowned self] (error) in
                self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
            }, cancel: { [unowned self] in
                self.writeConsoleLine("User Cancelled!")
        })
    }

    
    //Get email id api call
    private func fatcheEmail(email: @escaping (String) -> Void) {
        self.linkedinHelper.requestURL(LinkedIN.requestURL_MemberEmailAddress, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            if response.statusCode == 200{
                guard let obj = response.jsonObject else {return}
                if let obj1 = (obj["elements"] as? [[String:Any]])?.first{
                    if let handle = (obj1["handle~"] as? [String:Any]), let emailId = handle["emailAddress"] as? String{
                        email(emailId)
                    }
                }
            }
        })
    }
    
    private func writeConsoleLine(_ log: String, file: String = #file, function: String = #function, line: Int = #line ) {
        DispatchQueue.main.async { () -> Void in
            #if DEVELOPMENT
            print("\(log) called from \(function) \(file):\(line)")
            #endif
        }
    }
    
    private func clearCookieof(name:String = "linkedin"){
        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                print("cookie.domain:\(cookie.domain)")
                if cookie.domain.contains(name) {
                    cookieStorage.deleteCookie(cookie)
                }
            }
        }
    }
    
}


