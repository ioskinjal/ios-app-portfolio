//
//  EmailTC.swift
//  Luxongo
//
//  Created by admin on 8/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EmailTC: UITableViewCell {

    var cellData: FollowList?{
        didSet{
            loadCellUI()
        }
    }
    var indexPath:IndexPath?
    
    @IBOutlet weak var lblEmail: LabelSemiBold!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickRemove(_ sender: UIButton) {
        if let _ = self.cellData,
            let indexPath = self.indexPath,
            let parent = self.viewController as? AddEventDetailVC{
            parent.selectedInvitee?.remove(at: indexPath.row)
            parent.tblEmail.reloadData()
            if parent.selectedInvitee?.count ?? 0 <= 0{
                parent.autoDynamicHeight()
            }
        }
    }
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblEmail.text = cellData.email
        }
    }
    
}
