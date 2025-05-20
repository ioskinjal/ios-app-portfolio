//
//  MSContactUsVC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSContactUsVC: BaseViewController
{
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtQuestionOrComment: UITextView!
    @IBOutlet var viewTxtQuestion: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "ContactUs", action: #selector(btnSideMenuOpen))

        // Do any additional setup after loading the view.
    }
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()

    }
    override func viewDidLayoutSubviews()
    {
        txtName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtPhone.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtEmail.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        viewTxtQuestion.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }

    @IBAction func btnSaveAddressClick(_ sender: Any)
    {
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MSContactUsVC: UITextFieldDelegate,UITextViewDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            textField.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        viewTxtQuestion.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            self.viewTxtQuestion.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
}
