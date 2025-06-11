//
//  InformationPopUpViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 09/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup

class InformationPopUpViewController: BottomPopupViewController {

    @IBOutlet weak var lblCallUs: UILabel!{
        didSet{
            lblCallUs.text = "callus".localized
        }
    }
    @IBOutlet weak var lblLocation: UILabel!{
        didSet{
            lblLocation.text = "Location".localized
        }
    }
    @IBOutlet weak var lblLocationAns: UILabel!{
        didSet{
            lblLocationAns.text = "ANS".localized
        }
    }
    @IBOutlet weak var lblGuestserviceHour: UILabel!
    @IBOutlet weak var lblGuestServiceHead: UILabel!{
        didSet{
            lblGuestServiceHead.text = "gservice".localized
        }
    }
    @IBOutlet weak var lblWorkingHour: UILabel!
    @IBOutlet weak var lblTollFree: UILabel!{
        didSet{
            lblTollFree.text = "tollFree".localized
        }
    }
    @IBOutlet weak var lblWorkingHour2: UILabel!
    @IBOutlet weak var lblWorkingDay2: UILabel!{
        didSet{
            lblWorkingDay2.text = "weekDays".localized
        }
    }
    @IBOutlet weak var lblWorkingDay: UILabel!{
        didSet{
            lblWorkingDay.text = "regularDays".localized
        }
    }
    @IBOutlet weak var lblWorkingHours: UILabel!{
        didSet{
            lblWorkingHours.text = "working_hrs".localized
        }
    }
    @IBOutlet weak var lblDubaiMall: UILabel!{
        didSet{
            lblDubaiMall.text = "mallInfo".localized
        }
    }
    
    
    
    
    @IBOutlet weak var lblViewMap: UILabel!{
        didSet{
            lblViewMap.text = "map".localized
            lblViewMap.underline()
            
        }
    }
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var height: CGFloat = 650
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - BottomPopup overridden methods
    override func getPopupHeight() -> CGFloat {
        return height
    }
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tollFreeNoCallAction(_ sender: Any) {
        print("Call to Toll free")
        makePhoneCall(phoneNumber: phoneNumberLabel.text!)
    }
    @IBAction func viewMapSelector(_ sender: UIButton) {
                let urlString = "https://maps.google.com/?q=25.191832566,55.27416557"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
    }
    
    func makePhoneCall(phoneNumber: String) {
        let url:NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
//            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
//                UIApplication.shared.openURL(phoneURL as URL)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
}
