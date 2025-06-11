//
//  ChangePassword.swift
//  Luxongo
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    //MARK:Properties
    static var storyboardInstance:ChangePasswordVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as! ChangePasswordVC)
    }
    
    //MARK: Outlets
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblOldPw: LabelSemiBold!
    @IBOutlet weak var tfOldPw: TextField!
    @IBOutlet weak var lblNewPw: LabelSemiBold!
    @IBOutlet weak var tfNewPw: UITextField!
    @IBOutlet weak var lblConfPw: LabelSemiBold!
    @IBOutlet weak var tfConfPw: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickUpdate(_ sender: Any) {
        callChangePassword()
    }
    
}

//MARK: API function
extension ChangePasswordVC{
    func callChangePassword() {
        if isValidated(){
            let param:dictionary = ["userid": UserData.shared.getUser()!.userid,
                                    "old_password": tfOldPw.text!,
                                    "new_password": tfNewPw.text!,
                                    "confirm_password": tfNewPw.text!
            ]
            API.shared.call(with: .changePassword, viewController: self, param: param) { (response) in
                let msg = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                UIApplication.alert(title: "Success", message: msg, completion: {
                    self.popViewController(animated: true)
                })
            }
        }
    }
    
}

//MARK: Custom fucntion
extension ChangePasswordVC{
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfOldPw.text ?? "").isBlank {
            ErrorMsg = "Please enter your old password"
        }else if (tfNewPw.text ?? "").isBlank {
            ErrorMsg = "Please enter new Password"
        }else if tfNewPw.text!.count < 6 {
            ErrorMsg = "new password at list 6 character long"
        }else if (tfOldPw.text ?? "").isBlank {
            ErrorMsg = "Please enter confirm Password"
        }else if tfConfPw.text != tfNewPw.text {
            ErrorMsg = "Confirm password and New password not match"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
}
