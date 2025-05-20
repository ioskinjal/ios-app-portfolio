//
//  MSMyBalanceViewController.swift
//  MIShop
//
//  Created by nct48 on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSMyBalanceVC: UIViewController
{
    @IBOutlet var viewMainScrollView: UIScrollView!
    @IBOutlet var viewScrollViewBack: UIView!
    @IBOutlet var viewTableViewBack: UIView!
    @IBOutlet var tableViewRedemptionHistory: UITableView!
    @IBOutlet var viewHeightForTableViewConstraint: NSLayoutConstraint!
    @IBOutlet var viewMainCredits: UIView!
    @IBOutlet var viewMainPending: UIView!
    @IBOutlet var viewMainRedeemable: UIView!
    @IBOutlet var lblCreaditsPrice: UILabel!
    @IBOutlet var lblPendingPrice: UILabel!
    @IBOutlet var lblRedeemablePrice: UILabel!
    @IBOutlet var txtAmount: UITextField!
    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var btnSendRequest: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool)
    {
            self.settingMyBalanceView()
    }
    override func viewDidLayoutSubviews()
    {
        viewTableViewBack.layer.borderColor = colors.LightGray.color.cgColor
        viewTableViewBack.layer.borderWidth = 1
        txtDescription.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtAmount.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    
    func settingMyBalanceView()
    {
        reloadTableView()
    }
    func reloadTableView()
    {
        tableViewRedemptionHistory.reloadData()
        //showLosingerLoader(view: self,isFullScreen: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
            self.viewHeightForTableViewConstraint.constant = self.tableViewRedemptionHistory.contentSize.height + 25
        }
    }
    
    @IBAction func btnSendRequestClick(_ sender: Any)
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
extension MSMyBalanceVC: UITextFieldDelegate,UITextViewDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            textField.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        txtDescription.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1)
        {
            self.txtDescription.border(side: .bottom, color: colors.DarkGray.color, borderWidth: 1)
        }
    }
}

extension MSMyBalanceVC: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSRedemptionHistoryTC", for: indexPath) as! MSRedemptionHistoryTC
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSRedemptionHistoryFooterTC") as! MSRedemptionHistoryFooterTC
        return cell
    }
}
