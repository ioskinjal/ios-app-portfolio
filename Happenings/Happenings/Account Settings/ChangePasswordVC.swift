//
//  ChangePasswordVC.swift
//  Happenings
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    static var storyboardInstance:ChangePasswordVC? {
        return StoryBoard.accountsettings.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as? ChangePasswordVC
    }
    
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtOldPAssword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onCickSubmit(_ sender: UIButton) {
        if isValidated(){
            callChangePassword()
        }
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtOldPAssword.text?.isEmpty)! {
            ErrorMsg = "Please enter current password"
        }
        else if (txtNew.text?.isEmpty)! {
            ErrorMsg = "Please enter new password"
        }
        else if (txtConfirm.text?.isEmpty)! {
            ErrorMsg = "Please enter confirm password"
        }
        else if txtNew.text! != txtConfirm.text! {
            ErrorMsg = "new password and confirm new password not match!"
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
        
    }
    
    func callChangePassword() {
        let param = [
            "action":"change_password",
            "user_id":UserData.shared.getUser()!.user_id,
            "old_pwd":txtOldPAssword.text!,
            "new_pwd":txtNew.text!,
            "confirm_pwd":txtConfirm.text!
        ]
        Modal.shared.changePassword(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
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
