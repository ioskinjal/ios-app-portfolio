//
//  addressBookCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class addressBookCell: PersnolDetailBaseCell {
   
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewDefault: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    @IBOutlet weak var lblUserCountry: UILabel!
    @IBOutlet weak var viewDefaultWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnEditAddress: UIButton!
    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var underline: UILabel!
    var addressIndex = -1
    var addressdataCell : Addresses?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func editAddressBtnAction(sender:UIButton){
        addressIndex = sender.tag
        self.delegate?.editAddressBook(Cell:self)
    }
    @IBAction func removeAddressBtnAction(sender:UIButton){
        
        addressIndex = sender.tag
        self.delegate?.removeAddressBook(Cell:self)
    }
}
