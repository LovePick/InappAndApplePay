//
//  IAPProducts.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import UIKit

class IAPProducts: NSObject {

    public static let g500 = "g500"

    
    private static let productIdentifiers: Set<RUMEProductIdentifier> = [
        IAPProducts.g500
    ]
    
    public static let store = IAPHelper(productIDs: IAPProducts.productIdentifiers)
    
}
