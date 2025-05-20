//
//  CusineListVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 11/09/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class CusineListVC: BaseViewController {

    static var storyboardInstance:CusineListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: CusineListVC.identifier) as? CusineListVC
    }
    var arrSection : NSMutableArray = []
    let SectionHeaderHeight: CGFloat = 60
    @IBOutlet weak var tblCusine: UITableView!{
        didSet{
            tblCusine.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
            tblCusine.dataSource = self
            tblCusine.delegate = self
            tblCusine.separatorStyle = .none
            //tableView.estimatedRowHeight = 65
            // tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Cusine Type", action: #selector(onClickMenu(_:)))
        arrSection = ["BREAKFAST","LUNCH","DINNER"]
        tblCusine.reloadData()
       callgetCusineType()
        // Do any additional setup after loading the view.
    }

    func callgetCusineType() {
        Modal.shared.getCusineTypes(vc: self) { (dic) in
            print(dic)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
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
extension CusineListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.imgFood.layer.cornerRadius = 5
        cell.imgFood.layer.masksToBounds = true
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewSpace = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        viewSpace.backgroundColor = UIColor.groupTableViewBackground
        let view = UIView(frame: CGRect(x: 0, y: viewSpace.frame.size.height+viewSpace.frame.origin.y, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = UIColor.white
        view.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = arrSection[section] as? String
        view.addSubview(label)
        view.addSubview(viewSpace)
       
        return view
    }
    
}
