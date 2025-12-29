//
//  MoviesDetailsView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//
//
import SwiftUI
struct MoviesDetailsView: View {
    @State private var showNavTitle = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                Moviesposter()
                VStack(alignment: .leading, spacing: 26) {
                    
                    MoviesDetails()
                    
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    Story()
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    Rating()
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    Director()
                    
                    Stars()
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    Reviews()
                    
                    
                    ReviewsScrollView()
                    
                    Reviewbutton()
                }
                .padding(.horizontal)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.backward")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Image(systemName: "square.and.arrow.up")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Image(systemName: "bookmark")                }
            }
            
        }
        .foregroundColor(.yelloww)
    }
}
struct Moviesposter: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("images-3")
                .resizable()
                .scaledToFill()
                .padding(.top,-120)
            LinearGradient(
                colors: [.black.opacity(0.95), .black.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
            
            Text("Movies")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.bottom, 30)
        }
        
    }
}
struct MoviesDetails: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            item(title: "Duration", value: "1h 10m")
            item(title: "Language", value: "English")
            item(title: "Genre", value: "Drama")
            item(title: "Age", value: "13")
        }
        .foregroundColor(.white)
    }
    
    func item(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
    }
}

struct Story: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Story")
                .font(.title2)
                .bold()
            
            Text("Synopsis. In 1947, Andy Dufresne ... sent to the notoriously harsh Shawshank Prison.")
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
}
struct Rating: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("IMDb Rating")
                .font(.title2)
                .bold()
            
            Text("8.6 / 10")
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
}
struct Director: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Director")
                .font(.title2)
                .bold()
            
            Image("images-2")
                .resizable()
                .scaledToFill()
                .frame(width: 76, height: 76)
                .clipShape(Circle())
            
            Text("Christopher Nolan")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
}
struct Stars: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stars")
                .font(.title2)
                .bold()
            
            HStack(spacing: 24) {
                star(name: "Actor 1")
                star(name: "Actor 2")
                star(name: "Actor 3")
            }
        }
        .foregroundColor(.white)
    }
    
    func star(name: String) -> some View {
        VStack(spacing: 6) {
            Image("images-2")
                .resizable()
                .scaledToFill()
                .frame(width: 76, height: 76)
                .clipShape(Circle())
            
            Text(name)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
struct Reviews: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating & Reviews")
                .font(.title2)
                .bold()
            
            Text("4.8 out of 5")
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
}
struct ReviewCard: View {
    @State private var rating = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                Image("images-2")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Afnan Abdullah")
                        .foregroundColor(.white)
                    ReviewModelView(rating: $rating)
                }
                Spacer()
            }
            
            Text("This is an engagingly simple, good-hearted film...")
                .foregroundColor(.white.opacity(0.9))
            
            HStack {
                Spacer()
                Text("Tuesday")
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(width: 305, height: 188)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}
struct ReviewsScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ReviewCard()
                ReviewCard()
                ReviewCard()
                ReviewCard()
            }
            .padding(.horizontal)
        }
    }
}
struct Reviewbutton: View {
    var body: some View {
        Button(action: {
            print("Write a review")})
        {
            HStack {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                Text("Write a review")
                    .font(.title2)
                
                
            }
            .foregroundColor(.yelloww)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yelloww, lineWidth: 2)
            )
        }.padding(.horizontal)
    }
}
#Preview {
    MoviesDetailsView()
}
