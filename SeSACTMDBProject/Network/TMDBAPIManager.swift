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
    func fetchCreditsAPI(type: Endpoint, tvDataID: Int, completionHandler: @escaping([Cast], [Crew]) -> ()) {
        
        print(#function)
        
        let url = type.requestURL + "\(tvDataID)/credits?api_key=\(APIKey.BOXOFFICE)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let castData = json["cast"].arrayValue
                let crewData = json["crew"].arrayValue
                
                let castDataArray: [Cast] = castData.map { cast -> Cast in
                    
                    let castName = cast["name"].stringValue
                    let castCharacter = cast["character"].stringValue
                    let castProfileURL = cast["profile_path"].stringValue
                    
                    return Cast(name: castName, character: castCharacter, profilePath: castProfileURL)
                }
                
                let crewDataArray: [Crew] = crewData.map { crew -> Crew in
                    
                    let crewName = crew["name"].stringValue
                    let crewProfileURL = crew["profile_path"].stringValue // 없는 경우도 있음
                    let crewDepartment = crew["department"].stringValue
                    let crewJob = crew["job"].stringValue
                    
                    return Crew(name: crewName, profilePath: crewProfileURL, department: crewDepartment, job: crewJob)
                }
                
                completionHandler(castDataArray, crewDataArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 영상링크 api
    
    func fetchVideoAPI(type: Endpoint, tvDataID: Int, completionHandler: @escaping(String) -> ()) {
        
        print(#function)
        
        let url = URL.baseURL + "tv/\(tvDataID)/videos?api_key=\(APIKey.BOXOFFICE)&language=en-US#"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let key = json["results"][0]["key"].stringValue
                let keyURLSting = type.requestURL + key
                
                completionHandler(keyURLSting)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
 
    // MARK: - 유사 tv 프로그램 api
    
    let originTVShowList: [(String, Int)] = [
        ("Ms. Marvel", 92782),
        ("ワンピース", 37854),
        ("Pretty Little Liars: Original Sin", 110531),
        ("The Sandman", 90802),
        ("Game of Thrones", 1399)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function)
        
        let similarURL = URL.baseURL + "tv/\(query)/similar?api_key=\(APIKey.BOXOFFICE)&language=en-US&page=1"
        
        AF.request(similarURL, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)

                print(json)
//                let nameValue = json["results"].arrayValue.map { $0["name"].stringValue }
                let posterValue = json["results"].arrayValue.map { $0["poster_path"].stringValue }
                
                completionHandler(posterValue)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        //        var nameList: [[String]] = []
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: originTVShowList[0].1) { value in
            posterList.append(value)
            
            TMDBAPIManager.shared.callRequest(query: self.originTVShowList[1].1) { value in
                posterList.append(value)
                
                TMDBAPIManager.shared.callRequest(query: self.originTVShowList[2].1) { value in
                    posterList.append(value)
                    
                    TMDBAPIManager.shared.callRequest(query: self.originTVShowList[3].1) { value in
                        posterList.append(value)
                        
                        TMDBAPIManager.shared.callRequest(query: self.originTVShowList[4].1) { value in
                            posterList.append(value)
                            completionHandler(posterList)
                        }
                    }
                }
            }
        }
    }
    
    
    
}



