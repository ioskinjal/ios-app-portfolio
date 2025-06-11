//
//  FAQVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import FirebaseDatabase
class FAQVC: UIViewController {
    var dataDic = [String:Any]()
     var detailArray = [[String:Any]]()
     var parentController : UIViewController?
    var screenType = ""
    var commingFrom = ""
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            lblTitle.text = "faq".localized
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    
    
    @IBOutlet weak var tblFaq: UITableView!{
        didSet{
            tblFaq.delegate = self
            tblFaq.dataSource = self
        }
    }
    
    var faqData:NewInData?
    var arrList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //addinfoToFirebase(akey: "10101", aVal: "KRISHAN krishan")
        if screenType == "Services" {
            self.lblTitle.text = "\(dataDic["subject"] ?? "")"
        }else{
             callFAQ()
        }
       //getinfoFromFirebase()
        
    }
    func getinfoFromFirebase(){
        print("showData")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        _ = ref.observe(DataEventType.value, with: { (snapshot) in
          let dataDict = snapshot.value as? [String : AnyObject] ?? [:]
           //parse data here to get any info
            print("Print Data 00--  \(dataDict) ")
        })
    }
    func addinfoToFirebase(akey : String , aVal : String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
//        do{
//            let orderEnc = try orderEncrypt(key: "df1d175cfdcf447f62d6af03417c7973", text: aVal)
//            print("Print ENC --> \(orderEnc)")
//        }catch{
//            print("Error \(error)")
//        }
        
        ref.child("orders").updateChildValues(["\(akey)": "\(aVal)"])
    }
    func callFAQ(){
        let dictParam = ["identifier":"mobileapp_static_faq"]
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
                
                    self.faqData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async {
                    if self.faqData != nil{
                    self.setData(data:(self.faqData!))
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
            self.lblTitle.text = data.hits?.hitsList[0]._source?.title
            var containtText1 : String = data.hits?.hitsList[0]._source!.content.replaceString("\\r\\n", withString: "") ?? ""
            var containtText2 = containtText1.replaceString("\\", withString: "")
            
            let d = convertToDictionary(text: containtText2 ?? "")
            let dict:[[String:Any]] = d?["faqs"] as? [[String : Any]] ?? [[String : Any]]()
            arrList = dict as? [[String : Any]] ?? [[String:Any]]()
            }
            tblFaq.reloadData()
    
        }
    
    @IBAction func onClickBack(_ sender: Any) {
        if commingFrom == "Help" {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
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
extension FAQVC:NoInternetDelgate{
    func didCancel() {
        if screenType == "Services" {
        }else{
        self.callFAQ()
        }
    }
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if screenType == "Services" {
             return detailArray.count
          }else{
             return arrList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FAQCell.identifier) as? FAQCell else {
            fatalError("Cell can't be dequeue")
        }
         if screenType == "Services" {
              cell.lblName.text = detailArray[indexPath.row]["subject"]as? String ?? ""
         }else{
            cell.lblName.text = arrList[indexPath.row]["title"]as? String ?? ""
        }
      
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("FAQ Selecton with \(screenType) \(indexPath.row)")
        if screenType == "Services" {
            let storyboard = UIStoryboard(name: "servicedesc", bundle: Bundle.main)
            let serviceDescVC = storyboard.instantiateViewController(withIdentifier: "serviceDetailVC") as! serviceDetailVC
            serviceDescVC.dataDic = detailArray[indexPath.row]
            self.navigationController?.pushViewController(serviceDescVC, animated: true)
        }else{
            print("OPenServices")
        let storyboard = UIStoryboard(name: "faqService", bundle: Bundle.main)
            let faqService: faqServiceVC! = (storyboard.instantiateViewController(withIdentifier: "faqServiceVC") as! faqServiceVC)
            faqService.arrayOfQuestion = arrList[indexPath.row]["details"] as? [[String : Any]] ?? [[String:Any]]()
        faqService.heading = arrList[indexPath.row]["title"]as? String ?? ""
            if commingFrom == "Help" {
                faqService.commingFrom = self.commingFrom
                faqService.modalPresentationStyle = .fullScreen
                self.present(faqService, animated: true, completion: nil)
            }else{
                self.navigationController?.pushViewController(faqService, animated: true)
            }
        
        }
        
        
       // self.parentController?.navigationController?.pushViewController(returnOrderVC!, animated: true)
//        let storyboard = UIStoryboard(name: "appServices", bundle: Bundle.main)
//                let servocesVC: appServicesVC! = storyboard.instantiateViewController(withIdentifier: "appServicesVC") as? appServicesVC
//        self.navigationController?.pushViewController(servocesVC, animated: true)
        
        
        }

    
}
