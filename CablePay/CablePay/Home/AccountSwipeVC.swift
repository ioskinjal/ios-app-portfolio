//
//  AccountSwipeVC.swift
//  CablePay
//
//  Created by Harry on 12/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class AccountSwipeVC: UIViewController {
    
    static var storyboardInstance:AccountSwipeVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: AccountSwipeVC.identifier) as? AccountSwipeVC
    }
    
@IBOutlet weak var pageView: UIPageControl!
    
    var VisitoDetailPageVC:AccountPageController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountPageController"{
            if let VisitorVC = segue.destination as? AccountPageController{
                self.VisitoDetailPageVC = VisitorVC
                self.VisitoDetailPageVC?.pageViewControllerDelegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
extension AccountSwipeVC:AccountPageControllerDelegate{
    func setupPageController(numberOfPages: Int) {
        
    }
    func accountPageController(visitorPageViewController: AccountPageController,
                                   didUpdatePageCount count: Int) {
        pageView.numberOfPages = count
    }
    
    func accountPageController(visitorPageViewController: AccountPageController,
                                   didUpdatePageIndex index: Int) {
        pageView.currentPage = index
    }
    func turnPageController(to index: Int) {
        if index == 0{
            pageView.currentPage = index
        }else if index == 1{
            pageView.currentPage = index
        }else{
            pageView.currentPage = index
        }
    }
}
