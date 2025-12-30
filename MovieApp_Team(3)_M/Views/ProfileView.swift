//
//  ProfileView.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 04/07/1447 AH.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Profile")
                    .font(.system(size: 38, weight: .bold))
                    .padding(.top, 21)
                    .padding(.horizontal)
                
                Divider()
                
                NavigationLink(destination: EditProfileView()) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Image(.profileAvatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.brown)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sarah Abdullah")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Xxxx234@gmail.com")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.15))
                    )
                }
                .padding(.horizontal, 10)
                .padding(.top, 30)
                
                VStack {
                    Text("Saved Movies")
                        .font(.system(size: 26, weight: .bold))
                        .padding(.top, 40)
                        .padding(.horizontal)
                }
                VStack (spacing: 5){
                    Image(.movieismeLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 94, height: 94)
                            .padding(.top, 95)

                        
                        Text("No saved movies yet,start save\n your favourites")
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.yellow)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
