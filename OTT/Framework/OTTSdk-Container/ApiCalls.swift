//
//  ApiCalls.swift
//  DotComAPI
//
//  Created by Muzaffar on 10/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit
import OTTSdk


struct Key {
    static let sectionTitle = "sectionTitle"
    static let sectionValues = "sectionValues"
    static let cellTitle = "sectionTitle"
    static let selectorType = "selectorType"
}

//MARK: - protocol FDFSLoginViewControllerDelegate

protocol ApiCallsDelegate : class {
    func presentAlert(inputs : [String],data : [String]?, onSuccess : @escaping ([String])-> Void)
}

class ApiCalls: NSObject {
    enum SelectorType : String{
        
        //Status
        case initialRequest = "initialRequest"
        case location = "location"
        case token = "token"
        case configs = "configs"
        case refresh = "refresh"
        case countries = "countries"
        case pageContent = "pageContent"
        case guideChannels = "guideChannels"
        case guideChannelPrograms = "guideChannelPrograms"
        case details = "details"
        case sectionContent = "sectionContent"
        case stream = "stream"
        case samplePage = "samplePage"
        case search = "search"
        case suggestions = "suggestions"
        //User
        case signIn = "signIn"
        case signInWithEncryption = "signInWithEncryption"
        case signUp = "signUp"
        case signUpComplete = "signUpComplete"
        case signOut = "signOut"
        case userInfo = "userInfo"
        case updatePreference = "updatePreference"
        case getOtp = "getOtp"
        case userGetOtp = "userGetOtp"
        case resendOtp = "resendOtp"
        case verifyEmail = "verifyEmail"
        case verifyMobile = "verifyMobile"
        case updatePassword = "updatePassword"
        case linkedDeviceList = "linkedDeviceList"
        case delinkDevice = "delinkDevice"
        case userActivePackages = "userActivePackages"
        case transactions = "transactions"
        case sessionPreference = "sessionPreference"
        case continueWatching = "continueWatching"
        case getCurrentDate = "getCurrentDate"
        case poll = "poll"
    }
    
    static let apis = [
        
        // App
        [Key.sectionTitle : "App Startup",
         Key.sectionValues :[
            [Key.cellTitle : "InitialRequest", Key.selectorType : SelectorType.initialRequest],
            [Key.cellTitle : "Location", Key.selectorType : SelectorType.location],
            [Key.cellTitle : "Token", Key.selectorType : SelectorType.token],
            [Key.cellTitle : "Configs", Key.selectorType : SelectorType.configs],
            [Key.cellTitle : "Countries", Key.selectorType : SelectorType.countries],
            [Key.cellTitle : "Refresh", Key.selectorType : SelectorType.refresh]
            ]
        ],
        
        
        
        // User
        [Key.sectionTitle : "User",
         Key.sectionValues :[
            [Key.cellTitle : "Sign In", Key.selectorType : SelectorType.signIn],
            [Key.cellTitle : "Sign In With Encryption", Key.selectorType : SelectorType.signInWithEncryption],
            [Key.cellTitle : "Sign Up", Key.selectorType : SelectorType.signUp],
            [Key.cellTitle : "signUpComplete", Key.selectorType : SelectorType.signUpComplete],
            
            
            [Key.cellTitle : "Sign Out", Key.selectorType : SelectorType.signOut],
            [Key.cellTitle : "User Info", Key.selectorType : SelectorType.userInfo],
            [Key.cellTitle : "Update Preference", Key.selectorType : SelectorType.updatePreference],
            [Key.cellTitle : "Get Otp", Key.selectorType : SelectorType.getOtp],
            [Key.cellTitle : "User Get Otp", Key.selectorType : SelectorType.userGetOtp],
            [Key.cellTitle : "Resend Otp", Key.selectorType : SelectorType.resendOtp],
            [Key.cellTitle : "Verify Email", Key.selectorType : SelectorType.verifyEmail],
            [Key.cellTitle : "Verify Mobile", Key.selectorType : SelectorType.verifyMobile],
            [Key.cellTitle : "Update Password", Key.selectorType : SelectorType.updatePassword],
            [Key.cellTitle : "Linked DeviceList", Key.selectorType : SelectorType.linkedDeviceList],
            [Key.cellTitle : "Delink Device", Key.selectorType : SelectorType.delinkDevice],
            [Key.cellTitle : "Active Packages", Key.selectorType : SelectorType.userActivePackages],
            [Key.cellTitle : "Transactions", Key.selectorType : SelectorType.transactions],
            [Key.cellTitle : "Session Preference", Key.selectorType : SelectorType.sessionPreference]
            ]
        ],
    
        // Content
        [Key.sectionTitle : "Content",
         Key.sectionValues :[
            [Key.cellTitle : "Page Content", Key.selectorType : SelectorType.pageContent],
            [Key.cellTitle : "Guide Channels", Key.selectorType : SelectorType.guideChannels],
            [Key.cellTitle : "Guide Channel Programs", Key.selectorType : SelectorType.guideChannelPrograms],
            [Key.cellTitle : "Section Content", Key.selectorType : SelectorType.sectionContent],
            [Key.cellTitle : "Details", Key.selectorType : SelectorType.details],
            [Key.cellTitle : "Stream", Key.selectorType : SelectorType.stream],
            [Key.cellTitle : "Search", Key.selectorType : SelectorType.search],
            [Key.cellTitle : "Suggestions", Key.selectorType : SelectorType.suggestions],
            [Key.cellTitle : "continueWatching", Key.selectorType : SelectorType.continueWatching],
            [Key.cellTitle : "getCurrentDate", Key.selectorType : SelectorType.getCurrentDate],
            [Key.cellTitle : "Stream Poll", Key.selectorType : SelectorType.poll]
            ]
        ],
        
        // Samples
        [Key.sectionTitle : "Samples",
         Key.sectionValues :[
            [Key.cellTitle : "samplePage", Key.selectorType : SelectorType.samplePage]
            ]
        ]
        
        ] as [[String : Any]]
    
    
    static var instance: ApiCalls{
        struct Singleton{
            static let obj = ApiCalls()
        }
        return Singleton.obj
    }
    
    var delegate : ApiCallsDelegate?
    
    func call(info : [String : Any]) {
        guard let selectorType = info[Key.selectorType] as? SelectorType else {
            return
        }
        
        switch selectorType {
            
            //User
            
        case .signIn:
            self.signIn()
            break
        
        case .signInWithEncryption:
            self.signInWithEncryption()
            break
            
        case .signUp:
            self.signUp()
            break
        
        case .signUpComplete:
            self.signUpComplete()
            break
            
        case .signOut:
            self.signOut()
            break
            
        case .userInfo:
            self.userInfo()
            break
            
        case .updatePreference:
            self.updatePreference()
            break
            
        case .getOtp:
            self.getOtp()
            break
            
        case .userGetOtp:
            self.userGetOtp()
            break
            
        case .verifyEmail:
            self.verifyEmail()
            break
            
        case .verifyMobile:
            self.verifyMobile()
            break
            
        case .updatePassword:
            self.updatePassword()
            break
            
        case .linkedDeviceList:
            self.linkedDeviceList()
            break
            
        case .delinkDevice:
            self.delinkDevice()
            break
            
        case .userActivePackages:
            self.userActivePackages()
            break
            
        case .resendOtp:
            self.resendOtp()
            break
            
        case .transactions:
            self.transactions()
            break
            
        case .sessionPreference:
            self.sessionPreference()
            break
            
        //Initial
            
        case .initialRequest:
            self.initialRequest()
            break
            
        case .location:
            self.location()
            break
            
        case .token:
            self.token()
            break
            
        case .configs:
            self.configs()
            break
            
        case .countries:
            self.countries()
            break
            
            
        //Content
            
        case .pageContent:
            self.pageContent()
            break

        case .guideChannels:
            self.getGuideChannels()
            break
            
        case .guideChannelPrograms:
            self.getChannelPrograms()
            break

        case .details:
            self.details()
            break
            
        case .sectionContent:
            self.sectionContent()
            break
            
        case .stream:
            self.stream()
            break
            
        case .search:
            self.search()
            break
            
        case .suggestions:
            self.suggestions()
            break
            
        case .continueWatching:
            self.continueWatching()
            break
        case .getCurrentDate:
            self.getCurrentDate()
            break

        case .refresh:
            self.refresh()
            break
            
        case .poll:
            self.streamPoll()
            break
            
        // Samples
        case .samplePage:
            self.samplePage()
            break
            
//        default:
//            return
        }
    }

}

//MARK: - Initial
extension ApiCalls{
    func initialRequest() {
        OTTSdk.appManager.initiateSdk { (isSupported,error) in
            print(isSupported)
            OTTSdk.appManager.getHeaderEnrichmentNumber(onSuccess: { (response) in
                print(response)
            }, onFailure: { (error) in
                
            })
        }
    }
    
    func location() {
        OTTSdk.appManager.updateLocation(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    func configs() {
        OTTSdk.appManager.configuration(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print("configuration error.message")
        }
    }
    
    func token() {
        OTTSdk.appManager.getToken(onSuccess: {
            print("getToken")
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func countries() {
        OTTSdk.appManager.getCountries(onSuccess: { (response) in
            print(response.count)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func refresh() {
        OTTSdk.refresh { (response) in
            print(response)
        }
    }
    
    func streamPoll() {
        OTTSdk.mediaCatalogManager.poll(pollKey: "c3afc442-9bb0-47ad-825f-6d0f15c321d9", event_type: 2, onSuccess: { (successMessage) in
            print("#Player : poll success \(successMessage)")
        }) { (error) in
            print("#Player : poll error \(error.message)")
        }
    }
}


//MARK: - User
extension ApiCalls{
    func signIn() {
        delegate?.presentAlert(inputs: ["loginId","password"], data: ["apple3@yupptv.com","123456"], onSuccess: { (userInputs) in
            OTTSdk.userManager.signInWithPassword(loginId: userInputs[0], password: userInputs[1], appVersion: "1.0", isHeaderEnrichment: false, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    
    func signInWithEncryption() {
        //"testbase1@yupptv.com" "121212"
        delegate?.presentAlert(inputs: ["loginId","password"], data: ["muzafara@yupptv.com","111111"], onSuccess: { (userInputs) in
            OTTSdk.userManager.signInWithEncryption(loginId: userInputs[0], password: userInputs[1], onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    
    
    func signUp() {
        
        OTTSdk.userManager.signup(email: "r1@r.com", firstName: "Test", lastName: "To", mobile: "919030022011", password: "123123", dob: "946684800", gender: "M", appVersion: "1.0", referralType: nil, referralId: nil, isHeaderEnrichment: false , onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    func signUpComplete() {
        delegate?.presentAlert(inputs: ["referenceId","otp"], data: ["1","1"], onSuccess: { (userInputs) in OTTSdk.userManager.signupWithOTPVerification(referenceId:Int(userInputs[0])!,otp:Int(userInputs[1])!,onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
            }
        })
    }
    func signOut() {
        OTTSdk.userManager.signOut(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func userInfo() {
        
        print(OTTSdk.preferenceManager.selectedLanguages)
        
        OTTSdk.userManager.userInfo(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func updatePreference() {
        OTTSdk.userManager.updatePreference(selectedLanguageCodes: "TEL,TAM,HIN", sendEmailNotification: false, onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    

    func getOtp() {
        delegate?.presentAlert(inputs: ["mobile","email","verifyMobile 0,verifyEmail 1,signin 2,updatePassword 3"], data: ["919866470067","muzaffar.mtech@gmail.com","0"], onSuccess: { (userInputs) in
            
            /*
            case verifyMobile = "verify_mobile"
            case verifyEmail = "verify_email"
            case signin = "signin"
            case updatePassword = "update_password"
            
            */
            
            var context = UserManager.OtpContext.verifyMobile
            if userInputs[2] == "0"{
                context = UserManager.OtpContext.verifyMobile
            }
            if userInputs[2] == "1"{
                context = UserManager.OtpContext.verifyEmail
            }
            if userInputs[2] == "2"{
                context = UserManager.OtpContext.signin
            }
            if userInputs[2] == "3"{
                context = UserManager.OtpContext.updatePassword
            }
            
            let mobile = (userInputs[0].count > 0) ? userInputs[0] : nil
            let email = (userInputs[1].count > 0) ? userInputs[1] : nil
            
            OTTSdk.userManager.getOTP(mobile: mobile, email: email, context: context, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })

    }
    
    func userGetOtp() {
        OTTSdk.userManager.userGetOtp(targetType: .mobile, context: .verifyMobile, onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func resendOtp() {
        delegate?.presentAlert(inputs: ["referenceId"], data: [""], onSuccess: { (userInputs) in
            OTTSdk.userManager.resendOTP(referenceId: Int(userInputs[0])!, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    
    func verifyEmail() {
        delegate?.presentAlert(inputs: ["email","otp"], data: ["muzaffar.mtech@gmail.com",""], onSuccess: { (userInputs) in
            OTTSdk.userManager.verifyEmail(email: userInputs[0], otp: Int(userInputs[1])!, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    
    func verifyMobile() {
        delegate?.presentAlert(inputs: ["mobile","otp"], data: ["919866470067",""], onSuccess: { (userInputs) in
            OTTSdk.userManager.verifyMobile(mobile: userInputs[0], otp: Int(userInputs[1])!, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })

    }
    
    func updatePassword() {
        
        delegate?.presentAlert(inputs: ["mobile","email","password","otp"], data: ["919866470067","muzaffar.mtech@gmail.com","123123",""], onSuccess: { (userInputs) in
            
            
            let mobile = (userInputs[0].count > 0) ? userInputs[0] : nil
            let email = (userInputs[1].count > 0) ? userInputs[1] : nil
            
            
            OTTSdk.userManager.updatePassword(email: email, mobile: mobile, password: userInputs[2], otp: Int(userInputs[3])!, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })

    }
    
    func linkedDeviceList() {
        OTTSdk.userManager.linkedDeviceList(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    func delinkDevice() {
        OTTSdk.userManager.delinkDevice(boxId: "ABD5D30D-0860-487A-9EC2-7218E034929C", deviceType: 7, onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func userActivePackages() {
        OTTSdk.userManager.activePackages(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func transactions() {
        OTTSdk.userManager.transactionHistory(page: 0, count: nil, onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    
    func sessionPreference() {
        delegate?.presentAlert(inputs: ["displayLangCode"], data: ["SWA"], onSuccess: { (userInputs) in
            OTTSdk.userManager.sessionPreference(displayLangCode: userInputs[0], onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
}

//MARK: - Content
extension ApiCalls{
    func pageContent() {
        OTTSdk.mediaCatalogManager.pageContent(path: "home", onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }

    func getGuideChannels() {
        OTTSdk.mediaCatalogManager.getTVGuideChannels(filter: nil, skip_tabs: 0, time_zone: nil, onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }

    func getChannelPrograms() {
//        OTTSdk.mediaCatalogManager.getProgramForChannels(channel_ids: "21,22,24,27,20,26,23,41,25", start_time: nil, end_time: nil, time_zone: nil, isUserData: true, onSuccess: { (response) in
//            print(response)
//        }) { (error) in
//            print(error.message)
//        }
    }

    func details() {
        OTTSdk.mediaCatalogManager.pageContent(path: "series/mr-seed", onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    func sectionContent() {
        OTTSdk.mediaCatalogManager.sectionContent(path: "music", code: "trending_music", offset: nil, count: nil, filter: "subgenre:Gospel,Vernacular,Bongo", onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }

    func stream() {
        OTTSdk.mediaCatalogManager.stream(path: "movie/kick/play", network_type: "", onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }

    func search() {
        delegate?.presentAlert(inputs: ["query"], data: ["tv"], onSuccess: { (userInputs) in
            OTTSdk.mediaCatalogManager.search(query: userInputs[0], genre: nil, language: nil, dataType: nil, page: 0, pageSize: 10, onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    
    func suggestions() {
        delegate?.presentAlert(inputs: ["query"], data: ["lo"], onSuccess: { (userInputs) in
            OTTSdk.mediaCatalogManager.suggestions(query: userInputs[0], onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        })
    }
    func continueWatching() {
        let dic = ["items" : [["dataType":"tvshow_episode","id":1203]]]
        OTTSdk.mediaCatalogManager.getCardsForContinueWatching(payLoad: dic, onSuccess: { (response) in
            print(response)
        })  { (error) in
            print(error.message)
        }
    }
    
    func getCurrentDate() {
        
        for var _ in 0..<10 {
            OTTSdk.appManager.getCurrentDate(onSuccess: { (response) in
                print(response)
            }) { (error) in
                print(error.message)
            }
        }
    }
}

//MARK: - Sample
extension ApiCalls{
    func samplePage(){
        self.page(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.message)
        }
    }
    
    public func page(onSuccess : @escaping (PageContentResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        if let path = Bundle.main.path(forResource: "player", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    let response = PageContentResponse(jsonResult["response"] as! [String : Any])
                    
                    onSuccess(response)
                } catch {
                    onFailure(APIError.defaultError())
                }
            } catch let error {
                print(error.localizedDescription)
                onFailure(APIError.defaultError())
            }
        } else {
            print("Invalid filename/path.")
            onFailure(APIError.defaultError())
        }
    }
}
