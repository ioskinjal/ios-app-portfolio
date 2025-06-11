//
//  OrganizerTC.swift
//  Luxongo
//
//  Created by admin on 7/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OrganizerTC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cellData:MyOrgenizersCls.List?{
        didSet{
            showData()
        }
    }
    
    func showData(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
