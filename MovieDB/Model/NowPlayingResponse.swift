//
//  NowPlayingResponse.swift
//  TheMovieDB
//
//  Created by Rahul Nair on 12/03/21.
// 
//

import Foundation

struct NowPlayingResponse: Codable {
    var movies: [Movie]
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}
