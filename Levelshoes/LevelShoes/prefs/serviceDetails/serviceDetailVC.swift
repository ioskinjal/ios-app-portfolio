//
//  serviceDetailVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 31/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class serviceDetailVC: UIViewController {
     var dataDic = [String:Any]()
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            
        }
    }
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDesc.font = UIFont(name: "Cairo-Light", size: lblDesc.font.pointSize)
            }
            lblDesc.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var btnMoreinfo: UIButton!{
        didSet{
            btnMoreinfo.addTextSpacingButton(spacing: 1.5)
        }
    }
    @IBOutlet weak var header: headerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHeaderAction()
    }
    override func viewWillAppear(_ animated: Bool) {
         self.serviceImage.sd_setImage(with: URL(string:"\(dataDic["image"] ?? "")"), placeholderImage: UIImage(named: "imagePlaceHolder"))
              self.lblTitle.text = "\(dataDic["subject"] ?? "")"
              self.lblDesc.text = "\(dataDic["description"] ?? "")"
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.headerTitle.text = "aacountService".localized.uppercased()
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        self.navigationController?.popViewController(animated: true)
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
