//
//  SigninViewModel.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 07/07/1447 AH.
//

import Foundation
import Combine

@MainActor
class SigninViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func signIn() async {
        errorMessage = nil
        
        guard isValidEmail else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        guard isValidPassword else {
            errorMessage = "Please enter your password"
            return
        }
        
        await login()
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    private func login() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await fetchUsers()
            
            // Find user by email
            guard let userRecord = response.records.first(where: {
                $0.fields.email?.lowercased() == email.lowercased()
            }) else {
                errorMessage = SigninError.userNotFound.errorMessage
                return
            }
            
            // Check password
            guard userRecord.fields.password == password else {
                errorMessage = SigninError.invalidPassword.errorMessage
                return
            }
            
            // Save to SessionManager with the Airtable record ID
            SessionManager.shared.saveUserSession(
                userRecord.fields,
                recordId: userRecord.id
            )
            
            // Clear form
            email = ""
            password = ""
            
        } catch {
            errorMessage = error.localizedDescription
            print("Login error:", error)
        }
    }
    
    private func fetchUsers() async throws -> UsersResponse {
        return try await UserAPI.fetchUsers()
    }
    
    private func saveSession(for user: UserInfo) {
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.name ?? "User", forKey: "userName")
        UserDefaults.standard.set(user.profileImage ?? "", forKey: "userProfileImage")
    }
    
        private var isValidEmail: Bool {
            let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
        }
        
        private var isValidPassword: Bool {
            !password.isEmpty
    }
}

