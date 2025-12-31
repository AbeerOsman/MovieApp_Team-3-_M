//
//  MovieApp_Team_3__MApp.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 03/07/1447 AH.
//

import SwiftUI

@main
struct MovieApp: App {
    @StateObject var sessionManager = SessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            if sessionManager.isLoggedIn {
                MoviesCenterView()
                    .environmentObject(sessionManager)
                    .preferredColorScheme(.dark)
            } else {
                SigninView()
                    .environmentObject(sessionManager)
                    .preferredColorScheme(.dark)
            }
        }
    }
}

