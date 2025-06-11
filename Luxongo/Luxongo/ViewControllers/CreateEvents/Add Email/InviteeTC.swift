//
//  InviteeTC.swift
//  Luxongo
//
//  Created by admin on 8/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class InviteeTC: UITableViewCell {

    var cellData: FollowList?{
        didSet{
            loadCellUI()
        }
    }
    var indexPath:IndexPath?
    
    @IBOutlet weak var btnCheckBox: UIButton!{
        didSet{
            self.btnCheckBox.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
            self.btnCheckBox.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var lblName: LabelSemiBold!
    @IBOutlet weak var lblEmail: LabelSemiBold!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        
        if let cellData = self.cellData,
            let indexPath = self.indexPath,
            let parent = self.viewController as? SelectInviteeVC{
            cellData.isSelected.toggle()
            parent.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblName.text = cellData.user_name
            lblEmail.text = cellData.email
            btnCheckBox.isSelected = cellData.isSelected
        }
    }
    
}
