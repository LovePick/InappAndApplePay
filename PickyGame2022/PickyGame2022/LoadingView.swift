//
//  LoadingView.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import SwiftUI

struct LoadingView: View {
    var placeHolder: String
    
    @State var aintate: Bool = false
  
    
    var body: some View {
        VStack(spacing:28) {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color.primary, Color.primary.opacity(0)]), center: .center))
                .frame(width: 80, height: 80)
            // animating...
                .rotationEffect(.init(degrees: aintate ? -360 : 0))
                .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: aintate)
            
            Text(placeHolder)
            
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(BlurBGView())
        .cornerRadius(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.35))
        .onAppear {
            aintate.toggle()
        }
        
    }
    
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoadingView(placeHolder: "Loading")
            .previewLayout(.sizeThatFits)
    }
}

