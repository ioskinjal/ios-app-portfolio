//
//  ContactUsVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ContactUsVC: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.dropShadow()
        }
    }
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtEmailAddress: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var labelTitle: UILabel!
    
    static var storyboardInstance:ContactUsVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: ContactUsVC.identifier) as? ContactUsVC
    }
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlaceHolderLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        txtEmailAddress.text = UserData.shared.getUser()!.user_email
        txtName.text = UserData.shared.getUser()!.user_name
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func setUpPlaceHolderLabel() {
        txtMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 2
        // placeholderLabel.text = "Enter Some Dscription about yourself"
        placeholderLabel.text = localizedString(key: "Message*")
        placeholderLabel.font = UIFont(name:"Muli",size:15)        //UIFont.italicSystemFont(ofSize: (textViewSendMsg.font?.pointSize)!)
        
        txtMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMessage.font?.pointSize)! / 2)
        placeholderLabel.frame.size.width = txtMessage.frame.width - 15
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtMessage.text.isEmpty
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Contact Us")
        txtName.text = localizedString(key: "Name")
        txtEmailAddress.text = localizedString(key: "Email Address")
        btnSend.setTitle(localizedString(key: "Send"), for: .normal)
        btnCancel.setTitle(localizedString(key: "Cancel"), for: .normal)
    }
    func callApiContactus() {
        let dictParam = [
            "action": Action.sendContactus,
            "lId": "1",
            "name": txtName.text!,
            "message": txtMessage.text!,
            "email": txtEmailAddress.text!,
        ] as [String : Any]
        ApiCaller.shared.contactUs(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.shoWMessage(dict["message"] as? String ?? "")
        }
    }
    func shoWMessage(_ message: String) {
        let alert = UIAlertController(title: StringConstants.alert, message: message, preferredStyle: .alert)
        //  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - TextView Change
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtMessage {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtName.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.name)
            return false
        }
        else if (txtEmailAddress.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return false
        }
        else if AppHelper.isValidEmail(txtEmailAddress.text!) == false {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.validEmail)
            return false
        }
        else if (txtMessage.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.messageEmpty)
            return false
        }
        return true
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendAction(_ sender: UIButton) {
        if checkValidation() {
            callApiContactus()
        }
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
