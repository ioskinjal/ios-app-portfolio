//
//  confirmReturnVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class confirmReturnVC: UIViewController {
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var lblReturnSuccess: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReturnSuccess.font = UIFont(name: "Cairo-SemiBold", size: lblReturnSuccess.font.pointSize)
            }
            lblReturnSuccess.text = "returnSuccesfull".localized
            lblReturnSuccess.addTextSpacing(spacing: 1.0)
        }
    }
    @IBOutlet weak var lblSucessMsg: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSucessMsg.font = UIFont(name: "Cairo-Light", size: lblSucessMsg.font.pointSize)
            }
            lblSucessMsg.text = "confirmMsg".localized
             lblSucessMsg.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var lblOrderTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblOrderTitle.font = UIFont(name: "Cairo-SemiBold", size: lblOrderTitle.font.pointSize)
            }
            lblOrderTitle.text = "yourOrderno".localized
            lblOrderTitle.addTextSpacing(spacing: 1)
        }
    }
    @IBOutlet weak var lblOrderNo: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblOrderNo.addTextSpacing(spacing: 1)
            }
        }
    }
    
    @IBOutlet weak var lblWhatsUpNext: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblWhatsUpNext.font = UIFont(name: "Cairo-SemiBold", size: lblWhatsUpNext.font.pointSize)
            }
            lblWhatsUpNext.text = "whatNext".localized
        }
    }
    
    @IBOutlet weak var lbl1: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lbl1.font = UIFont(name: "Cairo-Light", size: lbl1.font.pointSize)
            }
            lbl1.text = "willRcvConfirmationEmail".localized
            lbl1.addTextSpacing(spacing: 0.5)
        }
    }
    
    @IBOutlet weak var lbl2: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lbl2.font = UIFont(name: "Cairo-Light", size: lbl2.font.pointSize)
            }
            lbl2.text = "willRcvTextmsg".localized
            lbl2.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var lbl3: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lbl3.font = UIFont(name: "Cairo-Light", size: lbl3.font.pointSize)
            }
            lbl3.text = "fourthDelivery"
            lbl3.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var lbl4: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lbl4.font = UIFont(name: "Cairo-Light", size: lbl4.font.pointSize)
            }
            lbl4.text = "codSelected".localized
            lbl4.addTextSpacing(spacing: 0.5)
        }
    }
    
    @IBOutlet weak var lblCountinueShopping: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblCountinueShopping.font = UIFont(name: "Cairo-Regular", size: lblCountinueShopping.font.pointSize)
            }
            lblCountinueShopping.text = "continue_shopping".localized
            lblCountinueShopping.addTextSpacing(spacing: 1.5)
        }
    }
    
    var orderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderNo.text = orderId
        loadHeaderAction()
    }
    private func loadHeaderAction(){
        header.buttonClose.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.backButton.isHidden = true
        header.headerTitle.text = "return_confirmation".localized

    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                  if vc.isKind(of: MyAccountViewController.self) {
                      return false
                  } else {
                      return true
                  }
              })
    }

    // MARK: - IBAction
    @IBAction func continueSelector(_ sender: UIButton) {
        self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                   if vc.isKind(of: MyAccountViewController.self) {
                       return false
                   } else {
                       return true
                   }
               })
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
