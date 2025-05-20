//
//  MSPurchaseHistoryVC.swift
//  MIShop
//
//  Created by nct48 on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSPurchaseHistoryVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
}
extension MSPurchaseHistoryVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSPurchaseHistoryTC", for: indexPath) as! MSPurchaseHistoryTC
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        //        if ((self.tableViewMyBooking.contentOffset.y + self.tableViewMyBooking.frame.size.height) >= self.tableViewMyBooking.contentSize.height)
        //        {
        //            if !isCompleted
        //            {
        //                isCompleted = true
        //                pageCounter += 1
        //                self.getRequestedRideDetails()
        //            }
        //        }
    }
}
