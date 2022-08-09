//
//  TMDBModel.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/3/22.
//

import Foundation

struct TMDBModel {
    
    let releaseDt: String
    let genreID: Int
    let posterImageView: String
    let backdropImageView: String
    let rate: Double
    let name: String
    let overview: String
    let id: Int
    
}

// MARK: - genre
struct GenreModel {
    
    static let shared = GenreModel()
    
    var genreDB: [Int: String] = [:]
    
    mutating func appendGenreDT(value: String, key: Int) {
        genreDB.updateValue(value, forKey: key)
    }
    
}

// MARK: - MemberResponse
struct Cast: Decodable {
    let name: String
    let character: String
    let profilePath: String?
}

// MARK: - Cast
struct Crew: Decodable {
    let name: String
    let profilePath: String?
    let department: String
    let job: String
}
