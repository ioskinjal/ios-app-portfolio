//
//  SearchCollectionTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 26/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
protocol SearchCollectionTableViewCellDelegate: class {
    func reloadDataWithPaging()
    func loadPDPPageForCatId(product:Dictionary<String, Any> ,atIndex:IndexPath ,cell :SearchCollectionTableViewCell)
    func tableScrollDirection(direction:String)
}
class SearchCollectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var _heightConstant: NSLayoutConstraint!
    var totalCount = ""
    var totalResultsFound : Int64 = 0
    var parentControllerSearch : UIViewController!
    weak var delegates: SearchCollectionTableViewCellDelegate?
    
    var searchWorkModel = SearchWordKlevuRootClass.init()
    var searchCollection = [SearchWordKlevuResult]()
    var lastContentOffset: CGFloat = 0
    var previousScrollingDirection = ""
    var upCount = 0
    var downCount = 0
    var stillCount = 0
    
    @IBOutlet weak var _lblSearchResult: UILabel!{
        didSet{
            _lblSearchResult.text = validationMessage.searchResult.localized
            _lblSearchResult.lineBreakMode = .byWordWrapping
            _lblSearchResult.numberOfLines = 0
            _lblSearchResult.textColor = UIColor.white
            let textString = NSMutableAttributedString(string: _lblSearchResult.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 20)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.35
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblSearchResult.attributedText = textString
            _lblSearchResult.sizeToFit()
        }
    }
    
    @IBOutlet weak var lblSearchResults: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSearchResults.font = UIFont(name: "Cairo-SemiBold", size: lblSearchResults.font.pointSize)
            }
            lblSearchResults.text = "searchResult".localized
        }
    }
    @IBOutlet weak var _iblToTotalResult: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _iblToTotalResult.font = UIFont(name: "Cairo-Light", size: _iblToTotalResult.font.pointSize)
            }
        }
    }
    
    let margin: CGFloat = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initCollectionView()
        if totalCount == "1"{
            self._iblToTotalResult.text =  totalCount + " " + "product"
        }else {
            self._iblToTotalResult.text =  totalCount + " " + "products"
        }
    }
    
    func collectionReloadData(){
        DispatchQueue.main.async(execute: {
            self.collectionViews?.reloadData()
        })
    }
    private  func initCollectionView() {
        let cells = [SearchCollectionViewCell.className ,newViewAllCell.className ]
        collectionViews.registerCollection(cells)
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            return []
        }
    }
}

extension SearchCollectionTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            
            if upCount == 0 {
                print("move up")
                upCount = 1
                downCount = 0
                stillCount = 0
                delegates?.tableScrollDirection(direction: "movingUp")
            }
            
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            
            if downCount == 0 {
                print("move down")
                downCount = 1
                upCount = 0
                stillCount = 0
                delegates?.tableScrollDirection(direction: "movingDown")
            }
        } else {
            // didn't move
            
            if stillCount == 0 {
                print("don't move")
                stillCount = 1
                upCount = 0
                downCount = 0
                delegates?.tableScrollDirection(direction: "still")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSearchWord.count > 0 {
            return arrSearchWord.count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == arrSearchWord.count  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newViewAllCell", for: indexPath) as? newViewAllCell else {
                fatalError("can't dequeue CustomCell")
            }
//            MBProgressHUD.hide(for: cell, animated: true)
//            if totalResultsFound != arrSearchWord.count {
//                MBProgressHUD.showAdded(to: cell, animated: true)
//            } else {
//                MBProgressHUD.hide(for: cell, animated: true)
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
//            }
            if UserDefaults.standard.value(forKey:string.language) as? String ?? "en" == "en" {
                Common.sharedInstance.backtoOriginalImage(aimg: cell.imgArrow)
            }
            else {
                Common.sharedInstance.rotateImage(aimg: cell.imgArrow)
            }
            
            cell.backgroundView?.isHidden = true
            
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            fatalError("can't dequeue SearchCollectionViewCell")
        }

        cell.lblOldPrice.isHidden = false
       // print("================================================================")
       //print("arr val at index =\(indexPath.row) = \(arrSearchWord[indexPath.row])")
        var lblTitleStr = ""
        if let manufacturer = arrSearchWord[indexPath.row]["manufacturer"] as? String {
            lblTitleStr = manufacturer
        }
        else{
            lblTitleStr = ""
        }
        var lblSubTitleStr = ""
        if let nameStr = arrSearchWord[indexPath.row]["name"] as? String {
            lblSubTitleStr = nameStr
        }
        else{
            lblSubTitleStr = ""
        }
        
        if UserDefaults.standard.value(forKey:string.language) as? String ?? "en" != "en" {
            cell._lblTitle.font = UIFont(name: "Cairo-SemiBold", size: cell._lblTitle.font.pointSize)
            cell._lblSubTitle.font = UIFont(name: "Cairo-Light", size: cell._lblSubTitle.font.pointSize)
        }
        
        cell._lblTitle.text = lblTitleStr.uppercased()
        cell._lblSubTitle.text = lblSubTitleStr.uppercased()
        cell.imageItem.image = nil
        let url = arrSearchWord[indexPath.row]["image"] as? String ?? ""
        //print("original url = \(url)")
        //let cleanFile = url.replacingOccurrences(of: "https://staging-levelshoes-m2.vaimo.com/needtochange", with: "https://www.levelshoes.com")
         let cleanFile = url.replacingOccurrences(of: "/needtochange", with: "")
        //print("image url = \(cleanFile)")
        self.contentView.activityStopAnimating()
        DispatchQueue.global().async {
            cell.imageItem.sd_setImage(with: URL(string: cleanFile), placeholderImage: UIImage(named: "place-holder"))
        }
        
        cell.imageItem.contentMode = .scaleAspectFit
        var startPrice = ""
        var price = ""
        var oldPrice = ""
        var salePrice = ""
        var lblDiscountedPrice = ""
        var storeBaseCurrency = arrSearchWord[indexPath.row]["storeBaseCurrency"] as? String ?? ""
        //#nitikesh
        startPrice = arrSearchWord[indexPath.row]["startPrice"] as? String ?? "0"
        price = arrSearchWord[indexPath.row]["price"] as? String ?? "0"
        oldPrice = arrSearchWord[indexPath.row]["oldPrice"] as? String ?? "0"
        salePrice = arrSearchWord[indexPath.row]["salePrice"] as? String ?? "0"
        
        //print("at index = \(indexPath.row) startprice =\(startPrice) salePrice =\(salePrice) price = \(price)")
        
        let doubleStartPrice = Double(startPrice)!
        let doubleSalePrice = Double(salePrice)!
        let doublePrice = Double(price)!
        
        
        if doubleStartPrice < doublePrice{
            
            cell.lblOldPrice.isHidden = true
            cell._lblPrice.text = "\(startPrice) \(storeBaseCurrency)"
            let oldVal = "\(String(describing: Double(price)!.clean))"
            
            cell.lblOldPrice.attributedText = NSAttributedString.init(string: "\(oldVal)  \(UserDefaults.standard.value(forKey: "currency") as? String ?? getWebsiteCurrency()).localized").string.strikeThrough()
         }
        else{
            cell.lblOldPrice.isHidden = true
            cell._lblPrice.text = "\(String(describing: Double(startPrice)!.clean)) \(storeBaseCurrency)"
        }
        /*
        if salePrice == oldPrice{
            //originalPrice = salePrice
            var price = String(format: "%.2f", Double(originalPrice) ?? 0.0)
            //let finalPrice = String(format: "%.2f", Double(originalPrice) ?? 0.0)
            cell._lblPrice.text =  "\(price)  \(UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? " AED")")"
        } else {
            lblDiscountedPrice = salePrice
            originalPrice = oldPrice
            var price = String(format: "%.2f", Double(lblDiscountedPrice) ?? 0.0)
            cell._lblPrice.text =  "\(price)  \(UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? " AED")")"
        }
 */
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegates?.loadPDPPageForCatId(product: arrSearchWord[indexPath.row] as! Dictionary, atIndex: indexPath, cell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard arrSearchWord.count > 0 else { return }
        if indexPath.item == arrSearchWord.count - 1 {
            print("need to load next products")
//            if(indexPath.row % 8 == 0){
                delegates?.reloadDataWithPaging()
//            }
        }
    }
}

extension SearchCollectionTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2-10, height:213)
        
//        if indexPath.row == arrSearchWord.count  {
//            return CGSize(width: collectionView.frame.size.width, height:100)
//        }
//        else {
//            //return CGSize(width: collectionView.frame.size.width / 2-10, height:305)
//            return CGSize(width: collectionView.frame.size.width / 2-10, height:213)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 30, right:0)
    }
    
}
