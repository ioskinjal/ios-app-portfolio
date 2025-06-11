//
//  AccountVC.swift
//  CablePay
//
//  Created by Harry on 12/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    static var storyboardInstance:AccountVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: AccountVC.identifier) as? AccountVC
    }
    
    @IBOutlet weak var btnTransaction: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
  
    @IBOutlet weak var tblTransactions: UITableView!{
        didSet{
            tblTransactions.delegate = self
            tblTransactions.dataSource = self
            tblTransactions.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.identifier)
        }
    }
    @IBOutlet weak var tblMessages: UITableView!{
        didSet{
            tblMessages.delegate = self
            tblMessages.dataSource = self
            tblMessages.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onClickMessage(btnMessage)
    }
    
    @IBAction func onClickMessage(_ sender: UIButton) {
        btnMessage.setTitleColor(UIColor.white, for: .normal)
        btnMessage.backgroundColor = UIColor.init(hexString: "FDBC00")
        
        btnTransaction.setTitleColor(UIColor.black, for: .normal)
        btnTransaction.backgroundColor = UIColor.init(hexString: "ffffff")
        
        tblTransactions.isHidden = true
        tblMessages.isHidden = false
    }
    
    @IBAction func onClickTransaction(_ sender: Any) {
        btnTransaction.setTitleColor(UIColor.white, for: .normal)
        btnTransaction.backgroundColor = UIColor.init(hexString: "FDBC00")
        
        btnMessage.setTitleColor(UIColor.black, for: .normal)
        btnMessage.backgroundColor = UIColor.init(hexString: "ffffff")
        
        tblTransactions.isHidden = false
        tblMessages.isHidden = true
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
extension AccountVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMessages{
        return 5
        }else{
         return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMessages{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else {
            fatalError()
        }
        
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else {
                fatalError()
            }
            
            return cell
        }
    }
    
}
