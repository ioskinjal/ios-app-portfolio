//
//  Login2VC.swift
//  CablePay
//
//  Created by Harry on 10/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class Login2VC: UIViewController {

    static var storyboardInstance:Login2VC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: Login2VC.identifier) as? Login2VC
    }
    
    @IBOutlet weak var viewLinkdin: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        onClickFacebook(button)
    }
    

    @IBAction func onClickFacebook(_ sender: UIButton) {
        self.viewLinkdin.backgroundColor = UIColor.init(hexString: "EAEEE4")
        self.viewFacebook.backgroundColor = UIColor.init(hexString: "D9DED2")
    }
    @IBAction func onClickLinkdin(_ sender: Any) {
        self.viewFacebook.backgroundColor = UIColor.init(hexString: "EAEEE4")
        self.viewLinkdin.backgroundColor = UIColor.init(hexString: "D9DED2")
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
