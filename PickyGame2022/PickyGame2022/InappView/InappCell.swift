//
//  InappCell.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 10/4/2565 BE.
//

import SwiftUI
import StoreKit

struct InappCell: View {
    var product:SKProduct
    
    @State var displyPrice:String = ""
    
    var body: some View {
        VStack {
            Text(product.localizedTitle)
          
            Text(displyPrice)
            Text(product.localizedDescription)
        }.onAppear(){
            setup()
        }
        
    }
    
    func setup() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        let formattedString = numberFormatter.string(from: product.price)
        displyPrice = formattedString ?? ""
        
    }
}

struct InappCell_Previews: PreviewProvider {
    static var previews: some View {
        InappCell(product: SKProduct())
    }
}
