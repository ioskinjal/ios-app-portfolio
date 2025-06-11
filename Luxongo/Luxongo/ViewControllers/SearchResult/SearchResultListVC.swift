//
//  SearchResultListVC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SearchResultListVC: BaseViewController {
    
    //MARK: Variables
    var serachText:String?
    var lat:String = ""
    var long:String = ""
    var address:String = ""
    var eventCls: EventCls?
    var searchEventList = [EventList](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var param:dictionary = [String:Any]()
    
    //MARK: Properties
    static var storyboardInstance:SearchResultListVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchResultListVC.identifier) as! SearchResultListVC
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMapView: GreyButton!
    
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
            
        }
    }
    
    @IBOutlet weak var lblAddr: LabelRegular!
    @IBOutlet weak var btnChange: GreyButton!
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(EventTC.nib, forCellReuseIdentifier: EventTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsHorizontalScrollIndicator = false
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.layoutIfNeeded()
        
        searchBar.text = serachText
        //callSerach()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.addRightView(icon: #imageLiteral(resourceName: "ic_filter"), selector: #selector(didTapBtnFilter(_:)))
        
        GooglePlaceAPI.shared.googlePlaceBlock = { (lat, long, addr, placeObj) in
            print("Place address: \(addr)")
            print("Place coordinate latitude: \(lat)")
            print("Place coordinate longitude: \(long)")
            self.lblAddr.text = addr
            self.address = addr
            self.lat = "\(lat)"
            self.long = "\(long)"
        }
        resetAndCallAPI()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickMapView(_ sender: UIButton) {
        let nextVC = SearchResultMapVC.storyboardInstance
        nextVC.searchEventList = self.searchEventList
        pushViewController(nextVC, animated: false)
    }
    
    @IBAction func onClickChange(_ sender: UIButton) {
        GooglePlaceAPI.shared.showGooglePlaceView(vc: self)
    }
    
    @objc private func didTapBtnFilter(_ sender:UIButton){
        if let _ = sender.superview as? UITextField{
            print("Click Filter")
            let presentVC = FilterByVC.storyboardInstance
            presentVC.parentVC = self
            present(presentVC, animated: true)
        }
    }
}

extension SearchResultListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = searchEventList[indexPath.row]
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEventList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let nextVC = EventPreview.storyboardInstance
        nextVC.event_slug = searchEventList[indexPath.row].event_slug
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: API methods
extension SearchResultListVC{
    
    func resetAndCallAPI() {
        searchEventList = []
        eventCls = nil
        callSerach()
    }
    
    func callSerach() {
        let nextPage = (eventCls?.page ?? 0 ) + 1
        self.param["page"] = nextPage
        self.param["limit"] = 5
        self.param["userid"] = UserData.shared.getUser()!.userid
        self.param["event_name"] = self.searchBar.text ?? ""
        self.param["event_lat"] = lat
        self.param["event_long"] = long
        self.param["event_addr"] = address
        
        
        API.shared.call(with: .searchEvents, viewController: self, param: param, failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.eventCls = EventCls(dictionary: response)
            if let eventCls = self.eventCls{
                if self.searchEventList.count > 0{
                    self.searchEventList += eventCls.eventList
                }
                else{
                    self.searchEventList = eventCls.eventList
                }
            }
        }
    }
    
    
}

//MARK: Custom function
extension SearchResultListVC{
    
    
    
}


extension SearchResultListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        searchBar.resignFirstResponder()
        resetAndCallAPI()
    }
    
}
