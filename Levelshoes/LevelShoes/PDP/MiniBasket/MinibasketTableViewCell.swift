//
//  MinibasketTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 15/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol MiniBasketProtocol {
    func changeSizeAction(Index: Int)
    func previousAction(_ cell:MinibasketTableViewCell)
    func nextAction(_ cell:MinibasketTableViewCell)
}

class MinibasketTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var qtyPlaceholderLabel: UILabel!{
        didSet{
            qtyPlaceholderLabel.text = "basket_qty".localized
        }
    }
    @IBOutlet weak var sizePlaceholderLabel: UILabel!{
        didSet{
            sizePlaceholderLabel.text = "basket_size".localized
        }
    }
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var regularAmountLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var imgPrev: UIImageView!
    @IBOutlet weak var imgNext: UIImageView!

    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTag: InsetLabel!{
        didSet{
            lblTag.addTextSpacing(spacing: 1)
        }
    }
    @IBOutlet weak var lblTag2: InsetLabel!{
        didSet{
            lblTag2.addTextSpacing(spacing: 1)
        }
    }
    
    var delegate: MiniBasketProtocol?
    var rowNumber: Int?
    var qtyValue: Int?
    var isState: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headingLabel.addTextSpacing(spacing: 1.07)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func setCartValue(_ cartData:[String:Any]){
        
        print("Cart DATA IS- \(cartData)")
        
        
        regularAmountLabel.isHidden = true
        guard let data:[String:Any] = cartData else{
            return
        }
        lblTag.text = " Narayan "
        lblTag2.text = " Narayan "
        mainImageView.sd_setImage(with: URL(string: data["imageURL"] as! String), completed: nil)
        mainImageView.contentMode = .scaleAspectFit
      //  let heading = data["categoryName"] as! String
      //  headingLabel.text = heading.uppercased()
        let subHeading =  data["name"] as! String
        subHeadingLabel.text = subHeading.uppercased()
        let finalPrice = Double("\(data["finalPrice"]!)") ?? 0.0
        let finalPriceInt = Double(finalPrice ?? 0).clean
        amountLabel.text = "\(finalPriceInt) " +  (UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized
       // amountLabel.text = String(format:"%.0f",finalPrice) + " " + (UserDefaults.standard.value(forKey: string.currency) as? String ?? "AED")!
        var price : Double = Double("\(data["finalPrice"]!)") ?? 0.0
        var regularPrice : Double = Double("\(data["regularPrice"]!)") ?? 0.0
        
        
        if regularPrice > price {
           regularAmountLabel.isHidden = false
            amountLabel.textColor = UIColor.red
        }
        //regularAmountLabel.text = String(format:"%.2f",regularPrice) + " " + (UserDefaults.standard.value(forKey: string.currency) as? String ?? "AED")!
        let fomatedPrice = Double(regularPrice ?? 0).clean
       // let fomatedPrice =  String(format:"%.0f",regularPrice)
        regularAmountLabel.attributedText = NSAttributedString.init(string: "\(fomatedPrice)  \((UserDefaults.standard.string(forKey: "currency") ?? getWebsiteCurrency()).localized)").string.strikeThrough()
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            regularAmountLabel.textAlignment = .left
        }
        else{
            regularAmountLabel.textAlignment = .right
        }
        qtyLabel.text = String(format:"%.2f",data["qty"] as! CVarArg)
        sizeLabel.text = getSizeValueById(id: Int(data["selectedSize"]! as! String) ?? 0) as! String
        
    }
    
    func cellConfiguration(cellno: Int, size: String, qty: Int, isCurrentState: Bool){
        rowNumber = cellno
        isState = isCurrentState
        sizeLabel.text = getSizeValueById(id: Int(size) ?? 0)
        qtyValue = qty
        if isState == true{
             qtyLabel.text = "\(qtyValue ?? 0)"
        }else{
             qtyLabel.text = "\(qtyValue ?? 0)"
        }
        
    }
    @IBAction func sizeBtnAction(_ sender: UIButton) {
        delegate?.changeSizeAction(Index: rowNumber ?? 0)
    }
    @IBAction func previousBtnAction(_ sender: UIButton) {
        if qtyValue! > 1 {
             let  qty = qtyValue! - 1
             qtyLabel.text = "\(qty ?? 0)"
            qtyValue = qty
             delegate?.previousAction(self)
        }
        
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if qtyValue! > 0 {
          let  qty = qtyValue! + 1
             qtyLabel.text = "\(qty ?? 0)"
            qtyValue = qty
            delegate?.nextAction(self)
        }
      
    }
}
