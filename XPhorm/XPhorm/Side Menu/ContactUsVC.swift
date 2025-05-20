//
//  ContactUsVC.swift
//  XPhorm
//
//  Created by admin on 7/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ContactUsVC: BaseViewController {
    @IBOutlet weak var btnSubmit: SignInButton!
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
           txtDesc.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        txtDesc.setRadius(8.0)
        }
    }
    @IBOutlet weak var txtContactNo: Textfield!
    @IBOutlet weak var txtEmail: Textfield!
    @IBOutlet weak var txtLastName: Textfield!
    @IBOutlet weak var txtFirstName: Textfield!
    
    static var storyboardInstance:ContactUsVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ContactUsVC.identifier) as? ContactUsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Contact Us".localized, action: #selector(onclickBack(_:)))
        
        txtFirstName.text = UserData.shared.getUser()?.firstName
        txtLastName.text = UserData.shared.getUser()?.lastName
        txtEmail.text = UserData.shared.getUser()?.email
        txtContactNo.text = UserData.shared.getUser()?.contactNumber
    }
    
    @objc func onclickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    @IBAction func onClickSubmit(_ sender: SignInButton) {
        if isValidated(){
            addContactUs()
        }
    }
    
    func addContactUs(){
        let param = ["firstname":txtFirstName.text!,
        "lastname":txtLastName.text!,
        "email":txtEmail.text!,
        "mobno":txtContactNo.text!,
        "msgdec":txtDesc.text!,
        "lId":UserData.shared.getLanguage,
        "action":"contact"]
        
        Modal.shared.conatct(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func setLanguage(){
        btnSubmit.setTitle("SUBMIT".localized, for: .normal)
        txtDesc.placeholder = "Description".localized
        txtContactNo.placeholder = "Contact No".localized
        txtEmail.placeholder = "Email".localized
        txtLastName.placeholder = "Last name".localized
        txtFirstName.placeholder = "First name".localized
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter a first name".localized
        }else  if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter a last name".localized
        }else  if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter email address".localized
        } else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Please enter a valid email id".localized
        }else if (txtContactNo.text?.isEmpty)! {
            ErrorMsg = "Please enter password".localized
        }else if txtContactNo.text?.count != 10{
            ErrorMsg = "please enter valid contact number".localized
        }else if txtDesc.text.isEmpty{
            ErrorMsg = "please enter description".localized
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
