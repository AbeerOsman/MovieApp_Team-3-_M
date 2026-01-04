//  EditProfileView.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 04/07/1447 AH.

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isEditing = false
    @State private var editedFirstName = ""
    @State private var editedLastName = ""
    @State private var isSaving = false
    
    private var firstName: String {
        let fullName = sessionManager.currentUser?.name ?? ""
        return fullName.split(separator: " ").first.map(String.init) ?? ""
    }
    
    private var lastName: String {
        let fullName = sessionManager.currentUser?.name ?? ""
        let components = fullName.split(separator: " ")
        return components.dropFirst().joined(separator: " ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 20) {
                
                if let user = sessionManager.currentUser {
                    ZStack {
                        if let profileImage = user.profileImage {
                            AsyncImage(
                                url: URL(string: user.profileImage ??
                                         "https://i.pinimg.com/736x/00/47/00/004700cb81873e839ceaadf9f3c1fb28.jpg")
                            ) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        }
                    }
                    .padding(.top, 38)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 60) {
                            Text("First name")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            
                            if isEditing {
                                TextField("", text: $editedFirstName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            } else {
                                Text(firstName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            
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
                            
                            if isEditing {
                                TextField("", text: $editedLastName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            } else {
                                Text(lastName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(white: 0.15))
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Button(action: {
                        sessionManager.signOut()
                    }) {
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
            }
            
            Spacer()
        }
        .navigationTitle("Profile info")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if isEditing {
                        isEditing = false
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.yellow)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        Task { await saveChanges() }
                    } else {
                        startEditing()
                    }
                }) {
                    if isSaving {
                        ProgressView().tint(.yellow)
                    } else {
                        Text(isEditing ? "Save" : "Edit")
                            .foregroundColor(.yellow)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
        }
    }
    
    func startEditing() {
        isEditing = true
        editedFirstName = firstName
        editedLastName = lastName
    }
    
    func saveChanges() async {
       

        
        guard let recordId = sessionManager.userRecordId else {
            return
        }
        guard let currentuser = sessionManager.currentUser else {
                return
            }
        isSaving = true
        
        let fullName = "\(editedFirstName) \(editedLastName)".trimmingCharacters(in: .whitespaces)

        let user = UserInfo(name: fullName,password: currentuser.password,  email: currentuser.email, profileImage: currentuser.profileImage)
        
        
        do {
            let data = try await NetworkService.updateUser(recordId: recordId, user: user)
            let updated = try JSONDecoder().decode(UserRecord.self, from: data)
            
            sessionManager.currentUser = updated.fields
            UserDefaults.standard.set(fullName, forKey: "userName")
            
            isEditing = false
        } catch {
            print("Error updating profile: \(error)")
        }
        
        isSaving = false
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environmentObject(SessionManager())
            .preferredColorScheme(.dark)
    }
}
