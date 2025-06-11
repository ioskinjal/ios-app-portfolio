//
//  SearchVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 01/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    
    static var storyboardInstance:SearchVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchVC.identifier) as? SearchVC
        
    }
    @IBOutlet weak var viewSeg5: UIView!
    @IBOutlet weak var viewSeg4: UIView!
    @IBOutlet weak var viewSeg3: UIView!
    @IBOutlet weak var viewSeg2: UIView!
    @IBOutlet weak var viewSeg1: UIView!
    @IBOutlet weak var viewSimilarProducts: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var viewNoResult: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                
                textfield.backgroundColor = .clear
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                textfield.textColor = .white
                textfield.border(side: .bottom, color: .white, borderWidth: 1.0)
                
                textfield.font = BrandenFont.thin(with: 16.0)
                
            }
            searchBar.delegate = self
            
        }
    }
    
    var StrGen = ""
    var selectedIndex = -1
     var searchData : SearchData?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = viewSimilarProducts
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    func callSearchAPI(searchText:String){
        var strKey = ""
        
        let strStore:String =  "\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")-\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        
        switch strStore {
        case "ae-en" :
            strKey = "a2xldnUtMTU4MzU4NzgzNDE0NDExNTg5OktsZXZ1LTRtMjlrYmhmOTY"
        case "ae-ar" :
            strKey = "a2xldnUtMTU4MzU4ODQxNjA3MTExNTg5OktsZXZ1LW5xYnBzdmYwbGw"
        case "sa-en" :
            strKey = "a2xldnUtMTU4MzU4OTI2OTgzMTExNTg5OktsZXZ1LWtpczFzY2k5dWw"
        case "sa-ar" :
            strKey = "a2xldnUtMTU4MzU4OTM0OTkwOTExNTg5OktsZXZ1LWthdGo0MnRxOG4"
        case "kw-en" :
            strKey = "a2xldnUtMTU4MzU4OTQyMDI3NTExNTg5OktsZXZ1LTN0NWtlYmdlNG4"
        case "kw-ar" :
            strKey = "a2xldnUtMTU4MzY0MTMzOTgwNzExNTg5OktsZXZ1LTM2OHVvdHU0aWU="
        case "om-en" :
            strKey = "a2xldnUtMTU4MzY0MTQxNzQ0NjExNTg5OktsZXZ1LWNxaXFxaGJhZWI"
        case "om-ar" :
            strKey = "a2xldnUtMTU4Mzc0ODE4MzUyMDExNTg5OktsZXZ1LWUwaWYzam1icXI"
        case "bh-en" :
            strKey = "a2xldnUtMTU4Mzc0ODUyOTQwNjExNTg5OktsZXZ1LTJyNnBzdjYwM3E"
        case "bh-ar" :
            strKey = "a2xldnUtMTU4Mzc1MTk5MjY2MDExNTg5OktsZXZ1LTZqYTE4djVybWI"
        default:
            strKey = "a2xldnUtMTU4MzU4NzgzNDE0NDExNTg5OktsZXZ1LTRtMjlrYmhmOTY"
        }
        let gender = UserDefaults.standard.value(forKey: "category") as! String
        if gender == "mens"{
                   StrGen = "men"
                   
               }else if gender == "womens"{
                   StrGen = "women"
    
               }else{
                   StrGen = "kids"
               }
       let param = ["ticket":"klevu-158358783414411589",
                     "term":searchText,
                     "paginationStartsFrom":0,
                     "noOfResults":12,
                     "showOutOfStockProducts":false,
                     "fetchMinMaxPrice":true,
                     "enableMultiSelectFilters":true,
                     "sortOrder":"rel",
                     "enableFilters":true,
                     "applyResults":"",
                     "visibility":"search",
                     "category":"KLEVU_PRODUCT",
                     "klevu_filterLimit":50,
                     "sv":2219,
                     "lsqt":"",
                     "responseType":"json",
                     "resultForZero":1,
                     "gender":StrGen,
                     
            ] as [String : Any]
        //print(param)
        
        let url = CommonUsed.globalUsed.cloudSearch + CommonUsed.globalUsed.search1
        ApiManager.apiGet(url: url, params: param) { (response, error) in
            
            if let error = error{
                print(error)
                return
            }
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
               self.searchData = SearchData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                
                if self.searchData?.result.count != 0 {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.viewNoResult.isHidden = true
                }else{
                    self.viewNoResult.isHidden = false
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func onClickMenu(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.tabBarController?.selectedIndex = 0
        case 1:
            print("")
        case 2:
            
            print("")
        case 3:
            print("")
        case 4:
            self.tabBarController?.selectedIndex = 4
        default:
            return
        }
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

extension SearchVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 34
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        callSearchAPI(searchText: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchProductCell.identifier) as? SearchProductCell else {
                fatalError("Cell can't be dequeue")
            }
            if indexPath.row == selectedIndex{
                
                cell.viewContainer.backgroundColor = UIColor(hexString: "212121")
            }else{
                cell.viewContainer.backgroundColor = .black
            }
            cell.selectionStyle = .none
      
        var imageStr = (searchData?.result[indexPath.row].image)!
        let array = imageStr.components(separatedBy: "/")
        imageStr =  "\(CommonUsed.globalUsed.kimageUrl)/\(array.count-2)/\(array.count-1)/\(array.last ?? "")"
        cell.imgProduct.downLoadImage(url:imageStr)
        cell.lblProduct.text = searchData?.result[indexPath.row].name.uppercased()
        let finalPrice = String(format: "%.2f", "\(searchData?.result[indexPath.row].startPrice ?? "0.0")")
        cell.lblPrice.text = finalPrice +  "\(searchData?.result[indexPath.row].storeBaseCurrency ?? "\(UserDefaults.standard.value(forKey: string.currency) ?? " AED")")"
        
            return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData?.result.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Search Results"
        
        label.textColor = .white
        label.font = BrandenFont.medium(with: 14.0)
        headerView.addSubview(label)
        headerView.backgroundColor = .black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            selectedIndex = indexPath.row
            self.tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 153
      
    }
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        reloadMoreData(indexPath: indexPath)
    //    }
    //
    //
    //    func reloadMoreData(indexPath: IndexPath) {
    //        if notificationList.count - 1 == indexPath.row &&
    //            (Int(notificationObj!.pagination!.page) < notificationObj!.pagination!.numPages) {
    //            self.getNotifications()
    //        }
    //    }
    
    
}
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewAll", for: indexPath)
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarProductCell.identifier, for: indexPath) as? SimilarProductCell else {
                fatalError("Cell can't be dequeue")
            }
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: false) {
            self.navigationController?.pushViewController(NewInVC.storyboardInstance!, animated: true)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.collectionView{
            
            changeSegment()
            
            var count = 0
            
            let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
                count = visibleIndexPath.row
            }
            
            switch count {
            case 0:
                viewSeg1.backgroundColor = .white
            case 1:
                viewSeg2.backgroundColor = .white
            case 2:
                viewSeg3.backgroundColor = .white
            case 3:
                viewSeg4.backgroundColor = .white
            case 4:
                viewSeg5.backgroundColor = .white
                
            default:
                viewSeg1.backgroundColor = .white
            }
        }
    }
    
    func changeSegment(){
        viewSeg1.backgroundColor = UIColor.init(hexString: "212121")
        viewSeg2.backgroundColor = UIColor.init(hexString: "212121")
        viewSeg3.backgroundColor = UIColor.init(hexString: "212121")
        viewSeg4.backgroundColor = UIColor.init(hexString: "212121")
        viewSeg5.backgroundColor = UIColor.init(hexString: "212121")
    }
    
    
    
}

