//
//  TMDBAPIManager.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/9/22.
//

import Foundation

import Alamofire
import SwiftyJSON


class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    // MARK: - 트렌드 api
    func fetchTVAPI(type: Endpoint, startPage: Int, completionHandler: @escaping(Int, [TMDBModel]) -> ()) {
        
        print(#function)
        
        let url = type.requestURL + "api_key=\(APIKey.BOXOFFICE)&page=\(startPage)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let totalCount = json["total_pages"].intValue
                
                let trendData = json["results"].arrayValue
                
                let trendDataArray: [TMDBModel] = trendData.map { tv -> TMDBModel in
                    
                    let posterImageUrl = tv["poster_path"].stringValue
                    let backdropImageUrl = tv["backdrop_path"].stringValue
                    let releaseDt = tv["first_air_date"].stringValue
                    let rate = tv["vote_average"].doubleValue
                    let programName = tv["name"].stringValue
                    let overview = tv["overview"].stringValue
                    let id = tv["id"].intValue
                    let genreid = tv["genre_ids"][0].intValue
                    
                    return TMDBModel(releaseDt: releaseDt, genreID: genreid, posterImageView: posterImageUrl, backdropImageView: backdropImageUrl, rate: rate, name: programName, overview: overview, id: id)
               }
                
                completionHandler(totalCount, trendDataArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - genre api
    func fetchGenreAPI(type: Endpoint, completionHandler: @escaping(JSON) -> ()) {
        
        print(#function)
        
        let url = type.requestURL + "api_key=\(APIKey.BOXOFFICE)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData {
            response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - cast, crew api
    
    
    
    
    // MARK: - 영상링크 api
    
    
    
    
}



