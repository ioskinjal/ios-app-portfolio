//
//  SliderCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 03/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

func isUserArabic() -> Bool {
    return UserDefaults.standard.string(forKey: string.userLanguage) == string.Arabic
}

func isRTL() -> Bool {
    if let semantic = UIApplication.shared.keyWindow?.semanticContentAttribute {
        let layoutDirection = UIView.userInterfaceLayoutDirection( for: semantic)
        return layoutDirection == .rightToLeft || isUserArabic()
    }
    return false || isUserArabic()
}
func category(for index: Int) -> String {
    let array = ["women", "men", "kids"]
    return array[index]
}

class SliderCell: UITableViewCell {
    
    var userData: AddressInformation?
    var addressArray : [Addresses] = [Addresses]()
    let checkoutModel = CheckoutViewModel()
    var navController:UINavigationController?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var animationView: AnimationView!
    
    static let underlineViewColor: UIColor = UIColor.init(hexString: "EEEEEE")
    static let underlineViewHeight: CGFloat = 1
    
    @IBOutlet weak var sliderArrowBottomConstraint: NSLayoutConstraint!
        {
        didSet {
            if deviceIsSmallerThanIphone7() {
                sliderArrowBottomConstraint.constant = 180
            }
        }
    }
    @IBOutlet weak var btnMoreInfo: UIButton!{
        didSet {
            btnMoreInfo.setTitle("moreInfo".localized, for: .normal)
            btnMoreInfo.addTextSpacing(spacing: 1.5, color: "ffffff")
            btnMoreInfo.tintColor = UIColor.white
            btnMoreInfo.underline()
        }
    }
    @IBOutlet weak var btnUpdate: UIButton!{
        didSet {
            btnUpdate.setTitle("updateAddress".localized, for: .normal)
            btnUpdate.underline()
        }
    }
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var btnKids: UIButton!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnMen: UIButton!
    @IBOutlet weak var viewSlider: UIView?
    @IBOutlet weak var imgFlag: UIImageView?
    @IBOutlet weak var btnCloseSignIn: UIButton?{
        didSet {
            btnCloseSignIn?.addTarget(self, action: #selector(onClickCloseSignIn), for: .touchUpInside)
        }
    }
    @IBOutlet weak var topBar: UIStackView!
    
    var closeSignIn: (() -> Void)?
    
    @IBOutlet weak var sliderArrow: UIImageView!
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var btnCloseSignedIn: UIButton!{
        didSet {
            btnCloseSignedIn.addTarget(self, action: #selector(onClickCloseSignedIn), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnGo: UIButton!{
        didSet {
            btnGo.setTitle("LETS GO".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnGo.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
            
        }
    }
    @IBOutlet weak var lblRegisterDesc: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblRegisterDesc.addTextSpacing(spacing: 0.5)
            }
            lblRegisterDesc.text = "register_desc".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblRegisterDesc.font = UIFont(name: "Cairo-Light", size: 18)
               
            }
        }
    }
    @IBOutlet weak var lblRegister: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language) as? String ?? "en" == "en"{
                lblRegister.addTextSpacing(spacing: 1.5)
            }
            lblRegister.text = "REGISTER OR SIGN IN".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblRegister.font = UIFont(name: "Cairo-SemiBold", size: 14)
               // btnKids.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }

        }
    }
    @IBOutlet weak var leftShadow: UIImageView!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language) as? String ?? "en" == "en" {
                leftShadow.image = #imageLiteral(resourceName: "overlay_right")
                leftShadow.contentMode = .right
            }
        }
    }
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var lblSignedInlbl2: UILabel!
    @IBOutlet weak var viewSignedIn: UIView!
    @IBOutlet weak var lblYouAre: UILabel!{
        didSet{
            lblYouAre.text = "YOU ARE IN".localized
        }
    }

    @IBOutlet weak var lblSignedInDesc: UILabel!
    
    @IBOutlet weak var btn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 18)
            }
        }
    }
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var lblSubHead: UILabel! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblSubHead.addTextSpacing(spacing: 0.5)
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSubHead.font = UIFont(name: "Cairo-Light", size: 20)
            }
        }
    }
    
    
    @IBOutlet weak var constVertical: NSLayoutConstraint!
    @IBOutlet weak var constWidth: NSLayoutConstraint!
    @IBOutlet weak var lblHead: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                //lblHead.font = UIFont(name: "Cairo-Bold", size: 60)
                lblHead.font = UIFont(name: "Cairo-Light", size: lblHead.font.pointSize)
            }
        }
    }
    
    var closeSignViewClicked: (() -> Void)?
    
    var parentVC = LatestHomeViewController()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.updateLayoutForLine()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.updateLayoutForLine()
        })
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        DispatchQueue.main.async {
            self.updateLayoutForLine()
        }
    }
    
    private func getButtonForCategory() -> UIButton {
        switch self.parentVC.SelectedCat {
            case "women":
                return self.btnWomen
            case "men":
                return self.btnMen
            case "kids":
                return self.btnKids
            default:
                return self.btnWomen
        }
    }
    private func updateLayoutForLine() {
        let btn: UIButton = getButtonForCategory()
        
        self.viewSegment.frame = CGRect(x: self.topBar.frame.minX + btn.frame.minX + btn.titleLabel!.frame.minX, y: self.topBar.frame.maxY, width: btn.titleLabel!.frame.width, height: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblHead.text = ""
        lblSubHead.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(changeCategory), name: Notification.Name(notificationName.changeCategory), object: nil)
        deSelectAll()
        btnMen.setTitle("MEN".localized, for: .normal)
        btnKids.setTitle("KIDS".localized, for: .normal)
        btnWomen.setTitle("WOMEN".localized, for: .normal)
        
        viewSegment.translatesAutoresizingMaskIntoConstraints = false
        updateLayoutForLine()
        
        animationView.hideSliderView = true
        animationView.delegate = self
        
        let fontName = lblHead.font.fontName
        if deviceIsSmallerThanIphone7() {
            topBar.spacing = 13
            lblHead.font = UIFont(name: fontName, size: 40)
        } else {
            topBar.spacing = 13
            lblHead.font = UIFont(name: fontName, size: 45)
        }

        DispatchQueue.main.async {
            self.selectCategory(self.getButtonForCategory(), proceedAnyway: true, animated: false)
        }
        
    }
    
    @IBAction func moreInfoBtnClicked(_ sender: Any) {
        print("ok")
        DispatchQueue.main.async {
            let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
            let changeVC = storyboards.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
             changeVC!.screenType = "TermsAndCondition"
            self.navController?.pushViewController(changeVC!, animated: true)
        }
        
    }
    @objc func changeCategory(_ notification:Notification){
          setSelectedCategory()
    }
    @IBAction func updateInfoClicked(_ sender: Any) {
        
        self.checkoutModel.getAddrssInformation(success: { (response) in
            print(response)
            self.userData = response
            guard let items = self.userData?.addresses else {
                return
            }
            self.addressArray = items
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "PersonalDetailStoryBord", bundle: Bundle.main)
                let returnOrderVC: PersonalDetailViewController! = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as? PersonalDetailViewController
                returnOrderVC.userData = self.userData
                returnOrderVC.addressArray = self.addressArray
                
                self.navController?.pushViewController(returnOrderVC!, animated: true)
            }
            
        }) {
            
        }
    }
    
    func setSelectedCategory() {
        let select = UserDefaults.standard.value(forKey: "category") as! String
        let strCategory = String(describing: select)
        if strCategory == CommonUsed.globalUsed.genderMen {
            selectCategory(btnMen)
        } else if strCategory == CommonUsed.globalUsed.genderWomen {
            selectCategory(btnWomen)
        } else if strCategory == CommonUsed.globalUsed.genderKids {
            selectCategory(btnKids)
        }
    }
    private func selectCategory(_ sender: UIButton, proceedAnyway: Bool = false, animated: Bool = true) {
        let index = sender.tag
        if parentVC.currentIndex != index {
            parentVC.currentIndex = index
        } else if proceedAnyway == false {
            return
        }
        
        enabledButtons(false)
        deSelectAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            proceed()
        })
        
        animationView.scroll(to: index, animated: animated) { [weak self] in
            guard let `self` = self else { return }
            let cat = category(for: index)
            self.parentVC.SelectedCat = cat
            self.enabledButtons(true)
        }
        
        func proceed() {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                sender.titleLabel?.font = UIFont(name: "Cairo-Bold", size: 20)
            } else {
               sender.titleLabel?.font = BrandenFont.bold(with: 16.0)
            }
            sender.setNeedsLayout()
            sender.layoutIfNeeded()
            let labelX = (sender.titleLabel?.frame.origin.x ?? 0)
            let leading = topBar.frame.minX + sender.frame.origin.x + labelX
            let f = CGRect(x: leading, y: topBar.frame.maxY, width: sender.titleLabel!.frame.width, height: 1)
            UIView.animate(withDuration: 0.2) {
                self.viewSegment.frame = f
            }
        }
    }
    
    @IBAction func onClickCategory(_ sender: UIButton) {
        selectCategory(sender, proceedAnyway: false, animated: true)
    }
    
    func deSelectAll() {
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            btnMen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            btnKids.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            btnWomen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            
        }else{
            btnMen.titleLabel?.font = BrandenFont.regular(with: 16.0)
            btnKids.titleLabel?.font = BrandenFont.regular(with: 16.0)
            btnWomen.titleLabel?.font = BrandenFont.regular(with: 16.0)
        }

    }
    
    @objc func onClickCloseSignIn(_ sender:UIButton) {
        self.closeSignIn?()
    }

    @objc func onClickCloseSignedIn(_ sender:UIButton){
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [], animations: {
            if self.viewSignedIn.isHidden == false {
                self.viewSignedIn.isHidden = true
            } else {
                self.viewSignIn.isHidden = true
            }
            self.closeSignViewClicked?()
        }, completion: nil)
        
    }
    
    func enabledButtons(_ value: Bool) {
        for b in buttons {
            b.isEnabled = value
        }
    }
    
}
extension UISegmentedControl {
    
    func removeBorder() {
        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.orange], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
    }
    
    func setupSegment() {
        self.removeBorder()
        let segmentUnderlineWidth: CGFloat = self.bounds.width
        let segmentUnderlineHeight: CGFloat = 2.0
        let segmentUnderlineXPosition = self.bounds.minX
        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.gray
        
        self.addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
        
    }
    func addUnderlineForSelectedSegment() {
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.orange
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
}
extension SliderCell:UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var constant = constVertical.constant
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if translation.y > 0 {
            constant += 0.5;
            if 20.0 < constant {
                constant = 20.0;
            }
        } else {
            constant -= 0.25
            if -1 * 20.0 > constant {
                constant = -1 * 20.0;
            }
        }
        constVertical.constant = constant;
    }
    
}

extension SliderCell: AnimationViewDelegate {
    func animationViewScrollProgress(progress: CGFloat) {
        
    }
    func animationViewScrolledToIndex(animationView: AnimationView, _ index: Int) {
        let _index = animationView.getIndexRespectRTL(index)
        if _index == 0 {
            selectCategory(btnWomen)
        } else if _index == 1 {
            selectCategory(btnMen)
        } else {
            selectCategory(btnKids)
        }
    }
}
