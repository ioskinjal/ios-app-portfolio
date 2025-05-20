//
//  ProductDetailVC.swift
//  MIShop
//
//  Created by NCrypted on 16/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailVC: BaseViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductDetail: UILabel!
    @IBOutlet weak var lblProductBrand: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var tblComents: UITableView!{
        didSet{
            tblComents.register(CommentListCell.nib, forCellReuseIdentifier: CommentListCell.identifier)
            tblComents.dataSource = self
            tblComents.delegate = self
        }
    }
    @IBOutlet weak var txtAddComment: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Followers", action: #selector(btnSideMenuOpen))
        navigationBar.btnLike.isHidden = false
        navigationBar.btnfav.isHidden = false
        navigationBar.btnShop.isHidden = false
        navigationBar.btnShare.isHidden = false
        let localSource = [ImageSource(imageString: "image-1")!, ImageSource(imageString: "image-2")!, ImageSource(imageString: "image-3")!]
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    @objc func btnSideMenuOpen()
    {
       self.navigationController?.popViewController(animated: true)
    }
   
    // MARK: - Lifecycle methods
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentListCell.identifier) as? CommentListCell else {
            fatalError("Cell can't be dequeue")
        }
       cell.imgUser.setRadius()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Detail screen
       
        
    }
    
}
