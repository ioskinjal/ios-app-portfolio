//
//  LoginVCMain.swift
//  CablePay
//
//  Created by Harry on 10/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class LoginVCMain: UIViewController {

    @IBOutlet weak var pageView: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    var VisitoDetailPageVC:VisitorPageViewController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VisitorPageViewController"{
            if let VisitorVC = segue.destination as? VisitorPageViewController{
                self.VisitoDetailPageVC = VisitorVC
                self.VisitoDetailPageVC?.pageViewControllerDelegate = self
            }
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
extension LoginVCMain:VisitoPageViewControllerDelegate{
    func setupPageController(numberOfPages: Int) {
        
    }
    func visitorPageViewController(visitorPageViewController: VisitorPageViewController,
                                    didUpdatePageCount count: Int) {
        pageView.numberOfPages = count
    }
    
    func visitorPageViewController(visitorPageViewController: VisitorPageViewController,
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
