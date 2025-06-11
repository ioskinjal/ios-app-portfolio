//
//  OnBoardingScreen2VC.swift
//  Luxongo
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OnBoardingScreen2VC: UIViewController {
    //MARK: Properties
    static var storyboardInstance:OnBoardingScreen2VC! {
        return (StoryBoard.main.instantiateViewController(withIdentifier: OnBoardingScreen2VC.identifier) as! OnBoardingScreen2VC)
    }
    
    //MARK: Outlets
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var lblDescription: LabelRegular!
    @IBOutlet weak var containtView: UIView!{
        didSet{
            containtView.setCornerRadious(withRadious: 20.0, cornerBorderSides: [.topLeft])
        }
    }
    
    //MARK: App Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
