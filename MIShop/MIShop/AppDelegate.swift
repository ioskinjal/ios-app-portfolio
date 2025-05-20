//
//  AppDelegate.swift
//  MIShop
//
//  Created by nct48 on 02/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import LGSideMenuController
import IQKeyboardManagerSwift
import FacebookCore
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        let rootViewController = UIStoryboard(name: "Parties", bundle: nil).instantiateViewController(withIdentifier: "AddPartyVC") as! AddPartyVC
        
        let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MSSideNavigationVC") as! MSSideNavigationVC
        
        let rightViewController:UIViewController? = nil
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                      leftViewController: leftViewController,
                                                      rightViewController: rightViewController)
        
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width*0.6;
        sideMenuController.leftViewPresentationStyle = .scaleFromBig;
        sideMenuController.leftViewBackgroundImage = #imageLiteral(resourceName: "ic_sidebar_bg")
      
        
        self.window?.rootViewController = sideMenuController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let loginManager = LoginManager()
        loginManager.logOut()
    }


}
extension AppDelegate {
    // MARK: - Loader
    
    func startLoader(loaderText:String = ""){
        
        let balackView:UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.tag = 420
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let indicator:UIActivityIndicatorView = {
            let iV = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            iV.startAnimating()
            iV.hidesWhenStopped = true
            iV.translatesAutoresizingMaskIntoConstraints = false
            return iV
        }()
        
        let label:UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
            label.textAlignment = .center
            label.textColor = .white
            label.text = loaderText
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let stackView :UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.addArrangedSubview(indicator)
            stack.addArrangedSubview(label)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 8
            return stack
        }()
        
        DispatchQueue.main.async {
            if let window = self.window{
                let view = window.viewWithTag(420)
                if view != nil{
                    self.stoapLoader()
                } else{
                    self.window?.addSubview(balackView)
                    NSLayoutConstraint.activate([
                        balackView.topAnchor.constraint(equalTo: window.topAnchor),
                        balackView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                        balackView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                        balackView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
                        ])
                    balackView.addSubview(stackView)
                    NSLayoutConstraint.activate([
                        stackView.centerXAnchor.constraint(equalTo: balackView.centerXAnchor),
                        stackView.centerYAnchor.constraint(equalTo: balackView.centerYAnchor),
                        stackView.leadingAnchor.constraint(equalTo: balackView.leadingAnchor),
                        stackView.trailingAnchor.constraint(equalTo: balackView.trailingAnchor)
                        ])
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            }
        }
    }
    
    func stoapLoader(){
        DispatchQueue.main.async {
            if let view = self.window?.viewWithTag(420){
                view.removeFromSuperview()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    
}


