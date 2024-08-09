//
//  Event.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import Foundation

final class Event: Codable, Identifiable, Hashable, Sendable, Equatable {

	static func == (lhs: Event, rhs: Event) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var id: UUID?
	var title: String
	var date: Date?
	var desc: String?
	var location: String?
	var imageString: String?
	var eventURL: String

	init(id: UUID?, title: String, date: Date?, desc: String?, location: String?, imageString: String?, eventURL: String) {
		self.id = id
		self.title = title
		self.date = date
		self.desc = desc
		self.location = location
		self.imageString = imageString
		self.eventURL = eventURL
	}

	static func placeholder() -> Event {
		.init(id: UUID(),
			  title: "Couples Members Dog Party",
			  date: Date(),
			  desc: "This is the description",
			  location: "Los Angeles", 
			  imageString: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F565408049%2F149919291057%2F1%2Foriginal.20230731-160805?w=512&auto=format%2Ccompress&q=75&sharp=10&rect=0%2C72%2C6560%2C3280&s=00db01ab3844b75cd158beb616b3b208",
			  eventURL: "https://www.eventbrite.com/e/free-dog-event-westworld-scottsdale-indoors-tickets-678300363647?aff=ebdssbdestsearch")
	}

	static func placeholders() -> [Event] {
		[.placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder(),
		 .placeholder(), .placeholder(), .placeholder(), .placeholder(), .placeholder()]
	}
}

extension Event {
	static var sample: [Event] =
	[
		Event(id: UUID(),
				title: "Couples Members Dog Party",
				date: Date(),
			 desc: "This is the description",
			  location: "Los Angeles", imageString: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F565408049%2F149919291057%2F1%2Foriginal.20230731-160805?w=512&auto=format%2Ccompress&q=75&sharp=10&rect=0%2C72%2C6560%2C3280&s=00db01ab3844b75cd158beb616b3b208", eventURL: "https://www.eventbrite.com/e/free-dog-event-westworld-scottsdale-indoors-tickets-678300363647?aff=ebdssbdestsearch"),

		Event(id: UUID(),
				title: "Dog Pool Party",
				date: Date(),
			 desc: "This is the description",
			  location: "Los Angeles", imageString: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F510826809%2F215884836029%2F1%2Foriginal.20210630-162246?w=512&auto=format%2Ccompress&q=75&sharp=10&rect=147%2C0%2C2100%2C1050&s=9db46a6f012fca41a487165bc1ec4988", eventURL: "https://www.eventbrite.com/e/free-dog-event-westworld-scottsdale-indoors-tickets-678300363647?aff=ebdssbdestsearch"),
	]
}
