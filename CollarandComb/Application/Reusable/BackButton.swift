//
//  BackButton.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/28/23.
//

import SwiftUI

/// #A button that dismisses the current view on the navigation stack.
/// ##A chevron facing left.
struct BackButton: View {

	/// A binding for the presentation mode of the view to be dismissed.
	@Binding var presentationMode: PresentationMode

	var body: some View {
		Button {
			$presentationMode.wrappedValue.dismiss()
		} label: {
			Image(systemName: "chevron.left")
				.font(.title2)
				.foregroundColor(.primary)
		}
		.accessibilityIdentifier("back button")
	}
}

