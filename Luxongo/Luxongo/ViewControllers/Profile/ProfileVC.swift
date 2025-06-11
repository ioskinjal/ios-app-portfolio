//
//  ProfileVC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {
    
    //MARK: Variables
    
    var menuIconList = [UIImage]()
    
    
    //MARK: Properties
    static var storyboardInstance:ProfileVC {
        return StoryBoard.profile.instantiateViewController(withIdentifier: ProfileVC.identifier) as! ProfileVC
    }
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            DispatchQueue.updateUI_WithDelay {
                self.imgUser.setRadius(radius: nil)
            }
        }
    }
    @IBOutlet weak var lblUserNm: LabelBold!
    @IBOutlet weak var btnEdit: BlackBgButton!
    
    @IBOutlet weak var containerTableView: UIView!{
        didSet{
            //self.containerTableView.setRadius(radius: 12)
            //self.containerTableView.shadow(isCorner: true, radius: 12)
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ProfileTC.nib, forCellReuseIdentifier: ProfileTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    var isForOrganizer = false
    var isFromDetail = false
    var otherUserData:User?
    var organizerData:MyOrgenizersCls.List?
    var organizer_id:String?
    
    var userSlug:String?
    var userId:String?
    
    func setUpUI() {
        if isFromDetail{
            btnBack.isHidden = false
            btnEdit.isHidden = true
        }else{
            btnBack.isHidden = true
            btnEdit.isHidden = false
        }
        
        if isForOrganizer{//For Organizer view
            btnBack.isHidden = false
            if isFromDetail{
                btnEdit.isHidden = true
            }else{
                btnEdit.isHidden = false
            }
            menuIconList = [#imageLiteral(resourceName: "description"), #imageLiteral(resourceName: "prWebsite"),#imageLiteral(resourceName: "ic_paypal"), #imageLiteral(resourceName: "facebook"), #imageLiteral(resourceName: "twitter"), #imageLiteral(resourceName: "linkedin")]
            getOrganizerDetail()
        }else{//For profile view
            menuIconList = [#imageLiteral(resourceName: "prEmail"), #imageLiteral(resourceName: "pr_phone"), #imageLiteral(resourceName: "prGendar"), #imageLiteral(resourceName: "pr_calendar"), #imageLiteral(resourceName: "prBusiness"), #imageLiteral(resourceName: "prWebsite"),#imageLiteral(resourceName: "ic_paypal"), #imageLiteral(resourceName: "prAddress")]
            getMyProfile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(profileChange), name: .editProfile, object: nil)
        setUpUI()
        
    }
    
    func getOrganizerDetail(){
        if let organizer_id = self.organizer_id, isForOrganizer{
            let param:dictionary = ["id":organizer_id,
                                    "userid":UserData.shared.getUser()!.userid]
            API.shared.call(with: .orgenizerDetail, viewController: nil, param: param, failer: { (response) in
                UIApplication.alert(title: "", message: response, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }) { (response) in
                print(response)
                let data = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                self.organizerData = MyOrgenizersCls.List(dictionary: data)
                self.showData(data:self.organizerData)
            }
        }
    }
    
    func showData(data:MyOrgenizersCls.List?){
        self.imgUser.downLoadImage(url: data?.image ?? "")
         self.lblUserNm.text = data?.name
        self.tableView.reloadData()
    }
    
    
    @objc func profileChange(notification: Notification) {
        let data = notification.object as! [String: Any]
        if data["flag"] as? Bool ?? false{
            print("Notification capture")
            setUpUI()
        }
    }
    
    func getMyProfile(){
        let param:dictionary!
        if let userSlug = userSlug, let userId = userId, isFromDetail{
            param = ["user_slug": userSlug,
                     "userid": userId,]
        }else{
            param = ["user_slug": UserData.shared.getUser()!.slug,
                     "userid": UserData.shared.getUser()!.userid]
        }
        API.shared.call(with: .userProfile, viewController: self, param: param) { (response) in
            if self.isFromDetail{
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                self.otherUserData = User(dictionary: dic)
                if let otherUserData = self.otherUserData{
                    self.imgUser.downLoadImage(url: otherUserData.avatar_100x_100)
                    self.lblUserNm.text = otherUserData.name
                    self.tableView.reloadData()
                }
            }else{
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                if let uData = User(dictionary: dic).convertToDictionary{
                    UserData.shared.setUser(dic: uData)
                    self.imgUser.downLoadImage(url: UserData.shared.getUser()?.avatar_100x_100 ?? "")
                    self.tableView.reloadData()
                    self.lblUserNm.text = UserData.shared.getUser()?.name
                }
            }
        }
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        if isForOrganizer{
            let nextVC = AddOrganizerVC.storyboardInstance
            nextVC.isFromEdit = true
            nextVC.data = organizerData
            pushViewController(nextVC, animated: true)
        }else{
            let nextVC = EditProfileVC.storyboardInstance
            nextVC.isEditMode = true
            pushViewController(nextVC, animated: true)
        }
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTC.identifier) as? ProfileTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.btnIcon.setImage(menuIconList[indexPath.row], for: .normal)
        cell.index = indexPath.row
        if isForOrganizer{
            cell.cellData = organizerData
            cell.showOrganizerData()
//            btnBack.isHidden = false
//            if organizerData?.id ?? "" == UserData.shared.getUser()?.userid {
//                btnEdit.isHidden = true
//            }
        }else{
            if isFromDetail{
                cell.userData = otherUserData
            }
            cell.showProfileData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuIconList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
