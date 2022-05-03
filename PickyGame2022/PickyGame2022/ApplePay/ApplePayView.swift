//
//  ApplePayView.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 3/5/2565 BE.
//

import SwiftUI

struct ApplePayView: View {
    
    @Binding var presentedAsModal: Bool
    @State var showLoading:Bool = false
    
    
    
    @State var showingAlert:Bool = false
    @State var showingAlertAction:Bool = false
    @State var alertMessage:String = ""
    
    var viewModel = ApplePayViewModel()
    
    
    var body: some View {
        
        ZStack {
            
            //Content
            VStack(){
                
                List(viewModel.shoeData, id: \.id){ item in
                    
                    Button {
                        //Action
                        viewModel.buyProduct(product: item) { success in
                            if(success){
                                print("Success")
                            }else{
                                print("Failed")
                            }
                        }
                        
                        
                    } label: {
                        ApplePayProductCell(product: item)
                    }

                    
                }
                
                Button {
                    dismissView()
                } label: {
                    Text("Dismiss")
                }
                
                
                
            }
            
            
            //LoadingView
            if(showLoading){
                LoadingView(placeHolder: "Loading...")
            }
        }
        .onAppear(){
            
            
            startSetup()
        }
        .alert(alertMessage, isPresented: $showingAlert) {
           
            Button("OK", role: .cancel) {
                showingAlert = false
                showingAlertAction = false
            }
        }
        .alert(alertMessage, isPresented: $showingAlertAction){
            
            Button("Buy") {
                tapOnBuy()
                showingAlert = false
                showingAlertAction = false
            }
            
            
            Button("Cancel", role: .cancel) {
                showingAlert = false
                showingAlertAction = false
            }
        }
        
    }
    
    
    func dismissView(){
        presentedAsModal = false
    }
    
    // MARK: - Action
    
    func startSetup(){
        viewModel.delegate = self
        viewModel.viewDidSetup()
    }
    
    func tapOnBuy(){
        
    }
    
   
    
    
}

extension ApplePayView: ApplePayViewModelDelegate {
    func applePayWillStartLongProcess() {
        showLoading = true
    }
    
    func applePayDidFinishLongProcess() {
        showLoading = false
    }
    
    func applePayShowError(_ error: Error) {
        let message = error.localizedDescription
        
        alertMessage = message
        showingAlert = true
    }
    
    func applePayShouldUpdateUI() {
        
    }
    
    
}

struct ApplePayView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        PreviewWrapper()
      
    }
    
    struct PreviewWrapper: View {
        @State var presentedAsModal:Bool = false
        
        var body: some View {
            ApplePayView(presentedAsModal: $presentedAsModal)
        }
        
    }
    
}
