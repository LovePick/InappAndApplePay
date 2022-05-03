//
//  InappView.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 7/4/2565 BE.
//

import SwiftUI
import StoreKit


struct InappView: View {
    @Binding var presentedAsModal: Bool
    @State var showLoading:Bool = true
    
    
    
    @State var showingAlert:Bool = false
    @State var showingAlertAction:Bool = false
    @State var alertMessage:String = ""
    
    
    var viewModel = InappViewModel()
    
    
    var body: some View {
        
        ZStack {
            
            //Content
            VStack(){
                
                List(viewModel.userDat.products, id: \.productIdentifier){ item in
                    
                    Button {
                        //Action
                        viewModel.purchase(product: item)
                    } label: {
                        InappCell(product: item)
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
    
    // MARK: - Methods To Implement
    
    func showAlert(for product: SKProduct) {
      
    }
    
}




// MARK: - ViewModelDelegate
extension InappView: InappViewModelDelegate {
    func toggleOverlay(shouldShow: Bool) {
        showLoading = shouldShow
    }
    
    func willStartLongProcess() {
        showLoading = true
    }
    
    func didFinishLongProcess() {
        showLoading = false
    }
    
    
    func showIAPRelatedError(_ error: Error) {
        let message = error.localizedDescription
        
        alertMessage = message
        showingAlert = true
    }
    
    
    func shouldUpdateUI() {
//        tableView.reloadData()
    }
    
    
    func didFinishRestoringPurchasesWithZeroProducts() {
//        showSingleAlert(withMessage: "There are no purchased items to restore.")
    }
    
    
    func didFinishRestoringPurchasedProducts() {
//        showSingleAlert(withMessage: "All previous In-App Purchases have been restored!")
    }
}




struct InappView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        PreviewWrapper()
        //            .previewLayout(.sizeThatFits)
    }
    
    struct PreviewWrapper: View {
        @State var presentedAsModal:Bool = false
        
        var body: some View {
            InappView(presentedAsModal: $presentedAsModal)
        }
        
    }
    
    
    
}
