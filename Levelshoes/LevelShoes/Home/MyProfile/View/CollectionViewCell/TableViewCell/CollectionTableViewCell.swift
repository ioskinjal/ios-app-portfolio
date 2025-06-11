//
//  CollectionTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol CollectionTableViewCellDelegate: class {
    func loadPDPPageWithKvuId(kvu:String)
    func goToHomeScreen()
    func goWishListView()
}
class CollectionTableViewCell: UITableViewCell {

    var delegate: CollectionTableViewCellDelegate?
     var myWishList = [WishlistModel]()



    @IBOutlet weak var lblWishlistHeader: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblWishlistHeader.font = UIFont(name: "Cairo-SemiBold", size: lblWishlistHeader.font.pointSize)
            }
            lblWishlistHeader.text = "accountWishlist".localized
        }
    }

    @IBOutlet weak var lblWishlistEmpty: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblWishlistEmpty.font = UIFont(name: "Cairo-SemiBold", size: lblWishlistEmpty.font.pointSize)
            }
            lblWishlistEmpty.text = "emptyWishlist".localized
            lblWishlistEmpty.addTextSpacing(spacing: 1.0)
        }
    }
    @IBOutlet weak var lblGetInspired: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblGetInspired.font = UIFont(name: "Cairo-Regular", size: lblGetInspired.font.pointSize)
            }
            lblGetInspired.text = "getInspired".localized
            lblGetInspired.addTextSpacing(spacing: 1.5)
            lblGetInspired.underline()
        }
    }
    @IBOutlet weak var lblMsg: UILabel!{
        didSet{
            
            // create an NSMutableAttributedString that we'll append everything to
            let str1 = "thanyouThink".localized
            let fullString = NSMutableAttributedString(string: str1)

            // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named:"Default")
            image1Attachment.bounds = CGRect(x: 0, y:-5, width: 18, height: 18)
            // wrap the attachment in its own attributed string so we can append it
            let image1String = NSAttributedString(attachment: image1Attachment)

            // add the NSTextAttachment wrapper to our full string, then add some more text.
            fullString.append(image1String)
            let Str2 = "startSaving".localized
            fullString.append(NSAttributedString(string:Str2))

            // draw the result in a label
            lblMsg.attributedText = fullString
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMsg.font = UIFont(name: "Cairo-Light", size: lblMsg.font.pointSize)
            }
            //lblMsg.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var btnNext: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnNext)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnNext)
            }
        }
    }
    @IBOutlet weak var viewEmptyMsg: UIView!
        static let cellidentifier = wishlistCollectionCell.name
//    static let nib = UINib(nibName: InformationHelpTableCell.name, bundle: nil)
    @IBOutlet weak var cellCollectionViews: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cells = [wishlistCollectionCell.className,newViewAllCell.className]
        self.cellCollectionViews.registerCollection(cells)
        self.cellCollectionViews.dataSource = self
        self.cellCollectionViews.delegate = self
        // Initialization code
        
        let nib = UINib(nibName: "MyAccViewAllCell", bundle: nil)
        self.cellCollectionViews.register(nib, forCellWithReuseIdentifier: "MyAccViewAllCell")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateWishListView(){
        DispatchQueue.main.async {
           
              
            if self.myWishList.count > 0{
                 self.viewEmptyMsg.isHidden = true
                 self.cellCollectionViews.reloadData()
            }else{
                self.viewEmptyMsg.isHidden = false
            }
           
           }
    }
    @IBAction func btnGetInspired(_ sender: Any) {
        self.delegate?.goToHomeScreen()
       
       }
   
}
//api call for get wishList

extension CollectionTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.myWishList.count > 0 && self.myWishList.count < 6{
             return  self.myWishList.count
        }else if  self.myWishList.count > 5{
             return  6
        }
        else{
             return 0
        }
       // return 1
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.myWishList.count > 5 && indexPath.row == 5 {
            print("Inside NEW VIEW ALL")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAccViewAllCell", for: indexPath) as? MyAccViewAllCell else {
                fatalError("can't dequeue CustomCell")
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: cell.imgArrow)
            }
            else{
                Common.sharedInstance.rotateImage(aimg: cell.imgArrow)
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistCollectionCell", for: indexPath) as? wishlistCollectionCell else {
            fatalError("can't dequeue CustomCell")
        }
        let wishListItem = self.myWishList[indexPath.row]
        cell.wishlistImageItem.sd_setImage(with: URL(string: CommonUsed.globalUsed.kimageUrl + wishListItem.product.image  ), placeholderImage: UIImage(named: "place-holder"))
        cell._lblTitle.text =  wishListItem.product.name.uppercased()
        cell._lblSubTitle.text = wishListItem.manufacturer.uppercased()
        let price = (Double(wishListItem.product.min_price)  ?? 0).clean
        if(wishListItem.product.min_price == 0.0 || wishListItem.product.min_price == nil){
            cell._lblPrice.text =  ""
        }
        else{
            cell._lblPrice.text =  "\(price)  \(UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")"
        }
       
       
        
        print("Prining ---- \(wishListItem.product.price)")

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.myWishList.count > 5 && indexPath.row == 5 {
            self.delegate?.goWishListView()
        }else{
            var wishListItem = self.myWishList[indexPath.row]
            self.delegate?.loadPDPPageWithKvuId(kvu:  wishListItem.product.primaryvpn as! String)
        }
    }
   
}
