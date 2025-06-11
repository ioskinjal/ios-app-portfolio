//
//  OnBoardingScreen1VC.swift
//  Luxongo
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OnBoardingScreen1VC: UIViewController {
    //MARK: Properties
    static var storyboardInstance:OnBoardingScreen1VC {
        return (StoryBoard.main.instantiateViewController(withIdentifier: OnBoardingScreen1VC.identifier) as! OnBoardingScreen1VC)
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
