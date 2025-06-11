//
//  faqServiceVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class faqServiceVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: backBtn)
    
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: backBtn)
            }
        }
    }
    var heading = ""
    var commingFrom = ""
    @IBOutlet weak var faqHeader: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                faqHeader.font = UIFont(name: "Cairo-SemiBold", size: faqHeader.font.pointSize)
            }
        }
    }
    @IBOutlet weak var myHeader: headerView!

    @IBOutlet weak var tblfaqService: UITableView!
    @IBOutlet weak var lblTitle: UILabel!{
            didSet{
                lblTitle.text = "faq".localized
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                    lblTitle.addTextSpacing(spacing: 1.5)
                }else{
                    lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
                }
            }
        }
    
    var arrayOfQuestion = [[String:Any]]()
    //var openSection = 0
    //var arrayHeader = 0 //[Int]()
  //  var openSections = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

      //  loadHeaderAction()
        for i in 0..<arrayOfQuestion.count{
            //openFIrstRow
            if i == 0 {
                arrayOfQuestion[i]["isSelected"] = true
            }else{
                arrayOfQuestion[i]["isSelected"] = false
            }
            
        }
        self.tblfaqService.reloadData()
        //self.openSections.insert(0)
    }
    @IBAction func onClickBack(_ sender: Any) {
        if commingFrom == "Help" {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        faqHeader.text = heading
    }
  
//       if self.openSections.contains(section) {
//           self.openSections.remove(section)
//          UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//              self.rotateAnyView(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
//              sender.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
//            self.tblfaqService.deleteRows(at: indexPathsForSection(),with: .fade)
//          }, completion: nil)

                                     
//       } else {
//         self.openSections.insert(section)
         
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//            self.rotateAnyView(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
//            sender.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
//            self.tblfaqService.insertRows(at: indexPathsForSection(),with: .fade)
//        }, completion: nil)
      // }
//        if sender.isSelected == true {
//          sender.isSelected = false
//            print("Inside Selection YEs")
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.rotateAnyView(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
//                sender.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
//            }, completion: nil)
//        }else {
//          sender.isSelected = true
//            print("Inside Selection YEs")
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.rotateAnyView(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
//                sender.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
//            }, completion: nil)
//        }
//    }
//    private func loadHeaderAction(){
//        myHeader.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
//        myHeader.buttonClose.isHidden = true
//        myHeader.headerTitle.text = "faq".localized
//        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
//            Common.sharedInstance.backtoOriginalButton(aBtn: myHeader.backButton)
//
//        }
//        else{
//            Common.sharedInstance.rotateButton(aBtn: myHeader.backButton)
//        }
//    }
   

    func rotateAnyView(view: UIView, fromValue: Double, toValue: Float, duration: Double = 1) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
    
//    @IBAction func onClickEditorNotes(_ sender: UIButton) {
//
//        if lblEditorNotes.isHidden == false {
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.rotateAnyView(view: sender, fromValue: M_PI / 2, toValue:0, duration: 0.5)
//                self.lblEditorNotes.isHidden = true
//                sender.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
//            }, completion: nil)
//        } else {
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.rotateAnyView(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
//
//                self.lblEditorNotes.isHidden = false
//                sender.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
//            }, completion: nil)
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension faqServiceVC: UITableViewDataSource, UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfQuestion.count
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "faqServiceCell", for: indexPath) as? faqServiceCell else{return UITableViewCell()}
             
        cell.selectionStyle = .none
        //cell.textLabel?.text = "section: \(indexPath.section)  row: \(indexPath.row)"
        cell.lblQuestion.text = arrayOfQuestion[indexPath.row]["title"] as? String ?? ""
        cell.lblDetail.text = arrayOfQuestion[indexPath.row]["description"] as? String ?? ""
        cell.btnExpand.tag = indexPath.row
        cell.btnExpand.addTarget(self, action: #selector(onClickExpand(_:)), for: .touchUpInside)
        if arrayOfQuestion[indexPath.row]["isSelected"]as? Bool ?? false == true{
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: cell.btnExpand, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
                cell.btnExpand.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
            cell.lblDetail.isHidden = false
                  }, completion: nil)
           // cell.lblDetail.sizeToFit()
        }else{
             cell.lblDetail.isHidden = true
            cell.btnExpand.isSelected = true
                        print("Inside Selection YEs")
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: cell.btnExpand, fromValue: 0 * M_PI, toValue:0, duration: 0.5)
                cell.btnExpand.setImage(#imageLiteral(resourceName: "expand"), for: .normal)

               
                        }, completion: nil)
           
        }
        return cell
    }
    
    @objc func onClickExpand(_ sender:UIButton){
        if arrayOfQuestion[sender.tag]["isSelected"]as? Bool ?? false == false{
        arrayOfQuestion[sender.tag]["isSelected"] = true
             self.tblfaqService.reloadData()
         }else{
             arrayOfQuestion[sender.tag]["isSelected"] = false
            UIView.animate(withDuration: 0.3) {
                 self.tblfaqService.reloadData()
               
            }
        }
     
                       
                  
       
    }
    
}
