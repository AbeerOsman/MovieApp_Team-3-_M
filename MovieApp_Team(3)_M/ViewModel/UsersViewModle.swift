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
        isLoading = true
        errorMessage = nil

        do {
            let endpoint = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/recPMaNVKM6yYZFIl"

            guard let url = URL(string: endpoint) else {
                //throw UsersError.invalidURL
            }

            var request = URLRequest(url: url)
            request.setValue(
                "Bearer \(APIKey.airtable)",
                forHTTPHeaderField: "Authorization"
            )

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
               // throw UsersError.invalidResponse
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(UserRecord.self, from: data)

            self.userRecord = result

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
