//
//  SigninViewModel.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 07/07/1447 AH.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class SigninViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isPasswordInvalid: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func signIn() {
        isPasswordInvalid = false
        errorMessage = ""
        
        guard checkEmail() else {
            errorMessage = "Please enter a valid email address"
            isPasswordInvalid = true
            return
        }
        
        guard checkPassword() else {
            return
        }
        
        Task {
            await login()
        }
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func checkEmail() -> Bool {
        if email.isEmpty {
            return false
        }
        
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailTest.evaluate(with: email)
    }
    
    func checkPassword() -> Bool {
        if password.isEmpty {
            errorMessage = "Please enter your password"
            isPasswordInvalid = true
            return false
        }
        
        return true
    }
    
    func login() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let users = try await getUsers()
            
            // البحث عن المستخدم بالإيميل
            if let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
                // التحقق من كلمة المرور
                if user.password == password {
                    isSignedIn = true
                    saveSession(userInfo: user)
                } else {
                    errorMessage = "Incorrect password. Please try again"
                    isPasswordInvalid = true
                }
            } else {
                errorMessage = "No account found with this email"
                isPasswordInvalid = true
            }
        } catch {
            errorMessage = error.localizedDescription
            isPasswordInvalid = true
            print("Error during login:", error)
        }
    }
    
    // Networking
    private func getUsers() async throws -> [UserInfo] {
        let endpoint = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users"
        
        // Convert string url into URL object
        guard let url = URL(string: endpoint) else {
            throw SigninError.invalidURL
        }
        
        // Create a URLRequest to add the Authorization header
        var request = URLRequest(url: url)
        print("token is: \(APIKey.airtable)")
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        
        // Call network
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SigninError.invalidResponse
        }
        
        // Decode JSON
        let decoder = JSONDecoder()
        let result = try decoder.decode(UsersResponse.self, from: data)
        
        // Return array of UserInfo
        return result.records.map { $0.fields }
    }
    
    func saveSession(userInfo: UserInfo) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(userInfo.name, forKey: "userName")
        UserDefaults.standard.set(userInfo.profile_image, forKey: "userProfileImage")
    }
    
    func signOut() {
        email = ""
        password = ""
        isSignedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
    }
}
