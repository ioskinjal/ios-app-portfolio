//
//  MovieDetailsTableViewCell.swift
//  sampleColView
//
//  Created by Ankoos on 20/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk

protocol DetailsTableViewCellProtocal {
    func selectedRollerPosterItem(item: Card) -> Void
}

class DetailsTableViewCell: UITableViewCell, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SectionCVCProtocal,DetailsChildViewControllerDelegate {
    
        
    @IBOutlet weak var recommendationCV: UICollectionView!
    var sectionDetails:Section?
    var pageContent:PageContentResponse?
    var viewController:UIViewController?
    var delegate : DetailsTableViewCellProtocal?
    weak var currentViewController: UIViewController?
    weak var updatingViewController: UIViewController?
    let secInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    static let nibname:String = "DetailsTableViewCell"
    static let identifier:String = "DetailsTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpData(section:Section?,pageContent:PageContentResponse) {
        self.pageContent = pageContent
        if pageContent.tabsInfo.tabs.count > 0 {
            for subView in self.contentView.subviews {
                subView.removeFromSuperview()
            }
            let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
            let newViewController = homeStoryboard.instantiateViewController(withIdentifier: "DetailsChildViewController") as! DetailsChildViewController
            self.currentViewController = newViewController
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            newViewController.pageDataContent = pageContent
            newViewController.delegate = self
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.viewController?.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.contentView)

        }
        else {
            self.sectionDetails = section
            
            if recommendationCV != nil {
                recommendationCV.alwaysBounceVertical = true
                
                recommendationCV.setContentOffset(CGPoint.zero, animated: true)
                recommendationCV.register(UINib(nibName: SectionCVC.nibname, bundle: nil), forCellWithReuseIdentifier: SectionCVC.identifier)
                recommendationCV.reloadData()
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.sectionDetails?.sectionInfo.dataType == "movie" {
            return CGSize(width: self.frame.width, height: 239)
        }
        else {
            if productType.iPad{
                return CGSize(width: self.frame.width, height: 220)
            }
            return CGSize(width: self.frame.width, height: 172)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionData = self.sectionDetails?.sectionData
        let sectionInfo = self.sectionDetails?.sectionInfo
        let sectionControls = self.sectionDetails?.sectionControls
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCVC.identifier, for: indexPath) as! SectionCVC
        if sectionInfo?.dataType == "movie" {
            cell.collectionViewHeightConstraint.constant = 199.0
        }
        else {
            if productType.iPad {
                cell.collectionViewHeightConstraint.constant = 180.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = 132.0
            }
        }
        if (sectionInfo?.name .isEmpty)! {
            cell.myLbl.text = sectionInfo?.code.capitalized
        }
        else {
            cell.myLbl.text = sectionInfo?.name
        }
        cell.setUpData(sectionData: sectionData!, sectionInfo: sectionInfo!,sectionControls: sectionControls!, pageData: self.pageContent!)
        cell.moreBtn.isHidden = true
        cell.delegate = self
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    //MARK: - Custom Methods
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        if oldViewController == newViewController {
            return
        }
        oldViewController.willMove(toParent: nil)
        self.currentViewController?.addChild(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.contentView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        updatingViewController = newViewController
        UIView.animate(withDuration: 0.5, animations: {
            if newViewController == self.updatingViewController{
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            }
        },
                       completion: { finished in
                        if newViewController == self.updatingViewController{
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParent()
                            newViewController.didMove(toParent: self.viewController)
                        }
        })
    }

    func addSubview(subView:UIView, toView parentView:UIView) {
        
        for subView in parentView.subviews{
            subView.removeFromSuperview()
        }
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }

    //MARK: - movie custom delegate methods
    func didSelectedRollerPosterItem(item: Card) -> Void{
        self.delegate?.selectedRollerPosterItem(item: item)
    }
    func rollerPoster_moreClicked(sectionData:SectionData,sect_data:SectionInfo,sectionControls:SectionControls){
    }

    //MARK: - recommendations delegate methods
    func didSelectedRecommendation(card : Card) {
        self.delegate?.selectedRollerPosterItem(item: card)
    }
}
