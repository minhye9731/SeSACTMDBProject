//
//  UIButton+Extension.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

@available (iOS 15.0, *)
extension UIButton.Configuration {
    
    static func tutorialStyle() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "TMDB 시작하기"
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = .blue
        configuration.baseBackgroundColor = .white
        configuration.cornerStyle = .capsule
        return configuration
    }
}
