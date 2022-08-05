//
//  Constant.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/3/22.
//

import Foundation
import UIKit

// MARK: - api 링크관련
struct EndPoint {
    static let tmdbURL = "https://api.themoviedb.org/3/trending/tv/day?"
    
    static let imageURL = "https://image.tmdb.org/t/p/original"
    
    static let memberURL = "https://api.themoviedb.org/3/tv/"
}
    
// MARK: - identifier
protocol ReusableProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol { // extension 저장 프로퍼티 불가능
    
    static var reuseIdentifier: String { // 연산 프로퍼티 get만 사용한다면 get 생략 가능
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


// MARK: - 이미지
enum ImageName: String {
    case hamburgerMenu = "list.dash"
    case magnifyingGlass = "magnifyingglass"
    case clip = "paperclip"
}
