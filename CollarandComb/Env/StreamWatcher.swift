//
//  StreamWatcher.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/23/24.
//

import Combine
import Foundation
import Network
import Observation

@MainActor
@Observable class StreamWatcher {
	private var client: Client?
	private var task: URLSessionWebSocketTask?
	private var watchedStreams: [Stream] = []
	private var instanceStreamingURL: URL?

	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()

	private var retryDelay: Int = 10

	enum Stream: String {
		case federated = "public"
		case local
		case user
		case direct
	}

	var events: [any StreamEvent] = []
	var unreadNotificationsCount: Int = 0
	var latestEvent: (any StreamEvent)?

	static let shared = StreamWatcher()

	private init() {
		decoder.keyDecodingStrategy = .convertFromSnakeCase
	}

	func setClient(client: Client, instanceStreamingURL: URL?) {
		if self.client != nil {
			stopWatching()
		}
		self.client = client
		self.instanceStreamingURL = instanceStreamingURL
		connect()
	}

	private func connect() {
		guard let task = try? client?.makeWebSocketTask(
			endpoint: Streaming.streaming,
			instanceStreamingURL: instanceStreamingURL
		) else {
			return
		}
		self.task = task
		self.task?.resume()
		receiveMessage()
	}

	func watch(streams: [Stream]) {
		if client?.isAuth == false {
			return
		}
		if task == nil {
			connect()
		}
		watchedStreams = streams
		streams.forEach { stream in
			sendMessage(message: StreamMessage(type: "subscribe", stream: stream.rawValue))
		}
	}

	func stopWatching() {
		task?.cancel()
		task = nil
	}

	private func sendMessage(message: StreamMessage) {
		if let encodedMessage = try? encoder.encode(message),
		   let stringMessage = String(data: encodedMessage, encoding: .utf8)
		{
			task?.send(.string(stringMessage), completionHandler: { _ in })
		}
	}

	private func receiveMessage() {
		//	task?.receive(completionHandler: { [weak self] result in
		//	  guard let self else { return }
		//	  switch result {
		//	  case let .success(message):
		//		switch message {
		//		case let .string(string):
		//		  do {
		//			guard let data = string.data(using: .utf8) else {
		//			  print("Error decoding streaming event string")
		//			  return
		//			}
		//			let rawEvent = try decoder.decode(RawStreamEvent.self, from: data)
		//			if let event = rawEventToEvent(rawEvent: rawEvent) {
		//			  Task { @MainActor in
		//				self.events.append(event)
		//				self.latestEvent = event
		//				if let event = event as? StreamEventNotification, event.notification.status?.visibility != .direct {
		//				  self.unreadNotificationsCount += 1
		//				}
		//			  }
		//			}
		//		  } catch {
		//			print("Error decoding streaming event: \(error.localizedDescription)")
		//		  }
		//
		//		default:
		//		  break
		//		}
		//
		//		receiveMessage()
		//
		//	  case .failure:
		//		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(retryDelay)) {
		//		  self.retryDelay += 30
		//		  self.stopWatching()
		//		  self.connect()
		//		  self.watch(streams: self.watchedStreams)
		//		}
		//	  }
		//	})
	}

	private func rawEventToEvent(rawEvent: RawStreamEvent) -> (any StreamEvent)? {
		guard let payloadData = rawEvent.payload.data(using: .utf8) else {
			return nil
		}
		do {
			switch rawEvent.event {
			case "update":
				let status = try decoder.decode(Product.self, from: payloadData)
				return StreamEventUpdate(product: status)
			case "status.update":
				let status = try decoder.decode(Product.self, from: payloadData)
				return StreamEventStatusUpdate(product: status)
			case "delete":
				return StreamEventDelete(status: rawEvent.payload)
			case "notification":
				let notification = try decoder.decode(CollarNotification.self, from: payloadData)
				return StreamEventNotification(notification: notification)
			case "conversation":
				let conversation = try decoder.decode(Conversation.self, from: payloadData)
				return StreamEventConversation(conversation: conversation)
			default:
				return nil
			}
		} catch {
			print("Error decoding streaming event to final event: \(error.localizedDescription)")
			print("Raw data: \(rawEvent.payload)")
			return nil
		}
	}

	func emmitDeleteEvent(for status: String) {
		let event = StreamEventDelete(status: status)
		self.events.append(event)
		self.latestEvent = event
	}

	func emmitEditEvent(for status: Product) {
		let event = StreamEventStatusUpdate(product: status)
		self.events.append(event)
		self.latestEvent = event
	}

	func emmitPostEvent(for status: Product) {
		let event = StreamEventUpdate(product: status)
		self.events.append(event)
		self.latestEvent = event
	}
}

