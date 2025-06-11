//
//  ProfileTC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ProfileTC: UITableViewCell {
    
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblTittle: LabelSemiBold!
    
    var userData: User?
    
    var index = -1 {
        didSet{
           
        }
    }
    var cellData:MyOrgenizersCls.List?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
        
    }
    
    func showOrganizerData(){
         if index == 0{
        self.lblTittle.text = cellData?.organizer_desc
         }else if index == 1{
            lblTittle.text = cellData?.website
         }else if index == 2{
            lblTittle.text = cellData?.fb_link
         }else if index == 3{
            lblTittle.text = cellData?.paypal_email
         }
         else if index == 4{
            lblTittle.text = cellData?.twitter_link
         }else if index == 5{
            lblTittle.text = cellData?.link_in_link
        }
    }
    
    func showProfileData(){
        var user: User?
        if let userData = self.userData{
            user = userData
        }else{
            user = UserData.shared.getUser()
        }
        if index == 0{
            lblTittle.text = user?.email
        }else if index == 1{
            lblTittle.text = user?.user_mobile_no
        }else if index == 2{
            lblTittle.text = user?.gender
        }else if index == 3{
            lblTittle.text = user?.date_of_birth
        }else if index == 4{
            lblTittle.text = user?.organisation
        }else if index == 5{
            lblTittle.text = user?.website
        }else if index == 6{
            lblTittle.text = user?.paypal_email
        }
        else{
            lblTittle.text = user?.address
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
