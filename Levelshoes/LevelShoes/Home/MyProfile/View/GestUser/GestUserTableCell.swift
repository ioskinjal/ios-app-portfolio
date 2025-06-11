//
//  GestUserTableCell.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol GestUserTableCellProtocol: class {
    func registerButtonTap()
    func signButtonTap()
    
}
class GestUserTableCell: UITableViewCell {
    var delegate: GestUserTableCellProtocol?
      
    @IBOutlet weak var lblSigninRegisterHeader: UILabel!{
        didSet { //accountSigninRegister
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSigninRegisterHeader.font = UIFont(name: "Cairo-SemiBold", size: lblSigninRegisterHeader.font.pointSize)
            }
            lblSigninRegisterHeader.text = "aacountAccount".localized
        }
    }
    @IBOutlet weak var lblSigninRegisterDesc: UILabel!{
        didSet {//accountSigninRegisterDesc
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSigninRegisterDesc.font = UIFont(name: "Cairo-Light", size: lblSigninRegisterDesc.font.pointSize)
            }
            lblSigninRegisterDesc.text = "myAccountNewDesc".localized
            lblSigninRegisterDesc.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var _btnSignIn: UIButton!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _btnSignIn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            _btnSignIn.setTitle("accountSignin".localized, for: .normal)
            _btnSignIn.addTextSpacingButton(spacing: 1.5)
        }
    }
     @IBOutlet weak var _btnSignUp: UIButton!{
         didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _btnSignUp.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
             _btnSignUp.setTitle("accountSignup".localized, for: .normal)
             _btnSignUp.addTextSpacingButton(spacing: 1.5)
         }
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func SignInButtoAction(){
        self.delegate?.signButtonTap()
    }
    @IBAction func SignUpButtoAction(){
        self.delegate?.registerButtonTap()
    }
}
