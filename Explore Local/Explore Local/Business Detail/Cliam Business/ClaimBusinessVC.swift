//
//  ClaimBusinessVC.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class ClaimBusinessVC: BaseViewController {

    static var storyboardInstance: ClaimBusinessVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ClaimBusinessVC.identifier) as? ClaimBusinessVC
    }
    var strBus_id:String?
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Claim Business", action: #selector(onClickMenu(_:)))
        
        txtUserName.text = UserData.shared.getUser()?.name
        txtEmailId.text = UserData.shared.getUser()?.email
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickClaimBusiness(_ sender: UIButton) {
        if txtNumber.text == "" {
            self.alert(title: "", message: "please enter contact number")
        }else if txtNumber.text?.length != 10 {
            self.alert(title: "", message: "please enter valid contact number")
        }else{
            callClaimBusiness()
        }
    }
    
    func callClaimBusiness() {
        let param = ["action":"claim",
                     "name":txtUserName.text!,
                     "email":txtEmailId.text!,
                     "number":txtNumber.text!,
                     "business_id":strBus_id!,
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
