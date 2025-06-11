//
//  ProductDetailVC.swift
//  LevelShoes
//
//  Created by apple on 5/20/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
import CoreData
import Adjust
import Firebase

class ProductDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SimilarProductsPDPCellDelegate {
    private var isPresenting = false
    @IBOutlet weak var topSpacing: NSLayoutConstraint!
    @IBOutlet weak var topMainSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var bottomMainSpacing: NSLayoutConstraint!

    var arrSimilarProduct = [Dictionary<String, Any>]()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var similarProductView: UIView!
    @IBOutlet weak var flageButton: UIButton!
    var isCommingFromWishList : Bool = false
    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sizeBtn: UIButton! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                sizeBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    @IBOutlet weak var addtobagView: UIView!{
        didSet {
            self.addtobagView.alpha = 1
            animateLabel()
        }
    }
    @IBOutlet weak var viewHeader: UIView!
    
    func animateLabel() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.addtobagView.alpha = 1
        }, completion: nil)
        
        
    }
    var objattrList = [String]()
     var designDetail = [OptionsList]()
    var isComingFromPDP = true
     var objList = [String]()
    var designData: [NSManagedObject] = []
   // var designData = ColorData(dictionary: ResponseKey.fatchData(res: UserData.shared.getDesignData()!, valueOf: .data).dic)
    // var colorData = ColorData(dictionary: ResponseKey.fatchData(res: UserData.shared.getColorData()!, valueOf: .data).dic)
    @IBOutlet weak var slidingIndicator: SlidingIndicator!
    @IBOutlet weak var sliderIndicator: SlidingIndicator! {
        didSet {
            sliderIndicator.ignoreRTL = true
        }
    }
    @IBOutlet weak var viewShipping: UIView!
    @IBOutlet weak var viewEditorNotes: UIView!
    @IBOutlet weak var viewAboutProduct: UIView!
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var sizeWhiteView: UIView!
    @IBOutlet weak var sizeTable: UITableView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var miniCartView: UIView!
    @IBOutlet weak var continueBtn: UIButton! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                continueBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    @IBOutlet weak var gotoBagBtn: UIButton! {
        didSet {
            gotoBagBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            gotoBagBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                gotoBagBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    
    @IBOutlet weak var tagsStack: UIStackView!
    @IBOutlet weak var lblTag1: InsetLabel!{
        didSet{
            lblTag1.addTextSpacing(spacing: 1)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTag1.font = UIFont(name: "Cairo-SemiBold", size: lblTag1.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblTag2: InsetLabel!{
        didSet{
            lblTag2.addTextSpacing(spacing: 1)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTag2.font = UIFont(name: "Cairo-SemiBold", size: lblTag2.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblTag3: InsetLabel!{
        didSet{
            lblTag3.addTextSpacing(spacing: 1)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTag3.font = UIFont(name: "Cairo-SemiBold", size: lblTag3.font.pointSize)
            }
        }
    }
    @IBOutlet weak var addtobagLbl: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            self.scrollView.delegate = self
        }
    }
    static var storyboardInstance: ProductDetailVC? {
        return StoryBoard.pdp.instantiateViewController(withIdentifier: ProductDetailVC.identifier) as? ProductDetailVC
    }
    
    @IBOutlet weak var animationView: AnimationView! {
        didSet {
            animationView.hideSliderView = true
            animationView.delegate = self
            animationView.datasource = self
        }
    }
        
    @IBOutlet weak var lblOldPrice: UILabel!{
        didSet {
            lblOldPrice.attributedText = "2,300 \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")".strikeThrough()
        }
    }
    @IBOutlet weak var proceedBtn: UIButton! {
        didSet {
            proceedBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            proceedBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                proceedBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    @IBOutlet weak var constTop: NSLayoutConstraint!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblProductNm: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblProductNm.font = UIFont(name: "Cairo-Light", size: lblProductNm.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblBrand: UILabel! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblBrand.addTextSpacing(spacing: 1.07)
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBrand.font = UIFont(name: "Cairo-SemiBold", size: lblBrand.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblProductDetail: UILabel!{
        didSet{
              if UserDefaults.standard.value(forKey: "language")as? String != "ar"{
                lblProductDetail.textAlignment = .left
             }else{
                lblProductDetail.textAlignment = .right
                lblProductDetail.font = UIFont(name: "Cairo-Light", size: lblProductDetail.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblEditorNotes: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey: "language")as? String != "ar"{
                           lblEditorNotes.textAlignment = .left
                        }else{
                           lblEditorNotes.textAlignment = .right
                        lblEditorNotes.font = UIFont(name: "Cairo-Light", size: lblEditorNotes.font.pointSize)
                       }
        }
    }
    var strGen = ""
    
    @IBOutlet weak var btnAddToBag: UIButton!{
        didSet {
            btnAddToBag.setTitle("add_to_bag".localized.uppercased(), for: .normal)
            btnAddToBag.addTextSpacing(spacing: 1.5, color: "ffffff")
            btnAddToBag.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            btnAddToBag.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            if UserDefaults.standard.value(forKey: "language")as? String == "ar" {
                btnAddToBag.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 15)
            }
        }
    }
    @IBOutlet weak var lblShiping: UILabel!{
        didSet{
             if UserDefaults.standard.value(forKey: "language")as? String != "ar"{
                lblShiping.textAlignment = .left
             }else{
                lblShiping.textAlignment = .right
                lblShiping.font = UIFont(name: "Cairo-Light", size: lblShiping.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblEditorsNote: UILabel!
        {
        didSet{
            lblEditorsNote.text = validationMessage.editorNote.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEditorsNote.font = UIFont(name: "Cairo-Regular", size: lblEditorsNote.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblProductDetailsTop: UILabel!
        {
        didSet{
            lblProductDetailsTop.text = validationMessage.lblProductDetailsTop.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblProductDetailsTop.font = UIFont(name: "Cairo-SemiBold", size: lblProductDetailsTop.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblShippingAndReturn: UILabel!
        {
        didSet{
            lblShippingAndReturn.text = validationMessage.shippingReturn.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblShippingAndReturn.font = UIFont(name: "Cairo-Regular", size: lblShippingAndReturn.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblAboutTheProduct: UILabel!
        {
        didSet{
            lblAboutTheProduct.text = validationMessage.aboutTheProduct.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblAboutTheProduct.font = UIFont(name: "Cairo-Regular", size: lblAboutTheProduct.font.pointSize)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var lblSimilarProducts: UILabel!{
        didSet{
            lblSimilarProducts.text = validationMessage.similarProducts.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSimilarProducts.font = UIFont(name: "Cairo-SemiBold", size: lblSimilarProducts.font.pointSize)
            }
        }
    }
    var materialDetail = [OptionsList]()
    var countryDetail = [OptionsList]()
    var colorDetail = [OptionsList]()
    var materialArray: [NSManagedObject] = []
    var selectedProduct = 0
    var detailData : NewInData?
    var data_response :Array<Any> = []
    var miniCart_response :Array<Any> = []
    @IBOutlet weak var myconstantForHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnShipping: UIButton!
    @IBOutlet weak var btnEditorNotes: UIButton!
    @IBOutlet weak var btnAboutProduct: UIButton!
    @IBOutlet weak var mySecndConstrain: NSLayoutConstraint!
    @IBOutlet weak var continueBtnTop: NSLayoutConstraint!
    var Sku = NSMutableString()
    var imageUrl = ""
    var skuVPN = ""
    
    private func showDetails(_ animated: Bool = true) {
        showTopheader()
        guard animated else { return }
        UIView.animate(withDuration: 0.5) {
            self.scrollView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDetails(_ animated: Bool = true) {
        hideTopHeader()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        guard animated else { return }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidingIndicator.numberOfItems = 6
        fetchAttributeData()
        onClickEditorNotes(btnEditorNotes)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        animationView.addGestureRecognizer(recognizer)
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
        continueBtn.layer.borderWidth = 1.0
        continueBtn.layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        sizeBtn.setTitle("SIZE GUIDE".localized, for: .normal)
        sizeBtn.underline()
        proceedBtn.setTitle("PROCEED".localized, for: .normal)
        addtobagLbl.text = "Added to your bag".localized
        continueBtn.setTitle("CONTINUE".localized, for: .normal)
        gotoBagBtn.setTitle("GO TO BAG".localized, for: .normal)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,height: 1500);
        data_response = (detailData?.hits?.hitsList[selectedProduct]._source?.configurable_children)!
        
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return }
        
//        var alamofireSource = [AlamofireSource]()
//
//        for i in 0..<source.media_gallery.count {
//            alamofireSource.append(AlamofireSource(urlString: CommonUsed.globalUsed.kimageUrl + source.media_gallery[i].image)!)
//        }
        let currency: String = (UserDefaults.standard.value(forKey: "currency") as? String ?? getWebsiteCurrency()).localized
        //let currency: String = UserDefaults.standard.string(forKey: "currency")!.localized
        sliderIndicator.ignoreRTL = true
        if(source.media_gallery.count > 0){
        sliderIndicator.numberOfItems = source.media_gallery.count
        }
//        viewSlider.setImageInputs(alamofireSource)
//        viewSlider.contentScaleMode = .scaleAspectFit
//
//        viewSlider.slideshowInterval = 0.0
        
        lblBrand.text = getBrandName(id: String(source.manufacturer)).uppercased()
        lblProductNm.text = source.name.uppercased()
        let regularPrice = source.regular_price
        let finalPrice = source.final_price
        if regularPrice != finalPrice {
            lblOldPrice.isHidden = false
            lblDiscountPrice.textColor = .red
        } else {
            lblOldPrice.isHidden = true
            lblDiscountPrice.textAlignment = .center
        }
        let formettedPrice = Double(source.final_price).clean
        lblDiscountPrice.text = "\(formettedPrice) \(currency)"
        
        let formettedOldPrice = Double(regularPrice ).clean
        lblOldPrice.attributedText = NSAttributedString.init(string: "\(formettedOldPrice) \(currency)").string.strikeThrough()
        
        if UserDefaults.standard.value(forKey: "language")as? String == "ar"{
            if lblOldPrice.isHidden {
                lblDiscountPrice.textAlignment = .center
            }else{
                lblDiscountPrice.textAlignment = .left
                lblOldPrice.textAlignment = .right
            }
        }
        var productDetails = "SKU".localized + ":" + source.sku
        skuVPN = source.sku
        var stock = "Is In Stock".localized
        if(source.stock?.is_in_stock == false){
            stock = "Not In Stock".localized
        }
        print("CKK COlolr\(source.color) \n Material \(source.material)")
        productDetails += "\n"+"Quantity".localized + " : " + stock
        productDetails += "\n"+"Made In".localized + " : " + getCountryame(id: "\(source.country_of_manufacture)")
        productDetails += "\n"+"Colour".localized + " : " + getColorName(id: "\(source.color)")
        productDetails += "\n"+"Material".localized + " : " + getMaterialName(id: "\(source.material)")
        lblProductDetail.text = productDetails
        lblEditorNotes.text = source.description.html2String
        
        var productShiping = "free_delivery_on_orders".localized
        productShiping += "\n"+"for_all_uae".localized
        productShiping += "\n"+"gift_wrapping".localized
        productShiping += "\n"+"free_service".localized
        
        
        lblShiping.text = productShiping
        klevuSearchApi(text: source.name, gender: strGen)
        collectionView.contentInset.left = -10
        collectionView.contentInset.right = -10
        
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblProductDetailsTop.textAlignment = .left
            Common.sharedInstance.backtoOriginalButton(aBtn: backBtn)
            bottomMainSpacing.constant = arrow.frame.maxY
        }
        else{
            lblProductDetailsTop.textAlignment = .right
            Common.sharedInstance.rotateButton(aBtn: backBtn)
            bottomMainSpacing.constant = arrow.frame.maxY + 15
        }
    }
    
    func fetchAttributeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            materialArray = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("materialArray", materialArray.count)
        }
        
         
         for j in 0..<materialArray.count{
            if materialArray[j].value(forKey: "attribute_code")as? String == "material"{
             let array:[OptionsList] = materialArray[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
                     materialDetail.append(array[k])
             }
            }
            if materialArray[j].value(forKey: "attribute_code")as? String == "country_of_manufacture"{
             let array:[OptionsList] = materialArray[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
                     countryDetail.append(array[k])
             }
            }
            if materialArray[j].value(forKey: "attribute_code")as? String == "color"{
             let array:[OptionsList] = materialArray[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
                     colorDetail.append(array[k])
             }
            }
            
            if materialArray[j].value(forKey: "attribute_code")as? String == "manufacturer"{
             let array:[OptionsList] = materialArray[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
                     designDetail.append(array[k])
             }
            }
         }
            
        }


    func getMaterialName(id:String) -> String{
         
        
        var strMaterial = ""
        for i in 0..<(materialDetail.count){
            print("CKK Material \(materialDetail[i].value) \n")
            if materialDetail[i].value == id {
                strMaterial = materialDetail[i].label
            }
        }
        return strMaterial
    }
    
    func getColorName(id:String) -> String{
         
        
        var strColor = ""
        for i in 0..<(colorDetail.count){
            print("CKK COLOR \(materialDetail[i].value) \n")
            if colorDetail[i].value == id {
                strColor = colorDetail[i].label
            }
        }
        return strColor
    }
    
    
    func getCountryame(id:String) -> String{
         
        
        var strCountry = ""
        for i in 0..<(countryDetail.count){
            if countryDetail[i].value == id {
                strCountry = countryDetail[i].label
            }
        }
        return strCountry
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tagList = detailData?.hits?.hitsList[selectedProduct]._source?.tags
        
        let tagsArray = tagList?.components(separatedBy: ",")
        if tagsArray?.count ?? 0 > 0 {
            let badge = "\(tagsArray![0])".uppercased()
            if badge.count > 1 {
                lblTag1.text = badge
            }
            else{
                lblTag1.isHidden = true
            }
        }

        if  tagsArray?.count ?? 0 > 1 {
             lblTag2.text = "\(tagsArray![1])".uppercased()
        }
        else{
            lblTag2.isHidden = true
        }
        if  tagsArray?.count ?? 0 > 2 {
             lblTag3.text = "\(tagsArray![2])".uppercased()
        }
        else{
            lblTag3.isHidden = true
        }
        
        showDetails()
        if isCommingFromWishList {
            self.similarProductView.isHidden = true
        }
        self.similarProductView.isHidden = false
        
        if (isWishListProduct(productId: String((detailData?.hits?.hitsList[selectedProduct]._source!.sku)! ))){
            self.flageButton.setImage(UIImage(named: "Selected"), for: .normal)
        }else{
            self.flageButton.setImage(UIImage(named: "Default"), for: .normal)
        }
        hideTopHeader()
        
        
        //**************** Adjust Event Tracking ************
        
        Adjust.trackSubsessionStart()
        
        let addToCardEvent = ADJEvent.init(eventToken: "gm9jx7")
        addToCardEvent?.addPartnerParameter("V_product_id", value: "\(detailData?.hits?.hitsList[selectedProduct]._source!.sku ?? "")")//@Nitikesh product parent id will be here
        addToCardEvent?.addPartnerParameter("content_type", value: "product")
        addToCardEvent?.addPartnerParameter("criteo_partner_id", value: "com.levelshoes.ios")
        addToCardEvent?.addPartnerParameter("Brand", value: "\(lblBrand.text ?? "")")
        addToCardEvent?.addPartnerParameter("category", value: "\(lblProductNm.text ?? "")")
        //addToCardEvent?.addPartnerParameter("Sub-category", value:  "")
        Adjust.trackEvent(addToCardEvent)

        
        // ***** Google Analytics *******
        // Prepare ecommerce parameters
        
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return }
        var selectedProduct: [String: Any] = [
            AnalyticsParameterItemID: source.sku,//@Nitikesh parent id will be here
            AnalyticsParameterItemName: source.name,
            
            AnalyticsParameterPrice: source.final_price / 1000000, 
            AnalyticsParameterCoupon:"",
            AnalyticsParameterItemCategory: getCategoryName(id: String(source.lvl_category)),//@Nitikesh category will be here
            AnalyticsParameterItemBrand: getBrandName(id: String(source.manufacturer)),//@Nitikesh brand will be here
            AnalyticsParameterItemCategory2:  getColorName(id: "\(source.color)"),
        ]
        // Specify order quantity
        selectedProduct[AnalyticsParameterQuantity]  = 1
        
        var itemDetails: [String: Any] = [
          AnalyticsParameterCurrency: getWebsiteCurrency(),
          AnalyticsParameterValue: source.final_price
        ]

        // Add items array
        itemDetails[AnalyticsParameterItems] = [selectedProduct]

        // Log view item event
        Analytics.logEvent(AnalyticsEventViewItem, parameters: itemDetails)
    }

    func showTopheader(){
        UIView.animate(withDuration: 0.5) {
            self.viewHeader.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
    }
    func hideTopHeader(){
        UIView.animate(withDuration: 0.5) {
            self.viewHeader.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        }
    }
    func moveToLoginScreen(){
        let loginVC = LoginViewController.storyboardInstance!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    func getImageUrl(at index: Int) -> URL? {
        guard let source = detailData?.hits?.hitsList[selectedProduct]._source else { return nil }
        return URL(string: CommonUsed.globalUsed.kimageUrl + source.media_gallery[index].image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideDetails(false)
    }
    
    @objc func didTap() {
        guard let imageView = animationView.currentView as? UIImageView, isPresenting == false else { return }
        isPresenting = true

        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        
        present(ImageViewerController(configuration: configuration), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isPresenting = false
        }
    }
    
    // MARK: TableView Delegates and Data Source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == cartTable {
            return miniCart_response.count
        } else {
            return (self.detailData?.hits?.hitsList[selectedProduct]._source?.sizeData.count)!
        }
    }
    
    //the method returning each cell of the list
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == cartTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCellTableViewCell", for: indexPath) as! ShoppingCellTableViewCell
            let imageUrltwo = (self.detailData?.hits?.hitsList[selectedProduct]._source?.media_gallery[0].image)
            let finalStr = CommonUsed.globalUsed.kimageUrl + imageUrltwo!
            cell.productImg.downLoadImage(url:finalStr)
            let dict = miniCart_response[indexPath.row] as! dictionary
            //let sku = dict ["sku"] as? String
            let productName : String = dict["name"] as? String ?? ""
            cell.productNameLbl.text = productName.uppercased()
            cell.qualityLbl.text =  productName.uppercased()
            cell.sizeLbl.text = String(describing: getSizeValueById(id: dict["size"]! as! Int))
            cell.quantityLbl.text = "1"
            let priceInStringFormat  = String(describing:dict["final_price"]!)
            let formettedPrice = Double(priceInStringFormat)!.clean
            cell.priceLbl.text =  "\(formettedPrice)"//String(describing:dict["final_price"]!)
            cell.selectionStyle = .none
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeTableViewCell", for: indexPath) as! SizeTableViewCell
            let data = self.detailData?.hits?.hitsList[selectedProduct]._source?.sizeData[indexPath.row]
            cell.sizeLbl.text = String(describing:getSizeValueById(id: data! as! Int)) + " (EU) "
            cell.stockLbl.text = "last_in_stock"
            let dict = data_response[indexPath.row] as! dictionary
            let finalValue = dict ["sku"] as? String
            if indexPath.row < data_response.count - 1
            {
                Sku.append(finalValue! + ",")
            }
            else
            {
                Sku.append(finalValue!)
            }
            if indexPath.row == data_response.count - 1
            {
                // testApi()
                //  callStockApi()
            }
            cell.selectionStyle = .none
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == sizeTable {
            return 56;
        }
        else
        {
            return UITableViewAutomaticDimension;
        }//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == sizeTable
        {
            let image = UIImage(named: "checkmark")
            let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:20, height:20));
            checkmark.image = image
            (self.sizeTable.cellForRow(at: indexPath as IndexPath)?.accessoryView = checkmark)!
            let dict = data_response[indexPath.row] as! dictionary
            //             let sku = dict ["sku"] as! String
            //            let prodName = dict ["name"] as! String
            //            let prodCorename = dict ["corename"] as! String
            //            let prodSize = dict ["size"] as! String
            //            let prodQuantity = dict ["quantity"] as! String
            //            let prodPrize = dict ["price"] as! String
            miniCart_response.append(dict)
            cartTable.reloadData()
            //            let databaseDict = ["sku":sku,"prodName":prodName,"prodCorename":prodCorename,"prodSize":prodSize,"prodQuantity":prodQuantity,"prodPrize":prodPrize]
            //            DatabaseHelper.sharedInstance.save(object: databaseDict)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == sizeTable
        {
            tableView.cellForRow(at: indexPath)?.accessoryView = .none
        }
    }
    
    func callOmsStockCheckApi(skus: String)  // "1,2,3,4"
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
         let url = URL(string: CommonUsed.globalUsed.omsStockUrl)!
                let params = [
                           "api_user_id" : CommonUsed.globalUsed.omsUserId,
                           "ean" : skus //111111,222222,333333,44444
                           ] as [String : Any] as [String : Any]
            
                Alamofire.request(url,method: .post, parameters: params, headers: ["X-RUN-API-KEY":CommonUsed.globalUsed.omsATPApiKey,"Content-Type":"application/x-www-form-urlencoded"])
                    .responseJSON { (response) in
                        MBProgressHUD.hide(for: self.view, animated: true)
              
                        switch response.result {
                                   case .success(_):
                                    
                                       if let data = response.result.value as? [String : Any] {
                                          
                                        let soh = data["soh"] as? [[String:Any]] ?? [[String:Any]]()
                                           if soh.count > 0{
                                              // self.moveToAddToPopup(storckDataArray :soh)
                                           }else {
                                             let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                               alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                               self.present(alert, animated: true, completion: nil)
                                           }
                                       } else {
                                         let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                           alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                           self.present(alert, animated: true, completion: nil)
                                       }
                                   case .failure(_):
                                     let alert = UIAlertController(title: "Error".localized, message: "out_of_stock".localized, preferredStyle: UIAlertControllerStyle.alert)
                                       alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
                                       self.present(alert, animated: true, completion: nil)
                                   }
   
                }
   
    }
    
    
    func moveToAddToPopup(){
        let storyboard = UIStoryboard(name: "PDP", bundle: Bundle.main)
        let changeVC: AddToBagPopUp
        changeVC = storyboard.instantiateViewController(withIdentifier: "AddToBagPopUp") as! AddToBagPopUp
        changeVC.productVPN = self.skuVPN
        changeVC.cart_source_data = detailData?.hits?.hitsList[selectedProduct]._source
        self.navigationController?.present(changeVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickAddToBag(_ sender: Any) {
       // var skudids = getSKUIds(skuId: detailData?.hits?.hitsList[selectedProduct]._source)
       // callOmsStockCheckApi(skus: skudids)
         self.moveToAddToPopup()

    }
    func getSKUIds(skuId :Hits.Source?)->String{
        var skuIds = [String]()
        var configurable_children = skuId?.configurable_children as? [[String:Any]] ?? [[String:Any]]()
        for child in configurable_children{
            skuIds.append(child["sku"] as! String)
        }
        let stringRepresentation = skuIds.joined(separator: ",")
        return stringRepresentation
    }
    @IBAction func onclickProceed(_ sender: Any) {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        if screenHeight >= 812.0
        {
            self.continueBtnTop.constant = 200
        }
        if miniCart_response.count == 0 {
            let alert = UIAlertController(title: "Level Shoes", message: "select_size".localized, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            miniCartView.isHidden = false
            miniCartView.animShow()
            sizeView.isHidden = true
        }
    }
    @IBAction func onClickShipping(_ sender: UIButton) {
        if lblShiping.isHidden == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: self.btnShipping, fromValue: 1.0 * M_PI, toValue:0, duration: 0.5)
                self.lblShiping.isHidden = true
                self.btnShipping.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: self.btnShipping, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
                
                self.lblShiping.isHidden = false
                self.btnShipping.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
            }, completion: nil)
            
        }
    }
    
    
    func rotateAnyView(view: UIView, fromValue: Double, toValue: Float, duration: Double = 1) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
    
    @IBAction func onClickEditorNotes(_ sender: UIButton) {
        
        if lblEditorNotes.isHidden == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: self.btnEditorNotes, fromValue: .pi / 2, toValue:0, duration: 0.5)
                self.lblEditorNotes.isHidden = true
                self.btnEditorNotes.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: self.btnEditorNotes, fromValue: 0, toValue: .pi, duration: 0.5)
                self.lblEditorNotes.isHidden = false
                self.btnEditorNotes.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
            }, completion: nil)
        }
    }
    
    @IBAction func onClickBookMark(_ sender: Any) {
        if (isWishListProduct(productId: String((detailData?.hits?.hitsList[selectedProduct]._source!.sku)! ))){
            flageButton.setImage(UIImage(named: "Selected"), for: .normal)
            self.similarProductView.isHidden = true
            
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else{
                var params:[String:Any] = [:]
                params["product_id"] = self.detailData?.hits?.hitsList[self.selectedProduct]._source!.id
                params["sku"] = self.detailData?.hits?.hitsList[self.selectedProduct]._source!.sku
                // let items = cartItems[indexPath.row]
                // viewModel.addToWishList(params)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.removeWishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        self.flageButton.set_image(UIImage(named: "Default")!, animated: true)
                        self.similarProductView.isHidden = false
                    }
                }) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            
        }else{
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else{
                var params:[String:Any] = [:]
                params["product_id"] = self.detailData?.hits?.hitsList[self.selectedProduct]._source!.id
                params["sku"] = self.detailData?.hits?.hitsList[self.selectedProduct]._source!.sku
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.addTowishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        self.flageButton.set_image(UIImage(named: "Selected")!, animated: true)
                        self.similarProductView.isHidden = true
                    }
                }) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    @IBAction func seconClose(_ sender: Any) {
        miniCartView.isHidden = true
        sizeView.isHidden = true
        miniCartView.animHide()
        sizeView.animHide()
        btnAddToBag.isHidden = false
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onCLickCloseBtn(_ sender: Any) {
        sizeView.isHidden = true
        btnAddToBag.isHidden = false
        sizeView.animHide()
    }
    @IBAction func onCLickSizeGuide(_ sender: Any) {
    }
    @IBAction func onClickAboutProduct(_ sender: UIButton) {
        if lblProductDetail.isHidden == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.rotateAnyView(view: self.btnAboutProduct, fromValue: M_PI / 2, toValue:0, duration: 0.5)
                self.lblProductDetail.isHidden = true
                self.btnAboutProduct.setImage(#imageLiteral(resourceName: "expand"), for: .normal)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.rotateAnyView(view: self.btnAboutProduct, fromValue: 0, toValue: Float(M_PI), duration: 0.5)
                
                self.lblProductDetail.isHidden = false
                self.btnAboutProduct.setImage(#imageLiteral(resourceName: "Collapse"), for: .normal)
            })
        }
    }
    func klevuSearchApi(text: String, gender: String){
        let param = [
            //  validationMessage.ticket:"klevu-158358783414411589",
            validationMessage.ticket:getSkuCode(),
            validationMessage.term: text ,
            validationMessage.paginationStartsFrom: 0,
            validationMessage.noOfResults:6,
            validationMessage.showOutOfStockProducts:"false",
            validationMessage.fetchMinMaxPrice:"true",
            validationMessage.enableMultiSelectFilters:"true",
            validationMessage.sortOrder:"rel",
            validationMessage.enableFilters:"true",
            validationMessage.applyResults:"",
            validationMessage.visibility:"search",
            validationMessage.category:"KLEVU_PRODUCT",
            validationMessage.klevu_filterLimit:"50",
            validationMessage.sv:"2219",
            validationMessage.lsqt:"",
            validationMessage.responseType:"json",
            validationMessage.resultForZero:"1",
            validationMessage.applyFilters: gender
            ] as [String : Any]
        //            arrSearchWord // badge_name
        let url = CommonUsed.globalUsed.KlevuMain + CommonUsed.globalUsed.kleviCloud + CommonUsed.globalUsed.klevuNSearch
        print("paginationStartsFrom :", fromIndex)
        print("Simlar Pro URL \(url)")
        
        DispatchQueue.main.async {
            ApiManager.apiGet(url: url, params: param) {(response:JSON?, error:Error? ) in
                if let error = error {
                    print(error)
                    if error.localizedDescription.contains(s: "offline") {
                        let nextVC = NoInternetVC.storyboardInstance!
                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.delegate = self
                    }
                    
                    return
                }
                if response != nil{
                    
                    let dict = response?.dictionaryObject
                   // print("Print RESULT DATA \(dict)")
                    _ =   SearchWordKlevuRootClass.init(fromDictionary: (response?.dictionaryObject)!)
                    let meta = dict?["meta"] as? [String : Any]
                    let Product = dict?["result"] as? [[String : Any]]
                    self.arrSimilarProduct = []
                    self.arrSimilarProduct.append(contentsOf: Product!)
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                    
                    //print("SIMILAR DATA \(self.arrSimilarProduct)")
                    
                }
            }
        }
    }
    func klevuProductSearchApi(skutext: String){
        var delimiter = ";"
        var tempSkuArray = skutext.components(separatedBy: delimiter)
        var skuId = tempSkuArray[0]
        var arrMust = [[String:Any]]()
        
        arrMust.append(["match": ["sku":skuId]])
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        
        var dictSort = [String:Any]()
        dictSort = ["updated_at":"desc"]
        let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture"],
                     "from":0,
                     "size": 5,
                     "sort" : dictSort,
                     "query": dictBool
            ] as [String : Any]
        
        let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            if let error = error {
                if error.localizedDescription.contains(s: "offline") {
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                }
                
                return
            }
            var data: NewInData?
            if response != nil{
                let dict = ["data": response?.dictionaryObject]
                data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async(execute: {
                    
                    let nextVC = ProductDetailVC.storyboardInstance!
                    // nextVC.selectedProduct = ip.row
                    nextVC.detailData = data
                    // applyTransitionAnimation(nextVC: nextVC)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                })
            }
            
        }
    }
    func addToWishList(cell: SimilarProductsPDPCell) {
        guard self.collectionView.indexPath(for: cell) != nil else {
            return
        }
        let indexPath = self.collectionView.indexPath(for: cell)!
        
        if isWishListProduct(productId: cell.skuId) {
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else {
                //  let sourceDataModel = self.skuSourseData[self.cartItems[indexPath.row].sku!] as! Hits.Source
                var params:[String:Any] = [:]
                params["product_id"] = cell.product_id
                params["sku"] = cell.skuId
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.removeWishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        cell.btnBookMark.setImage(UIImage(named: "Default"), for: .normal)
                    }
                }) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }else{
            if UserDefaults.standard.value(forKey: "userToken") == nil {
                self.moveToLoginScreen()
            }else {
                var params:[String:Any] = [:]
                params["product_id"] = cell.product_id
                params["sku"] = cell.skuId
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ApiManager.addTowishList(params: params, success: { (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.async {
                        cell.btnBookMark.setImage(UIImage(named: "Selected"), for: .normal)
                    }
                }) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
}
extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSimilarProduct.count > 0 {
            return arrSimilarProduct.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != 0 && indexPath.row == arrSimilarProduct.count - 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewAllCell.identifier, for: indexPath) as? ViewAllCell else {
                fatalError("Cell can't be dequeue")
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: cell.imgArrow)
            }
            else{
                Common.sharedInstance.rotateImage(aimg: cell.imgArrow)
            }
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarProductsPDPCell.identifier, for: indexPath) as? SimilarProductsPDPCell else {
                fatalError("Cell can't be dequeue")
            }
            if UserDefaults.standard.value(forKey: "language")as? String == "ar"{
                cell.lblProductNm.textAlignment = .right
            }else{
                cell.lblProductNm.textAlignment = .left
            }
            cell.similarProductsdelagate = self
            let delimiter = ";"
            var skutext =     arrSimilarProduct[indexPath.row]["sku"] as? String ?? ""
            let tempSkuArray = skutext.components(separatedBy: delimiter)
            cell.skuId = tempSkuArray[0]
            let delimiterID = "-"
            var iDext =     arrSimilarProduct[indexPath.row]["id"] as? String ?? ""
            let tempiDArray = iDext.components(separatedBy: delimiterID)
            cell.product_id = tempiDArray[0]
            if isWishListProduct(productId: cell.skuId) {
                cell.btnBookMark.setImage(UIImage(named: "Selected"), for: .normal)
            }else{
                cell.btnBookMark.setImage(UIImage(named: "Default"), for: .normal)
            }
           
           // cell.lblTag.text = "EXCLUSIVE"
            cell.lblTag.text = ""
            cell.lblTag.isHidden = true
           
            
            cell.imgProduct.image = nil
            var url = arrSimilarProduct[indexPath.row]["image"] as! String
            print("url =====>",url)
            //The URL will be replaced once will go to Production #nitikesh
            if(url != ""){
            url = "https://www.levelshoes.com" + url.components(separatedBy: "needtochange")[1]
            }
            //let cleanFile = url.replacingOccurrences(of: "https://staging-levelshoes-m2.vaimo.com/needtochange", with: "https://www.levelshoes.com")
            //print("staging ====>",cleanFile)
            cell.arrSimilarProduct = self.arrSimilarProduct
            cell.lblBrand.text = (arrSimilarProduct[indexPath.row]["manufacturer"] as? String)!.uppercased()
            cell.lblProductNm.text = (arrSimilarProduct[indexPath.row]["name"] as? String)?.uppercased() as? String
            cell.imgProduct.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "imagePlaceHolder"))
            var startPrice = ""
            var priceValue = ""
            var oldPrice = ""
            var lblDiscountedPrice = ""
            startPrice = arrSimilarProduct[indexPath.row]["startPrice"] as? String ?? ""
            let startPriceInt = Double(startPrice) ?? 0
            priceValue = arrSimilarProduct[indexPath.row]["price"] as? String ?? ""
             let priceValueInt = Double(priceValue) ?? 0
            let currencyStr = UserDefaults.standard.string(forKey: "currency")?.localized ?? getWebsiteCurrency()
              var priceS = startPriceInt.clean
            if startPriceInt == priceValueInt{
                cell.lblPrice.text = "\(priceS) " + currencyStr.localized
                cell.lblOldPrice.isHidden = true
            }else{
                var priceP = priceValueInt.clean
                cell.lblPrice.text =  "\(priceS) " + currencyStr.localized
                cell.lblPrice.textColor  = .red
                cell.lblOldPrice.isHidden = false
                cell.lblOldPrice.attributedText = NSAttributedString.init(string: "\(priceP)\(currencyStr)").string.strikeThrough()
               // cell.lblOldPrice.text = "\(priceP) " + "\((currencyStr))".localized
            }
            
            return cell
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  arrSimilarProduct.count - 1 == indexPath.row  {
            print("Pop to new view")
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
            DispatchQueue.main.async(execute: {
                self.klevuProductSearchApi(skutext: self.arrSimilarProduct[indexPath.row]["sku"] as! String)
            })
        }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
            let velocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
            if velocityY > 0 && self.scrollView.contentOffset.y == 0 {
                self.hideDetails()
                return
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var count = 0
            let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.minX, y: visibleRect.midY)
            if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
                count = visibleIndexPath.row
                let leftSide = scrollView.contentOffset.x + scrollView.frame.width - scrollView.contentInset.right
                if leftSide == scrollView.contentSize.width {
                    count += 1
                }
                slidingIndicator.selectedItem = count
            }
        } else if scrollView == self.scrollView {
            if scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset.y = 0
            }
            let y = scrollView.contentOffset.y
            if y < mainView.frame.height {
                topSpacing.constant = -y
                topMainSpacing.constant = y
            }
            if scrollView.contentOffset.y - 50 > mainView.frame.height {
                viewHeader.backgroundColor = .white
                self.tagsStack.alpha = 0.0
            } else {
                viewHeader.backgroundColor = .clear
                self.tagsStack.alpha = 1.0
            }
        }
    }
}
//extension ProductDetailVC:ImageSlideshowDelegate{
//    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int){
//        animationView.scroll(to: page, animated: true) {}
//        sliderIndicator.selectedItem = page
//    }
//    
//    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }
//}

extension UIView {
    func animShow() {
        UIView.animate(withDuration:0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= 1100
                        self.layoutIfNeeded()
        }, completion: nil)
        // self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration:0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += 1100
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            //self.isHidden = true
        })
    }
}
extension ProductDetailVC:NoInternetDelgate{
    func didCancel() {
        // self.callStockApi()
    }
}

extension ProductDetailVC: AnimationViewDatasource, AnimationViewDelegate {
    func animationViewScrollProgress(progress: CGFloat) {
        sliderIndicator.progress = progress
    }
    func animationViewScrolledToIndex(animationView: AnimationView, _ index: Int) {
        sliderIndicator.selectedItem = index
//        viewSlider.setCurrentPage(index, animated: false)
    }
    
    func numberOfViews(in animationView: AnimationView) -> Int {
        if let data = detailData, data.hits?.hitsList.count ?? 0 > selectedProduct {
            return data.hits?.hitsList[selectedProduct]._source?.media_gallery.count ?? 0
        }
        else{
            return 0
        }
    }
    
    func animationView(_ animationView: AnimationView, viewForRowAt index: Int) -> UIView {
        var imgView: UIImageView
        if let val = animationView.dequeueReusableView() as? UIImageView {
            imgView = val
        } else {
            imgView = UIImageView()
        }
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        let url = getImageUrl(at: index)
        imgView.sd_setImage(with: url, completed: nil)
        
        return imgView
    }
}

extension ProductDetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
func getSizeValueById(id: Int) -> String{
    let attributeData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
    let attribute_code = "size"
    if attribute_code == "size"{
        for j in 0..<attributeData.count{
            let array:[OptionsList] = attributeData[j].value(forKey: "options") as! [OptionsList]
            for k in 0..<array.count{
                
                
                let str:String = array[k].value
                if Int(str) == id {
                    return array[k].label
                }
            }
        }
        
    }
    return ""
    
}


class PassThrouStackView: UIStackView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
}
