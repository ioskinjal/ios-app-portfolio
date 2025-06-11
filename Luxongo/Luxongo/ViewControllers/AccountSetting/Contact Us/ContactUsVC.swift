//
//  ContactUsVC.swift
//  Luxongo
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ContactUsVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:ContactUsVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: ContactUsVC.identifier) as! ContactUsVC)
    }
    let ACCEPTABLE_CHARACTERS = "0123456789+"

    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: BlackBgButton!
    
    @IBOutlet weak var lblFullNm: LabelSemiBold!
    @IBOutlet weak var lblEmail: LabelSemiBold!
    @IBOutlet weak var lblConNo: LabelSemiBold!
    @IBOutlet weak var lblMsg: LabelSemiBold!
    
    @IBOutlet weak var tfFullNm: TextField!
    @IBOutlet weak var tfEmail: TextField!{
        didSet{
            self.tfEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var tfConNo: TextField!{
        didSet{
            self.tfConNo.keyboardType = .phonePad
            self.tfConNo.delegate = self
        }
    }
    
    @IBOutlet weak var textViewMsg: UITextView!{
        didSet{
            textViewMsg.placeholder = "Enter your menssage here.."
            textViewMsg.setPlaceHolderFontColor(font: Font.SourceSerifProRegular.size(17.0), color: Color.grey.textPlaceHolder)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        callContactUs()
    }
    
}

//API functions
extension ContactUsVC{
    
    func setUpData(){
        self.tfFullNm.text = UserData.shared.getUser()!.name
        self.tfEmail.text = UserData.shared.getUser()!.email
        self.tfConNo.text = UserData.shared.getUser()!.user_mobile_no
    }
    
    func callContactUs() {
        if isValidated(){
            let param:dictionary = ["name":tfFullNm.text!,
                                    "email":tfEmail.text!,
                                    "mobile":tfConNo.text!,
                                    "message":textViewMsg.text!,
            ]
            API.shared.call(with: .contactUs, viewController: self, param: param) { (response) in
                let msg = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                UIApplication.alert(title: "Success", message: msg, completion: {
                    self.popViewController(animated: true)
                })
            }
        }
    }
}

//MARK: Custom fucntions
extension ContactUsVC{
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfFullNm.text ?? "").isBlank {
            ErrorMsg = "Please enter your name"
        }else if (tfEmail.text ?? "").isBlank {
            ErrorMsg = "Please enter an Email"
        }else if !tfEmail.text!.isValidEmailId {
            ErrorMsg = "Please enter valid Email"
        }else if (tfConNo.text ?? "").isBlank {
            ErrorMsg = "Please enter contact number"
        }else if (textViewMsg.text ?? "").isBlank {
            ErrorMsg = "Please enter your message"
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

//MARK: TextField delegates
extension ContactUsVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfConNo{
            return string.allowCharacterSets(with: "01234567789+")
        }else{
            return true
        }
    }
    
}

