//
//  ProductCartRowView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductCartRowView: View {

	@EnvironmentObject var cartManager: CartManager
	@State var product: Product2
	@State var count = 1

	var body: some View {
		HStack {
			VStack {
				WebImage(url: URL(string: product.imageURL))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 80, height: 80)
					.cornerRadius(4)

				Spacer()
			}
			.padding(.trailing, 6)

			VStack(alignment: .leading) {

				ModTextView(text: product.title, type: .subtitle_1, lineLimit: 2).foregroundColor(Color.text_primary_color)

				ModTextView(text:  product.desc, type: .body_1, lineLimit: 1).foregroundColor(Color.gray)
					.padding(.bottom, 4)

//				ForEach(product.options ?? [], id: \.self) { string in
//					HStack {
//						ModTextView(text:  string, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//						Spacer()
//					}
//				}

				if (product.optionOne != nil) {
					HStack {
						ModTextView(text: product.optionOne!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				if (product.optionTwo != nil) {
					HStack {
						ModTextView(text: product.optionTwo!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				if (product.optionThree != nil) {
					HStack {
						ModTextView(text: product.optionThree!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				Spacer()

				HStack {

					HStack {

						Button {
							count += 1
							product.quantity += 1
//							cartManager.increaseAmount(product: product)

						} label: {
							Image(systemName: "plus.circle.fill")
								.font(Font.system(size: 22, weight: .ultraLight))
								.foregroundColor(Color.text_primary_color)
						}

						ModTextView(text: "\(product.quantity)", type: .body_1, lineLimit: 2).foregroundColor(Color.text_primary_color)

						Button {
//							if product.quantity > 1 {
//								count -= 1
//								product.quantity -= 1
//								cartManager.decreaseAmount(product: product) // Update the cart with decreased quantity
//							} else if product.quantity == 1 {
//								cartManager.removeFromCart(product: product)
//							}
////							if product.quantity > 1 {
////								count -= 1
////								product.quantity -= 1
////								let new = Product(id: UUID(), title: product.title, price: product.price, desc: product.desc, imageURL: product.imageURL, quantity: product.quantity, isMenuItem: product.isMenuItem)
////								product = new
////								cartManager.decreaseAmount(old: product, product: new)
////							} else if product.quantity == 1 {
////								cartManager.removeFromCart(product: product)
////							}
						} label: {
							if product.quantity > 1 {
								Image(systemName: "minus.circle.fill")
									.font(Font.system(size: 22, weight: .ultraLight))
									.foregroundColor(Color.text_primary_color)
							} else if product.quantity == 1 {
								Image(systemName: "trash")
									.font(Font.system(size: 22, weight: .ultraLight))
									.foregroundColor(Color.text_primary_color)
							}
						}
						.buttonStyle(.plain)
					}

					Spacer()
					ModTextView(text: "$\(product.price.description)", type: .body_1, lineLimit: 1).foregroundColor(Color.gold_color)

				}
			}
		}
		.padding(8)
	}
}


struct OrderCartRowView: View {

//	@EnvironmentObject var cartManager: CartManager
	@State var order: Order

	var body: some View {
		VStack(alignment: .leading){

			ModTextView(text: "Ordered by: \(order.user?.firstName ?? "No name") \(order.user?.lastName ?? "No name")", type: .subtitle_1B)
				.foregroundColor(.gold_color)

			ModTextView(text: "Ordered at: \(order.createdAt!.formatted())", type: .body_1)
				.padding(.bottom, 10)

			ForEach(order.products ?? [], id: \.id){ product in
//				OrderedProductRowView(product: product)
			}

//			Button(action: {
//				print("Completed")
//
//			}) {
//				HStack{
//					Spacer()
//					Text("Mark Order Complete").font(.system(size: 18)).foregroundColor(Color.white)
//					Spacer()
//					Image(systemName: "checkmark")
//						.resizable()
//						.frame(width: 15, height: 15)
//						.foregroundColor(Color.white)
//				}
//				.padding(.horizontal, 20)
//			}
//			.accessibilityIdentifier("completeButton")
//			.padding([.top, .bottom], 12)
//			.background(Color.gold_color)
//			.cornerRadius(4)
//			.buttonStyle(.plain)
//			.padding(.top, 30)

			HStack {

				ModTextView(text: "Total:", type: .h6, lineLimit: 2).foregroundColor(Color.text_primary_color)

				Spacer()

				ModTextView(text: "$20.00", type: .h6, lineLimit: 1).foregroundColor(Color.gold_color)

			}
			.padding(.top, 16)

			Divider()
				.foregroundColor(.gold_color)
				.frame(height: 20)
		}
		.padding(.horizontal, 10)
	}
}

struct OrderedProductRowView: View {

	@EnvironmentObject var cartManager: CartManager
	@State var product: Product2
	@State var count = 1

	var body: some View {
		HStack {
			VStack {
				WebImage(url: URL(string: product.imageURL))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 80, height: 80)
					.cornerRadius(4)

				Spacer()
			}
			.padding(.trailing, 6)

			VStack(alignment: .leading) {

				ModTextView(text: product.title, type: .subtitle_1B, lineLimit: 2).foregroundColor(Color.text_primary_color)

				ModTextView(text:  product.desc, type: .body_1, lineLimit: 1).foregroundColor(Color.gray)
					.padding(.bottom, 4)

//				ForEach(product.options ?? [], id: \.self) { string in
//					HStack {
//						ModTextView(text:  string, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
//						Spacer()
//					}
//				}

				if (product.optionOne != nil) {
					HStack {
						ModTextView(text: product.optionOne!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				if (product.optionTwo != nil) {
					HStack {
						ModTextView(text: product.optionTwo!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				if (product.optionThree != nil) {
					HStack {
						ModTextView(text: product.optionThree!, type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
						Spacer()
					}
				}

				Spacer()

				HStack {

					ModTextView(text: "Quantity: \(product.quantity)", type: .body_1, lineLimit: 2).foregroundColor(Color.text_primary_color)

					Spacer()

					ModTextView(text: "$\(product.price.description)", type: .body_1, lineLimit: 1).foregroundColor(Color.text_primary_color)

				}
			}
		}
	}
}
