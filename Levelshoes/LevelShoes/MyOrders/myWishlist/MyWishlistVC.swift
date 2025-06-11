//
//  MyWishlistVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 11/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyWishlistVC: UIViewController,mywishlistCellDelegae {
    var productData : NewInData?
     var myWishList = [WishlistModel]()
    var deleteCell = mywishlistCell.self
  //  var isEditMode : Bool = false
     @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var lblWishlistEmpty: UILabel!{
        didSet{
            lblWishlistEmpty.addTextSpacing(spacing: 1.0)
        }
    }
    @IBOutlet weak var lblGetInspired: UILabel!{
        didSet{
            lblGetInspired.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblMsg: UILabel!{
        didSet{
            lblMsg.addTextSpacing(spacing: 0.5)
        }
    }

    var txtRemoveItemsHeader = ""
    var txtRemoveItemsDesc = ""
    @IBOutlet weak var viewEmpetyWishlistIndicator: UIView!
    
    @IBOutlet weak var lblEdit: UILabel!{
        didSet {
            let strDont:String = "Edit".localized
            lblEdit.attributedText = underlinedString(string: strDont as NSString, term: "Edit" as NSString)
        }
    }
    @IBOutlet weak var lblWishlistHeader: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblWishlistHeader.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var btnGetinspired: UIButton!{
        didSet{
            btnGetinspired.underline()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         txtRemoveItemsHeader = "Remove  items"
        txtRemoveItemsDesc = "wishlist_removeItems".localized

        print("Wishlist Count \(myWishList.count)")

       
      
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           txtRemoveItemsHeader = "Remove items"
             txtRemoveItemsDesc = "wishlist_removeItems".localized

             print("Wishlist Count \(myWishList.count)")

             viewEmpetyWishlistIndicator.isHidden = myWishList.count == 0 ? false : true
        if myWishList.count > 0 {
                 lblWishlistHeader.text =  ("WISHLIST ( \(myWishList.count) ) ")
              }else{
              lblWishlistHeader.text =  ("WISHLIST")
              }
        self.getMyWishList()
    }
    func underlinedString(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: string as String)
        let underlineRange = string.range(of: term as String)
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)

        return output
    }
    // MARK: - IBAction buttons
    @IBAction func closeSelector(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnEditSelector(_ sender: UIButton) {
           print("Remove from bag")
       // isEditMode = !isEditMode
        
        self.wishListTableView.reloadData()
    }
    func deleteItem(cell:mywishlistCell){
          let alert = UIAlertController(title: txtRemoveItemsHeader, message:txtRemoveItemsDesc , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove".localized, style: .default, handler: { action in
                       var param = ["product_id":cell.myWishList.product_id, "sku":cell.myWishList.product.sku]
                      MBProgressHUD.showAdded(to: self.view, animated: true)
                                 ApiManager.removeWishList(params: param, success: { (response) in
                                            print(response)
                                  MBProgressHUD.hide(for: self.view, animated: true)
                                    let indexPath : IndexPath =  self.wishListTableView.indexPath(for: cell)!
                                    UIView.animate(withDuration: 0.30, animations: {
                                        cell.alpha = 0.0
                                    }) { finished in
                                        cell.isHidden = true
                                        self.myWishList.remove(at: indexPath.row)
                                        self.wishListTableView.beginUpdates()
                                        self.wishListTableView.deleteRows(at: [indexPath], with:.top)
                                        self.wishListTableView.endUpdates()
                                    }
                                  self.viewEmpetyWishlistIndicator.isHidden = self.myWishList.count == 0 ? false : true
                                  if self.myWishList.count > 0 {
                                      self.lblWishlistHeader.text =  ("WISHLIST ( \(self.myWishList.count) ) ")
                                               }else{
                                      self.lblWishlistHeader.text =  ("WISHLIST")
                                               }
                                    // self.getMyWishList()
                                        }) {
                                            
                                        }
                   }))
                   
            //        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            //        subview.backgroundColor = colorNames.alertBackground
            //        alert.view.tintColor = UIColor.white
                   self.present(alert, animated: true)
          
        
         
    }
   
        func removeWishList(cell:mywishlistCell){
            deleteItem(cell: cell)
        }
        func addToBag(cell:mywishlistCell){
           // getParentSkuDetail(skuId:cell.myWishList.product.sku)
            klevuProductSearchApi(skutext: cell.myWishList.product.sku, moveScreen: "AddToBag")
        }
    
    func getMyWishList()  {
    let param = [
        "customer_id": UserDefaults.standard.value(forKey: "customerId")!
        ] as [String : Any]
    MBProgressHUD.showAdded(to: self.view, animated: true)
    ApiManager.getWishList(params: param, success: { (response ) in
        print(response)
         MBProgressHUD.hide(for: self.view, animated: true)
        if response != nil{
            self.myWishList = []
            if let data = response  as? [AnyObject]{
                for wislistitem in data{
                    var productModel = WishlistModel()
                    productModel = productModel.getWishlistModel(dict: wislistitem as! [String : AnyObject])
                    self.myWishList.append(productModel)
                }
            }
        self.myWishList =  getSortedWishList(wishList: self.myWishList)
        DispatchQueue.main.async {
            self.wishListTableView.reloadData()
        }
    }
    }) {
        
    }
    }
    
    
    func getParentSkuDetail(skuId:String){
        
        let url = getProductUrl()
        let  param = ["_source":["id","size_options","size","image","manufacturer","configurable_children.stock",
                                 "configurable_children.size","configurable_children.sku","configurable_options","sku"],
                      "query":["bool":
                        ["must":
                            [
                                ["terms":["sku":[skuId]]
                                ]
                            ]
                        ]
            ]
            ]as [String : Any]
        self.magentoApiCallForProduct(url:url,param:param,controller:self,skuId: skuId)
    }
    func magentoApiCallForProduct(url:String,param : Any , controller:UIViewController,skuId:String){
        MBProgressHUD.showAdded(to: view, animated: true)
        ApiManager.apiPost(url: url, params: param as! [String : Any]) { (response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    controller.present(nextVC, animated: true, completion: nil)
                    
                }
                controller.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil{
                var dict = [String:Any]()
                print("magentoApiCallForProduct===========>",response)
                dict["data"] = response?.dictionaryObject
                self.productData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                self.getConfigurationForeSkuId(skuId: skuId)
                
            }
        }
        
    }
   

    
    func getConfigurationForeSkuId(skuId:String){
        var skuData = [String : [String:Any]]()
        var skuSourseData = [String : Any]()
        for i in 0..<(productData!.hits?.hitsList.count)!{
            var histList = productData!.hits?.hitsList[i]._source?.configurable_children
            for j in 0..<(histList!.count) {
                var skuDatavalue = histList![j] as! [String : Any]
                skuData[skuDatavalue["sku"] as! String] = histList![j] as! [String : Any]
                skuSourseData[skuDatavalue["sku"] as! String] = productData!.hits!.hitsList[i]._source!
            }
        }
        
        openSizepopUP(source:skuSourseData[skuId] as! Hits.Source?)
    }

   
    func openSizepopUP(source:Hits.Source?){
        let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
        let changeVC: AddToBagPopUp
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddToBagPopUp") as! AddToBagPopUp
        changeVC.comingScreen = "ShoppingBagVC"
       // changeVC.delegate = self
       // changeVC.cartItems = self.cartItems
        changeVC.cart_source_data = source  //productData?.hits?.hitsList[cell.rowNumber!]._source
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    @IBAction func getInspiredSelector(_ sender: UIButton) {
        print("Open Get inspired")
        self.dismiss(animated: true, completion: {
           NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 0)
        })

    }
    @IBAction func btnRemoveSelector(_ sender: UIButton) {
        print("Remove from bag")
           let alert = UIAlertController(title: txtRemoveItemsHeader, message:txtRemoveItemsDesc , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove".localized, style: .default, handler: { action in
               print("Remove from Table API ")
           }))
           
    //        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
    //        subview.backgroundColor = colorNames.alertBackground
    //        alert.view.tintColor = UIColor.white
           self.present(alert, animated: true)

    }
        
}
extension MyWishlistVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWishList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "mywishlistCell", for: indexPath) as! mywishlistCell

        cell.delegate = self
        var wishListItem = self.myWishList[indexPath.row]
        cell.wlistImgviewProduct.sd_setImage(with: URL(string: CommonUsed.globalUsed.kimageUrl + wishListItem.product.image  ), placeholderImage: UIImage(named: "place-holder"))
       //cell.wlistImgviewProduct.sd_setImage(with: URL(string: wishListItem.product.small_image ), placeholderImage: UIImage(named: "womensandels.jpeg"))
        cell.wlistLblProductname.text =  wishListItem.product.name.uppercased()
        cell.wlistLblSubTitle.text =  wishListItem.manufacturer.uppercased()
        var price = (Double(wishListItem.product.min_price)  ?? 0).clean
        let currencyStr = (UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
        if(wishListItem.product.min_price == 0.0 || wishListItem.product.min_price == nil){
            cell.wlistLblPrice.text = ""
        }
        else{
            
            cell.wlistLblPrice.text =  "\(price) " + "\((currencyStr))".localized
        }
        
         cell.myWishList = wishListItem

        print("Print Name \(wishListItem.product.name) \n  subtitle \(wishListItem.product.short_description)")
        
        return cell
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var wishListItem = self.myWishList[indexPath.row]
        self.klevuProductSearchApi(skutext:  wishListItem.product.primaryvpn as! String, moveScreen:"PDP")

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
             print("DELETE CELL")
            let cell = tableView.cellForRow(at: indexPath) as! mywishlistCell
            deleteItem(cell: cell)
        }
    }
    func klevuProductSearchApi(skutext: String, moveScreen:String){
              var delimiter = ";"
              var tempSkuArray = skutext.components(separatedBy: delimiter)
              var skuId = tempSkuArray[0]
              var arrMust = [[String:Any]]()
              
              arrMust.append(["match": ["sku":skuId]])
              let dictMust = ["must":arrMust]
              let dictBool = ["bool":dictMust]
              
              var dictSort = [String:Any]()
              dictSort = ["updated_at":"desc"]
              let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture"],
                           "from":0,
                           "size": 5,
                           "sort" : dictSort,
                           "query": dictBool
                  ] as [String : Any]
              
              let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
              let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        MBProgressHUD.showAdded(to: self.view, animated: true)
              ApiManager.apiPost(url: url, params: param) { (response, error) in
                 MBProgressHUD.hide(for: self.view, animated: true)
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
                        if moveScreen == "PDP"{
                            let nextVC = ProductDetailVC.storyboardInstance!
                            nextVC.isCommingFromWishList = true
                            nextVC.detailData = data
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }else if moveScreen == "AddToBag"{
                            
                            let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
                            let changeVC: AddToBagPopUp
                            changeVC = storyboard.instantiateViewController(withIdentifier: "AddToBagPopUp") as! AddToBagPopUp
                            //  changeVC.comingScreen = "ShoppingBagVC"
                            // changeVC.delegate = self
                            // changeVC.cartItems = self.cartItems
                              changeVC.cart_source_data = data?.hits?.hitsList[0]._source  //productData?.hits?.hitsList[cell.rowNumber!]._source
                            self.navigationController?.present(changeVC, animated: true, completion: nil)
                            
                        }
                        
                    })
                  }
                  
              }
          }
}
