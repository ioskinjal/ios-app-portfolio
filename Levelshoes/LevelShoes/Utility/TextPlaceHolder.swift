//
//  TextPlaceHolder.swift
//  LevelShoes
//
//  Created by Maa on 15/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
class TextPlaceHolder {
    
    
    static func firstTextFieldplaceHolder(text:String, textfieldname :UITextField)
    {
        var myMutableStringTitle = NSMutableAttributedString()
        let Name: String?  = text
        
        myMutableStringTitle = NSMutableAttributedString(string:Name!)
        let range = (myMutableStringTitle.string as NSString).range(of: "*")
        
        myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)    // Color
        textfieldname.attributedPlaceholder = myMutableStringTitle
        
        
    }
    
    static func textFieldPlaceHolder(text: String,textFieldname: UITextField,startIndex: Int){
        let stringCount = text.count
        let AttriburedString = NSMutableAttributedString(string: text)

        AttriburedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorNames.c4747 , range: .init(location: startIndex, length: stringCount))

                   let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
                   AttriburedString.append(asterix)
        textFieldname.attributedPlaceholder = AttriburedString
        
    }
    static func textFieldPlaceHolderReturnString(text: String,textFieldname: UITextField,startIndex: Int,endIndex: Int) -> String{
           
           let AttriburedString = NSMutableAttributedString(string: text)

           AttriburedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: .init(location: startIndex, length: endIndex))

                      let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
                      AttriburedString.append(asterix)
           textFieldname.attributedPlaceholder = AttriburedString
        let str = String(describing: textFieldname)
        return str
       }
}


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
