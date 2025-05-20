//
//  PartiesListVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class PartiesListVC: BaseViewController,UIActionSheetDelegate {

    @IBOutlet weak var collectionViewParties: UICollectionView!{
        didSet{
            collectionViewParties.delegate = self
            collectionViewParties.dataSource = self
            collectionViewParties.register(PartiesListCell.nib, forCellWithReuseIdentifier: PartiesListCell.identifier)
        }
    }
    
    var currentPartyList = [PartyList]()
    var upcomingPartyList = [PartyList]()
    var pastPartyList = [PartyList]()
    var strParty : String = "current"
    override func viewDidLoad() {
        super.viewDidLoad()
         self.callgetOngoingPartyList()
        setUpNavigation(vc: self, navigationTitle: "Parties", action: #selector(btnSideMenuOpen))
       
       
    }

    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickFilter(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Filter", message: "", preferredStyle: .actionSheet)
        
        let UpcomingButton = UIAlertAction(title: "Upcoming Parties", style: .default, handler: { (action) -> Void in
            self.strParty = "upcoming"
            self.callgetUpcomingPartyList()
        })
        
        let  OngoingButton = UIAlertAction(title: "Ongoing Parties", style: .default, handler: { (action) -> Void in
            self.strParty = "current"
            self.callgetOngoingPartyList()
        })
        
        let PastButton = UIAlertAction(title: "Past Parties", style: .default, handler: { (action) -> Void in
            self.strParty = "past"
            self.callgetPastPartyList()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(UpcomingButton)
        alertController.addAction(OngoingButton)
        alertController.addAction(PastButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    func callgetUpcomingPartyList() {
        ModelClass.shared.getUpcominParty(vc: self) { (dic) in
           self.upcomingPartyList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({PartyList(dic: $0 as! [String:Any])})
            if self.upcomingPartyList.count != 0{
                self.collectionViewParties.reloadData()
            }
            
        }
    }
    
    func callgetOngoingPartyList() {
        ModelClass.shared.getCurrentParty(vc: self) { (dic) in
             self.currentPartyList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({PartyList(dic: $0 as! [String:Any])})
            if self.currentPartyList.count != 0{
                self.collectionViewParties.reloadData()
            }
        }
    }
    
    func callgetPastPartyList() {
        ModelClass.shared.getPastParty(vc: self) { (dic) in
             self.pastPartyList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({PartyList(dic: $0 as! [String:Any])})
            if self.pastPartyList.count != 0{
                self.collectionViewParties.reloadData()
            }
        }
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
extension PartiesListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          if strParty == "upcoming"{
            return upcomingPartyList.count
        }else if strParty == "current"{
            return currentPartyList.count
          }else{
            return pastPartyList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartiesListCell.identifier, for: indexPath) as? PartiesListCell else {
            fatalError("Cell can't be dequeue")
        }
        if strParty == "upcoming"{
        cell.imgParty.downLoadImage(url: upcomingPartyList[indexPath.row].img)
        cell.lblPartyName.text = upcomingPartyList[indexPath.row].partyName
        cell.lblDate.text = upcomingPartyList[indexPath.row].partyDate
        cell.lblHost.text = upcomingPartyList[indexPath.row].userName
        }else if strParty == "current"{
            cell.imgParty.downLoadImage(url: currentPartyList[indexPath.row].img)
            cell.lblPartyName.text = currentPartyList[indexPath.row].partyName
            cell.lblDate.text = currentPartyList[indexPath.row].partyDate
            cell.lblHost.text = currentPartyList[indexPath.row].userName
        }else{
            cell.imgParty.downLoadImage(url: pastPartyList[indexPath.row].img)
            cell.lblPartyName.text = pastPartyList[indexPath.row].partyName
            cell.lblDate.text = pastPartyList[indexPath.row].partyDate
            cell.lblHost.text = pastPartyList[indexPath.row].userName
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = PartyDetailVC.instantiate(appStorybord: .Parties)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 15 ), height: 248)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
