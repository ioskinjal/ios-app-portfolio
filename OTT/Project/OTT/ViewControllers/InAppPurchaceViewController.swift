//
//  InAppPurchaceVC.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import StoreKit


protocol InAppPurchaceVCDelegate {
    
    func didBuyProduct(movieId: String)
    
}


class InAppPurchaceViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    struct Product {
        var productId = ""
        var packageId = ""
        var image_url = ""
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var privacyTermsButton: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var product = Product()
    var currencyCode = ""
    var delegate: InAppPurchaceVCDelegate!
    var movieId = String()
    var productIDs: Set<String> = []
    var productsArray: Array<SKProduct?> = []
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    var productRequest:SKProductsRequest!
    var transactionForRestore:SKPaymentTransaction!
    
    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buyButton.isHidden = false
        
        // self.buyButton.setNeedsFocusUpdate()
//        self.restoreButton.updateUIForYuppButtonType(yuppButtonType: .normal)
//        self.buyButton.updateUIForYuppButtonType(yuppButtonType: .normal)
        // Replace the product IDs with your own values if needed.
        self.getInAppPurchaseProductDetails()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Network methods
    func getInAppPurchaseProductDetails() {
        self.startAnimating(allowInteraction: false)
        self.contentView.isHidden = true
        YuppTVSDK.paymentsManager.inAppProductDetails(entityId: self.movieId, onSuccess: { (productDetails) in
            self.stopAnimating()
            self.product.productId = productDetails.productId
            self.product.packageId = String(productDetails.packageId)
            self.product.image_url = productDetails.iPhoneImageUrl
            UIColor.applyGradientToView(self.backgroundImageView)
            self.backgroundImageView.sd_setImage(with: URL.init(string: self.product.image_url), placeholderImage: #imageLiteral(resourceName: "Default-Banner"))
            self.contentView.isHidden = false
            self.requestProductInfo()
            SKPaymentQueue.default().add(self)
        }) { (error) in
            self.stopAnimating()
            self.errorLabel.text = error.message
            self.errorLabel.isHidden = false
            
            //TODO: show alert
        }
    }
    
    func validateViaOwnServer(receipt: String) {
        //print(receipt)
        
        self.startAnimating(allowInteraction: false)
        
        YuppTVSDK.paymentsManager.validateAppleReceipt(productId: self.product.productId, currency: self.currencyCode, receipt: receipt, onSuccess: { (successMessage) in
            
            /* let expireDate = result["expiryDate"] as! String
             let transactionID = result["transactionId"] as! String
             let desc =  "Expiry Date: " + expireDate + "\n Transaction ID: " + "\(transactionID)"
             self.descLabel.text = desc as String
             self.productTitle.text = result["message"] as? String
             self.buyButton.tag = 1000
             self.buyButton.setTitle("Continue to watch", for: UIControlState.normal)*/
            self.restoreButton.isHidden = true
            self.gotoDetailsPage()
        }) { (error) in
            self.errorLabel.isHidden = false
            self.errorLabel.text = error.message
        }
        
    }
    
    // MARK: - Custom method implementation
    
    func requestProductInfo() {
        self.productIDs.insert(self.product.productId)
        self.startAnimating(allowInteraction: true)
        if SKPaymentQueue.canMakePayments() {
            
            // let productIdentifiers : Set<String>  = [productIDs]
            productRequest = SKProductsRequest(productIdentifiers: productIDs )
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }

    func gotoDetailsPage() {
        self.delegate.didBuyProduct(movieId: self.movieId)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: IBAction method implementation
    @IBAction func restoreButtonTap(_ sender: Any) {
        if self.errorLabel.isHidden == false {
            self.errorLabel.isHidden = true
        }
        self.transactionInProgress = true
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    @IBAction func privacyTermsButtonTap(_ sender: Any) {
    }
    @IBAction func backButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buyButtonTap(_ sender: Any) {
        if self.errorLabel.isHidden == false {
            self.errorLabel.isHidden = true
        }
        
        if transactionInProgress {
            return
        }
        let payment = SKPayment(product: self.productsArray[0]! as SKProduct)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
    }
    
    
    // MARK: - SKProductsRequestDelegate method implementation
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error %@ \(error)")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count: Int = response.products.count
        self.stopAnimating()
        if count > 0 {
            _ = response.products
            let validProduct: SKProduct = response.products[0]
            print(validProduct.localizedTitle)
            print(validProduct.localizedDescription)
            print(validProduct.priceLocale.currencyCode as Any)
            
            self.productTitle.text = validProduct.localizedTitle
            self.descTextView.text = validProduct.localizedDescription
            self.currencyCode = validProduct.priceLocale.currencyCode!
            let buyButtonTitle = "Buy For " + self.currencyCode + " "+String(describing: validProduct.price)
            self.buyButton.setTitle(buyButtonTitle, for: UIControlState.normal)
            self.buyButton.isHidden = false
            for product in response.products {
                productsArray.append(product )
            }
            
        }
        else {
            print("No products")
        }
    }
    
    
    // MARK: SKPaymentTransactionObserver method implementation
    
    //1
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchasing:
                self.startAnimating(allowInteraction: false)
                break
            case SKPaymentTransactionState.deferred:
                self.startAnimating(allowInteraction: false)
                break
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.",transaction)
                self.transactionForRestore = transaction
                SKPaymentQueue.default().finishTransaction(transaction)
                self.stopAnimating()
                transactionInProgress = false
                self.restoreNonRenewing()
                break
                
            case SKPaymentTransactionState.restored:
                self.transactionForRestore = transaction
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                break
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Transaction Failed!"
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                self.stopAnimating()
                break
            default:
                self.stopAnimating()
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    //2
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            print(transaction.payment.productIdentifier,"was removed from the payment queue.");
        }
    }
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
        _ = [String:Any]()
        self.stopAnimating()
        self.restoreNonRenewing()
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.webstart.tomsgamesinc.StartLight_No_Ads":
                print("remove ads")
            default:
                print("IAP not setup")
            }
            
            
        }
    }
    
    // 5
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("There was an error");
    }
    
    private func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: SKError) {
        if (error.code != SKError.paymentCancelled)
        {
            // self.status = IAPRestoredFailed;
            //self.message = error.localizedDescription;
        }
        
    }
    
    
    func restoreNonRenewing() {
        let receiptURL = Bundle.main.appStoreReceiptURL!
        let receipt = NSData(contentsOf: receiptURL)
        // do {
        if receipt == nil {
            SKPaymentQueue.default().finishTransaction(self.transactionForRestore)
        }
        else {
            let jsonObjectString = receipt?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: UInt(0)))
            self.validateViaOwnServer(receipt: jsonObjectString!)
        }
        //}
        //        catch let error {
        //            print(error)
        //        }
    }

    
}
