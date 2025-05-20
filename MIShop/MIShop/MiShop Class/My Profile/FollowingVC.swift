//
//  FollowingVC.swift
//  MIShop
//
//  Created by NCrypted on 17/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class FollowingVC: BaseViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUserName: UIImageView!
    @IBOutlet weak var tblFollowing: UITableView!{
        didSet{
            tblFollowing.register(FollowersCell.nib, forCellReuseIdentifier: FollowersCell.identifier)
            tblFollowing.dataSource = self
            tblFollowing.delegate = self
        }
    }
    
      var followingList = [Follower.FollowerList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Followings", action: #selector(btnSideMenuOpen))
        callgetFollowingAPI()
    }
   
    func callgetFollowingAPI() {
        let param = [
            "user_id": UserData.shared.getUser()!.uId,
            "login_id":UserData.shared.getUser()!.uId,
            "pageno":"1"
        ]
        ModelClass.shared.getFollowingList(vc: self, param: param) { (dic) in
            let data = Follower(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
           
            self.imgUserName.downLoadImage(url: data.userimg)
            self.lblName.text = data.fullname
            self.followingList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .followerList).map({Follower.FollowerList(dic: $0 as! [String:Any])})
            if self.followingList.count != 0{
                self.tblFollowing.reloadData()
            }
        }
    }
    @objc func btnSideMenuOpen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FollowingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowersCell.identifier) as? FollowersCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.imgUser.downLoadImage(url: followingList[indexPath.row].followimg)
        cell.lblName.text = followingList[indexPath.row].followfullname
        cell.lblUserName.text = followingList[indexPath.row].followname
        cell.btnFollow.setTitle(followingList[indexPath.row].followstatus.uppercased(), for: .normal)
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(onClickFollow(_:)), for: .touchUpInside)
        return cell
    }
    @objc func onClickFollow(_ sender:UIButton){
        let button:UIButton = sender
        if button.currentTitle == "follow" {
            let param = [
                "follow_user_id":followingList[button.tag].followid,
                "user:id":UserData.shared.getUser()!.uId
            ]
            ModelClass.shared.FollowUser(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callgetFollowingAPI()
                })
            }
        }else{
            let param = [
                "follow_id":followingList[button.tag].id,
                ]
            ModelClass.shared.UnFollowUser(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callgetFollowingAPI()
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
        
        
    }
    
}
