//
//  UIViewController+Extension.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/17/22.
//

import UIKit

extension UIViewController {
    
    func setTutorialLabel(label: UILabel, title: String ) {
        label.numberOfLines = 0
        label.alpha = 0
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.text = title
        label.textAlignment = .center
    }
    
    func setSampleScene(imgView: UIImageView, name: String) {
        imgView.image = UIImage(named: name)
        imgView.layer.cornerRadius = 8
        imgView.layer.masksToBounds = true
        imgView.alpha = 0
    }
    
    func setTutorialAnimate(dur: Double, label: UILabel, imgView: UIImageView) {
        UIView.animate(withDuration: dur) {
            label.alpha = 1
            imgView.alpha = 1
        } completion: { _ in }
        
    }
    
}
