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
                                        .frame(width: 41, height: 41)

                                      Image(.profileAvatar)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28.19, height: 31.47)
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

struct HighRatedMovies: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("High Rated")
                .font(.system(size: 22, weight: .semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                //all top reated movies
                HStack(alignment: .center) {
                    //1st movie
                    Image("TopGun")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 355, height: 429)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                        .overlay {
                            ZStack(alignment: .bottomLeading) {

                                LinearGradient(
                                    colors: [.black.opacity(0.4), .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Top Gun")
                                        .font(.system(size: 28, weight: .bold))

                                    HStack {
                                        ForEach(1...5, id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 12))
                                        }
                                    }

                                    HStack {
                                        Text("4.8")
                                            .font(.system(size: 20))
                                        Text("out of 5")
                                            .font(.system(size: 12))
                                    }

                                    Text("Action · 2 hr 9 min")
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                        }
                    //2ed movie
                    Image(.images2)
                        .resizable()
                        //.scaledToFit()
                        .frame(width: 355)
                        .aspectRatio(355 / 429, contentMode: .fill)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                        .overlay {
                            ZStack(alignment: .bottomLeading) {

                                LinearGradient(
                                    colors: [.black.opacity(0.4), .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Top Gun")
                                        .font(.system(size: 28, weight: .bold))

                                    HStack {
                                        ForEach(1...5, id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 12))
                                        }
                                    }

                                    HStack {
                                        Text("4.8")
                                            .font(.system(size: 20))
                                        Text("out of 5")
                                            .font(.system(size: 12))
                                    }

                                    Text("Action · 2 hr 9 min")
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                        }
                }
                
                
            }
        }
        .padding(.horizontal)
        .padding(.top, 24)
    }
}






#Preview {
    MoviesCenterView()
}
