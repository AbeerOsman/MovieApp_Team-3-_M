//
//  EditProfileView.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 04/07/1447 AH.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = "Sarah"
    @State private var lastName: String = "Abdullah"
    @State private var showSignOutAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Text("Profile info")
                    .font(.system(size: 20, weight: .bold))
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.yellow)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Edit")
                            .foregroundColor(.yellow)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(.profileAvatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .padding(.top, 38)
                
                VStack(spacing: 0) {
                    HStack(spacing: 60) {
                        Text("First name")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Text(firstName)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(white: 0.15))
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    HStack(spacing: 60) {
                        Text("Last name")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Text(lastName)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(white: 0.15))
                }
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 20)

                Button(action: {}) {
                    Text("Sign Out")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(white: 0.15))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 300)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditProfileView()
        .preferredColorScheme(.dark)
}
