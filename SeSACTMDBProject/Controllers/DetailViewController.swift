//
//  DetailViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/4/22.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi()
        
        
    }
    
    // MARK: - Navi 설정
        func configureNavi() {
            self.navigationItem.title = "출연/제작"
            
            self.navigationController?.navigationBar.tintColor = .black
            
            let navibarAppearance = UINavigationBarAppearance()

            navibarAppearance.backgroundColor = .white
            navibarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 20)]
            navibarAppearance.shadowColor = .gray
            
            self.navigationItem.scrollEdgeAppearance = navibarAppearance
            self.navigationItem.standardAppearance = navibarAppearance
            
        }


    

}
