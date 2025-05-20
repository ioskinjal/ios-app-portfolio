//
//  BidsVC.swift
//  MIShop
//
//  Created by NCrypted on 16/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class BidsVC: BaseViewController {

    @IBOutlet weak var tblBids: UITableView!{
        didSet{
            tblBids.register(BidsCell.nib, forCellReuseIdentifier: BidsCell.identifier)
            tblBids.dataSource = self
            tblBids.delegate = self
        }
    }
    @IBOutlet weak var lblNoBid: UILabel!
    var bidsList = [bidList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callgetMyBids()
        setUpNavigation(vc: self, navigationTitle: "Bids", action: #selector(btnSideMenuOpen))
       
        // Do any additional setup after loading the view.
    }

    func callgetMyBids(){
        let param = [
            "user_id":UserData.shared.getUser()!.uId
        ]
        ModelClass.shared.getMyBid(vc: self, param: param) { (dic) in
            self.bidsList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .bidlist).map({bidList(dic: $0 as! [String:Any])})
         //   self.bidsList =
           // print(ResponseKey.fatchData(res: dic, valueOf: .data).dic)
          //  self.bidsList = ResponseKey.fatchDataAsArray(res: ResponseKey.fatchData(res: dic, valueOf: .data).dic, valueOf: .bidlist).map({bidList(dic: $0 as! [String:Any])})
            if self.bidsList.count != 0{
                self.tblBids.reloadData()
            }else{
                self.lblNoBid.isHidden = false
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
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
extension BidsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BidsCell.identifier) as? BidsCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.imgUser.downLoadImage(url: bidsList[indexPath.row].productimage)
        cell.lblUserName.text = bidsList[indexPath.row].productName
        cell.lblBidAmount.text = bidsList[indexPath.row].amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bidsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
        
        
    }
    
}
