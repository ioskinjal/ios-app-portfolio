//
//  Login3VC.swift
//  CablePay
//
//  Created by Harry on 10/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class Login3VC: UIViewController {

    static var storyboardInstance:Login3VC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: Login3VC.identifier) as? Login3VC
    }
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        self.btnLogin.backgroundColor = UIColor.init(hexString: "EAEEE4")
        self.btnRegister.backgroundColor = UIColor.init(hexString: "D9DED2")
        
        self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickRegister(_ sender: UIButton) {
        self.btnRegister.backgroundColor = UIColor.init(hexString: "EAEEE4")
        self.btnLogin.backgroundColor = UIColor.init(hexString: "D9DED2")
        self.navigationController?.pushViewController(RegisterVC.storyboardInstance!, animated: true)
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
