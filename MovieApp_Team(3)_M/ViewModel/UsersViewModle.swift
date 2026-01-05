//
//  UsersViewModle.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 10/07/1447 AH.
//

import Foundation

import Combine

@MainActor
class UsesViewModel: ObservableObject {
    @Published var user: UserInfo?
    @Published var userRecord: UserRecord?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchUser() async {
        guard let recordId = SessionManager.shared.userRecordId else {
            errorMessage = "No user logged in"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await UserAPI.fetchUser(id: recordId)
            self.userRecord = result
            self.user = result.fields
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch user error:", error)
        }
        
        isLoading = false
    }
}
