//
//  LocationsVC.swift
//  BooknRide
//
//  Created by NCrypted on 09/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

protocol LocationDelegate {
    func didSelectLocation(isHome:Bool)
    func dismissLocation()
}

class LocationsVC: BaseVC {
    
    @IBOutlet weak var homeLocationBtn: UIButton!
    @IBOutlet weak var workLocationBtn: UIButton!
    @IBOutlet weak var lblSelectLocations:UILabel!
    @IBOutlet weak var btnCancel:UIButton!
    
    var delegate :LocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //displayLocations()
        getLocaion(locationType: "home")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblSelectLocations.text = appConts.const.sELECT_LOC
        btnCancel.setTitle(appConts.const.cANCEL, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocaion(locationType:String){
        
        if NetworkManager.isNetworkConneted(){
            startIndicator(title: "")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let params: Parameters = ["userId":appDelegate.currentUser!.uId,"locationType":locationType,"lId":Language.getLanguage().id]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.getLocation, parameters: params, successBlock: { (json, urlResponse) in
                
                
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        let dataAns:NSArray = (jsonDict?.object(forKey: "dataAns") as! NSArray)
                        
                        if dataAns.count > 0 {
                            
                            let locationDict = dataAns.object(at: 0) as! NSDictionary
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let valid = Validator()
                            
                            
                            if locationType == "home"{
                                
                                if valid.isNotNull(object: locationDict["homeLocation"] as AnyObject){
                                    appDelegate.currentUser?.homeLocation = locationDict.object(forKey: "homeLocation") as! String
                                    appDelegate.currentUser?.homeLat = locationDict.object(forKey: "homeLat") as! String
                                    appDelegate.currentUser?.homeLong = locationDict.object(forKey: "homeLong") as! String
                                }
                                else{
                                    appDelegate.currentUser?.homeLocation = ""
                                    appDelegate.currentUser?.homeLat = ""
                                    appDelegate.currentUser?.homeLong = ""
                                }
                                
                                self.getLocaion(locationType: "work")
                                
                            }
                            else{
                                
                                if valid.isNotNull(object: locationDict["workLocation"] as AnyObject){
                                    appDelegate.currentUser?.workLocation = locationDict.object(forKey: "workLocation") as! String
                                    appDelegate.currentUser?.workLat = locationDict.object(forKey: "workLat") as! String
                                    appDelegate.currentUser?.workLong = locationDict.object(forKey: "workLong") as! String
                                }
                                else{
                                    appDelegate.currentUser?.workLocation = ""
                                    appDelegate.currentUser?.workLat = ""
                                    appDelegate.currentUser?.workLong = ""
                                }
                                
                                
                                self.displayLocations()
                            }
                        }
                        
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.stopIndicator()
                        
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    
    func displayLocations(){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let homeLocation:String = (appDelegate.currentUser?.homeLat)!
        let workLocation:String = (appDelegate.currentUser?.workLat)!
        
        if homeLocation.isEmpty{
            
            homeLocationBtn.setTitle(appConts.const.nO_HOME_LOC, for: UIControlState.normal)
            homeLocationBtn.isEnabled = false
        }
        else{
            //homeLocationBtn.setTitle(appDelegate.currentUser?.homeLocation, for: UIControlState.normal)
            homeLocationBtn.setTitle(appConts.const.hOME_LOC, for: UIControlState.normal)
            homeLocationBtn.isEnabled = true
            
        }
        
        if workLocation.isEmpty{
            
            workLocationBtn.setTitle(appConts.const.nO_WORK_LOC, for: UIControlState.normal)
            workLocationBtn.isEnabled = false
        }
        else{
            //            workLocationBtn.setTitle(appDelegate.currentUser?.workLocation, for: UIControlState.normal)
            workLocationBtn.setTitle(appConts.const.wORK_LOC, for: UIControlState.normal)
            
            workLocationBtn.isEnabled = true
            
        }
        self.stopIndicator()
        
        self.view.isHidden = false
    }
    
    @IBAction func btnHomeLocationClicked(_ sender: Any) {
        
        delegate?.didSelectLocation(isHome: true)
    }
    
    @IBAction func btnWorkLoationClicked(_ sender: Any) {
        
        delegate?.didSelectLocation(isHome: false)
    }
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        delegate?.dismissLocation()
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
