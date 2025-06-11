//
//  PaymentSuccessViewController.swift
//  sampleColView
//
//  Created by Muzaffar on 16/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit

protocol PaymentSuccessVCDelegate {
    func didSelectedDoneForPaymentSuccessPopup()
}

class PaymentSuccessViewController: UIViewController, UIGestureRecognizerDelegate {

    var delegate : PaymentSuccessVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PaymentSuccessViewController.dismiss as (PaymentSuccessViewController) -> () -> ()))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        self.delegate?.didSelectedDoneForPaymentSuccessPopup()
    }
    @IBAction func doneTap(_ sender: Any) {
        self.delegate?.didSelectedDoneForPaymentSuccessPopup()
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
