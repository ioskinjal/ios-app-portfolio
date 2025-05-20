//
//  UpdateEmailVC.swift
//  Happenings
//
//  Created by admin on 3/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class UpdateEmailVC: UIViewController {
    
    static var storyboardInstance:UpdateEmailVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: UpdateEmailVC.identifier) as? UpdateEmailVC
    }
    
    var dictParam = [String:Any]()
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFacebook()
    }
    
    @IBAction func onClickUpdate(_ sender: UIButton) {
        if txtEmail.text == ""{
            self.alert(title: "", message: "please enter email address")
        }else if !(txtEmail.text?.isValidEmailId)!{
            self.alert(title: "", message: "please enter valid email id")
        }else{
            loginButtonClicked()
        }
    }
    
    func socilaLogin(fNm:String, lNm:String, loginType:String, socialId:String, email:String,  profile_pic:String) {
        dictParam["signup_email_address"] = txtEmail.text!
        
        Modal.shared.socialSignUp(vc: self, param: dictParam) { (dic) in
            print("Social Login respoence: \(dic)")
            //isSocialLogin = true
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            _ = UserData.shared.setUser(dic: data)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
            })
        }
    }
}


extension UpdateEmailVC {
    
    
    func configureFacebook(){
        //btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        //btnFacebook.delegate = self
       // btnFB.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        LoginManager().logOut()
        //let loginManager = LoginManager().
        //loginManager.logOut()
    }
    
    @objc func loginButtonClicked() {
            let loginmanger = LoginManager()
            loginmanger.logOut()
            if let accessToken = AccessToken.current {
                // User is logged in, use 'accessToken' here.
                print("accessToken:\(accessToken)")
                self.getFBUserData()
            }
            else{
                let loginManager = LoginManager()
                let readPermissions: [ReadPermission] = [.publicProfile, .email, /*.userBirthday*/]
                loginManager.logIn(readPermissions: readPermissions, viewController: self) { (loginResult) in
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                    case .cancelled:
                        print("Users cancelled login.")
                    case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
                        print("Logged in!")
                        print("grantedPermissions:\(grantedPermissions.description)")
                        print("declinedPermissions:\(declinedPermissions.description)")
                        print("accessToken:\(accessToken.authenticationToken)")
                        //if grantedPermissions.contains(Permission(name: "email")) == true { .. }
                        self.getFBUserData()
                        //                    AccessToken.refreshCurrentToken({ (accessToken, error) in
                        //                        self.getFBUserData()
                        //                    })
                    }
                }
            }
    }
    
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            let params = ["fields" : "id,email,first_name,last_name,gender"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            graphRequest.start {
                (urlResponse, requestResult) in
                switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        let fNm = responseDictionary["first_name"] as! String
                        let lNm = responseDictionary["last_name"] as! String
                        let email = responseDictionary["email"] as! String
                        //  let gender = responseDictionary["gender"] as! String
                        let fbId = responseDictionary["id"] as! String
                        let facebookProfileUrl:String?
                        facebookProfileUrl = "http://graph.facebook.com/\(fbId)/picture?type=large"
                        print("=======fbId===================")
                        print(fbId)
                        print("=============fNm=============")
                        print(fNm)
                        print("==========lNm================")
                        print(lNm)
                        print("===========email===============")
                        print(email)
                        print("===========gender===============")
                        //   print(gender)
                        print("===========================")
                        
                        self.socilaLogin(fNm: fNm, lNm: lNm, loginType: "facebook", socialId: fbId, email: email, profile_pic: facebookProfileUrl!)
                    }
                }
            }
        }
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


