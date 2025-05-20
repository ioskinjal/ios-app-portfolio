//
//  HomeVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
var mealType:String?
class HomeVC: BaseViewController {

    static var storyboardInstance:HomeVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: HomeVC.identifier) as? HomeVC
    }
    var arrRecommendationList : [RecommendedList] = []
    var arrBoolCustomization: [Bool] = []
    var arrCustomization = [CustomizationList]()
    var arrPopularList : [RecommendedList] = []
    var selectedTag:Int = 0
    var selectedTagCustom:Int = 0
    var arrItemSelected:NSMutableArray = []
    @IBOutlet weak var viewBlank: UIView!
    @IBOutlet weak var tblCustHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewCustomization: UIView!
    @IBOutlet weak var tblCustomization: UITableView!{
        didSet{
            tblCustomization.register(CustomizationCell.nib, forCellReuseIdentifier: CustomizationCell.identifier)
            tblCustomization.dataSource = self
            tblCustomization.delegate = self
            tblCustomization.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var collectionViewFavoriteHeightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRecommendation: UICollectionView!{
        didSet{
            collectionViewRecommendation.delegate = self
            collectionViewRecommendation.dataSource = self
            collectionViewRecommendation.register(RecommendationCell.nib, forCellWithReuseIdentifier: RecommendationCell.identifier)
        }
    }
    @IBOutlet weak var collectionViewFavorite: UICollectionView!{
        didSet{
            collectionViewFavorite.delegate = self
            collectionViewFavorite.dataSource = self
            collectionViewFavorite.register(FavoriteCuisinesCell.nib, forCellWithReuseIdentifier: FavoriteCuisinesCell.identifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrItemSelected = NSMutableArray()
        callgetRecommendationsCuisines()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "", action: #selector(onClickMenu(_:)))
       setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.setAutoHeight()
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
       // self.navigationBar.lblCount.text = String(format: "%d", (UserData.shared.getUser()!.cart_items_count))
        callgetRecommendationsCuisines()
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func callgetRecommendationsCuisines(){
        let user = UserData.shared.getUser()
        var param = [String:String]()
        if user != nil {
            param = ["uid":UserData.shared.getUser()!.user_id]
        }else{
            param = ["token_id":UserData.shared.deviceToken]
        }
        Modal.shared.getrecommendationcuisines(vc: self, param: param) { (dic) in
            print(dic)
            self.viewBlank.isHidden = true
             let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            var count:Int = data["cart_items_count"] as! Int
            UserDefaults.standard.set(count, forKey: "cartCount")
             UserDefaults.standard.synchronize()
            self.navigationBar.lblCount.text = String(format: "%d", count)
            
           
            self.arrRecommendationList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .recommended).map({RecommendedList(dic: $0 as! [String:Any])})
            self.arrPopularList = ResponseKey.fatchDataAsArray(res: dic["data"] as! dictionary, valueOf: .popular).map({RecommendedList(dic: $0 as! [String:Any])})
            if self.arrRecommendationList.count != 0 {
                self.collectionViewRecommendation.reloadData()
               
            }
            if self.arrPopularList.count != 0{
                self.collectionViewFavorite.reloadData()
                self.setAutoHeight()
            }
            
        }
    }
    @objc func onClickMenu(_ sender: UIButton){
       sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @objc func onClickCart(_ sender: UIButton){
       let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collectionViewFavoriteHeightConst.constant = self.collectionViewFavorite.contentSize.height
            self.collectionViewFavorite.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UiButton Click Events
    
    @IBAction func onClickSeeAll(_ sender: UIButton) {
        let nextVC = MenuListVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickCloseCust(_ sender: UIButton) {
         self.navigationBar.isHidden = false
        self.viewCustomization.isHidden = true
    }
    
    @IBAction func onClickAddToCart(_ sender: UIButton) {
        isFromMenu = true
        let user = UserData.shared.getUser()
        var strDeliveryDate:String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let date = Date()
        strDeliveryDate = dateFormatter.string(from: date)
        let strCustomId = arrItemSelected.componentsJoined(by: ",")
      //  let strCustomId = arrItemSelected.componentsJoined(by: ",")
                var param =  [String:Any]()
                if user != nil {
                    param = ["uid":UserData.shared.getUser()!.user_id,
                             "item_id":arrRecommendationList[selectedTag].itemID!,
                             "date":strDeliveryDate,
                             "customization_item_id":strCustomId]
                }else{
                    param = ["token_id":UserData.shared.deviceToken,
                             "item_id":arrRecommendationList[selectedTag].itemID!,
                             "date":strDeliveryDate,
                             "customization_item_id":strCustomId]
                }
                Modal.shared.addToCart(vc: self, param: param) { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.callgetRecommendationsCuisines()
                         self.navigationBar.isHidden = false
                        
                        self.viewCustomization.isHidden = true
                        self.arrItemSelected = NSMutableArray()
                        if UserDefaults.standard.value(forKey: "cartCount") != nil{
                        let count = UserDefaults.standard.value(forKey: "cartCount") as! Int
                        self.navigationBar.lblCount.text = String(format: "%d", count+1)
                            UserDefaults.standard.set(count, forKey: "cartCount")
                            UserDefaults.standard.synchronize()
                        }
                    })
                }
    }
    
    

}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewRecommendation {
            return arrRecommendationList.count
        }else{
            return arrPopularList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewRecommendation {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCell.identifier, for: indexPath) as? RecommendationCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblProductName.text = arrRecommendationList[indexPath.row].itemName
            cell.imgProduct.downLoadImage(url: arrRecommendationList[indexPath.row].itemImage!)
            cell.lblPrice.text = "Rs " + arrRecommendationList[indexPath.row].itemPrice!
            cell.btnCart.tag = indexPath.row
            cell.btnCart.addTarget(self, action: #selector(onClickAddToCart1(_:)), for: .touchUpInside)
            
        return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCuisinesCell.identifier, for: indexPath) as? FavoriteCuisinesCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.lblProductName.text = arrPopularList[indexPath.row].itemName
            cell.imgProduct.downLoadImage(url: arrPopularList[indexPath.row].itemImage!)
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
            
        }
    }
    
    @objc func onClickAddToCart1(_ sender:UIButton) {
        if self.arrRecommendationList[sender.tag].isItemCustomizable == true {
        arrItemSelected = NSMutableArray()

        arrCustomization = [CustomizationList]()

            self.arrCustomization = self.arrRecommendationList[sender.tag].customizationList
        if self.arrCustomization.count != 0{
        self.arrCustomization[0].customizationItemList[0].isSelected = true
        }
        for _ in self.arrCustomization {
            if arrCustomization.count == 1 {
                self.arrBoolCustomization.append(true)
                selectedTagCustom = 0
            }else{
            self.arrBoolCustomization.append(false)
            }
        }
        selectedTag = sender.tag
        self.navigationBar.isHidden = true
        viewCustomization.isHidden = false
        isFromMenu = true
        tblCustomization.reloadData()
        autoDynamicHeight()
        }else{
            let user = UserData.shared.getUser()
            var strDeliveryDate:String = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let date = Date()
            strDeliveryDate = dateFormatter.string(from: date)
            //  let strCustomId = arrItemSelected.componentsJoined(by: ",")
            var param =  [String:Any]()
            if user != nil {
                param = ["uid":UserData.shared.getUser()!.user_id,
                         "item_id":arrRecommendationList[sender.tag].itemID!,
                         "date":strDeliveryDate,
                         "customization_item_id":""]
            }else{
                param = ["token_id":UserData.shared.deviceToken,
                         "item_id":arrRecommendationList[sender.tag].itemID!,
                         "date":strDeliveryDate,
                         "customization_item_id":""]
            }
            Modal.shared.addToCart(vc: self, param: param) { (dic) in
                print(dic)
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callgetRecommendationsCuisines()
                    self.navigationBar.isHidden = false
                    self.viewCustomization.isHidden = true
                })
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewFavorite {
       mealType = arrPopularList[indexPath.row].mealType
        let nextVC = MenuListVC.storyboardInstance!
        nextVC.selectedCuisin = arrPopularList[indexPath.row].itemName
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == collectionViewRecommendation {
        return CGSize(width:260, height: 181)
         }else{
             return CGSize(width:collectionView.frame.size.width/2-5, height: 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionViewRecommendation {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }else{
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationCell.identifier) as? CustomizationCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblName.text = (arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemName) + " - " + (arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemPrice)
        if arrCustomization[indexPath.section].customizationType == "2" || arrCustomization[indexPath.section].customizationType == "3"  {
            if indexPath.row == 0{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
                arrItemSelected.add(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
            }else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
            }
            
        }else if arrCustomization[indexPath.section].customizationType == "4" || arrCustomization[indexPath.section].customizationType == "1"  {
            if arrCustomization[indexPath.section].customizationItemList[indexPath.row].isSelected == true {
                cell.btnCheck.setImage(#imageLiteral(resourceName: "radio-icon-fill"), for: .normal)
                arrItemSelected.add(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
            } else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "radio-icon"), for: .normal)
                arrItemSelected.remove(arrCustomization[indexPath.section].customizationItemList[indexPath.row].customizationItemID)
            }
        }
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
            
            return cell
        }
    
    @objc func onClickCheck(_ sender:UIButton){
        
        let button:UIButton = sender
        if arrCustomization[selectedTagCustom].customizationType == "4" || arrCustomization[selectedTagCustom].customizationType == "1" {
            
            let list:Int = arrCustomization[selectedTagCustom].customizationItemList.count
            for i in 0..<list {
                
                if arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemName == arrCustomization[selectedTagCustom
                    ].customizationItemList[i].customizationItemName {
                    if arrCustomization[selectedTagCustom].customizationType == "1" {
                        if arrCustomization[selectedTagCustom].customizationItemList[i].isSelected == true{
                            arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = false
                        }else{
                            arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = true
                        }
                    }else{
                        arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = true
                    }
                }else{
                    arrCustomization[selectedTagCustom].customizationItemList[i].isSelected = false
                }
            }
            
            
            
            tblCustomization.reloadData()
            
        }else if arrCustomization[selectedTagCustom].customizationType == "2" || arrCustomization[selectedTagCustom].customizationType == "3"  {
            
            if button.currentImage == #imageLiteral(resourceName: "checkbox_checked") {
                
                
                
                if arrCustomization[selectedTagCustom].customizationType == "3"{
                    let list:Int = arrCustomization[selectedTagCustom].customizationItemList.count
                    let selectedArray = arrCustomization[selectedTagCustom].customizationItemList.filter({$0.isSelected==true})
                    if selectedArray.count == 1{
                        let i = arrCustomization[selectedTagCustom].customizationItemList.index(of: selectedArray.first!)
                        if sender.tag == i {
                            return
                        }
                    }else{
                        button.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
                        arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = false
                        arrItemSelected.remove(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
                    }
                    //for type "2" "3"
                }else{
                    button.setImage(#imageLiteral(resourceName: "checkbox_unchecked"), for: .normal)
                    arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = false
                    arrItemSelected.remove(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
                }
            }else{
                button.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
                arrCustomization[selectedTagCustom].customizationItemList[sender.tag].isSelected = true
                arrItemSelected.add(arrCustomization[selectedTagCustom].customizationItemList[sender.tag].customizationItemID)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (arrBoolCustomization[section]) {
                return (arrCustomization[section].customizationItemList.count)
            }else{
                return 0
            }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return arrCustomization.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let viewHeaderMain = UIView(frame: CGRect(x: 0, y: 0, width: tblCustomization.frame.size.width, height: 60))
            viewHeaderMain.backgroundColor = UIColor.clear
            
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: viewHeaderMain.frame.size.width, height: viewHeaderMain.frame.size.height - 10))
            let viewSeprator =  UIView(frame: CGRect(x: 0, y: viewHeader.frame.size.height-1, width: tblCustomization.frame.size.width, height:1))
            viewSeprator.backgroundColor = UIColor.lightGray
            viewHeader.addSubview(viewSeprator)
            viewHeaderMain.addSubview(viewHeader)
            viewHeaderMain.tag = section
            
            viewHeader.backgroundColor = UIColor.white
            
            let imgViewArrow = UIImageView(frame: CGRect(x: viewHeader.frame.size.width - 20, y: 20, width: 10, height: 6))
            viewHeader.addSubview(imgViewArrow)
            
            if (arrBoolCustomization[section]) {
                imgViewArrow.image = #imageLiteral(resourceName: "up-arrow-ico")
                imgViewArrow.frame = CGRect(x: viewHeader.frame.size.width - 20, y: 17, width: 10, height: 6)
            } else {
                imgViewArrow.image = #imageLiteral(resourceName: "down-arrow-ico")
            }
            let lblHeaderTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tblCustomization.bounds.size.width - 50, height: 50))
            
            lblHeaderTitle.textColor = UIColor.black
            lblHeaderTitle.text = arrCustomization[section].customizationName
            viewHeader.addSubview(lblHeaderTitle)
            
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.headerSectionTapped(_:)))
            
            viewHeaderMain.addGestureRecognizer(headerTapped)
            
            return viewHeaderMain
        
    }
    
    @objc func headerSectionTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
        
            var indexPath = IndexPath(row: 0, section: gestureRecognizer!.view!.tag)
            selectedTagCustom = indexPath.section
            let collapsed: Bool = arrBoolCustomization[indexPath.section]
            var sectionno: Int = 0
            if indexPath.row == 0 {
                for i in 0..<arrBoolCustomization.count {
                    if (arrBoolCustomization[i]) == true {
                        sectionno = i
                    }
                    arrBoolCustomization[i] = false
                }
                for i in 0..<arrCustomization.count {
                    if indexPath.section == i {
                        arrBoolCustomization[indexPath.section] = !collapsed ? true : false
                    }
                }
                
                // [arrData replaceObjectAtIndex:indexPath.section withObject:dict];
                
                tblCustomization.reloadData()
                autoDynamicHeight()
            }
    }
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblCustHeightConst.constant = self.tblCustomization.contentSize.height
            self.view.layoutIfNeeded()
        }
    }

}
