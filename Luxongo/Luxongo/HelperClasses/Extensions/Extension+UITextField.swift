//
//  Extension+UITextField.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension UITextField{
    //This method used to searching methos Or Serching API call
    func writingTimeGetTextFieldString(string: String) -> String {
        let replacementString = string
        let textFieldString = self.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = textFieldString! + replacementString
        }
        else if (textFieldString?.count ?? 0) > 0{ // if it was a delete character
            finalString = String(textFieldString!.dropLast())
            if finalString.count <= 0 { //if all character are deleted..then show all values
                finalString = ""
            }
        }
        return finalString
    }
    
}


extension UITextField{
    
    func leftView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
//        view.backgroundColor = UIColor.red
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 5, y: 5, width:20, height:20)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.leftView = view;
        self.leftViewMode = UITextField.ViewMode.always;
    }
    
    func rightView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.red
        let imgView = UIImageView()
        imgView.frame = CGRect(x: -10, y: 5, width:15, height:15)//CGRect(x: 0, y: 0, width: 15, height: 15)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.rightView = view;
        self.rightViewMode = UITextField.ViewMode.always
    }
    
    func resetTextField() {
        self.resignFirstResponder()
        self.text = nil
    }
    
    func setPlaceHolderColor(color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func setTextFiledAsRequired(string: String = "*", color: UIColor = UIColor.red) {
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = placeholder.getStringInMutipleColor(strings: [string], colors: [color])
        }
    }
    
    func addDropDownArrow() {
        let arrowButton:UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: (self.frame.height) * 0.70, height: (self.frame.height) * 0.70)
            button.backgroundColor = .clear
            button.tintColor = UIColor.gray
            button.addTarget(self, action: #selector(didTapBtnArrow), for: .touchUpInside)
            return button
        }()
        self.rightView = arrowButton
        self.rightViewMode = .always
    }
    @objc private func didTapBtnArrow(_ sender:UIButton){
        if let textField = sender.superview as? UITextField{
            textField.becomeFirstResponder()
        }
    }
    
    func addPasswordToggel() {
        let passwordToggelButton:UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "eye-open").withRenderingMode(.alwaysTemplate), for: .selected)
            button.setImage(#imageLiteral(resourceName: "eye-close").withRenderingMode(.alwaysTemplate), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: (self.frame.height) * 0.70, height: (self.frame.height) * 0.70)
            button.backgroundColor = .clear
            button.tintColor = Color.Orange.theme
            button.addTarget(self, action: #selector(didTapBtnPasswordToggel), for: .touchUpInside)
            return button
        }()
        self.rightView = passwordToggelButton
        self.rightViewMode = .whileEditing
        self.isSecureTextEntry = true
    }
    @objc private func didTapBtnPasswordToggel(_ sender:UIButton){
        UIView.transition(
            with: (sender),
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                sender.isSelected.toggle()
                self.isSecureTextEntry.toggle()
        })
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

//https://mobikul.com/useful-uitextfield-extensions/
//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
//        }
//    }
//}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

/*
//Usage
txtField.setLeftPaddingPoints(50)
//or
txtField.setRightPaddingPoints(50)
*/

private var KeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &KeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &KeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])//prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}

extension UITextField {
    class func connectAllTxtFieldFields(txtfields:[UITextField]) -> Void {
        guard let last = txtfields.last else {
            return
        }
        for i in 0 ..< txtfields.count - 1 {
            txtfields[i].returnKeyType = .next
            txtfields[i].addTarget(txtfields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}
//UITextField.connectAllTxtFieldFields(txtfields: [txtField, txtField2, txtField3])


//extension UITextField{
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            let color = UIColor.init(cgColor: layer.borderColor!)
//            return color
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowColor = UIColor.black.cgColor
//            layer.shadowOffset = CGSize(width: 0, height: 2)
//            layer.shadowOpacity = 0.4
//            layer.shadowRadius = shadowRadius
//        }
//    }
//}



@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}



extension UITextField{
    
    var _text: String{
        return (self.text ?? "").trimmingCharacters(in: .whitespaces)
    }
    
    var isEmpty: Bool{
        return ( self._text == "" ? true : false )
    }
}


extension UITextField{
    func setCurrentDate(formate:String = DateFormatter.appDateTimeFormat, date:Date = Date()) {
        self.text = date.dateAsString(formate: formate)
    }
}
