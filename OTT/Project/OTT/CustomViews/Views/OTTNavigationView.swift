//
//  OTTNavigationView.swift
//  OTT
//
//  Created by Muzaffar Ali on 13/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
@objc protocol OTTNavigationViewDelegate {
    @objc func didTapOnBackButton(navigationBarView : OTTNavigationView)
}

@IBDesignable
class OTTNavigationView: UIView {
    static let height = 65
    weak var delegate : OTTNavigationViewDelegate?

    private var _backButton : UIButton?
    var backButton : UIButton{
        get{
            if _backButton == nil{
                _backButton = UIButton()
                _backButton!.frame = CGRect.init(x: 0, y: 0, width: 62, height: OTTNavigationView.height)
                _backButton!.setImage(UIImage.init(named: "backIcon") , for: UIControl.State.normal)
                _backButton!.addTarget(self, action: #selector(OTTNavigationView.backButtonTap) , for: UIControl.Event.touchUpInside)
            }
            return _backButton!
        }
        
    }
    
    private var _titleLabel : UILabel?
    private var titleLabel : UILabel{
        get{
            if _titleLabel == nil{
                // Do any additional setup after loading the view, typically from a nib.
                _titleLabel = UILabel()
                _titleLabel!.font = UIFont.ottRegularFont(withSize: 18)
                _titleLabel!.textColor = AppTheme.instance.currentTheme.cardTitleColor
                _titleLabel!.textAlignment = .left
                _titleLabel!.numberOfLines = 1
                _titleLabel!.frame = CGRect.init(x: Int(backButton.frame.origin.x + backButton.frame.size.width), y: 0, width: 300, height: OTTNavigationView.height)
            }
            return _titleLabel!
        }
    }

    @IBInspectable var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    @IBInspectable var backColor: UIColor = AppTheme.instance.currentTheme.navigationBarColor {
        didSet {
            self.backgroundColor = backColor
        }
    }

    //MARK: Initializers
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Custom Methods
    
    @objc func backButtonTap(){
        self.delegate?.didTapOnBackButton(navigationBarView: self)
        printYLog(#function)
    }
    
    func setup() {
        self.addSubview(self.backButton)
        self.addSubview(self.titleLabel)
        self.backgroundColor = .red
    }
    
    func configure() {
        self.backgroundColor = self.backColor
    }
    
}
