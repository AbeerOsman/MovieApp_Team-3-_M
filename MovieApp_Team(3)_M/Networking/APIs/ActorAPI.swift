//
//  ActorAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//

import Foundation

struct ActorAPI {
    
    static func fetchActors(for movieID: String) async throws -> [ActorFilds] {
        // Fetch movie_actors records
        let data = try await NetworkService.fetch(Endpoints.movieActors(movieID))
        let response = try JSONDecoder().decode(MovieActorsResponse.self, from: data)
        
        // Fetch each actor's details
        var actors: [ActorFilds] = []
        for record in response.records {
            let actorID = record.fields.actor_id
            let actorData = try await NetworkService.fetch(Endpoints.actor(actorID))
            let actorResponse = try JSONDecoder().decode(ActorResponse.self, from: actorData)
            actors.append(actorResponse.fields)
        }
        
        return actors
    }
}
