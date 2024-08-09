//
//  SignUpView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/28/23.
//

import SwiftUI
import UIKit

/// #The view that handles user sign-up.
struct SignUpView: View {

	/// The presentation mode used to dismiss this view.
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	/// The view model that manages this view.
	/// An instance of `SignUpViewModel`
	@StateObject var viewModel = SignUpViewModel()

	/// A binding to a boolean that indicates whether the user is signed in or not.
	/// A successful sign-up toggles the value to true.
	@Binding var isSignedIn: Bool

	@State var color = Color.secondary_color


	var body: some View {
		ZStack {
			Color.black.opacity(0.7)
				.ignoresSafeArea()
			LinearGradient(colors: [Color.primary_color, Color.secondary_color], startPoint: .top, endPoint: .bottom)
				.ignoresSafeArea()
//				.opacity(0.7)

			VStack(alignment: .leading) {
				ModTextView(text: "Collar Club" , type: .h3, lineLimit: 2)
					.foregroundColor(Color.text_primary_color)
					.padding(.bottom, 30)

				//Sign welcome text

				//						ModTextView(text: "welcome to kaizen: season zero!" , type: .subtitle_1, lineLimit: 2)
				//							.foregroundColor(Color.text_primary_color)
				//							.padding(.bottom, 10)
				//Sign In boilerplate text
				ModTextView(text: "Sign up for The Collar Club." , type: .h6, lineLimit: 2)
					.foregroundColor(Color.text_primary_color)

//				HStack {
//					Text(viewModel.emailErrorDescription)
//						.font(.caption)
//						.foregroundColor(.red)
//					Spacer()
//				}.padding(.bottom)

				TextField("email address", text: $viewModel.email)
					.font(Font.custom("Barlow", size: 18))
					.foregroundColor(.white)
					.padding(20)
					.foregroundColor(.white)
					.background(RoundedRectangle(cornerRadius: 12).stroke(viewModel.firstName != "" ? Color.gold_color : self.color, lineWidth: 3))
					.padding(.top, 10)
					.preferredColorScheme(.dark)
					.autocapitalization(.none)

				TextField("first name", text: $viewModel.firstName)
					.font(Font.custom("Barlow", size: 18))
					.foregroundColor(.white)
					.padding(20)
					.foregroundColor(.white)
					.background(RoundedRectangle(cornerRadius: 12).stroke(viewModel.firstName != "" ? Color.gold_color : self.color, lineWidth: 3))
					.padding(.top, 10)
					.preferredColorScheme(.dark)
					.autocapitalization(.none)

				TextField("last name", text: $viewModel.lastName)
					.font(Font.custom("Barlow", size: 18))
					.foregroundColor(.white)
					.padding(20)
					.foregroundColor(.white)
					.background(RoundedRectangle(cornerRadius: 12).stroke(viewModel.lastName != "" ? Color.gold_color : self.color, lineWidth: 3))
					.padding(.top, 10)
					.preferredColorScheme(.dark)
					.autocapitalization(.none)


				if !viewModel.isEmailValid {
					VStack(spacing: 0) {
						SecureField("Password", text: $viewModel.password)
							.font(Font.custom("Barlow", size: 18))
							.foregroundColor(.white)
							.padding(20)
							.foregroundColor(.white)
							.background(RoundedRectangle(cornerRadius: 12).stroke(viewModel.firstName != "" ? Color.gold_color : self.color, lineWidth: 3))
							.padding(.top, 10)
							.preferredColorScheme(.dark)
							.autocapitalization(.none)
							.overlayDivider(.bottom)
							.accessibilityIdentifier("password input")

						SecureField("Confirm password", text: $viewModel.repeatedPassword)
							.font(Font.custom("Barlow", size: 18))
							.foregroundColor(.white)
							.padding(20)
							.foregroundColor(.white)
							.background(RoundedRectangle(cornerRadius: 12).stroke(viewModel.firstName != "" ? Color.gold_color : self.color, lineWidth: 3))
							.padding(.top, 10)
							.preferredColorScheme(.dark)
							.autocapitalization(.none)
							.accessibilityIdentifier("repeat password")

						HStack {
							ModTextView(text:viewModel.passwordErrorDescription, type: .body_1, lineLimit: 2)
								.foregroundColor(.red)

							Spacer()
						}.padding(.bottom)

						Spacer()

						Button(action: {
							viewModel.signUp {
								isSignedIn = true
								self.presentationMode.wrappedValue.dismiss()
							}
						}) {
							HStack{
								Spacer()
								Text("Sign Up").font(.system(size: 18)).foregroundColor(Color.white)
								Spacer()
								Image(systemName: "arrow.right")
									.resizable()
									.frame(width: 15, height: 15)
									.foregroundColor(Color.white)
							}
							.padding(.horizontal, 20)
						}
						.accessibilityIdentifier("signUpButton")
						.padding([.top, .bottom], 12)
						.background(Color.gold_color)
						.cornerRadius(4)
						.buttonStyle(.plain)
						.padding(.top, 50)

					}

				}
				Spacer()
			}
			.padding(.top, 48)
			.padding()
			.navigationTitle("Sign up")
			.navigationBarBackButtonHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					BackButton(presentationMode: presentationMode)
				}
			}
		}
	}
}


