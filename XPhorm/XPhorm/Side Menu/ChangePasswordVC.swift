//
//  ChangePasswordVC.swift
//  XPhorm
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    static var storyboardInstance:ChangePasswordVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as? ChangePasswordVC
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtRePwd: UITextField!
    @IBOutlet weak var txtNewPwd: UITextField!
    @IBOutlet weak var txtOldPwd: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Change Password".localized, action: #selector(onClickBack(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
        txtUserName.text = UserData.shared.getUser()!.firstName + " " + UserData.shared.getUser()!.lastName
        txtUserName.isUserInteractionEnabled = false
    }

    func setLanguage(){
     self.txtOldPwd.placeholder = "Old Password".localized
    self.txtNewPwd.placeholder = "New Password".localized
    self.txtRePwd.placeholder = "Re-enter Password".localized
    self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
            callChangePwd()
        }
    }
    
    func callChangePwd(){
        let param = ["newpsw":txtNewPwd.text!,
                     "oldpsw":txtOldPwd.text!,
                     "re_enterpsw":txtRePwd.text!,
                     "action":"updatePassword",
                     "lId":UserData.shared.getLanguage,
                     "userId":UserData.shared.getUser()!.id]
        
        Modal.shared.setting(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        if (txtOldPwd.text?.isEmpty)! {
            ErrorMsg = "Please enter current password".localized
        }
        else if (txtNewPwd.text?.isEmpty)! {
            ErrorMsg = "Please enter new password".localized
        }
        else if (txtRePwd.text?.isEmpty)! {
            ErrorMsg = "Please enter re-enter password".localized
        }
        else if txtNewPwd.text! != txtRePwd.text! {
            ErrorMsg = "new password and re-enter password not match!".localized
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
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
