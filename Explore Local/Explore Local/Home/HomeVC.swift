//
//  HomeVC.swift
//  Explore Local
//
//  Created by NCrypted on 05/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {

    private let refreshControl = UIRefreshControl()
  
    @IBOutlet weak var tblCategory: UITableView!{
        didSet{
            tblCategory.register(SingleImageCell.nib, forCellReuseIdentifier: SingleImageCell.identifier)
            tblCategory.register(TwoImageCell.nib, forCellReuseIdentifier: TwoImageCell.identifier)
            tblCategory.dataSource = self
            tblCategory.delegate = self
            tblCategory.separatorStyle = .none
            if #available(iOS 10.0, *) {
                tblCategory.refreshControl = refreshControl
            } else {
                tblCategory.addSubview(refreshControl)
            }
            refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        }
    }
    
    static var storyboardInstance:HomeVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: HomeVC.identifier) as? HomeVC
    }
     var selectedMenu = 0
   
   
    var arrCategoryList = [AnyObject]()
    var arrSubCategoryList = [CategoryList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "Explore Local", action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickSearch(_:)), btnRightImg: #imageLiteral(resourceName: "Search_white"))
        
        
    //    callGetSubCategory()
    }

    override func viewWillAppear(_ animated: Bool) {
        callGetCategory()
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ?
            JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        //    JSONSerialization.WritingOptionsJSONSerialization.WritingOptions.PrettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func callGetCategory() {
        let param = ["action":"category"]
        Modal.shared.home(vc: self, param: param) { (dic) in
            print(dic)
          
            self.arrCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .category) as [AnyObject]
            self.tblCategory.reloadData()
             self.refreshControl.endRefreshing()
        }
    }
    
//    func callGetSubCategory(){
//        let param = ["action":"subcategory",
//                     "category_id":"1"]
//        Modal.shared.home(vc: self, param: param) { (dic) in
//            print(dic)
//            self.arrSubCategoryList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .category).map({CategoryList(dic: $0 as! [String:Any])})
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onClickMenu(_ sender: UIButton){
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @objc func onClickSearch(_ sender: UIButton){
        self.navigationController?.pushViewController(SearchResultVC.storyboardInstance!, animated: true)
    }

    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        callGetCategory()
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
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let array = NSMutableArray()
        array.addObjects(from:arrCategoryList[indexPath.row] as! [Any])
        if array.count == 1 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleImageCell.identifier) as? SingleImageCell else {
            fatalError("Cell can't be dequeue")
            
            
        }
            
            var dict = NSDictionary()
            dict = array[0] as! NSDictionary
            cell.imgView.downLoadImage(url:dict.value(forKey: "image") as! String)
            cell.lblName.text = dict.value(forKey: "name") as? String
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoImageCell.identifier) as? TwoImageCell else {
                fatalError("Cell can't be dequeue")
            }
            let array = NSMutableArray()
            array.addObjects(from:arrCategoryList[indexPath.row] as! [Any])
            var dict = NSDictionary()
            dict = array[0] as! NSDictionary
            cell.imgView1.downLoadImage(url:dict.value(forKey: "image") as! String)
            cell.lblName1.text = dict.value(forKey: "name") as? String
            
            let array1 = NSMutableArray()
            array1.addObjects(from:arrCategoryList[indexPath.row] as! [Any])
            var dict1 = NSDictionary()
            dict1 = array1[1] as! NSDictionary
            cell.imgView2.downLoadImage(url:dict1.value(forKey: "image") as! String)
            cell.llbName2.text = dict1.value(forKey: "name") as? String
            cell.btn1.tag = indexPath.row
            cell.btn2.tag = indexPath.row
            cell.btn1.addTarget(self, action: #selector(onclickBtn1), for: .touchUpInside)
             cell.btn2.addTarget(self, action: #selector(onclickBtn2), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func onclickBtn1(_ sender:UIButton){
        let array = NSMutableArray()
        array.addObjects(from:arrCategoryList[sender.tag] as! [Any])
        var dict = NSDictionary()
        dict = array[0] as! NSDictionary
        let nextVC = SubCategoryListVC.storyboardInstance!
        nextVC.strCatID = dict.value(forKey: "id") as? String
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func onclickBtn2(_ sender:UIButton){
        let array1 = NSMutableArray()
        array1.addObjects(from:arrCategoryList[sender.tag] as! [Any])
        var dict1 = NSDictionary()
        dict1 = array1[1] as! NSDictionary
        let nextVC = SubCategoryListVC.storyboardInstance!
        nextVC.strCatID = dict1.value(forKey: "id") as? String
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return inviteFriendsList.count
        return arrCategoryList.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let array = NSMutableArray()
        array.addObjects(from:arrCategoryList[indexPath.row] as! [Any])
        var dict = NSDictionary()
        dict = array[0] as! NSDictionary
        let nextVC = SubCategoryListVC.storyboardInstance!
        nextVC.strCatID = dict.value(forKey: "id") as? String
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
}
