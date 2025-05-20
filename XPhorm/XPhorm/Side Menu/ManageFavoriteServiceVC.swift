//
//  ManageFavoriteServiceVC.swift
//  XPhorm
//
//  Created by admin on 6/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageFavoriteServiceVC: BaseViewController {
    
    static var storyboardInstance:ManageFavoriteServiceVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ManageFavoriteServiceVC.identifier) as? ManageFavoriteServiceVC
    }

    @IBOutlet weak var tblFavorite: UITableView!{
        didSet{
            tblFavorite.dataSource = self
            tblFavorite.delegate = self
            tblFavorite.tableFooterView = UIView()
            tblFavorite.separatorStyle = .none
            
        }
    }
    
    var serviceList = [FavoriteCLS.FavList]()
    var serviceObj: FavoriteCLS?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Manage Favorite Service", action: #selector(onClickMenu(_:)))
        
        getFavoriteServices()
    }
    
    func getFavoriteServices(){
         let nextPage = (serviceObj?.pagination?.page ?? 0 ) + 1
        
        let param = ["action":"getFavServices",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getFavorite(vc: self, param: param) { (dic) in
            self.serviceObj = FavoriteCLS(dictionary: dic)
            if self.serviceList.count > 0{
                self.serviceList += self.serviceObj!.favList
            }
            else{
                self.serviceList = self.serviceObj!.favList
            }
            self.tblFavorite.reloadData()
        }
    }

    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
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
extension ManageFavoriteServiceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteServiceCell.identifier) as? FavoriteServiceCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.viewContainer.setRadius(10.0)
        cell.viewContainer.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
        let data:FavoriteCLS.FavList?
        data = serviceList[indexPath.row]
        cell.lblLocation.text = data?.location
        cell.lblServiceName.text = data?.categoryName
        //cell.lblRate.text = data.ra
        cell.lblPrice.text = currency + data!.price
        cell.lblServiceCat.text = data?.desc
        cell.imgFavorite.downLoadImage(url: data?.serviceImage ?? "")
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(onClickUnFav(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnrequestBook.tag = indexPath.row
        cell.btnrequestBook.addTarget(self, action: #selector(onClickRequest(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onClickRequest(_ sender:UIButton){
        let nextVC = BookServiceVC.storyboardInstance!
        nextVC.service_id = serviceList[sender.tag].serviceId
        nextVC.service_type = serviceList[sender.tag].categoryName
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func onClickUnFav(_ sender:UIButton){
        let param = ["lId":UserData.shared.getLanguage,
                     "action":"updateFav",
                     "val":"favorit",
                     "userId":UserData.shared.getUser()!.id,
                     "id":serviceList[sender.tag].serviceId]
        
        Modal.shared.search(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.serviceList = [FavoriteCLS.FavList]()
                self.serviceObj = nil
                self.getFavoriteServices()
            })
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if serviceList.count - 1 == indexPath.row &&
            (serviceObj!.pagination!.page > serviceObj!.pagination!.numPages) {
            self.getFavoriteServices()
        }
    }
    
}
