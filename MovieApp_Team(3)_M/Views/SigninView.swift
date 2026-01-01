
//
//  SignInView.swift
//  MovieApp_Team(3)_M

////  SignInView.swift
////  MovieApp_Team(3)_M
////
////  Created by Shaikha Alnashri on 04/07/1447 AH.
////

//
//import SwiftUI
//


import SwiftUI

struct SigninView: View {
    @StateObject private var viewModel = SigninViewModel()
    
    var body: some View {
        
        NavigationStack {
             ZStack {
                Image("SigninBackground")
                    .resizable()
                    .overlay {
                        LinearGradient(
                            colors: [Color.clear, Color.black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sign in")
                                .font(.system(size: 50, weight: .bold))
                            
                            Text("You'll find what you're looking for in the ocean of movies")
                                .font(.system(size: 18))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 320)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("Enter your email", text: $viewModel.email)
                            .padding()
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.9))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .tint(Color(red: 0.953, green: 0.8, blue: 0.31))
                    }
                    .padding(.top, 25)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("Enter your password", text: $viewModel.password)
                                    .foregroundColor(.white)
                            } else {
                                SecureField("Enter your password", text: $viewModel.password)
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                viewModel.togglePasswordVisibility()
                            } label: {
                                Image(systemName: viewModel.isPasswordVisible
                                      ? "eye.slash.fill"
                                      : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.9))
                        .cornerRadius(8)
                        .tint(Color(red: 0.953, green: 0.8, blue: 0.31))
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        Button {
                            Task {
                                await viewModel.signIn()
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign in")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color(red: 0.953, green: 0.8, blue: 0.31))
                        .cornerRadius(8)
                        .padding(.top, 48)
                        .disabled(viewModel.isLoading)
                        
                        Spacer()
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .navigationDestination(isPresented: $viewModel.isSignedIn) {
                MoviesCenterView()
            }
        }
    }
}

#Preview {
    SigninView()
        .preferredColorScheme(.dark)
}

//struct SigninView: View {
//    //@StateObject private var viewModel = SigninViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            ZStack() {
//                Image("SigninBackground")
//                    .resizable()
//                    .overlay {
//                        LinearGradient(colors: [Color.clear, Color.black], startPoint: .top, endPoint: .bottom)
//                    }
//                    .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    
//                    HStack {
//                        VStack (alignment: .leading, spacing: 8) {
//                            Text("Sign in")
//                                .font(.system(size: 50, weight: .bold))
//                            
//                            Text("You'll find what you're looking for in the ocean of movies")
//                                .font(.system(size: 18))
//                                .lineLimit(nil)
//                                .fixedSize(horizontal: false, vertical: true)
//                }
//                        
//                        .padding(.top, 320)
//                        Spacer()
//                        
//                }
//                    
//                    VStack (alignment: .leading, spacing: 8) {
//                        Text("Email")
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.white)
//                        
//                    //    TextField("Enter your email", text: $viewModel.email)
//                            .padding()
//                            .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.9))
//                            .cornerRadius(8)
//                            .foregroundColor(.white)
//                            .autocapitalization(.none)
//                            .tint(Color(red: 0.953, green: 0.8, blue: 0.31))
//                            .keyboardType(.emailAddress)
//                        
//                        
//                }
//                    .padding(.top, 25)
//                    
//                    VStack (alignment: .leading, spacing: 8) {
//                        Text("Password")
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.white)
//                        
//                        HStack {
//                            if viewModel.isPasswordVisible {
//                                TextField("Enter your password", text: $viewModel.password)
//                                    .foregroundColor(.white)
//                            } else {
//                                SecureField("Enter your password", text: $viewModel.password)
//                                    .foregroundColor(.white)
//                            }
//                            
//                            Button(action: {
//                                viewModel.togglePasswordVisibility()
//                            }) {
//                                Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
//                                    .foregroundColor(.gray)
//                                
//                            }
//                        }
//                        .padding()
//                        .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.9))
//                        .cornerRadius(8)
//                        .tint(Color(red: 0.953, green: 0.8, blue: 0.31))
//                    
//                    
//                    if viewModel.isPasswordInvalid {
//                        Text(viewModel.errorMessage)
//                            .font(.system(size: 16))
//                            .foregroundColor(.red)
//                            //.padding(.top, 2)
//                    }
//                }
//                    .padding(.top, 20)
//                  
//                    VStack (alignment: .leading, spacing: 8) {
//                        Button("Sign in") {
//                            viewModel.signIn()
//                        }
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(red: 0.953, green: 0.8, blue: 0.31))
//                            .cornerRadius(8)
//                            .padding(.top, 48)
//                        
//                        Spacer()
//
//                    }
//                }
//                .padding()
//                .foregroundColor(.white)
//            }
//           // .navigationDestination(isPresented: $viewModel.isSignedIn) {
//                MoviesCenterView()
//            }
//        }
//    }
//}
//
//#Preview {
//    SigninView()
//    .preferredColorScheme(.dark)
//}

