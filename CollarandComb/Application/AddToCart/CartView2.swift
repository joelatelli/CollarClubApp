//
//  CartView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/31/23.
//

import SwiftUI
import ComposableArchitecture
import PassKit
import Combine

struct CartView2: View {

	@EnvironmentObject var cartManager: CartManager2
	@EnvironmentObject private var userVM: UserViewModel

	@State private var paymentSuccessful = false // Track payment success

	var body: some View {
		ScrollView {

			if cartManager.products.count > 0 {

				HStack {
					ModTextView(text: "\(cartManager.products.count) Items", type: .subtitle, lineLimit: 2).foregroundColor(Color.text_primary_color)

					Spacer()

					ModTextView(text: "Subtotal: $\(cartManager.total)", type: .subtitle, lineLimit: 2).foregroundColor(Color.text_primary_color)
					
				}.padding()

				Divider()
					.foregroundColor(.text_primary_color)
					.padding(.horizontal, 20)

//				ForEach(cartManager.order.products ?? [], id: \.id){ product in
//					ProductCartRowView(product: product)
//				}

				Divider()
					.foregroundColor(.text_primary_color)
					.padding(.horizontal, 20)

				HStack {
					ModTextView(text: "Subtotal", type: .subtitle, lineLimit: 2).foregroundColor(Color.text_primary_color)

					Spacer()

					ModTextView(text: "$\(cartManager.total)", type: .subtitle, lineLimit: 2).foregroundColor(Color.text_primary_color)
				}.padding()

//				PaymentButton(action: cartManager.pay)
//					.padding(.top, 30)

				Button {
//					cartManager.sendOrder(order: CreateOrderData(id: UUID(), user_id: userVM.me.id ?? UUID(), products: cartManager.productData))
				} label: {
					ModTextView(text: "Send Order", type: .subtitle, lineLimit: 2).foregroundColor(Color.text_primary_color)
				}
				.padding(.top, 30)

			} else {
				Text("Your cart is empty")
			}

		}
		.navigationTitle(Text("Checkout")).padding(.top)
		.onDisappear {
			if cartManager.paymentSuccess {
				cartManager.paymentSuccess = false
			}
		}
	}
}


//extension CartView{
//	class Coordinator: NSObject, PKPaymentAuthorizationViewControllerDelegate {
//		let parent: CartView
//
//		init(_ parent: CartView) {
//			self.parent = parent
//		}
//
//		func paymentAuthorizationViewController(
//			_ controller: PKPaymentAuthorizationViewController,
//			didAuthorizePayment payment: PKPayment,
//			handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
//		) {
//			// Exchange the authorized PKPayment for a nonce using Square In-App Payments SDK
//			let nonceRequest = SQIPApplePayNonceRequest(payment: payment)
//			nonceRequest.perform { cardDetails, error in
//				if let cardDetails = cardDetails {
//					// Send the card nonce to your server to charge the card or store the card on file.
//					// Handle success or failure accordingly
//
//					// Example: Replace this with your server communication logic
//					/*
//					MyAPIClient.shared.chargeCard(withNonce: cardDetails.nonce) { transaction, chargeError in
//						if let chargeError = chargeError {
//							completion(PKPaymentAuthorizationResult(status: .failure, errors: [chargeError]))
//						} else {
//							completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//						}
//					}
//					*/
//
//					completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//				} else if let error = error {
//					print(error)
//					completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
//				}
//			}
//		}
//
//		func paymentAuthorizationViewControllerDidFinish(
//			_ controller: PKPaymentAuthorizationViewController
//		) {
//			controller.dismiss(animated: true)
//		}
//	}
//
//	func makeCoordinator() -> Coordinator {
//		Coordinator(self)
//	}
//}
