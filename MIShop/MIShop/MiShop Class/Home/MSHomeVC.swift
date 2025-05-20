//
//  MSHomeVC.swift
//  MIShop
//
//  Created by nct48 on 20/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSHomeVC: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Home", action: #selector(btnSideMenuOpen))
    }
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
extension MSHomeVC: UITableViewDelegate,UITableViewDataSource
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSHomeTC", for: indexPath) as! MSHomeTC
        cell.btnListing.border(side: .all, color: colors.LightGray.color, borderWidth: 1)
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
