//
//  DocumetsTableViewCell.swift
//  BnR Partner
//
//  Created by Ncrypted on 09/07/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
protocol DocumetsTableViewCellDelegate:class {
    func remove(item name: String)
}

class DocumetsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnRemove:UIButton!{
        didSet{
            btnRemove.addTarget(self, action: #selector(didTapBtnRemove), for: .touchUpInside)
        }
    }
    
    var data:Document?{
        didSet{
            self.setupUI()
        }
    }
    
   weak var delegate:DocumetsTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DocumetsTableViewCell{
    func setupUI(){
        if let data = data{
            self.lblName.text = data.name
        }
    }
}


extension DocumetsTableViewCell{
    @objc func didTapBtnRemove(){
        delegate.remove(item: data!.name)
    }
}
