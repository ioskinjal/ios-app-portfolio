//
//  MyFolowersVC.swift
//  Happenings
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyFolowersVC: BaseViewController {

    @IBOutlet weak var followerCollectionView: UICollectionView!{
        didSet{
            followerCollectionView.delegate = self
            followerCollectionView.dataSource = self
            followerCollectionView.register(MyFollowersCell.nib, forCellWithReuseIdentifier: MyFollowersCell.identifier)
        }
    }
    
    static var storyboardInstance: MyFolowersVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: MyFolowersVC.identifier) as? MyFolowersVC
    }
    
    var follwerList = [myFollowersCls.CustmerList]()
    var followerObj: myFollowersCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

          setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Followers", action: #selector(onClickMenu(_:)), isRightBtn: false)
        
        callMyFollwersAPI()
        
    }
    
    func callMyFollwersAPI(){
        let param = ["user_id":"206",
                     "per_page":10,
                     "page_no":1] as [String : Any]
        
        Modal.shared.myFollowers(vc: self, param: param) { (dic) in
            self.followerObj = myFollowersCls(dictionary: dic)
            if self.follwerList.count > 0{
                self.follwerList += self.followerObj!.following_customers
            }
            else{
                self.follwerList = self.followerObj!.following_customers
            }
            if self.follwerList.count != 0 {
                self.followerCollectionView.reloadData()
            }
        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyFolowersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return follwerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFollowersCell.identifier, for: indexPath) as? MyFollowersCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        var data:myFollowersCls.CustmerList?
        data = follwerList[indexPath.row]
        cell.lblName.text = (data?.customerFirstName)! + " " + (data?.customerLastName)!
        cell.imgFollowers.downLoadImage(url: (data?.customerProfileImg)!)
        return cell
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 200)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    //        return imageSize
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if follwerList.count - 1 == indexPath.row &&
            (followerObj!.currentPage > followerObj!.TotalPages) {
            self.callMyFollwersAPI()
        }
    }
}
