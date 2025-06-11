//
//  MaintenanceAlertVC.swift
//  LevelShoes
//
//  Created by Pradeep Kumar Sagar on 24/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup

class MaintenanceAlertVC: BottomPopupViewController {

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "appMaintenance".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.text = "maintenaceUpdate".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDesc.font = UIFont(name: "Cairo-Light", size: lblDesc.font.pointSize)
            }
        }
    }

    @IBOutlet weak var btnExitApp: UIButton!{
        didSet{
            btnExitApp.setTitle("exitApp".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                 btnExitApp.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func getPopupHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    @IBAction func exitAppSelector(_ sender: UIButton) {
        print("Run Code here for Exit app")
        exit(-1)
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
