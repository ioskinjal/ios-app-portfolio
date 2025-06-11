//
//  CancelSubscriptionSuccessPopup.swift
//  OTT
//
//  Created by Chandra Sekhar on 21/08/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit

protocol CancelSubscriptionSuccessPopupProtocol {
    func okThanksClicked()
}

class CancelSubscriptionSuccessPopup: UIViewController {

    var delegate:CancelSubscriptionSuccessPopupProtocol! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    @IBAction func okThanksClicked(_ sender: Any) {
        self.delegate.okThanksClicked()
    }
    
    override func didReceiveMemoryWarning() {
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
