//
//  SelectOrganizerVC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectOrganizerVC: BaseViewController {

    //MARK: Variables
    var orgenizerObj: MyOrgenizersCls?
    var listOfOrganizer: [MyOrgenizersCls.List] = []{
        didSet{
            tableView.reloadData()
            self.displayPopUp(presentView: self.sceneDockView, isPresent: self.listOfOrganizer.count < 1 )
        }
    }
    
    //MARK: Properties
    static var storyboardInstance:SelectOrganizerVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: SelectOrganizerVC.identifier) as! SelectOrganizerVC
    }
    
    //TODO: PopUpView Organizer
    @IBOutlet var sceneDockView: UIView!
    @IBOutlet weak var lblNoOrgaz: LabelRegular!
    @IBOutlet weak var btnAddOrg: BlackBgButton!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(SelectOraganizerTC.nib, forCellReuseIdentifier: SelectOraganizerTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetOrginizer()
    }
    
    //MARK: PopUp method
    @IBAction func onClickAddOrg(_ sender: UIButton) {
        openAddOrgVC()
    }
    
}

//MARK: Custom function
extension SelectOrganizerVC{
    
    func openAddOrgVC() {
        let nextVC = AddOrganizerVC.storyboardInstance
        nextVC.getCreatedOrg = {[weak self] (newOrg) in
            guard let self = self else { return }
            self.listOfOrganizer.append(newOrg)
        }
        pushViewController(nextVC, animated: true)
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (listOfOrganizer.filter({ $0.isSelected == true })).count < 1 {
            ErrorMsg = "Please select Organizer"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func saveDataWithOutValidate() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            let selectedOrgIds = (listOfOrganizer.filter({ $0.isSelected == true })).map({String($0.organizer_id)}).joined(separator: ",")
            eventData.organizer_ids = selectedOrgIds
        }
    }
    
    private func saveData() -> dictionary {
        let selectedOrgIds = (listOfOrganizer.filter({ $0.isSelected == true })).map({String($0.organizer_id)}).joined(separator: ",")
        let param:dictionary = [
            "organizer_ids": selectedOrgIds,
        ]
        return param
    }
    
    func setDataForEvent( eventData: inout CreateEvent) {
        let dic = saveData()
        eventData.organizer_ids = dic["organizer_ids",""]
    }
    
    func setUpPreLoadData() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            setPreSelected(ids: eventData.organizer_ids)
        }
    }
    
    func setPreSelected(ids: String) {
        if ids.isBlank {return}
        print(listOfOrganizer.map({$0.organizer_id}))
        print(ids)
        let idAry = ids.components(separatedBy: ",")
        for _id in idAry{
            let foundItems = listOfOrganizer.filter { "\($0.organizer_id)" == _id }
            if let item = foundItems.first{
                item.isSelected = true
            }
        }
        tableView.reloadData()
        
    }
    
}

//MARK: API Methods
extension SelectOrganizerVC{
    func callGetOrginizer() {
          let nextPage = (orgenizerObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .getUserOrganizers, viewController: self, param: param, failer: { (errStr) in
            print(errStr)
            self.listOfOrganizer = []
        }) { (response) in
            self.orgenizerObj = MyOrgenizersCls(dictionary: response)
            if self.listOfOrganizer.count > 0{
                self.listOfOrganizer += self.orgenizerObj!.list
            }
            else{
                self.listOfOrganizer = self.orgenizerObj!.list
            }
           
            if self.listOfOrganizer.count > 0{
                self.setUpPreLoadData()
            }
        }
    }
}


extension SelectOrganizerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectOraganizerTC.identifier) as? SelectOraganizerTC else {fatalError("Cell can't be dequeue")}
        cell.cellData = listOfOrganizer[indexPath.row]
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOrganizer.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
