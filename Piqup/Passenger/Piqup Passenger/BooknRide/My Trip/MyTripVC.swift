//
//  MyTripVC.swift
//  Carry
//
//  Created by NCrypted on 21/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class MyTripVC: BaseVC {
    @IBOutlet weak var tblMyTrip: UITableView!{
        didSet{
            let nib = UINib(nibName: "MyTripCell", bundle: nil)
            let addressIdentifier = "MyTripCell"
            tblMyTrip.register(nib, forCellReuseIdentifier: addressIdentifier)
            tblMyTrip.dataSource = self
            tblMyTrip.delegate = self
            tblMyTrip.separatorStyle = .none
        }
    }
    
    var tripList: NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetMyTrips()
    }

    func callGetMyTrips(){
        let alert = Alert()
        
        startIndicator(title: "")
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Trip.getTripList, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                self.tripList.addObjects(from: jsonDict?.value(forKey: "dataAns") as! [Any])
                if self.tripList.count != 0{
                    self.tblMyTrip.reloadData()
                }
                
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MyTripVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressIdentifier = "MyTripCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: addressIdentifier) as? MyTripCell else {
            fatalError("Cell can't be dequeue")
        }
        let dict:NSDictionary = tripList[indexPath.row]as! NSDictionary
       // cell.lblCarName.text = dict.value(forKey: "<#T##String#>")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        reloadMoreData(indexPath: indexPath)
//    }
//
//    func reloadMoreData(indexPath: IndexPath) {
//        if orderList.count - 1 == indexPath.row &&
//            (orderObj!.pagination!.current_page < orderObj!.pagination!.total_pages) {
//            self.callGetMyOrders()
//        }
//    }
    
}

