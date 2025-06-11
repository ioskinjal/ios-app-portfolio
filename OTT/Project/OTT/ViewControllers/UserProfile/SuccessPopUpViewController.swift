//
//  SuccessPopUpViewController.swift
//  sampleColView
//
//  Created by Ankoos on 14/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
@objc protocol SuccessPopUpViewControllerDelegate{
    @objc optional func  DoneButtonClicked()
}
class SuccessPopUpViewController: UIViewController {
    var delegate:SuccessPopUpViewControllerDelegate!
    // MARK: - Navigation
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusMessageLabel: UILabel!
     @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    var destinationVC : UIViewController!
    var fromUpdateMobile:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        if fromUpdateMobile{
            statusImageView.image = #imageLiteral(resourceName: "success_status_icon")
            statusMessageLabel.text = "Your phone number is updated".localized
            statusLabel.text = "Success".localized
        }else{
            statusImageView.image = #imageLiteral(resourceName: "success_status_icon")
            statusMessageLabel.text = "Your password updated successfully".localized
            statusLabel.text = "Success".localized
        }
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Custom actions
    @IBAction func DoneButtonClicked(_ sender: Any) {
        if fromUpdateMobile{
//            self.delegate.doneButtonClickedForDestination!(destination: destinationVC)
        }else{
            self.delegate?.DoneButtonClicked!()
        }
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
