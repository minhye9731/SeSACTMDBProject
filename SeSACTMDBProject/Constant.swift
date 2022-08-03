//
//  Constant.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/3/22.
//

import Foundation
import UIKit

struct EndPoint {
    static let tmdbURL = "https://api.themoviedb.org/3/trending/tv/day?"
    
    static let imageURL = "https://image.tmdb.org/t/p/original"
}

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
