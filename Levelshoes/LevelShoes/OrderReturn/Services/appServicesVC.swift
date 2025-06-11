//
//  appServicesVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 07/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class appServicesVC: UIViewController {

    @IBOutlet weak var tblServices: UITableView!
    @IBOutlet weak var header: headerView!
    
    var dataArray = [[String:Any]]()
    var servicesData:NewInData?
    var arrList = [[String:Any]]()
    private var loadingSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderAction()
        callServices()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        callServices()
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
        header.headerTitle.text = "aacountService".localized.uppercased()
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }

    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Pick Address")
        self.navigationController?.popViewController(animated: true)
    }

  func callServices(){
        let dictParam = ["identifier":"mobileapp_static_services"]
        var dictMatch = [String:Any]()
        dictMatch["match"] = dictParam
        var arrMust = [[String:Any]]()
        arrMust.append(dictMatch)
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        let param = ["query":dictBool]
        print(param)
        
        let storeCode="\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        
        let url = CommonUsed.globalUsed.main + "/" +  storeCode + "/" + CommonUsed.globalUsed.cmsBlockDoc + "/" + CommonUsed.globalUsed.ESSearchTag
        
        ApiManager.apiPost(url: url, params: param as [String : Any]) { (response, error) in
            
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            
            // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                    self.servicesData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async {
                    if self.servicesData != nil{
                    self.setData(data:(self.servicesData!))
                    }
                }
                    
                
            }
        }
    }
    
    
        func setData(data:NewInData){
            guard let items = data.hits?.hitsList else {
                       return
                   }
            if(items.count > 0){
            var containtText1 : String = data.hits?.hitsList[0]._source!.content.replaceString("\\r\\n", withString: "") ?? ""
            var containtText2 = containtText1.replaceString("\\", withString: "")
            
            let d = convertToDictionary(text: containtText2 ?? "")
            let dict:[[String:Any]] = d?["services"] as? [[String : Any]] ?? [[String : Any]]()
            dataArray = dict as? [[String : Any]] ?? [[String:Any]]()
            }
            tblServices.reloadData()
    
        }

}
extension appServicesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "servicesCell", for: indexPath) as! servicesCell
         cell.productImg.sd_setImage(with: URL(string:"\(dataArray[indexPath.row]["image"] ?? "")"), placeholderImage: UIImage(named: "imagePlaceHolder"))
       
        cell.lblTitle.text = "\(dataArray[indexPath.row]["subject"] ?? "")"
        cell.lblMsg.text = "\(dataArray[indexPath.row]["description"] ?? "")"
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let inner : [String:Any] = dataArray[indexPath.row]["inner"] as? [String : Any] ?? [String:Any]()
         var innerdetailArray = inner["detail"] as? [[String : Any]] ?? [[String : Any]]()
      // \"subject\"
        if isInnerDataAvailable(innerdatacall: innerdetailArray){
            let storyboard = UIStoryboard(name: "servicedesc", bundle: Bundle.main)
            let serviceDescVC = storyboard.instantiateViewController(withIdentifier: "serviceDetailVC") as! serviceDetailVC
            serviceDescVC.dataDic = dataArray[indexPath.row]
            self.navigationController?.pushViewController(serviceDescVC, animated: true)
            
        }else{
        let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
        let changeVC = storyboards.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
        changeVC!.screenType = "Services"
        changeVC!.dataDic = dataArray[indexPath.row]
        
        changeVC!.detailArray = inner["detail"] as! [[String : Any]]
        self.navigationController?.pushViewController(changeVC!, animated: true)
        }

    }
    
    func isInnerDataAvailable(innerdatacall:[[String : Any]])->Bool{
        var InnerCall = false
        for innerData in innerdatacall {
            var sub = "\(innerData["subject"] ?? "")"
            if sub == "" {
               InnerCall = true
            }
        }
       return InnerCall
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        var lastInitialDisplayableCell = false
        let rowHeight = 144

        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if dataArray.count > 0 && !loadingSuccess {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }

        if !loadingSuccess {

            if lastInitialDisplayableCell {
                loadingSuccess = true
            }

            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: CGFloat(rowHeight/2))
            cell.alpha = 0

            UIView.animate(withDuration: 1.0, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
}
extension appServicesVC:NoInternetDelgate{
    func didCancel() {
        self.callServices()
    }
}
