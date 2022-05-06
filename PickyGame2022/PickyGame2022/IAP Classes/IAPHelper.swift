//
//  IAPHelper.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import Foundation
import StoreKit

public typealias IAPProductIdentifier = String
public typealias IAPProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()
public typealias BuyProductRequestCompletionHandler = (_ success: Bool, _ transition: SKPaymentTransaction, _ error:Error?) -> ()
public typealias RestoreProductRequestCompletionHandler = ( _ transitions: [SKPaymentTransaction]) -> ()

// MARK: - Class

public class IAPHelper: NSObject {
    
  
    
    fileprivate let rumeProductIdentifiers: Set<IAPProductIdentifier>
    fileprivate var rumePurchasedProductIdentifiers = Set<IAPProductIdentifier>()
    
    fileprivate var rumeProductsRequest: SKProductsRequest?
    fileprivate var rumeProductsRequestCompletionHandler: IAPProductRequestCompletionHandler?
    
    
    fileprivate var buyProductRequestCompletionHandler: BuyProductRequestCompletionHandler?

    fileprivate var restoreProductRequestCompletionHandler:RestoreProductRequestCompletionHandler?
    
    
    static let rumeIAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    
    
    
  
    
    public init(productIDs: Set<IAPProductIdentifier>) {
        rumeProductIdentifiers = productIDs
        

        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    public func requestProducts(completionHandler: @escaping IAPProductRequestCompletionHandler) {
        rumeProductsRequest?.cancel()
        rumeProductsRequestCompletionHandler = completionHandler
        
        rumeProductsRequest = SKProductsRequest(productIdentifiers: rumeProductIdentifiers)
        rumeProductsRequest?.delegate = self
        rumeProductsRequest?.start()
    }
    
    public func buyProduct(product: SKProduct, completionHandler: @escaping BuyProductRequestCompletionHandler) {
        buyProductRequestCompletionHandler = completionHandler
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(productIdentifier: IAPProductIdentifier) -> Bool {
        return rumePurchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayment() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases(completionHandler: @escaping RestoreProductRequestCompletionHandler) {
        restoreProductRequestCompletionHandler = completionHandler
        
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
            for p in products {
                print("Product (available): \(p.productIdentifier)")
            }
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
        
        buyProductRequestCompletionHandler = nil
        restoreProductRequestCompletionHandler = nil
        
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
    
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("paymentQueueRestoreCompletedTransactionsFinished")
        for transction in SKPaymentQueue.default().transactions {
            print(transction.transactionIdentifier)
            print(transction.payment.productIdentifier)
        }
        
        UserIAPData.shared.handleRestore(transactions: SKPaymentQueue.default().transactions)
        restoreProductRequestCompletionHandler?(SKPaymentQueue.default().transactions)
        reset()
    }
    
    
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        
        //ซื้อสำเร็จ
        
        
        UserIAPData.shared.handlePurchase(transaction: transaction)
        buyProductRequestCompletionHandler?(true, transaction, nil)
        
        SKPaymentQueue.default().finishTransaction(transaction)
        reset()
        
        
      
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        if transaction.error!._code != SKError.Code.paymentCancelled.rawValue {
            print("Error: \(transaction.error?.localizedDescription)")
        }

        buyProductRequestCompletionHandler?(false, transaction, transaction.error)
        SKPaymentQueue.default().finishTransaction(transaction)
        reset()
        
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        guard  let productIdentifier = transaction.original?.payment.productIdentifier else {
            return
        }
        

        UserIAPData.shared.handleRestore(transactions: [transaction])
        buyProductRequestCompletionHandler?(true, transaction, nil)
        
        
        SKPaymentQueue.default().finishTransaction(transaction)
        reset()
    }
    
    /*
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
            UserDefaults.standard.synchronize()
        }
       
        
        NotificationCenter.default.post(name: Notification.Name(IAPHelper.rumeIAPHelperPurchaseNotification), object: identifier)
    }*/
    
}
