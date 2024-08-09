//
//  CartManager.swift
//  CollarandComb
//
//  Created by Joel Muflam on 7/31/23.
//

import Foundation

class CartManager2: ObservableObject {
	@Published private(set) var products: [Product2] = []
	@Published private(set) var productData: [CreateProductData] = []
	@Published private(set) var order: Order = Order(id: UUID(), user: nil, products: [], createdAt: nil, isCompleted: false, completedAt: nil, total: 1)
	@Published private(set) var total: Float = 0
	@Published private(set) var orders: [Order] = []

	private var webSocketTask: URLSessionWebSocketTask?

	// Payment-related variables
	let paymentHandler = PaymentHandler()
	@Published var paymentSuccess = false

	func addToCart(product: Product2) {
//		products.append(contentsOf: product)
//		total += product.price
//		products.append(product)
//		order.products?.append(product)
//		total = products.map { $0.price }.reduce(total, +)
//		productData.append(CreateProductData(title: product.title, price: product.price, desc: product.desc, imageURL: product.imageURL, quantity: product.quantity, isMenuItem: false, order_id: order.id ?? UUID()))
	}

	func removeFromCart(product: Product2) {

		products = products.filter {
			$0.id != product.id
		}

		order.products = order.products?.filter {
			$0.id != product.id
		}

		total -= product.price
	}

	func decreaseAmount(product: Product2) {
//		if let index = order.products?.firstIndex(of: product) {
//			let newQuantity = product.quantity - 1
//			if newQuantity > 0 {
//				let newProduct = Product2(id: product.id, title: product.title, price: product.price, desc: product.desc, imageURL: product.imageURL, quantity: newQuantity, isMenuItem: product.isMenuItem)
//				order.products?[index] = newProduct
//				total -= product.price
//			} else {
//				removeFromCart(product: product)
//			}
//		}
	}

	func increaseAmount(product: Product2) {
//		if let index = order.products?.firstIndex(of: product) {
//			let newQuantity = product.quantity + 1 // Increase the quantity instead of decreasing
//			let newProduct = Product2(id: product.id, title: product.title, price: product.price, desc: product.desc, imageURL: product.imageURL, quantity: newQuantity, isMenuItem: product.isMenuItem)
//			order.products?[index] = newProduct
//			total += product.price // Increase the total
//		}
	}

	// Call the startPayment function from the PaymentHandler. In the completion handler, set the paymentSuccess variable
   func pay() {
	   paymentHandler.startPayment(products: products, total: Int(total)) { success in
		   self.paymentSuccess = success
		   self.products = []
		   self.total = 0
	   }
   }

//	func connectWebSocket() {
//		let url = URL(string: "wss://caf-vapor-api-c922eaf44828.herokuapp.com/orders/orders")!
//		webSocketTask = URLSession.shared.webSocketTask(with: url)
//		webSocketTask?.receive { [weak self] result in
//			switch result {
//			case .success(.string(let ordersJSON)):
//				let decoder = JSONDecoder()
//				if let ordersData = ordersJSON.data(using: .utf8) {
//					do {
//						let orders = try decoder.decode(OrderListResponse.self, from: ordersData)
//						DispatchQueue.main.async {
//							self?.orders = orders.data
//						}
//					} catch let decodingError {
//						print("WebSocket Decoding Error: \(decodingError)")
//					}
//				}
//			case .failure(let error):
//				print("WebSocket Error: \(error)")
//			default:
//				break
//			}
//			self?.connectWebSocket() // Reconnect for more messages
//		}
//		webSocketTask?.resume()
//	}

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
													path: "orders/",
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


struct OrderListResponse: Codable {
	let data: [Order]
}
