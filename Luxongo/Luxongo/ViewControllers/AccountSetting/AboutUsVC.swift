//
//  AboutUsVC.swift
//  Luxongo
//
//  Created by admin on 9/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AboutUsVC: BaseViewController {

    static var storyboardInstance:AboutUsVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: AboutUsVC.identifier) as! AboutUsVC)
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

       callAboutUs()
    }
    
    func callAboutUs(){
        API.shared.call(with: .cmsPages, viewController: self, param: [:]) { (response) in
            self.content = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({ContentPage(dic: $0 as! [String:Any])})
            self.tableView.reloadData()
        }
            
        }

    @IBAction func onClickback(_ sender: Any) {
        popViewController(animated: true)
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

extension AboutUsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier) as? AboutCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
       cell.lblName.text = content[indexPath.row].page_title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ContentVC.storyboardInstance!
        nextVC.data = content[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
}
