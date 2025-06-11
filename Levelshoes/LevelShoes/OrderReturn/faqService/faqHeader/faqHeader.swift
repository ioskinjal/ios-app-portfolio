//
//  faqHeader.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
@IBDesignable
class faqHeader: UIView {
    @IBOutlet weak var sepratorLine: UIView!
    @IBOutlet weak var viewButtonContainer: UIView!
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
           lblTitle.lineBreakMode = .byWordWrapping
           lblTitle.numberOfLines = 0
           lblTitle.textColor = UIColor.black
           let textContent = "How do I place an order on Level Shoes app?"
           
           let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Regular", size: 18)!
           ])
           let textRange = NSRange(location: 0, length: textString.length)
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = 1.33
                textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
           lblTitle.attributedText = textString
           lblTitle.sizeToFit()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "faqHeader", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @IBAction func ButtonPressed(_ sender: UIButton) {
        
        if sender.isSelected == true {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //self.viewButtonContainer(view: sender, fromValue: M_PI / 2, toValue:0, duration: 0.5)
                self.sectionButton.isSelected = true
                sender.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //self.viewButtonContainer(view: sender, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
                
               self.sectionButton.isSelected = false
                sender.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
            }, completion: nil)
        }

    }
    
}
