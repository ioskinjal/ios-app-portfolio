//
//  Extension+UITextView.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


//https://finnwea.com/blog/adding-placeholders-to-uitextviews-in-swift
/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    public func setPlaceHolderFontColor(font: UIFont, color: UIColor){
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            placeholderLabel.textColor = color
            placeholderLabel.font = font
        }
    }
    
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


extension UITextView{
    
    var _text: String{
        return (self.text ?? "").trimmingCharacters(in: .whitespaces)
    }
    
    var isEmpty: Bool{
        return ( self._text == "" ? true : false )
    }
}

