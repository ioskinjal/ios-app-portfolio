//
//  MSMyShoppingAddressVC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSMyShoppingAddressVC: UIViewController
{
    @IBOutlet var txtApartment: UITextField!
    @IBOutlet var txtStreetName: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtZipcode: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews()
    {
        txtApartment.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtStreetName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtCountry.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtState.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtCity.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtZipcode.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtPhone.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
    @IBAction func btnSaveAddressClickl(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension MSMyShoppingAddressVC: UITextFieldDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            textField.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
}

