//
//  UpgradeMemberShipPlanVC.swift
//  ThumbPin
//
//  Created by NCT109 on 12/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import HSCycleGalleryView

class UpgradeMemberShipPlanVC: BaseViewController {
    
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
   // @IBOutlet weak var pager: HSCycleGalleryView!
    static var storyboardInstance:UpgradeMemberShipPlanVC? {
        return StoryBoard.serviceNotifications.instantiateViewController(withIdentifier: UpgradeMemberShipPlanVC.identifier) as? UpgradeMemberShipPlanVC
    }
    var arrUpgradePlan = [UpgradePlanList]()
    var pager = HSCycleGalleryView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApiUpgradeMembedrShipPlane()
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    // Override to remove this view from the navigation stack
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove self from navigation hierarchy
        guard let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.index(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
    }
    func callApiUpgradeMembedrShipPlane() {
        let dictParam = [
            "action": Action.getList,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getMemberShipPlan(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.arrUpgradePlan = ResponseKey.fatchData(res: dict, valueOf: .plans).ary.map({UpgradePlanList(dic: $0 as! [String:Any])})
            self.showCarouselView()
        }
    }
    func callApiPaymentURL(_ planID: String) {
        let dictParam = [
            "action": Action.pre_paypal,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "plan_id": planID
            ] as [String : Any]
        ApiCaller.shared.getPaymentUrl(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            isfromChat = false
            let paypalUrl = GetPaypalURL(dic: dict["data"] as? [String : Any] ?? [String:Any]())
            if !paypalUrl.paypal_url.isEmpty {
                let vc = PaypalPaymentVC.storyboardInstance!
                isfromChat = false
                vc.paypalUrl = paypalUrl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func callApiFreeMembedrShipPlane(_ planID: String) {
        let dictParam = [
            "action": Action.getfreeplan,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "plan_id": planID
        ] as [String : Any]
        ApiCaller.shared.getMemberShipPlan(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    func showCarouselView() {
        viewContainer.updateConstraints()
        viewContainer.layoutIfNeeded()
        view.layoutIfNeeded()
        pager = HSCycleGalleryView(frame: CGRect(x: 0, y: 0, width: viewContainer.frame.width, height: viewContainer.frame.height))
        pager.register(nib: UpgradeMembershipCell.nib, forCellReuseIdentifier: UpgradeMembershipCell.identifier)
        pager.delegate = self
        self.viewContainer.addSubview(pager)
        self.pager.reloadData()
        pager.scrollToSpecificIndex(1)
    }
    
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Upgrade Membership")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
    @objc func pressButtonBuyMembershipPlan(_ sender: UIButton) {
        if arrUpgradePlan[sender.tag].is_free == "n" {
            
        }
        else if arrUpgradePlan[sender.tag].is_free == "y" {
            callApiFreeMembedrShipPlane(arrUpgradePlan[sender.tag].id)
        }
        else if arrUpgradePlan[sender.tag].is_free == "" {
            callApiPaymentURL(arrUpgradePlan[sender.tag].id)
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UpgradeMemberShipPlanVC: HSCycleGalleryViewDelegate {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        pageControl.numberOfPages = arrUpgradePlan.count
        return arrUpgradePlan.count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "UpgradeMembershipCell", for: IndexPath(item: index, section: 0)) as! UpgradeMembershipCell
       cell.labelPlaneName.text = arrUpgradePlan[index].plan_name
       cell.labelTotalCredit.text = arrUpgradePlan[index].total_credits
       cell.labelPrice.text = arrUpgradePlan[index].price
       cell.btnBuy.setTitle(arrUpgradePlan[index].button_text, for: .normal)
       cell.btnBuy.tag = index
       cell.btnBuy.addTarget(self, action: #selector(self.pressButtonBuyMembershipPlan(_:)), for: .touchUpInside)
        if arrUpgradePlan[index].is_free == "n" {
            cell.btnBuy.backgroundColor = Color.Custom.darkGrayColor
        }else {
            cell.btnBuy.backgroundColor = Color.Custom.mainColor
        }
        if arrUpgradePlan[index].messaging == "y"{
            cell.lblMsg.text = localizedString(key: "Yes")
        }else{
            cell.lblMsg.text = localizedString(key: "No")
        }
        cell.lblDuration.text = arrUpgradePlan[index].duration + localizedString(key: "Days")
        return cell
    }
    func cycleGalleryViewscrollViewDidEndDecelerating(_ index: Int) {
        self.pageControl?.currentPage = index
    }
    
    func cycleGalleryViewscrollViewDidEndScrollingAnimation(_ index: Int) {
        self.pageControl?.currentPage = index
    }
    func cycleGalleryViewscrollViewDidScroll(_ index: Int) {
        self.pageControl?.currentPage = index
    }
    
}

