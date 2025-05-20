//
//  MyProfileVC.swift
//  MIShop
//
//  Created by NCrypted on 17/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MyProfileVC: BaseViewController {

    @IBOutlet weak var constCollectioViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCountFollowings: UILabel!
    @IBOutlet weak var lblCountFolloweres: UILabel!
    @IBOutlet weak var lblCountListing: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUSerProfile: UIImageView!
    @IBOutlet weak var imgTimeLine: UIImageView!
    @IBOutlet weak var productCollectionView: UICollectionView!{
        didSet{
            productCollectionView.delegate = self
            productCollectionView.dataSource = self
            productCollectionView.register(ProductCollectionCell.nib, forCellWithReuseIdentifier: ProductCollectionCell.identifier)
        }
    }
    var productList = [MyShop.Products]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, navigationTitle: "Profile", action: #selector(btnSideMenuOpen))
        imgUSerProfile.setRadius()
        imgUSerProfile.clipsToBounds = true
        callgetMyShopAPI()
    }

    func callgetMyShopAPI() {
    let param = [
    "user_id":UserData.shared.getUser()!.uId
    ]
        ModelClass.shared.getMyShop(vc: self, param: param) { (dic) in
            let data = MyShop(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.lblEmail.text = data.email
            self.lblLocation.text = data.location
            self.lblCountListing.text = String(format: "%d", data.listing)
            self.lblCountFolloweres.text = String(format: "%d", data.followers)
            self.lblCountFollowings.text = String(format: "%d", data.following)
            self.lblUserName.text = data.username
            self.imgTimeLine.downLoadImage(url: data.bannerImg)
            self.imgUSerProfile.downLoadImage(url: data.profileImg)
            self.productList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .products).map({MyShop.Products(dic: $0 as! [String:Any])})
            if self.productList.count != 0{
                self.productCollectionView.reloadData()
                self.setAutoHeight()
            }
        }
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.constCollectioViewHeight.constant = self.productCollectionView.contentSize.height
            self.productCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
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
    
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickEdit(_ sender: Any) {
        let nextVC = EditProfileVC.instantiate(appStorybord: .MyProfile)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickListing(_ sender: Any) {
    }
    @IBAction func onClickFollowers(_ sender: Any) {
    }
    
    @IBAction func onClickFollowings(_ sender: Any) {
    }
    
    @IBAction func onClickViewAll(_ sender: Any) {
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
extension MyProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.identifier, for: indexPath) as? ProductCollectionCell else {
            fatalError("Cell can't be dequeue")
        }
       cell.imgProduct.downLoadImage(url: productList[indexPath.row].productimg)
       cell.lblProductName.text = productList[indexPath.row].productName
       cell.lblAmount.text = productList[indexPath.row].amount
        cell.btnEdit.layer.borderColor = colors.DarkBlue.color.cgColor
        if productList[indexPath.row].isSold == "r" {
            cell.lblResereved.isHidden = false
            cell.imgReserved.isHidden = false
        }else{
            cell.lblResereved.isHidden = true
            cell.imgReserved.isHidden = true
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onClickedit(_:)), for: .touchUpInside)
        return cell
    }
    
     @objc func onClickedit(_ sender:UIButton) {
        let nextVC = AddProductVC.instantiate(appStorybord: .Products)
        nextVC.selectedProductID = productList[sender.tag].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onClickDelete(_ sender:UIButton) {
        self.alert(title: "Alert", message: "Are you sure you want to delete this product?", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                let param = [
                    "user_id":UserData.shared.getUser()!.uId,
                    "prodId":self.productList[sender.tag].id
                ]
                ModelClass.shared.deleteProduct(vc: self, param: param) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.callgetMyShopAPI()
                    })
                }
            }
            else {
                //Do nothing
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = ProductDetailVC.instantiate(appStorybord: .Products)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 20 ), height: 280)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
