//
//  RegistartionViewController.swift
//  LevelShoes
//
//  Created by apple on 4/24/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import SwiftyJSON
import STPopup

class RegistartionViewController: UIViewController{
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var firstnameImage: UIImageView!
    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var fbBtn: UIButton!
    //    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTf: UITextField!
    @IBOutlet weak var lastNameTf: UITextField!
    @IBOutlet weak var registerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //  @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var mobileTf: UITextField!
    // @IBOutlet weak var passWordTf: UITextField!
    @IBOutlet weak var confirmPassTf: UITextField!
    @IBOutlet weak var viewForShadow: UIView!
    
    //    @IBOutlet weak var fbBtn: UIButton! {
    //        didSet {
    //            fbBtn.setBackgroundColor(color: UIColor(hexString: "264786"), forState: .highlighted)
    //            fbBtn.setBackgroundColor(color: UIColor(hexString: "34589D"), forState: .normal)
    //        }
    //    }
    
    @IBOutlet weak var termBtn: UIButton!
    let registerData = RegisterDetail()
    var errorIndex = 999
    var errorMessage = ""
    @IBOutlet weak var createBtn: UIButton! {
        didSet {
            createBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            createBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
        }
    }
    static var storyboardInstance:RegistartionViewController? {
        return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: RegistartionViewController.identifier) as? RegistartionViewController
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForShadow.addBottomShadow()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let attributedTitle = NSAttributedString(string: "CREATE ACCOUNT", attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        createBtn.setAttributedTitle(attributedTitle, for: .normal)
        let attributedTitlesecond = NSAttributedString(string: "SIGN IN WITH FACEBOOK", attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        fbBtn.setAttributedTitle(attributedTitlesecond, for: .normal)
        let attributedTitleThird = NSAttributedString(string: "REGISTER", attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.black] )
        registerLbl.attributedText = attributedTitleThird
        termBtn.titleLabel?.font =  BrandenFont.regular(with: 14)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Click Action
    @IBAction func onClickNotify(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "ic_switch_off"){
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
        }
    }
    
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func onCLickCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onCLickFbBtn(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        if AccessToken.current != nil{
            MBProgressHUD.hide(for: self.view, animated: true)
            
            print("Move to Another VC")
        }
        else{
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email", "public_profile", "user_birthday"], from: self)
            { loginResult, error in
                
               // print("Result",loginResult as Any)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if ((error) != nil){
                    print("Process error", error?.localizedDescription as Any)
                    
                }
                else if loginResult!.isCancelled {
                    print("Cancelled")
                }
                else{
                    print(loginResult?.token as Any)
                    if (loginResult?.grantedPermissions.contains("email"))! {
                        print(loginResult as Any);
                        self.fetchDataFromFB()
                    }
                }
            }
        }
    }
    @IBAction func onClickCreateBtn(_ sender: Any) {
        let color2 = UIColor(hex: 0x424242)
        createBtn.backgroundColor = color2
        self.view.endEditing(true)
        if isAllValid() {
            CallCreateUserApi()
        } else {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Facebook Login
    
    func fetchDataFromFB(){
        if(AccessToken.current != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else { return }
                print("info",Info)
                
                if (((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String) != nil {
                    //Download image from imageURL
                }
                let json = JSON(Info)
                let height = json["picture"]["data"]["height"].intValue
                let url = json["picture"]["data"]["url"].stringValue
                let lastName = json["last_name"].stringValue
                let email = json["email"].stringValue
                let first_name = json["first_name"].stringValue
                let fb_ID = json["id"].intValue
                print("height",height)
                print("url",url)
                print("lastName",lastName)
                print("email",email)
                print("first_name",first_name)
                print("fb_ID",fb_ID)
            })
        }
    }
    
}
extension RegistartionViewController:NoInternetDelgate{
    func didCancel() {
        self.CallCreateUserApi()
    }
}
