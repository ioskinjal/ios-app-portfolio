//
//  SelectCategoryViewController.swift
//  LevelShoes
//
//  Created by apple on 4/25/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class SelectCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    @IBOutlet weak var backgroudView: UIImageView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yourinLbl: UILabel!{
        didSet{
            yourinLbl.text = "YOU’RE IN:".localized
            yourinLbl.font.withSize(14)
            yourinLbl.addTextSpacing(spacing: 1)
        }
    }
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var flagImageView: UIImageView!
    let catArr = ["WOMEN","MEN","KIDS"]
     var player: AVPlayer?
    @IBOutlet weak var logoImageView: UIImageView!
    static var storyboardInstance:SelectCategoryViewController? {
     return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: SelectCategoryViewController.identifier) as? SelectCategoryViewController
     
 }
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
                switchViewControllers(isArabic: true)
            }
        tableView.delegate = self
        tableView.reloadData()
        self.tableView.isScrollEnabled = false
        let countryname = UserDefaults.standard.value(forKey: "country") ?? ""
        if countryname as! String == "UAE".localized || countryname as! String == "الإماراتالعربيةالمتحدة"
        {
            countryLbl.font.withSize(18)
            countryLbl.textAlignment=NSTextAlignment.left
            countryLbl.text =  "United Arab Emirates".localized + " | English".localized
        }
        
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
        
        SetDataonPage()
      
    }
    override func viewDidLayoutSubviews(){
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height)
         self.tableView.reloadData()
        
    }
    
    func SetDataonPage ()
    {
        if data._source?.category?.data[0].status == "active" {
            yourinLbl.textColor = UIColor(hexString: (data._source?.category?.data[0].label_color)!)
            countryLbl.textColor = UIColor(hexString: (data._source?.category?.data[0].label_color)!)
            logoImageView.sd_setImage(with: URL(string:(data._source?.category?.data[0].logoUrl)!), placeholderImage: UIImage(named: "logo_white"))
            if data._source?.category?.data[0].type == "image"
            {
                backgroudView.sd_setImage(with: URL(string:(data._source?.category?.data[0].image_url)!), placeholderImage: UIImage(named: "levelShoesBackgroud"))
                videoView.isHidden = true
            }
            else
            {
                backgroudView.isHidden = true
                self.player = AVPlayer(url: URL(string:( data._source?.category?.data[0].image_url)!)!)
                self.videoView?.playerLayer.player = player
                self.videoView.playerLayer.videoGravity = .resize
                self.videoView.player?.play()
            }
        }
    }
    
    
     // MARK: TableView Delegates and Data Source
      public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
          return data._source?.category?.name.count ?? 0
      }
      
      //the method returning each cell of the list
      public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          let cell = tableView.dequeueReusableCell(withIdentifier: "CategeoryTableViewCell", for: indexPath) as! CategeoryTableViewCell
        cell.categoryBtn.layer.cornerRadius = 2.0
         cell.categoryBtn.setBackgroundColor(color: UIColor(hexString: "C7C7C7"), forState: .highlighted)
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveLinear], animations: {
            cell.categoryBtn.setTitle(self.catArr [indexPath.row], for: .normal)

        }, completion: nil)
        let title = data._source?.category?.name[indexPath.row].name
        let attributedTitle = NSAttributedString(string:(title?.uppercased())!, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.black] )
        cell.categoryBtn.setAttributedTitle(attributedTitle, for: .normal)
         cell.categoryBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.categoryBtn.tag = indexPath.row
          return cell
      }
    
    @objc func buttonAction(sender: UIButton!) {
        UserDefaults.standard.setValue(data._source?.category?.name[sender.tag].name.lowercased(), forKey: "category")
                                 let viewController = LatestHomeViewController.storyboardInstance!
                                
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)

                              let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
                              nextViewController.selectedIndex = 0
        
                             // nextViewController.tabBar.isHidden = true
                        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        sharedAppdelegate.window?.rootViewController = self.navigationController
                                 sharedAppdelegate.window?.makeKeyAndVisible()
          
           
       }
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableViewAutomaticDimension;//Choose your custom row height
      }
    

   

}
