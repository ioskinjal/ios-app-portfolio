//
//  SearchBusinessVC.swift
//  Explore Local
//
//  Created by NCrypted on 06/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class SearchBusinessVC: UIViewController {

    static var storyboardInstance:SearchBusinessVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: SearchBusinessVC.identifier) as? SearchBusinessVC
    }
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewBusiness: UICollectionView!{
        didSet{
            collectionViewBusiness.delegate = self
            collectionViewBusiness.dataSource = self
            collectionViewBusiness.register(BusinessListCell.nib, forCellWithReuseIdentifier: BusinessListCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchBusinessVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessListCell.identifier, for: indexPath) as? BusinessListCell else {
            fatalError("Cell can't be dequeue")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 7 ), height: 197)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
