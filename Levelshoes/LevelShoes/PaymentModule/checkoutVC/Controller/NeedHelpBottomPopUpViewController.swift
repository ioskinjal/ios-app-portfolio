//
//  NeedHelpBottomPopUpViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 09/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup

class NeedHelpBottomPopUpViewController: BottomPopupViewController{
    var parentController : UIViewController?
    @IBOutlet weak var lblMeedHelp: UILabel!{
        didSet{
            lblMeedHelp.text = "Need Help".localized
        }
    }
    @IBOutlet weak var lblCallUs: UILabel!{
        didSet{
            lblCallUs.text = "callus".localized
        }
    }
    @IBOutlet weak var lblGuestserviceHead: UILabel!{
        didSet{
            lblGuestserviceHead.text = "gservice".localized
        }
    }
    @IBOutlet weak var lblTollFreeHead: UILabel!{
        didSet{
            lblTollFreeHead.text = "tollFree".localized
        }
    }
    
    
    @IBOutlet weak var lblLocation: UILabel!{
        didSet{
            lblLocation.text = "Location".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                //lblLocation.font =  UIFont(name: "Cairo-Light", size: lblLocation.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblAddress: UILabel!{
        didSet{
            lblAddress.text = "ANS".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                //lblAddress.font =  UIFont(name: "Cairo-Light", size: 15)
            }
        }
    }
    @IBOutlet weak var btnViewmap: UIButton!{
        didSet{
           //btnViewmap.setTitle("maps".localized, for: .normal)
            btnViewmap.titleLabel?.text = "maps".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                //btnViewmap.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
            }
            btnViewmap.underline()
        }
    }
    
    @IBOutlet weak var lblGuestServiceHoursAns: UILabel!
    @IBOutlet weak var lblWorkingHour2: UILabel!
    @IBOutlet weak var lblWorkingHour: UILabel!
    @IBOutlet weak var lblWorkingday2: UILabel!{
        didSet{
            lblWorkingday2.text = "weekDays".localized
            //lblweekDays.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblWorkingDay: UILabel!{
        didSet{
            lblWorkingDay.text = "regularDays".localized
            //lblweekDays.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblWorkingHours: UILabel!{
        didSet{
            lblWorkingHours.text = "working_hrs".localized
        }
    }
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var faqButtonOutlet: UIButton!{
        didSet{
            faqButtonOutlet.setTitle("faq".localized, for: .normal)
            faqButtonOutlet.addTextSpacing(spacing: 1.5, color: Common.blackColor)
            
        }
    }
    @IBOutlet weak var popUpBackGroundView: UIView!
    
    var height: CGFloat = 574

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - BottomPopup overridden methods
    override func getPopupHeight() -> CGFloat {
        return height
    }
    
    override func viewDidLayoutSubviews() {
        popUpBackGroundView.layer.cornerRadius = 0
//        faqButtonOutlet.layer.cornerRadius = 5
//        faqButtonOutlet.layer.borderWidth = 1
//        faqButtonOutlet.layer.borderColor = UIColor.black.cgColor
    }
    @IBAction func crossBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tollFreeNoCallAction(_ sender: Any) {
        self.makePhoneCall(phoneNumberValue: phoneNumberLabel.text ?? "")
    }
    
    @IBAction func viewMapSelector(_ sender: UIButton) {
        print("VIew map Acton")
        let urlString = "https://maps.google.com/?q=25.1988,55.2796"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func FAQsButtonAction(_ sender: Any) {
        print("Open FAQS");
        let storyboard =  UIStoryboard(name: "MyProfile", bundle: Bundle.main)
        let faqsVC = storyboard.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
        faqsVC.commingFrom = "Help"
        faqsVC.modalPresentationStyle = .fullScreen
        self.present(faqsVC, animated: true, completion: nil)
//        let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
//        let changeVC = storyboards.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
//        //self.parentController?.navigationController?.pushViewController(changeVC!, animated: true)
//        self.parentController?.present(changeVC, animated: true, completion: nil)
    }
    func makePhoneCall(phoneNumberValue: String) {
        print("MAKE PHONE CALLS")
        let callString = "call".localized
        var questionMark  = "?"
        var phoneNumber = phoneNumberValue
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            questionMark = "+؟"
            phoneNumber = "9718005383573"
        }
        
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: ("\(callString) " + phoneNumber + "\(questionMark)"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "\(callString)", style: .default, handler: { (action) in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }))
      
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                    
            self.present(alert, animated: true, completion: nil)
        }
    }
}
