//
//  ViewController.swift
//  Xphorm
//
//  Created by admin on 5/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DataModel{
    var image:UIImage
    var description:String
    var title:String
    
    init(image:UIImage,description:String,title:String) {
        self.image = image
        self.description = description
        self.title = title
    }
    
    
    static var staticData:[DataModel] = {
        var arr = [DataModel]()
        arr += [
            DataModel(image: #imageLiteral(resourceName: "searchSliderIcon-1"), description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",title: "Search Trainer"),
            DataModel(image: #imageLiteral(resourceName: "bookSliderIcon-2"), description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",title:"Book and Pay" ),
            DataModel(image: #imageLiteral(resourceName: "paymentSliderIcon-3"), description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",title:"Secure Payment" ),
        ]
        return arr
    }()
}

class showCaseVC: UIViewController {
    
    static var storyboardInstance:showCaseVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: showCaseVC.identifier) as? showCaseVC
    }
    
    @IBOutlet weak var collectionView:UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
     @IBOutlet weak var pageView:UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      UserDefaults.standard.set(true, forKey: "isFirstLogin")
        UserDefaults.standard.synchronize()
        
        pageView.numberOfPages = DataModel.staticData.count
    }
    @IBAction func onClickSkip(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults.standard.synchronize()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontrollerHome") as! UITabBarController
        
        UIApplication.shared.keyWindow?.rootViewController = viewController;
        
    }
}

extension showCaseVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataModel.staticData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? collectionViewCell else { return UICollectionViewCell()}
        cell.data = DataModel.staticData[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        pageView.currentPage = indexPath.row
    }
    
}
