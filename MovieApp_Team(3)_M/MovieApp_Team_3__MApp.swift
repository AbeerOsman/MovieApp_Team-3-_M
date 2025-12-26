//
//  MovieApp_Team_3__MApp.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 03/07/1447 AH.
//

import SwiftUI

@main
struct MovieApp_Team_3__MApp: App {
    var body: some Scene {
        WindowGroup {
            AddReviewView(rating: .constant(3))
                .preferredColorScheme(.dark)
        }
    }
}

