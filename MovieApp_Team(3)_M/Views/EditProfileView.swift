//  EditProfileView.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 04/07/1447 AH.

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isEditing = false
    @State private var editedFirstName = ""
    @State private var editedLastName = ""
    @State private var isSaving = false
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var isUploadingImage = false
    
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
                    // Profile Image
                    ZStack {
                        if let imageData = selectedPhotoData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
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
                        
                        if isEditing {
                            Circle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 80, height: 80)
                            
                            PhotosPicker(selection: $selectedPhotoItem,
                                       matching: .images) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    .padding(.top, 38)
                    .onChange(of: selectedPhotoItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                selectedPhotoData = data
                            }
                        }
                    }
                    
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
                        selectedPhotoData = nil
                        selectedPhotoItem = nil
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
                .disabled(isSaving)
            }
        }
    }
    
    func startEditing() {
        isEditing = true
        editedFirstName = firstName
        editedLastName = lastName
        selectedPhotoData = nil
        selectedPhotoItem = nil
    }
    
    func saveChanges() async {
        guard let recordId = sessionManager.userRecordId else {
            return
        }
        guard let currentUser = sessionManager.currentUser else {
            return
        }
        
        isSaving = true
        
        let fullName = "\(editedFirstName) \(editedLastName)".trimmingCharacters(in: .whitespaces)
        
        var imageUrl = currentUser.profileImage ?? ""
        
        if let photoData = selectedPhotoData {
            isUploadingImage = true
            do {
                imageUrl = try await NetworkService.uploadImageToImgur(imageData: photoData)
            } catch {
                print("Error uploading image: \(error)")
                isSaving = false
                isUploadingImage = false
                return
            }
            isUploadingImage = false
        }
        
        let user = UserInfo(
            name: fullName,
            password: currentUser.password,
            email: currentUser.email,
            profileImage: imageUrl
        )
        
        do {
            let data = try await NetworkService.updateUser(recordId: recordId, user: user)
            let updated = try JSONDecoder().decode(UserRecord.self, from: data)
            
            sessionManager.currentUser = updated.fields
            sessionManager.updateUserDefaults(user: updated.fields)
            
            isEditing = false
            selectedPhotoData = nil
            selectedPhotoItem = nil
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
