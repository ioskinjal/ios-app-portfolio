//
//  RegisterVC.swift
//  CablePay
//
//  Created by admin on 3/14/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class RegisterVC: BaseViewController {

    static var storyboardInstance:RegisterVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: RegisterVC.identifier) as? RegisterVC
    }
    
    @IBOutlet weak var txtCode: FPNTextField!{
        didSet{
            txtCode.parentViewController = self
            txtCode.delegate = self
            
            txtCode.flagSize = CGSize(width: 35, height: 35)
            txtCode.flagButtonEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            txtCode.hasPhoneNumberExample = true

        }
    }
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Register", action: #selector(onClickBack))
        
    }
    @IBOutlet weak var txtDateOfBirth: UITextField!{
        didSet{
            let pickerView =  UIDatePicker()
            pickerView.datePickerMode = .date
            let mydate = Date()
            pickerView.maximumDate = mydate
            pickerView.addTarget(self, action: #selector(startTime(_:)), for: UIControl.Event.valueChanged)
            txtDateOfBirth.inputView = pickerView
        }
    }
    
    @objc func startTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDateOfBirth.text = formatter.string(from: sender.date)
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickRegister(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickAccept(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "ic_check"){
            sender.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: .normal)
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
extension RegisterVC: FPNTextFieldDelegate {
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))
        
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164)!,
            textField.getFormattedPhoneNumber(format: .International)!,
            textField.getFormattedPhoneNumber(format: .National)!,
            textField.getFormattedPhoneNumber(format: .RFC3966)!,
            textField.getRawPhoneNumber()!
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
}
