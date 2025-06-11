//
//  TargetPage.swift
//  OTT
//
//  Created by Muzaffar on 05/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast


class TargetPage: NSObject {
    
    enum UserNavigationPageType {
        case unKnown

        case home

        case packages

        case userProfile

        case OTP
    }
    
    static func userNavigationPage(fromViewController:UIViewController, shouldUpdateUserObj:Bool,actionCode:Int, completion: @escaping (_ page:UserNavigationPageType) -> Void) {
        if shouldUpdateUserObj {
            OTTSdk.userManager.userInfo(onSuccess: { (_) in
                completion(self.userNavigationPage(fromViewController: fromViewController, actionCode: actionCode))
            }) { (error) in
                completion(.unKnown)
            }
        } else {
            completion(self.userNavigationPage(fromViewController: fromViewController, actionCode: actionCode))
        }
        
    }
    
    static func userNavigationPage(fromViewController:UIViewController,actionCode:Int) -> UserNavigationPageType {
        if actionCode == 1 || actionCode == 2 || actionCode == 3 || actionCode == 4{
             return .OTP
        }
        else if let _ = OTTSdk.preferenceManager.user {
            /* if user.isEmailVerified || user.isPhoneNumberVerified {
                return .home
            } else {
                return .OTP
            }*/
             return .home
        } else {
            return .unKnown
        }
    }
    
    static func getTargetPageObject(path : String, _ menuItem : Menu? = nil, completion : @escaping (UIViewController, PageInfo.PageType?) -> Void){
        var isDefaultPage = false
        if menuItem != nil, menuItem!.params != nil, menuItem!.params?.isLoginRequired == true {
            if (path == AppDelegate.getDelegate().favouritesTargetPath || path == "mylibrary" || path == "favourites" || (menuItem!.params?.isDarkMenu ?? false == true)) && OTTSdk.preferenceManager.user == nil {
                isDefaultPage = true
            }
        }
        else if (path == AppDelegate.getDelegate().favouritesTargetPath || path == "mylibrary" ||  (menuItem != nil && menuItem!.params?.isDarkMenu ?? false == true)) && OTTSdk.preferenceManager.user == nil  {
            isDefaultPage = true
        }
        
        if isDefaultPage == true {
            let defaultVC = self.defaultViewController()
            if path == AppDelegate.getDelegate().favouritesTargetPath || path == "favourites" {
                defaultVC.isFavView = true
                defaultVC.isMyLibraryView = false
            } else if path == "mylibrary" {
                defaultVC.isFavView = false
                defaultVC.isMyLibraryView = true
            }else if (menuItem != nil && menuItem!.params?.isDarkMenu ?? false == true) {
                defaultVC.isFavView = false
                defaultVC.isMyLibraryView = false
                defaultVC.isAfterDarkView = true
            }
            completion(defaultVC,PageInfo.PageType.unKnown)
        }
        else {
            OTTSdk.mediaCatalogManager.pageContent(path: path, onSuccess: { (pageContentResponse) in
                let pageType = pageContentResponse.info.pageType
                
                switch pageType {
                case .content:
                    let cvc = self.contentViewController()
                    cvc.pageContentResponse = pageContentResponse
                    AppDelegate.getDelegate().contentViewController = cvc
                    completion(cvc,pageType)
                    break
                case .player:
                    let cvc = self.playerViewController()
                    cvc.pageDataResponse = pageContentResponse
                    _ = playerVC?.view // Load view hierarchy
                    completion(cvc,pageType)
                    break
                case .list:
                    if pageContentResponse.info.attributes.contentType == "shorts" {
                        let cvc = self.shortsViewController()
                        cvc.pageResponse = pageContentResponse
                        cvc.targetPath = path
                        completion(cvc,pageType)
                    }else{
                        let cvc = self.moviesViewController()
                        cvc.pageResponse = pageContentResponse
                        cvc.targetPath = path
                        completion(cvc,pageType)
                    }
                    break
                case .details:
                    if appContants.appName == .gac {
                        let dvc = detailsViewController()
                        dvc.contentDetailResponse = pageContentResponse
                        AppDelegate.getDelegate().detailsViewController = dvc
                        completion(dvc,pageType)
                    }
                    else {
                        let dvc_old = detailsViewController_Old()
                        dvc_old.contentDetailResponse = pageContentResponse
                        AppDelegate.getDelegate().detailsViewController_old = dvc_old
                        completion(dvc_old,pageType)
                    }
                    
                    break
                default:
                    completion(self.defaultViewController(),pageType)
                    break
                }
                
            }) { (error) in
                completion(self.defaultViewController(),nil)
            }
        }
    }
    
    static func contentViewController() -> ContentViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        let homeStoryboard = UIStoryboard(name: "Content", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
    }
    
    static func defaultViewController() -> DefaultViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "DefaultViewController") as! DefaultViewController
    }
    
    static func moviesViewController() -> ListViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        let homeStoryboard = UIStoryboard(name: "Movies", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
    }
    static func shortsViewController() -> ShortsHomeVC{

        let homeStoryboard = UIStoryboard(name: "Content", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "ShortsHomeVC") as! ShortsHomeVC
    }
    static func detailsViewController() -> DetailsViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        return UIStoryboard(name: "Movies", bundle:nil).instantiateViewController(withIdentifier: "DetailsViewController3") as! DetailsViewController;
    }
    
    static func detailsViewController_Old() -> DetailsViewController_Old{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        return UIStoryboard(name: "Movies", bundle:nil).instantiateViewController(withIdentifier: "DetailsViewController_Old") as! DetailsViewController_Old;
    }
    static func tvGuideViewController() -> TVGuideViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "TVGuideViewController") as! TVGuideViewController
    }
    static func tinyGuideViewController() -> TinyGuideViewController{
//        if AppDelegate.getDelegate().isFromPlayerPage {
//            AppDelegate.getDelegate().isFromPlayerPage = false
//            if playerVC != nil{
//                playerVC?.removeViews()
//                playerVC = nil
//            }
//        }
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        return homeStoryboard.instantiateViewController(withIdentifier: "TinyGuideViewController") as! TinyGuideViewController
    }
    
    static func monthlyPlannerViewController() -> MonthlyPlannerViewController{
        let storyboard = UIStoryboard(name: "Planners", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MonthlyPlannerViewController") as! MonthlyPlannerViewController
    }
    
    static func accountViewController() -> NewAccountController{
        //        if AppDelegate.getDelegate().isFromPlayerPage {
        //            AppDelegate.getDelegate().isFromPlayerPage = false
        //            if playerVC != nil{
        //                playerVC?.removeViews()
        //                playerVC = nil
        //            }
        //        }
        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "NewAccountController") as! NewAccountController
    }

    static func playerViewController() -> PlayerViewController{
        if playerVC != nil{
            playerVC?.removeViews()
            playerVC = nil
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabs", bundle:nil)
        playerVC = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController
        //        playerVC?.expandViews()
        //        playerVC?.didStartDisplay()
        playerVC?.pageString = ""
        if appContants.appName == .tsat {
            playerVC?.castMediaController = GCKUIMediaController.init()
            playerVC?.castMediaController.delegate = playerVC
        }
        return playerVC!
    }
    
    static func userProfileViewController() -> UserProfileInfoViewController {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "UserProfileInfoViewController") as! UserProfileInfoViewController
        return storyBoardVC
    }

    static func otpViewController() -> OTPViewController {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        return storyBoardVC
    }
    static func searchViewController() -> SearchViewController {
    
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    } 
}
