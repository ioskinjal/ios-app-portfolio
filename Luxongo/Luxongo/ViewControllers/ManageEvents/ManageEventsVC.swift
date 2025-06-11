//
//  ManageEventsVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageEventsVC: BaseViewController {
    
    //MARK: Variables
    var currentEventTypeVC:UIViewController?
    var selectedMenu = 1
    private let upperBound = 3 //Maximum page number
    
    //MARK: Properties
    static var storyboardInstance:ManageEventsVC {
        return StoryBoard.manageEvents.instantiateViewController(withIdentifier: ManageEventsVC.identifier) as! ManageEventsVC
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
            
        }
    }
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var rootContainerView: UIView!{
        didSet{
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipped(gesture:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            rootContainerView.addGestureRecognizer(swipeLeft)
            
            let swipeLeft1 = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipped(gesture:)))
            swipeLeft1.direction = UISwipeGestureRecognizer.Direction.right
            rootContainerView.addGestureRecognizer(swipeLeft1)
        }
    }
    
    @IBOutlet weak var btnUpComing: BlackTabButton!{
        didSet{
            self.btnUpComing.tag = 1
        }
    }
    @IBOutlet weak var btnPast: BlackTabButton!{
        didSet{
            self.btnPast.tag = 2
        }
    }
    @IBOutlet weak var btnDraft: BlackTabButton!{
        didSet{
            self.btnDraft.tag = 3
        }
    }
    
    @IBOutlet weak var btnBootomView: UIView!
    
    var csv_url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMenu(num: selectedMenu)
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        popViewController(animated: true)
    }
    
    
    @IBAction func onClickUpcoming(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    @IBAction func onClickPast(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    @IBAction func onClickDraft(_ sender: UIButton) {
        if !sender.isSelected{
            selectionMenu(num: sender.tag)
        }
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Manage Events", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Flyer", style: .default , handler:{ (UIAlertAction)in
            self.pushViewController(CreateEventsVC.storyboardInstance, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Export as CSV", style: .default , handler:{ (UIAlertAction)in
            self.downloadCSV()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    
    func downloadCSV() {
        if !csv_url.isBlank{
            if let url = URL(string: csv_url) {
                Downloader.loadFileAsync(url: url, fileName: "event_\(Date()).csv".removingAllWhitespacesAndNewlines) { (downloadedURL, error) in
                    if error == nil {
                        print("downloadedURL : \((downloadedURL ?? ""))")
                        //UIApplication.alert(title: "Saved!", message: "Doument is saved")
                        let ac = UIAlertController(title: "Saved!", message: "Documents is saved.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    } else {
                        print("error : \((error?.localizedDescription ?? ""))")
                        //UIApplication.alert(title: "Error", message: error?.localizedDescription ?? "")
                        let ac = UIAlertController(title: "Error", message: error?.localizedDescription ?? "", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            }
        }
        else{
            print("No URL found")
        }
    }
}


//MARK: Custom function
extension ManageEventsVC{
    
    private func loadView(center point:CGPoint, vc: UIViewController) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                self.rootContainerView.swipeAnimation(direction: (self.btnBootomView.center.x < point.x ? .rightToLeft : .leftToRight), duration: 0.3)
                print((self.btnBootomView.center.x < point.x ? "RtL" : "LtR"))
                UIView.animate(withDuration: 0.3, animations: {
                    self.btnBootomView.center.x = point.x
                }, completion: nil)
        }
    }
    
    func selectionMenu(num: Int) {
        btnPast.isSelected = false
        btnUpComing.isSelected = false
        btnDraft.isSelected = false
        
        selectedMenu = num
        switch num {
        case 1:
            print("Upcoming")
            btnUpComing.isSelected = true
            let nextVC = ManageEventsListVC.storyboardInstance
            nextVC.selectedTab = .upComing
            loadView(center: btnUpComing.center, vc: nextVC)
        case 2:
            print("Past")
            btnPast.isSelected = true
            let nextVC = ManageEventsListVC.storyboardInstance
            nextVC.selectedTab = .past
            loadView(center: btnPast.center, vc: nextVC)
        case 3:
            print("Draft")
            btnDraft.isSelected = true
            let nextVC = ManageEventsListVC.storyboardInstance
            nextVC.selectedTab = .draft
            loadView(center: btnDraft.center, vc: nextVC)
        default:
            print("No menu selection");break
        }
    }
    
    @objc func viewSwipped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                let pageLimit = UserData.shared.isRTL ? upperBound : 1
                if selectedMenu == pageLimit { return }
                changeMenu(isSwipeLeft: UserData.shared.isRTL)
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                let pageLimit = UserData.shared.isRTL ? 1 : upperBound
                if selectedMenu == pageLimit { return }
                changeMenu(isSwipeLeft: !UserData.shared.isRTL)
            default:
                break
            }
        }
    }
    
    func changeMenu(isSwipeLeft:Bool = true) {
        if isSwipeLeft{
            self.selectedMenu = min(upperBound, (self.selectedMenu + 1))
        }else{
            self.selectedMenu = max(1, (self.selectedMenu - 1))
        }
        selectionMenu(num: selectedMenu)
        
        //        switch selectedMenu {
        //        case 1:
        //            print("From Upcoming")
        //            selectedMenu = 1
        //            selectionMenu(num: selectedMenu)
        //        case 2:
        //            print("From Past")
        //            selectedMenu = 2
        //            selectionMenu(num: selectedMenu)
        //        case 3:
        //            print("From Draft")
        //            selectedMenu = 3
        //            selectionMenu(num: selectedMenu)
        //        default:
        //            break
        //        }
        
    }
    
}


