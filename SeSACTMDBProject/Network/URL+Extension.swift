//
//  URL+Extension.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import Foundation

extension URL {
    
    static let baseURL = "https://api.themoviedb.org/3/"
    
    // 연산 프로퍼티로도 활용 가능
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }

}
