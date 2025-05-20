//
//  ForgotPasswordVC.swift
//  XPhorm
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    static var storyboardInstance:ForgotPasswordVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ForgotPasswordVC.identifier) as? ForgotPasswordVC
    }
    
    @IBOutlet weak var btnSubmit: SignInButton!
    @IBOutlet weak var txtEmail: Textfield!{
        didSet{
            txtEmail.keyboardType = .emailAddress
        }
    }
    
    @IBOutlet weak var lblForgotPwd: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage()
    {
        btnSubmit.setTitle("Submit".localized, for: .normal)
        lblForgotPwd.text = "Forgot Username/Password".localized
        txtEmail.placeholder = "Email".localized
    }
    

    @IBAction func onClickSubmit(_ sender: SignInButton) {
        if txtEmail.text!.isEmpty {
            self.alert(title: "", message: "Please enter email address".localized)
        }else if !txtEmail.text!.isValidEmailId{
            self.alert(title: "", message: "Please enter a valid email id".localized)
        }else{
            forgotPwd()
        }
    }
    
    func forgotPwd() {
        Modal.shared.login(vc: self, param: ["forgot_email":txtEmail.text!,
                                                 "action":"forgotPassword",
                                                 "lId":UserData.shared.getLanguage]) { (dic) in
                                                    print(dic)
                                                    let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                                                    self.alert(title: "", message: data, completion: {
                                                        self.navigationController?.popViewController(animated: true)
                                                    })
        }
    }
    @IBAction func onClickSignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
