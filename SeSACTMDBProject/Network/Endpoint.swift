//
//  Endpoint.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import Foundation

enum Endpoint {
    
    case trend
    case image
    case genre
    case member
    
    var requestURL: String {
        switch self {
        case .trend:
            return URL.makeEndPointString("trending/tv/day?")
        case .image:
            return "https://image.tmdb.org/t/p/original"
        case .genre:
            return URL.makeEndPointString("genre/tv/list?")
        case .member:
            return URL.makeEndPointString("tv/")
            
        }
    }
}
