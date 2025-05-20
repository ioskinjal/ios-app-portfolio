//
//  RedeemHistoryVC.swift
//  BooknRide
//
//  Created by KASP on 22/02/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class RedeemHistoryVC: BaseVC {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyTablview: UITableView!{
        didSet{
            historyTablview.dataSource = self as? UITableViewDataSource
            historyTablview.delegate = self
        }
    }
    public let historyCellIdentifier  = "redeemCell"

    var historyList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((historyTablview) != nil) {
            let nib = UINib(nibName: "RedeemHistoryCell", bundle: nil)
            historyTablview.register(nib, forCellReuseIdentifier: historyCellIdentifier)
            
            historyTablview.separatorStyle = UITableViewCellSeparatorStyle.none
            historyTablview.rowHeight  = UITableViewAutomaticDimension
            historyTablview.estimatedRowHeight = 150
            
        }
        
        getRedeemHistory(lastCount: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func getRedeemHistory(lastCount:Int){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
        
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "lastCount":lastCount,
                "totalRecords":20,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.redeemHistory, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print("Items \(dataAns)")
                    
                    let histories = RedeemHistory.initWithResponse(array: (dataAns as! [Any]))
                    
                    if lastCount>0{
                        self.historyList.addObjects(from: histories)
                    }
                    else{
                        self.historyList = (histories as NSArray).mutableCopy() as! NSMutableArray
                    }
                    
                    DispatchQueue.main.async {
                        self.historyTablview.reloadData()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        if lastCount == 0 {
                            alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
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

    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
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

extension RedeemHistoryVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: historyCellIdentifier, for: indexPath) as? RedeemHistoryCell  else {
            
            fatalError("Redeem History Cell Deque")
        }
        
     
        let currentHistory = self.historyList.object(at: indexPath.row) as! RedeemHistory
        cell.displayHistory(history: currentHistory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.historyList.count - 1){
            
            self.getRedeemHistory(lastCount: self.historyList.count)
      
        }
    }
}
