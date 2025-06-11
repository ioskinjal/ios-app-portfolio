//
//  SignoutTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import MBProgressHUD

protocol SignoutProtocol: class {
    func needHelp()
    func loadHomePage()
    func logoutView()
}

class SignoutTableViewCell: UITableViewCell {

    var delegate: SignoutProtocol?

    @IBOutlet weak var _lblUserName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblUserName.font = UIFont(name: "Cairo-SemiBold", size: _lblUserName.font.pointSize)
            }
        }
    }
    @IBOutlet weak var _lblUserEmail: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                _lblUserEmail.addTextSpacing(spacing: 0.5)
            }else{
                _lblUserEmail.font = UIFont(name: "Cairo-Light", size: _lblUserEmail.font.pointSize)
            }
        }
    }
    @IBOutlet weak var _btnSignOut: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _btnSignOut.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            _btnSignOut.setTitle("accountSignOut".localized, for: .normal)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }

    func getQuoteId(){
           if !M2_isUserLogin && (UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == "" ||  UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == nil) {
               ApiManager.getQuoteID(params: [:], success: { (resp) in
                   
                   UserDefaults.standard.set(resp, forKey: "guest_carts__item_quote_id")
                   UserDefaults.standard.synchronize()
                 userLoginStatus(status: false)
               })  {
                   // quote failure
                   // failure()
               }
           }
           
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func signOutPressed(_ sender: UIButton) {
        
        print("SIgn Out Pressed")
        UserDefaults.standard.set(nil , forKey: "userToken")
        UserDefaults.standard.set(nil, forKey:"customerId")
        UserDefaults.standard.set(nil, forKey:"storeId")
        UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
        UserDefaults.standard.set(nil,forKey: "quote_id_to_convert")
        UserDefaults.standard.set(nil, forKey: string.isFBuserLogin)
        removeAllWishListArray()
        //User is Not Loggedin case Handle
        M2_isUserLogin = false
        userLoginStatus(status: false)
        //getQuoteId()
       
        let fbLoginManager = LoginManager()
           fbLoginManager.logOut()
           let cookies = HTTPCookieStorage.shared
           let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
           for cookie in facebookCookies! {
               cookies.deleteCookie(cookie )
           }
     
        FacebookSignInManager.logoutFromFacebook()
        
     
        
        self.delegate?.loadHomePage()
      
       // FacebookSignInManager
        
      //  let storyboard = UIStoryboard(name: "orderDetail", bundle: nil)
      //  let vc = storyboard.instantiateViewController(withIdentifier: "orderDetailVC") as! orderDetailVC
//        let nav = UINavigationController()
//        nav.pushViewController(vc, animated: true)
        
//                let storyboard = UIStoryboard(name: "orderDetail", bundle: Bundle.main)
//                let orderDetailVC: orderDetailVC! = storyboard.instantiateViewController(withIdentifier: "orderDetailVC") as? orderDetailVC
//                let nav = UINavigationController()
//                nav.pushViewController(orderDetailVC, animated: true)
    }
    
}
