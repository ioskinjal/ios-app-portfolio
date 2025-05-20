//
//  PaypalPreferencesVC.swift
//  XPhorm
//
//  Created by admin on 6/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PaypalPreferencesVC: BaseViewController {
    
    static var storyboardInstance:PaypalPreferencesVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: PaypalPreferencesVC.identifier) as? PaypalPreferencesVC
    }
    
    @IBOutlet weak var btnSave: SignInButton!
    @IBOutlet weak var txtPaypalEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Paypal Preferences".localized, action: #selector(onClickBack(_:)))
        
        callgetPapalEmail()
    }
    
    func callgetPapalEmail(){
        let param = ["action":"getPaypalPreference",
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.setting(vc: self, param: param) { (dic) in
            let dict:[String:Any] = dic["data"] as! [String : Any]
            self.txtPaypalEmail.text = dict["paypalId"] as? String
        }
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtPaypalEmail.placeholder = "Paypal Email".localized
        
        btnSave.setTitle("Save".localized, for: .normal)
        
    }
    @IBAction func onClicksave(_ sender: SignInButton) {
        if txtPaypalEmail.text!.isEmpty{
            self.alert(title: "", message: "please enter paypal email".localized)
        }else if !txtPaypalEmail.text!.isValidEmailId{
            self.alert(title: "", message: "please enter valid paypal email".localized)
        }else{
            callAddPapalPreference()
        }
    }
    
    func callAddPapalPreference(){
        let param = ["action":"updatePaypalId",
                     "userId":UserData.shared.getUser()!.id,
                     "email":txtPaypalEmail.text!,
                     "lId":UserData.shared.getLanguage]
        Modal.shared.setting(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
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
