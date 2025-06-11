//
//  FollowCell.swift
//  Luxongo
//
//  Created by admin on 8/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FollowCell: UITableViewCell {
    
    @IBOutlet weak var btnFollow: BlackBgButton!
    @IBOutlet weak var lblUserName: LabelBold!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var followerData:FollowList?{
        didSet{
            showData()
        }
    }
    
    
    func showData(){
        lblUserName.text = followerData?.user_name
        imgUser.downLoadImage(url: followerData!.avatar)
        if followerData?.is_logged_user_follow == "n"{
            btnFollow.setTitle("FOLLOW", for: .normal)
        }else{
            btnFollow.setTitle("UNFOLLOW", for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onClickFollow(_ sender: BlackBgButton) {
        if let parentVC = self.viewController as? FollowersVC {
            let param = ["userid":followerData!.requester_userid,
                         "requester_userid":UserData.shared.getUser()!.userid] as [String : Any]
            
            API.shared.call(with: .followUnfollow, viewController: parentVC, param: param) { (response) in
                parentVC.userObj = nil
                parentVC.userList = [FollowList]()
                parentVC.getFollowers()
            }
        }else if let parentVC = self.viewController as? FollowingVC {
            let param = ["userid":followerData!.userid,
                         "requester_userid":UserData.shared.getUser()!.userid] as [String : Any]
            
            API.shared.call(with: .followUnfollow, viewController: parentVC, param: param) { (response) in
                parentVC.userObj = nil
                parentVC.userList = [FollowList]()
                parentVC.getFollowings()
            }
        }
    }
}
