//
//  ContentView.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 03/07/1447 AH.
//

import SwiftUI

struct MoviesCenterView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                VStack{
                      HStack{
                          Text("Movies Center")
                              .font(.system(size: 28, weight: .bold))
                          Spacer()
                                  ZStack{
                                      Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 55, height: 55)

                                      Image(.profileAvatar)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 31)
                                        .foregroundColor(.brown)
                                  }
                              
                          
                      }.padding(.horizontal, 16)
                        .padding(.top, 20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                           .foregroundColor(.gray)

                        TextField("Search for movie name, actors ...", text: $searchText)
                              }
                              .padding(12)
                              .background(Color(.systemGray6))
                              .cornerRadius(12)
                              .padding(.horizontal, 16)
                    
                    Spacer()
                      
                    HighRatedMovies()
                      
                  }
            }
            
        }
    }

}

struct HighRatedMovies : View {
    var body: some View {
        VStack(alignment: .leading){
            
            Text("High Rated")
                .font(.system(size: 22, weight: .semibold))
            //Top Movies
                Image(.images)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 355, height: 429)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                    .overlay {
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                        VStack(alignment: .leading){
                            Text("Top Gun")
                                .font(.system(size: 28, weight: .bold))
                            
                        }
                    }
            }
            
        }
    }





#Preview {
    MoviesCenterView()
}
