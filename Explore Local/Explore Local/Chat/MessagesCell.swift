//
//  MessagesCell.swift
//  Talabtech
//
//  Created by NCT 24 on 23/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.setRadius(color: Color.grey.lightDeviderColor)
        }
    }
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var _containerView: UIView!{
        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self._containerView.border(side: .bottom, color: Color.Black.theam, borderWidth: 1.0)
//            }
        }
    }
    
    var cellData: MessageCls.MessagesList? {
        didSet{
            self.loadUI()
        }
    }
    
    
    func loadUI() {
        if let cellData = self.cellData {
            lblMessage.text = cellData.message
            lblCustomerName.text = cellData.user_name
            lblDate.text = cellData.date
            imgUser.downLoadImage(url: cellData.user_profile!)
        }
        else{
            lblMessage.text = ""
            lblDate.text = ""
            lblCustomerName.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessage.text = ""
        lblDate.text = ""
        lblCustomerName.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
