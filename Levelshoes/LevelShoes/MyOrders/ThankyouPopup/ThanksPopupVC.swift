//
//  ThanksPopupVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 25/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ThanksPopupVC: UIViewController {
    var popupHeader = ""
    var popupDesc = ""
    var popupDescHidden  = false
    @IBOutlet weak var thanksView: ThanksPopup!
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction()
        thanksView.lblHeader.text = popupHeader
        thanksView.lblDesc.isHidden = popupDescHidden == true ? true : false
        thanksView.lblDesc.text = popupDesc
        
        // Do any additional setup after loading the view.
    }
    private func addAction(){
        thanksView.btnContinue.addTarget(self, action: #selector(continueSelector), for: .touchUpInside)
    }
    @objc func continueSelector(sender : UIButton) {
        //Write button action here
        print("Continue to new task")
        hidepopupWhenTappedAround()
        ///self.navigationController?.popViewController(animated: true)
    }
    func hidepopupWhenTappedAround() {
        self.dismiss(animated: true, completion: nil)
    }
   

}
