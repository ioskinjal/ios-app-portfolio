//
//  MSMessageDetailsVC.swift
//  MIShop
//
//  Created by nct48 on 07/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSMessageDetailsVC: BaseViewController
{

    @IBOutlet var lblMessageTitle: UILabel!
    @IBOutlet var lblMessageDate: UILabel!
    @IBOutlet var lblMessageText: UILabel!
    
    @IBOutlet var btnReply: UIButton!{didSet{
       
        }}
    
    @IBOutlet var btnForward: UIButton!{didSet{
        
        
        }}
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Messages", action: #selector(btnSideMenuOpen))
        
        
        btnForward.layer.borderColor = colors.LightGray.color.cgColor
        btnForward.layer.borderWidth = 1
        
        btnReply.layer.borderColor = colors.LightGray.color.cgColor
        btnReply.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    @IBAction func btnReplyClick(_ sender: Any) {
    }
    @IBOutlet var btnForwardClick: UIButton!
    
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
