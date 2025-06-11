//
//  SelectTicketTC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectTicketTC: UITableViewCell {

    var cellData: MyTicketsCls.List?{
        didSet{
            loadCellUI()
        }
    }
    var indexPath:IndexPath?
    
    @IBOutlet weak var btnCheckBox: UIButton!{
        didSet{
            self.btnCheckBox.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        }
    }
    
    @IBOutlet weak var lblTicketType: LabelSemiBold!
    @IBOutlet weak var lblPrice: LabelRegular!
    @IBOutlet weak var lblValPrice: LabelRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        //sender.isSelected.toggle()
        if let cellData = self.cellData,
            let indexPath = self.indexPath,
            let parent = self.viewController as? SelectTicketVC{
            cellData.isSelected.toggle()
            parent.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblTicketType.text = cellData.ticket_type
            lblValPrice.text = ( cellData.ticket_price_type.lowercased() == "f" ? "Free".localized : cellData.ticket_price )
            btnCheckBox.isSelected = cellData.isSelected
        }
    }
    
}
