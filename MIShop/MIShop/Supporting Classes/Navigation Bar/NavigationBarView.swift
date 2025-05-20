//
//  NavigationBarView.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class NavigationBarView: UIView
{

    @IBOutlet weak var btnShop: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnfav: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var navigationView: UIView!{didSet{
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{ navigationView.backgroundColor = .white}
        }}
    @IBOutlet var bottomViewLine: UIView!{didSet{
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{ bottomViewLine.isHidden = false}
        else {bottomViewLine.isHidden = true}
        }}
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
//    func setUpNavigation(vc:UIViewController, isBackButton:Bool, btnTitle:String = "", navigationTitle:String, action: Selector) {
//        if isBackButton{
//            btnMenu.setImage(#imageLiteral(resourceName: "BackArrow"), for: UIControlState())
//        }
//        else{
//            btnMenu.setImage(#imageLiteral(resourceName: "MenuIcon"), for: UIControlState())
//        }
//        btnMenu.addTarget(vc, action:action, for: UIControlEvents.touchUpInside)
//        btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControlState())
//        btnMenu.setTitleColor(.white, for: UIControlState())
//        lblTitle.text = navigationTitle
//    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
