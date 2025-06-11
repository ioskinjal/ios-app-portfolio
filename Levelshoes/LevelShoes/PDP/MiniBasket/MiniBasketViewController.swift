//
//  MiniBasketViewController.swift
//  LevelShoes
//
//  Created by Naveen Wason on 14/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import BottomPopup
import CoreData
import MBProgressHUD
import Firebase
import Adjust

class MiniBasketViewController: BottomPopupViewController {
    
    @IBOutlet weak var lblHeaderAddedtobag: UILabel!{
        didSet{
            lblHeaderAddedtobag.text = "Added to your bag".localized
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueshoppingBtnOutlet: UIButton!{
        didSet{
            continueshoppingBtnOutlet.setTitle("CONTINUE SHOPPING".localized, for: .normal) //#000000
            continueshoppingBtnOutlet.addTextSpacing(spacing: 1.5, color: Common.blackColor)
        }
    }
    @IBOutlet weak var goToBagBtnOutlet: UIButton!{
        didSet{
            goToBagBtnOutlet.setTitle("GO TO BAG".localized, for:.normal) //GO TO BAG
            goToBagBtnOutlet.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }
    var data: Array<Any> =  Array<Any>()
    var itemDict:[String:Any]  = [:]
    var height: CGFloat = 574
    var sizeArray:Array<Any> = Array<Any>()
    //var sizePickerView = UIPickerView()
    //var toolbar = UIToolbar()

    var selectedSize: String?
    var requseQty: Int = 1
    var isSizeStatus: Bool?
    
    var selectedProduct:[String:Any] = [:]
   // var cartData:Cart?
    
    
    let viewModel = MiniBasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAttributeeData()
        let cells =
            [MinibasketTableViewCell.className]
        tableView.register(cells)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(nil,forKey: "quote_id_to_convert")
        //print("BASKET \(itemDict["badge_name"]) and \(itemDict["size"] as? String)")
        if let size:String = itemDict["size"] as? String {
            sizeArray = size.split(separator: "\t")
        }
        
        
        if selectedProduct.count == 0 {
            return
        }
       // cartData =  CoreDataManager.getDataByID(entity: "Cart", data: selectedProduct)?.first  as? Cart
       // print("name", cartData?.productName ?? "")
        
        self.tableView.reloadData()
        updateValues()
    }
//    override func viewDidLayoutSubviews() {
//        continueshoppingBtnOutlet.layer.cornerRadius = 4
//        continueshoppingBtnOutlet.layer.borderWidth = 1
//        continueshoppingBtnOutlet.layer.borderColor = UIColor.black.cgColor
//    }
    
    
    func updateValues() {
        self.viewModel.cartUpdated = {(type, response) in
            if type == "updateCart"{
                print("response",response)
            }else if type == "getCart"{
               // self.setCartData(response as! CartModel)
            }
        }
    }
    
    override func getPopupHeight() -> CGFloat {
        return height
    }
    func showPickerView() {
       /* sizePickerView.delegate = self
        sizePickerView.backgroundColor = UIColor.white
        sizePickerView.setValue(UIColor.black, forKey: "textColor")
        sizePickerView.autoresizingMask = .flexibleWidth
        sizePickerView.contentMode = .center
        sizePickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sizePickerView)

        self.addToolbar()
        self.view.addSubview(toolbar)*/
    }
    func addToolbar(){
        /*toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonClicked))]*/
    }
    @objc func doneButtonClicked(_ sender:Any){
        self.tableView.reloadData()
       // self.sizePickerView.removeFromSuperview()
       // self.toolbar.removeFromSuperview()
    }
    
    @IBAction func goToBagBtnAction(_ sender: UIButton) {
        //self.tabBarController?.selectedIndex = 4
        // Google Analytics -Add a product into shopping cart
        
        if UserDefaults.standard.value(forKey: "language")as? String != "ar"{
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 4)
            })
        }
        else{
            self.dismiss(animated: true, completion: {
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                if let wTB = (  UIApplication.shared.keyWindow?.rootViewController as? UITabBarController ) {
                    if let wVCs = wTB.viewControllers {
                        for (index, element) in wVCs.enumerated() {
                            print("Item \(index): \(element)")
                            if let nav = element as? UINavigationController {
                                if nav.visibleViewController is ShoppingBagVC{
                                    NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: index)
                                }
                            }
                        }
                    }
                }
                else {
                    if let navCtr = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                        let vc = navCtr.viewControllers
                        for (_, element) in vc.enumerated() {
                            if let tabCtr = element as? UITabBarController {
                                if let wVCs = tabCtr.viewControllers {
                                    for (index, element) in wVCs.enumerated() {
                                        print("Item \(index): \(element)")
                                        if let nav = element as? UINavigationController {
                                            if nav.visibleViewController is ShoppingBagVC{
                                                NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: index)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }

    @IBAction func continueShoppingBtnAction(_ sender: UIButton) {
        //shoppig
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension MiniBasketViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 230
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MinibasketTableViewCell", for: indexPath) as? MinibasketTableViewCell else{return UITableViewCell()}
        cell.delegate = self
       
        let dictAtrb = itemDict["product_option"] as? [String:Any] ?? [String:Any]()
        let arrAtrb = dictAtrb["extension_attributes"]as? [String:Any] ??  [String:Any]()
        let arrconfig = arrAtrb["configurable_item_options"]as? [[String:Any]] ??  [[String:Any]]()
        cell.setCartValue(self.itemDict)
         cell.headingLabel.text = getBrandName(id: "\(itemDict["manufacturer"]!)")
        cell.cellConfiguration(cellno: indexPath.row, size: selectedSize ?? "", qty: requseQty ?? 1, isCurrentState: isSizeStatus ?? false)
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnPrev)
             Common.sharedInstance.backtoOriginalButton(aBtn: cell.btnNext)
        }
        else{
            Common.sharedInstance.rotateButton(aBtn: cell.btnPrev)
             Common.sharedInstance.rotateButton(aBtn: cell.btnNext)
        }
        return cell
    }
    
    
    func fetchAttributeeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("colorArray", designData.count)
        }
        
        
         for j in 0..<designData.count{
             let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
             
             designDetail.append(array[k])
             }
         }
    
        let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
              designDetail = sorteddesignDetail
        
        let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
        for i in 0..<designDetail.count{
            for j in arrColorNm{
                if designDetail[i].label == j{
                    designDetail[i].isSelected = true
                }
            }
        }
        
        for i in 0..<designDetail.count{
            objList.append(designDetail[i].label)
        }
        objattrList = objList
       
    }
    func getBrandName(id:String) -> String{
          var strBrand = ""
          for i in 0..<(designDetail.count){
             if id == "\(designDetail[i].value)"{
              strBrand = designDetail[i].label
             }
          }
          return strBrand.uppercased()
      }
}
extension MiniBasketViewController: MiniBasketProtocol{
    func previousAction(_ cell: MinibasketTableViewCell) {
        var  updateRequseQty = Int(cell.qtyValue ?? 0)
        var params:[String:Any] = [:]
        params["sku"] = itemDict["sku"]
        params["qty"] = updateRequseQty ?? 1
        params["product_option"] = itemDict["product_option"]
        
        params["item_id"] = itemDict["item_id"]
        //   params["qty"] = cartItems[selectedItem].qty
        
        var extension_attributes:[String:Any] = [:]
        extension_attributes["option_id"] = itemDict["attributeID"]
        extension_attributes["option_value"] = itemDict["selectedSize"]    //itemDict["size"]
        
        var   configurable_item_options = ["configurable_item_options" : [extension_attributes]]
        var productOption:[String:Any] = [:]
        productOption["extension_attributes"] = configurable_item_options
        
        
        params["product_option"] = productOption
        
        if(M2_isUserLogin){
            params["quote_id"] = itemDict["quote_id"]
        }
        else{
            params["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.updateCartItem(params: params, success: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let errorMessage = (response as? [String:Any])?["message"] {
             
               
                let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage as? String ?? "", preferredStyle: UIAlertControllerStyle.alert)
                           alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                           self.present(alert, animated: true, completion: nil)
                          
            }else{
            DispatchQueue.main.async {
                self.requseQty = updateRequseQty
                self.tableView.reloadData()
            }
        }
            print(response)
        }) {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
    func nextAction(_ cell: MinibasketTableViewCell) {
        
        var  updateRequseQty = Int(cell.qtyValue ?? 0)
        var params:[String:Any] = [:]
        params["sku"] = itemDict["sku"]
        params["qty"] = updateRequseQty ?? 1
        params["product_option"] = itemDict["product_option"]
        
        params["item_id"] = itemDict["item_id"]
        //   params["qty"] = cartItems[selectedItem].qty
        
        var extension_attributes:[String:Any] = [:]
        extension_attributes["option_id"] = itemDict["attributeID"]
        extension_attributes["option_value"] = itemDict["selectedSize"]    //itemDict["size"]
        
        var   configurable_item_options = ["configurable_item_options" : [extension_attributes]]
        var productOption:[String:Any] = [:]
        productOption["extension_attributes"] = configurable_item_options
        
        
        params["product_option"] = productOption
        
        if(M2_isUserLogin){
            params["quote_id"] = itemDict["quote_id"]
        }
        else{
            params["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.updateCartItem(params: params, success: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let errorMessage = (response as? [String:Any])?["message"] {
                var qty = updateRequseQty - 1
                cell.qtyValue = qty
                cell.qtyLabel.text = "\(qty ?? 0)"
                let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage as? String ?? "", preferredStyle: UIAlertControllerStyle.alert)
                           alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                           self.present(alert, animated: true, completion: nil)
                          
            }else{
            DispatchQueue.main.async {
                self.requseQty = updateRequseQty
                self.tableView.reloadData()
            }
        }
            
            print(response)
        }) {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
   
    func changeSizeAction(Index: Int) {
//        self.showPickerView()
        if data.count > 1 {
        let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
        let changeVC: SizeSelectionViewController
        changeVC = storyboard.instantiateViewController(withIdentifier: "SizeSelectionViewController") as! SizeSelectionViewController
        changeVC.data = data
          
     //   changeVC.cartData = cartData
        changeVC.sizeArray = sizeArray
        changeVC.itemDict = self.itemDict
            changeVC.selectedSize = self.selectedSize!
            changeVC.requseQty = self.requseQty
          
        changeVC.delegate = self
        self.present(changeVC, animated: true, completion: nil)
        //self.navigationController?.present(changeVC, animated: true, completion: nil)
        }
    }
}
extension MiniBasketViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row] as! String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSize = sizeArray[row] as! String
    }
}

extension MiniBasketViewController: SizeSelectionDelegate{
    func reloadSize(withSize: String, qty: Int) {
        self.selectedSize = withSize
        self.requseQty = qty
        self.tableView.reloadData()
    }
}
