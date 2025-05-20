//
//  ShoppingCartVC.swift
//  Happenings
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ShoppingCartVC: BaseViewController {

    static var storyboardInstance:ShoppingCartVC? {
        return StoryBoard.shoppingCart.instantiateViewController(withIdentifier: ShoppingCartVC.identifier) as? ShoppingCartVC
    }
    
    @IBOutlet weak var btnCheckOut: UIButton!{
        didSet{
            btnCheckOut.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    @IBOutlet weak var tblConst: NSLayoutConstraint!
    @IBOutlet weak var lblTotalAmmount: UILabel!
    @IBOutlet weak var tblShoppingCart: UITableView!{
        didSet{
            tblShoppingCart.register(ShoppingCartCell.nib, forCellReuseIdentifier: ShoppingCartCell.identifier)
            tblShoppingCart.dataSource = self
            tblShoppingCart.delegate = self
            tblShoppingCart.tableFooterView = UIView()
            tblShoppingCart.separatorStyle = .none
        }
    }
    
    var cartList = [ShopingCartList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        autoDynamicHeight()
        callGetCart()
    }
    
    func callGetCart(){
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getCart(vc: self, param: param) { (dic) in
            print(dic)
            self.cartList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({ShopingCartList(dic: $0 as! [String:Any])})
            if self.cartList.count != 0{
                self.tblShoppingCart.reloadData()
                self.setAutoHeighttbl()
            }
            
            self.lblTotalAmmount.text = "\(UserData.shared.getUser()!.currency)\(dic["total_amount"] as? Int ?? -10)"
        }
    }
    
    @IBAction func onClickCheckOut(_ sender: UIButton) {
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
extension ShoppingCartVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Shopping Cart", action: #selector(onClickMenu(_:)))
        
        
    }
   
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblConst.constant = self.tblShoppingCart.contentSize.height
            self.view.layoutIfNeeded()
        }
}
}
extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCell.identifier) as? ShoppingCartCell else {
            fatalError("Cell can't be dequeue")
        }
        var data:ShopingCartList?
        data = cartList[indexPath.row]
        cell.lblDealName.text = data?.deal_title
        cell.lblOption.text = data?.deal_option_title
        cell.lblCat.text = data?.deal_category
        cell.lblSubCat.text = data?.deal_subcategory
        cell.lblOptionDiscountPrice.text = String(format: "%@ %@",(UserData.shared.getUser()?.currency)!,data!.deal_option_discount)
        cell.lblPrice.text =  String(format: "%@ %@",(UserData.shared.getUser()?.currency)!,data!.deal_option_price)
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(onClickRemove(_:)), for: .touchUpInside)
       return cell
    }
    
    @objc func onClickRemove(_ sender:UIButton){
        let param = ["cart_id":cartList[sender.tag].cart_id,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.removeFromCart(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                
                self.callGetCart()
                
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func setAutoHeighttbl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.tblConst.constant = self.tblShoppingCart.contentSize.height
            self.tblShoppingCart.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblConst.constant = self.tblShoppingCart.contentSize.height
            self.view.layoutIfNeeded()
        }


    }
//
//
//    func reloadMoreData(indexPath: IndexPath) {
//        if paymentHistoryList.count - 1 == indexPath.row &&
//            (favouriteObj!.currentPage > favouriteObj!.TotalPages) {
//            self.paymentHistoryAPI()
//        }
//    }
}
