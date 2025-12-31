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
    @Published var isSignedIn = false
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

    func signOut() {
        clearSession()
    }

    private var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    private var isValidPassword: Bool {
        !password.isEmpty
    }

    private func login() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let users = try await fetchUsers()

            guard let user = users.first(where: {
                $0.email.lowercased() == email.lowercased()
            }) else {
                errorMessage = "No account found with this email"
                return
            }

            guard user.password == password else {
                errorMessage = "Invalid password. Please try again"
                return
            }

            isSignedIn = true
            saveSession(for: user)

        } catch {
            errorMessage = error.localizedDescription
            print("Login error:", error)
        }
    }

    private func fetchUsers() async throws -> [UserInfo] {
        let endpoint = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users"

        guard let url = URL(string: endpoint) else {
            throw SigninError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SigninError.invalidResponse
        }

        let result = try JSONDecoder().decode(UsersResponse.self, from: data)
        return result.records.map { $0.fields }
    }

    private func saveSession(for user: UserInfo) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.name ?? "User", forKey: "userName")
        UserDefaults.standard.set(user.profile_image ?? "", forKey: "userProfileImage")
    }

    private func clearSession() {
        email = ""
        password = ""
        isSignedIn = false

        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
    }
}
