//
//  MyOrderVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class MyOrderVC: BaseViewController {

     let SectionHeaderHeight: CGFloat = 60
    static var storyboardInstance:MyOrderVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MyOrderVC.identifier) as? MyOrderVC
    }
    var strStartDate:String = ""
    var nextPage:Int = 0
    var strEndDate:String = ""
    var strMealType:String = ""
    var strOrderType:String = ""
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var txtToDate: UITextField!{
        didSet{
            let startDatePickerView =  UIDatePicker()
            startDatePickerView.datePickerMode = .date
            startDatePickerView.addTarget(self, action: #selector(startTimeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtToDate.inputView = startDatePickerView
        }
    }
    @IBOutlet weak var txtFromDate: UITextField!{
        didSet{
            let endDatePickerView =  UIDatePicker()
            endDatePickerView.datePickerMode = .date
            endDatePickerView.addTarget(self, action: #selector(endTimeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtFromDate.inputView = endDatePickerView
        }
    }
    @IBOutlet weak var txtSelectOrderStatus: UITextField!{
        didSet{
            txtSelectOrderStatus.addTarget(self, action: #selector(onClickOrderStatus(_:)), for: .touchDown)
        }
    }
    @IBOutlet weak var txtSelectMealType: UITextField!{
        didSet{
            txtSelectMealType.addTarget(self, action: #selector(onClickMealType(_:)), for: .touchDown)
        }
    }
   
    @IBOutlet weak var tblOrders: UITableView!{
        didSet{
            tblOrders.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
            tblOrders.dataSource = self
            tblOrders.delegate = self
            tblOrders.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var orderList = [MyOrdersCls.OrderList]()
    var orderObj: MyOrdersCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Orderes", action: #selector(onClickMenu(_:)))
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Orders", action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickFilter(_:)), btnRightImg: #imageLiteral(resourceName: "filter-ico"))
        self.navigationBar.btnCart.isHidden = true
        self.navigationBar.viewCart.isHidden = true
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        let date = Date()
//        strStartDate = dateFormatter.string(from: date)
//        strEndDate = dateFormatter.string(from: date)
//        self.txtToDate.text = strEndDate
//        self.txtFromDate.text = strStartDate
    }
    override func viewWillAppear(_ animated: Bool) {
        orderObj = nil
        orderList = [MyOrdersCls.OrderList]()
        callGetMyOrders()
    }
    
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         sender.minimumDate = dateFormatter.date(from: strStartDate)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
            strEndDate = dateFormatter.string(from: sender.date)
        
        self.txtToDate.text = strEndDate
    }
    
    @objc func endTimeDiveChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        strStartDate = dateFormatter.string(from: sender.date)
        self.txtFromDate.text = strStartDate
        strEndDate = dateFormatter.string(from: sender.date)
        
        self.txtToDate.text = strEndDate
    }
    
    @objc func onClickMealType(_ sender:UITextField){
        let alertController = UIAlertController(title: "Meal Type", message: "", preferredStyle: .actionSheet)
        
        let UpcomingButton = UIAlertAction(title: "Breakfast", style: .default, handler: { (action) -> Void in
            self.txtSelectMealType.text = "Breakfast"
            self.strMealType = "1"
        })
        
        let  OngoingButton = UIAlertAction(title: "Lunch", style: .default, handler: { (action) -> Void in
            self.txtSelectMealType.text = "Lunch"
            self.strMealType = "2"
        })
        
        let PastButton = UIAlertAction(title: "Dinner", style: .default, handler: { (action) -> Void in
            self.txtSelectMealType.text = "Dinner"
            self.strMealType = "3"
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            self.txtSelectMealType.text = "Select Meal Type"
            self.strMealType = ""
        })
        
        alertController.addAction(UpcomingButton)
        alertController.addAction(OngoingButton)
        alertController.addAction(PastButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func onClickOrderStatus(_ sender:UITextField){
        let alertController = UIAlertController(title: "Order Status", message: "", preferredStyle: .actionSheet)
        
        let UpcomingButton = UIAlertAction(title: "Upcoming Order", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Upcoming Order"
            self.strOrderType = "u"
           
        })
        
        let  OngoingButton = UIAlertAction(title: "Order Received", style: .default, handler: { (action) -> Void in
             self.txtSelectOrderStatus.text = "Order Received"
            self.strOrderType = "r"
            
        })
        
        let PastButton = UIAlertAction(title: "Order Packed", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Order Packed"
            self.strOrderType = "p"
            
        })
        
        let wayButton = UIAlertAction(title: "Order on the Way", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Order on the Way"
            self.strOrderType = "w"
            
        })
        
        let deliveredButton = UIAlertAction(title: "Order Delivered", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Order Delivered"
            self.strOrderType = "d"
            
        })
        
        let pendingButton = UIAlertAction(title: "Refund Status Pending", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Refund Status Pending"
            self.strOrderType = "rp"
            
        })
        
        let cancelledButton = UIAlertAction(title: "Cancelled", style: .default, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Cancelled"
            self.strOrderType = "c"
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            self.txtSelectOrderStatus.text = "Select Order Status"
            self.strOrderType = ""
        })
        
        alertController.addAction(UpcomingButton)
        alertController.addAction(OngoingButton)
        alertController.addAction(PastButton)
        alertController.addAction(cancelButton)
        
        alertController.addAction(wayButton)
        alertController.addAction(deliveredButton)
        alertController.addAction(pendingButton)
        alertController.addAction(cancelledButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    func callGetMyOrders() {
      
        var param = [String:Any]()
        
            let nextPage = (orderObj?.pagination?.current_page ?? 0 ) + 1
            print("nextPage: \(nextPage)")//UserData.shared.getUser()!.user_id
        param = ["uid":UserData.shared.getUser()!.user_id,
                 "page": nextPage,
                  "mealType":strMealType,
                    "to_date":strEndDate,
                "from_date":strStartDate,
                "order_status":strOrderType
    
    ]
        Modal.shared.getMyOrders(vc: self, param: param, failer: { (dic) in
            self.tblOrders.reloadData()
        }) { (dic) in
            self.orderObj = MyOrdersCls(dictionary: dic)
            if self.orderList.count > 0{
                self.orderList += self.orderObj!.orderListItem
            }
            else{
                self.orderList = self.orderObj!.orderListItem
            }
            self.tblOrders.reloadData()
        }
        
        
    }
    @objc func onClickFilter(_ sende:UIButton){
        orderList =  [MyOrdersCls.OrderList]()
        orderObj = nil
        self.navigationBar.isHidden = true
        viewFilter.isHidden = false
        
    }
    
   
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UIBuuton Click Events
    
    @IBAction func onClickDeleteToDate(_ sender: UIButton) {
        strEndDate = ""
        txtToDate.text = "To Date"
    }
    @IBAction func onClickDeleteFromdate(_ sender: UIButton) {
        strStartDate = ""
        txtFromDate.text = "From Date"
    }
    @IBAction func onclickCloseFilter(_ sender: UIButton) {
        self.navigationBar.isHidden = false
        viewFilter.isHidden = true
    }
    @IBAction func onclickReset(_ sender: UIButton) {
        strEndDate = ""
        strStartDate = ""
        strMealType = ""
        strOrderType = ""
        txtFromDate.text = "From Date"
        txtToDate.text = "To Date"
        txtSelectOrderStatus.text = "Select Order Status"
        txtSelectMealType.text = "Select Meal Type"
       
    }
    @IBAction func onClickApply(_ sender: UIButton) {
        self.navigationBar.isHidden = false
        viewFilter.isHidden = true
        callGetMyOrders()
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
extension MyOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            fatalError("Cell can't be dequeue")
        }
        
       cell.lblstatus.layer.cornerRadius = 15
        cell.lblstatus.layer.masksToBounds = true
        cell.lblOrderId.text =  "#MOMK" + orderList[indexPath.row].orderId!
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var showDate = inputFormatter.date(from: orderList[indexPath.row].order_date!)
        inputFormatter.dateFormat = "dd MMMM yyyy"
        var resultString = inputFormatter.string(from: showDate!)
        print(resultString)
        cell.lblOrderDate.text = resultString
       // inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //showDate = inputFormatter.date(from: orderList[indexPath.row].delivery_date!)
       // inputFormatter.dateFormat = "dd MMMM yyyy"
       // resultString = inputFormatter.string(from: showDate!)
       // cell.lblDeliveryDate.text = resultString
       
        if orderList[indexPath.row].mealType == "1" {
            cell.lblType.text = "BREAKFAST"
        }else if orderList[indexPath.row].mealType == "2" {
             cell.lblType.text = "LUNCH"
        }else{
             cell.lblType.text = "DINNER"
        }

        if orderList[indexPath.row].order_status == "u" {
             cell.lblstatus.text = "ORDER UPCOMING"
        }else if orderList[indexPath.row].order_status == "r" {
            cell.lblstatus.text = "ORDER RECEIVED"
             cell.lblstatus.backgroundColor = UIColor.init(hexString: "Ef0F2F")
        }else if orderList[indexPath.row].order_status == "p" {
            cell.lblstatus.text = "ORDER PACKED"
        }else if orderList[indexPath.row].order_status == "w" {
            cell.lblstatus.text = "ORDER PACKED"
        }else if orderList[indexPath.row].order_status == "d" {
            cell.lblstatus.text = "ORDER DELIVERED"
            cell.lblstatus.backgroundColor = UIColor.init(hexString: "11c443")
        }else if orderList[indexPath.row].order_status == "c" {
            cell.lblstatus.text = "ORDER CANCELLED"
            cell.lblstatus.backgroundColor = UIColor.init(hexString: "Ef0F2F")
        }else if orderList[indexPath.row].order_status == "rp" {
            cell.lblstatus.text = "ORDER REFUND PENDING"
        }else{
            cell.lblstatus.text = "ORDER REFUND PAID"
        }
        
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(onClickViewDetails(_:)), for: .touchUpInside)
          cell.selectionStyle = .none
        return cell
        
    }
    
    @objc func onClickViewDetails(_ sender:UIButton){
        let nextVC = OrderDetailVC.storyboardInstance!
        nextVC.selectedOrder = orderList[sender.tag]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if orderList.count - 1 == indexPath.row &&
            (orderObj!.pagination!.current_page < orderObj!.pagination!.total_pages) {
            self.callGetMyOrders()
        }
    }
    
}

