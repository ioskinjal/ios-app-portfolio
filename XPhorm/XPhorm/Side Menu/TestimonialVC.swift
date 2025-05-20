//
//  TestimonialVC.swift
//  XPhorm
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TestimonialVC: BaseViewController {

    static var storyboardInstance:TestimonialVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: TestimonialVC.identifier) as? TestimonialVC
    }
    
    @IBOutlet weak var viewAddTestimonial: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtTestiMonial: UITextField!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var testList = [TestimonialClass.TestList]()
    var testObj: TestimonialClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Testimonials", action: #selector(onClickBack(_:)))
        
        getTestimonials()
    }
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getTestimonials(){
        
         let nextPage = (testObj?.pagination?.page ?? 0 ) + 1
        
        let param = ["action":"getTestimonials",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getTestimonials(vc: self, param: param) { (dic) in
            self.testObj = TestimonialClass(dictionary: dic)
            if self.testList.count > 0{
                self.testList += self.testObj!.testList
            }
            else{
                self.testList = self.testObj!.testList
            }
            
            self.tableView.reloadData()
        }
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        self.viewAddTestimonial.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickCloseAdd(_ sender: UIButton) {
        self.viewAddTestimonial.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onclickSave(_ sender: SignInButton) {
        if txtTestiMonial.text == ""
        {
            self.alert(title: "", message: "please enter testimonial")
        }else{
            let param = ["action":"addTestimonial",
                "userId":UserData.shared.getUser()!.id,
                "lId":UserData.shared.getLanguage,
                "message":txtTestiMonial.text!]
            
            Modal.shared.getTestimonials(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.testObj = nil
                    self.testList = [TestimonialClass.TestList]()
                    self.getTestimonials()
                    self.viewAddTestimonial.isHidden = true
                    self.navigationBar.isHidden = false
                })
            }
        }
       
    }
    @IBAction func onClickAdd(_ sender: UIButton) {
        self.viewAddTestimonial.isHidden = false
        self.navigationBar.isHidden = true
    }
    @IBAction func onClickCloseDetail(_ sender: UIButton) {
        viewDetail.isHidden = true
        self.navigationBar.isHidden = false
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
extension TestimonialVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestimonialCell.identifier) as? TestimonialCell else {
            fatalError("Cell can't be dequeue")
            
        }
        
        cell.selectionStyle = .none
        cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
        cell.viewContainer.setRadius(8.0)
        let data:TestimonialClass.TestList?
        data = testList[indexPath.row]
        cell.lblname.text = data?.userName
        cell.lblEmail.text = data?.email
        cell.lblDesc.text = data?.message
        cell.lblDate.text = data?.createdDate
        cell.btnViewDetail.tag = indexPath.row
        cell.btnViewDetail.addTarget(self, action: #selector(onClickViewDetail(_:)), for: .touchUpInside)
        return cell
        
        
        
    }
    
    @objc func onClickViewDetail(_ sender:UIButton){
        lblDetail.text = testList[sender.tag].message
        viewDetail.isHidden = false
        self.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testList.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
