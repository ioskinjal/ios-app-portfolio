//
//  SubCategoryListVC.swift
//  Explore Local
//
//  Created by NCrypted on 14/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class SubCategoryListVC: BaseViewController {
    
    static var storyboardInstance:SubCategoryListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SubCategoryListVC.identifier) as? SubCategoryListVC
    }
   
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var collectionViewSubCategory: UICollectionView!{
        didSet{
            collectionViewSubCategory.delegate = self
            collectionViewSubCategory.dataSource = self
            collectionViewSubCategory.register(SubCategoryCell.nib, forCellWithReuseIdentifier: SubCategoryCell.identifier)
        }
    }
    
     var strCatID:String?
     var subCategoryList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Sub Category", action: #selector(onClickMenu(_:)), isRightBtn: false)
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        callGetSubCategory()
       // self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func callGetSubCategory() {
       
            let param = ["action":"subcategory",
                         "category_id":strCatID!]
        Modal.shared.home(vc: self, param: param) { (dic) in
            print(dic)
            
            self.subCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .subcategory) as [AnyObject]
            if self.subCategoryList.count != 0{
                self.collectionViewSubCategory.reloadData()
            }else{
                self.lblNoData.isHidden = false
            }
            
        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
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
extension SubCategoryListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as? SubCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        var dict = NSDictionary()
        dict = subCategoryList[indexPath.row] as! NSDictionary
        cell.imgView.downLoadImage(url: dict.value(forKey: "image") as! String)
        cell.lblName.text = dict.value(forKey: "name")as? String
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = PostedBuisnessVC.storyboardInstance!
        var dict = NSDictionary()
        dict = subCategoryList[indexPath.row] as! NSDictionary
        isFromSubCat = true
        nextVC.strCatSubId = (dict.value(forKey: "id")as? String)!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2-5, height:collectionView.frame.size.width / 2-5)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    }
    
    
}
//extension SubCategoryListVC:UIGestureRecognizerDelegate{
//    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
