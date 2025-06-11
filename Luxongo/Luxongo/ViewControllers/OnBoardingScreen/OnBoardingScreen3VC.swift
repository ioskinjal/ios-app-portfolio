//
//  OnBoardingScreen3VC.swift
//  Luxongo
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OnBoardingScreen3VC: UIViewController {
    //MARK: Properties
    static var storyboardInstance:OnBoardingScreen3VC {
        return (StoryBoard.main.instantiateViewController(withIdentifier: OnBoardingScreen3VC.identifier) as! OnBoardingScreen3VC)
    }
    
    //MARK: Outlets
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var lblDescription: LabelRegular!
    @IBOutlet weak var containtView: UIView!{
        didSet{
            //containtView.setCornerRadious(withRadious: 20.0, cornerBorderSides: [.topLeft])
        }
    }
    
    //MARK: App Method
    override func viewDidLoad() {
        super.viewDidLoad()
        //containtView.setCornerRadious(withRadious: 20.0, cornerBorderSides: [.topLeft])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containtView.setCornerRadious(withRadious: 20.0, cornerBorderSides: [.topLeft])
    }
}
