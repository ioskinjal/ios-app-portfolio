//
//  emailPopupVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/09/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
protocol emailPopupVCDelegate : class {
    func continuousBtnAction(emailPopupVC :emailPopupVC, email: String)
     func linkCustomerAccount(emailPopupVC :emailPopupVC)
}
class emailPopupVC: UIViewController {
   var  first_name :String = ""
    var lastName: String = ""
    var fb_ID :String = ""
     var popUpType :String = ""
    var verificationCode :String = ""
    var verificationEmailAddress :String = ""
    var isRegisterUser : Bool = false
     
    
    weak var emailPopupDelegate : emailPopupVCDelegate?

    @IBOutlet weak var popup: emailPopup!
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.popUpType == "verify"{
            self.popup.lblemailTitle.text = "Enter your verification code"
            self.popup.lblEmalDesc.text = "please check email for verification code"
            self.popup.txtEmail.placeholder = "verification code"
             print("verify code ===== %@",self.verificationCode)
        }
    }
    private func addAction(){
        popup.btnContinue.addTarget(self, action: #selector(continueSelector), for: .touchUpInside)
    }
    @objc func continueSelector(sender : UIButton) {
        //Write button action here
        print("Continue to new task")
        if self.popUpType == "verify"{
            
            if self.verificationCode == self.popup.txtEmail.text {
                print("verify code ===== %@",self.verificationCode)
                self.emailPopupDelegate?.linkCustomerAccount(emailPopupVC :self)
                hidepopupWhenTappedAround()
                
            }else{
                let errorMessage = "invalid_code".localized
                let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
        self.emailPopupDelegate?.continuousBtnAction(emailPopupVC: self, email:self.popup.txtEmail.text ?? "")
            hidepopupWhenTappedAround()
        }
        
    }
    func hidepopupWhenTappedAround() {
        self.dismiss(animated: true, completion: nil)
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
