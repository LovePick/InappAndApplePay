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


    
    init(){

    }
    
  
    
    func loadProducts(finish: @escaping()->Void){
        products = []
        
        guard let store = IAPProducts.shared.store else {
            finish()
            return
        }
        //โหลด รายการสินค้าที่มีขาย
        store.requestProducts { success, products in
            if success {
                guard let products = products else { return }
                self.products = products
                
//                for product in products {
//                    print(product.localizedTitle)
//                    print(product.localizedDescription)
//                    print(product.productIdentifier)
//
//                }
            }else{
                print("Something wrong")
            }
            
            finish()
        }
    }
    
    
    func handlePurchase(transaction: SKPaymentTransaction){
        
       //เมื่อซื้อสินค้าสำเร็จจะมาเรียก
        guard let tranactionID = transaction.transactionIdentifier as? String else { return }
        guard let productID = transaction.payment.productIdentifier as? String else { return }
        
        
        print("User buy ")
        
        print("transactionIdentifier :\(tranactionID)")
        print("productIdentifier :\(productID)")
       
      // ส่งข้อมูลไปที่ server ว่าซื้อสำเร็จ  transaction.transactionIdentifier  ผูกกับ USER ID
        
        for product in products {
            guard product.productIdentifier == productID else { continue }
            if product.productIdentifier == IAPProducts.g500 {
                //
                gold += 500
                
            }else if(product.productIdentifier == IAPProducts.g1500){
                gold += 1500
            }
        }
    }
    
    
    
    func handleRestore(transactions: [SKPaymentTransaction]){
        
        
        if(transactions.count > 0){
            for transaction in transactions {
                print("transactionIdentifier :\(transaction.transactionIdentifier)")
                print("productIdentifier :\(transaction.payment.productIdentifier)")
            }
        }
        
        // ต้องไปเช็คกับ server ว่าเคยได้รับสินค้าไปรึยัง (transaction.transactionIdentifier)
        // ถ้ารับไปแล้วก็ไม่ต้องสนใจ
        // ถ้ายังก็เพิ่มสินค้าให้
        
    }
    
    
    
    
}
