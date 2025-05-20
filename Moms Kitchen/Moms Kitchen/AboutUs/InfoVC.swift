//
//  InfoVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 08/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class InfoVC: BaseViewController {

    static var storyboardInstance:InfoVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: InfoVC.identifier) as? InfoVC
    }
    
    var arrInfoList = [InfoList]()
    @IBOutlet weak var tblInfo: UITableView!{
        didSet{
            tblInfo.register(InfoCell.nib, forCellReuseIdentifier: InfoCell.identifier)
            tblInfo.dataSource = self
            tblInfo.delegate = self
            tblInfo.separatorStyle = .singleLine
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Info", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        callgetInfoAPI()
        
    }

    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    func callgetInfoAPI() {
        Modal.shared.getInfo(vc: self) { (dic) in
            print(dic)
            self.arrInfoList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({InfoList(dic: $0 as! [String:Any])})
            if self.arrInfoList.count != 0{
                self.tblInfo.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier) as? InfoCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblText.text = arrInfoList[indexPath.row].pageTitle
       
        return cell
        
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInfoList.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = AboutUsVC.storyboardInstance!
        nextVC.dataAbout = arrInfoList[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    
    
    
}
