//
//  ApplePayProductCell.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 3/5/2565 BE.
//

import SwiftUI

struct ApplePayProductCell: View {
    
    @State var product:ApplePayProduct
    @State var displyPrice:String = ""
    
    var body: some View {
        VStack {
            Text(product.name)
            Text(displyPrice)
            Text("PAY WITH  APPLE")
        }.onAppear(){
            setup()
        }
    }
    
    
    func setup() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        // get localeIdentifier : https://gist.github.com/jacobbubu/1836273
        numberFormatter.locale = Locale(identifier: "th_TH")
        
        let num = NSNumber(value: product.price)
        let formattedString = numberFormatter.string(from: num)
        displyPrice = formattedString ?? ""
        
    }
}

struct ApplePayProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ApplePayProductCell(product: ApplePayProduct(name: "Nike Air Force 1 High LV8", price: 110.00))
    }
}
