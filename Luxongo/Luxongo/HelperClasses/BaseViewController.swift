//
//  BaseViewController.swift
//  Luxongo
//
//  Created by admin on 6/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        //WebRequester.shared.cancelAllReuest()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func pushViewController(_ viewController: UIViewController, animated: Bool){
        sharedAppdelegate.stopLoader()
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
 
    @discardableResult
    func popViewController(animated: Bool) -> UIViewController?{
        sharedAppdelegate.stopLoader()
        return self.navigationController?.popViewController(animated: animated)
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool) -> [UIViewController]?{
        sharedAppdelegate.stopLoader()
        return self.navigationController?.popToRootViewController(animated: animated)
    }

    func popToViewController<T:UIViewController>(type: T.Type, animated: Bool){
        for vc in self.navigationController?.viewControllers ?? []{
            print("\(vc) ==? \(T.self)")
            if vc is T{
                sharedAppdelegate.stopLoader()
                self.navigationController?.popToViewController(vc, animated: animated);break
            }
        }
    }
    
    func popToHomeViewController(animated: Bool){
        popToViewController(type: MainHomeVC.self, animated: animated)
    }
    
}

extension BaseViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
