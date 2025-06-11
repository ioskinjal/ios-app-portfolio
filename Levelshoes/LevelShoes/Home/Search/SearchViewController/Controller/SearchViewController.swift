//
//  SearchViewController.swift
//  LevelShoes
//
//  Created by Maa on 25/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SwiftyJSON


struct Categoryess {
    let name : String
    var items : [[String:Any]]
}

var newView = UIView()
var checkGreaterThanTwoWord: Bool = false
var changeCategory : Bool = false
var searchTextWord :String = ""
var applyFilter = ""

var searchTimer: Timer?


class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, NoInternetDelgate {
    func didCancel() {
        
    }
    
    @IBOutlet weak var arWomenSelectionView: UIView!
    @IBOutlet weak var arMenSelectionView: UIView!
    @IBOutlet weak var arKidsSelectionView: UIView!
    
    @IBOutlet weak var topHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var constWidth: NSLayoutConstraint!
    @IBOutlet weak var constViewLeading: NSLayoutConstraint!
    @IBOutlet weak var _lblMenu: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblMenu.font = UIFont(name: "Cairo-SemiBold", size: _lblMenu.font.pointSize)
            }
            _lblMenu.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var _btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchHeaderView: UIView!
    @IBOutlet weak var selectionHeaderView: UIView!
    @IBOutlet weak var selectionArrowView: UIView!
    @IBOutlet weak var searchBorderView: UIView!
    
    @IBOutlet weak var searchButtonBGView: UIView!
    @IBOutlet weak var _btnMen: UIButton!{
        didSet {
            _btnMen.setTitle(validationMessage.slideMen.localized, for: .normal)
            //_btnMen.addTextSpacing(spacing: 1.5, color: "ffffff")
        }
    }
    var currentCategoryButton: UIButton?
    
    @IBOutlet weak var _btnWomen: UIButton!{
        didSet {
            _btnWomen.setTitle(validationMessage.slideWomen.localized, for: .normal)
            //_btnWomen.addTextSpacing(spacing: 1.5, color: "ffffff")
        }
    }
    
    @IBOutlet weak var _btnKids: UIButton!{
        didSet{
            _btnKids.setTitle(validationMessage.slidKids.localized, for: .normal)
            //_btnKids.addTextSpacing(spacing: 1.5, color: "ffffff")
            
        }
    }
    @IBOutlet weak var _viewSegment: UIView!
    @IBOutlet weak var _backgroundViewTable: UIView!{
        didSet{
            _backgroundViewTable.backgroundColor = UIColor(hexString: colorHexaCode.backgroundViewTable)
        }
    }
   // var language = NSLocale.current.languageCode;
    var language = UserDefaults.standard.value(forKey: string.language) as? String
    @IBOutlet weak var _searchBar: UISearchBar!
    @IBOutlet weak var SearchBarView: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                txtFieldSearch.font = UIFont(name: "Cairo-SemiBold", size: 16)
            }
            
            txtFieldSearch.backgroundColor = UIColor(hexString: colorHexaCode.txtFieldSearch)
           // txtFieldSearch.keyboardType = UIKeyboardType.alphabet
        }
    }
    
    lazy var searchController = storyBoard.instantiateViewController(withIdentifier: "SearchCollectionViewController") as! SearchCollectionViewController
    
    //    var parentVC = SearchViewController()
    var SelectedCat = ""
    
    var currentIndex = 0
    var originalArr = [[String:Any]]()
    var recentArr = [[String:Any]]();
    var recentIteamArr: [Recentitemsearch] = []
    var searchArrRes = [[String:Any]]()
    var searchTrendingArr : [[String : Any]] = []
    var searching:Bool = false
    var searchingCount: Bool = false
    var sections = [Categoryess]()
    var allcategory = SearchCategorySource()
    var kidsArray: [NSManagedObject] = []
    var fetchAllKidsChildrenBaby : [NSManagedObject] = []
    var menArray: [NSManagedObject] = []
    var womenArray: [NSManagedObject] = []
    var searchProductArray: [ProductList] = []
    //    let searchCollectionVC = SearchCollectionViewController.searchCollectionStoryboardInstance!
    //MARK:- Controller Instance
    
    static var searchBoardInstance:SearchViewController? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController
        
    }
    let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
    
    let searchcollectionVC = SearchCollectionViewController.searchCollectionStoryboardInstance!
    //MARK: - ViewDid Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategoryFromNotification), name: Notification.Name(notificationName.changeCategory), object: nil)
        getTrendingNowAPI()
        self.searchButtonBGView.isHidden = true
        self._btnClose.isHidden = false
        let cells =
            [CategoryTableViewCell.className, CollectionTableViewCell.className]
        tableView.register(cells)
        tableView.tableHeaderView?.frame = CGRect.zero
        _lblMenu.text = validationMessage.searchMenu.localized
        if language == "ar" {
            txtFieldSearch.textAlignment = .right
            _btnMen.tag = 1
            _btnWomen.tag = 2
            _btnKids.tag = 0
            _viewSegment.isHidden = true
        }
        else{
            _viewSegment.isHidden = false
            arWomenSelectionView.isHidden = true
            arMenSelectionView.isHidden = true
            arKidsSelectionView.isHidden = true
        }
        TapOnCategoryClick(_btnWomen)
        _btnWomen.isSelected = true
        txtFieldSearch.placeholder = validationMessage.searchTxtPlaceholder.localized
        //        SelectedCat = "women"

        txtFieldSearch.delegate = self
        txtFieldSearch.textColor  = UIColor.white
        txtFieldSearch.attributedPlaceholder = NSAttributedString(string: validationMessage.searchTxtPlaceholder.localized,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "C7C7C7")])
        //        txtFieldSearch.leftViewMode = UITextFieldViewMode.always
        //        txtFieldSearch.leftViewMode = .always
        
        //        recentArr =   [
        //            ["name": "Boot", "number": "+8800000003"],
        //            ["name": "Boy", "number": "+8800000004"]
        //        ]
        
        originalArr = [
            ["name": "Savan", "number": "+8800000001"],
            ["name": "Sammual", "number": "+8800000002"],
            ["name": "Sam", "number": "+8800000003"],
            ["name": "Samir", "number": "+8800000004"],
            ["name": "Chandu", "number": "+8800000005"],
            ["name": "Chandan", "number": "+8800000006"]
        ]
        fetchAllproductDataArray(category: "men")
        fetchAllproductDataArray(category: "women")
        fetchAllproductDataArray(category: "kids")
        setSelectedCategory()
        
        self.tableView.alwaysBounceVertical = false
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    self.tableView.alwaysBounceVertical = true

                case 1334:
                    print("iPhone 6/6S/7/8")
                    self.tableView.alwaysBounceVertical = true

                default:
                    print("Unknown")
                    self.tableView.alwaysBounceVertical = false
                }
            }
       // self.tableView.alwaysBounceVertical = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        language = UserDefaults.standard.value(forKey: string.language) as? String
        
        newView.frame = _backgroundViewTable.bounds
        newView.backgroundColor = UIColor(hexString: "070707")
        setFont()
        //my Section array
        //                let nav = UINavigationController()
        //                nav.pushViewController(orderDetailVC, animated: true)
        
        
    }
    func setFont(){
        _btnWomen.addTextSpacingButton(spacing: 1.5)
        _btnKids.addTextSpacingButton(spacing: 1.5)
        _btnMen.addTextSpacingButton(spacing: 1.5)
    }
    //MARK:- ViewWill Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func updateCategoryFromNotification(_ notification:Notification){
        setSelectedCategory()
    }
    func fetchAllproductDataArray(category:String){
        
        if category == "women"{
            womenArray = CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "women", parentId: "0") ?? []
        } else if category == "men"{
            menArray = CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "men", parentId: "0") ?? []
        }else if category == "kids"{
            kidsArray = CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: "kids", parentId: "0") ?? []
        }else{
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK:- Fetch Data from CoreData
    
    func fetchAllKidsBabyArray(){
        
        if CoreDataManager.sharedManager.fetchAllKidsChildrenBabyData() != nil{
            
            fetchAllKidsChildrenBaby = CoreDataManager.sharedManager.fetchAllKidsChildrenBabyData()!
        }
    }
    
    
    func setSelectedCategory(){
        //_btnWomen _btnKids _btnMen
        let select = UserDefaults.standard.value(forKey: "category") as? String ?? ""
        
        let strCategory = String(describing: select)
        
        if strCategory == "women"{
            SelectedCat = "women"
            TapOnCategoryClick(_btnWomen)
        }else if strCategory == "men"{
            SelectedCat = "men"
            TapOnCategoryClick(_btnMen)
        }else if strCategory == "kids"{
            SelectedCat = "kids"
            TapOnCategoryClick(_btnKids)
        }  else{
            SelectedCat = "women"
            TapOnCategoryClick(_btnWomen) //women
            
        }
    }
    func hideArebicSelection() {
        arWomenSelectionView.isHidden = true
        arMenSelectionView.isHidden = true
        arKidsSelectionView.isHidden = true
        _viewSegment.isHidden = true
    }
    
    //MARK:- Animated View
    func animateViewUp() {
        let diff = self._lblMenu.frame.height - (self.view.frame.height - self.SearchBarView.frame.height)
        let isCountryPickerOverlapLogo = diff > 0
        if isCountryPickerOverlapLogo {
            self.searchViewCenterY.constant = -diff-70
        }
        UIView.animate(withDuration: 1.0, delay: 1, options: [.curveLinear], animations: {
            self._lblMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }, completion:nil)
    }
    
    
    func animateViewDown(){
        self.searchViewCenterY.constant = 0
        UIView.animate(withDuration: 0.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.SearchBarView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK:- Close Button
    @IBAction func TapToCloseCrossTextField(_ sender: UIButton) {
        txtFieldSearch.text = ""
        txtFieldSearch.resignFirstResponder()
        self.searchProductArray = []
        if recentArr.count < 1 {
            sections = [
                Categoryess(name:" ", items:recentArr),
                Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
        } else {
            sections = [
                Categoryess(name:" ", items:recentArr),
                Categoryess(name:validationMessage.RECENT_SEARCHES.localized, items:recentArr),
                Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
        }
        newView.removeFromSuperview()
        self.tableView.reloadData()
        searching = true
        tableView.isHidden = false
        checkGreaterThanTwoWord = true
        if let button = currentCategoryButton {
            TapOnCategoryClick(button)
        }
        moveUpHeaderView(isUp: false)
    }
    @IBAction func TapToCloseCross(_ sender: UIButton){
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 0)
        })
    }
    
    //MARK:- Animetion
    func moveUpHeaderView(isUp:Bool) {
        
        /*
        if isUp {
            self.topHeaderConstraint.constant = -80
        } else {
            self.topHeaderConstraint.constant = 0
        }
        */
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            proceed()
        },completion: { finish in
            
        })
        
        func proceed() {
            self.searchButtonBGView.isHidden = !isUp
            self._btnClose.isHidden = isUp
            self.view.layoutIfNeeded()
            if isUp {
                self.searchBorderView.frame.size.width -= 50
                self.searchBorderView.frame.size.height = self._backgroundViewTable.frame.height
                if self.language == "ar" {
                    self.searchButtonBGView.frame.origin.x = self.searchBorderView.frame.origin.x
                } else {
                    self.searchButtonBGView.frame.origin.x = self.searchBorderView.frame.maxX + 10
                }
            } else {
                self.searchBorderView.frame.size.width = self.searchBorderView.frame.width + 50
                self.searchBorderView.frame.size.height = self._backgroundViewTable.frame.height
                if self.language == "ar" {
                    self.searchButtonBGView.frame.origin.x = self.searchBorderView.frame.origin.x - 20
                } else {
                    self.searchButtonBGView.frame.origin.x = self.searchBorderView.frame.maxX
                }
            }

        }
    }
    
    //MARK: - Category Button
    @IBAction func TapOnCategoryClick(_ sender: UIButton) {
       // print("btn tag = \(sender.tag) title = \(sender.titleLabel?.text)")
        if language == "ar" {
            hideArebicSelection()
        }
        searchController.needToCallPaginationAPI = true
        deSelectAll()
        currentCategoryButton = sender
        searching = false
        txtFieldSearch.resignFirstResponder()
        if language == "ar" {
            sender.titleLabel?.font = UIFont(name: "Cairo-Bold", size: 16)
        }else{
            sender.titleLabel?.font = BrandenFont.bold(with: 16.0)
        }
        
        var labelX = (sender.titleLabel?.frame.origin.x ?? 0)
        var leading = sender.frame.origin.x
        tableView.contentOffset = .zero
        if language == "ar" {
            if sender.tag == 0 {
                //leading = _btnWomen.frame.origin.x - 5
                arKidsSelectionView.isHidden = false
            } else if sender.tag == 1 {
                //leading = _btnMen.frame.origin.x - 5
                arMenSelectionView.isHidden = false
            } else if sender.tag == 2 {
                //leading = _btnKids.frame.origin.x - 5
                arWomenSelectionView.isHidden = false
            }
            
        } else {
            leading = sender.frame.origin.x
        }
        SelectedCat = ""
        if sender.tag == 0 {
            if language == "ar" {
                SelectedCat = "kids"
                if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                    applyFilter = "gender:للأطفال الرضع;;gender:للجنسين;;gender:للبنات"
                }
                else {
                    applyFilter = "gender:Baby;;gender:Boy;;gender:Girl"
                }
            }
            else{
                SelectedCat = "women"
                if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                    applyFilter = "gender:للنساء"
                }
                else {
                    applyFilter = "gender:Women"
                }
            }
            
        } else if sender.tag == 1 {
            SelectedCat = "men"
            if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                applyFilter = "gender:للرجال"
            }
            else {
                applyFilter = "gender:Men"
            }
        } else if sender.tag == 2 {
            if language == "ar" {
                SelectedCat = "women"
                if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                    applyFilter = "gender:للنساء"
                }
                else {
                    applyFilter = "gender:Women"
                }
            }
            else{
                SelectedCat = "kids"
                if UserDefaults.standard.value(forKey: string.language)as? String == string.ar{
                    applyFilter = "gender:للأطفال الرضع;;gender:للجنسين;;gender:للبنات"
                }
                else {
                    applyFilter = "gender:Baby;;gender:Boy;;gender:Girl"
                }
            }
        }
        if checkGreaterThanTwoWord == true{
            changeCategory = true
            let controller = searchController
            if controller.parent == nil {
                addChildViewController(controller)
            }
            arrSearchWord = []
            fromIndex = 0
            
            let searchText  = txtFieldSearch.text ?? ""
            
            //controller.klevuSearchApi(text: searchTextWord, gender: applyFilter)
            controller.klevuSearchApi(text: searchText, gender: applyFilter)
            //                controller.view.frame.size.height = _backgroundViewTable.frame.size.height
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            newView.addSubview(controller.view)
            controller.view.pinToSuperview()
        }

        self.constWidth.constant = sender.intrinsicContentSize.width
        if language == "ar" {
            labelX += 8
        }
        self.constViewLeading.constant = leading + labelX
        
        UIView.animate(withDuration: 0.4) {
            self._viewSegment.superview?.layoutIfNeeded()
        }
        if txtFieldSearch.text!.length > 2 {
            loadCategoryViewAfterSearch()
        } else {
            tableView.reloadData()
        }
    }
    
    func loadCategoryViewAfterSearch() {
        let searchText  = txtFieldSearch.text ?? ""
        let controller = searchController
        if controller.parent == nil {
            addChildViewController(controller)
        }
        
        checkGreaterThanTwoWord = true
        arrSearchWord = []
        //Nitikesh look
        self.searchProductArray = []
        self.searchProductArray =   CoreDataManager.sharedManager.fetchProductNewDataForSearchCatogery(rootCategoryName: SelectedCat, searchCatName: txtFieldSearch.text! ) ?? []
        controller.klevuSearchApi(text: txtFieldSearch.text ?? "", gender: applyFilter ?? "")
        
        controller.searchProductArray = self.searchProductArray
        controller.delegate = self
        searchingCount = true
        // controller.view.frame.size.height = _backgroundViewTable.frame.size.height
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        newView.addSubview(controller.view)
        controller.view.pinToSuperview()
        _backgroundViewTable.addSubview(newView)
        controller.didMove(toParentViewController: self)
        controller.tableViewCollection.reloadData()
    }
    
    func deSelectAll() {
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
            _btnWomen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            _btnMen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            _btnKids.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
        }else{
            _btnWomen.titleLabel?.font = BrandenFont.regular(with: 16.0)
            _btnMen.titleLabel?.font = BrandenFont.regular(with: 16.0)
            _btnKids.titleLabel?.font = BrandenFont.regular(with: 16.0)
        }

    }
    
    
    //MARK:- Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //   moveUpHeaderView(isUp: false)
        textField.resignFirstResponder()
        // recentArr.removeAll()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recentIteamArr =  CoreDataManager.sharedManager.fetchRecentitemsearchData(searchtext: textField.text ?? "", categoryname: SelectedCat, language: UserDefaults.standard.value(forKey: "language") as? String ?? "" , id : recentArr.count) ?? []
        recentArr.removeAll()
        for recentIteam in recentIteamArr {
            let dic = ["name" : recentIteam.searchtext]
            recentArr.insert(dic, at: 0)
        }
        searching = true
        moveUpHeaderView(isUp: true)
        if recentArr.count < 1 {
       
            sections = [
            Categoryess(name:" ", items:recentArr),
            Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
            
        
        }else{
            sections = [
            Categoryess(name:" ", items:recentArr),
            Categoryess(name:validationMessage.RECENT_SEARCHES.localized, items:recentArr),
            Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
        }
        tableView.reloadData()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var tempRecentArray    =  CoreDataManager.sharedManager.fetchRecentitemsearchData(searchtext: textField.text ?? "", categoryname: SelectedCat, language: UserDefaults.standard.value(forKey: "language") as? String ?? "" , id : recentArr.count)!
          moveUpHeaderView(isUp: true)
        if (textField.text ?? "").length > 2 {
            if tempRecentArray.count < 2{
                CoreDataManager.sharedManager.insertRecentitemsearchData(searchtext: textField.text ?? "", categoryname: SelectedCat, language: UserDefaults.standard.value(forKey: "language") as? String ?? "" , id :recentArr.count )
                
            } else {
                var deleteItemObj : Recentitemsearch = Recentitemsearch()
                for deleteItem in tempRecentArray{
                    var name = recentArr[recentArr.count - 1]["name"] as? String
                    if deleteItem.searchtext == name {
                        deleteItemObj = deleteItem
                    }
                    
                }
                CoreDataManager.sharedManager.deleteRecentIteamSearchData(recentItem: deleteItemObj)
                
                CoreDataManager.sharedManager.insertRecentitemsearchData(searchtext: textField.text ?? "", categoryname: SelectedCat, language: UserDefaults.standard.value(forKey: "language") as? String ?? "" , id : tempRecentArray.count)
                
            }
            recentIteamArr =  CoreDataManager.sharedManager.fetchRecentitemsearchData(searchtext: textField.text ?? "", categoryname: SelectedCat, language: UserDefaults.standard.value(forKey: "language") as? String ?? "" , id : recentArr.count) ?? []
            recentArr.removeAll()
            for recentIteam in recentIteamArr {
                let dic = ["name" : recentIteam.searchtext]
                recentArr.insert(dic, at: 0)
            }
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let controller = searchController
        if controller.parent == nil {
            addChildViewController(controller)
        }
        var searchText  = textField.text ?? ""
        searchText = searchText + string
        if textField == txtFieldSearch {
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace: Int = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            searchTextWord = textField.text ?? "" 
            searchTextWord = searchTextWord + string
            if newLength <= 2 {
                self.searchProductArray = []
                 if recentArr.count < 1 {
                      
                           sections = [
                           Categoryess(name:" ", items:recentArr),
                           Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
                           
                       
                       }else{
                           sections = [
                           Categoryess(name:" ", items:recentArr),
                           Categoryess(name:validationMessage.RECENT_SEARCHES.localized, items:recentArr),
                           Categoryess(name:validationMessage.TRENDING_SEARCHES.localized, items:searchTrendingArr)]
                       }
                newView.removeFromSuperview()
                controller.removeFromParentViewController()
                self.tableView.reloadData()
                searching = true
                tableView.isHidden = false
                checkGreaterThanTwoWord = true
            } else if newLength >= 3 {
                checkGreaterThanTwoWord = true
                arrSearchWord = []
                //Nitikesh look
                self.searchProductArray =   CoreDataManager.sharedManager.fetchProductNewDataForSearchCatogery(rootCategoryName: SelectedCat, searchCatName: searchText ) ?? []
                print("searchTextWord = \(searchTextWord)")
                controller.klevuSearchApi(text: searchTextWord, gender: applyFilter)
                controller.searchProductArray = self.searchProductArray
                controller.delegate = self
                searchingCount = true
//                controller.view.frame.size.height = _backgroundViewTable.frame.size.height
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                newView.addSubview(controller.view)
                controller.view.pinToSuperview()
                _backgroundViewTable.addSubview(newView)
                controller.didMove(toParentViewController: self)
                controller.tableViewCollection.reloadData()
            }
        }
        searchArrRes = self.originalArr.filter({(($0["name"] as? String ?? "").localizedCaseInsensitiveContains(searchText))})
        return true
    }
    //MARK:- Trending Now Api
    func getTrendingKlevuUrl( category: String) -> String{
        let localizedUrl = CommonUsed.globalUsed.main + "/" + CommonUsed.globalUsed.productIndexName + "_"
        let url =  localizedUrl + "/" + CommonUsed.globalUsed.categorySearch
        return url
    }
    
    func getTrendingNowAPI(){
        
        let param = [
            // validationMessage.ticket:"klevu-158358783414411589",
            validationMessage.ticket:getSkuCode(),
            validationMessage.term:"popularproduct",
            validationMessage.paginationStartsFrom:"0",
            validationMessage.noOfResults:"12",
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
            validationMessage.resultForZero:"1"
            ] as [String : Any]
        
        let url = CommonUsed.globalUsed.KlevuMain + CommonUsed.globalUsed.kleviCloud + CommonUsed.globalUsed.klevuNSearch
        ApiManager.apiGet(url: url, params: param) {(response:JSON?, error:Error? ) in
            DispatchQueue.main.async {
                proceed()
            }
            func proceed() {
                if let error = error {
                    print(error)
                    if error.localizedDescription.contains(s: "offline") {
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    return
                }
                if response != nil{
                    let dict = response?.dictionaryObject
                    let Product = dict?["popularProducts"] as? [[String : Any]]
                    guard let values = Product else { return }
                    for item in values {
                        let imageUrl = item["imageUrl"] as? String ?? ""
                        let skuID = item["sku"] as? String ?? ""
                        let id = item["id"] as? String ?? ""
                        let price = item["price"] as? String ?? ""
                        let name = item["name"] as? String ?? ""
                        let Dictionary = [ "name" : name, "id":id, "skuID": skuID, "imagUrl":imageUrl,"price":price
                        ]
                        self.searchTrendingArr.append(Dictionary)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func klevuProductSearchApi(skutext: String){
        var delimiter = ";"
        var newstr = "token0 token1 token2 token3"
        var tempSkuArray = skutext.components(separatedBy: delimiter)
        var skuId = tempSkuArray[0]
        var arrMust = [[String:Any]]()
        
        arrMust.append(["match": ["sku":skuId]])
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        
        var dictSort = [String:Any]()
        dictSort = ["updated_at":"desc"]
        let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id"],
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
    func open() {
        let subcategoryVC = SearchSubCategoryViewController.searchSubCategoryBoardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(subcategoryVC, animated: false)
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        
        if( searching == false){
            return 1
        }
        if searchProductArray.count > 0{
            return 1
        }
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 0
        if( searching == false){
            //            return searchArrRes.count
            if SelectedCat == "women" {
                rowCount = womenArray.count
            }else if SelectedCat == "men"{
                rowCount = menArray.count
            }else if SelectedCat == "kids"{
                rowCount = kidsArray.count
            }
            return rowCount
        }else{
            if section == 0 {
                return searchProductArray.count
            }else{
                let items = self.sections[section].items
                return items.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else{return UITableViewCell()}
        
        if searching == false {
            if SelectedCat == "men" {
                
                if indexPath.row <= menArray.count-1 {
                    let arr = menArray[indexPath.row]
                    cell._lblCategoryName.text = arr.value(forKeyPath: "catName") as? String
                }
                
            } else if SelectedCat == "women" {
                if indexPath.row <= womenArray.count-1 {
                    let arr = womenArray[indexPath.row]
                    cell._lblCategoryName.text = arr.value(forKeyPath: "catName") as? String
                }
            } else if SelectedCat == "kids" {
                if indexPath.row <= kidsArray.count-1 {
                    let arr = kidsArray[indexPath.row]
                    cell._lblCategoryName.text = arr.value(forKeyPath: "catName") as? String
                }
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                cell._lblCategoryName.font = UIFont(name: "BrandonGrotesque-Light", size: 16)
            }else{
                cell._lblCategoryName.font = UIFont(name: "Cairo-Light", size: 16)
            }
            cell._line.isHidden = false
            cell._imgArrow.isHidden = false
        } else {
            
            if indexPath.section == 0 {
                cell._lblCategoryName.text = (self.searchProductArray[indexPath.row].parentCatName ?? "") + " > " + (self.searchProductArray[indexPath.row].catName  ?? "")
                //                cell._line?.isHidden = true
                //                cell._imgArrow.isHidden = true
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    cell._lblCategoryName.font = UIFont(name: "BrandonGrotesque-Light", size: 16)
                }else{
                    cell._lblCategoryName.font = UIFont(name: "Cairo-Light", size: 16)
                }
                
            }else{
                let items = self.sections[indexPath.section].items
                let item = items[indexPath.row]
                cell._lblCategoryName.text = item["name"] as? String
                cell._line?.isHidden = true
                cell._imgArrow.isHidden = true
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    cell._lblCategoryName.font = UIFont(name: "BrandonGrotesque-Light", size: 16)
                }else{
                    cell._lblCategoryName.font = UIFont(name: "Cairo-Light", size: 16)
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! CategoryTableViewCell
        let subcategoryVC = SearchSubCategoryViewController.searchSubCategoryBoardInstance!
        var titleName = ""
        if searching == false {
            var selectedProduct : ProductList = ProductList()
            if SelectedCat == "women"{
                selectedProduct  = womenArray[indexPath.row] as? ProductList ?? ProductList()
                let parentId = selectedProduct.categoryId ?? ""
                subcategoryVC.arrSubCategory =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: CommonUsed.globalUsed.genderWomen, parentId: parentId)!
            } else if SelectedCat == "men" {
                selectedProduct  = menArray[indexPath.row] as! ProductList
                let parentId = selectedProduct.categoryId ?? ""
                subcategoryVC.arrSubCategory =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: CommonUsed.globalUsed.genderMen, parentId: parentId)!
                print("Selcted men")
            }else if SelectedCat == "kids"{
                selectedProduct  = kidsArray[indexPath.row] as! ProductList
                let parentId = selectedProduct.categoryId ?? ""
                subcategoryVC.arrSubCategory =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: CommonUsed.globalUsed.genderKids, parentId: parentId)!
                print("Selcted kids")
            }
            //-------
            //add for view all design confirm Narayan sir
            if selectedProduct.linkType == "link" && !(selectedProduct.linkCatIds!.contains("{")) {
                if (SelectedCat == "women" && selectedProduct.categoryId == CommonUsed.globalUsed.viewAllDesignersWomenId) || (SelectedCat == "men" && selectedProduct.categoryId == CommonUsed.globalUsed.viewAllDesignersMenId) || ( SelectedCat == CommonUsed.globalUsed.genderKids && selectedProduct.categoryId == CommonUsed.globalUsed.viewAllDesignersKidId ) {
                    OpenAZScreen()
                }else{
                    
                    let templinkid = selectedProduct.linkCatIds
                    let validetorlinkId = templinkid?.components(separatedBy: "|")
                    let linkId  = validetorlinkId![0]
                    let nextVC = NewInVC.storyboardInstance!
                    let productName : ProductList = selectedProduct
                    if productName.genderID == CommonUsed.globalUsed.genderMen {
                        nextVC.strGen = CommonUsed.globalUsed.genderMenId
                    } else if productName.genderID == CommonUsed.globalUsed.genderWomen {
                        nextVC.strGen = CommonUsed.globalUsed.genderWomenId
                    } else if productName.genderID == CommonUsed.globalUsed.genderKids {
                        nextVC.strGen = CommonUsed.globalUsed.genderKidsId
                    }
                    //nextVC.strGen = productName.genderID!
                    nextVC.headlingLbl = productName.catName!
                    nextVC.categoryName = productName.catName!
                    nextVC.cat_id = Int(linkId)!
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
            } else if subcategoryVC.arrSubCategory.count < 1 {
                let nextVC = NewInVC.storyboardInstance!
                let productName : ProductList = selectedProduct
                if productName.genderID == CommonUsed.globalUsed.genderMen {
                    nextVC.strGen = CommonUsed.globalUsed.genderMenId
                } else if productName.genderID == CommonUsed.globalUsed.genderWomen {
                    nextVC.strGen = CommonUsed.globalUsed.genderWomenId
                } else if productName.genderID == CommonUsed.globalUsed.genderKids {
                    nextVC.strGen = CommonUsed.globalUsed.genderKidsId
                }
                //nextVC.strGen = productName.genderID!
                nextVC.headlingLbl = productName.catName!
                nextVC.categoryName = productName.catName!
                nextVC.cat_id = Int(productName.categoryId ?? "0")!
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else {
                titleName = currentCell._lblCategoryName.text!
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                subcategoryVC.TopTitleName = titleName.uppercased()
                navigationController?.view.layer.add(transition, forKey: kCATransition)
                navigationController?.pushViewController(subcategoryVC, animated: false)
            }
        } else {
            //for recent treand
            if self.sections[indexPath.section].name == validationMessage.TRENDING_SEARCHES.localized   {
                //go PDP page
                if let skuId = searchTrendingArr[indexPath.row]["skuID"] {
                    klevuProductSearchApi(skutext: skuId as? String ?? "")
                }
            } else {
                //for recent search
                txtFieldSearch.text = currentCell._lblCategoryName.text ?? ""
                if txtFieldSearch.text!.length > 2 {
                    loadCategoryViewAfterSearch()
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if( searching == false){
            return ""
        }
        return self.sections[section].name
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if language == "ar" {}
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searching == false {
            return UITableViewAutomaticDimension
        }
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 56
        }
        else {
            return 56
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searching == false {
            return nil
        }else{
            // Create the view.
            let headerView = UIView()
            //             var headerView = UIView(frame: CGRect(x: 0, y: 20, width: tableView.bounds.size.width, height: 60))
            //
            //
            //
            //            headerView.backgroundColor = .clear
            //            // Create the label that goes inside the view.
            //            var headerLabel = UILabel(frame: CGRect(x: 0, y: 20, width: tableView.bounds.size.width, height: 30))
            //            if section == 1 && recentArr.count < 1{
            //                           headerLabel.frame =  CGRect(x: 0, y: 40, width: tableView.bounds.size.width, height: 60)
            //                       }
            var headerLabel = UILabel(frame: CGRect(x: 0, y: 18, width: tableView.bounds.size.width, height: 20))
            
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en" {
                headerLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 14)
            }else{
                headerLabel.font = UIFont(name: "Cairo-SemiBold", size: 14)
            }
            
            headerLabel.textColor = .white
            headerLabel.text = self.sections[section].name ?? ""
            let attributedString = NSMutableAttributedString(string: headerLabel.text ?? "")
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSRange(location: 0, length: headerLabel.text!.count))
            headerLabel.attributedText = attributedString
            
            //headerLabel.sizeToFit()
            //  headerView.frame = headerLabel.frame
            // Add label to the view.
            if( language == "ar" ){
                headerLabel.textAlignment = NSTextAlignment.right
            }
            headerView.addSubview(headerLabel)
            
            // Return view.
            return headerView
        }
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight:CGFloat = 80.0
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsets(top: -CGFloat(sectionHeaderHeight), left: 0, bottom: 0, right: 0);
        }
    }
    
    func loadPLPPage() {
        
    }
}
extension SearchViewController: SearchCollectionViewControllerDelegate {
    
    
    func loadPDPPageForCatId(product: Dictionary<String, Any>, atIndex: IndexPath, cell: SearchCollectionTableViewCell) {
        
    }
    
    func selectedProduct(product:ProductList, atIndex:IndexPath, cell: SearchCategoryTableViewCell) {
        
        if product.parentCatId == "0" {
            let subcategoryVC = SearchSubCategoryViewController.searchSubCategoryBoardInstance!
            var titleName = ""
            
            let selectedProduct : ProductList = product as? ProductList ?? ProductList()
            let parentId : String = selectedProduct.categoryId ?? ""
            subcategoryVC.arrSubCategory =  CoreDataManager.sharedManager.fetchProductNewDataForCatogery(rootCategoryName: SelectedCat, parentId: parentId) ?? [ProductList]()
            
            titleName = (selectedProduct.catName ?? "").uppercased()
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            subcategoryVC.TopTitleName = titleName
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(subcategoryVC, animated: false)
        } else {
            let productName : ProductList = product as? ProductList ?? ProductList()
           //add for view all design confirm Narayan sir
            if (productName.genderID == CommonUsed.globalUsed.genderWomen && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersWomenId) || (productName.genderID == CommonUsed.globalUsed.genderMen && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersMenId) || ( productName.genderID == CommonUsed.globalUsed.genderKids && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersKidId ){
                OpenAZScreen()
           }else{
          
             let nextVC = NewInVC.storyboardInstance!
            if productName.genderID == CommonUsed.globalUsed.genderMen {
                nextVC.strGen = CommonUsed.globalUsed.genderMenId
            } else if productName.genderID == CommonUsed.globalUsed.genderWomen {
                nextVC.strGen = CommonUsed.globalUsed.genderWomenId
            } else if productName.genderID == CommonUsed.globalUsed.genderKids {
                nextVC.strGen = CommonUsed.globalUsed.genderKidsId
            }
            
            nextVC.headlingLbl = productName.catName ?? ""
            nextVC.categoryName = productName.catName!
            if productName.linkType == "link" && !(productName.linkCatIds!.contains("{")) {
                let templinkid = productName.linkCatIds
                let validetorlinkId = templinkid?.components(separatedBy: "|")
                let linkId  = validetorlinkId![0]
                nextVC.cat_id = Int(linkId)!
                
            }else{
                  nextVC.cat_id = Int(productName.categoryId!)!
            }
           // nextVC.cat_id = Int(productName.categoryId ?? "0") ?? 0
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        }
    }
    func OpenAZScreen(){
        self.dismiss(animated: true, completion: {
                   NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 1)
               })
    }
}
