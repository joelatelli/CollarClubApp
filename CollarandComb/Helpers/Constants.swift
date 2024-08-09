//
//  Constants.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//

import Foundation

enum Constants {
	static let baseURL = "https://caf-vapor-api-c922eaf44828.herokuapp.com/"
	static let nodeBaseURL = "https://node-db-collar-club-9d8f9fa7d4eb.herokuapp.com/api/"

	static let paddingLarge: CGFloat = 40
	static let paddingStandard: CGFloat = 25
	static let paddingSmall: CGFloat = 15
	static let paddingBottomSection: CGFloat = 135

	static let fontXXLarge: CGFloat = 34
	static let fontXLarge: CGFloat = 34
	static let fontLarge: CGFloat = 26
	static let fontMedium: CGFloat = 20
	static let fontSmall: CGFloat = 16
	static let fontXSmall: CGFloat = 14
	static let fontXXSmall: CGFloat = 12

	static let spacingLarge: CGFloat = 20
	static let spacingMedium: CGFloat = 16
	static let spacingSmall: CGFloat = 12

	static let radiusStandard: CGFloat = 10
	static let radiusSmall: CGFloat = 5

	static let opacityLow: Double = 0.85
	static let opacityStandard: Double = 0.7
	static let opacityHigh: Double = 0.5
	static let opacityXHigh: Double = 0.35

	static let pic = "https://firebasestorage.googleapis.com/v0/b/kaizen-b2bfb.appspot.com/o/Screen%20Shot%202022-04-30%20at%207.46.45%20PM.png?alt=media&token=0150a4c7-9e24-4659-8955-a48603aeacaf"

	static let cover = "https://firebasestorage.googleapis.com/v0/b/kaizen-b2bfb.appspot.com/o/challenges%2Fnahil-naseer-xljtGZ2-P3Y-unsplash.jpg?alt=media&token=cc8496c9-1f47-4c34-a55f-8fddd8a34d59"

	static let user = User.placeholder()
}

enum Endpoints {

	// Todo Endpoints
	static let todos = "todos"
	static let activeTodos = "todos/active"
	static let waitingTodos = "todos/waiting"
	static let completedTodos = "todos/completed"
	static let failedTodos = "todos/failed"

	static let buckets = "buckets"
	static let users = "users"
	static let notifications = "notifications"
	static let attachments = "attachments"
	static let staps = "steps"
}

let APP_NAME = "Collar and Foam"
let APP_LINK = "collarandfoam.dog"
let SHARED_FROM_EXPENSO = """
	Shared from \(APP_NAME) App: \(APP_LINK)
	"""

// IMAGE_ICON NAMES
let IMAGE_DELETE_ICON = "delete_icon"
let IMAGE_SHARE_ICON = "share_icon"
let IMAGE_FILTER_ICON = "filter_icon"
let IMAGE_OPTION_ICON = "settings_icon"


// Category tags
let CAREER_TAG = "Career and Work"
let HEALTH_TAG = "Health and Wellness"
let FITNESS_TAG = "Fitness and Sports"
let SPIRITUALITY_TAG = "Spirituality"
let LIVING_ENVIRONMENT_TAG = "Living Environment"
let INTELLECTUAL_TAG = "Intellectual Life"
let CREATIVE_TAG = "Creative Life"
let FAMILY_TAG = "Family Life"
let ROMANTIC_TAG = "Romantic Relationships"
let ADVENTURE_TAG = "Adventures"
let COMMUNITY_TAG = "Community Life"
let FINANCES_TAG = "Finances"
let LEISURE_TAG = "Leisure"
let SOCIAL_TAG = "Social Life"
let NO_TAG = "No Category"

// Transaction types
let TODO_TYPE = "Todo"
let BUCKET_TYPE = "Bucket"

let UD_EXPENSE_CURRENCY = "expenseCurrency"

func getTransTagTitle(transTag: String) -> String {
	switch transTag {
		case CAREER_TAG: return "Career and Work"
		case HEALTH_TAG: return "Health and Wellness"
		case FITNESS_TAG: return "Fitness and Sports"
		case SPIRITUALITY_TAG: return "Spirituality"
		case LIVING_ENVIRONMENT_TAG: return "Living Environment"
		case INTELLECTUAL_TAG: return "Intellectual Life"
		case CREATIVE_TAG: return "Creative Life"
		case FAMILY_TAG: return "Family Life"
		case ROMANTIC_TAG: return "Romantic Relationships"
		case ADVENTURE_TAG: return "Adventures"
		case COMMUNITY_TAG: return "Community Life"
		case FINANCES_TAG: return "Finances"
		case LEISURE_TAG: return "Leisure"
		case SOCIAL_TAG: return "Social Life"
		default: return "No Category"
	}
}

/// #The endpoints for the api resources.
enum API {

	/// The base URL for all API requests.
	static let baseURL  =   URL(string: "https://caf-vapor-api-c922eaf44828.herokuapp.com/")
	static let nodeBaseURL  =   URL(string: "https://node-db-collar-club-9d8f9fa7d4eb.herokuapp.com/api/")

	/// A collection of endpoints for User activity.
	enum User: String {

		/// The endpoint for checking email availability.
		case checkEmail = "users/checkemail/"

		/// The endpoint for signing up a user.
		case signUp = "users/"

		/// The endpoint for signing in a user.
		case signIn = "users/login/"

		/// The endpoint for signing out a user.
		case signOut = "users/signout/"
	}

	/// A collection of endpoints for fetching menu data.
	enum Menu: String {

		/// The endpoint for fetching the menu sections.
		case fetchMenu = "menu/"
	}

	/// A collection of endpoints for Cart operations.
	enum Cart: String {

		/// The endpoint for fetching the contents of the user's cart.
		case fetchContents = "carts/contents/"

		/// The endpoint for adding items to the user's cart.
		case addItem = "carts/add/"

		/// The endpoint for removing items from the user's cart.
		case removeItem = "carts/remove/"
	}

	/// A collection of endpoints for fetching Food details.
	enum Food: String {

		/// The endpoint for fetching the options for the food.
		case fetchOptions = "options/"
	}
}
