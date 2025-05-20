//
//  CountryCodeVC.swift
//  BooknRide
//
//  Created by NCrypted on 07/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

protocol CodeDelegate {
    func didSelectCode(code:CountryCode)
}

class CountryCodeVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    @IBOutlet weak var codePickerView: UIPickerView!
    
    var codes = NSArray()
    var delegate: CodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        codePickerView.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return codes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let code = codes.object(at: row) as! CountryCode
        return code.country_code
    }
    
    
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        let selectedCode:CountryCode = codes.object(at:codePickerView.selectedRow(inComponent: 0)) as! CountryCode
        
        delegate?.didSelectCode(code: selectedCode)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
