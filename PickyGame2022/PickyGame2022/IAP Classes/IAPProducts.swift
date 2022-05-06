//
//  IAPProducts.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import UIKit

class IAPProducts: NSObject {

    static let shared = IAPProducts()
    
    
    public static let g500 = "g500"
    public static let g1500 = "g1500"

    
    public static let f100 = "100FOX"
    public static let f300 = "300FOX"
    public static let f500 = "500FOX"
    public static let f1000 = "1000FOX"
    public static let f3000 = "3000FOX"

    
    
    private static let productIdentifiers: Set<IAPProductIdentifier> = [
        IAPProducts.g500,
        IAPProducts.g1500,
        IAPProducts.f100,
        IAPProducts.f300,
        IAPProducts.f500,
        IAPProducts.f1000,
        IAPProducts.f3000,
    ]
    
    
    public var store:IAPHelper?
    
    override init(){
        
        self.store = IAPHelper(productIDs: IAPProducts.productIdentifiers)
    }
    
    
}
