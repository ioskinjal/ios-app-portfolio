//
//  MSSideNavigationVC.swift
//  MIShop
//
//  Created by nct48 on 03/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

struct sideMenu
{
    var image : UIImage
    var title : String
    static func setTableData() -> [sideMenu]{
        return [
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Home"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "My Shop"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Products"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Shops"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Feeds"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "News"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Discount Store"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Bids"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Likes"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Favourites"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Orders"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "My Parties"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Add Products"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Add New Party"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Account Setting"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "About Us"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Contact Us"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Logout")
        ]
    }
    
    static func setTableDataSelected() -> [sideMenu]{
        return [
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Home"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "My Shop"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Products"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Shops"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Feeds"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "News"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Discount Store"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Bids"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Likes"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Favourites"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Orders"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "My Parties"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Add Products"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Add New Party"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Account Setting"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "About Us"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Contact Us"),
            sideMenu(image: #imageLiteral(resourceName: "AboutUs"), title: "Logout")
        ]
    }
}

//ContactUs Navigation Icon
//Home Navigation Icon
//Inbox Navigation Icon
//Logout Navigation Icon
//MyBooking Navigation Icon
//MyReservation Navigation Icon
//Notification Navigation Icon
//
//
//ContactUs Navigation Icon Selected
//Home Navigation Icon Selected
//Inbox Navigation Icon Selected
//Logout Navigation Icon Selected
//MyBooking Navigation Icon Selected
//MyReservation Navigation Icon Selected
//Notification Navigation Icon Selected



class MSSideNavigationVC: UIViewController
{
    @IBOutlet var tableViewSideNavBar: UITableView!{didSet{
        tableViewSideNavBar.tableFooterView = UIView()
        }}
    
    var arrSideMenu = sideMenu.setTableData()
    var arrSideMenu2 = sideMenu.setTableDataSelected()
    
    @IBOutlet var imgUserImage: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserEmail: UILabel!
    var selectedRowIndex : Int?
     var vcArray = [UIViewController]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //imgUserImage.downLoadImage(url:(userDefaultsManager.getUser().currentUser.profileUrl))
        
        //lblUserName.text = userDefaultsManager.getUser().currentUser.firstName + userDefaultsManager.getUser().currentUser.lastName
        //lblUserEmail.text = userDefaultsManager.getUser().currentUser.email
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSlideMenuLanguage), name: NSNotification.Name("changeSlideMenuLanguage"), object: nil)
        
    }
    @objc func changeSlideMenuLanguage()
    {
        print("dfdsfdfd fdsf ds")
        arrSideMenu = sideMenu.setTableData()
        arrSideMenu2 = sideMenu.setTableDataSelected()
        
        tableViewSideNavBar.reloadData()
    }
    func settingNavigationDetails()
    {
        //imgUserImage.downLoadImage(url: )
    }
    
}

extension MSSideNavigationVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        if selectedRowIndex==indexPath.row
        {
            let viewLine = UIView()
            viewLine.frame = CGRect(x: 0, y: 0, width: 2, height: cell.frame.size.height)
            viewLine.backgroundColor = UIColor.white
            
            cell.textLabel?.text = arrSideMenu2[indexPath.row].title
            cell.textLabel?.textColor = UIColor.white
            cell.imageView?.image = arrSideMenu2[indexPath.row].image
            cell.addSubview(viewLine)
        }
        else
        {
            cell.textLabel?.text = arrSideMenu[indexPath.row].title
            cell.textLabel?.textColor = UIColor.white
            
            cell.imageView?.image = arrSideMenu[indexPath.row].image
        }
        cell.backgroundColor = UIColor.clear
        cell.imageView?.contentMode = .center
        return cell
    }

//    func getNextVC(index: Int) -> UIViewController? {
//            switch index {
//            case 0:
//                return nil
//            case 1:
//
//                return nil
//            case 2:
//                return ProductDetailVC.storyboardInstance!
//            case 3:
//
//                return nil
//            case 4:
//
//                return nil
//            case 5:
//
//                return nil
//            case 6:
//
//                return nil
//            case 7:
//
//                return nil
//            case 8:
//
//                return nil
//            case 9:
//
//                return nil
//            case 10:
//
//                return nil
//            case 11:
//
//                return nil
//            case 12:
//
//                return nil
//            default:
//                return nil
//
//        }
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        sideMenuController!.hideLeftView(animated: true, completionHandler: nil)
       // self.navigationController?.pushViewController(getNextVC(index: indexPath.row)!, animated: true)
//        if indexPath.row == 2 {
//            let nextVC = ProductDetailVC.storyboardInstance!
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
        tableViewSideNavBar.reloadData()
        
        
    }
}
extension MSSideNavigationVC {
    func setMenubarElemnts() {
        //vcArray = [st
                   //Logout, 12
        //]
    }
}
