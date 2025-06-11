//
//  MyOrgenizersVC.swift
//  Luxongo
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyOrgenizersVC: BaseViewController {
    
    //MARK: Properties
    
    static var storyboardInstance:MyOrgenizersVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: MyOrgenizersVC.identifier) as! MyOrgenizersVC
    }
    
    @IBOutlet weak var tableview: UITableView!{
        didSet{
            tableview.register(SelectOraganizerTC.nib, forCellReuseIdentifier: SelectOraganizerTC.identifier)
            tableview.dataSource = self
            tableview.delegate = self
            tableview.tableFooterView = UIView()
        }
    }
    
    var orgenizerList = [MyOrgenizersCls.List]()
    var orgenizerObj: MyOrgenizersCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orgenizerList = [MyOrgenizersCls.List]()
        orgenizerObj = nil
        getMyOrgenizer()
    }
    
    func getMyOrgenizer(){
        
        let nextPage = (orgenizerObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .getUserOrganizers, viewController: self, param: param) { (response) in
            self.orgenizerObj = MyOrgenizersCls(dictionary: response)
            if self.orgenizerList.count > 0{
                self.orgenizerList += self.orgenizerObj!.list
            }
            else{
                self.orgenizerList = self.orgenizerObj!.list
            }
            if self.orgenizerList.count != 0{
                self.tableview.reloadData()
            }
        }
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
         popViewController(animated: true)
    }
    @IBAction func onClickAdd(_ sender: UIButton) {
        let nextVC = AddOrganizerVC.storyboardInstance
        nextVC.isFromEdit = false
         pushViewController(nextVC, animated: true)
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
extension MyOrgenizersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectOraganizerTC.identifier) as? SelectOraganizerTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.btnCheckBox.setImage(#imageLiteral(resourceName: "redDustbin"), for: .normal)
        cell.orgenizerData = orgenizerList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgenizerList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProfileVC.storyboardInstance
        nextVC.isForOrganizer = true
        nextVC.organizer_id = String(orgenizerList[indexPath.row].organizer_id)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if orgenizerList.count - 1 == indexPath.row &&
            (Int(orgenizerObj!.page) < orgenizerObj!.lastPage) {
            getMyOrgenizer()
        }
    }
}
