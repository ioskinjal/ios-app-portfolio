//
//  infoVC.swift
//  XPhorm
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class infoVC: BaseViewController {

    static var storyboardInstance:infoVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: infoVC.identifier) as? infoVC
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var content = [ContentPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Information", action: #selector(onClickMenu(_:)))
        
        getInfo()
    }
    
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    func getInfo(){
        let param = ["action":"getContentPages",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage]
        
        Modal.shared.getContentPages(vc: self, param: param) { (dic) in
            self.content = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({ContentPage(dic: $0 as! [String:Any])})
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func onClickTestimonials(_ sender: UIButton) {
        self.navigationController?.pushViewController(TestimonialVC.storyboardInstance!, animated: true)
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
extension infoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier) as? InfoCell else {
            fatalError("Cell can't be dequeue")
            
        }
        
        cell.selectionStyle = .none
        cell.lblInfo.text = content[indexPath.row].pageName
        return cell
        
        
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return content.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ContentVC.storyboardInstance!
        nextVC.data = content[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
