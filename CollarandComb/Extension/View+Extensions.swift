//
//  View.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/15/23.
//

import SwiftUI

extension View {

	/// Overlays a Divider onto the view
	/// - Parameter alignment: The alignment to use when overlaying the divider
	/// - Returns: A new view with the divider overlaid.
	func overlayDivider(_ alignment: Alignment)    ->    some View {
		return self.overlay(Divider(), alignment: alignment)
	}

	/// Overlays a GeometryReader onto the view to read the offset of the view
	/// when the user scrolls or swipes.
	/// - Parameter offsetHandler: A closure that takes a CGRect and returns nothing.
	/// - Returns: A new view with the GeometryReader overlaid.
	func readOffset(_ offsetHandler: @escaping (_ rect: CGRect) -> Void) -> some View {
		return self
			.overlay(
				GeometryReader { geometry in
					Color.clear
						.preference(key: OffsetKey.self, value: geometry.frame(in: .named("ScrollView")))
				}
			)
			.onPreferenceChange(OffsetKey.self) { rect in
				offsetHandler(rect)
			}
	}

	/// Adds a card-like background to a view.
	/// - Returns: A new view with the background set.
	func cardify()    ->    some View {
		return self
			.background(Color(UIColor.systemBackground).overlay(Color.white.opacity(0.2)))
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.shadow(color: .black.opacity(0.5), radius: 3)
	}
}

extension View {
	func onAppCameToForeground(perform action: @escaping () -> Void) -> some View {
		self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
			 action()
		}
	}

	func onAppWentToBackground(perform action: @escaping () -> Void) -> some View {
		self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
			action()
		}
	}

	func shadowedStyle() -> some View {
		self
			.shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
			.shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
	}
}

extension View {
	func redacted(if condition: @autoclosure () -> Bool) -> some View {
		EmptyView()
//		redacted(reason: condition() ? .placeholder : []).shimmering(active: condition())
	}

	func hud(
		isPresented: Binding<Bool>,
		message: String,
		iconName: String? = nil,
		backgroundColor: Color
	) -> some View {
		ZStack(alignment: .top) {
			self

			if isPresented.wrappedValue {
				HUD(message: message, iconName: iconName, backgroundColor: backgroundColor)
					.zIndex(1)
					.transition(.move(edge: .top).combined(with: .opacity))
					.padding(.horizontal)
					.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
						.onEnded { value in
							if value.translation.height < 0 {
								// if swipe up - dismiss HUD
								withAnimation {
									isPresented.wrappedValue = false
								}
							}
						}
					)
			}
		}
	}

	func autoBlur(radius: Double) -> some View {
		blur(radius: radius)
			.allowsHitTesting(radius < 1)
			.animation(.linear(duration: 0.1), value: radius)
	}

	/// Adds an animated shimmering effect to any view, typically to show that
	/// an operation is in progress.
	/// - Parameters:
	///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
	///   - duration: The duration of a shimmer cycle in seconds. Default: `1.5`.
	///   - bounce: Whether to bounce (reverse) the animation back and forth. Defaults to `false`.
	///   - delay:A delay in seconds. Defaults to `0`.
//	@ViewBuilder func shimmering(
//		active: Bool = true, duration: Double = 1.5, bounce: Bool = false, delay: Double = 0
//	) -> some View {
//		if active {
//			modifier(Shimmer(duration: duration, bounce: bounce, delay: delay))
//		} else {
//			self
//		}
//	}
}


