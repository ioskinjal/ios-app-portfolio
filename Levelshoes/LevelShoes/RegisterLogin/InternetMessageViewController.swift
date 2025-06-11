//
//  InternetMessageViewController.swift
//  LevelShoes
//
//  Created by apple on 4/25/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class InternetMessageViewController: UIViewController {
    @IBOutlet weak var homePageBtn: UIButton!
    @IBOutlet weak var tryAgainBtn: UIButton!
    {
        didSet{
            tryAgainBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            tryAgainBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      homePageBtn.layer.borderWidth = 1
      homePageBtn.layer.borderColor = UIColor.black.cgColor
      homePageBtn.setBackgroundColor(color: UIColor(hexString: "C7C7C7"), forState: .highlighted)
    }
    @IBAction func onClickTryAgainBtn(_ sender: Any) {
    }
    @IBAction func onCLickHomeBtn(_ sender: Any) {
    }


}
