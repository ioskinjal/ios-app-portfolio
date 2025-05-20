//
//  BaseVC.swift
//  BooknRide
//
//  Created by NCrypted on 02/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit


class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return textField.resignFirstResponder()
//    }
    
    func openMenu(){
        if self.slideMenuController() != nil {
            self.slideMenuController()?.openLeft()
        }
    }
    
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func sharedAppDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func presentLocationAlert(){
        
        let throwAlert = Alert()
        throwAlert.showAlertWithLeftAndRightCompletionHandler(titleStr: appConts.const.LBL_LOCATION, messageStr: appConts.const.LBL_LOCATION_SERVICE_DISABLED, leftButtonTitle: appConts.const.LBL_SETTINGS, rightButtonTitle: appConts.const.bTN_OK, leftCompletionBlock: {
            
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            
            
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                        // Checking for setting is opened or not
                        print("Setting is opened: \(success)")
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl!)
                }
            }
            
        }, rightCompletionBlock: {
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    func displayNetworkAlert(){
        
        stopIndicator()
        let alert = Alert()
        
        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: appConts.const.MSG_NETWORK, messageStr: appConts.const.MSG_NO_INTERNET, leftButtonTitle: appConts.const.bTN_OK, rightButtonTitle: appConts.const.LBL_SETTINGS, leftCompletionBlock: {
            
        }) {
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)

        }
    }
    
    
    func startIndicator(title:String){
        
        
        sharedAppDelegate().showLoader(title: title)
        
    }
    
    func stopIndicator(){
        
        sharedAppDelegate().hideLoader()
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
extension UITextField{
    
    func leftView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
        //view.backgroundColor = UIColor.clear
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 5, y: 5, width:15, height:15)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.leftView = view;
        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func rightView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
        //view.backgroundColor = UIColor.gray
        let imgView = UIImageView()
        imgView.frame = CGRect(x: -10, y: 5, width:15, height:15)//CGRect(x: 0, y: 0, width: 15, height: 15)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.rightView = view;
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func resetTextField() {
        self.resignFirstResponder()
        self.text = nil
    }
    
    func setPlaceHolderColor(color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func setPasswordToggle(normalImage icon1: UIImage, selectedImage icon2: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0,
                                             width: ((self.frame.height) * 0.70),
                                             height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon1, for: .normal)
        btnView.setImage(icon2, for: .selected)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        self.rightViewMode = .whileEditing
        self.rightView = btnView
        btnView.tag = 10101
        btnView.addTarget(self, action: #selector(btnEyeAction(_:)), for: .touchUpInside)
        isSecureTextEntry = true
    }
    
    @objc private func btnEyeAction(_ sender: UIButton) {
        self.isSecureTextEntry = sender.isSelected
        //sender.isSelected = !sender.isSelected
        UIView.transition(
            with: (sender),
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                guard sender === self.rightView?.viewWithTag(10101) as? UIButton else {
                    return
                }
                sender.isSelected = !sender.isSelected
        })
    }
    
}

//https://finnwea.com/blog/adding-placeholders-to-uitextviews-in-swift
/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    public func resetPlaceHolder(){
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
                placeholderLabel.isHidden = self.text.count > 0
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.isHidden = self.text.count > 0
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

extension UIViewController {
    //MARK:- UIAlertController
    func alert(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: appConts.const.bTN_OK, style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: appConts.const.bTN_OK, style: .default) {
            (action: UIAlertAction) in
            print("Youve pressed OK Button")
            completion()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func alert(title: String, message : String, actions:[String], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            
            let act = UIAlertAction(title: actions[i], style: .default, handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[String],style:[UIAlertActionStyle], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            
            let act = UIAlertAction(title: actions[i], style: style[i], handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
        
        //For iPad display actionsheet
        //alertController.popoverPresentationController?.sourceRect = button!.frame
        //alertController.popoverPresentationController?.sourceView = self.view
        
        //        self.present(alertController, animated: true, completion: nil)
    }
}
