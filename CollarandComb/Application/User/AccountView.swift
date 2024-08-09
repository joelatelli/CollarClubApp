//
//  AccountView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/8/23.
//

import ComposableArchitecture
import SwiftUI
import Combine
import CodeScanner
import CoreImage.CIFilterBuiltins

struct AccountView: View {
	let store: StoreOf<AccountFeature>

	@Environment(\.colorScheme) private var colorScheme
	@EnvironmentObject private var userVM: UserViewModel
	@EnvironmentObject var cartManager: CartManager

	let context = CIContext()
	let filter = CIFilter.qrCodeGenerator()

	@State private var showingSheet = false
	@State private var showSavedView = false
	@State private var showHistoryView = false
	@State private var isShowingScanner = false

	@State private var name = "Anonymous"
	@State private var emailAddress = "you@yoursite.com"
	@State private var initials = "C&F"

	private struct ViewState: Equatable {
		let isRefreshActionInProgress: Bool
		let areSavedProductsFetched: Bool
		let areHisoryProductsFetched: Bool

		init(state: AccountFeature.State) {
			isRefreshActionInProgress = state.isRefreshActionInProgress
			areSavedProductsFetched = !state.savedProductList.isEmpty
			areHisoryProductsFetched = !state.orderProductList.isEmpty
		}
	}

	var body: some View {
		WithViewStore(store, observe: ViewState.init) { viewStore in
			personTodos
		}
	}

	private var personTodos: some View {
		NavigationView {
			WithViewStore(store, observe: ViewState.init) { viewStore in
				ZStack {
					BigGradient()
						.ignoresSafeArea()
					
					ScrollView {
						VStack {

//							SmallMediaCover(imageURL: "https://firebasestorage.googleapis.com/v0/b/kaizen-b2bfb.appspot.com/o/posts%2FIMG_0986.jpeg?alt=media&token=3e4b6ff5-32e1-49af-89e4-7a0b1b75da87")
//								.padding(.top, 30)
////								.padding(.trailing, 20)

							Spacer()
								.frame(height: 30)

							ZStack {
							   Circle()
								   .fill(Color.gold_color) // Change the color as desired
								   .frame(width: 100, height: 100)

								ModTextView(text: initials, type: .h4, lineLimit: 2).foregroundColor(Color.text_primary_color)

							}

							VStack(alignment: .center) {
								ModTextView(text: "\(userVM.me.firstName) \(userVM.me.lastName)", type: .h5, lineLimit: 2).foregroundColor(Color.text_primary_color)

								HStack {
									ModTextView(text: "Single Membership", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)
								}
								.padding(5)
								.background(Color.gold_color)
								.cornerRadius(4)

							}
							.padding(.bottom, 60)

							Button {
								showingSheet.toggle()
							} label: {
								HStack {
									Image(systemName: "qrcode")
										.font(Font.system(size: 30, weight: .light))
										.padding(.trailing, 20)
										.foregroundColor(.gold_color)

									ModTextView(text: "View My QR Code", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)

									Spacer()

									Image(systemName: "arrow.right")
										.font(Font.system(size: 30, weight: .ultraLight))
								}
							}
							.padding(.bottom, 20)
							.buttonStyle(.plain)

							Button {
								isShowingScanner = true
							} label: {
								HStack {
									Image(systemName: "qrcode.viewfinder")
										.font(Font.system(size: 30, weight: .light))
										.padding(.trailing, 20)
										.foregroundColor(.gold_color)

									ModTextView(text: "Scan QR Code", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)

									Spacer()

									Image(systemName: "arrow.right")
										.font(Font.system(size: 30, weight: .ultraLight))
								}
							}
							.padding(.bottom, 40)
							.buttonStyle(.plain)

//							if userVM.me.isAdmin {
//								HStack {
//									Image(systemName: "tray")
//										.font(Font.system(size: 30, weight: .light))
//										.padding(.trailing, 20)
//										.foregroundColor(.gold_color)
//
//									ModTextView(text: "View Orders", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)
//
//									Spacer()
//
//									Image(systemName: "arrow.right")
//										.font(Font.system(size: 30, weight: .ultraLight))
//								}
//								.padding(.bottom, 20)
//							}

							userSavedNavLink

							userHistoryNavLink

							NavigationLink("View Orders", destination: OrdersView(cartManager: cartManager))

//							HStack {
//								Image(systemName: "phone")
//									.font(Font.system(size: 30, weight: .light))
//									.padding(.trailing, 20)
//									.foregroundColor(.gold_color)
//
//								ModTextView(text: "Contact Collar and Foam", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)
//
//								Spacer()
//
//								Image(systemName: "arrow.right")
//									.font(Font.system(size: 30, weight: .ultraLight))
//							}
//							.padding(.bottom, 20)
//
//							
//
//							HStack {
//								Image(systemName: "person.crop.square")
//									.font(Font.system(size: 30, weight: .light))
//									.padding(.trailing, 20)
//									.foregroundColor(.gold_color)
//
//								ModTextView(text: "View Membership Status", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)
//
//								Spacer()
//
//								Image(systemName: "arrow.right")
//									.font(Font.system(size: 30, weight: .ultraLight))
//							}

//							List(cartManager.orders, id: \.id) { order in
//								Text(order.id?.uuidString ?? "YOOOOOOOO")
//							}


							Spacer()

						}
						.padding(.horizontal, 10)
					}
				}
				.navigationTitle("Account")
				.navigationBarTitleDisplayMode(.inline)
				.toolbarBackground(Color.gold_color, for: .navigationBar)
				.toolbar(content: toolbar)
				.sheet(isPresented: $showingSheet) {
					SheetView(image: generateQRCode(from: userVM.me.id!.uuidString))
				}
				.sheet(isPresented: $isShowingScanner) {
					CodeScannerView(codeTypes: [.qr], simulatedData: "Joel Muflam\njoelmuflam@gmail.com.com", completion: handleScan)
				}
				.task {
					viewStore.send(.onAppear(userVM.me.id!.uuidString))
					print("COUNTT: \(cartManager.orders.count)")
				}
				.onAppear {
					cartManager.connectWebSocket()
					initials = getInitials(firstName: userVM.me.firstName, lastName: userVM.me.lastName ?? "")
					print("COUNTT: \(cartManager.orders.count)")
				}
			}
		}
	}

	private func getInitials(firstName: String, lastName: String) -> String {
			let firstInitial = firstName.prefix(1)
			let lastInitial = lastName.prefix(1)
			return "\(firstInitial)\(lastInitial)"
		}

	func generateQRCode(from string: String) -> UIImage {
		filter.message = Data(string.utf8)

		if let outputImage = filter.outputImage {
			if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
				return UIImage(cgImage: cgimg)
			}
		}

		return UIImage(systemName: "xmark.circle") ?? UIImage()
	}

	func handleScan(result: Result<ScanResult, ScanError>) {
	   isShowingScanner = false

		switch result {
		case .success(let result):
			let details = result.string.components(separatedBy: "\n")

		case .failure(let error):
			print("Scanning failed: \(error.localizedDescription)")
		}
	}
}

struct SheetView: View {
	@Environment(\.dismiss) var dismiss

	let image: UIImage

	var body: some View {
		ZStack{
			Color.primary_color.edgesIgnoringSafeArea(.all)

			VStack(alignment: .center, spacing: 5) {
				Image(uiImage: image)
					.interpolation(.none)
					.resizable()
					.scaledToFit()
					.frame(width: 300, height: 300)
//				Button("Press to dismiss") {
//					dismiss()
//				}
//				.font(.body)
//				.padding()
//				.background(.black)
			}
		}
	}
}

// MARK: - User Saved
extension AccountView {
	private var userSavedNavLink: some View {
		NavigationLink(isActive: $showSavedView) {
			userSaved
		} label: {
//			ZStack(alignment: .bottomLeading) {
//				RoundedRectangle(cornerRadius: 6)
//					.fill(
//						LinearGradient(
//							colors: [.purple, .blue],
//							startPoint: .bottomLeading,
//							endPoint: .top
//						)
//					)
//					.overlay {
//						Image(systemName: "person.3.fill")
//							.resizable()
//							.scaledToFit()
//							.foregroundColor(.white)
//							.frame(width: 60, height: 60)
//					}
//
//				VStack(alignment: .leading, spacing: 0) {
//					Text("Most")
//					Text("Followed")
//				}
//				.foregroundColor(.white)
//				.multilineTextAlignment(.leading)
//				.font(.headline)
//				.padding(.bottom, 10)
//				.padding(.leading, 10)
//			}
//			.frame(height: 170)
			HStack {
				Image(systemName: "bookmark")
					.font(Font.system(size: 34, weight: .light))
					.padding(.trailing, 20)
					.foregroundColor(.gold_color)

				ModTextView(text: "Favorite List", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)

				Spacer()

				Image(systemName: "arrow.right")
					.font(Font.system(size: 30, weight: .ultraLight))
			}
			.padding(.bottom, 20)
		}
	}

	private var userSaved: some View {
		VStack {
			Text("Saved")
				.font(.caption2)
				.frame(height: 0)
				.foregroundColor(.clear)

			ScrollView {
				VStack {
					WithViewStore(store, observe: ViewState.init) { viewStore in
						if viewStore.areSavedProductsFetched {
							ForEachStore(
								self.store.scope(
									state: \.savedProductList,
									action: AccountFeature.Action.productRowAction
								)
							) {
								ProductRow(store: $0)
							}

						} else {
							VStack(alignment: .center) {
								ModTextView(text: "Your saved list is empty", type: .body_1)
									.foregroundColor(.gold_color)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Saved Products")
		.navigationBarBackButtonHidden(false)
		.navigationBarTitleDisplayMode(.large)
//		.toolbar {
//			toolbar { showSavedView = false }
//		}
		.onAppear {
//			ViewStore(store).send(.onAppearMostFollewedManga)
		}
	}
}


// MARK: - User Saved
extension AccountView {
	private var userHistoryNavLink: some View {
		NavigationLink(isActive: $showHistoryView) {
			userHistory
		} label: {
//			ZStack(alignment: .bottomLeading) {
//				RoundedRectangle(cornerRadius: 6)
//					.fill(
//						LinearGradient(
//							colors: [.purple, .blue],
//							startPoint: .bottomLeading,
//							endPoint: .top
//						)
//					)
//					.overlay {
//						Image(systemName: "person.3.fill")
//							.resizable()
//							.scaledToFit()
//							.foregroundColor(.white)
//							.frame(width: 60, height: 60)
//					}
//
//				VStack(alignment: .leading, spacing: 0) {
//					Text("Most")
//					Text("Followed")
//				}
//				.foregroundColor(.white)
//				.multilineTextAlignment(.leading)
//				.font(.headline)
//				.padding(.bottom, 10)
//				.padding(.leading, 10)
//			}
//			.frame(height: 170)
			HStack {
				Image(systemName: "timer")
					.font(Font.system(size: 30, weight: .light))
					.padding(.trailing, 20)
					.foregroundColor(.gold_color)

				ModTextView(text: "Order History", type: .subtitle_2B, lineLimit: 2).foregroundColor(Color.text_primary_color)

				Spacer()

				Image(systemName: "arrow.right")
					.font(Font.system(size: 30, weight: .ultraLight))
			}
			.padding(.bottom, 20)
		}
	}

	private var userHistory: some View {
		VStack {
			Text("History")
				.font(.caption2)
				.frame(height: 0)
				.foregroundColor(.clear)

			ScrollView {
				VStack {
					WithViewStore(store, observe: ViewState.init) { viewStore in
						if viewStore.areHisoryProductsFetched {
							ForEachStore(
								self.store.scope(
									state: \.productList,
									action: AccountFeature.Action.productRowAction
								)
							) {
								ProductRow(store: $0)
							}
						} else {
							VStack {
								ModTextView(text: "Your order history is empty", type: .body_1)
									.foregroundColor(.gold_color)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Order History")
		.navigationBarBackButtonHidden(false)
		.navigationBarTitleDisplayMode(.large)
//		.toolbar {
//			toolbar { showHistoryView = false }
//		}
		.onAppear {
//			ViewStore(store).send(.onAppearMostFollewedManga)
		}
	}
}

extension AccountView {
	private func toolbar() -> some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			WithViewStore(store) { viewStore in
				HStack(spacing: 6) {
					Image(systemName: "rectangle.portrait.and.arrow.right")
						.foregroundColor(.text_primary_color)
						.frame(minWidth: 20)
						.contentShape(Rectangle())
						.padding(6)
						.onTapGesture {
							AuthService.shared.token = nil
						}
				}
			}
		}
	}
}

struct OrdersView: View {
	@ObservedObject var cartManager: CartManager

	var body: some View {
		ScrollView {
			ForEach(cartManager.orders, id: \.id) { order in
				OrderCartRowView(order: order)
			}
		}
	}
}
