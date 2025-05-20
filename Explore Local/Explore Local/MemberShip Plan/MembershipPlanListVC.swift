//
//  MembershipPlanListVC.swift
//  Explore Local
//
//  Created by NCrypted on 29/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Stripe
import StoreKit

var isFromPlan = false
class MembershipPlanListVC: BaseViewController {

    static var storyboardInstance: MembershipPlanListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MembershipPlanListVC.identifier) as? MembershipPlanListVC
    }
    
    var memberShipList = [MemberShipList]()
    var strAmount:String = ""
    var colorList = ["EB3A93","00B0D0","00AB8C","FEC137"]
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblMembership: UITableView!{
        didSet{
            tblMembership.register(MembershipPlanCell.nib, forCellReuseIdentifier: MembershipPlanCell.identifier)
            tblMembership.dataSource = self
            tblMembership.delegate = self
            tblMembership.tableFooterView = UIView()
            tblMembership.separatorStyle = .none
//            tblMembership.tableHeaderView = headerView
        }
    }
    
    @IBOutlet weak var headerView: UIStackView!
    var renewDate = Date()
    var selectedRow:Int = -1
    var transactionId:String?
     var strPlan_id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Membership Plan", action: #selector(onClickMenu(_:)))
        
        callgetMemberShipPlan()
        IAPHelper.store.purchaseStatusBlock =  {[weak self] (type, transaction) in
            guard let self = self else{ return }
            self.sharedAppdelegate.stoapLoader()
            if type == .failed || type == .disabled || type == .deferred {
                if  let transactionError = transaction?.error as NSError?,
                    let localizedDescription = transaction?.error?.localizedDescription,
                    transactionError.code != SKError.paymentCancelled.rawValue {
                    print("Transaction Error: \(localizedDescription)")
                    //                    self.al(message: localizedDescription)
                    self.alert(title: "", message: localizedDescription)
                } else {
                    //                    self.showAlert(message: type.message())
                    self.alert(title: "", message: type.message())
                }
            } else if type == .purchased {
                self.alert(title: "", message: type.message())
                if let transaction = transaction {
                    self.transactionId = transaction.transactionIdentifier
                    print("product identifier : \(transaction.payment.productIdentifier)")
                    print("transaction identifier : \(transaction.transactionIdentifier ?? "")")
                    print("transaction state : \(transaction.transactionState)")
                    print("transaction date : \(transaction.transactionDate ?? Date())")
                    
                    transaction.transactionState
                    self.saveMembershipTransaction()
                    //TODO: make api call with request data and transaction detail
                }
                //                self.requestIndex = nil
            } else if type == .restored {
                self.alert(title: "", message: type.message())
            }
        }
       
    }
    
    func callPamentDetails() {
        
    }
    func saveMembershipTransaction(){
        let param:[String:Any] = ["action":"new_payment",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "amount":strAmount,
                     "plan_id":strPlan_id,
                     "transaction_id":transactionId ?? ""]
        
        Modal.shared.getMemberShipPlan(vc: self, param: param) { (dic) in
            print(dic)
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.dismiss(animated: true, completion: nil)
            self.alert(title: "", message: str, completion: {
                self.callgetMemberShipPlan()
            })
        }
    }
    
    func callgetMemberShipPlan(){
        let param = ["action":"plans",
                     "user_id":UserData.shared.getUser()?.user_id ?? ""]
        
        Modal.shared.getMemberShipPlan(vc: self, param: param) { (dic) in
            print(dic)
            
            self.memberShipList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .plans).map({MemberShipList(dic: $0 as! [String:Any])})
           
            if self.memberShipList.count != 0{
                self.tblMembership.reloadData()
            }else{
                self.lblNoData.isHidden = true
            }
        }
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MembershipPlanListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MembershipPlanCell.identifier) as? MembershipPlanCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
      // cell.btnUpgrade.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        cell.lblName.text = memberShipList[indexPath.row].plan_name
        cell.lblPoint1.text = memberShipList[indexPath.row].desc
        let colorIndex = indexPath.row % colorList.count
        let strColor = String(format: "%@",colorList[colorIndex])
        let color:UIColor = UIColor.init(hexString: strColor)
        cell.viewContainer.border(side: .all, color: color, borderWidth: 2.0)
        cell.btnUpgrade.backgroundColor = color
        cell.lblName.textColor = color
        cell.lblPoint1.textColor = color
        //cell.lblduration.text = memberShipList[indexPath.row].duration
        //cell.lblamount.text = String(format: "$%d", (memberShipList[indexPath.row].amount as NSString).intValue)
        if memberShipList[indexPath.row].isperchased == "y"{
            //cell.btnUpgrade.setTitle("Purchased", for: .normal)
            cell.btnUpgrade.isHidden = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            renewDate = dateFormatter.date(from: memberShipList[indexPath.row].renew_date)!
            var currentDate = Date()
            let strcurrentDate = dateFormatter.string(from: currentDate)
            currentDate = dateFormatter.date(from: strcurrentDate)!
            if renewDate == currentDate {
                //cell.btnUpgrade.tag = indexPath.row
                //onClickPerchase(cell.btnUpgrade)
            }
        }else{
          //  cell.btnUpgrade.setTitle("Purchase", for: .normal)
            cell.btnUpgrade.isHidden = false
            cell.btnUpgrade.tag = indexPath.row
            cell.btnUpgrade.addTarget(self, action: #selector(onClickPerchase(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
   
        
    @objc func onClickPerchase(_ sender:UIButton){
        let user = UserData.shared.getUser()
        if user == nil{
            isFromPlan = true
            self.navigationController?.pushViewController(SignUpVC.storyboardInstance!, animated: true)
        }else{
        selectedRow = sender.tag
        let param:[String:Any] = ["action":"get_plan_id",
                                  "user_id":UserData.shared.getUser()!.user_id,
                                  "plan_id":memberShipList[sender.tag].membership_id]
        
        Modal.shared.getMemberShipPlan(vc: self, param: param) { (dic) in
            print(dic)
            self.strPlan_id = dic["plan_id"] as! String
            self.strAmount = self.memberShipList[sender.tag].amount
            let price = IAPHelper.store.getProductPrice(identifier: self.memberShipList[sender.tag].identifier )
            if price != "BUY" {
              //  let alert = UIAlertController(title: "", message: "You have to pay \(price) to purchase this \(self.memberShipList[sender.tag].plan_name) membership plan.", preferredStyle: .alert)
              //  alert.addAction(UIAlertAction(title: "Pay Now", style: .default, handler: { (action) in
                self.sharedAppdelegate.startLoader()
                    //                        if let identifiers = self.cellData!.ios_identifier{
                    //if InAppProduct.yearly == self.memberShipList[sender.tag].identifier {
                        IAPHelper.store.buyProduct(identifier:self.memberShipList[sender.tag].identifier )
                    //} else {
                      //  self.alert(title: "", message: "You can not subscribe")
                    //}
                    //                        }
                //}))
               // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //self.sharedAppdelegate.stoapLoader()
                //}))
                //UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
               
                self.alert(title: "", message: "Cannot connect to iTunes Store.")
            }
            
        }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberShipList.count
    }
    
    
}

extension MembershipPlanListVC:
PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    @available(iOS 11.0, *)
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            if error == nil {
                print("Stripe Token Here => =>",token?.tokenId as Any)
                let param = ["action":"payment",
                             "user_id":UserData.shared.getUser()!.user_id,
                             "token":token!.tokenId,
                             "amount":self.memberShipList[self.selectedRow].amount,
                             "plan_id":self.memberShipList[self.selectedRow].membership_id]
                
                Modal.shared.getMemberShipPlan(vc: self, param: param, success: { (dic) in
                    print(dic)
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.dismiss(animated: true, completion: nil)
                    self.alert(title: "", message: str, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                })
                completion(PKPaymentAuthorizationResult.init(status: .success, errors: nil))
                
            } else {
                print("Error Here => => ",error?.localizedDescription as Any)
                completion(PKPaymentAuthorizationResult.init(status: .failure, errors: [error!]))
            }
        }
    }
    
}


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
