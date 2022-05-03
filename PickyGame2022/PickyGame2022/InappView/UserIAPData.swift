//
//  UserData.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import UIKit
import StoreKit


class UserIAPData {
    static let shared = UserIAPData()
    
    var gold:Int = 0
    
    
    var products = [SKProduct]()

//    var productsStoreSell = [IAPProductDisplayData]();
    
    init(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase), name: NSNotification.Name(rawValue: IAPHelper.rumeIAPHelperPurchaseNotification), object: nil)
    }
    
  
    
    func loadProducts(finish: @escaping()->Void){
        products = []
        
        //โหลด รายการสินค้าที่มีขาย
        IAPProducts.store.requestProducts { success, products in
            if success {
                guard let products = products else { return }
                self.products = products
                
                for product in products {
                    print(product.localizedTitle)
                    print(product.localizedDescription)
                    print(product.productIdentifier)
                    
                    /*
                    let identifier = product.productIdentifier
                    switch identifier {
                    case IAPProducts.g500:
//                        self.purchaseFiveColorChangesButton.product = product
                        
                        break
                    default:
                        break
                    }
                     */
                }
            }else{
                print("Something wrong")
            }
            
            finish()
        }
    }
    
    
    @objc func handlePurchase(notification: Notification){
        
        //แสดงรายการสินค้าที่เคยซื้อไปทั้งหมด
        // ต้องเช็คว่าเคยให้ สินค้าไปแล้วรึยัง
        guard let productID = notification.object as? String else { return }
        
        print(productID)
        
        
        for product in products {
            guard product.productIdentifier == productID else { continue }
            if product.productIdentifier == IAPProducts.g500 {
                //
                gold += 500
                
            }
        }
    }
}
