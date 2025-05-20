//
//  PostedAdvertiseVC.swift
//  Explore Local
//
//  Created by NCrypted on 13/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class PostedAdvertiseVC: BaseViewController {

    static var storyboardInstance: PostedAdvertiseVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: PostedAdvertiseVC.identifier) as? PostedAdvertiseVC
    }
    
    @IBOutlet weak var btnAd: UIButton!{
        didSet{
            btnAd.layer.borderColor = UIColor.init(hexString: "6367F9").cgColor
        }
    }
    
    @IBOutlet weak var stackViewAdvertise: UIStackView!
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var tblAdvertise: UITableView!{
        didSet{
            tblAdvertise.register(PostedAdvertiseCell.nib, forCellReuseIdentifier: PostedAdvertiseCell.identifier)
            tblAdvertise.dataSource = self
            tblAdvertise.delegate = self
            tblAdvertise.tableFooterView = UIView()
            tblAdvertise.separatorStyle = .none
        }
    }
    
    var adList = [PostedAdvertiseCls.AdvertiseList]()
    var addObj: PostedAdvertiseCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Posted Advertisements", action: #selector(onClickMenu(_:)))
        
       
        
        if UserData.shared.getUser()?.user_type == "1"{
            stackViewAdvertise.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adList = [PostedAdvertiseCls.AdvertiseList]()
        addObj = nil
         callGetPostedAdvertisement()
    }
    func callGetPostedAdvertisement(){
        let nextPage = (addObj?.pagination?.current_page ?? 0 ) + 1
        
        let param = ["action":"advertisements",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page":nextPage] as [String : Any]
        Modal.shared.postedAdvertisement(vc: self, param: param) { (dic) in
            self.addObj = PostedAdvertiseCls(dictionary: dic)
            if self.adList.count > 0{
                self.adList += self.addObj!.advertiseList
            }
            else{
                self.adList = self.addObj!.advertiseList
            }
           
            if self.adList.count != 0{ self.tblAdvertise.reloadData()
            }else{
                self.lblNodata.isHidden = false
            }
        }
        
        
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func annNewAdvertise(_ sender: UIButton) {
        self.navigationController?.pushViewController(PostNewAdvertiseVC.storyboardInstance!, animated: true)
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
extension PostedAdvertiseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostedAdvertiseCell.identifier) as? PostedAdvertiseCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
        cell.btnApproved.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        if adList[indexPath.row].status == "p" {
        cell.btnApproved.setTitle("Pending", for: .normal)
            cell.lblRejectedReason.text = ""
        }else if adList[indexPath.row].status == "r" {
            cell.btnApproved.setTitle("Rejected", for: .normal)
            cell.lblRejectedReason.text = adList[indexPath.row].rejected_reason
        }else{
          cell.btnApproved.setTitle("Accepted", for: .normal)
            cell.lblRejectedReason.text = ""
        }
        cell.lblName.text = adList[indexPath.row].page
        cell.lblDesc.text = adList[indexPath.row].target
        cell.imgAd.downLoadImage(url: adList[indexPath.row].image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if adList.count - 1 == indexPath.row &&
            (addObj!.pagination!.current_page > addObj!.pagination!.total_pages) {
            self.callGetPostedAdvertisement()
        }
    }
    
    
    
}
