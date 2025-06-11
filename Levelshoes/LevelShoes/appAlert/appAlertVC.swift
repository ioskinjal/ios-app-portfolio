//
//  appAlertVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 21/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
class appAlertVC: BottomPopupViewController {
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "appDisable".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.text = "forceUpdate".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDesc.font = UIFont(name: "Cairo-Light", size: lblDesc.font.pointSize)
            }
        }
    }
    @IBOutlet weak var btnNewVersion: UIButton!{
        didSet{
            btnNewVersion.setTitle("getApp".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnNewVersion.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
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
    @IBAction func getNewVersionSelector(_ sender: UIButton) {
        print("Run Code here fot Get New Version ")
        let urlStr = "itms-apps://itunes.apple.com/app/apple-store/id1533573882?mt=8"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
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
