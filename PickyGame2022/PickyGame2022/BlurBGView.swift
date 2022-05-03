//
//  BlurBGView.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import SwiftUI


struct BlurBGView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct BlurBGView_Previews: PreviewProvider {
    static var previews: some View {
        BlurBGView()
            .previewLayout(.sizeThatFits)
    }
}
