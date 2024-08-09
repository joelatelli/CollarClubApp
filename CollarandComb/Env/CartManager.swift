//
//  CartManager.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/26/24.
//

import Combine
import Foundation
import Network
import Observation

@MainActor
@Observable class CartManager: ObservableObject {

	static let shared = CartManager()

	private(set) var products: [Product] = []
	private(set) var productData: [CreateProductData] = []
	private(set) var order: Order = Order(id: UUID(), user: nil, products: [], createdAt: nil, isCompleted: false, completedAt: nil, total: 1)
	private(set) var total: Double = 0.00
	private(set) var orders: [Order] = []

	private(set) var productOrders: [ProductOrder] = []
	private(set) var productOrdersDTO: [ProductOrderDTO] = []
	private(set) var orderDTO: OrderDTO = OrderDTO(status: "Paid", paymentMethod: "Debit Card", customerId: "", products: [])

	private var webSocketTask: URLSessionWebSocketTask?

	// Payment-related variables
	let paymentHandler = PaymentHandler()
	var paymentSuccess = false

	func addToCart(product: ProductOrder) {
//		products.append(contentsOf: product)
//		total += product.price
		products.append(product.product)
		order.products?.append(product.product)
		total = products.map { Double($0.price) ?? 0.00 }.reduce(total, +)

//		productData.append(CreateProductData(title: product.name, price: Double(product.product.price) ?? 0.00, desc: product.desc, imageURL: product.imageURL, quantity: 1, isMenuItem: false, order_id: order.id ?? UUID()))

		productOrders.append(product)
		productOrdersDTO.append(ProductOrderDTO(id: UUID(), quantity: product.quantity, totalPrice: product.totalPrice, size: product.size, productId: product.product.id!.uuidString))
	}

	func removeFromCart(product: ProductOrder) {

		products = products.filter {
			$0.id != product.id
		}

		order.products = order.products?.filter {
			$0.id != product.id
		}

		total -= Double(product.totalPrice) ?? 0.00
	}

	func decreaseAmount(product: ProductOrder) {
//		if let index = order.products?.firstIndex(of: product) {
//			let newQuantity = product.quantity - 1
//			if newQuantity > 0 {
//				let newProduct = Product(id: product.id, title: product.title, price: product.price, desc: product.desc, createdAt: product.createdAt, imageURL: product.imageURL, size: product.size, options: product.options, sizes: product.sizes, quantity: newQuantity, isMenuItem: product.isMenuItem, optionOne: product.optionOne, optionTwo: product.optionTwo, optionThree: product.optionThree, optionFour: product.optionFour, optionFive: product.optionFive, bookmarked: product.bookmarked, mediaAttachments: product.mediaAttachments, visibility: product.visibility)
//				order.products?[index] = newProduct
//				total -= product.price
//			} else {
//				removeFromCart(product: product)
//			}
//		}
	}

	func increaseAmount(product: ProductOrder) {
//		if let index = order.products?.firstIndex(of: product) {
//			let newQuantity = product.quantity + 1 // Increase the quantity instead of decreasing
//			let newProduct = Product(id: product.id, title: product.title, price: product.price, desc: product.desc, createdAt: product.createdAt, imageURL: product.imageURL, size: product.size, options: product.options, sizes: product.sizes, quantity: newQuantity, isMenuItem: product.isMenuItem, optionOne: product.optionOne, optionTwo: product.optionTwo, optionThree: product.optionThree, optionFour: product.optionFour, optionFive: product.optionFive, bookmarked: product.bookmarked, mediaAttachments: product.mediaAttachments, visibility: product.visibility)
//			order.products?[index] = newProduct
//			total += product.price // Increase the total
//		}
	}

	// Call the startPayment function from the PaymentHandler. In the completion handler, set the paymentSuccess variable
   func pay() {
//	   paymentHandler.startPayment(products: products, total: Int(total)) { success in
//		   self.paymentSuccess = success
//		   self.products = []
//		   self.total = 0
//	   }
   }

	func connectWebSocket() {
		let url = URL(string: "wss://caf-vapor-api-c922eaf44828.herokuapp.com/orders/orders")!
		webSocketTask = URLSession.shared.webSocketTask(with: url)
		webSocketTask?.receive { [weak self] result in
			switch result {
			case .success(.string(let ordersJSON)):
				let decoder = JSONDecoder()
				if let ordersData = ordersJSON.data(using: .utf8) {
					print("WebSocket Success")

					do {
						let orders = try decoder.decode([Order].self, from: ordersData)
						DispatchQueue.main.async {
							self?.orders = orders
							print("WebSocket Success 2XXX")
						}
					} catch let decodingError {
						print("WebSocket Decoding Error: \(decodingError)")
					}
				}
			case .failure(let error):
				print("WebSocket Error: \(error)")
			default:
				break
			}
			self?.connectWebSocket() // Reconnect for more messages
		}
		webSocketTask?.resume()
	}

	func sendOrder2(_ order: Order) {
		let encoder = JSONEncoder()
		if let orderData = try? encoder.encode(order),
		   let orderString = String(data: orderData, encoding: .utf8) {
			let message = URLSessionWebSocketTask.Message.string("order:\(orderString)")
			webSocketTask?.send(message) { error in
				if let error = error {
					print("WebSocket Sending Error: \(error)")
				}
			}
		}
	}

	func sendOrder(order: OrderDTO) {
		NetWorkManager.makePostRequestWithoutReturn(sending: order,
													path: "create-order",
													authType: .bearer
		) { result in
			switch result {
			case .success:
				print("PARTICIPATING ---")
			case .failure(let error):
				print("")
			}
		}
	}
}

