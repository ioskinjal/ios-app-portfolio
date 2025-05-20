//
//  AddressListVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 30/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

var strAddressID:String?
class AddressListVC: BaseViewController {

    static var storyboardInstance:AddressListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: AddressListVC.identifier) as? AddressListVC
    }
    var arrAddressList:[AddressList] = []
    let SectionHeaderHeight: CGFloat = 55
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tblAddress: UITableView!{
        didSet{
            tblAddress.register(AddressCell.nib, forCellReuseIdentifier: AddressCell.identifier)
            tblAddress.dataSource = self
            tblAddress.delegate = self
            tblAddress.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "User Address", action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickCart(_:)), btnRightImg:#imageLiteral(resourceName: "add_ic"))
        self.navigationBar.btnCart.isHidden = true
        self.navigationBar.viewCart.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        callGetUserAddressAPI()
        
    }
    
    @objc func onClickCart(_ sender: UIButton){
        let nextVC = AddNewAddressVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func callGetUserAddressAPI() {
        self.arrAddressList = [AddressList]()
        let param = ["uid":UserData.shared.getUser()!.user_id]
        Modal.shared.getUserAddress(vc: self, param: param) { (dic) in
            print(dic)
           
           
            self.arrAddressList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({AddressList(dic: $0 as! [String:Any])})
            if self.arrAddressList.count == 0{
                self.viewNoData.isHidden = false
                
            }else{
                self.tblAddress.reloadData()
            }
        }
        self.tblAddress.reloadData()
      
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
extension AddressListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier) as? AddressCell else {
            fatalError("Cell can't be dequeue")
        }
       cell.lblAddress.text =  arrAddressList[indexPath.row].address_line1 + "," +
        arrAddressList[indexPath.row].address_line2 + "," +
        arrAddressList[indexPath.row].address_line3 + "," +
        arrAddressList[indexPath.row].landmark + "," +
        arrAddressList[indexPath.row].area_name +  "," +
        arrAddressList[indexPath.row].city + "-" +
        arrAddressList[indexPath.row].pincode + "," +
        arrAddressList[indexPath.row].state + "," + "India"
        
        if arrAddressList[indexPath.row].address_type_id == "1"{
             cell.btnOffice.setTitle("Office", for: .normal)
        }else  if arrAddressList[indexPath.row].address_type_id == "2"{
            cell.btnOffice.setTitle("Home", for: .normal)
        }else{
             cell.btnOffice.setTitle("Other", for: .normal)
        }
       
        cell.lblNickName.text = arrAddressList[indexPath.row].area_nick_name
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func onClickEdit(_ sender:UIButton){
       let nextVC = AddNewAddressVC.storyboardInstance!
        isEdit = true
        nextVC.editData = arrAddressList[sender.tag]
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onClickDelete(_ sender:UIButton){
        self.alert(title: "Alert", message: "Are you sure you want to delete this address ?", actions: ["Ok","Cancel"]) { (btnNo) in
            if btnNo == 0 {
                let param = ["uid":UserData.shared.getUser()!.user_id,
                             "address_id":self.arrAddressList[sender.tag].id]
                Modal.shared.deleteAddress(vc: self, param: param, success: { (dic) in
                    self.callGetUserAddressAPI()
                })
            }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddressList.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // strAddressID = arrAddressList[indexPath.row].id
        //self.navigationController?.popViewController(animated: true)
    }
    
}
