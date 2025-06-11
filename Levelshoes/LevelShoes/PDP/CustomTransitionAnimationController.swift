//
//  CustomTransitionAnimationController.swift
//  LevelShoes
//
//  Created by Albert Musagitov on 13.08.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData

class CustomTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let selectedProduct: Int
    private let detailData : NewInData?
    
    
  
    
    init(originFrame: CGRect, selectedProduct: Int, detailData: NewInData?) {
        self.originFrame = originFrame
        self.selectedProduct = selectedProduct
        self.detailData = detailData
    }
   
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? ProductDetailVC else { return }
                
        let imageView = TransitionImageView(frame: originFrame)
        imageView.clipsToBounds = true
        
        let url = getImageUrl(at: 0)
        imageView.imageView.sd_setImage(with: url, completed: nil)
        
        let imageFinalFrameHeight = toVC.view.frame.size.height - 140 - 95
        let imageFinalFrame = CGRect(x: 0, y: 0, width: fromVC.view.frame.width, height: imageFinalFrameHeight)
        imageView.leftButton.alpha = 0
        
        let carouselView = CustomTransitionSliderView(frame: imageFinalFrame)
        carouselView.frame.origin.x = 40
        carouselView.frame.origin.y = carouselView.frame.height
        carouselView.frame.size.width -= 80
        carouselView.frame.size.height = 2
        carouselView.alpha = 0
        carouselView.clipsToBounds = true
        
        carouselView.setupData(selectedProduct, detailData: detailData)
        
        let titleContainer = DetailsView(frame: originFrame)
        titleContainer.clipsToBounds = true
        
        titleContainer.setupData(selectedProduct, detailData: detailData)
        
        let titleContainerFinalFrame = CGRect(x: 20, y: toVC.view.frame.size.height - 213, width: fromVC.view.frame.width - 40, height: 125)
        var titleContainerOriginFrame = titleContainerFinalFrame
        titleContainerOriginFrame.origin.y += titleContainerOriginFrame.height
        titleContainer.frame = titleContainerOriginFrame
        titleContainer.alpha = 0
        
        let addToBagContainer = AddToBagView(frame: CGRect(x: 0, y: toVC.view.frame.size.height, width: fromVC.view.frame.width, height: 93))
        var addToBagContainerFinalFrame = addToBagContainer.frame
        addToBagContainerFinalFrame.origin.y -= addToBagContainerFinalFrame.height
        addToBagContainer.alpha = 0
        
        let containerView = transitionContext.containerView
        
        let whiteBackgroundView = UIView(frame: containerView.bounds)
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.alpha = 0
        
        containerView.addSubview(whiteBackgroundView)
        containerView.addSubview(imageView)
        containerView.addSubview(carouselView)
        containerView.addSubview(titleContainer)
        containerView.addSubview(addToBagContainer)
        containerView.addSubview(toVC.view)
        
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2/3) {
                    imageView.frame = imageFinalFrame
                    imageView.leftButton.alpha = 1
                    imageView.updateLayout()
                    whiteBackgroundView.alpha = 1
                }
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                    titleContainer.frame = titleContainerFinalFrame
                    titleContainer.alpha = 1
                    carouselView.alpha = 1
                }

                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                    addToBagContainer.frame = addToBagContainerFinalFrame
                    addToBagContainer.alpha = 1
                }
        },
            completion: { _ in
                toVC.view.isHidden = false
                imageView.removeFromSuperview()
                carouselView.removeFromSuperview()
                titleContainer.removeFromSuperview()
                addToBagContainer.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension CustomTransitionAnimationController {
    func getImageUrl(at index: Int) -> URL? {
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return nil }
        return URL(string: CommonUsed.globalUsed.kimageUrl + source.media_gallery[index].image)
    }
}

class TransitionImageView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.setImage(#imageLiteral(resourceName: "Default"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
        leftButton.frame = CGRect(x: 30, y: 45, width: 45, height: 45)
        rightButton.frame = CGRect(x: bounds.width - 75, y: 45, width: 45, height: 45)
        
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(leftButton)
        addSubview(rightButton)
        
    }
    
    func updateLayout() {
        leftButton.frame = CGRect(x: 30, y: 45, width: 45, height: 45)
        rightButton.frame = CGRect(x: bounds.width - 75, y: 45, width: 45, height: 45)
        
        imageView.frame = bounds
    }

}

class CustomTransitionSliderView: SlidingIndicator {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "carousel")
        imageView.contentMode = .scaleToFill

        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        slider.bringToFront()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
    }
    
    func setupData(_ selectedProduct: Int, detailData: NewInData?) {
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return }
        
        numberOfItems = source.media_gallery.count
        selectedItem = 0
    }
}


class DetailsView: UIStackView {
    
    
    var objattrList = [String]()
             var designDetail = [OptionsList]()
             var objList = [String]()
            var designData: [NSManagedObject] = []
    
    lazy var nameStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = .vertical
        return stackView
    }()
   
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
                
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.font = UIFont(name: "BrandonGrotesque-Medium", size: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.font = UIFont(name: "BrandonGrotesque-Light", size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
                
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.font = UIFont(name: "BrandonGrotesque-Light", size: 14)
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var oldPriceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        
        label.textColor = UIColor(hexString: "9E9E9E")
        label.font = UIFont(name: "BrandonGrotesque-Light", size: 14)
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var scrollDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Scroll down")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return imageView
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alignment = .fill
        distribution = .fill
        axis = .vertical
        spacing = 5
        
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        fetchAttributeeData()
        let spacing = UIView()
        spacing.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spacing.backgroundColor = .clear
        addArrangedSubview(spacing)
        
        nameStackView.addArrangedSubview(brandLabel)
        nameStackView.addArrangedSubview(productNameLabel)
        
        addArrangedSubview(nameStackView)
        
        priceStackView.addArrangedSubview(discountLabel)
        priceStackView.addArrangedSubview(oldPriceLabel)
        
        addArrangedSubview(priceStackView)
        
        addArrangedSubview(scrollDownImage)
        
        addArrangedSubview(line)
    }
    
    func setupData(_ selectedProduct: Int, detailData: NewInData?) {
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return }

        let currency: String = (UserDefaults.standard.value(forKey: "currency") as? String ?? getWebsiteCurrency()).localized
       // let currency: String = UserDefaults.standard.string(forKey: "currency")!.localized

        
//        sliderIndicator.numberOfItems = source.media_gallery.count
//        viewSlider.setImageInputs(alamofireSource)
//        viewSlider.contentScaleMode = .scaleAspectFit
//
//        viewSlider.slideshowInterval = 0.0
        
        brandLabel.text = getBrandName(id: String(source.manufacturer))
        productNameLabel.text = source.name.uppercased()
        let regularPrice = source.regular_price
        let finalPrice = source.final_price
        if (regularPrice != finalPrice) {
            oldPriceLabel.isHidden = false
            discountLabel.textColor = .red
        } else {
            oldPriceLabel.isHidden = true
            discountLabel.textAlignment = .center
        }
        let formettedPrice = Double(source.final_price ).clean
        discountLabel.text = "\(formettedPrice) \(currency)"
        
        let formettedOldPrice = Double(regularPrice ).clean
        oldPriceLabel.attributedText = NSAttributedString.init(string: "\(formettedOldPrice) \(currency)").string.strikeThrough()
        
        if UserDefaults.standard.value(forKey:string.language) as? String ?? "en" == "en" {
            brandLabel.addTextSpacing(spacing: 1.5)
        }
    }
    
    func fetchAttributeeData(){

           if CoreDataManager.sharedManager.fetchAttributeData() != nil{

               designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
               print("colorArray", designData.count)
           }
           
           
            for j in 0..<designData.count{
                let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
                designDetail.append(array[k])
                }
            }
       
           let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
                 designDetail = sorteddesignDetail
           
           let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
           for i in 0..<designDetail.count{
               for j in arrColorNm{
                   if designDetail[i].label == j{
                       designDetail[i].isSelected = true
                   }
               }
           }
           
           for i in 0..<designDetail.count{
               objList.append(designDetail[i].label)
           }
           objattrList = objList
          
       }
       
       func getBrandName(id:String) -> String{
           var strBrand = ""
           for i in 0..<(designDetail.count){
              if id == "\(designDetail[i].value)"{
               strBrand = designDetail[i].label
              }
           }
           return strBrand.uppercased()
       }
    
    
    
}

class AddToBagView: UIView {
    let addToBagButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("ADD TO BAG".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "BrandonGrotesque-Regular", size: 14)
        let lang = UserDefaults.standard.value(forKey:string.language) as? String ?? "en"
        if lang != "Arabic" {
            if lang == "en" {
                button.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
        button.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
        button.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        
        addToBagButton.frame = CGRect(x: 20, y: 20, width: bounds.size.width - 40, height: 53)
        addSubview(addToBagButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        addToBagButton.frame = CGRect(x: 20, y: 20, width: bounds.size.width - 40, height: 53)
    }
}
