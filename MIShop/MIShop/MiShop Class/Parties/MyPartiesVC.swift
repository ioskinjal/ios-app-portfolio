//
//  MyPartiesVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MyPartiesVC: BaseViewController {

    @IBOutlet weak var collectionViewParties: UICollectionView!{
        didSet{
            collectionViewParties.delegate = self
            collectionViewParties.dataSource = self
            collectionViewParties.register(MyPartyCell.nib, forCellWithReuseIdentifier: MyPartyCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "My Party", action: #selector(btnSideMenuOpen))
    }

    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
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
extension MyPartiesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPartyCell.identifier, for: indexPath) as? MyPartyCell else {
            fatalError("Cell can't be dequeue")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = PartyDetailVC.instantiate(appStorybord: .Parties)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height:288)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
