//
//  ImageCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 02/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    var isVisible = false
    weak var scrollView : UIScrollView? {
                didSet {
                    
                    kvoToken?.invalidate()
                    guard let scrollView = scrollView, let _window = self.window else {
                        self.imgMain.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
                        return }
                    kvoToken = scrollView.observe(\.contentOffset, options: .new) { initial, change in
                        
                        guard self.isVisible == true else { return }
                        guard let pointY = self.scrollView?.convert(self.frame.origin, to: self.window).y else { return }
                        
                        let delta = pointY / _window.frame.height
                        let ty = -60 * delta
                        
                        let transform = CATransform3DMakeTranslation(0, ty, 0)
                        self.imgMain.layer.transform = transform
                    }
                }
    }
    var kvoToken: NSKeyValueObservation?

    @IBOutlet weak var conTopimgview: NSLayoutConstraint!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblSubHead: UILabel!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var imgMain: UIImageView!

    var parentVC:LatestHomeViewController?{
        didSet{
//            parentVC?.tblHome.delegate = self
        }
    }
    
   var data : [SourceLanding.DataList.ArrayData]? {
        didSet{
           // setData()
        }
    }
    
    func offset(offset: CGPoint) {
        imgMain.frame = imgMain.bounds
    }
    
    func setData() {
        for i in 0..<(data?.count)! {
            for j in 0..<(data![i].elements.count) {
                if data?[i].elements[j].type == "button"{
                    btn.setTitle(data?[i].elements[j].content, for: .normal)
                    
                    btn.setTitleColor(UIColor(hexString: data?[i].elements[j].foreground_color ?? "ffffff"), for: .normal)
                    btn.setBackgroundColor(color: UIColor(hexString: data?[i].elements[j].background_color ?? "ffffff"), forState: .normal)
                    if data?[i].elements[j].background_color == "" {
                        let imageView = UIImageView()
                        imageView.downLoadImage(url: data?[i].elements[j].background_image ?? "")
                        btn.setBackgroundImage(imageView.image, for: .normal)
                    }
                    
                    
                }
                else if data?[i].elements[j].type == "text"{
                    lblSubHead.text = data?[i].elements[j].content
                    lblSubHead.textColor = UIColor(hexString: data?[i].elements[j].foreground_color ?? "ffffff")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
        let fontName = lblHead.font.fontName
        if deviceIsSmallerThanIphone7() {
            lblHead.font = UIFont(name: fontName, size: 40)
        } else {
            lblHead.font = UIFont(name: fontName, size: 45)
        }
    
        // Initialization code
        if UserDefaults.standard.value(forKey: "language")as? String == "ar"{
            lblHead.textAlignment = .right
        } else {
            lblHead.textAlignment = .left
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblHead.text = ""
        lblSubHead.text = ""
        btn.setTitle("", for: .normal)
        btn.setBackgroundImage(nil, for: .normal)
        imgMain.image = nil
    }
}
/*
extension ImageCell:UITableViewDelegate{
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
     var constant = constVertical.constant
       let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if translation.y > 0 {
            constant += 0.25;
            if (20.0 < constant)
                       {
                        constant = 20.0;
                       }
        } else {
            constant -= 0.25
            if (-1 * 20.0 > constant)
            {
                constant = -1 * 20.0;
            }
        }
        
        constVertical.constant = constant;
        

    }
    
}
 */

class HighlightButton: UIButton {
    private var normalColor: UIColor?
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                normalColor = backgroundColor
                backgroundColor = UIColor.lightGray
            } else {
                backgroundColor = normalColor
            }
        }
    }
}
