/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A shared class for handling payment across an app and its related extensions
*/

import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

protocol ApplePayPaymentStatus : NSObjectProtocol {
    func createCheckoutToken(paymentJSONResponse : AnyObject,currency: String, amount:Double)
}


class PaymentHandler: NSObject {

    var totalFinal = PKPaymentSummaryItem()
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler!
    
    weak var delegate : ApplePayPaymentStatus?

    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]

    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    func startPayment(addressDict:Addresses?,total:String,completion: @escaping PaymentCompletionHandler) {
        
        completionHandler = completion
        var array = total.components(separatedBy: " ")
        var strTotal = array[0]
        array = strTotal.components(separatedBy: ",")
        if array.count > 1{
            strTotal = "\(array[0])\(array[1])"
        }else{
            strTotal = "\(array[0])"
        }
        paymentSummaryItems.removeAll()
        totalFinal = PKPaymentSummaryItem(label: "Level Shoes-Allied", amount: NSDecimalNumber(string: strTotal), type: .pending)
        paymentSummaryItems.append(PKPaymentSummaryItem(label: "Level Shoes-Allied", amount: totalFinal.amount))
        
        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = Configuration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        let strCountryCode:String = UserDefaults.standard.value(forKey: "storecode") as? String ?? "AE"
        paymentRequest.countryCode = strCountryCode.uppercased()
       
        paymentRequest.currencyCode = getWebsiteCurrency()
        paymentRequest.requiredShippingContactFields = [.postalAddress, .name]
        
        let contact = PKContact()
        var name = PersonNameComponents()
        name.givenName = addressDict?.firstname
        name.familyName = addressDict?.lastname
        contact.name = name
        
        let address = CNMutablePostalAddress()
        address.street = addressDict?.street[0] ?? ""
        if (addressDict?.street.count)! > 1{
            address.street = address.street + "\n \(addressDict?.street[1] ?? "")"
        }
        var countryName = ""
       if(strCountryCode.uppercased() == "AE"){ countryName = "United Arab Emirates" }
       else if(strCountryCode.uppercased() == "SA"){ countryName = "Saudi Arabia" }
       else if(strCountryCode.uppercased() == "KW"){ countryName = "Kuwait" }
       else if(strCountryCode.uppercased() == "OM"){ countryName = "Oman" }
       else if(strCountryCode.uppercased() == "BH"){ countryName = "Bahrain" }
       address.country = countryName
       address.isoCountryCode = strCountryCode.uppercased()
        contact.postalAddress = address
        
        paymentRequest.shippingContact = contact
        
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        addinfoToFirebase(akey:   globalQuoteId + " - " + "PREAP", aVal: "\(contact)")

        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
                
            }
        })
    }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
 */
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform some very basic validation on the provided contact information
    
        let token = payment.token
        let paymentData = token.paymentData
        
        do {
            let paymentJSONResponse = try JSONSerialization.jsonObject(with: paymentData, options: .mutableContainers) as AnyObject
         
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        var elements = ["AE","SA","KW","OM","BH"]
            if !(elements.contains(payment.shippingContact?.postalAddress?.isoCountryCode.uppercased() ?? "")) {
                let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Levelshoes App only picks up in the selected countried. (UAE, KW, KSA, OM, BH)")
                let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
                errors.append(pickupError)
                errors.append(countryError)
                status = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
            
            print(paymentJSONResponse)
            
          //createCheckoutToken(paymentJSONResponse: paymentJSONResponse)

            
            var total = paymentSummaryItems.last
            total!.amount = totalFinal.amount
            
            print(total!.amount)
            
            
            
            let strCountryCode:String = UserDefaults.standard.value(forKey: "storecode") as? String ?? "AE"
            let currencyCode = UserDefaults.standard.value(forKey: string.currency) as? String ?? "AED"
            
             print(currencyCode)
            
            delegate?.createCheckoutToken(paymentJSONResponse: paymentJSONResponse,currency: currencyCode, amount: Double(total!.amount) * 100.0)
            }
            
            self.paymentStatus = status
            completion(PKPaymentAuthorizationResult(status: status, errors: errors))
            
        }
        catch let error
        {
            print(error)
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            
        }
        
        
    }
    
    
   
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // We are responsible for dismissing the payment sheet once it has finished
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    
                    
                    
                    
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
    
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        // The didSelectPaymentMethod delegate method allows you to make changes when the user updates their payment card
        // Here we're applying a $2 discount when a debit card is selected
        guard paymentMethod.type == .debit else {
            completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: paymentSummaryItems))
            return
        }

        var discountedSummaryItems = paymentSummaryItems
       // let discount = PKPaymentSummaryItem(label: "Debit Card Discount", amount: )
       // discountedSummaryItems.insert(discount, at: paymentSummaryItems.count - 1)
        if let total = paymentSummaryItems.last {
            total.amount = totalFinal.amount
        }
        completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: discountedSummaryItems))
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        print(payment.token)
    }
}
