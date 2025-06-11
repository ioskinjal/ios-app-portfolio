//
//  SearchCollectionViewController.swift
//  LevelShoes
//
//  Created by Maa on 26/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Foundation
import MBProgressHUD

var arrSearchWord = [Dictionary<String, Any>]()
var fromIndex = 0
protocol SearchCollectionViewControllerDelegate :class {
    func selectedProduct(product:ProductList, atIndex:IndexPath, cell: SearchCategoryTableViewCell  )
    func loadPDPPageForCatId(product:Dictionary<String, Any> ,atIndex:IndexPath ,cell :SearchCollectionTableViewCell)
    
}

import Alamofire

class SearchCollectionViewController: UIViewController, NoInternetDelgate, SearchCollectionTableViewCellDelegate {

    var klevuSearchApiTask: DataRequest?
    
    
    func didCancel() {
        
    }
    var  rowHeight = 0
    var halfPageHeight = 0
    weak var delegate: SearchCollectionViewControllerDelegate?;
    @IBOutlet weak var tableViewCollection: UITableView!
    var searchWorkModel = SearchWordKlevuRootClass.init()
    var searchCollection = [SearchWordKlevuResult]()
    var numberOfItems: Int = 0
    let collectionItemHeight: CGFloat = 400.0
    var totalResultsFound : Int64 = 0
    var onDidSelectItem: ((IndexPath) -> ())?
    var batchSize = 50
    var offSet : CGPoint = CGPoint.zero
    var needToCallPaginationAPI = true
    var searchProductArray: [ProductList] = []
    var scrollingDirection = ""
    var prevScrollDirection = ""
    override func viewDidLoad() {
        //kk
        super.viewDidLoad()
        //tableViewCollection.isScrollEnabled = false
        let cells =
            [SearchCategoryTableViewCell.className, SearchCollectionTableViewCell.className]
        tableViewCollection.register(cells)
        tableViewCollection.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableViewCollection.alwaysBounceVertical = false
    }
    static var searchCollectionStoryboardInstance:SearchCollectionViewController? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchCollectionViewController.identifier) as? SearchCollectionViewController
        
    }
    func updateHeight() {
        UIView.setAnimationsEnabled(false)
        tableViewCollection.beginUpdates()
        tableViewCollection.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    
    func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // if the table view is the last UI element, you might need to adjust the height
        let size = CGSize(width: targetSize.width,
                          height: tableViewCollection.frame.origin.y + tableViewCollection.contentSize.height)
        return size
        
    }
    //MARK:- SearchCollectionTableViewCellDelegate
    func reloadDataWithPaging() {
        guard self.needToCallPaginationAPI else { return }
        fromIndex = searchProductArray.count + self.batchSize
        klevuSearchApi(text: searchTextWord, gender: applyFilter)
    }
    
    func loadPDPPageForCatId(product:Dictionary<String, Any> ,atIndex:IndexPath ,cell :SearchCollectionTableViewCell){
        klevuProductSearchApi(skutext: product["sku"] as? String ?? "")
    }
    func tableScrollDirection(direction:String){
        DispatchQueue.main.async {
            self.scrollingDirection = direction

            let index = IndexPath(row: 0, section: 0)
            self.tableViewCollection.reloadRows(at: [index], with: .none)
        }
    }
    
    func klevuProductSearchApi(skutext: String){
        let delimiter = ";"
        let tempSkuArray = skutext.components(separatedBy: delimiter)
        let skuId = tempSkuArray[0]
        var arrMust = [[String:Any]]()
        
        arrMust.append(["match": ["sku":skuId]])
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        
        var dictSort = [String:Any]()
        dictSort = ["updated_at":"desc"]
        let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id","color","material"],
                     "from":0,
                     "size": 5,
                     "sort" : dictSort,
                     "query": dictBool
            ] as [String : Any]
        
        let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            if let error = error {
                if error.localizedDescription.contains(s: "offline") {
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                }
                
                return
            }
            var data: NewInData?
            if response != nil{
                let dict = ["data": response?.dictionaryObject]
                data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async(execute: {
                    
                    let nextVC = ProductDetailVC.storyboardInstance!
                    // nextVC.selectedProduct = ip.row
                    nextVC.detailData = data
                    // applyTransitionAnimation(nextVC: nextVC)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                })
            }
            
        }
    }
    func klevuSearchApi(text: String, gender: String){
        
        DispatchQueue.global().async {
            
            guard self.klevuSearchApiTask == nil else { return }
            if self.totalResultsFound > 0 {
                guard self.totalResultsFound > arrSearchWord.count else { return }
            }
            
            print(#function)
            let param = [
                //  validationMessage.ticket:"klevu-158358783414411589",
                validationMessage.ticket:getSkuCode(),
                validationMessage.term: text ,
                validationMessage.paginationStartsFrom: fromIndex,
                validationMessage.noOfResults:self.batchSize,
                validationMessage.showOutOfStockProducts:"false",
                validationMessage.fetchMinMaxPrice:"true",
                validationMessage.enableMultiSelectFilters:"true",
                validationMessage.sortOrder:"rel",
                validationMessage.enableFilters:"true",
                validationMessage.applyResults:"",
                validationMessage.visibility:"search",
                validationMessage.category:"KLEVU_PRODUCT",
                validationMessage.klevu_filterLimit:"50",
                validationMessage.sv:"2219",
                validationMessage.lsqt:"",
                validationMessage.responseType:"json",
                validationMessage.resultForZero:"1",
                validationMessage.applyFilters: gender
                ] as [String : Any]

            print("paginationStartsFrom :-", fromIndex)
            self.klevuSearchApiTask?.cancel()
            let url = CommonUsed.globalUsed.KlevuMain + CommonUsed.globalUsed.kleviCloud + CommonUsed.globalUsed.klevuNSearch
            self.klevuSearchApiTask = ApiManager.apiGet(url: url, params: param) { [weak self] (response:JSON?, error:Error? ) in
                guard let `self` = self else { return }
                self.klevuSearchApiTask = nil
                if let error = error {
                    print(error)
                    if error.localizedDescription.contains(s: "offline") {
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                
                guard let response = response else { return }
                
                let dict = response.dictionaryObject
                _ = SearchWordKlevuRootClass.init(fromDictionary: (response.dictionaryObject)!)
                let meta = dict?["meta"] as? [String : Any]
                self.totalResultsFound = meta?["totalResultsFound"] as? Int64 ?? 0
                let results = dict?["result"] as? [[String : Any]] ?? []
                //print("result \(results)")
                let val = results.count >= self.batchSize
                self.needToCallPaginationAPI = val
                arrSearchWord.append(contentsOf: results)
                guard changeCategory == true else  {
                    DispatchQueue.main.async {
                        self.tableViewCollection.reloadData()
                    }
                    return
                }
                DispatchQueue.main.async(execute: {
                   // let index = IndexPath(row: 0, section: 0)
                    guard let cell = self.tableViewCollection.dequeueReusableCell(withIdentifier: "SearchCollectionTableViewCell") as? SearchCollectionTableViewCell else { return }
                    
                    cell.totalResultsFound = self.totalResultsFound
                    cell.totalCount = self.stringFromAny(value: self.totalResultsFound)
                    self.tableViewCollection.reloadData()
                    cell.collectionReloadData()
                    
                    DispatchQueue.main.async(execute: { [self] in
                        //This code will run in the main thread:
                        var frame = self.tableViewCollection.frame
                        frame.size.height = self.tableViewCollection.contentSize.height
                        self.tableViewCollection.frame = frame
                        self.tableViewCollection.isScrollEnabled = false
                    })
                })
            }
        }
    }
}

extension SearchCollectionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.searchProductArray.count < 1 {
//            return  1
//        }
        return  2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.totalResultsFound == 0 && self.searchProductArray.count == 0) {
            let cell = self.loadSearchListView(tableView: tableView, indexPath: indexPath)
            return cell
        }
        switch indexPath.row
        {
            case 0:
                let cell = self.loadSearchListView(tableView: tableView, indexPath: indexPath)
                return cell
            default:
                let cell = self.loadCollectionView(tableView: tableView, indexPath: indexPath)
                return cell
            
        }
        /*
        if self.searchProductArray.count < 1 {
            if arrSearchWord.count < 1 {
                //if both search list and grid not available then show no result fond
                let cell = self.loadSearchListView(tableView: tableView, indexPath: indexPath)
                return cell
            }
            else{
                let cell = self.loadCollectionView(tableView: tableView, indexPath: indexPath)
                return cell
            }
        }
        else{
            switch indexPath.row
            {
                case 0:
                    let cell = self.loadSearchListView(tableView: tableView, indexPath: indexPath)
                    return cell
                default:
                    let cell = self.loadCollectionView(tableView: tableView, indexPath: indexPath)
                    return cell
                
            }
        }
 */
    }

    
    func loadSearchListView(tableView: UITableView , indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryTableViewCell", for: indexPath) as? SearchCategoryTableViewCell else { return UITableViewCell() }
        cell.searchProductArray = self.searchProductArray
        cell.delegate = self
        
        if (self.totalResultsFound == 0 && self.searchProductArray.count == 0) {
            cell.isShowNoIteamView(isShow:true)
        }
        else{
            cell.isShowNoIteamView(isShow:false)
        }
//        if cell.searchProductArray.count < 1 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                if cell.searchProductArray.count < 1 {
//                    cell.isShowNoIteamView(isShow:true)
//                }
//            }
//        } else {
//            cell.isShowNoIteamView(isShow:false)
//        }
        cell.tableViewCell.reloadData()
//        DispatchQueue.main.async {
//            cell.frame = self.tableViewCollection.bounds;
            
//            cell.layoutSubviews()
//            cell.tableViewCell.invalidateIntrinsicContentSize()
//            cell.tableViewCell.layoutIfNeeded()
//            cell.tableViewCell.heightAnchor.constraint(equalToConstant: cell.tableViewCell.contentSize.height).isActive = true
//            self.updateHeight()
//        }
        return cell
    }

    func loadCollectionView(tableView: UITableView , indexPath: IndexPath) -> UITableViewCell{
        
        guard let cellCollection = tableView.dequeueReusableCell(withIdentifier: "SearchCollectionTableViewCell", for: indexPath) as? SearchCollectionTableViewCell else{return UITableViewCell()}
        cellCollection.selectionStyle = .none
        cellCollection.delegates = self
        cellCollection.frame = tableViewCollection.bounds;
        cellCollection.parentControllerSearch = self

//        if self.totalResultsFound % 2 == 0 {
//            print("even number")
//            print("searchProductArray count = \(self.searchProductArray.count)")
//            print("totalResultsFound = \(self.totalResultsFound)")
//            if self.searchProductArray.count == 0 {
//                cellCollection._heightConstant.constant = tableView.frame.height - 50
//            }
//            else{
//                cellCollection._heightConstant.constant = tableView.frame.height
//            }
//
//          } else {
//            print("odd number")
//            print("searchProductArray count = \(self.searchProductArray.count)")
//            print("totalResultsFound = \(self.totalResultsFound)")
//            cellCollection._heightConstant.constant = tableView.frame.height - 50
//          }
        cellCollection._heightConstant.constant = tableView.frame.height - 50
        cellCollection.layoutIfNeeded()
        cellCollection.collectionViews.reloadData()
        cellCollection.totalResultsFound = self.totalResultsFound
        cellCollection.totalCount = self.stringFromAny(value: totalResultsFound)
        return cellCollection
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchProductArray.count < 1 {
            if arrSearchWord.count < 1 {
                let h = 56.0 * CGFloat(min(4, searchProductArray.count))
               // return 10
            }
        }
        switch indexPath.row {
            case 0:
                var h:CGFloat = 0.0//56.0 * CGFloat(min(4, searchProductArray.count))
                if scrollingDirection == "" {
                    h = 56.0 * CGFloat(min(4, searchProductArray.count))
                    prevScrollDirection = ""
                }
                else if scrollingDirection == "movingUp"{
                    h = 0.0
                    prevScrollDirection = "movingUp"
                }
                else if scrollingDirection == "movingDown"{
                    h = 56.0 * CGFloat(min(4, searchProductArray.count))
                    prevScrollDirection = "movingDown"
                }
                else{
                    if prevScrollDirection == "movingUp" {
                        h = 0.0
                    }
                    else if prevScrollDirection == "movingDown" {
                        h = 56.0 * CGFloat(min(4, searchProductArray.count))
                    }
                    
                }
                return h
            default:
                return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SearchCollectionTableViewCell {
            cell.collectionViews.tag = indexPath.section
            cell.collectionViews.reloadData()
        }
    }
}
extension SearchCollectionViewController: SearchCategoryTableViewCellDelegate {
    func selectedProduct(product:ProductList, atIndex:IndexPath, cell: SearchCategoryTableViewCell  ){
        self.delegate?.selectedProduct(product: product, atIndex: atIndex, cell: cell)
    }
}

