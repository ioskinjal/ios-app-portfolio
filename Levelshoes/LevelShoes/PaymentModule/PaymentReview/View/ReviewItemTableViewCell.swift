//
//  ReviewItemTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 28/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData

class ReviewItemTableViewCell: UITableViewCell {

    var objattrList = [String]()
                   var designDetail = [OptionsList]()
                   var objList = [String]()
                  var designData: [NSManagedObject] = []
    @IBOutlet weak var lblYourItems: UILabel!{
        didSet{
            lblYourItems.text = "yourItems".localized
        }
    }
    @IBOutlet weak var viewSlideIndicator: SlidingIndicator!
    @IBOutlet weak var totalItemLabel: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                totalItemLabel.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var reviewItemCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewItemCollectionView.delegate = self
        reviewItemCollectionView.dataSource = self
        reviewItemCollectionView.register(UINib(nibName: "ReviewItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewItemCollectionViewCell")
        totalItemLabel.text = "\(CartDataModel.cart?.items?.count ?? 0) " +  "items".localized
        viewSlideIndicator.numberOfItems = CartDataModel.cart?.items?.count ?? 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension ReviewItemTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartDataModel.cart?.items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewItemCollectionViewCell", for: indexPath) as! ReviewItemCollectionViewCell
     
            var sourceData = globalProducts[CartDataModel.cart?.items?[indexPath.row].sku ?? ""] as! Hits.Source
            var childData = childrenData[CartDataModel.cart?.items?[indexPath.row].sku ?? ""] as!  [String :Any]
            cell.itemnameLabel.text = CartDataModel.cart?.items?[indexPath.row].name?.uppercased()
            cell.itemImageView.sd_setImage(with: URL(string: CommonUsed.globalUsed.kimageUrl + sourceData.image), placeholderImage: UIImage(named: "imagePlaceHolder"))
            cell.itemImageView.contentMode = .scaleAspectFit
            cell.sizeLabel.text = getSizeValueById(id: sourceData.size)
            cell.irtemTypeLabel.text = getBrandName(id: String(sourceData.manufacturer)).uppercased()
        let ckCurrency = (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
        cell.amountLabel.text = "\(Double(childData["final_price"] as? Double ?? 0.0).clean) \(ckCurrency)"
        let staticQty = "qty".localized
        let staticSize = "basket_size".localized
        cell.sizeLabel.text = "\(staticSize) \(getSizeValueById(id: childData["size"] as! Int) )"  + " / " + "\(staticQty) \(CartDataModel.cart?.items?[indexPath.row].qty ?? 0)"
        
        return cell
    }
    func fetchAttributeeData(){

              if CoreDataManager.sharedManager.fetchAttributeData() != nil{

                  designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
                  print("colorArray", designData.count)
              }
              
              
               for j in 0..<designData.count{
                   let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                   for k in 0..<array.count{
                   
                   designDetail.append(array[k])
                   }
               }
          
              let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
                    designDetail = sorteddesignDetail
              
              let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
              for i in 0..<designDetail.count{
                  for j in arrColorNm{
                      if designDetail[i].label == j{
                          designDetail[i].isSelected = true
                      }
                  }
              }
              
              for i in 0..<designDetail.count{
                  objList.append(designDetail[i].label)
              }
              objattrList = objList
             
          }
          
          func getBrandName(id:String) -> String{
              var strBrand = ""
              for i in 0..<(designDetail.count){
                 if id == "\(designDetail[i].value)"{
                  strBrand = designDetail[i].label
                 }
              }
              return strBrand.uppercased()
          }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 350)
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
     
            var count = 0
            
            let visibleRect = CGRect(origin: reviewItemCollectionView.contentOffset, size: reviewItemCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = reviewItemCollectionView.indexPathForItem(at: visiblePoint) {
                count = visibleIndexPath.row
                viewSlideIndicator.selectedItem = count
                
        }
    }
}

