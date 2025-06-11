//
//  PwdSuccessVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 28/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class PwdSuccessVC: UIViewController {

    @IBOutlet weak var lblPasswordChnage: UILabel!{
        didSet{
            lblPasswordChnage.text =  "Password Changed".localized
        }
    }
    @IBOutlet weak var lblToHave: UILabel!{
        didSet{
            lblToHave.text = "You have successfully changed your password Enjoy Shopping!".localized
        }
    }
    @IBOutlet weak var btnStartShopping: UIButton!{
        didSet{
            btnStartShopping.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            btnStartShopping.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
           if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
            btnStartShopping.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
            btnStartShopping.setTitle("START SHOPPING".localized, for: .normal)
        }
    }
    @IBOutlet weak var changingText: UILabel!
    @IBOutlet weak var changingLbl: UILabel!
    static var storyboardInstance:PwdSuccessVC? {
           return StoryBoard.ForgotPW.instantiateViewController(withIdentifier: PwdSuccessVC.identifier) as? PwdSuccessVC
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func onClickStartShopping(_ sender: Any) {
        
        //User is Not Loggedin case Handle
        UserDefaults.standard.set(nil,forKey: "userToken")
        userLoginStatus(status: false)
        M2_isUserLogin = false
       
         UserDefaults.standard.setValue(nil, forKey: "guest_carts__item_quote_id")
         UserDefaults.standard.setValue(nil, forKey: "quote_id_to_convert")
        
        let loginVC = LoginViewController.storyboardInstance!
        let navigationController = UINavigationController(rootViewController: loginVC)
        loginVC.isCommingPwdSuccessScreen = true
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
//        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
//        UserDefaults.standard.setValue(nil, forKey: "guest_carts__item_quote_id")
//        UserDefaults.standard.setValue(nil, forKey: "quote_id_to_convert")
//        UIApplication.shared.keyWindow?.rootViewController = nextViewController
 

        
        //self.navigationController?.pushViewController(LatestHomeViewController.storyboardInstance!, animated: true)
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
