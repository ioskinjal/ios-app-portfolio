//
//  AboutUsVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 03/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class AboutUsVC: BaseViewController {

    static var storyboardInstance: AboutUsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: AboutUsVC.identifier) as? AboutUsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "About Us", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func onClickMenu(_ sender: UIButton){
            self.navigationController?.popViewController(animated: true)
        
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
