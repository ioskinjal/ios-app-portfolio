//
//  Login4VC.swift
//  CablePay
//
//  Created by Harry on 10/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class Login4VC: UIViewController {

    static var storyboardInstance:Login4VC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: Login4VC.identifier) as? Login4VC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
