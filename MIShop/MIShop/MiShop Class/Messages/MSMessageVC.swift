//
//  MSMessageVC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSMessageVC: BaseViewController {

    @IBOutlet var btnChangePassword: UIButton!{didSet{btnChangePassword.isSelected=true}}
    @IBOutlet var btnEmailNotification: UIButton!
    @IBOutlet var btnShippingAddress: UIButton!
    @IBOutlet var viewLineOne: UIView!
    @IBOutlet var viewLineTwo: UIView!
    @IBOutlet var viewLineThree: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Messages", action: #selector(btnSideMenuOpen))
    }
   
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    
    @IBAction func btnChangePasswordClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":0])
    }
    
    @IBAction func btnEmailNotificationClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":1])
    }
    
    @IBAction func btnShippingAddressClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":2])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MSMessagePageVC"
        {
            if let imagesPageVC = segue.destination as? MSMessagePageVC
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

extension MSMessageVC: MSMessagePageVCDelegate
{
    func setupPageController(numberOfPages: CGFloat)
    {
        
    }
    
    func turnPageController(to index: Int)
    {
        if index == 0
        {
            print(123)
            viewLineOne.isHidden=false
            viewLineTwo.isHidden=true
            viewLineThree.isHidden=true
            
            btnChangePassword.isSelected=true
            btnEmailNotification.isSelected=false
            btnShippingAddress.isSelected=false
            
            //setUpNavigation(vc: self, navigationTitle: "Requested Rides", action: #selector(btnSideMenuOpen))
            
        }
        else if index == 1
        {
            print(456)
            viewLineOne.isHidden=true
            viewLineTwo.isHidden=false
            viewLineThree.isHidden=true
            
            btnChangePassword.isSelected=false
            btnEmailNotification.isSelected=true
            btnShippingAddress.isSelected=false
            
            //setUpNavigation(vc: self, navigationTitle: "Upcoming Rides", action: #selector(btnSideMenuOpen))
            
        }
        else if index == 2
        {
            print(456)
            viewLineOne.isHidden=true
            viewLineTwo.isHidden=true
            viewLineThree.isHidden=false
            
            btnChangePassword.isSelected=false
            btnEmailNotification.isSelected=false
            btnShippingAddress.isSelected=true
            
            //setUpNavigation(vc: self, navigationTitle: "Ride History", action: #selector(btnSideMenuOpen))
            
        }
    }
}
