//
//  InfoVC.swift
//  BooknRide
//
//  Created by KASP on 03/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class InfoVC: BaseVC {
    
    let infoCellIdentifier  = "infoCell"
    
    var infoItems:NSMutableArray = []
    
    @IBOutlet weak var infoWebView: UIWebView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var InfoTableView: UITableView!
    
   
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navTitle:UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((InfoTableView) != nil) {
            let nib = UINib(nibName: "InfoCell", bundle: nil)
            InfoTableView.register(nib, forCellReuseIdentifier: infoCellIdentifier)
            InfoTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            InfoTableView.rowHeight  = 50
            InfoTableView.estimatedRowHeight = 50
            
        }
        getCmsList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navTitle.text = appConts.const.lBL_INFO
    }
    
    
    func getCmsList(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userType":"u",
                "lId":Language.getLanguage().id
                
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.WebPages.getcmsList, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print("Items \(dataAns)")
                    
                    self.infoItems = dataAns
                    
                    DispatchQueue.main.async {
                        
                        self.InfoTableView.reloadData()
                    }
                }
                else{
                    DispatchQueue.main.async {
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
    
    
    
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        openMenu()
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

extension InfoVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as? InfoCell
        
        if cell == nil {
            cell = InfoCell(style: UITableViewCellStyle.default, reuseIdentifier: infoCellIdentifier)
        }
        
        let dictObject = self.infoItems[indexPath.row] as! NSDictionary
        
        cell?.lblTitle.text = String(format:"%@",dictObject.object(forKey: "constant") as! CVarArg)
        
        cell?.borderView.applyBorder(color: UIColor.lightGray, width: 1.0)
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictObject = self.infoItems[indexPath.row] as! NSDictionary
        
        let aboutVC = WebVC(nibName: "WebVC", bundle: nil)
        aboutVC.cmsID = String(format:"%@",dictObject.object(forKey: "id") as! CVarArg)
        aboutVC.cmsConstant = String(format:"%@",dictObject.object(forKey: "constant") as! CVarArg)
        self.navigationController?.pushViewController(aboutVC, animated: true)
        
    }
}
