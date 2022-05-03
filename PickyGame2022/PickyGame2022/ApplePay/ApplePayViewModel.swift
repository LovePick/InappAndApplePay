//
//  ApplePayViewModel.swift
//  PickyGame2022
//
//  Created by Supapon Pucknavin on 3/5/2565 BE.
//

import UIKit
import PassKit

protocol ApplePayViewModelDelegate {
    
    func applePayWillStartLongProcess()
    func applePayDidFinishLongProcess()
    func applePayShowError(_ error: Error)
    func applePayShouldUpdateUI()
}

typealias PaymentCompletionHandler = (Bool) -> Void


class ApplePayViewModel: NSObject {
    
    var delegate: ApplePayViewModelDelegate?
    
    
    
    
    var shoeData = [ApplePayProduct]()
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    func viewDidSetup(){
        if let d = delegate {
            d.applePayWillStartLongProcess()
        }
        
        // load Product list
        //...
        //Delay function
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            self.shoeData = [
                ApplePayProduct(name: "Nike Air Force 1 High LV8", price: 110.00),
                ApplePayProduct(name: "adidas Ultra Boost Clima", price: 139.99),
                ApplePayProduct(name: "Jordan Retro 10", price: 190.00),
                ApplePayProduct(name: "adidas Originals Prophere", price: 49.99),
                ApplePayProduct(name: "New Balance 574 Classic", price: 90.00)
            ]
            
            //after finish call api
            if let d = self.delegate {
                d.applePayShouldUpdateUI()
                d.applePayDidFinishLongProcess()
            }
        }
        
        
        
    }
    
    func buyProduct(product:ApplePayProduct, completion: @escaping PaymentCompletionHandler){
        
        completionHandler = completion
        
        
        let paymentItem = PKPaymentSummaryItem.init(label: product.name, amount: NSDecimalNumber(value: product.price))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.supportedNetworks = paymentNetworks
            request.countryCode = "TH"  //"US"
            request.currencyCode = "THB"   //"USD"
            
            //"Replace me with your Apple Merchant ID"
            request.merchantIdentifier = "merchant.PickyGame2022"  // merchant.MrFoxMerchant
            request.merchantCapabilities = .capability3DS
            request.paymentSummaryItems = [paymentItem]
            
            // Display our payment request
            paymentController = PKPaymentAuthorizationController(paymentRequest: request)
            paymentController?.delegate = self
            paymentController?.present(completion: { (presented: Bool) in
                if presented {
                    NSLog("Presented payment controller")
                } else {
                    NSLog("Failed to present payment controller")
                    self.completionHandler!(false)
                }
            })
            
            
            
        } else {
            
            if let d = self.delegate {
                let e = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unable to make Apple Pay transaction."])
                
                d.applePayShowError(e)
            }
        }
        
        
    }
    
}

extension ApplePayViewModel: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            paymentStatus = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            paymentStatus = .success
        }

        completion(paymentStatus)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }

    
    
}
