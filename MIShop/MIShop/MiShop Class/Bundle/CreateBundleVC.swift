//
//  CreateBundleVC.swift
//  MIShop
//
//  Created by NCrypted on 18/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class CreateBundleVC: BaseViewController {

    @IBOutlet weak var txtActualPrice: UITextField!
    @IBOutlet weak var txtProductDesc: UITextView!{
        didSet{
            txtProductDesc.placeholder = "Description"
        }
    }
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtDiscountPrice: UITextField!
    @IBOutlet weak var txtCalculatedPrice: UITextField!
    @IBOutlet weak var collectionViewBundleImages: UICollectionView!{
        didSet{
            collectionViewBundleImages.delegate = self
            collectionViewBundleImages.dataSource = self
            collectionViewBundleImages.register(BundleImageCell.nib, forCellWithReuseIdentifier: BundleImageCell.identifier)
        }
    }
    override func viewDidLayoutSubviews()
    {
        txtProductName.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtActualPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtDiscountPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtCalculatedPrice.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
        txtProductDesc.border(side: .bottom, color: colors.LightGray.color, borderWidth: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Create Bundle", action: #selector(btnSideMenuOpen))
       
        txtProductDesc.text = "Description"
        txtProductDesc.textColor = UIColor.lightGray
    }

    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickSubmit(_ sender: Any) {
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

extension CreateBundleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BundleImageCell.identifier, for: indexPath) as? BundleImageCell else {
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
        return CGSize(width: 80, height:80)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
