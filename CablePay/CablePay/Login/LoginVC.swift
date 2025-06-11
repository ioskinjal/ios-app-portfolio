//
//  LoginVC.swift
//  CablePay
//
//  Created by Harry on 10/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {

    static var storyboardInstance:LoginVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC
    }
    
    var usrTextField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Login", action: #selector(onClickBack))
        
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickForgot(_ sender: UIButton) {
        forgotPassword()
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        self.navigationController?.pushViewController(BottomBarMenuVC.storyboardInstance!, animated: true)
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
extension LoginVC{

    func sendHandler(alert: UIAlertAction!){
        
    }
    func usrTextField(textField: UITextField!){
        usrTextField = textField
        usrTextField?.placeholder = "Enter EmailId"
    }
    func forgotPassword(){
        let alertController = UIAlertController( title: "Forgot Password", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler:self.usrTextField)
        let okAction = UIAlertAction(title: "Send", style: .default, handler: self.sendHandler)
        let cancle = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancle)
        self.present(alertController, animated: true, completion: nil)
    }
}
