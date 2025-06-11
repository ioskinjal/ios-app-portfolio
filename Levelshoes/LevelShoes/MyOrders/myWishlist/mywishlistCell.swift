//
//  mywishlistCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 11/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol mywishlistCellDelegae : class{
    func removeWishList(cell:mywishlistCell)
    func addToBag(cell:mywishlistCell)
}
class mywishlistCell: UITableViewCell {
    var delegate : mywishlistCellDelegae?
    var myWishList = WishlistModel()
    @IBOutlet weak var wlistImgviewProduct: UIImageView!
    @IBOutlet weak var wlistLblProductname: UILabel!{
        didSet{
            wlistLblProductname.addTextSpacing(spacing: 1.07)
        }
    }
    @IBOutlet weak var wlistLblSubTitle: UILabel!
    @IBOutlet weak var wlistLblPrice: UILabel!
    @IBOutlet weak var selectedModeView: UIView!
    @IBOutlet weak var selectedcellIcon: UIImageView!
    var isSelectedCell :Bool = false
    @IBOutlet weak var btnAddtobag: UIButton!{
        didSet{
            let localizeString = "add_to_bag".localized
            btnAddtobag.underline(localizeString)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnAddtobag.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:20)
            }
            else{
                btnAddtobag.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            }
        }
    }//"Add to bag".localized
    @IBOutlet weak var btnRemove: UIButton!{
        didSet{
            btnRemove.setTitle("Remove".localized, for: .normal)
            btnRemove.underline()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnRemove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:20)
            }
            else{
                btnRemove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            }
        }
    }//"Remove".localized
    @IBOutlet weak var wlistAddtobag: UILabel!{
         didSet {
             let strDont:String = "Add to bag".localized
            
//             wlistAddtobag.attributedText = underlinedString(string: strDont as NSString, term: "Add to bag" as NSString)
         }
     }
     @IBOutlet weak var wlistRemoveBag: UILabel!{
         didSet {
             let strDont:String = "Remove".localized
//             wlistRemoveBag.attributedText = underlinedString(string: strDont as NSString, term: "Remove" as NSString)
         }
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func underlinedString(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: string as String)
        let underlineRange = string.range(of: term as String)
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)

        return output
    }
    @IBAction func btnSelectCell(_ sender: UIButton) {
           print("Remove from bag")
        isSelectedCell = !isSelectedCell
        if isSelectedCell {
           self.selectedcellIcon.setImage(#imageLiteral(resourceName: "blackMark"))
        }else{
           // let image = UIImage(named: "")
            self.selectedcellIcon.image = nil
        }
    }
    @IBAction func btnAddtoBagSelector(_ sender: UIButton) {
           print("ADD TO BAG ")
        self.delegate?.addToBag(cell: self)
       }
       @IBAction func btnRemoveSelector(_ sender: UIButton) {
           print("Remove from bag")
        self.delegate?.removeWishList(cell: self)
       }
}
