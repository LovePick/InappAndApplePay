//
//  IAPHelper.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import Foundation
import StoreKit

public typealias RUMEProductIdentifier = String
public typealias RUMEProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

// MARK: - Class

public class IAPHelper: NSObject {
    
    fileprivate let rumeProductIdentifiers: Set<RUMEProductIdentifier>
    fileprivate var rumePurchasedProductIdentifiers = Set<RUMEProductIdentifier>()
    
    fileprivate var rumeProductsRequest: SKProductsRequest?
    fileprivate var rumeProductsRequestCompletionHandler: RUMEProductRequestCompletionHandler?
    
    static let rumeIAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    
    
    
  
    
    public init(productIDs: Set<RUMEProductIdentifier>) {
        rumeProductIdentifiers = productIDs
        
        // check ready buy
        for productIdentifier in productIDs {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                rumePurchasedProductIdentifiers.insert(productIdentifier)
                print("Already purchased \(productIdentifier)")
            } else {
                print("Not yet purchased \(productIdentifier)")
            }
        }
        
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    public func requestProducts(completionHandler: @escaping RUMEProductRequestCompletionHandler) {
        rumeProductsRequest?.cancel()
        rumeProductsRequestCompletionHandler = completionHandler
        
        rumeProductsRequest = SKProductsRequest(productIdentifiers: rumeProductIdentifiers)
        rumeProductsRequest?.delegate = self
        rumeProductsRequest?.start()
    }
    
    public func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(productIdentifier: RUMEProductIdentifier) -> Bool {
        return rumePurchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayment() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

// MARK: - SKProductRequestsDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       
        
        
        // ready for sell
        var products:[SKProduct] = [SKProduct]()
        if !response.products.isEmpty {
            products = response.products
            // Implement your custom method here.
//            displayStore(products)
        }
        
        
        // don't allow for sell
        for invalidIdentifier in response.invalidProductIdentifiers {
            // Handle any invalid product identifiers as appropriate.
            print("invalidIdentifier: \(invalidIdentifier)")
        }
        
        
        
        
        
        
        rumeProductsRequestCompletionHandler?(true, products)
        reset()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        rumeProductsRequestCompletionHandler?(false, nil)
        reset()
        print("Error: \(error.localizedDescription)")
    }
    
    private func reset() {
        rumeProductsRequest = nil
        rumeProductsRequestCompletionHandler = nil
    }
    
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction: transaction)
            case .failed:
                failedTransaction(transaction: transaction)
            case .restored:
                restoreTransaction(transaction: transaction)
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
        
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        postPurchaseNotificationForIdentifier(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        if transaction.error!._code != SKError.Code.paymentCancelled.rawValue {
            print("Error: \(transaction.error?.localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        guard  let productIdentifier = transaction.original?.payment.productIdentifier else {
            return
        }
        
        postPurchaseNotificationForIdentifier(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func postPurchaseNotificationForIdentifier(identifier: String?) {
        guard let identifier = identifier else {
            return
        }
        
        if identifier.hasSuffix("Consumable") {
            
            if identifier == IAPProducts.g500 {
               
            }
        } else {
            //Non-Consumables  แบบซื้อครั้งเดียว
            
            rumePurchasedProductIdentifiers.insert(identifier)
            UserDefaults.standard.set(true, forKey: identifier)
        }
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name(IAPHelper.rumeIAPHelperPurchaseNotification), object: identifier)
    }
    
}
