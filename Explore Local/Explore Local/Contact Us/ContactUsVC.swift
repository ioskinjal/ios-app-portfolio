//
//  ContactUsVC.swift
//  Talabtech
//
//  Created by NCT 24 on 11/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit


class ContactUsVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:ContactUsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ContactUsVC.identifier) as? ContactUsVC
    }
    
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var btnSubmit: GreenButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.placeholder = "Message Description"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        let user = UserData.shared.getUser()
        if user != nil{
        let array:NSArray = UserData.shared.getUser()!.name.components(separatedBy: " ") as NSArray
        self.txtFirstName.text = array[0] as? String
        self.txtLastName.text = array[1] as? String
        self.txtEmail.text = UserData.shared.getUser()?.email
        }else{
            self.txtFirstName.isUserInteractionEnabled = true
             self.txtLastName.isUserInteractionEnabled = true
             self.txtEmail.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        print("onClickSubmit")
        if isValidated() {
            callContactUsAPI()
        }
    }
    
    
    
}

//MARK: Custom function
extension ContactUsVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Contact Us", action: #selector(onClickMenu(_:)))
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func callContactUsAPI() {
        Modal.shared.home(vc: self, param: ["action":"contactus","user_id":UserData.shared.getUser()?.user_id ?? "", "email":txtEmail.text!, "description":textView.text!, "fname":txtFirstName.text!, "lname":txtLastName.text!,
                                            "contact":txtContactNo.text!]) { (dic) in
            print(dic)
    
        self.alert(title: "", message: ResponseKey.fatchData(res: dic, valueOf: .message).str, completion: {
            self.navigationController?.popViewController(animated: true)
        })
        }
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtFirstName.text?.isEmpty)! {
            ErrorMsg = "Please enter a first name"
        }
        else if (txtLastName.text?.isEmpty)! {
            ErrorMsg = "Please enter a Last name"
        }
        else if (txtEmail.text?.isEmpty)! {
            ErrorMsg = "Please enter a email Id"
        }
        else if !(txtEmail.text?.isValidEmailId)! {
            ErrorMsg = "Email Id is not valid"
        }else if (txtContactNo.text?.isEmpty)! {
            ErrorMsg = "please enter contact number"
        }else if (txtContactNo.text!.length != 10) {
            ErrorMsg = "contact number is not valid"
        }
        else if (textView.text?.isEmpty)! {
            ErrorMsg = "Please enter a message"
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
    
}
