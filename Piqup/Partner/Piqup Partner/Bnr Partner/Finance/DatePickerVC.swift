//
//  DatePickerVC.swift
//  BnR Partner
//
//  Created by KASP on 11/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

// This protocol method is used to pass Date object
protocol DatePickerDelegate {
    func userDidSelectDate(selectedDate:Date)
    func cancelDateClicked()
}


class DatePickerVC: BaseVC {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    
    var delegate: DatePickerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCancel.setTitle(appConts.const.cANCEL, for: .normal)
        btnDone.setTitle(appConts.const.bTN_DONE, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCanelClicked(_ sender: Any) {
        
        delegate?.cancelDateClicked()
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        let finalDate:Date = self.datePicker.date
        delegate?.userDidSelectDate(selectedDate: finalDate)
        
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
