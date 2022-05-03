//
//  ContentView.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import SwiftUI



struct ContentView: View {
    
    @State var showInapp:Bool = false
    @State var showApplePay:Bool = false
    
    
    var userData = UserIAPData.shared
    
    var body: some View {
        VStack(){
            Text("Hello")
            
            Button {
                showInappView()
            } label: {
                Text("In-App Purchase")
            }
            
            Button {
                showApplePayView()
            } label: {
                Text("Apple Pay")
            }

        }
        .sheet(isPresented: $showInapp) {
            InappView(presentedAsModal: $showInapp)
        }
        .sheet(isPresented: $showApplePay) {
            ApplePayView(presentedAsModal: $showApplePay)
        }
        .onAppear(){
            loadProducts()
        }
        
    }
    
    
    func showInappView(){
        showInapp = true
    }
    
    func showApplePayView(){
        showApplePay = true
    }
    
    func loadProducts(){
        
        //If use inapp need load user buy list
//        userData.loadProducts {
//
//        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
