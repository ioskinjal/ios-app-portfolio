//
//  InviteTC.swift
//  Luxongo
//
//  Created by admin on 8/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class InviteTC: UITableViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblContactName: LabelSemiBold!
    @IBOutlet weak var lblContactCount: LabelSemiBold!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cellData: MyContactCls.List?{
        didSet{
            loadCellUI()
        }
    }
    var indexPath:IndexPath?

    @IBAction func onClickRadio(_ sender: UIButton) {
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblContactName.text = cellData.contact_list_name
            lblContactCount.text = "\(String(describing: cellData.detailList.count ) ) Contacts"
            btnRadio.isSelected = cellData.isSelected
        }
    }
    
}
