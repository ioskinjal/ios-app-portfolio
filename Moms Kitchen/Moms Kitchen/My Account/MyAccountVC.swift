//
//  MyAccountVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class MyAccountVC: BaseViewController {

    static var storyboardInstance:MyAccountVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MyAccountVC.identifier) as? MyAccountVC
    }
    
    @IBOutlet weak var viewNotification: UIView!{
        didSet{
            self.viewNotification.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewchangePassword: UIView!{
        didSet{
            self.viewchangePassword.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewUserProfile: UIView!{
        didSet{
            self.viewUserProfile.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "My Account", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        
        
    }

    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UIButton Click Events
    @IBAction func onClickUserProfile(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickChangePassword(_ sender: UIButton) {
        let nextVC = ChangePasswordVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickNotification(_ sender: UIButton) {
        let nextVC = NotificationSettingVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
