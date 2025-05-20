//
//  OrderDetailVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class OrderDetailVC: BaseViewController {

    static var storyboardInstance:OrderDetailVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: OrderDetailVC.identifier) as? OrderDetailVC
    }
    var orderId:String?
    var orderStatus:String?
    var selectedOrder:MyOrdersCls.OrderList!
    var orderDetail:OrderDetail?
    @IBOutlet weak var lblTotalAmmount: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var lblTotalPriceOrder: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblCGSTHead: UILabel!
    
    @IBOutlet weak var lblSGSTHead: UILabel!
    @IBOutlet weak var viewBlank: UIView!
    @IBOutlet weak var viewTotalAmmount: UIView!{
        didSet{
            self.viewTotalAmmount.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)

        }
    }
    @IBOutlet weak var viewSgst: UIView!{
        didSet{
            self.viewSgst.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewCgst: UIView!{
        didSet{
            self.viewCgst.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewTotalPrice: UIView!{
        didSet{
            self.viewTotalPrice.border(side: .all, color: Color.Seprator.lightDeviderColor, borderWidth: 1.0)

        }
    }
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var tblOrders: UITableView!{
        didSet{
            tblOrders.register(OrderCell.nib, forCellReuseIdentifier: OrderCell.identifier)
            tblOrders.dataSource = self
            tblOrders.delegate = self
            tblOrders.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Order Detail", action: #selector(onClickMenu(_:)))
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        
        callGetOrderDetail()
       
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func callGetOrderDetail(){
        let param = ["order_id":(selectedOrder!.orderId)!,
                     "order_status:":(selectedOrder!.order_status)!,
                     "type":(selectedOrder!.mealType)!]// "date":(selectedOrder!.delivery_date)!
       
        Modal.shared.getOrders(vc: self, param: param) { (dic) in
            print(dic)
            self.viewBlank.isHidden = true
            let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            let menu = OrderDetail(data: data)
            self.orderDetail = menu
            
            self.lblTotalPriceOrder.text = String(format: "Rs %.2f", self.orderDetail!.total_order_price)
            self.lblCGST.text = String(format: "Rs %.1f", self.orderDetail!.cgst_charge)
            self.lblSGST.text = String(format: "Rs %.1f", self.orderDetail!.sgst_charge)
            self.lblTotalAmmount.text = String(format: "Rs %.2f", self.orderDetail!.total_price)
            
            self.lblCGSTHead.text = String(format: "CGST(%.0f%%)", self.orderDetail!.cgst_percentage) //+ "%)"
            self.lblSGSTHead.text = String(format: "SGST(%.0f%%)", self.orderDetail!.sgst_percentage) //+ "%)"
            self.tblOrders.reloadData()
            self.autoDynamicHeight()
        }
    }

    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.heightConst.constant = self.tblOrders.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onClickMenu(_ sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
   // MARK:- UIButton Click Events
    @IBAction func onClickDownloadInvoice(_ sender: UIButton) {
        let param = ["order_id":selectedOrder.orderId!]
        Modal.shared.getInvoice(vc: self, param: param) { (dic) in
            print(dic)
        
            var dict = NSDictionary()
            dict = dic["data"] as! NSDictionary
            let strurl:String = dict.value(forKey: "invoice") as! String
            let url = strurl
        if !url.isBlank{
            Downloader.loadFileAsync(url: URL(string: url )!) { (str, err) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                if err == nil, str != nil{
                    CloudDataManager.sharedInstance.copyFileToCloud()
                    
                    let ac = UIAlertController(title: "Saved!", message: "Documents is saved.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.viewController?.present(ac, animated: true, completion: nil)
                }
                else{
                    let ac = UIAlertController(title: "Save error", message: err?.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.viewController?.present(ac, animated: true, completion: nil)
                    print("Error in Save Document")
                }
            }
        }
        else{
            print("No URL found")
        }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderDetail = orderDetail else {return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier) as? OrderCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.imgFood.layer.cornerRadius = 5
        cell.imgFood.layer.masksToBounds = true
        cell.lblFoodName.text = orderDetail.order_items[indexPath.row].itemName
        if orderDetail.order_items[indexPath.row].customizationList.count != 0{
             for i in 0..<orderDetail.order_items[indexPath.row].customizationList.count{
        if cell.lblName.text == ""{
            cell.lblName.text =
           orderDetail.order_items[indexPath.row].customizationList[i].customizationItemName
        }else{
            cell.lblName.text = cell.lblName.text! + "," + orderDetail.order_items[indexPath.row].customizationList[i].customizationItemName
        }
            }
        }else{
            cell.lblName.text = ""
        }
        cell.lblName.sizeToFit()
        cell.imgFood.downLoadImage(url: orderDetail.order_items[indexPath.row].itemImage)
        cell.lblPrice.text = "Rs " + orderDetail.order_items[indexPath.row].itemPrice
        cell.lblqty.text = orderDetail.order_items[indexPath.row].qty
        cell.selectionStyle = .none
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        if orderDetail.order_items[indexPath.row].isCancelable == true {
            cell.btnDelete.isHidden = false
        }else{
           cell.btnDelete.isHidden = true
        }
         let inputFormatter = DateFormatter()
         inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: orderDetail.order_items[indexPath.row].delivery_date)
         inputFormatter.dateFormat = "dd MMM yyyy"
        let resultString = inputFormatter.string(from: showDate!)
         cell.lblDate.text = resultString
        return cell
      
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        self.alert(title: "Alert", message: "Are you sure you want to cancel this item? Canceled amount will be credited to your wallet credit balance, after admin approval.", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                if self.orderDetail?.order_items[sender.tag].isCancelable == true {
                    //  let  OngoingButton = UIAlertAction(title: "Paytm wallet", style: .default, handler: { (action) -> Void in
                    let param = ["cart_item_id":self.orderDetail!.order_items[sender.tag].cartItemId]
                    Modal.shared.cancelOrder(vc: self, param: param) { (dic) in
                        let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                        self.alert(title: "", message: str, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self.alert(title: "", message: "you can't delete this item", completion: {
                        
                    })
                }
                }
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orderDetail = orderDetail else {return 0}
        return  orderDetail.order_items.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    
    
}
