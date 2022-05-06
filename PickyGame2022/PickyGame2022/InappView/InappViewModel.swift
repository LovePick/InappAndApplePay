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
    
    let userIAPData = UserIAPData.shared
    
    
    
    // MARK: - Fileprivate Methods
    fileprivate func updateDataWithPurchasedProduct(_ product: SKProduct) {
        // ซื้อสินค้าสำเร็จ
        if(product.productIdentifier.contains("g500")){
        
            print("Buy 500G")
            
        }else if(product.productIdentifier.contains("g1500")){
            
            print("Buy1 500G")
        }

        
        
        // Ask UI to be updated and reload the table view.
        delegate?.shouldUpdateUI()
        delegate?.didFinishLongProcess()
    }
    
    
    fileprivate func restoreInappPurchased() {
     

        delegate?.shouldUpdateUI()
        delegate?.didFinishLongProcess()
    }
    
    
    // MARK: - Methods To Implement
    
    func viewDidSetup() {
        delegate?.willStartLongProcess()
        
        userIAPData.loadProducts {  [weak self] in
            
         
            self?.delegate?.shouldUpdateUI()
            self?.delegate?.didFinishLongProcess()
            
        }
      
    }
    
  
    
    func purchase(product: SKProduct){
        delegate?.willStartLongProcess()
        
        print("click Buy: \(product.productIdentifier)")
        if let store = IAPProducts.shared.store {
            store.buyProduct(product: product) { [weak self](success, productIdentifier, error) in
                if(success){
                    self?.delegate?.shouldUpdateUI()
                    self?.delegate?.didFinishLongProcess()
                }else{
                    self?.delegate?.didFinishLongProcess()
                    if let e = error {
                        self?.delegate?.showIAPRelatedError(e)
                    }
                    
                }
            }
           
        }
        
      
    }
    
    
    func restorePurchases() {
        
        if let store = IAPProducts.shared.store {
            delegate?.willStartLongProcess()
            store.restorePurchases { [weak self](transitions) in
                self?.delegate?.shouldUpdateUI()
                self?.delegate?.didFinishLongProcess()
            }
        }
    }
    
}
