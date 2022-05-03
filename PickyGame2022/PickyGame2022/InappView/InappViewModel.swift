//
//  InappViewModel.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import UIKit
import StoreKit


protocol InappViewModelDelegate {
    func toggleOverlay(shouldShow: Bool)
    func willStartLongProcess()
    func didFinishLongProcess()
    func showIAPRelatedError(_ error: Error)
    func shouldUpdateUI()
    func didFinishRestoringPurchasesWithZeroProducts()
    func didFinishRestoringPurchasedProducts()
}
class InappViewModel {

    // MARK: - Properties
    
    var delegate: InappViewModelDelegate?
    
    let userDat = UserIAPData.shared
    
    
    
    // MARK: - Fileprivate Methods
    fileprivate func updateDataWithPurchasedProduct(_ product: SKProduct) {
        // ซื้อสินค้าสำเร็จ
        if(product.productIdentifier.contains("g500")){
        
            print("Buy 500G")
        }

        
        
        // Ask UI to be updated and reload the table view.
        delegate?.shouldUpdateUI()
    }
    
    
    fileprivate func restoreInappPurchased() {
     

        delegate?.shouldUpdateUI()
    }
    
    
    // MARK: - Methods To Implement
    
    func viewDidSetup() {
        delegate?.willStartLongProcess()
        
        userDat.loadProducts {  [weak self] in
            
            self?.delegate?.shouldUpdateUI()
            self?.delegate?.didFinishLongProcess()
        }
      
    }
    
  
    
    func purchase(product: SKProduct){
        
        IAPProducts.store.buyProduct(product: product)
      
    }
    
    
    func restorePurchases() {
        delegate?.willStartLongProcess()
        
        
    }
    
}
