//
//  StaticPageVC.swift
//  Happenings
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class StaticPageVC: BaseViewController {

    static var storyboardInstance: StaticPageVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: StaticPageVC.identifier) as? StaticPageVC
    }
    @IBOutlet weak var tblList: UITableView!{
        didSet{
            tblList.register(CategoryFilterCell.nib, forCellReuseIdentifier: CategoryFilterCell.identifier)
            tblList.dataSource = self
            tblList.delegate = self
            tblList.tableFooterView = UIView()
            tblList.separatorStyle = .singleLine
        }
    }
    var pageList = [PageList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Static Page", action: #selector(onClickMenu(_:)))
        
        callgetStaticPages()
    }
    
    func callgetStaticPages(){
        let param = ["action":"content-pages"]
        
        Modal.shared.getStaticPages(vc: self, param: param) { (dic) in
            
            self.pageList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({PageList(dictionary: $0 as! [String:Any])})
            
            if self.pageList.count != 0{
                self.tblList.reloadData()
            }
        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
extension StaticPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterCell.identifier) as? CategoryFilterCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.viewPoint.isHidden = true
        cell.lblName.text = pageList[indexPath.row].pageTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = WebVC.storyboardInstance!
        nextVC.strTitle = pageList[indexPath.row].pageTitle!
        if pageList[indexPath.row].page_or_url == "p"{
            nextVC.strLink = pageList[indexPath.row].page_slug!
        }else{
        nextVC.strLink = pageList[indexPath.row].page_url!
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
