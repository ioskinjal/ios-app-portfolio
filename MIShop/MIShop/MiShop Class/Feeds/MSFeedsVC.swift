//
//  MSFeedsVC.swift
//  MIShop
//
//  Created by nct48 on 20/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSFeedsVC: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Feeds", action: #selector(btnSideMenuOpen))
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


extension MSFeedsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MSFeedsCC", for: indexPath as IndexPath) as! MSFeedsCC
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10
        let itemWidth = (collectionView.bounds.width - 15.0) / 2.0
        return CGSize(width: itemWidth, height: itemWidth + (itemWidth/2))
    }
}
