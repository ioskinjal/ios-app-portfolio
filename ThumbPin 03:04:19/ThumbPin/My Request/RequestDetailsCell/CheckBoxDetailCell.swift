//
//  CheckBoxDetailCell.swift
//  ThumbPin
//
//  Created by NCT109 on 30/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class CheckBoxDetailCell: UITableViewCell {

    @IBOutlet weak var conTblvwCheckBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var tblvwCheckbox: UITableView!
    @IBOutlet weak var labelQuestion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         tblvwCheckbox.register(RadioTypeCell.nib, forCellReuseIdentifier: RadioTypeCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableViewDataSourceDelegate
        <D: UITableViewDataSource & UITableViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        conTblvwCheckBoxHeight.constant = 0
        tblvwCheckbox.estimatedRowHeight = 44
        tblvwCheckbox.rowHeight = UITableViewAutomaticDimension
        tblvwCheckbox.delegate = dataSourceDelegate
        tblvwCheckbox.dataSource = dataSourceDelegate
        tblvwCheckbox.tag = row
        tblvwCheckbox.reloadData()
        conTblvwCheckBoxHeight.constant = tblvwCheckbox.contentSize.height
    }
    
}
