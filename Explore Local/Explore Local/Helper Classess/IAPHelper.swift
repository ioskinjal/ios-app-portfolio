//
//  IAPHelper.swift
//
//  Created by NCrypted Technologies.
//  Copyright © 2019 NCrypted Technologies. All rights reserved.
//

//reference link
//https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started
//

import StoreKit

enum IAPHandlerAlertType {
    case disabled
    case purchased
    case restored
    case failed
    case deferred
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .purchased: return "You've successfully bought this purchase!"
        case .restored: return "You've successfully restored your purchase!"
        case .failed: return "Transaction was cancelled or failed!"
        case .deferred: return "Something is went to wrong from App Store!"
        }
    }
}


//TODO: -List here all your product identifiers
struct InAppProduct {
   // static let yearly = "com.app.freeplan" //"com.app.test.yearly" //"com.razeware.razefaces.swiftshopping"
    static let weekexplorer = "2weekexplorer"
    static let thelocal = "thelocal12month"
    //....
}

open class IAPHelper: NSObject  {
    //add all product indetifiers into productIdentifiers <Set>
    //static let productIdentifiers: Set<ProductIdentifier> = [InAppProduct.acceptRequest, InAppProduct.product1, InAppProduct.product2, ...]
    static let productIdentifiers: Set<String> = [InAppProduct.weekexplorer,InAppProduct.thelocal]
    
    //Initialize IAPHelper object
    static let store = IAPHelper(productIds: productIdentifiers)
    
    private var purchasedProductIdentifiers: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var products : [SKProduct] = []
    
    var purchaseStatusBlock: ((IAPHandlerAlertType, SKPaymentTransaction?) -> Void)?
    
    public init(productIds: Set<String>) {
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func initializeProduct() {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: IAPHelper.productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    private func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func buyProduct(identifier: String) {
        if let product = getProduct(identifier: identifier) {
            self.buyProduct(product)
        } else {
            purchaseStatusBlock?(.disabled, nil)
        }
    }
    
    //return true if product already purchased
    public func isProductPurchased(_ productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func getProduct(identifier: String) -> SKProduct? {
        let product : [SKProduct] = self.products.filter({$0.productIdentifier == identifier})
        if product.count > 0 {
            return product[0]
        }
        return nil
    }
    
    //get product price with currency symbol
    func getProductPrice(identifier: String) -> String {
        
        if let product = getProduct(identifier: identifier) {
            if IAPHelper.canMakePayments() {
                let priceFormatter: NumberFormatter = {
                    let formatter = NumberFormatter()
                    
                    formatter.formatterBehavior = .behavior10_4
                    formatter.numberStyle = .currency
                    
                    return formatter
                }()
                priceFormatter.locale = product.priceLocale
                return priceFormatter.string(from: product.price) ?? "BUY"
            }
        }
        return "BUY"
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        self.products = response.products
        clearProductRequest()
        
        for p in self.products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        self.products = []
        clearProductRequest()
    }
    
    private func clearProductRequest() {
        productsRequest = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                print("deferred...")
                purchaseStatusBlock?(.deferred, transaction)
                break
            case .purchasing:
                print("purchasing...")
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseStatusBlock?(.purchased, transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseStatusBlock?(.restored, transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if  let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseStatusBlock?(.failed, transaction)
    }
    
    private func deliverPurchaseNotificationFor(transaction: SKPaymentTransaction) {
        
        purchasedProductIdentifiers.insert(transaction.payment.productIdentifier)
        UserDefaults.standard.set(true, forKey: transaction.payment.productIdentifier)
    }
}
