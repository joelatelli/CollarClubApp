//
//  LoginView.swift
//  CollarandComb
//
//  Created by Joel Muflam on 8/14/23.
//

import SwiftUI
//import Introspect

struct LoginView: View {
	@StateObject var viewModel = UserViewModel()

	@Binding var isSignedIn: Bool

	@State var emailAddress:String = ""
	@State var password: String = ""
	@State private var showHidePass = false
	@State private var message:String = ""
	@State private var error:Bool = false
	@State private var userLogin:Bool = false

	var body: some View {
		VStack {
			Spacer()
			VStack(alignment: .leading, spacing: 30){
				VStack(alignment: .leading, spacing: 10){
					Text("Email Address").font(.system(size: 16)).foregroundColor(Color.text_primary_color)
						.accessibilityIdentifier("userNameLabel")

					TextField("Email Address", text: self.$emailAddress)
						.accessibilityIdentifier("userNameText")
						.colorMultiply(Color.black)
						.keyboardType(.default)
						.padding(.horizontal, 15)
						.padding([.top,.bottom], 15)
						.background(Color.secondary_color)
						.cornerRadius(6)

				}

				VStack(alignment: .leading, spacing: 10){

					Text("Password").font(.system(size: 16)).foregroundColor(Color.text_primary_color)
						.accessibilityIdentifier("passwordLabel")
					HStack{
						if showHidePass{
							TextField("Password", text: self.$password)
								.accessibilityIdentifier("passwordText")
								.keyboardType(.default)

						} else {
							SecureField("Password", text: $password)
								.accessibilityIdentifier("securepasswordText")
								.keyboardType(.default)
						}

						Button(action: {
							self.showHidePass.toggle()
						}) {
							Image(systemName: showHidePass ? "eye.slash" : "eye")
								.resizable()
								.renderingMode(.template)
								.frame(width: 20, height: 15)
								.foregroundColor(Color.gray.opacity(0.75))
						}
						.accessibilityIdentifier("passwordShowHide")
					}

					.padding(.horizontal, 15)
					.padding([.top,.bottom], 15)
					.background(Color.secondary_color)
					.cornerRadius(6)
				}

				Button(action: {
					print("LOGINNNN")
					Auth().login(email: emailAddress, password: password) { result in
						switch result {
						case .success:
							DispatchQueue.main.async {
								self.isSignedIn = true
							}
						case .failure:
							let message = "Could not login. Check your credentials and try again"
						}
					}
				}) {
					HStack{
						Spacer()
						Text("Login").font(.system(size: 18)).foregroundColor(Color.white)
						Spacer()
						Image(systemName: "arrow.right")
							.resizable()
							.frame(width: 15, height: 15)
							.foregroundColor(Color.white)
					}
					.padding(.horizontal, 20)
				}
				.accessibilityIdentifier("loginButton")
				.padding([.top, .bottom], 12)
				.background(Color.gold_color)
				.cornerRadius(5)
				.buttonStyle(.plain)

			}
			.alert(isPresented: $error) {
				Alert(title: Text("User Login Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
			}
			.padding([.leading,.trailing],15)

			Spacer()


		}
		.fullScreenCover(isPresented: self.$userLogin, content: {
			EmptyView()
		})
		.background(Color("F8F8F8"))
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden(true)

	}
}

extension  UITextView {
	@objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
		self.resignFirstResponder()
	}
}


struct SignInView: View {

	/// The view model that manages this view.
	/// An instance of `SignInViewModel`
	@StateObject var viewModel = SignInViewModel()
	@Binding var isSignedIn: Bool

	@State var answer = false
	@State var check = false

	@State var color = Color.secondary_color
	@State var username = ""
	@State var password = ""
	@State var visible = false
//	@Binding var show: Bool
	@State var alert = false
	@State var error = ""

	@State private var showSheet = false

	var body: some View {
		ZStack(alignment: .topTrailing) {

			Color.primary_color.edgesIgnoringSafeArea(.all)
				.ignoresSafeArea()

			GeometryReader {_ in

				VStack {

					HStack {
						Spacer()

						//Register button
						Button(action: {

//							NavigationLink("Don't have an account?", destination: SignUpView(isSignedIn: $isSignedIn))
//								.font(.subheadline.bold())

							self.showSheet.toggle()


//							self.show.toggle()
						}) {
							ModTextView(text: "register" , type: .subtitle_2, lineLimit: 1)
								.foregroundColor(Color.gold_color)

						}
					}
					Spacer()


					//					VStack(alignment: .leading, spacing: 6) {
					//						//Sign In Logo
					//						ModTextView(text: "kaizen." , type: .h1, lineLimit: 2)
					//							.foregroundColor(Color.text_primary_color)
					//							.padding(.bottom, 10)
					//							.padding(.top, 60)
					//
					//						ModTextView(text: "season zero." , type: .h3, lineLimit: 2)
					//							.foregroundColor(Color.text_primary_color)
					//							.padding(.bottom, 10)
					//					}

					//					Image("Splash Logo")
					//						.resizable()
					//						.renderingMode(.original)
					//						.aspectRatio(contentMode: .fit)
					//						.frame(width: 240, height: 240, alignment: .center)
					//						.padding(.top, 60)

					VStack(alignment: .leading, spacing: 6) {

						//Sign In Logo

						ModTextView(text: "The Collar Club" , type: .h3, lineLimit: 2)
							.foregroundColor(Color.text_primary_color)
							.padding(.bottom, 30)

						//Sign welcome text

						//						ModTextView(text: "welcome to kaizen: season zero!" , type: .subtitle_1, lineLimit: 2)
						//							.foregroundColor(Color.text_primary_color)
						//							.padding(.bottom, 10)
						//Sign In boilerplate text
						ModTextView(text: "Sign in to your account." , type: .h6, lineLimit: 2)
							.foregroundColor(Color.text_primary_color)

						//Email input field
						TextField("email address", text: self.$username)
							.font(Font.custom("Barlow", size: 18))
							.foregroundColor(.white)
							.padding(20)
							.foregroundColor(.white)
							.background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" ? Color.gold_color : self.color, lineWidth: 3))
							.padding(.top, 30)
							.preferredColorScheme(.dark)
							.autocapitalization(.none)

						HStack(spacing: 15) {
							VStack {
								if self.visible {
									//Password input field
									TextField("password", text: self.$password)
										.font(Font.custom("Barlow", size: 20))
										.foregroundColor(.white)
										.foregroundColor(.white)
										.preferredColorScheme(.dark)
										.autocapitalization(.none)
								} else  {
									SecureField("password", text: self.$password)
										.font(Font.custom("Barlow", size: 20))
										.foregroundColor(.white)
										.foregroundColor(.white)
										.preferredColorScheme(.dark)
										.autocapitalization(.none)
								}
							}

							//Show password icon
							Button (action: {
								self.visible.toggle()
							}) {
								Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
									.foregroundColor(.white)
							}

						}
						.padding(20)
						.background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.gold_color : self.color, lineWidth: 3))
						.padding(.top, 20)


						//Forget password text
						HStack {
							Spacer()

							Button(action: {
								//								self.resetPassword()
							}) {
								Text("forgot password")
									.font(Font.custom("Barlow", size: 18))
									.foregroundColor(.white)
							}
						}
						.padding(.top, 20)


						Button(action: {
							print("LOGINNNN")
							Auth().login(email: username, password: password) { result in
								switch result {
								case .success:
									DispatchQueue.main.async {
										self.isSignedIn = true
									}
								case .failure:
									let message = "Could not login. Check your credentials and try again"
								}
							}
						}) {
							HStack{
								Spacer()
								Text("Login").font(.system(size: 18)).foregroundColor(Color.white)
								Spacer()
								Image(systemName: "arrow.right")
									.resizable()
									.frame(width: 15, height: 15)
									.foregroundColor(Color.white)
							}
							.padding(.horizontal, 20)
						}
						.accessibilityIdentifier("loginButton")
						.padding([.top, .bottom], 12)
						.background(Color.gold_color)
						.cornerRadius(4)
						.buttonStyle(.plain)
						.padding(.top, 50)
					}
					.padding(.top, 30)

					Spacer()
						.frame(height: 60)
				}
				.padding(.horizontal, 30)
			}
			.sheet(isPresented: $showSheet) {
				SignUpView(isSignedIn: $isSignedIn)
			}
		}


//		if self.alert {
//			ErrorView(alert: self.$alert, error: self.$error)
//		}
	}

	func clear() {
		self.username = ""
		self.password = ""
	}

	func test(value: Int) -> Bool {

				if value == 1 {
					check = false
				} else {
					print("Succes")
					check = true
				}

			return check
		}

}

