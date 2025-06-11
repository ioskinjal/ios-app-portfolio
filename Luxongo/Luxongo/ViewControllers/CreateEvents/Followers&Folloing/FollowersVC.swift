//
//  FollowersVC.swift
//  Luxongo
//
//  Created by admin on 8/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FollowersVC: BaseViewController {

    static var storyboardInstance:FollowersVC {
        return (StoryBoard.createEvent.instantiateViewController(withIdentifier: FollowersVC.identifier) as! FollowersVC)
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(FollowCell.nib, forCellReuseIdentifier: FollowCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var userList = [FollowList]()
    var userObj: FollowersCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFollowers()
    }
    
    func getFollowers(){
        
         let nextPage = (userObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
            "page":nextPage,
            "limit":10] as [String : Any]
        
        API.shared.call(with: .followers, viewController: self, param: param) { (response) in
            self.userObj = FollowersCls(dictionary: response)
            if self.userList.count > 0{
                self.userList += self.userObj!.list
            }
            else{
                self.userList = self.userObj!.list
            }
            if self.userList.count != 0{
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FollowersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowCell.identifier) as? FollowCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.followerData = userList[indexPath.row]
         cell.selectionStyle = .none
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        //        cell.popularData = savedList[indexPath.row]
        //        cell.parentVCMyevents = self
        //        cell.showPopularData()
        //        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProfileVC.storyboardInstance
        nextVC.isFromDetail = true
        nextVC.userId = userList[indexPath.row].userid
        nextVC.userSlug = userList[indexPath.row].userslug
        nextVC.isForOrganizer = false
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
