//
//  hapticClient.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/15/23.
//

import SwiftUI
import ComposableArchitecture

extension DependencyValues {
	var hapticClient: HapticClient {
		get { self[HapticClient.self] }
		set { self[HapticClient.self] = newValue }
	}
}

struct HapticClient {
	let generateFeedback: (UIImpactFeedbackGenerator.FeedbackStyle) -> EffectTask<Never>
	let generateNotificationFeedback: (UINotificationFeedbackGenerator.FeedbackType) -> EffectTask<Never>
}

extension HapticClient: DependencyKey {
	static let liveValue: HapticClient = .init(
		generateFeedback: { style in
			.fireAndForget {
				HapticUtil.generateFeedback(style: style)
			}
		},
		generateNotificationFeedback: { style in
			.fireAndForget {
				HapticUtil.generateNotificationFeedback(style: style)
			}
		}
	)
}

