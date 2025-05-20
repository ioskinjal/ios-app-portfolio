//
//  NavigationBarView.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {

    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnRight: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func setUpNavigation(vc:UIViewController, isBackButton:Bool, btnTitle:String = "", navigationTitle:String, action: Selector) {
//        if isBackButton{
//            btnMenu.setImage(#imageLiteral(resourceName: "ic_back"), for: UIControlState())
//        }
//        else{
//            btnMenu.setImage(#imageLiteral(resourceName: "hamburger-icon"), for: UIControlState())
//        }
//        btnMenu.addTarget(vc, action:action, for: UIControlEvents.touchUpInside)
//        btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControlState())
//        btnMenu.setTitleColor(Color.white, for: UIControlState())
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
