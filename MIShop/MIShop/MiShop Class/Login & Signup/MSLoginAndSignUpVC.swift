//
//  MSLoginAndSignUpVC.swift
//  MIShop
//
//  Created by nct48 on 02/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSLoginAndSignUpVC: BaseViewController
{

    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var viewLine1: UIView!
    @IBOutlet var viewLine2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Mishop", action: #selector(btnSideMenuOpen))

        // Do any additional setup after loading the view.
    }
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    @IBAction func btnLoginClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":0])
    }
    
    @IBAction func btnSignUpClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":1])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MSLoginAndSignUpPageVC"
        {
            if let imagesPageVC = segue.destination as? MSLoginAndSignUpPageVC
            {
                imagesPageVC.pageViewControllerDelegate = self
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
extension MSLoginAndSignUpVC: AccountSettingPageViewControllerDelegate
{
    func setupPageController(numberOfPages: CGFloat)
    {
        
    }
    
    func turnPageController(to index: Int)
    {
        if index == 0
        {
            print(123)
            viewLine1.backgroundColor = colors.DarkBlue.color
            viewLine2.backgroundColor = colors.DarkGray.color
            btnLogin.isSelected=true
            btnSignUp.isSelected=false
        }
        else
        {
            print(456)
            viewLine1.backgroundColor = colors.DarkGray.color
            viewLine2.backgroundColor = colors.DarkBlue.color
            btnLogin.isSelected=false
            btnSignUp.isSelected=true
        }
    }
}



