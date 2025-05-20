//
//  MSOrderVC.swift
//  MIShop
//
//  Created by nct48 on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSOrderVC: BaseViewController {

    @IBOutlet var btnMyBalance: UIButton!{didSet{btnMyBalance.isSelected=true}}
    @IBOutlet var btnPurchaseHistory: UIButton!
    @IBOutlet var btnSaleHistory: UIButton!
    @IBOutlet var viewLineOne: UIView!
    @IBOutlet var viewLineTwo: UIView!
    @IBOutlet var viewLineThree: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Order", action: #selector(btnSideMenuOpen))
    }
    
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    
    @IBAction func btnMyBalanceClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":0])
    }
    
    @IBAction func btnPurchaseHistoryClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":1])
    }
    
    @IBAction func btnSaleHistoryClick(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name("JobspageIndexChange"), object: nil, userInfo: ["index":2])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MSOrderPageVC"
        {
            if let imagesPageVC = segue.destination as? MSOrderPageVC
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

extension MSOrderVC: MSOrderPageVCDelegate
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
            
            btnMyBalance.isSelected=true
            btnPurchaseHistory.isSelected=false
            btnSaleHistory.isSelected=false
            
            //setUpNavigation(vc: self, navigationTitle: "Requested Rides", action: #selector(btnSideMenuOpen))
            
        }
        else if index == 1
        {
            print(456)
            viewLineOne.isHidden=true
            viewLineTwo.isHidden=false
            viewLineThree.isHidden=true
            
            btnMyBalance.isSelected=false
            btnPurchaseHistory.isSelected=true
            btnSaleHistory.isSelected=false
            
            //setUpNavigation(vc: self, navigationTitle: "Upcoming Rides", action: #selector(btnSideMenuOpen))
            
        }
        else if index == 2
        {
            print(456)
            viewLineOne.isHidden=true
            viewLineTwo.isHidden=true
            viewLineThree.isHidden=false
            
            btnMyBalance.isSelected=false
            btnPurchaseHistory.isSelected=false
            btnSaleHistory.isSelected=true
            
            //setUpNavigation(vc: self, navigationTitle: "Ride History", action: #selector(btnSideMenuOpen))
            
        }
    }
}
