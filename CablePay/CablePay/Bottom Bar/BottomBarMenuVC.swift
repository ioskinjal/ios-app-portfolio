//
//  BottomBarMenuVC.swift
//  Dating Platform
//
//  Created by NCrypted Technologies on 05/09/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class BottomBarMenuVC: BaseViewController {
    static var storyboardInstance:BottomBarMenuVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: BottomBarMenuVC.identifier) as? BottomBarMenuVC
    }
    
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var lblSend: UILabel!
    
    @IBOutlet weak var imgMore: UIImageView!
    
    @IBOutlet weak var lblMore: UILabel!
    
    @IBOutlet weak var imgRequest: UIImageView!
    
    @IBOutlet weak var lblRequest: UILabel!
    
    @IBOutlet weak var imgReport: UIImageView!
    
    @IBOutlet weak var lblAccount: UILabel!
    
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var rootToContainrView: UIView!
    @IBOutlet weak var btnAccount: UIButton!{
        didSet{
            btnAccount.tag = 1
        }
    }
    @IBOutlet weak var btnSend: UIButton!{
        didSet{
            btnSend.tag = 2
        }
    }
    @IBOutlet weak var btnMore: UIButton!{
        didSet{
            btnMore.tag = 3
        }
    }
    @IBOutlet weak var btnRequest: UIButton!{
        didSet{
            btnRequest.tag = 4
        }
    }
    @IBOutlet weak var btnReport: UIButton!{
        didSet{
            btnReport.tag = 5
        }
    }
   
    var bottomSelectedMenu = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation()
        self.loadDefaultSelectedMenu()
        setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "Accounts", action: #selector(onClickProfile), isRightBtn: true, actionRight: #selector(onClickProfile), btnRightImg: #imageLiteral(resourceName: "ic_headphone"))
        
    }
    
    @objc func onClickProfile(_ sender:UIButton){
        
    }
    
    
    @IBAction func onClickBottomBar(_ sender: UIButton) {
        if bottomSelectedMenu != sender.tag - 0{
            bottomSelectedMenu = sender.tag - 0
            sender.isSelected = true
            loadDefaultSelectedMenu()
        }
    }
    
   
}
extension BottomBarMenuVC{
    func loadDefaultSelectedMenu()
    {
        var nextView: UIViewController!
//            btnSend.setImage(#imageLiteral(resourceName: "ic_send_white"), for: .normal)
//            btnMore.setImage(#imageLiteral(resourceName: "ic_send_white"), for: .normal)
//            btnReport.setImage(#imageLiteral(resourceName: "ic_headphone"), for: .normal)
//            btnReport.setImage(#imageLiteral(resourceName: "ic_user"), for: .normal)
            switch bottomSelectedMenu
            {
            case 0:
                print("Home")
                nextView = AccountSwipeVC.storyboardInstance
            case 1:
                print("Profile")
                if btnAccount.isSelected{
                    btnSend.isSelected = false
                    btnMore.isSelected = false
                    btnRequest.isSelected = false
                    btnReport.isSelected = false
                }
                //nextView = ProfileVC.storyboardInstance!
            case 2:
                print("Favorite")
                if btnSend.isSelected{
                    btnAccount.isSelected = false
                    btnMore.isSelected = false
                    btnRequest.isSelected = false
                    btnReport.isSelected = false
//                    btnSend.setImage(#imageLiteral(resourceName: "ic_send"), for: .normal)
                    lblSend.textColor = UIColor.black
                }else{
//                    btnSend.setImage(#imageLiteral(resourceName: "ic_send_white"), for: .normal)
                    lblSend.textColor = UIColor.white
                }
                //nextView = FavoriteVC.storyboardInstance!
            case 3:
                print("Like")
                if btnMore.isSelected{
                    btnSend.isSelected = false
                    btnAccount.isSelected = false
                    btnReport.isSelected = false
                    btnRequest.isSelected = false
//                    btnMore.setImage(#imageLiteral(resourceName: "like-active"), for: .normal)
                    lblMore.textColor = UIColor.black
                }else{
//                    btnMore.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                    lblMore.textColor = UIColor.white
                }
                //nextView = LikedYouVC.storyboardInstance!
            case 4:
                print("Message")
                if btnRequest.isSelected{
                    btnMore.isSelected = false
                    btnSend.isSelected = false
                    btnAccount.isSelected = false
                    btnReport.isSelected = false
                    btnRequest.setImage(#imageLiteral(resourceName: "message-active"), for: .normal)
                    lblRequest.textColor = UIColor.black
                }else{
//                    btnRequest.setImage(#imageLiteral(resourceName: "message"), for: .normal)
                    lblSend.textColor = UIColor.white
                }
                //nextView = MessageListVC.storyboardInstance!
            case 5:
                print("Search")
                if btnReport.isSelected{
                    btnMore.isSelected = false
                    btnRequest.isSelected = false
                    btnSend.isSelected = false
                    btnAccount.isSelected = false
//                    btnReport.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                    lblReport.textColor = UIColor.black
                }else{
//                    btnReport.setImage(#imageLiteral(resourceName: "search-active"), for: .normal)
                    lblReport.textColor = UIColor.white
                }
                //nextView = LikedYouVC.storyboardInstance!
            //self.prevPoint = self.btnEvent.center
            default:
                break
            }
            
            ViewEmbedder.embed(
                withViewController: nextView,
                parent: self,
                container: self.rootToContainrView){ vc in
                    // do things when embed complete
            }
    }
}
/*extension BottomBarMenuVC :BottomPageViewControllerDelegate{
    func setupPageController(numberOfPages: Int) {
    
    }
    func turnPageController(to index: Int) {
        if index == 0{
            if UserDefaults.standard.object(forKey: "IsInstall") as? Bool ?? false{
                if btnFav.isSelected || btnLike.isSelected || btnMessage.isSelected || btnSearch.isSelected || btnProfile.isSelected{
                    btnFav.isSelected = false
                    btnLike.isSelected = false
                    btnMessage.isSelected = false
                    btnSearch.isSelected = false
                    btnProfile.isSelected = false
                }
            }else{
                if btnFav.isSelected || btnLike.isSelected || btnMessage.isSelected || btnSearch.isSelected{
                    btnFav.isSelected = false
                    btnLike.isSelected = false
                    btnMessage.isSelected = false
                    btnSearch.isSelected = false
                }
                btnProfile.isSelected = true
                if btnProfile.isSelected{
                    btnFav.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
                    btnSearch.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                    btnMessage.setImage(#imageLiteral(resourceName: "message"), for: .normal)
                    btnLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }
            }
        }else if index == 1{
            if btnProfile.isSelected || btnLike.isSelected || btnMessage.isSelected || btnSearch.isSelected{
                btnProfile.isSelected = false
                btnLike.isSelected = false
                btnMessage.isSelected = false
                btnSearch.isSelected = false
            }
            btnFav.isSelected = true
            if btnFav.isSelected{
                btnFav.setImage(#imageLiteral(resourceName: "favourite-active"), for: .normal)
                btnSearch.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                btnMessage.setImage(#imageLiteral(resourceName: "message"), for: .normal)
                btnLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            }
        }else if index == 2{
            if btnProfile.isSelected || btnFav.isSelected || btnMessage.isSelected || btnSearch.isSelected{
                btnProfile.isSelected = false
                btnFav.isSelected = false
                btnMessage.isSelected = false
                btnSearch.isSelected = false
            }
            btnLike.isSelected = true
            if btnLike.isSelected{
                btnLike.setImage(#imageLiteral(resourceName: "like-active"), for: .normal)
                btnSearch.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                btnMessage.setImage(#imageLiteral(resourceName: "message"), for: .normal)
                btnFav.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
            }
        }else if index == 3{
            if btnProfile.isSelected || btnFav.isSelected || btnLike.isSelected || btnSearch.isSelected{
                btnProfile.isSelected = false
                btnFav.isSelected = false
                btnLike.isSelected = false
                btnSearch.isSelected = false
            }
            btnMessage.isSelected = true
            if btnMessage.isSelected{
                btnFav.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
                btnSearch.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                btnMessage.setImage(#imageLiteral(resourceName: "message-active"), for: .normal)
                btnLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            }
        }else if index == 4{
            if btnProfile.isSelected || btnLike.isSelected || btnMessage.isSelected || btnFav.isSelected{
                btnProfile.isSelected = false
                btnLike.isSelected = false
                btnMessage.isSelected = false
                btnFav.isSelected = false
            }
            btnSearch.isSelected = true
            if btnMessage.isSelected{
                btnFav.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
                btnSearch.setImage(#imageLiteral(resourceName: "search-active"), for: .normal)
                btnMessage.setImage(#imageLiteral(resourceName: "message"), for: .normal)
                btnLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            }
        }else{
            return
        }
    }
}*/
