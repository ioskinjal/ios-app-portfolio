//
//  FollowersVC.swift
//  MIShop
//
//  Created by NCrypted on 17/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class FollowersVC: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var tblFollowers: UITableView!{
        didSet{
            tblFollowers.register(FollowersCell.nib, forCellReuseIdentifier: FollowersCell.identifier)
            tblFollowers.dataSource = self
            tblFollowers.delegate = self
        }
    }
    
    var followerList = [Follower.FollowerList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Followers", action: #selector(btnSideMenuOpen))
        callgetFollowerAPI()
    }

    func callgetFollowerAPI() {
            let param = [
                "user_id": UserData.shared.getUser()!.uId,
                "login_id":UserData.shared.getUser()!.uId,
                "pageno":"1"
        ]
        ModelClass.shared.getFolowerList(vc: self, param: param) { (dic) in
            let data = Follower(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.lblUserName.text = data.username
            self.imgUser.downLoadImage(url: data.userimg)
            self.lblName.text = data.fullname
            self.followerList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .followerList).map({Follower.FollowerList(dic: $0 as! [String:Any])})
            if self.followerList.count != 0{
                self.tblFollowers.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func btnSideMenuOpen()
    {
       self.navigationController?.popViewController(animated: true)
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

extension FollowersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowersCell.identifier) as? FollowersCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.imgUser.downLoadImage(url: followerList[indexPath.row].followimg)
        cell.lblName.text = followerList[indexPath.row].followfullname
        cell.lblUserName.text = followerList[indexPath.row].followname
       cell.lblUserName.textColor = colors.DarkGray.color
        cell.btnFollow.setTitle(followerList[indexPath.row].followstatus.uppercased(), for: .normal)
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(onClickFollow(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func onClickFollow(_ sender:UIButton){
        let button:UIButton = sender
        if button.currentTitle == "follow" {
            let param = [
                "follow_user_id":followerList[button.tag].followid,
                "user:id":UserData.shared.getUser()!.uId
            ]
            ModelClass.shared.FollowUser(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callgetFollowerAPI()
                })
            }
        }else{
            self.alert(title: "Alert", message: "Are you sure you want to unfollow this user?", actions: ["Yes","No"]) { (btnNo) in
                if btnNo == 0 {
                    let param = [
                        "follow_id":self.followerList[button.tag].id,
                        ]
                    ModelClass.shared.UnFollowUser(vc: self, param: param) { (dic) in
                        let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                        self.alert(title: "", message: str, completion: {
                            self.callgetFollowerAPI()
                        })
                    }
                }
                else {
                    //Do nothing
                }
        }
    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
        
        
    }
    
}
