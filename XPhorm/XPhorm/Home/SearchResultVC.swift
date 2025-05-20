//
//  SearchResultVC.swift
//  XPhorm
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SearchResultVC: BaseViewController {

    static var storyboardInstance:SearchResultVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchResultVC.identifier) as? SearchResultVC
    }

    @IBOutlet weak var tblSearch: UITableView!{
        didSet{
            tblSearch.dataSource = self
            tblSearch.delegate = self
            tblSearch.tableFooterView = UIView()
            tblSearch.separatorStyle = .none
            
        }
    }
    var param = [String:Any]()
    var searchResultList = [SearchResultCls.SearchList]()
    var searchObj: SearchResultCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Search".localized, action: #selector(onClickBack(_:)))
        callSearchAPI()
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func callSearchAPI(){
        
        let nextPage = (Int(searchObj?.pagination?.page ?? "") ?? 0) + 1
        
        param["page"] = nextPage
        let user = UserData.shared.getUser()
        if user != nil{
            param["userId"] = UserData.shared.getUser()?.id
        }
        Modal.shared.search(vc: self, param: param) { (dic) in
            self.searchObj = SearchResultCls(dictionary: dic)
            if self.searchResultList.count > 0{
                self.searchResultList += self.searchObj!.searchList
            }
            else{
                self.searchResultList = self.searchObj!.searchList
            }
            if self.searchResultList.count != 0{
            self.tblSearch.reloadData()
            }
        }
    }
    
    @IBAction func onClickFilterBy(_ sender: SignInButton) {
        let nextVC = FilterByVC.storyboardInstance!
        nextVC.param = param
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickMapview(_ sender: SignInButton) {
        let nextVC = SearchMapVC.storyboardInstance!
        nextVC.searchList = searchResultList
        nextVC.param = param
        self.navigationController?.pushViewController(nextVC, animated: true)
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
extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteServiceCell.identifier) as? FavoriteServiceCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.viewContainer.setRadius(10.0)
        cell.viewContainer.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
        let data:SearchResultCls.SearchList?
        data = searchResultList[indexPath.row]
        cell.imgFavorite.downLoadImage(url: data?.userImg ?? "")
        cell.lblServiceName.text = data?.userName
        cell.lblServiceCat.text = data?.categoryName
        cell.lblLocation.text = data?.location
        cell.rateView.rating = (data!.avgRating as NSString).doubleValue
        cell.lblRate.text = "(\(String(describing: data!.avgRating))/5)"
        cell.lblTotalService.text = "\(String(describing: data!.totalService))"
        cell.lblTotalServiceHead.text = "TOTAL SERVICE".localized
        cell.lblPrice.text = currency + data!.price
        if data?.favStatus == "true"{
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "fillHeartIcon"), for: .normal)
        }else{
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "blankHeartIcon"), for: .normal)
        }
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(onClickFavorite(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnrequestBook.tag = indexPath.row
        cell.btnrequestBook.addTarget(self, action: #selector(onClickRequest(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func onClickRequest(_ sender:UIButton){
        let user = UserData.shared.getUser()
        if user != nil{
        let nextVC = BookServiceVC.storyboardInstance!
        nextVC.service_id = searchResultList[sender.tag].id
        nextVC.service_type = searchResultList[sender.tag].categoryName
        self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            self.alert(title: "", message: "please login to book service")
        }
    }
    @objc func onClickFavorite(_ sender:UIButton){
        let user = UserData.shared.getUser()
        if user != nil{
        if sender.currentImage ==  #imageLiteral(resourceName: "fillHeartIcon") {
            let param = ["lId":UserData.shared.getLanguage,
            "action":"updateFav",
            "val":"favorit",
            "userId":UserData.shared.getUser()!.id,
            "id":searchResultList[sender.tag].id]
            
            Modal.shared.search(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.searchResultList = [SearchResultCls.SearchList]()
                    self.searchObj = nil
                    self.callSearchAPI()
                })
            }
        }else{
                let param = ["lId":UserData.shared.getLanguage,
                             "action":"updateFav",
                             "val":"favorit-o",
                             "userId":UserData.shared.getUser()!.id,
                             "id":searchResultList[sender.tag].id]
                
                Modal.shared.search(vc: self, param: param) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.searchResultList = [SearchResultCls.SearchList]()
                        self.searchObj = nil
                        self.callSearchAPI()
                    })
        }
    }
        }else{
            self.alert(title: "", message: "please login to add favorite")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if searchResultList.count - 1 == indexPath.row &&
            (Int(searchObj!.pagination!.page) ?? 0 < searchObj!.pagination!.numPages) {
            self.callSearchAPI()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ServiceDetailVC.storyboardInstance!
        nextVC.service_id = searchResultList[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
